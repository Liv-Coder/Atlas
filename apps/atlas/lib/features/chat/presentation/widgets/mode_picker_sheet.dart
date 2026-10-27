import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../domain/models/atlas_mode.dart';

class ModePickerSheet extends StatelessWidget {
  const ModePickerSheet({
    super.key,
    required this.selectedMode,
    required this.onSelected,
  });

  final AtlasMode selectedMode;
  final ValueChanged<AtlasMode> onSelected;

  IconData _iconFor(AtlasMode mode) {
    return switch (mode) {
      AtlasMode.plan => LucideIcons.listChecks,
      AtlasMode.chat => LucideIcons.messageCircle,
      AtlasMode.agent => LucideIcons.bot,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.atlasColors;
    return AtlasBottomSheet(
      title: 'Mode',
      subtitle: 'How Atlas should work in this chat.',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(AtlasMode.values.length, (i) {
          final mode = AtlasMode.values[i];
          final isSelected = mode == selectedMode;
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              onSelected(mode);
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
                    child: Icon(
                      _iconFor(mode),
                      size: 21,
                      color: colors.text,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mode.displayName,
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w600,
                            color: colors.text,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          mode.description,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: colors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
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
