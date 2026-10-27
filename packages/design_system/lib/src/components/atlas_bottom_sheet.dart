import 'package:flutter/material.dart';
import '../theme/atlas_colors.dart';
import '../theme/atlas_radius.dart';

class AtlasBottomSheet extends StatelessWidget {
  const AtlasBottomSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.atlasColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.bg2,
        borderRadius: AtlasRadius.sheetTop,
        border: Border(top: BorderSide(color: colors.hair)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        10,
        20,
        22 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4.5,
              margin: const EdgeInsets.only(top: 2, bottom: 14),
              decoration: BoxDecoration(
                color: colors.hair2,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              color: colors.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: colors.muted,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
