import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AttachPickerSheet extends StatelessWidget {
  const AttachPickerSheet({
    super.key,
    required this.onAttachSelected,
  });

  final ValueChanged<String> onAttachSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.atlasColors;
    const options = [
      (label: 'Photo', file: 'photo.png', icon: LucideIcons.image),
      (label: 'File', file: 'price-list.pdf', icon: LucideIcons.fileText),
      (label: 'Camera', file: 'camera.jpg', icon: LucideIcons.camera),
    ];

    return AtlasBottomSheet(
      title: 'Attach',
      subtitle: 'Add something to your next message.',
      child: Row(
        children: options.map((opt) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  onAttachSelected(opt.file);
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: colors.surface2,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(opt.icon, size: 25, color: colors.text),
                      const SizedBox(height: 9),
                      Text(
                        opt.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.text2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
