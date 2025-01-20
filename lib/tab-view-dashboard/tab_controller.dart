// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:real_web_rough_entry_system/tab-view-dashboard/tab_item.dart';
//
// // Controller to manage tab views dynamically
// class TabControllerX extends GetxController {
//   var tabList = <TabItem>[].obs;  // Dynamic list of TabItem
//   var currentIndex = 0.obs;      // Track the currently active tab
//
//   // Add a new tab dynamically
//   void addTab(TabItem tab) {
//     tabList.add(tab);
//     currentIndex.value = tabList.length - 1;  // Switch to the newly added tab
//   }
//
//   // Remove a tab by index
//   void removeTab(int index) {
//     if (tabList.isNotEmpty && index < tabList.length) {
//       tabList.removeAt(index);
//       if (currentIndex.value >= tabList.length) {
//         currentIndex.value = tabList.length - 1;
//       }
//     }
//   }
//
//   // Move a tab from one index to another
//   void moveTab(int oldIndex, int newIndex) {
//     if (oldIndex < 0 || oldIndex >= tabList.length || newIndex < 0 || newIndex >= tabList.length) {
//       return;  // Ensure indices are valid
//     }
//
//     // Move the tab item
//     final movedTab = tabList.removeAt(oldIndex);
//     tabList.insert(newIndex, movedTab);
//
//     // Update currentIndex if necessary
//     if (currentIndex.value == oldIndex) {
//       // If the current tab was moved, update its index
//       currentIndex.value = newIndex;
//     } else if (oldIndex < currentIndex.value && newIndex >= currentIndex.value) {
//       // Shift currentIndex down if a tab before the current tab was moved to after it
//       currentIndex.value--;
//     } else if (oldIndex > currentIndex.value && newIndex <= currentIndex.value) {
//       // Shift currentIndex up if a tab after the current tab was moved to before it
//       currentIndex.value++;
//     }
//   }
// }

import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/tab-view-dashboard/tab_item.dart';

class TabControllerX extends GetxController {
  RxList<TabItem> tabList = <TabItem>[].obs;  // Dynamic list of TabItem
  RxInt currentIndex = 0.obs;       // Track the currently active tab
  RxInt draggingIndex = (-1).obs;
  RxBool isReportForm = false.obs;
  // RxBool isPArtyLedgerForm = false.obs;
  // Track the index of the tab being dragged

  // Add a new tab dynamically
  void addTab(TabItem tab) {
    tabList.add(tab);
    currentIndex.value = tabList.length - 1;  // Switch to the newly added tab
  }

  // Remove a tab by index
  void removeTab(int index) {
    if (tabList.isNotEmpty && index < tabList.length) {
      tabList.removeAt(index);
      if (currentIndex.value >= tabList.length) {
        currentIndex.value = tabList.length - 1;
      }
    }
  }

  // Move a tab from one index to another
  void moveTab(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= tabList.length || newIndex < 0 || newIndex >= tabList.length) {
      return;
    }

    // Move the tab item
    final movedTab = tabList.removeAt(oldIndex);
    tabList.insert(newIndex, movedTab);

    // Update currentIndex if necessary
    if (currentIndex.value == oldIndex) {
      currentIndex.value = newIndex;
    } else if (oldIndex < currentIndex.value && newIndex >= currentIndex.value) {
      currentIndex.value--;
    } else if (oldIndex > currentIndex.value && newIndex <= currentIndex.value) {
      currentIndex.value++;
    }

    // Reset dragging index after the move
    draggingIndex.value = -1;
  }
}
