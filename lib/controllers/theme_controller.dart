import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find<ThemeController>();
  static bool get isInitialized => Get.isRegistered<ThemeController>();

  static const String _prefIsDark = 'app_is_dark_mode';
  static const String _prefThemeId = 'app_theme_id';

  final RxBool isDarkMode = false.obs;

  AppThemeConfig get activeConfig =>
      isDarkMode.value ? AppThemes.dark : AppThemes.light;

  ThemeData get currentThemeData => buildThemeData(activeConfig);

  String get currentThemeId => isDarkMode.value ? 'dark' : 'light';

  @override
  void onInit() {
    super.onInit();
    loadSavedTheme();
  }

  Future<void> loadSavedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedDark = prefs.getBool(_prefIsDark);
      if (savedDark != null) {
        isDarkMode.value = savedDark;
      } else {
        final savedId = prefs.getString(_prefThemeId);
        if (savedId != null) {
          isDarkMode.value = (savedId == 'dark' ||
              savedId == 'midnight_navy' ||
              savedId == 'dark_charcoal' ||
              savedId == 'emerald_dark' ||
              savedId == 'obsidian_black');
        }
      }
      Get.changeTheme(currentThemeData);
      update();
    } catch (e) {
      debugPrint('ThemeController: Error loading saved theme: $e');
    }
  }

  Future<void> toggleDarkMode() async {
    await setDarkMode(!isDarkMode.value);
  }

  Future<void> setDarkMode(bool isDark) async {
    if (isDarkMode.value == isDark) return;
    isDarkMode.value = isDark;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefIsDark, isDark);
      await prefs.setString(_prefThemeId, isDark ? 'dark' : 'light');
    } catch (e) {
      debugPrint('ThemeController: Error saving theme: $e');
    }
    Get.changeTheme(currentThemeData);
    update();
  }

  Future<void> setTheme(String themeId) async {
    final bool isDark = (themeId == 'dark' ||
        themeId == 'midnight_navy' ||
        themeId == 'dark_charcoal' ||
        themeId == 'emerald_dark' ||
        themeId == 'obsidian_black');
    await setDarkMode(isDark);
  }

  Future<void> resetToDefault() async {
    await setDarkMode(false);
  }
}
