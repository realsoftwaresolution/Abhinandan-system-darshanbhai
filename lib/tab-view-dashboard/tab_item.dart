// import 'package:flutter/material.dart';
//
// class TabItem {
//   final Widget view;
//   final String label;
//   TabItem({required this.view, required this.label});
// }

import 'package:flutter/material.dart';

class TabItem {
  final Widget view;
  final String label;
  final Widget icon;
  TabItem({required this.view, required this.label, required this.icon});
}

// class TabControllerX extends GetxController {
//   RxList<TabItem> tabList = <TabItem>[].obs;
//   RxInt currentIndex = 0.obs;
//
//   void addTab(TabItem tab) {
//     tabList.add(tab);
//   }
//
//   void removeTab(int index) {
//     tabList.removeAt(index);
//     if (currentIndex.value >= tabList.length) {
//       currentIndex.value = tabList.length - 1;
//     }
//   }
// }