import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class TextStyles {
  // Orbitron font for headings
  static TextStyle orbitron({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.white,
  }) {
    return GoogleFonts.orbitron(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Inter font for body text
  static TextStyle inter({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.white,
    FontStyle fontStyle = FontStyle.normal, // Add this
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle, // Add this
    );
  }

  // Specific text styles
  static TextStyle get displayLarge =>
      orbitron(fontSize: 32, fontWeight: FontWeight.bold);

  static TextStyle get displayMedium =>
      orbitron(fontSize: 24, fontWeight: FontWeight.w600);

  static TextStyle get titleLarge =>
      orbitron(fontSize: 20, fontWeight: FontWeight.w500);

  static TextStyle get bodyLarge => inter(fontSize: 16, color: AppColors.white);

  static TextStyle get bodyMedium =>
      inter(fontSize: 14, color: AppColors.grey200);

  static TextStyle get bodySmall =>
      inter(fontSize: 12, color: AppColors.grey400);

  // Neon text with glow effect
  static TextStyle neon({
    required Color glowColor,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return orbitron(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: glowColor,
    );
  }
}
