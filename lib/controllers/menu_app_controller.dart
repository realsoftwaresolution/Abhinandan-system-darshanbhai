import 'package:get/get.dart';

class MenuAppController extends GetxController {
  static MenuAppController get to => Get.find<MenuAppController>();

  /// Tracks which MainMenuMstID groups are currently expanded in the sidebar accordion
  final RxSet<int> expandedMenuIds = <int>{1, 2}.obs; // MASTER (1) and TRANSACTION (2) expanded by default

  /// Search query for filtering menu items if user searches
  final RxString searchQuery = ''.obs;

  void toggleExpand(int menuId) {
    if (expandedMenuIds.contains(menuId)) {
      expandedMenuIds.remove(menuId);
    } else {
      expandedMenuIds.add(menuId);
    }
  }

  bool isExpanded(int menuId) => expandedMenuIds.contains(menuId);

  void expandAll(Iterable<int> menuIds) {
    expandedMenuIds.addAll(menuIds);
  }

  void collapseAll() {
    expandedMenuIds.clear();
  }
}
