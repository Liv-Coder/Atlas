import 'package:flutter/material.dart';
import 'atlas_colors.dart';
import 'atlas_typography.dart';

class AtlasTheme {
  const AtlasTheme._();

  static ThemeData light() => _build(Brightness.light, AtlasColorPalette.light);
  static ThemeData dark() => _build(Brightness.dark, AtlasColorPalette.dark);

  static ThemeData _build(Brightness brightness, AtlasColorPalette palette) {
    final textTheme = AtlasTypography.buildTextTheme(palette);
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: palette.bg,
      canvasColor: palette.bg2,
      dividerColor: palette.hair,
      fontFamily: AtlasTypography.primaryFontFamily,
      textTheme: textTheme,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: palette.accent,
        onPrimary: palette.accentInk,
        secondary: palette.text2,
        onSecondary: palette.bg,
        error: palette.danger,
        onError: Colors.white,
        surface: palette.surface,
        onSurface: palette.text,
      ),
      extensions: <ThemeExtension<dynamic>>[palette],
    );
  }
}
