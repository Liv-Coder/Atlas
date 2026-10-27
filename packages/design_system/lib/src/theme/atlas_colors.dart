import 'package:flutter/material.dart';

@immutable
class AtlasColorPalette extends ThemeExtension<AtlasColorPalette> {
  const AtlasColorPalette({
    required this.bg,
    required this.bg2,
    required this.surface,
    required this.surface2,
    required this.surface3,
    required this.hair,
    required this.hair2,
    required this.text,
    required this.text2,
    required this.muted,
    required this.accent,
    required this.accentInk,
    required this.userBubble,
    required this.userText,
    required this.danger,
    required this.dangerBg,
    required this.chip,
    required this.statusReady,
    required this.statusRunning,
  });

  final Color bg;
  final Color bg2;
  final Color surface;
  final Color surface2;
  final Color surface3;
  final Color hair;
  final Color hair2;
  final Color text;
  final Color text2;
  final Color muted;
  final Color accent;
  final Color accentInk;
  final Color userBubble;
  final Color userText;
  final Color danger;
  final Color dangerBg;
  final Color chip;
  final Color statusReady;
  final Color statusRunning;

  /// Exact Light palette from Nexus Chat Mock.html
  static const AtlasColorPalette light = AtlasColorPalette(
    bg: Color(0xFFFFFFFF),
    bg2: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    surface2: Color(0xFFF7F7F5),
    surface3: Color(0xFFEEEEEC),
    hair: Color(0x14000000),
    hair2: Color(0x24000000),
    text: Color(0xFF171717),
    text2: Color(0xFF4D4D4A),
    muted: Color(0xFF8A8A86),
    accent: Color(0xFF171717),
    accentInk: Color(0xFFFFFFFF),
    userBubble: Color(0xFFF4F4F2),
    userText: Color(0xFF171717),
    danger: Color(0xFFC2410C),
    dangerBg: Color(0x12C2410C),
    chip: Color(0xFFF4F4F2),
    statusReady: Color(0xFF16A34A),
    statusRunning: Color(0xFFD97706),
  );

  /// Exact Dark palette from Nexus Chat Mock.html
  static const AtlasColorPalette dark = AtlasColorPalette(
    bg: Color(0xFF171717),
    bg2: Color(0xFF171717),
    surface: Color(0xFF212121),
    surface2: Color(0xFF2A2A2A),
    surface3: Color(0xFF383838),
    hair: Color(0x1AFFFFFF),
    hair2: Color(0x2EFFFFFF),
    text: Color(0xFFF5F5F3),
    text2: Color(0xFFC9C9C5),
    muted: Color(0xFF9A9A96),
    accent: Color(0xFFF5F5F3),
    accentInk: Color(0xFF171717),
    userBubble: Color(0xFF2F2F2F),
    userText: Color(0xFFF5F5F3),
    danger: Color(0xFFF0A58A),
    dangerBg: Color(0x1AF0A58A),
    chip: Color(0xFF2A2A2A),
    statusReady: Color(0xFF4ADE80),
    statusRunning: Color(0xFFD97706),
  );

  @override
  AtlasColorPalette copyWith({
    Color? bg,
    Color? bg2,
    Color? surface,
    Color? surface2,
    Color? surface3,
    Color? hair,
    Color? hair2,
    Color? text,
    Color? text2,
    Color? muted,
    Color? accent,
    Color? accentInk,
    Color? userBubble,
    Color? userText,
    Color? danger,
    Color? dangerBg,
    Color? chip,
    Color? statusReady,
    Color? statusRunning,
  }) {
    return AtlasColorPalette(
      bg: bg ?? this.bg,
      bg2: bg2 ?? this.bg2,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      surface3: surface3 ?? this.surface3,
      hair: hair ?? this.hair,
      hair2: hair2 ?? this.hair2,
      text: text ?? this.text,
      text2: text2 ?? this.text2,
      muted: muted ?? this.muted,
      accent: accent ?? this.accent,
      accentInk: accentInk ?? this.accentInk,
      userBubble: userBubble ?? this.userBubble,
      userText: userText ?? this.userText,
      danger: danger ?? this.danger,
      dangerBg: dangerBg ?? this.dangerBg,
      chip: chip ?? this.chip,
      statusReady: statusReady ?? this.statusReady,
      statusRunning: statusRunning ?? this.statusRunning,
    );
  }

  @override
  AtlasColorPalette lerp(ThemeExtension<AtlasColorPalette>? other, double t) {
    if (other is! AtlasColorPalette) return this;
    return AtlasColorPalette(
      bg: Color.lerp(bg, other.bg, t)!,
      bg2: Color.lerp(bg2, other.bg2, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      surface3: Color.lerp(surface3, other.surface3, t)!,
      hair: Color.lerp(hair, other.hair, t)!,
      hair2: Color.lerp(hair2, other.hair2, t)!,
      text: Color.lerp(text, other.text, t)!,
      text2: Color.lerp(text2, other.text2, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentInk: Color.lerp(accentInk, other.accentInk, t)!,
      userBubble: Color.lerp(userBubble, other.userBubble, t)!,
      userText: Color.lerp(userText, other.userText, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerBg: Color.lerp(dangerBg, other.dangerBg, t)!,
      chip: Color.lerp(chip, other.chip, t)!,
      statusReady: Color.lerp(statusReady, other.statusReady, t)!,
      statusRunning: Color.lerp(statusRunning, other.statusRunning, t)!,
    );
  }
}

extension AtlasThemeContext on BuildContext {
  AtlasColorPalette get atlasColors =>
      Theme.of(this).extension<AtlasColorPalette>() ?? AtlasColorPalette.light;
}
