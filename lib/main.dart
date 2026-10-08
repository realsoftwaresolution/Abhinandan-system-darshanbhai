import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/main/main_screen.dart';
import 'package:real_web_rough_entry_system/splash_screen.dart';
import 'package:real_web_rough_entry_system/tab-view-dashboard/tab_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Abhinandan Diamond',
      theme: lightTheme,
      initialBinding: BindingsBuilder(() {
        Get.put(TabControllerX());
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
