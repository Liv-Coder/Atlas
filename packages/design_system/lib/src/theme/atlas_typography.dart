import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'atlas_colors.dart';

class AtlasTypography {
  const AtlasTypography._();

  static TextTheme buildTextTheme(AtlasColorPalette colors) {
    final base = GoogleFonts.manropeTextTheme();
    return base.copyWith(
      headlineMedium: GoogleFonts.manrope(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.25,
        color: colors.text,
      ),
      titleLarge: GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.2,
        color: colors.text,
      ),
      titleMedium: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.15,
        color: colors.text,
      ),
      bodyLarge: GoogleFonts.manrope(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.65,
        color: colors.text,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: colors.text2,
      ),
      labelSmall: GoogleFonts.manrope(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
        color: colors.muted,
      ),
    );
  }

  static TextStyle mono({
    double fontSize = 12.5,
    FontWeight fontWeight = FontWeight.w500,
    Color? color,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
