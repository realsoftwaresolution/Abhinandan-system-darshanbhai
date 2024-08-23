import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/controllers/menu_app_controller.dart';
import 'package:real_web_rough_entry_system/dashboard_screen.dart';
import 'package:real_web_rough_entry_system/expense_form_screen.dart';
import 'package:real_web_rough_entry_system/memoiss_form_screen.dart';
import 'package:real_web_rough_entry_system/memorec_form_screen.dart';
import 'package:real_web_rough_entry_system/party/party_form_screen.dart';
import 'package:real_web_rough_entry_system/purchase_form_screen.dart';
import 'package:real_web_rough_entry_system/sale_form_screen.dart';
import 'package:real_web_rough_entry_system/settings_screen.dart';
// Import other screens as needed

import '../responsive.dart';
import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.find to access the MenuAppController
    final MenuAppController menuController = Get.find<MenuAppController>();

    return Scaffold(
      key: menuController.scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screens
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: Obx(() {
                // Switch between different screens based on the selected index
                switch (menuController.selectedIndex.value) {
                  case 0:
                    return const DashboardScreen();
                  case 1:
                    return const PurchaseFormScreen(); // Replace with your actual screen
                  case 2:
                    return const PartyFormScreen();
                  case 3:
                    return const SaleFormScreen();
                  case 4:
                    return const MemoIssFormScreen();
                  case 5:
                    return const MemoRecFormScreen();
                  case 6:
                    return const ExpenseFormScreen();
                  case 7:
                    return const SettingsScreen();
                    // Replace with your actual screen
                  default:
                    return const DashboardScreen();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
