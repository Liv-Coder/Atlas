import 'dart:async';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage/storage.dart';
import '../../../domain/models/agent_provider.dart';
import '../../../domain/models/atlas_mode.dart';
import '../../../domain/models/chat_session.dart';
import '../../../domain/models/workflow_state.dart';
import '../../../domain/seed/atlas_seed_sessions.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required HiveStorageService storageService,
    required SecureKeyStore secureKeyStore,
  })  : _storage = storageService,
        super(ChatState(sessions: AtlasSeedSessions.buildInitialSessions()));

  final HiveStorageService _storage;
  int _seq = 100;

  void initialize() {
    final stored = _storage.readSessionsJson();
    if (stored.isNotEmpty) {
      final restored = stored.map(ChatSession.fromJson).toList();
      emit(state.copyWith(sessions: restored));
    } else {
      _persistSessions(state.sessions);
    }
  }

  void selectSession(String sessionId) {
    emit(state.copyWith(activeSessionId: () => sessionId));
  }

  void startNewChat() {
    emit(
      state.copyWith(
        activeSessionId: () => null,
        attachedFileName: () => null,
      ),
    );
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void selectAgent(int index) {
    if (index < 0 || index >= AgentProviderConfig.defaults.length) return;
    final agent = AgentProviderConfig.defaults[index];
    emit(
      state.copyWith(
        selectedAgentIndex: index,
        snackbarMessage: () => 'Agent set to ${agent.provider} · ${agent.model}',
        snackbarHasUndo: false,
      ),
    );
  }

  void selectMode(AtlasMode mode) {
    final nextWorkflow = mode == AtlasMode.agent
        ? const AgentWorkflowProgress(
            runState: WorkflowRunState.ready,
            statusLabel: 'Ready',
            goalText: '',
            activeStepIndex: 0,
            completedSteps: 0,
            progressFraction: 0.12,
          )
        : state.workflow;

    emit(state.copyWith(mode: mode, workflow: nextWorkflow));
  }

  void attachFile(String fileName) {
    emit(state.copyWith(attachedFileName: () => fileName));
  }

  void removeAttachment() {
    emit(state.copyWith(attachedFileName: () => null));
  }

  Future<void> triggerVoiceInput() async {
    if (state.isRecordingVoice) return;
    emit(state.copyWith(isRecordingVoice: true));
    await Future<void>.delayed(const Duration(milliseconds: 1600));
    if (!isClosed) {
      emit(state.copyWith(isRecordingVoice: false));
    }
  }

  void togglePinSession(String sessionId) {
    final updated = <ChatSession>[];
    var nowPinned = false;
    for (final s in state.sessions) {
      if (s.id == sessionId) {
        nowPinned = !s.pinned;
        updated.add(
          s.copyWith(
            pinned: nowPinned,
            group: nowPinned ? SessionGroup.pinned : SessionGroup.today,
            timeLabel: nowPinned ? 'Pinned · just now' : 'Today · just now',
          ),
        );
      } else {
        updated.add(s);
      }
    }
    _persistSessions(updated);
    emit(
      state.copyWith(
        sessions: updated,
        snackbarMessage: () => nowPinned ? 'Chat pinned' : 'Chat unpinned',
        snackbarHasUndo: false,
      ),
    );
  }

  void duplicateSession(String sessionId) {
    final index = state.sessions.indexWhere((s) => s.id == sessionId);
    if (index == -1) return;
    final orig = state.sessions[index];
    _seq++;
    final copy = orig.copyWith(
      id: 's$_seq',
      title: '${orig.title} copy',
      timeLabel: 'Today · just now',
      group: orig.pinned ? SessionGroup.pinned : SessionGroup.today,
      messages: List<ChatMessage>.from(orig.messages),
    );
    final updated = List<ChatSession>.from(state.sessions)
      ..insert(index + 1, copy);
    _persistSessions(updated);
    emit(
      state.copyWith(
        sessions: updated,
        snackbarMessage: () => 'Chat duplicated',
        snackbarHasUndo: false,
      ),
    );
  }

  void deleteSession(String sessionId) {
    final index = state.sessions.indexWhere((s) => s.id == sessionId);
    if (index == -1) return;
    final removed = state.sessions[index];
    final wasActive = state.activeSessionId == sessionId;
    final updated = List<ChatSession>.from(state.sessions)..removeAt(index);
    _persistSessions(updated);
    emit(
      state.copyWith(
        sessions: updated,
        activeSessionId: wasActive ? () => null : null,
        lastDeleted: () => DeletedSessionSnapshot(
          session: removed,
          index: index,
          wasActive: wasActive,
        ),
        snackbarMessage: () => 'Chat deleted',
        snackbarHasUndo: true,
      ),
    );
  }

  void undoDeleteSession() {
    final snap = state.lastDeleted;
    if (snap == null) return;
    final updated = List<ChatSession>.from(state.sessions);
    final insertIdx = snap.index.clamp(0, updated.length);
    updated.insert(insertIdx, snap.session);
    _persistSessions(updated);
    emit(
      state.copyWith(
        sessions: updated,
        activeSessionId: snap.wasActive ? () => snap.session.id : null,
        lastDeleted: () => null,
        snackbarMessage: () => null,
        snackbarHasUndo: false,
      ),
    );
  }

  Future<void> sendMessage(String rawInput) async {
    final trimmed = rawInput.trim();
    if (trimmed.isEmpty || state.isSending) return;

    final attachmentNote = state.attachedFileName != null
        ? '\n[Attached: ${state.attachedFileName}]'
        : '';
    final fullUserText = '$trimmed$attachmentNote';

    final sessionsList = List<ChatSession>.from(state.sessions);
    var active = state.activeSession;

    if (active == null) {
      _seq++;
      final title =
          trimmed.length > 34 ? '${trimmed.substring(0, 34)}…' : trimmed;
      active = ChatSession(
        id: 's$_seq',
        title: title,
        timeLabel: 'Today · just now',
        group: SessionGroup.today,
        pinned: false,
        kind: 'live',
        messages: const [],
      );
      sessionsList.insert(0, active);
    }

    _seq++;
    final userMsg = ChatMessage(
      id: 'm$_seq',
      role: MessageRole.user,
      content: fullUserText,
    );

    final updatedActive = active.copyWith(
      messages: [...active.messages, userMsg],
    );
    final activeIdx = sessionsList.indexWhere((s) => s.id == updatedActive.id);
    sessionsList[activeIdx] = updatedActive;

    emit(
      state.copyWith(
        sessions: sessionsList,
        activeSessionId: () => updatedActive.id,
        attachedFileName: () => null,
        isSending: true,
      ),
    );

    if (state.mode == AtlasMode.agent) {
      _runAgentWorkflowStepper(trimmed);
    }

    await Future<void>.delayed(const Duration(milliseconds: 950));
    if (isClosed) return;

    _seq++;
    final reply = _buildReplyMessage(
      id: 'm$_seq',
      prompt: trimmed,
      mode: state.mode,
      providerBadge:
          '${state.activeAgent.provider} · ${state.mode.displayName}',
    );

    final afterReplyList = List<ChatSession>.from(state.sessions);
    final idx = afterReplyList.indexWhere((s) => s.id == updatedActive.id);
    if (idx != -1) {
      final s = afterReplyList[idx];
      afterReplyList[idx] = s.copyWith(messages: [...s.messages, reply]);
    }
    _persistSessions(afterReplyList);

    emit(
      state.copyWith(
        sessions: afterReplyList,
        isSending: false,
      ),
    );
  }

  void _runAgentWorkflowStepper(String goal) {
    final shortGoal =
        goal.length > 64 ? '${goal.substring(0, 64)}…' : goal;
    emit(
      state.copyWith(
        workflow: AgentWorkflowProgress(
          runState: WorkflowRunState.running,
          statusLabel: 'Planning',
          goalText: shortGoal,
          activeStepIndex: 0,
          completedSteps: 0,
          progressFraction: 0.18,
        ),
      ),
    );

    Future<void>.delayed(const Duration(milliseconds: 380), () {
      if (isClosed) return;
      emit(
        state.copyWith(
          workflow: AgentWorkflowProgress(
            runState: WorkflowRunState.running,
            statusLabel: 'Gathering',
            goalText: shortGoal,
            activeStepIndex: 1,
            completedSteps: 1,
            progressFraction: 0.38,
          ),
        ),
      );
    });

    Future<void>.delayed(const Duration(milliseconds: 820), () {
      if (isClosed) return;
      emit(
        state.copyWith(
          workflow: AgentWorkflowProgress(
            runState: WorkflowRunState.awaitingApproval,
            statusLabel: 'Awaiting approval',
            goalText: '$shortGoal — plan ready in chat below.',
            activeStepIndex: 2,
            completedSteps: 2,
            progressFraction: 0.68,
          ),
        ),
      );
    });
  }

  Future<void> approveWorkflowMessage(String messageId) async {
    final active = state.activeSession;
    if (active == null) return;

    final updatedMessages = active.messages.map((m) {
      if (m.id == messageId) {
        return m.copyWith(
          workflowApproved: true,
          workflowStatus: 'Approved · Running',
        );
      }
      return m;
    }).toList();

    _updateActiveSessionMessages(updatedMessages);
    emit(
      state.copyWith(
        workflow: state.workflow.copyWith(
          runState: WorkflowRunState.running,
          statusLabel: 'Verifying',
          activeStepIndex: 3,
          completedSteps: 3,
          progressFraction: 0.88,
        ),
        snackbarMessage: () => 'Workflow approved — executing step 3',
        snackbarHasUndo: false,
      ),
    );

    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (isClosed) return;

    final currentActive = state.activeSession;
    if (currentActive == null) return;

    final completedMessages = currentActive.messages.map((m) {
      if (m.id == messageId) {
        return m.copyWith(
          workflowApproved: true,
          workflowCompleted: true,
          workflowStatus: 'Complete',
        );
      }
      return m;
    }).toList();

    _updateActiveSessionMessages(completedMessages);
    emit(
      state.copyWith(
        workflow: state.workflow.copyWith(
          runState: WorkflowRunState.done,
          statusLabel: 'Complete',
          activeStepIndex: 3,
          completedSteps: 4,
          progressFraction: 1.0,
        ),
        snackbarMessage: () => 'Workflow complete — ready for review',
        snackbarHasUndo: false,
      ),
    );
  }

  void _updateActiveSessionMessages(List<ChatMessage> messages) {
    final active = state.activeSession;
    if (active == null) return;
    final list = List<ChatSession>.from(state.sessions);
    final idx = list.indexWhere((s) => s.id == active.id);
    if (idx == -1) return;
    list[idx] = active.copyWith(messages: messages);
    _persistSessions(list);
    emit(state.copyWith(sessions: list));
  }

  String? buildExportText() {
    final s = state.activeSession;
    if (s == null || s.messages.isEmpty) {
      emit(
        state.copyWith(
          snackbarMessage: () => 'Nothing to export yet',
          snackbarHasUndo: false,
        ),
      );
      return null;
    }
    final buffer = StringBuffer('Atlas — ${s.title}\n\n');
    for (final m in s.messages) {
      if (m.role == MessageRole.user) {
        buffer.writeln('You: ${m.content}\n');
      } else {
        buffer.writeln('Atlas: ${m.content}');
        for (final item in m.bulletItems) {
          buffer.writeln('  • $item');
        }
        if (m.footerNote != null) {
          buffer.writeln(m.footerNote);
        }
        buffer.writeln();
      }
    }
    emit(
      state.copyWith(
        snackbarMessage: () => 'Chat exported',
        snackbarHasUndo: false,
      ),
    );
    return buffer.toString();
  }

  void resetAppData() {
    final seeded = AtlasSeedSessions.buildInitialSessions();
    _storage.clearAll();
    _persistSessions(seeded);
    emit(
      ChatState(
        sessions: seeded,
        activeSessionId: null,
        selectedAgentIndex: state.selectedAgentIndex,
        mode: AtlasMode.plan,
        snackbarMessage: 'App data reset — mode back to Plan',
        snackbarHasUndo: false,
      ),
    );
  }

  void clearSnackbar() {
    emit(state.copyWith(snackbarMessage: () => null, snackbarHasUndo: false));
  }

  void showInfoSnackbar(String message) {
    emit(
      state.copyWith(
        snackbarMessage: () => message,
        snackbarHasUndo: false,
      ),
    );
  }

  ChatMessage _buildReplyMessage({
    required String id,
    required String prompt,
    required AtlasMode mode,
    required String providerBadge,
  }) {
    final t = prompt.toLowerCase();
    if (mode == AtlasMode.agent) {
      return ChatMessage(
        id: id,
        role: MessageRole.assistant,
        content:
            'I turned your goal into a workflow. Review the plan — nothing external runs without your approval.',
        footerNote:
            'You stay in control — pause, edit or stop the workflow at any point.',
        providerBadge: providerBadge,
        isAgentWorkflowCard: true,
        workflowGoal: prompt,
      );
    }

    if (t.contains('hotel') || t.contains('outreach') || t.contains('b2b')) {
      return ChatMessage(
        id: id,
        role: MessageRole.assistant,
        content: 'Hotel outreach ko lagi plan banauchhu:',
        bulletItems: const [
          'Pahile segment: Kathmandu, Lalitpur ra Pokhara ka hotels — F&B volume anusar priority',
          'First message: chhoto intro + WhatsApp catalogue ko 46 products ko link',
          'Bundle offer: cups, food containers ra packaging — hotels le harek hapta line items',
          '3 din pachhi euta follow-up matra, tespachhi tracker ma status update',
        ],
        checkedStepIndices: const {0, 1},
        footerNote:
            'Bhana bhane ma kunai euta hotel ko lagi pahilo message ko draft pani banauchhu.',
        providerBadge: providerBadge,
      );
    }

    if (t.contains('route') || t.contains('hetauda') || t.contains('map')) {
      return ChatMessage(
        id: id,
        role: MessageRole.assistant,
        content: 'Kathmandu → Hetauda bike route:',
        bulletItems: const [
          'Kathmandu → Pharping → Dakshinkali → Sisneri → Kulekhani → Hetauda',
          'Karib **85 km**, 3.5–4.5 ghanta — Sisneri–Kulekhani ukalo ra ghumauro chha',
          'Bihan chadai niskine, Kulekhani ma euta chiya stop',
        ],
        footerNote:
            'Naachghar–Mugling highway route lamo (~200 km) chha tara sajilo chha.',
        providerBadge: providerBadge,
      );
    }

    if (t.contains('price') ||
        t.contains('catalogue') ||
        t.contains('whatsapp')) {
      return ChatMessage(
        id: id,
        role: MessageRole.assistant,
        content: 'Catalogue ko barema:',
        bulletItems: const [
          '46 products sabai WhatsApp Business catalogue ma chhan, photo ra min order qty sahit',
          'Price phone app bata add hunchha — `Catalogue → item → Price`',
          'Meta Business AI agent ON chha ra latest prices bujhchha',
        ],
        footerNote:
            'Kun item ko price change garne ho, naam bhana — steps dinchhu.',
        providerBadge: providerBadge,
      );
    }

    if (t.contains('flutter') || t.contains('atlas') || t.contains('app')) {
      return ChatMessage(
        id: id,
        role: MessageRole.assistant,
        content: 'Atlas (Flutter) ko status:',
        bulletItems: const [
          'Naam ra package fix: **Atlas** · `com.atlas.chat`',
          'Scope: clean chat, drawer, agent sheet, Plan/Chat/Agent with professional workflow, full Settings',
          'Agent workflow: Plan → Gather → Execute → Verify, live progress + approvals',
        ],
        checkedStepIndices: const {0, 1},
        footerNote:
            'Sabai screens tappable chhan — drawer, agent chip, mode chip ra Settings try gara.',
        providerBadge: providerBadge,
      );
    }

    if (mode == AtlasMode.plan) {
      final clip = prompt.length > 60 ? '${prompt.substring(0, 60)}…' : prompt;
      return ChatMessage(
        id: id,
        role: MessageRole.assistant,
        content: 'Plan mode ma, pahile steps banauchhu:',
        bulletItems: [
          'Timro message bujhye: **“$clip”**',
          'Goal ra chahine inputs chhuttyauchhu',
          'Step-by-step plan banayera, timro approval pachhi matra execute garchhu',
        ],
        checkedStepIndices: const {0, 1},
        footerNote:
            'Plan thik chha bhane **“go”** lekha, ma pahilo step bata suru garchhu.',
        providerBadge: providerBadge,
      );
    }

    final clip = prompt.length > 70 ? '${prompt.substring(0, 70)}…' : prompt;
    return ChatMessage(
      id: id,
      role: MessageRole.assistant,
      content: 'Hajur — bujhye. **“$clip”** ko barema ma maddat garna sakchhu.',
      footerNote:
          'Ali detail dinus — kasko lagi, kahile samma, ra budget jasto kei chha bhane — ma spashta answer dinchhu.',
      providerBadge: providerBadge,
    );
  }

  void _persistSessions(List<ChatSession> sessions) {
    _storage.writeSessionsJson(sessions.map((s) => s.toJson()).toList());
  }
}
