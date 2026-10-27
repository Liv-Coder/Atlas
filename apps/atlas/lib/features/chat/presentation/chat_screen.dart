import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:routing/routing.dart';
import 'package:share_plus/share_plus.dart';
import '../../../domain/models/atlas_mode.dart';
import '../../../domain/models/chat_session.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import 'widgets/agent_picker_sheet.dart';
import 'widgets/agent_workflow_bar.dart';
import 'widgets/agent_workflow_card.dart';
import 'widgets/attach_picker_sheet.dart';
import 'widgets/mode_picker_sheet.dart';
import 'widgets/sessions_drawer.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.atlasColors;
    final settings = context.watch<SettingsCubit>().state;

    return BlocConsumer<ChatCubit, ChatState>(
      listenWhen: (prev, curr) =>
          prev.snackbarMessage != curr.snackbarMessage ||
          prev.activeSession?.messages.length !=
              curr.activeSession?.messages.length,
      listener: (context, state) {
        _scrollToBottom();
        final msg = state.snackbarMessage;
        if (msg != null && msg.isNotEmpty) {
          final cubit = context.read<ChatCubit>();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: colors.text,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                content: Text(
                  msg,
                  style: TextStyle(
                    color: colors.bg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                action: state.snackbarHasUndo
                    ? SnackBarAction(
                        label: 'Undo',
                        textColor: colors.bg,
                        onPressed: cubit.undoDeleteSession,
                      )
                    : null,
              ),
            );
          cubit.clearSnackbar();
        }
      },
      builder: (context, state) {
        final cubit = context.read<ChatCubit>();
        final activeSession = state.activeSession;
        final messages = activeSession?.messages ?? const <ChatMessage>[];

        return Scaffold(
          key: _scaffoldKey,
          drawer: SessionsDrawer(
            onOpenSettings: () => context.push(AtlasRoutes.settings),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: 'Open sessions drawer',
                        onPressed: () =>
                            _scaffoldKey.currentState?.openDrawer(),
                        icon: Icon(
                          LucideIcons.menu,
                          size: 22,
                          color: colors.text2,
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => showModalBottomSheet<void>(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (_) => AgentPickerSheet(
                              selectedIndex: state.selectedAgentIndex,
                              onSelected: cubit.selectAgent,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    state.activeAgent.provider,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: colors.text,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Flexible(
                                  child: Text(
                                    state.activeAgent.model,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: colors.muted,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Icon(
                                  LucideIcons.chevronDown,
                                  size: 16,
                                  color: colors.muted,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'New chat',
                        onPressed: cubit.startNewChat,
                        icon: Icon(
                          LucideIcons.squarePen,
                          size: 21,
                          color: colors.text2,
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Messages Area
                Expanded(
                  child: messages.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                          itemCount:
                              messages.length + (state.isSending ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == messages.length) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  'Atlas is thinking…',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontStyle: FontStyle.italic,
                                    color: colors.muted,
                                  ),
                                ),
                              );
                            }
                            final m = messages[index];
                            return _buildMessageItem(context, m);
                          },
                        ),
                ),

                // Export Chat Row
                if (messages.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 8),
                    child: TextButton.icon(
                      onPressed: () {
                        final text = cubit.buildExportText();
                        if (text != null) {
                          Share.share(text, subject: activeSession?.title);
                        }
                      },
                      icon: Icon(
                        LucideIcons.download,
                        size: 16,
                        color: colors.muted,
                      ),
                      label: Text(
                        'Export chat',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: colors.muted,
                        ),
                      ),
                    ),
                  ),

                // Composer Zone
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.mode == AtlasMode.agent &&
                          settings.showWorkflowProgress)
                        AgentWorkflowBar(
                          workflow: state.workflow,
                          approvalsEnabled: settings.agentApprovals,
                          onApprovalsTap: () =>
                              context.push(AtlasRoutes.settings),
                        ),
                      if (state.attachedFileName != null)
                        Container(
                          margin: const EdgeInsets.only(left: 4, bottom: 8),
                          padding: const EdgeInsets.fromLTRB(11, 7, 8, 7),
                          decoration: BoxDecoration(
                            color: colors.chip,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: colors.hair),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                LucideIcons.paperclip,
                                size: 15,
                                color: colors.text,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                state.attachedFileName!,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: colors.text2,
                                ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: cubit.removeAttachment,
                                child: Icon(
                                  LucideIcons.x,
                                  size: 14,
                                  color: colors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      _buildComposerBox(context, state),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colors = context.atlasColors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 0, 28, 72),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'What should we work on?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
                height: 1.25,
                color: colors.text,
              ),
            ),
            const SizedBox(height: 14),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: Text(
                'Ask anything, or switch to Agent mode — Atlas will turn your goal into a clear workflow with steps, progress and approvals.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.5,
                  height: 1.55,
                  color: colors.muted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem(BuildContext context, ChatMessage m) {
    final colors = context.atlasColors;
    final cubit = context.read<ChatCubit>();

    if (m.role == MessageRole.user) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.82,
          ),
          decoration: BoxDecoration(
            color: colors.userBubble,
            borderRadius: AtlasRadius.bubble,
          ),
          child: Text(
            m.content,
            style: TextStyle(
              fontSize: 15,
              height: 1.55,
              color: colors.userText,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MarkdownBody(
            data: m.content,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              p: TextStyle(
                fontFamily: AtlasTypography.primaryFontFamily,
                fontSize: 15,
                height: 1.65,
                color: colors.text,
              ),
              code: AtlasTypography.mono(color: colors.text),
              codeblockDecoration: BoxDecoration(
                color: colors.surface2,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.hair),
              ),
            ),
          ),
          if (m.bulletItems.isNotEmpty) ...[
            const SizedBox(height: 8),
            for (var i = 0; i < m.bulletItems.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                      child: m.checkedStepIndices.contains(i)
                          ? Text(
                              '✓',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: colors.text,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 8, left: 2),
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: colors.muted,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                    ),
                    Expanded(
                      child: MarkdownBody(
                        data: m.bulletItems[i],
                        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                          p: TextStyle(
                            fontFamily: AtlasTypography.primaryFontFamily,
                            fontSize: 15,
                            height: 1.6,
                            color: colors.text,
                          ),
                          code: AtlasTypography.mono(color: colors.text),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          if (m.isAgentWorkflowCard)
            AgentWorkflowCard(
              message: m,
              onApprove: () => cubit.approveWorkflowMessage(m.id),
              onEditPlan: () {
                cubit.showInfoSnackbar(
                  'Plan is editable — describe what to change',
                );
                _inputFocusNode.requestFocus();
              },
            ),
          if (m.footerNote != null && m.footerNote!.isNotEmpty) ...[
            const SizedBox(height: 10),
            MarkdownBody(
              data: m.footerNote!,
              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                p: TextStyle(
                  fontFamily: AtlasTypography.primaryFontFamily,
                  fontSize: 15,
                  height: 1.65,
                  color: colors.text,
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            m.providerBadge,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: colors.muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComposerBox(BuildContext context, ChatState state) {
    final colors = context.atlasColors;
    final cubit = context.read<ChatCubit>();
    final isAgentMode = state.mode == AtlasMode.agent;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 10, 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AtlasRadius.composer,
        border: Border.all(color: colors.hair2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _inputController,
            focusNode: _inputFocusNode,
            minLines: 1,
            maxLines: 5,
            onChanged: (_) => setState(() {}),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                cubit.sendMessage(value);
                _inputController.clear();
                setState(() {});
              }
            },
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w500,
              color: colors.text,
            ),
            decoration: InputDecoration(
              hintText: state.isRecordingVoice
                  ? 'Listening… speak now'
                  : state.mode.placeholder,
              hintStyle: TextStyle(color: colors.muted),
              border: InputBorder.none,
              isCollapsed: true,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                tooltip: 'Attach a file',
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) => AttachPickerSheet(
                    onAttachSelected: cubit.attachFile,
                  ),
                ),
                icon: Icon(LucideIcons.plus, size: 22, color: colors.text2),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (_) => ModePickerSheet(
                    selectedMode: state.mode,
                    onSelected: cubit.selectMode,
                  ),
                ),
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isAgentMode ? colors.text : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: isAgentMode ? colors.text : colors.hair,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isAgentMode
                              ? const Color(0xFF4ADE80)
                              : colors.muted,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        state.mode.chipLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: isAgentMode ? colors.bg : colors.text2,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        LucideIcons.chevronDown,
                        size: 14,
                        color: isAgentMode
                            ? colors.bg.withValues(alpha: 0.7)
                            : colors.muted,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Voice input',
                onPressed: cubit.triggerVoiceInput,
                icon: Icon(
                  LucideIcons.mic,
                  size: 21,
                  color: state.isRecordingVoice
                      ? const Color(0xFFF87171)
                      : colors.text2,
                ),
              ),
              const SizedBox(width: 4),
               SizedBox(
                width: 36,
                height: 36,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: _inputController.text.trim().isEmpty
                      ? null
                      : () {
                          final text = _inputController.text;
                          _inputController.clear();
                          setState(() {});
                          cubit.sendMessage(text);
                        },
                  style: IconButton.styleFrom(
                    backgroundColor: colors.text,
                    disabledBackgroundColor:
                        colors.text.withValues(alpha: 0.18),
                  ),
                  icon: Icon(
                    LucideIcons.arrowUp,
                    size: 18,
                    color: colors.bg,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
