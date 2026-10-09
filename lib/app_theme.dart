import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/controllers/theme_controller.dart';

class AppThemeConfig {
  final String id;
  final String name;
  final String description;
  final bool isDark;
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color brandRed;
  final Color background;
  final Color surface;
  final Color cardBg;
  final Color inputBg;
  final Color inputBgDisabled;
  final Color border;
  final Color borderLight;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color success;
  final Color successBg;
  final Color warning;
  final Color warningBg;
  final Color danger;
  final Color dangerBg;
  final Color info;
  final Color infoBg;
  final Color tableRowAlt;
  final Color tableRowHover;

  const AppThemeConfig({
    required this.id,
    required this.name,
    required this.description,
    required this.isDark,
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    this.brandRed = const Color(0xFFC50404),
    required this.background,
    required this.surface,
    required this.cardBg,
    required this.inputBg,
    required this.inputBgDisabled,
    required this.border,
    required this.borderLight,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    this.success = const Color(0xFF16A34A),
    this.successBg = const Color(0xFFDCFCE7),
    this.warning = const Color(0xFFD97706),
    this.warningBg = const Color(0xFFFEF3C7),
    this.danger = const Color(0xFFDC2626),
    this.dangerBg = const Color(0xFFFEE2E2),
    this.info = const Color(0xFF0284C7),
    this.infoBg = const Color(0xFFE0F2FE),
    required this.tableRowAlt,
    required this.tableRowHover,
  });
}

class AppThemes {
  // 1. Light Theme (Clean Professional ERP)
  static const AppThemeConfig light = AppThemeConfig(
    id: 'light',
    name: 'Light Theme',
    description: 'Clean professional ERP design with slate background and royal blue accent',
    isDark: false,
    primary: Color(0xFF1D4ED8),       // Royal Blue
    primaryLight: Color(0xFF3B82F6),  // Sky Blue
    primaryDark: Color(0xFF1E3A8A),   // Deep Navy
    background: Color(0xFFF8FAFC),    // Slate 50
    surface: Colors.white,
    cardBg: Colors.white,
    inputBg: Colors.white,
    inputBgDisabled: Color(0xFFF1F5F9),
    border: Color(0xFFCBD5E1),        // Slate 300
    borderLight: Color(0xFFE2E8F0),   // Slate 200
    textPrimary: Color(0xFF0F172A),   // Slate 900
    textSecondary: Color(0xFF475569), // Slate 600
    textMuted: Color(0xFF94A3B8),     // Slate 400
    tableRowAlt: Color(0xFFF8FAFC),
    tableRowHover: Color(0xFFEFF6FF), // Soft Blue 50
  );

  // 2. Dark Theme (Deep Midnight Navy Executive ERP)
  static const AppThemeConfig dark = AppThemeConfig(
    id: 'dark',
    name: 'Dark Theme',
    description: 'Deep oceanic midnight navy for maximum eye comfort in low light',
    isDark: true,
    primary: Color(0xFF38BDF8),       // Radiant Sky Blue
    primaryLight: Color(0xFF7DD3FC),  // Light Sky Blue
    primaryDark: Color(0xFF0284C7),   // Deep Cyan
    background: Color(0xFF0B1120),    // Slate 950 / Deep Midnight Navy
    surface: Color(0xFF131E32),       // Elevated Navy Surface
    cardBg: Color(0xFF131E32),        // Card Background
    inputBg: Color(0xFF1E293B),       // Slate 800 - distinct dark input surface on card
    inputBgDisabled: Color(0xFF0F172A), // Slate 900 - inactive input background
    border: Color(0xFF1E293B),        // Slate 800
    borderLight: Color(0xFF334155),   // Slate 700
    textPrimary: Color(0xFFF8FAFC),   // Slate 50 / Ice White
    textSecondary: Color(0xFF94A3B8), // Slate 400
    textMuted: Color(0xFF64748B),     // Slate 500
    successBg: Color(0xFF064E3B),
    warningBg: Color(0xFF78350F),
    dangerBg: Color(0xFF7F1D1D),
    infoBg: Color(0xFF0C4A6E),
    tableRowAlt: Color(0xFF0F172A),   // Slate 900
    tableRowHover: Color(0xFF1E293B), // Slate 800
  );

