import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../domain/models/chat_session.dart';
import '../../cubit/chat_cubit.dart';
import '../../cubit/chat_state.dart';

class SessionsDrawer extends StatelessWidget {
  const SessionsDrawer({
    super.key,
    required this.onOpenSettings,
  });

  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final colors = context.atlasColors;
    return Drawer(
      width: 322,
      backgroundColor: colors.bg2,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            final cubit = context.read<ChatCubit>();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 10, 12),
                  child: Row(
                    children: [
                      const AtlasLogoMark(size: 38, borderRadius: 11),
                      const SizedBox(width: 11),
                      Text(
                        'Atlas',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: colors.text,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(LucideIcons.x, size: 20, color: colors.text2),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 2, 14, 10),
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: colors.surface2,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(LucideIcons.search, size: 18, color: colors.muted),
                        const SizedBox(width: 9),
                        Expanded(
                          child: TextField(
                            onChanged: cubit.updateSearchQuery,
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              color: colors.text,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search chats',
                              hintStyle: TextStyle(color: colors.muted),
                              border: InputBorder.none,
                              isCollapsed: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        cubit.startNewChat();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.text,
                        foregroundColor: colors.bg,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(LucideIcons.plus, size: 20),
                      label: const Text(
                        'New chat',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: state.hasAnyFilteredSession
                      ? ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          children: [
                            for (final group in SessionGroup.values)
                              ..._buildGroupSection(
                                context,
                                group,
                                state.filteredByGroup(group),
                                state.activeSessionId,
                              ),
                          ],
                        )
                      : Center(
                          child: Text(
                            'No chats match your search.',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: colors.muted,
                            ),
                          ),
                        ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 8, 12),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: colors.hair)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: colors.text,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'D',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: colors.bg,
                          ),
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'D',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                color: colors.text,
                              ),
                            ),
                            Text(
                              'shresthabibidhsuppliers@gmail.com',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: colors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Open settings',
                        onPressed: () {
                          Navigator.of(context).pop();
                          onOpenSettings();
                        },
                        icon: Icon(
                          LucideIcons.settings,
                          size: 20,
                          color: colors.text2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildGroupSection(
    BuildContext context,
    SessionGroup group,
    List<ChatSession> items,
    String? activeId,
  ) {
    if (items.isEmpty) return const [];
    final colors = context.atlasColors;
    final cubit = context.read<ChatCubit>();

    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 14, 10, 6),
        child: Row(
          children: [
            if (group == SessionGroup.pinned) ...[
              Icon(LucideIcons.pin, size: 13, color: colors.muted),
              const SizedBox(width: 6),
            ],
            Text(
              group.heading,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: colors.muted,
              ),
            ),
          ],
        ),
      ),
      for (final s in items)
        InkWell(
          borderRadius: BorderRadius.circular(13),
          onTap: () {
            cubit.selectSession(s.id);
            Navigator.of(context).pop();
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
            decoration: BoxDecoration(
              color: s.id == activeId ? colors.surface2 : Colors.transparent,
              borderRadius: BorderRadius.circular(13),
              border: s.id == activeId ? Border.all(color: colors.hair) : null,
            ),
            child: Row(
              children: [
                if (s.pinned) ...[
                  Icon(LucideIcons.pin, size: 15, color: colors.muted),
                  const SizedBox(width: 6),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          color: colors.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        s.timeLabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    LucideIcons.ellipsisVertical,
                    size: 18,
                    color: colors.muted,
                  ),
                  color: colors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: colors.hair2),
                  ),
                  onSelected: (action) {
                    if (action == 'pin') {
                      cubit.togglePinSession(s.id);
                    } else if (action == 'dup') {
                      cubit.duplicateSession(s.id);
                    } else if (action == 'del') {
                      _confirmDelete(context, s);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'pin',
                      child: Row(
                        children: [
                          Icon(LucideIcons.pin, size: 17, color: colors.text2),
                          const SizedBox(width: 10),
                          Text(s.pinned ? 'Unpin chat' : 'Pin chat'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'dup',
                      child: Row(
                        children: [
                          Icon(LucideIcons.copy, size: 17, color: colors.text2),
                          const SizedBox(width: 10),
                          const Text('Duplicate'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'del',
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.trash2,
                            size: 17,
                            color: colors.danger,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Delete',
                            style: TextStyle(color: colors.danger),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
    ];
  }

  void _confirmDelete(BuildContext context, ChatSession session) {
    final colors = context.atlasColors;
    final cubit = context.read<ChatCubit>();
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: colors.bg2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: colors.hair2),
        ),
        title: Text(
          'Delete this chat?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.text,
          ),
        ),
        content: Text(
          '“${session.title}” will be removed from your sessions. You can undo right after deleting.',
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: colors.text2,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            style: TextButton.styleFrom(
              backgroundColor: colors.surface2,
              foregroundColor: colors.text,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              cubit.deleteSession(session.id);
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
