import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/assort/assort_form_screen.dart';
import 'package:real_web_rough_entry_system/assort/rough_assort_form_screen.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/header.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memoiss_form_screen.dart';
import 'package:real_web_rough_entry_system/memo%20receive/memorec_form_screen.dart';
import 'package:real_web_rough_entry_system/party-ledger/party_ledger_form_screen.dart';
import 'package:real_web_rough_entry_system/party/party_form_screen.dart';
import 'package:real_web_rough_entry_system/payment/payment_form_screen.dart';
import 'package:real_web_rough_entry_system/purchase/purchase_form_screen.dart';
import 'package:real_web_rough_entry_system/report/report_screen.dart';
import 'package:real_web_rough_entry_system/responsive.dart';
import 'package:real_web_rough_entry_system/sale/sale_form_screen.dart';
import 'package:real_web_rough_entry_system/tab-view-dashboard/advanced_dashboard.dart';
import 'package:real_web_rough_entry_system/tab-view-dashboard/tab_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardWithDynamicTabs extends StatelessWidget {
  const DashboardWithDynamicTabs({super.key});

  void _openTab(String label, IconData icon, Widget view) {
    tabController.isReportForm.value = false;
    tabController.addTab(
      TabItem(
        view: view,
        label: label,
        icon: Icon(icon, size: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    final shortcuts = <ShortcutActivator, VoidCallback>{
      const SingleActivator(LogicalKeyboardKey.keyW, control: true): () {
        tabController.closeCurrentTab();
      },
      const SingleActivator(LogicalKeyboardKey.keyW, alt: true): () {
        tabController.closeCurrentTab();
      },
      const SingleActivator(LogicalKeyboardKey.tab, control: true): () {
        tabController.nextTab();
      },
      const SingleActivator(LogicalKeyboardKey.tab, control: true, shift: true): () {
        tabController.previousTab();
      },
      const SingleActivator(LogicalKeyboardKey.pageDown, control: true): () {
        tabController.nextTab();
      },
      const SingleActivator(LogicalKeyboardKey.pageUp, control: true): () {
        tabController.previousTab();
      },
    };

    return CallbackShortcuts(
      bindings: shortcuts,
      child: Focus(
        autofocus: true,
        child: Obx(
          () => Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.background,
            drawer: Responsive.isMobile(context) ? _buildMobileDrawer(context) : null,
            appBar: AppBar(
              elevation: 0.5,
              titleSpacing: Responsive.isMobile(context) ? 4 : 16,
              leading: Responsive.isMobile(context)
                  ? Builder(
                      builder: (scaffoldContext) => IconButton(
                        icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
                        tooltip: 'Open Menu',
                        onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
                      ),
                    )
                  : null,
              title: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset(
                      "assets/images/logo.svg",
                      colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Obx(
                    () => Text(
                      getCompanyName(defaultController.companyCode.value),
                      style: TextStyle(
                        fontSize: Responsive.isMobile(context) ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.white,
              actions: [
                if (!Responsive.isMobile(context)) ...[
                  _buildNavButton(
                    context: context,
                    icon: Icons.people_alt_outlined,
                    activeIcon: Icons.people_alt_rounded,
                    label: 'Party',
                    tooltip: 'Party Master',
                    onTap: () => _openTab('Party', Icons.people_alt_rounded, const PartyFormScreen(showHeader: false)),
                  ),
                  _buildNavButton(
                    context: context,
                    icon: Icons.shopping_bag_outlined,
                    activeIcon: Icons.shopping_bag_rounded,
                    label: 'Purchase',
                    tooltip: 'Purchase Entry',
                    onTap: () => _openTab('Purchase', Icons.shopping_bag_rounded, const PurchaseFormScreen(showHeader: false)),
                  ),
                  _buildNavButton(
                    context: context,
                    icon: Icons.sell_outlined,
                    activeIcon: Icons.sell_rounded,
                    label: 'Sale',
                    tooltip: 'Sale Entry',
                    onTap: () => _openTab('Sale', Icons.sell_rounded, const SaleFormScreen(showHeader: false)),
                  ),
                  _buildNavButton(
                    context: context,
                    icon: Icons.checklist_outlined,
                    activeIcon: Icons.checklist_rounded,
                    label: 'Memo Issue',
                    tooltip: 'Memo Issue',
                    onTap: () => _openTab('Memo Issue', Icons.checklist_rounded, const MemoIssFormScreen(showHeader: false)),
                  ),
                  _buildNavButton(
                    context: context,
                    icon: Icons.checklist_rtl_outlined,
                    activeIcon: Icons.checklist_rtl_rounded,
                    label: 'Memo Rec',
                    tooltip: 'Memo Receive',
                    onTap: () => _openTab('Memo Receive', Icons.checklist_rtl_rounded, const MemoRecFormScreen(showHeader: false)),
                  ),
                  _buildNavButton(
                    context: context,
                    icon: Icons.payment_outlined,
                    activeIcon: Icons.payment_rounded,
                    label: 'Payment',
                    tooltip: 'Payment Voucher',
                    onTap: () => _openTab('Payment', Icons.payment_rounded, const PaymentFormScreen(showHeader: false)),
                  ),
                  _buildNavButton(
                    context: context,
                    icon: Icons.receipt_long_outlined,
                    activeIcon: Icons.receipt_long_rounded,
                    label: 'Reports',
                    tooltip: 'Reports & Ledger',
                    isActive: tabController.isReportForm.value,
                    onTap: () {
                      tabController.isReportForm.value = !tabController.isReportForm.value;
                    },
                  ),
                ],
                if (Responsive.isDesktop(context)) ...[
                  const SizedBox(width: 8),
                  const SizedBox(width: 160, child: SearchField()),
                ],
                const SizedBox(width: 8),
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_rounded, size: 20, color: AppColors.primary),
                  ),
                  tooltip: 'Account Menu',
                  onPressed: () => _showAccountMenu(context),
                ),
                const SizedBox(width: 8),
              ],
              bottom: tabController.isReportForm.value
                  ? PreferredSize(
                      preferredSize: const Size.fromHeight(48),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F5F9),
                          border: Border(top: BorderSide(color: AppColors.borderLight)),
                        ),
                        child: Row(
                          children: [
                            _buildSubNavButton(
                              icon: Icons.receipt_long_rounded,
                              label: 'Reports',
                              onTap: () => _openTab('Reports', Icons.receipt_long_rounded, const ReportScreen(showHeader: false)),
                            ),
                            const SizedBox(width: 8),
                            _buildSubNavButton(
                              icon: Icons.account_balance_rounded,
                              label: 'Party Ledger',
                              onTap: () => _openTab('Party Ledger', Icons.account_balance_rounded, const PartyLedgerFormScreen(showHeader: false)),
                            ),
                            const SizedBox(width: 8),
                            _buildSubNavButton(
                              icon: Icons.sort_rounded,
                              label: 'Assort Master',
                              onTap: () => _openTab('Assort Master', Icons.sort_rounded, const AssortFormScreen(showHeader: false)),
                            ),
                          ],
                        ),
                      ),
                    )
                  : null,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Modern Tab Bar Strip
                Obx(() {
                  if (tabController.tabList.isEmpty) return const SizedBox.shrink();

                  return Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      border: Border(bottom: BorderSide(color: AppColors.borderLight, width: 1)),
                    ),
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                    child: Listener(
                      onPointerSignal: (pointerSignal) {
                        if (pointerSignal is PointerScrollEvent) {
                          scrollController.jumpTo(
                            (scrollController.offset + pointerSignal.scrollDelta.dy).clamp(
                              0.0,
                              scrollController.position.maxScrollExtent,
                            ),
                          );
                        }
                      },
                      child: SingleChildScrollView(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            tabController.tabList.length,
                            (i) => Obx(() {
                              final isSelected = tabController.currentIndex.value == i;
                              final item = tabController.tabList[i];

                              return LongPressDraggable<int>(
                                data: i,
                                axis: Axis.horizontal,
                                onDragStarted: () => tabController.draggingIndex.value = i,
                                onDraggableCanceled: (_, __) => tabController.draggingIndex.value = -1,
                                onDragCompleted: () => tabController.draggingIndex.value = -1,
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.15),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        item.icon,
                                        const SizedBox(width: 8),
                                        Text(item.label, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                                child: DragTarget<int>(
                                  onWillAcceptWithDetails: (_) => true,
                                  onAcceptWithDetails: (details) {
                                    tabController.moveTab(details.data, i);
                                  },
                                  builder: (context, _, __) {
                                    return InkWell(
                                      onTap: () {
                                        tabController.currentIndex.value = i;
                                      },
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 4),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          color: isSelected ? Colors.white : Colors.transparent,
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                          border: isSelected
                                              ? Border.all(color: AppColors.borderLight, width: 1)
                                              : null,
                                        ),
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconTheme(
                                                    data: IconThemeData(
                                                      size: 15,
                                                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                                    ),
                                                    child: item.icon,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    item.label,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  InkWell(
                                                    borderRadius: BorderRadius.circular(10),
                                                    onTap: () => tabController.removeTab(i),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(2.0),
                                                      child: Icon(
                                                        Icons.close_rounded,
                                                        size: 14,
                                                        color: isSelected ? AppColors.textSecondary : AppColors.textMuted,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (isSelected)
                                              Positioned(
                                                top: 0,
                                                left: 0,
                                                right: 0,
                                                child: Container(
                                                  height: 2.5,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  );
                }),

                // Active Tab Content or Dashboard
                Expanded(
                  child: Obx(() {
                    if (tabController.tabList.isNotEmpty) {
                      return IndexedStack(
                        index: tabController.currentIndex.value,
                        children: tabController.tabList.map((tab) => tab.view).toList(),
                      );
                    }

                    if (defaultController.enabledAdvancedDashboard.value) {
                      return const AdvancedDashboard();
                    }

                    // Modern Welcome Empty State
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SvgPicture.asset(
                              "assets/images/logo.svg",
                              colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Abhinandan Diamond ERP',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Select a module from the top navigation bar to begin data entry.',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 8,
                            children: [
                              _buildQuickActionButton(
                                icon: Icons.shopping_bag_outlined,
                                label: 'Purchase Entry',
                                onTap: () => _openTab('Purchase', Icons.shopping_bag_rounded, const PurchaseFormScreen(showHeader: false)),
                              ),
                              _buildQuickActionButton(
                                icon: Icons.category_outlined,
                                label: 'Rough Assort',
                                onTap: () => _openTab('Rough Assort', Icons.category_rounded, const RoughAssortFormScreen(showHeader: false)),
                              ),
                              _buildQuickActionButton(
                                icon: Icons.sell_outlined,
                                label: 'Sale Entry',
                                onTap: () => _openTab('Sale', Icons.sell_rounded, const SaleFormScreen(showHeader: false)),
                              ),
                              _buildQuickActionButton(
                                icon: Icons.payment_outlined,
                                label: 'Payment Voucher',
                                onTap: () => _openTab('Payment', Icons.payment_rounded, const PaymentFormScreen(showHeader: false)),
                              ),
                              _buildQuickActionButton(
                                icon: Icons.account_balance_outlined,
                                label: 'Party Ledger',
                                onTap: () => _openTab('Party Ledger', Icons.account_balance_rounded, const PartyLedgerFormScreen(showHeader: false)),
                              ),
                              _buildQuickActionButton(
                                icon: Icons.receipt_long_outlined,
                                label: 'Reports',
                                onTap: () => _openTab('Reports', Icons.receipt_long_rounded, const ReportScreen(showHeader: false)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),

            // Modern Sleek Status Bar
            bottomNavigationBar: Container(
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
                border: Border(top: BorderSide(color: Color(0xFF334155), width: 0.5)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.person_outline_rounded, color: Color(0xFF94A3B8), size: 14),
                      const SizedBox(width: 4),
                      FutureBuilder<String?>(
                        future: getUsername(),
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.data ?? 'Admin',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                          );
                        },
                      ),
                    ],
                  ),
                  if (!Responsive.isMobile(context)) ...[
                    const SizedBox(width: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.cloud_done_outlined, color: Color(0xFF38BDF8), size: 14),
                        const SizedBox(width: 4),
                        Text(
                          defaultController.baseUrl.split('//').last.split('/').first,
                          style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 11),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Text(
                      'Shortcuts: Ctrl+W: Close Tab | Ctrl+Tab: Switch Tab | Alt+A: Add | Alt+S: Save',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 10),
                    ),
                    const SizedBox(width: 16),
                  ] else ...[
                    const Spacer(),
                  ],
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today_outlined, color: Color(0xFF94A3B8), size: 12),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd-MM-yyyy').format(DateTime.now()),
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time_rounded, color: Color(0xFF94A3B8), size: 12),
                      const SizedBox(width: 4),
                      StreamBuilder(
                        stream: Stream.periodic(const Duration(seconds: 1)),
                        builder: (context, snapshot) {
                          return Text(
                            DateFormat('hh:mm:ss a').format(DateTime.now()),
                            style: const TextStyle(color: Colors.white, fontSize: 11),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String tooltip,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    final isTablet = Responsive.isTablet(context);
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 7 : 10, vertical: 6),
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(isActive ? activeIcon : icon, size: 18, color: isActive ? AppColors.primary : AppColors.textPrimary),
              if (!isTablet) ...[
                const SizedBox(width: 5),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A), // Slate 900
                border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SvgPicture.asset(
                      "assets/images/logo.svg",
                      colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            getCompanyName(defaultController.companyCode.value),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Abhinandan Diamond ERP',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Modules Navigation List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                children: [
                  _buildDrawerItem(
                    icon: Icons.dashboard_rounded,
                    title: 'Dashboard',
                    subtitle: 'Financial overview & KPIs',
                    onTap: () {
                      Navigator.pop(context);
                      tabController.tabList.clear();
                      tabController.isReportForm.value = false;
                      defaultController.enabledAdvancedDashboard.value = true;
                    },
                  ),
                  const Divider(height: 16, color: AppColors.borderLight),
                  _buildDrawerItem(
                    icon: Icons.people_alt_rounded,
                    title: 'Party Master',
                    subtitle: 'Manage client & vendor accounts',
                    onTap: () {
                      Navigator.pop(context);
                      _openTab('Party', Icons.people_alt_rounded, const PartyFormScreen(showHeader: false));
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.shopping_bag_rounded,
                    title: 'Purchase Entry',
                    subtitle: 'Rough diamond purchases',
                    onTap: () {
                      Navigator.pop(context);
                      _openTab('Purchase', Icons.shopping_bag_rounded, const PurchaseFormScreen(showHeader: false));
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.sell_rounded,
                    title: 'Sale Entry',
                    subtitle: 'Customer invoice & sales',
                    onTap: () {
                      Navigator.pop(context);
                      _openTab('Sale', Icons.sell_rounded, const SaleFormScreen(showHeader: false));
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.checklist_rounded,
                    title: 'Memo Issue',
                    subtitle: 'Issue parcels on approval/memo',
                    onTap: () {
                      Navigator.pop(context);
                      _openTab('Memo Issue', Icons.checklist_rounded, const MemoIssFormScreen(showHeader: false));
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.checklist_rtl_rounded,
                    title: 'Memo Receive',
                    subtitle: 'Receive parcels on memo',
                    onTap: () {
                      Navigator.pop(context);
                      _openTab('Memo Receive', Icons.checklist_rtl_rounded, const MemoRecFormScreen(showHeader: false));
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.payment_rounded,
                    title: 'Payment Voucher',
                    subtitle: 'Bank & cash payments/receipts',
                    onTap: () {
                      Navigator.pop(context);
                      _openTab('Payment', Icons.payment_rounded, const PaymentFormScreen(showHeader: false));
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.receipt_long_rounded,
                    title: 'Reports & Inquiries',
                    subtitle: 'Stock, ledger & outstanding reports',
                    onTap: () {
                      Navigator.pop(context);
                      _openTab('Reports', Icons.receipt_long_rounded, const ReportScreen(showHeader: false));
                    },
                  ),
                ],
              ),
            ),

            // Drawer Bottom Options
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                border: Border(top: BorderSide(color: AppColors.borderLight)),
              ),
              child: ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                leading: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.business_rounded, size: 18, color: AppColors.primary),
                ),
                title: const Text('Switch Company', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.textMuted),
                onTap: () {
                  Navigator.pop(context);
                  _showProfileOptionsDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      dense: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
      ),
      onTap: onTap,
    );
  }

  Widget _buildSubNavButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        side: const BorderSide(color: AppColors.borderLight),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      icon: Icon(icon, size: 15, color: AppColors.primary),
      label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      onPressed: onTap,
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ActionChip(
      avatar: Icon(icon, size: 16, color: AppColors.primary),
      label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      backgroundColor: Colors.white,
      side: const BorderSide(color: AppColors.borderLight),
      onPressed: onTap,
    );
  }

  void _showProfileOptionsDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.business_rounded, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getCompanyName(defaultController.companyCode.value),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            getCompanyDetails(defaultController.companyCode.value).mobileno ?? '',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Text(
                    getCompanyDetails(defaultController.companyCode.value).address ?? 'No Address',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Get.back(),
                      child: const Text('Close'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                      onPressed: () {
                        if (tabController.tabList.isEmpty) {
                          _logout();
                          Get.back();
                        } else {
                          infoDialog(messageText: 'Please close all open tabs before logging out.');
                        }
                      },
                      icon: const Icon(Icons.logout_rounded, size: 16, color: Colors.white),
                      label: const Text('Logout', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed('/');
  }

  void _showAccountMenu(BuildContext context) async {
    await showMenu(
      context: context,
      color: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      position: const RelativeRect.fromLTRB(10, 50, 0, 0),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getCompanyName(defaultController.companyCode.value),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
              ),
              Text(
                getCompanyDetails(defaultController.companyCode.value).mobileno ?? '',
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          child: const ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.swap_horiz_rounded, size: 20),
            title: Text('Switch Company', style: TextStyle(fontSize: 13)),
          ),
          onTap: () {
            Future.delayed(Duration.zero, () {
              showCompanySelectionDialog(isFromSwitchCompany: true);
            });
          },
        ),
        PopupMenuItem(
          child: const ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.person_outline_rounded, size: 20),
            title: Text('Company Profile', style: TextStyle(fontSize: 13)),
          ),
          onTap: () {
            Future.delayed(Duration.zero, () {
              if (context.mounted) {
                _showProfileOptionsDialog(context);
              }
            });
          },
        ),
        PopupMenuItem(
          child: const ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.settings_outlined, size: 20),
            title: Text('Settings', style: TextStyle(fontSize: 13)),
          ),
          onTap: () {
            Future.delayed(Duration.zero, () {
              if (context.mounted) {
                showSettingsDialog(context);
              }
            });
          },
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          child: const ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.logout_rounded, color: AppColors.danger, size: 20),
            title: Text('Log out', style: TextStyle(fontSize: 13, color: AppColors.danger, fontWeight: FontWeight.bold)),
          ),
          onTap: () {
            if (tabController.tabList.isEmpty) {
              _logout();
            } else {
              infoDialog(messageText: 'Please close all open tabs before logging out.');
            }
          },
        ),
      ],
    );
  }
}