  // Backward-compatibility aliases
  static const AppThemeConfig royalBlue = light;
  static const AppThemeConfig midnightNavy = dark;

  static const Map<String, AppThemeConfig> allThemes = {
    'light': light,
    'dark': dark,
    'royal_blue': light,
    'midnight_navy': dark,
    'dark_charcoal': dark,
    'obsidian_black': dark,
    'emerald_dark': dark,
    'emerald_green': light,
    'deep_violet': light,
    'crimson_ruby': light,
    'amber_gold': light,
  };

  static AppThemeConfig getTheme(String id) {
    return allThemes[id] ?? light;
  }
}

class AppColors {
  static AppThemeConfig get _current {
    try {
      if (Get.isRegistered<ThemeController>()) {
        final ctrl = Get.find<ThemeController>();
        return ctrl.isDarkMode.value ? AppThemes.dark : AppThemes.light;
      }
    } catch (_) {}
    return AppThemes.light;
  }

  // Theme state
  static bool get isDark => _current.isDark;

  // Brand & Accent Colors
  static Color get primary => _current.primary;
  static Color get primaryLight => _current.primaryLight;
  static Color get primaryDark => _current.primaryDark;
  static Color get brandRed => _current.brandRed;

  // Neutral Colors
  static Color get background => _current.background;
  static Color get surface => _current.surface;
  static Color get cardBg => _current.cardBg;
  static Color get inputBg => _current.inputBg;
  static Color get inputBgDisabled => _current.inputBgDisabled;
  static Color get border => _current.border;
  static Color get borderLight => _current.borderLight;

  // Text Colors
  static Color get textPrimary => _current.textPrimary;
  static Color get textSecondary => _current.textSecondary;
  static Color get textMuted => _current.textMuted;

  // State Colors
  static Color get success => _current.success;
  static Color get successBg => _current.successBg;
  static Color get warning => _current.warning;
  static Color get warningBg => _current.warningBg;
  static Color get danger => _current.danger;
  static Color get dangerBg => _current.dangerBg;
  static Color get info => _current.info;
  static Color get infoBg => _current.infoBg;

  // Table Row Highlight
  static Color get tableRowAlt => _current.tableRowAlt;
  static Color get tableRowHover => _current.tableRowHover;
}

ThemeData buildThemeData(AppThemeConfig config) {
  final brightness = config.isDark ? Brightness.dark : Brightness.light;

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    primaryColor: config.primary,
    scaffoldBackgroundColor: config.background,
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: config.primary,
      onPrimary: config.isDark ? const Color(0xFF0F172A) : Colors.white,
      secondary: config.brandRed,
      onSecondary: Colors.white,
      surface: config.surface,
      onSurface: config.textPrimary,
      error: config.danger,
      onError: Colors.white,
    ),
    fontFamily: 'Roboto',
    appBarTheme: AppBarTheme(
      backgroundColor: config.isDark ? config.cardBg : Colors.white,
      foregroundColor: config.textPrimary,
      elevation: 0.5,
      scrolledUnderElevation: 1.0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: config.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: config.cardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: config.borderLight, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      filled: true,
      fillColor: config.inputBg,
      hintStyle: TextStyle(color: config.textMuted, fontSize: 13),
      labelStyle: TextStyle(color: config.isDark ? config.borderLight : config.textSecondary, fontSize: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: config.isDark ? config.borderLight : config.border, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: config.isDark ? config.borderLight : config.border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: config.primary, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: config.isDark ? config.border : config.borderLight, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: config.danger, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: config.danger, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: config.primary,
        foregroundColor: config.isDark ? const Color(0xFF0F172A) : Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: config.textPrimary,
        side: BorderSide(color: config.border, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: config.cardBg,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: config.cardBg,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    dividerTheme: DividerThemeData(
      color: config.borderLight,
      thickness: 1,
      space: 1,
    ),
  );
}

final ThemeData lightTheme = buildThemeData(AppThemes.light);
final ThemeData darkTheme = buildThemeData(AppThemes.dark);
