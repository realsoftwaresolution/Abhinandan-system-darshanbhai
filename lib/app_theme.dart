import 'package:flutter/material.dart';

class AppColors {
  // Brand & Accent Colors
  static const Color primary = Color(0xFF1E40AF); // Professional Royal Blue
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1E3A8A);
  static const Color brandRed = Color(0xFFC50404); // Preserved brand red

  // Neutral Colors
  static const Color background = Color(0xFFF8FAFC); // Clean slate background
  static const Color surface = Colors.white;
  static const Color cardBg = Colors.white;
  static const Color border = Color(0xFFCBD5E1); // Slate 300
  static const Color borderLight = Color(0xFFE2E8F0); // Slate 200

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400

  // State Colors
  static const Color success = Color(0xFF16A34A);
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFD97706);
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerBg = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF0284C7);
  static const Color infoBg = Color(0xFFE0F2FE);

  // Table Row Highlight
  static const Color tableRowAlt = Color(0xFFF8FAFC);
  static const Color tableRowHover = Color(0xFFEFF6FF);
}

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.brandRed,
    surface: AppColors.surface,
    error: AppColors.danger,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.textPrimary,
  ),
  fontFamily: 'Roboto',
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: AppColors.textPrimary,
    elevation: 0.5,
    scrolledUnderElevation: 1.0,
    centerTitle: false,
    titleTextStyle: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
  cardTheme: CardThemeData(
    color: AppColors.cardBg,
    elevation: 0,
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: AppColors.borderLight, width: 1),
      borderRadius: BorderRadius.circular(8),
    ),
    margin: EdgeInsets.zero,
  ),
  inputDecorationTheme: InputDecorationTheme(
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    filled: true,
    fillColor: Colors.white,
    hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
    labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: AppColors.border, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: AppColors.border, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: AppColors.border, width: 1),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: AppColors.danger, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.textPrimary,
      side: const BorderSide(color: AppColors.border, width: 1),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: AppColors.borderLight,
    thickness: 1,
    space: 1,
  ),
);
