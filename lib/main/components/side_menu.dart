import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/controllers/menu_app_controller.dart';

class SideMenu extends StatelessWidget {
  final MenuAppController menuController = Get.find<MenuAppController>();

  SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: ListView(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(30),
            margin: const EdgeInsets.all(30),
            child: SvgPicture.asset(
                "assets/images/logo.svg",
                height: 20,
                // color: Colors.black54,
              ),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              menuController.setSelectedIndex(0);
              Get.back();
            },
          ),
          DrawerListTile(
            title: "Purchase",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              menuController.setSelectedIndex(1);
              Get.back();
            },
          ),
          DrawerListTile(
            title: "Party",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              menuController.setSelectedIndex(2);
              Get.back();
            },
          ),
          DrawerListTile(
            title: "Sale",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {
              menuController.setSelectedIndex(3);
              Get.back();
            },
          ),
          DrawerListTile(
            title: "Memo Iss",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              menuController.setSelectedIndex(4);
              Get.back();
            },
          ),
          DrawerListTile(
            title: "Memo Rec",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {
              menuController.setSelectedIndex(5);
              Get.back();
            },
          ),
          DrawerListTile(
            title: "Expense",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              menuController.setSelectedIndex(6);
              Get.back();
            },
          ),
          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {
              menuController.setSelectedIndex(7);
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    // For selecting those three line once press "Command+D"
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
