import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/controllers/menu_app_controller.dart';
import 'package:real_web_rough_entry_system/controllers/theme_controller.dart';
import 'package:real_web_rough_entry_system/main/main_screen.dart';
import 'package:real_web_rough_entry_system/splash_screen.dart';
import 'package:real_web_rough_entry_system/tab-view-dashboard/tab_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeController = Get.put(ThemeController());
  await themeController.loadSavedTheme();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.to;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Abhinandan Diamond',
      theme: buildThemeData(AppThemes.light),
      darkTheme: buildThemeData(AppThemes.dark),
      themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      builder: (context, child) {
        return Obx(
          () => AnimatedTheme(
            data: themeController.currentThemeData,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
      initialBinding: BindingsBuilder(() {
        Get.put(TabControllerX());
        Get.put(MenuAppController());
        Get.put(DefaultController());
      }),
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/MainScreen', page: () => const MainScreen()),
      ],
      initialRoute: '/',
    );
  }
}
