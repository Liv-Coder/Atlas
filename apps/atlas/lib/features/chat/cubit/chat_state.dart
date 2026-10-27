import 'package:equatable/equatable.dart';
import '../../../domain/models/agent_provider.dart';
import '../../../domain/models/atlas_mode.dart';
import '../../../domain/models/chat_session.dart';
import '../../../domain/models/workflow_state.dart';

class DeletedSessionSnapshot extends Equatable {
  const DeletedSessionSnapshot({
    required this.session,
    required this.index,
    required this.wasActive,
  });

  final ChatSession session;
  final int index;
  final bool wasActive;

  @override
  List<Object?> get props => [session, index, wasActive];
}

class ChatState extends Equatable {
  const ChatState({
    required this.sessions,
    this.activeSessionId,
    this.selectedAgentIndex = 0,
    this.mode = AtlasMode.plan,
    this.searchQuery = '',
    this.attachedFileName,
    this.isSending = false,
    this.isRecordingVoice = false,
    this.workflow = const AgentWorkflowProgress(),
    this.lastDeleted,
    this.snackbarMessage,
    this.snackbarHasUndo = false,
  });

  final List<ChatSession> sessions;
  final String? activeSessionId;
  final int selectedAgentIndex;
  final AtlasMode mode;
  final String searchQuery;
  final String? attachedFileName;
  final bool isSending;
  final bool isRecordingVoice;
  final AgentWorkflowProgress workflow;
  final DeletedSessionSnapshot? lastDeleted;
  final String? snackbarMessage;
  final bool snackbarHasUndo;

  AgentProviderConfig get activeAgent =>
      AgentProviderConfig.defaults[selectedAgentIndex];

  ChatSession? get activeSession {
    if (activeSessionId == null) return null;
    for (final s in sessions) {
      if (s.id == activeSessionId) return s;
    }
    return null;
  }

  List<ChatSession> filteredByGroup(SessionGroup group) {
    final q = searchQuery.trim().toLowerCase();
    return sessions.where((s) {
      if (s.group != group) return false;
      if (q.isEmpty) return true;
      return s.title.toLowerCase().contains(q);
    }).toList();
  }

  bool get hasAnyFilteredSession {
    return SessionGroup.values.any((g) => filteredByGroup(g).isNotEmpty);
  }

  ChatState copyWith({
    List<ChatSession>? sessions,
    String? Function()? activeSessionId,
    int? selectedAgentIndex,
    AtlasMode? mode,
    String? searchQuery,
    String? Function()? attachedFileName,
    bool? isSending,
    bool? isRecordingVoice,
    AgentWorkflowProgress? workflow,
    DeletedSessionSnapshot? Function()? lastDeleted,
    String? Function()? snackbarMessage,
    bool? snackbarHasUndo,
  }) {
    return ChatState(
      sessions: sessions ?? this.sessions,
      activeSessionId:
          activeSessionId != null ? activeSessionId() : this.activeSessionId,
      selectedAgentIndex: selectedAgentIndex ?? this.selectedAgentIndex,
      mode: mode ?? this.mode,
      searchQuery: searchQuery ?? this.searchQuery,
      attachedFileName:
          attachedFileName != null ? attachedFileName() : this.attachedFileName,
      isSending: isSending ?? this.isSending,
      isRecordingVoice: isRecordingVoice ?? this.isRecordingVoice,
      workflow: workflow ?? this.workflow,
      lastDeleted: lastDeleted != null ? lastDeleted() : this.lastDeleted,
      snackbarMessage:
          snackbarMessage != null ? snackbarMessage() : this.snackbarMessage,
      snackbarHasUndo: snackbarHasUndo ?? this.snackbarHasUndo,
    );
  }

  @override
  List<Object?> get props => [
        sessions,
        activeSessionId,
        selectedAgentIndex,
        mode,
        searchQuery,
        attachedFileName,
        isSending,
        isRecordingVoice,
        workflow,
        lastDeleted,
        snackbarMessage,
        snackbarHasUndo,
      ];
}
