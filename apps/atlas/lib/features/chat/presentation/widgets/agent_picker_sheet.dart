import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../domain/models/agent_provider.dart';

class AgentPickerSheet extends StatelessWidget {
  const AgentPickerSheet({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.atlasColors;
    return AtlasBottomSheet(
      title: 'Agent',
      subtitle: 'Provider and model for this chat.',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(AgentProviderConfig.defaults.length, (i) {
          final agent = AgentProviderConfig.defaults[i];
          final isSelected = i == selectedIndex;
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              onSelected(i);
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                border: i > 0
                    ? Border(top: BorderSide(color: colors.hair))
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: colors.surface2,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.hair),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      agent.initial,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colors.text,
                      ),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              agent.provider,
                              style: TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w600,
                                color: colors.text,
                              ),
                            ),
                            if (agent.badge.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2.5,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.surface2,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: colors.hair),
                                ),
                                child: Text(
                                  agent.badge,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: colors.muted,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          agent.fullModel,
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: colors.text,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LucideIcons.check,
                        size: 14,
                        color: colors.bg,
                      ),
                    )
                  else
                    const SizedBox(width: 24),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
