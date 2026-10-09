import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/tab-view-dashboard/tab_item.dart';

class TabControllerX extends GetxController {
  RxList<TabItem> tabList = <TabItem>[].obs; // Dynamic list of TabItem
  RxInt currentIndex = 0.obs; // Track the currently active tab
  RxInt draggingIndex = (-1).obs;
  RxBool isReportForm = false.obs;
  RxBool isSidebarCollapsed = false.obs;

  void toggleSidebar() {
    isSidebarCollapsed.value = !isSidebarCollapsed.value;
  }

  String get activeTabLabel {
    if (tabList.isEmpty || currentIndex.value < 0 || currentIndex.value >= tabList.length) {
      return 'Dashboard';
    }
    return tabList[currentIndex.value].label;
  }

  // Add a new tab dynamically
  void addTab(TabItem tab) {
    // If a tab with the same label already exists, switch to it instead of creating duplicate
    final existingIndex = tabList.indexWhere((t) => t.label == tab.label);
    if (existingIndex != -1) {
      currentIndex.value = existingIndex;
    } else {
      tabList.add(tab);
      currentIndex.value = tabList.length - 1; // Switch to the newly added tab
    }
  }

  // Remove a tab by index
  void removeTab(int index) {
    if (tabList.isNotEmpty && index >= 0 && index < tabList.length) {
      tabList.removeAt(index);
      if (currentIndex.value >= tabList.length) {
        currentIndex.value = tabList.isEmpty ? 0 : tabList.length - 1;
      }
    }
  }

  // Close current active tab
  void closeCurrentTab() {
    if (tabList.isNotEmpty && currentIndex.value >= 0 && currentIndex.value < tabList.length) {
      removeTab(currentIndex.value);
    }
  }

  // Switch to next tab
  void nextTab() {
    if (tabList.length > 1) {
      currentIndex.value = (currentIndex.value + 1) % tabList.length;
    }
  }

  // Switch to previous tab
  void previousTab() {
    if (tabList.length > 1) {
      currentIndex.value = (currentIndex.value - 1 + tabList.length) % tabList.length;
    }
  }

  // Move a tab from one index to another
  void moveTab(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= tabList.length || newIndex < 0 || newIndex >= tabList.length) {
      return;
    }

    final movedTab = tabList.removeAt(oldIndex);
    tabList.insert(newIndex, movedTab);

    if (currentIndex.value == oldIndex) {
      currentIndex.value = newIndex;
    } else if (oldIndex < currentIndex.value && newIndex >= currentIndex.value) {
      currentIndex.value--;
    } else if (oldIndex > currentIndex.value && newIndex <= currentIndex.value) {
      currentIndex.value++;
    }

    draggingIndex.value = -1;
  }
}
