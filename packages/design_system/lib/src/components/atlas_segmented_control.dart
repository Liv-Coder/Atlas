import 'package:flutter/material.dart';
import '../theme/atlas_colors.dart';

class AtlasSegmentOption<T> {
  const AtlasSegmentOption({
    required this.value,
    required this.label,
    this.icon,
  });

  final T value;
  final String label;
  final IconData? icon;
}

class AtlasSegmentedControl<T> extends StatelessWidget {
  const AtlasSegmentedControl({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<AtlasSegmentOption<T>> options;
  final T selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.atlasColors;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: colors.hair),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((opt) {
          final isSel = opt.value == selected;
          return GestureDetector(
            onTap: () => onSelected(opt.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: isSel ? colors.surface : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: isSel
                    ? const [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (opt.icon != null) ...[
                    Icon(
                      opt.icon,
                      size: 15,
                      color: isSel ? colors.text : colors.muted,
                    ),
                    const SizedBox(width: 5),
                  ],
                  Text(
                    opt.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isSel ? colors.text : colors.muted,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
