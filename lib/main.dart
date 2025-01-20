// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
// import 'package:real_web_rough_entry_system/main/main_screen.dart';
//
// import 'controllers/menu_app_controller.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Real Software Solutions',
//       // theme: ThemeData.dark().copyWith(
//       //   scaffoldBackgroundColor: bgColor,
//       //   textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
//       //       .apply(bodyColor: Colors.white),
//       //   canvasColor: secondaryColor,
//       // ),
//       initialBinding: BindingsBuilder(() {
//         Get.put(MenuAppController());
//         Get.put(DefaultController());
//       }),
//       home: const MainScreen(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/main/main_screen.dart';
import 'package:real_web_rough_entry_system/splash_screen.dart';

import 'tab-view-dashboard/tab_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Real Software Solutions | RES',
      initialBinding: BindingsBuilder(() {
        // Get.put(MenuAppController());
        Get.put(TabControllerX());
        Get.put(DefaultController());
      }),
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()), // You can replace this with your splash screen if needed
        GetPage(name: '/MainScreen', page: () => const MainScreen()),
      ],
      initialRoute: '/', //
      // home: const MainScreen(),
    );
  }
}
