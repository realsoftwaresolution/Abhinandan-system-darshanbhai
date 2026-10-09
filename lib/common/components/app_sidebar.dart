import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/assort/assort_form_screen.dart';
import 'package:real_web_rough_entry_system/assort/rough_assort_form_screen.dart';
import 'package:real_web_rough_entry_system/common/components/diamond_logo.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/controllers/theme_controller.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memoiss_form_screen.dart';
import 'package:real_web_rough_entry_system/memo%20receive/memorec_form_screen.dart';
import 'package:real_web_rough_entry_system/party-ledger/party_ledger_form_screen.dart';
import 'package:real_web_rough_entry_system/party/party_form_screen.dart';
import 'package:real_web_rough_entry_system/payment/payment_form_screen.dart';
import 'package:real_web_rough_entry_system/purchase/purchase_form_screen.dart';
import 'package:real_web_rough_entry_system/report/report_screen.dart';
import 'package:real_web_rough_entry_system/sale/sale_form_screen.dart';
import 'package:real_web_rough_entry_system/tab-view-dashboard/tab_controller.dart';
import 'package:real_web_rough_entry_system/tab-view-dashboard/tab_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Ultra-clean, modern left sidebar for Abhinandan Diamond ERP.
/// Supports seamless Light Theme and Dark Theme with high-contrast executive typography,
/// single-line menu items, smooth hover states, collapse/expand rail, and direct theme toggle.
class AppSidebar extends StatefulWidget {
  final bool isCollapsed;
  final VoidCallback onToggleCollapse;
  final bool isDrawer;

  const AppSidebar({
    super.key,
    required this.isCollapsed,
    required this.onToggleCollapse,
    this.isDrawer = false,
  });

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  late final TabControllerX _tabController;
  late final DefaultController _defaultController;

  @override
  void initState() {
    super.initState();
    _tabController = Get.isRegistered<TabControllerX>()
        ? Get.find<TabControllerX>()
        : Get.put(TabControllerX());
    _defaultController = Get.isRegistered<DefaultController>()
        ? Get.find<DefaultController>()
        : Get.put(DefaultController());
  }

  void _openTab(String label, IconData icon, Widget view) {
    if (widget.isDrawer) {
      Navigator.of(context).pop();
    }
    _tabController.isReportForm.value = false;
    _tabController.addTab(
      TabItem(
        view: view,
        label: label,
        icon: Icon(icon, size: 16),
      ),
    );
  }

  void _openDashboard() {
    if (widget.isDrawer) {
      Navigator.of(context).pop();
    }
    _tabController.tabList.clear();
    _tabController.isReportForm.value = false;
    _defaultController.enabledAdvancedDashboard.value = true;
  }

