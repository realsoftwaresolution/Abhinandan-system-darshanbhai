import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/tab-view-dashboard/dashboard_with_tab.dart';
// Import other screens as needed

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DefaultController defaultController = Get.find<DefaultController>();

    return Scaffold(
      key: defaultController.scaffoldKey,
      body: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: DashboardWithDynamicTabs(),
          ),
        ],
      ),
    );
  }
}
