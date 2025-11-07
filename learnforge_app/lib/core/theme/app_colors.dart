import 'dart:ui';
import 'package:flutter/material.dart';

class AppColors {
  // Dark colors from your CSS
  static const Color dark900 = Color(0xFF0A0A0F);
  static const Color dark800 = Color(0xFF131318);
  static const Color dark700 = Color(0xFF1A1A22);
  static const Color dark600 = Color(0xFF252530);

  // Neon colors from your CSS
  static const Color neonPurple = Color(0xFF8B5CF6);
  static const Color neonCyan = Color(0xFF06B6D4);
  static const Color neonPink = Color(0xFFEC4899);
  static const Color neonBlue = Color(0xFF3B82F6);

  // Additional colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey400 = Color(0xFF9CA3AF);

  // Status colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color warning = Color(0xFFF59E0B); // Amber/Orange
  static const Color danger = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF3B82F6); // Blue

  // Primary and secondary colors
  static const Color primary = neonPurple;
  static const Color secondary = neonCyan;
  static const Color accent = neonPink;

  // Text colors
  static const Color textLight = white;
  static const Color textDark = dark900;
  static const Color textMuted = grey400;

  // Gradient combinations
  static const LinearGradient purpleCyanGradient = LinearGradient(
    colors: [neonPurple, neonCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pinkBlueGradient = LinearGradient(
    colors: [neonPink, neonBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Additional gradients
  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [warning, Color(0xFFFBBF24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [danger, Color(0xFFF87171)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
