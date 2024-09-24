import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/controllers/menu_app_controller.dart';

// Model for Drawer Items
class DrawerItem {
  final String title;
  final String svgSrc;
  final int index;

  DrawerItem({
    required this.title,
    required this.svgSrc,
    required this.index,
  });
}

class SideMenu extends StatelessWidget {
  final MenuAppController menuController = Get.find<MenuAppController>();

  SideMenu({super.key});

  // List of Menu Items
  final List<DrawerItem> drawerItems = [
    DrawerItem(title: "Dashboard", svgSrc: "assets/icons/menu_dashboard.svg", index: 0),
    DrawerItem(title: "Purchase", svgSrc: "assets/icons/menu_tran.svg", index: 1),
    DrawerItem(title: "Party", svgSrc: "assets/icons/menu_task.svg", index: 2),
    DrawerItem(title: "Sale", svgSrc: "assets/icons/menu_doc.svg", index: 3),
    DrawerItem(title: "Memo Iss", svgSrc: "assets/icons/menu_store.svg", index: 4),
    DrawerItem(title: "Memo Rec", svgSrc: "assets/icons/menu_notification.svg", index: 5),
    DrawerItem(title: "Expense", svgSrc: "assets/icons/menu_profile.svg", index: 6),
    DrawerItem(title: "Settings", svgSrc: "assets/icons/menu_setting.svg", index: 7),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Column(
        children: [
          // Small Drawer Header
          SizedBox(
            height: 100, // Adjusted height for a smaller header
            child: DrawerHeader(
              padding: const EdgeInsets.symmetric(horizontal: 10), // Reduced padding
              margin: EdgeInsets.zero, // No margin to save space
              child: SvgPicture.asset(
                "assets/images/logo.svg",
                height: 50, // Reduced logo size to fit smaller header
              ),
            ),
          ),
          // Dynamic List of Menu Items
          Expanded(
            child: ListView.builder(
              itemCount: drawerItems.length,
              itemBuilder: (context, index) {
                final item = drawerItems[index];
                return DrawerListTile(
                  title: item.title,
                  svgSrc: item.svgSrc,
                  press: () {
                    menuController.setSelectedIndex(item.index);
                    Get.back();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable DrawerListTile Widget
class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.svgSrc,
    required this.press,
  });

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black54),
      ),
    );
  }
}
