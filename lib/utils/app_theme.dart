// lib/utils/app_theme.dart
// Defines the global color palette, text styles, and theme data for the app.
// All UI components should reference these constants for visual consistency.

import 'package:flutter/material.dart';

class AppColors {
  // ── Primary Brand Colors ──────────────────────────────────────────────────
  static const Color primary = Color(0xFF5B6BF8);       // Indigo-blue (buttons, highlights)
  static const Color primaryLight = Color(0xFFEEF0FF);  // Light tint for backgrounds
  static const Color primaryDark = Color(0xFF3A4BD6);   // Darker shade for pressed states

  // ── Accent / Semantic Colors ──────────────────────────────────────────────
  static const Color success = Color(0xFF34C759);  // Green – completed items
  static const Color warning = Color(0xFFFF9F0A);  // Orange – pending/in-progress
  static const Color error = Color(0xFFFF3B30);    // Red – errors / destructive actions
  static const Color info = Color(0xFF32ADE6);     // Blue – informational highlights

  // ── Neutral Palette ───────────────────────────────────────────────────────
  static const Color background = Color(0xFFF5F7FF); // App background (very light lavender)
  static const Color surface = Color(0xFFFFFFFF);    // Card / surface color
  static const Color surfaceVariant = Color(0xFFF0F2FF); // Slightly tinted surface

  // ── Text Colors ───────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1D3B);   // Dark navy – primary text
  static const Color textSecondary = Color(0xFF6B7280);  // Medium grey – subtitles
  static const Color textHint = Color(0xFFB0B7C3);       // Light grey – hints/placeholders

  // ── Chart / Data Colors ───────────────────────────────────────────────────
  static const Color chartBlue = Color(0xFF5B6BF8);
  static const Color chartGreen = Color(0xFF34C759);
  static const Color chartOrange = Color(0xFFFF9F0A);
  static const Color chartRed = Color(0xFFFF6B6B);
}

class AppTheme {
  // ── Main Light Theme ──────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        background: AppColors.background,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.background,

      // ── AppBar ────────────────────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),

      // ── Elevated Button ───────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // ── Text Button ───────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      // ── Input Fields ──────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.textHint.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
      ),

      // ── Card ──────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
    );
  }
}
