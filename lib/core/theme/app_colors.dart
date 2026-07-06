import 'package:flutter/material.dart';

/// BachatBite color palette — Indian-inspired premium dark theme
class AppColors {
  AppColors._();

  // ── Base surfaces ──
  static const Color background = Color(0xFF0F0F1A);
  static const Color surface = Color(0xFF1A1A2E);
  static const Color surfaceLight = Color(0xFF242440);
  static const Color cardGlass = Color(0x1AFFFFFF); // 10% white

  // ── Primary accents ──
  static const Color saffron = Color(0xFFFF6F00);
  static const Color saffronLight = Color(0xFFFF9100);
  static const Color turmericGold = Color(0xFFFFB300);

  // ── Semantic ──
  static const Color savingsGreen = Color(0xFF00E676);
  static const Color savingsGreenDark = Color(0xFF00C853);
  static const Color warningAmber = Color(0xFFFFAB00);
  static const Color errorRed = Color(0xFFFF5252);

  // ── Meal slot colors ──
  static const Color mealBreakfast = Color(0xFFFFA726); // warm amber
  static const Color mealLunch = Color(0xFF66BB6A); // green
  static const Color mealDinner = Color(0xFF42A5F5); // blue

  // ── Text ──
  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFFB0B0C0);
  static const Color textMuted = Color(0xFF6C6C80);

  // ── Misc ──
  static const Color divider = Color(0xFF2A2A40);
  static const Color shimmer = Color(0xFF2E2E45);

  // ── Gradients ──
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [saffron, turmericGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0F0F1A), Color(0xFF16213E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0x1AFFFFFF), Color(0x0DFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