  void _handleLogout() {
    if (_tabController.tabList.isNotEmpty) {
      infoDialog(messageText: 'Please close all open tabs before logging out.');
      return;
    }

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: AppColors.isDark ? 0.6 : 0.15),
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 26),
              ),
              const SizedBox(height: 16),
              Text(
                'Confirm Logout',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to end your session?',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: BorderSide(color: AppColors.borderLight),
                      ),
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        Get.back();
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.clear();
                        Get.offAllNamed('/');
                      },
                      child: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool collapsed = widget.isDrawer ? false : widget.isCollapsed;
    final double width = widget.isDrawer ? 280 : (collapsed ? 70 : 260);

    return Obx(() {
      final isDark = ThemeController.isInitialized
          ? ThemeController.to.isDarkMode.value
          : false;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: width,
        height: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          border: Border(
            right: BorderSide(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              width: 1.0,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Clean Brand Header
            _buildBrandHeader(collapsed, isDark),

            Divider(
              height: 1,
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),

            // 2. High-Contrast Scrollable Navigation Menu Items
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: collapsed ? 8 : 10,
                  vertical: 10,
                ),
                child: Obx(() {
                  final currentLabel = _tabController.activeTabLabel;
                  final hasNoTabs = _tabController.tabList.isEmpty;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Section: MAIN
                      _buildSectionHeader('MAIN', collapsed, isDark),
                      _buildMenuItem(
                        icon: Icons.dashboard_rounded,
                        title: 'Dashboard',
                        collapsed: collapsed,
                        isActive: hasNoTabs,
                        onTap: _openDashboard,
                        isDark: isDark,
                      ),
                      _buildMenuItem(
                        icon: Icons.people_alt_rounded,
                        title: 'Party',
                        collapsed: collapsed,
                        isActive: !hasNoTabs && currentLabel == 'Party',
                        onTap: () => _openTab('Party', Icons.people_alt_rounded, const PartyFormScreen(showHeader: false)),
                        isDark: isDark,
                      ),

                      const SizedBox(height: 12),

                      // Section: OPERATIONS
                      _buildSectionHeader('OPERATIONS', collapsed, isDark),
                      _buildMenuItem(
                        icon: Icons.shopping_bag_rounded,
                        title: 'Purchase',
                        collapsed: collapsed,
                        isActive: !hasNoTabs && currentLabel == 'Purchase',
                        onTap: () => _openTab('Purchase', Icons.shopping_bag_rounded, const PurchaseFormScreen(showHeader: false)),
                        isDark: isDark,
                      ),
                      _buildMenuItem(
                        icon: Icons.sell_rounded,
                        title: 'Sale',
                        collapsed: collapsed,
                        isActive: !hasNoTabs && currentLabel == 'Sale',
                        onTap: () => _openTab('Sale', Icons.sell_rounded, const SaleFormScreen(showHeader: false)),
                        isDark: isDark,
                      ),
                      _buildMenuItem(
                        icon: Icons.checklist_rounded,
                        title: 'Memo Issue',
                        collapsed: collapsed,
                        isActive: !hasNoTabs && currentLabel == 'Memo Issue',
                        onTap: () => _openTab('Memo Issue', Icons.checklist_rounded, const MemoIssFormScreen(showHeader: false)),
                        isDark: isDark,
                      ),
                      _buildMenuItem(
                        icon: Icons.checklist_rtl_rounded,
                        title: 'Memo Rec',
                        collapsed: collapsed,
                        isActive: !hasNoTabs && (currentLabel == 'Memo Rec' || currentLabel == 'Memo Receive'),
                        onTap: () => _openTab('Memo Receive', Icons.checklist_rtl_rounded, const MemoRecFormScreen(showHeader: false)),
                        isDark: isDark,
                      ),
                      _buildMenuItem(
                        icon: Icons.payment_rounded,
                        title: 'Payment',
                        collapsed: collapsed,
                        isActive: !hasNoTabs && currentLabel == 'Payment',
                        onTap: () => _openTab('Payment', Icons.payment_rounded, const PaymentFormScreen(showHeader: false)),
                        isDark: isDark,
                      ),

                      const SizedBox(height: 12),

                      // Section: REPORTS & MASTERS
                      _buildSectionHeader('REPORTS & MASTERS', collapsed, isDark),
                      _buildMenuItem(
                        icon: Icons.receipt_long_rounded,
                        title: 'Reports',
                        collapsed: collapsed,
                        isActive: !hasNoTabs && currentLabel == 'Reports',
                        onTap: () => _openTab('Reports', Icons.receipt_long_rounded, const ReportScreen(showHeader: false)),
                        isDark: isDark,
                      ),
                      _buildMenuItem(
                        icon: Icons.account_balance_rounded,
                        title: 'Party Ledger',
                        collapsed: collapsed,
                        isActive: !hasNoTabs && currentLabel == 'Party Ledger',
                        onTap: () => _openTab('Party Ledger', Icons.account_balance_rounded, const PartyLedgerFormScreen(showHeader: false)),
                        isDark: isDark,
                      ),
                      _buildMenuItem(
                        icon: Icons.sort_rounded,
                        title: 'Assort Master',
                        collapsed: collapsed,
                        isActive: !hasNoTabs && currentLabel == 'Assort Master',
                        onTap: () => _openTab('Assort Master', Icons.sort_rounded, const AssortFormScreen(showHeader: false)),
                        isDark: isDark,
                      ),
                      _buildMenuItem(
                        icon: Icons.category_rounded,
                        title: 'Rough Assort',
                        collapsed: collapsed,
                        isActive: !hasNoTabs && currentLabel == 'Rough Assort',
                        onTap: () => _openTab('Rough Assort', Icons.category_rounded, const RoughAssortFormScreen(showHeader: false)),
                        isDark: isDark,
                      ),
                    ],
                  );
                }),
              ),
            ),

            Divider(
              height: 1,
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),

            // 3. Bottom Footer: Branch Control & User Profile
            _buildBottomSection(collapsed, isDark),
          ],
        ),
      );
    });
  }

  /// Clean Brand Header with Diamond Logo & Collapse Toggle
  Widget _buildBrandHeader(bool collapsed, bool isDark) {
    if (collapsed) {
      return Container(
        height: 64,
        alignment: Alignment.center,
        child: Tooltip(
          message: 'Expand Sidebar (Ctrl+B)',
          child: InkWell(
            onTap: widget.onToggleCollapse,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.35)
                      : const Color(0xFF1D4ED8).withValues(alpha: 0.25),
                  width: 1.2,
                ),
              ),
              child: isDark
                  ? DiamondLogo.lightOnDark(size: 24)
                  : DiamondLogo.blueOnLight(size: 24),
            ),
          ),
        ),
      );
    }

    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          // Diamond Logo Badge
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF38BDF8).withValues(alpha: 0.35)
                    : const Color(0xFF1D4ED8).withValues(alpha: 0.25),
                width: 1.2,
              ),
            ),
            child: isDark
                ? DiamondLogo.lightOnDark(size: 26)
                : DiamondLogo.blueOnLight(size: 26),
          ),
          const SizedBox(width: 10),

          // Brand Typography
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Abhinandan',
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'D I A M O N D',
                  style: TextStyle(
                    color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF1D4ED8),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 3.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Section Header (MAIN, OPERATIONS, etc.)
  Widget _buildSectionHeader(String title, bool collapsed, bool isDark) {
    if (collapsed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Divider(
          height: 1,
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 5),
      child: Text(
        title,
        style: TextStyle(
          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.3,
        ),
      ),
    );
  }

  /// Clean Single-Line Menu Item
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required bool collapsed,
    required bool isActive,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final Widget itemContent = Container(
      height: 42,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1D4ED8) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: const Color(0xFF1D4ED8).withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          hoverColor: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFF1D4ED8).withValues(alpha: 0.06),
          splashColor: const Color(0xFF38BDF8).withValues(alpha: 0.2),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: collapsed ? 0 : 12,
            ),
            child: Row(
              mainAxisAlignment:
                  collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isActive
                      ? Colors.white
                      : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                ),
                if (!collapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: isActive
                            ? Colors.white
                            : (isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B)),
                        fontSize: 13.5,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isActive)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF38BDF8),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF38BDF8),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    if (collapsed) {
      return Tooltip(
        message: title,
        preferBelow: false,
        verticalOffset: 20,
        child: itemContent,
      );
    }

    return itemContent;
  }

  /// Clean Bottom Section
  Widget _buildBottomSection(bool collapsed, bool isDark) {
    if (collapsed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Tooltip(
              message: 'Log Out',
              child: IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
                onPressed: _handleLogout,
              ),
            ),
          ],
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      color: isDark ? const Color(0xFF0A0F1D) : const Color(0xFFF8FAFC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // User Profile Row
          Row(
            children: [
              // User Avatar
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF1D4ED8), Color(0xFF0284C7)],
                  ),
                ),
                child: const Center(
                  child: Text(
                    'A',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Username
              Expanded(
                child: FutureBuilder<String?>(
                  future: getUsername(),
                  builder: (context, snapshot) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data ?? 'Admin',
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Administrator',
                          style: TextStyle(
                            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Logout Button
              IconButton(
                icon: const Icon(Icons.logout_rounded, size: 18, color: Colors.redAccent),
                tooltip: 'Log Out',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                onPressed: _handleLogout,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
