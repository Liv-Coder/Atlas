import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:routing/routing.dart';
import 'package:share_plus/share_plus.dart';
import '../../../domain/models/atlas_mode.dart';
import '../../chat/cubit/chat_cubit.dart';
import '../../chat/presentation/widgets/agent_picker_sheet.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.atlasColors;
    final settings = context.watch<SettingsCubit>().state;
    final settingsCubit = context.read<SettingsCubit>();
    final chatState = context.watch<ChatCubit>().state;
    final chatCubit = context.read<ChatCubit>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: colors.hair)),
              ),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Back to chat',
                    onPressed: () => context.pop(),
                    icon: Icon(
                      LucideIcons.chevronLeft,
                      size: 22,
                      color: colors.text2,
                    ),
                  ),
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: colors.text,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
                children: [
                  _sectionLabel(context, 'PROVIDER'),
                  _cardGroup(
                    context,
                    children: [
                      _settingsRow(
                        context,
                        icon: LucideIcons.cpu,
                        title: 'Provider',
                        subtitle: chatState.activeAgent.provider,
                        onTap: () => showModalBottomSheet<void>(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (_) => AgentPickerSheet(
                            selectedIndex: chatState.selectedAgentIndex,
                            onSelected: chatCubit.selectAgent,
                          ),
                        ),
                      ),
                      _settingsRow(
                        context,
                        icon: LucideIcons.keyRound,
                        title: 'API key',
                        subtitle: settings.displayApiKey,
                        monoSubtitle: true,
                        onTap: () {
                          settingsCubit.toggleApiKeyVisibility();
                          chatCubit.showInfoSnackbar(
                            !settings.apiKeyRevealed
                                ? 'Key stays on this device only'
                                : 'API key hidden',
                          );
                        },
                      ),
                      _settingsRow(
                        context,
                        icon: LucideIcons.sparkles,
                        title: 'Model',
                        subtitle: chatState.activeAgent.fullModel,
                        onTap: () => showModalBottomSheet<void>(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (_) => AgentPickerSheet(
                            selectedIndex: chatState.selectedAgentIndex,
                            onSelected: chatCubit.selectAgent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _sectionLabel(context, 'AGENT & WORKFLOW'),
                  _cardGroup(
                    context,
                    children: [
                      _settingsRow(
                        context,
                        icon: LucideIcons.shieldCheck,
                        title: 'Agent approvals',
                        subtitle: 'Ask before external actions',
                        trailing: AtlasSwitch(
                          value: settings.agentApprovals,
                          onChanged: (_) =>
                              settingsCubit.toggleAgentApprovals(),
                        ),
                      ),
                      _settingsRow(
                        context,
                        icon: LucideIcons.gitBranch,
                        title: 'Workflow',
                        subtitle: 'Plan → Gather → Execute → Verify',
                        onTap: () {
                          chatCubit.selectMode(AtlasMode.agent);
                          chatCubit.showInfoSnackbar(
                            'Agent workflow: Plan → Gather → Execute → Verify',
                          );
                          context.pop();
                        },
                      ),
                      _settingsRow(
                        context,
                        icon: LucideIcons.slidersHorizontal,
                        title: 'Default mode',
                        subtitle: chatState.mode.displayName,
                      ),
                      _settingsRow(
                        context,
                        icon: LucideIcons.rotateCcw,
                        title: 'Show workflow progress',
                        subtitle: 'Stepper & progress in Agent mode',
                        trailing: AtlasSwitch(
                          value: settings.showWorkflowProgress,
                          onChanged: (_) =>
                              settingsCubit.toggleWorkflowProgress(),
                        ),
                      ),
                    ],
                  ),
                  _sectionLabel(context, 'APPEARANCE'),
                  _cardGroup(
                    context,
                    children: [
                      _settingsRow(
                        context,
                        icon: LucideIcons.moon,
                        title: 'Theme',
                        subtitle: settings.isDarkMode ? 'Dark' : 'Light',
                        trailing: AtlasSegmentedControl<bool>(
                          selected: settings.isDarkMode,
                          onSelected: settingsCubit.setDarkMode,
                          options: const [
                            AtlasSegmentOption(
                              value: true,
                              label: 'Dark',
                              icon: LucideIcons.moon,
                            ),
                            AtlasSegmentOption(
                              value: false,
                              label: 'Light',
                              icon: LucideIcons.sun,
                            ),
                          ],
                        ),
                      ),
                      _settingsRow(
                        context,
                        icon: LucideIcons.type,
                        title: 'Text size',
                        subtitle: settings.textSize.label,
                        trailing: AtlasSegmentedControl<AtlasTextSize>(
                          selected: settings.textSize,
                          onSelected: settingsCubit.setTextSize,
                          options: const [
                            AtlasSegmentOption(
                              value: AtlasTextSize.small,
                              label: 'S',
                            ),
                            AtlasSegmentOption(
                              value: AtlasTextSize.medium,
                              label: 'M',
                            ),
                            AtlasSegmentOption(
                              value: AtlasTextSize.large,
                              label: 'L',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _sectionLabel(context, 'DATA & PRIVACY'),
                  _cardGroup(
                    context,
                    children: [
                      _settingsRow(
                        context,
                        icon: LucideIcons.download,
                        title: 'Export chat',
                        subtitle: 'Download this conversation as text',
                        onTap: () {
                          final text = chatCubit.buildExportText();
                          if (text != null) {
                            Share.share(text);
                          }
                          context.pop();
                        },
                      ),
                      _settingsRow(
                        context,
                        icon: LucideIcons.trash2,
                        title: 'Reset app data',
                        subtitle: 'Clears chats and returns mode to Plan',
                        isDanger: true,
                        onTap: () {
                          chatCubit.resetAppData();
                          context.pop();
                        },
                      ),
                    ],
                  ),
                  _sectionLabel(context, 'ABOUT'),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: colors.hair)),
                    ),
                    child: Row(
                      children: [
                        const AtlasLogoMark(size: 52, borderRadius: 15),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Atlas',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: colors.text,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Your professional AI agent\nVersion 1.0 · Flutter · com.atlas.chat',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  height: 1.5,
                                  fontWeight: FontWeight.w600,
                                  color: colors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text) {
    final colors = context.atlasColors;
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 6, left: 2),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
          color: colors.muted,
        ),
      ),
    );
  }

  Widget _cardGroup(BuildContext context, {required List<Widget> children}) {
    final colors = context.atlasColors;
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.hair)),
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++)
            Container(
              decoration: BoxDecoration(
                border: i > 0
                    ? Border(top: BorderSide(color: colors.hair))
                    : null,
              ),
              child: children[i],
            ),
        ],
      ),
    );
  }

  Widget _settingsRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    bool monoSubtitle = false,
    bool isDanger = false,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final colors = context.atlasColors;
    final fg = isDanger ? colors.danger : colors.text;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: isDanger ? colors.danger : colors.text2,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: fg,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    overflow: TextOverflow.ellipsis,
                    style: monoSubtitle
                        ? AtlasTypography.mono(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colors.muted,
                          )
                        : TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: colors.muted,
                          ),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: colors.muted,
                ),
          ],
        ),
      ),
    );
  }
}
