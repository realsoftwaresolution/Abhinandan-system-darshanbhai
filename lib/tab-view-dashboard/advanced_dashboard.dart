import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/common/components/app_data_grid.dart';
import 'package:real_web_rough_entry_system/common/utils/currency_formatter.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/purchase/outstanding_purchase_details.dart';
import 'package:real_web_rough_entry_system/tab-view-dashboard/dashboard_kpi_card.dart';
import 'package:real_web_rough_entry_system/tab-view-dashboard/list_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AdvancedDashboard extends StatefulWidget {
  const AdvancedDashboard({super.key});

  @override
  State<AdvancedDashboard> createState() => _AdvancedDashboardState();
}

class _AdvancedDashboardState extends State<AdvancedDashboard> {
  // Overdue view state
  bool _isOverdueTableView = false;
  String _overdueFilterType = 'All'; // 'All', 'Purchase', 'Sale'
  String _overdueAgingFilter = 'All'; // 'All', '< 30d', '30-90d', '> 90d'
  final TextEditingController _overdueSearchController = TextEditingController();
  String _overdueSearchQuery = '';

  // Upcoming view state
  bool _isUpcomingTableView = false;
  String _upcomingFilterType = 'All'; // 'All', 'Purchase', 'Sale'
  String _upcomingRangeFilter = 'All'; // 'All', '7 Days', '15 Days', '30 Days'
  final TextEditingController _upcomingSearchController = TextEditingController();
  String _upcomingSearchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (defaultController.outstandingPurchaseSaleDetailsList.isEmpty) {
        defaultController.getOutstandingPurchaseSaleDetails();
      }
      if (defaultController.partyMstList.isEmpty) {
        defaultController.getPartyData();
      }
      if (defaultController.creditDebitDataList.isEmpty) {
        defaultController.getCreditDebitData();
      }
    });
  }

  @override
  void dispose() {
    _overdueSearchController.dispose();
    _upcomingSearchController.dispose();
    super.dispose();
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.background,
        body: defaultController.isLoadingDashboardData.value &&
                defaultController.outstandingPurchaseSaleDetailsList.isEmpty
            ? _buildLoadingState()
            : RefreshIndicator(
                onRefresh: () async {
                  await defaultController.getOutstandingPurchaseSaleDetails();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Header Bar
                      _buildDashboardHeader(),
                      const SizedBox(height: 16),

                      // Top KPI Summary Cards Row
                      _buildKpiSummarySection(),
                      const SizedBox(height: 20),

                      // Today's Payments (Smart banner or priority cards)
                      _buildTodayPaymentSection(),
                      const SizedBox(height: 24),

                      // Overdue Payments Section
                      _buildOverduePaymentSection(),
                      const SizedBox(height: 24),

                      // Upcoming Payments Section
                      _buildUpcomingPaymentSection(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // ==================== TOP DASHBOARD HEADER ====================

  Widget _buildDashboardHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;
        final refreshButton = OutlinedButton.icon(
          onPressed: () {
            defaultController.getOutstandingPurchaseSaleDetails();
          },
          icon: defaultController.isLoadingDashboardData.value
              ? SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                )
              : const Icon(Icons.refresh_rounded, size: 16),
          label: const Text('Refresh', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.borderLight),
            backgroundColor: AppColors.cardBg,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Financial Dashboard',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildLiveBadge(),
                    ],
                  ),
                  refreshButton,
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Real-time overview of outstandings & liquid balances.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Financial Dashboard',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildLiveBadge(),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Real-time overview of outstandings, liquid balances, and payment schedules.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            refreshButton,
          ],
        );
      },
    );
  }

  Widget _buildLiveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.success,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            'Live',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== TOP KPI SUMMARY SECTION ====================

  Widget _buildKpiSummarySection() {
    final allDetails = defaultController.outstandingPurchaseSaleDetailsList;

    // Purchase calculations
    final purchaseList = allDetails.where((e) => e.trnType == 'Purchase').toList();
    final double totalOutAmtPur = purchaseList.fold(
      0.0,
      (sum, item) => sum + ((item.bAmtRs is num) ? (item.bAmtRs as num).toDouble() : 0.0),
    );

    // Sale calculations
    final saleList = allDetails.where((e) => e.trnType == 'Sale').toList();
    final double totalOutAmtSale = saleList.fold(
      0.0,
      (sum, item) => sum + ((item.bAmtRs is num) ? (item.bAmtRs as num).toDouble() : 0.0),
    );

    // Cash and Bank accounts data
    final cashBankData = <Map<String, dynamic>>[];
    for (final partyType in defaultController.partyMstList) {
      if (partyType.typeCode == 3 ||
          (partyType.typeCode == 4 && partyType.companyCode == defaultController.companyCode.value)) {
        final partyTransactions = defaultController.creditDebitDataList
            .where((cd) => cd.partyCode == partyType.partyCode)
            .toList();

        final double sumCredit = partyTransactions.fold(
            0.0, (prev, cd) => prev + ((cd.creditRs is num) ? (cd.creditRs as num).toDouble() : 0.0));
        final double sumDebit = partyTransactions.fold(
            0.0, (prev, cd) => prev + ((cd.debitRs is num) ? (cd.debitRs as num).toDouble() : 0.0));

        final double opBalCr = (partyType.creditOpBalRs is num) ? (partyType.creditOpBalRs as num).toDouble() : 0.0;
        final double opBalDr = (partyType.debitOpBalRs is num) ? (partyType.debitOpBalRs as num).toDouble() : 0.0;

        final double balance = (sumCredit - sumDebit) + (opBalCr - opBalDr);
        final isCash = partyType.typeCode == 3;
        final partyName = getPartyName(partyType.partyCode);

        cashBankData.add({
          'title': partyName,
          'amount': balance,
          'icon': isCash ? Icons.account_balance_wallet_outlined : Icons.account_balance_outlined,
          'accentColor': isCash ? const Color(0xFF0284C7) : const Color(0xFF0D9488),
          'badgeText': isCash ? 'CASH' : 'BANK',
          'badgeColor': isCash ? const Color(0xFF0284C7) : const Color(0xFF0D9488),
          'subtitle': balance >= 0 ? 'Current Balance' : 'Overdrawn / Negative',
        });
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // Responsive card columns:
        // Mobile (< 650px): 1 column (100% width)
        // Tablet (650px - 1050px): 2 columns
        // Small Desktop (1050px - 1400px): 3 columns
        // Large Desktop (>= 1400px): 4 columns
        final int columns = width < 650
            ? 1
            : (width < 1050
                ? 2
                : (width < 1400 ? 3 : 4));
        const spacing = 12.0;
        final cardWidth = (width - (columns - 1) * spacing) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            // Purchase Outstanding Card
            SizedBox(
              width: cardWidth,
              child: DashboardKpiCard(
                title: 'Purchase Outstanding',
                amount: totalOutAmtPur,
                icon: Icons.shopping_bag_outlined,
                accentColor: const Color(0xFFEA580C), // Amber/Orange
                badgeText: '${purchaseList.length} Invoices',
                badgeColor: const Color(0xFFEA580C),
                subtitle: 'Total unpaid supplier invoices',
              ),
            ),

            // Sale Outstanding Card
            SizedBox(
              width: cardWidth,
              child: DashboardKpiCard(
                title: 'Sale Outstanding',
                amount: totalOutAmtSale,
                icon: Icons.sell_outlined,
                accentColor: AppColors.primary, // Royal Blue
                badgeText: '${saleList.length} Invoices',
                badgeColor: AppColors.primary,
                subtitle: 'Total pending customer payments',
              ),
            ),

            // Net Balance (Receivable - Payable)
            SizedBox(
              width: cardWidth,
              child: DashboardKpiCard(
                title: 'Net Outstandings',
                amount: totalOutAmtSale - totalOutAmtPur,
                icon: Icons.swap_horiz_rounded,
                accentColor: (totalOutAmtSale - totalOutAmtPur) >= 0
                    ? AppColors.success
                    : AppColors.danger,
                badgeText: (totalOutAmtSale - totalOutAmtPur) >= 0 ? 'SURPLUS' : 'DEFICIT',
                badgeColor: (totalOutAmtSale - totalOutAmtPur) >= 0
                    ? AppColors.success
                    : AppColors.danger,
                subtitle: (totalOutAmtSale - totalOutAmtPur) >= 0
                    ? 'Receivables exceed payables'
                    : 'Payables exceed receivables',
              ),
            ),

            // Cash and Bank Cards
            for (final cb in cashBankData)
              SizedBox(
                width: cardWidth,
                child: DashboardKpiCard(
                  title: cb['title'] as String,
                  amount: cb['amount'] as double,
                  icon: cb['icon'] as IconData,
                  accentColor: cb['accentColor'] as Color,
                  badgeText: cb['badgeText'] as String,
                  badgeColor: cb['badgeColor'] as Color,
                  subtitle: cb['subtitle'] as String,
                ),
              ),
          ],
        );
      },
    );
  }

  // ==================== TODAY'S PAYMENTS SECTION ====================

  Widget _buildTodayPaymentSection() {
    final today = DateTime.now();
    final allDetails = defaultController.outstandingPurchaseSaleDetailsList;

    final todayPayments = allDetails.where((details) {
      if (details.dueDate == null) return false;
      final dueDate = DateTime.tryParse(details.dueDate!);
      return dueDate != null && _isSameDate(dueDate, today);
    }).toList();

    // If no payments today: show smart, sleek compact banner
    if (todayPayments.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                color: AppColors.success,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "No Payments Due Today",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    "All bills and collections are up to date for ${DateFormat('dd MMMM yyyy').format(today)}.",
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Text(
                '0 Due Today',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // If payments are due today: display them prominently!
    final double todayTotal = todayPayments.fold(
      0.0,
      (sum, item) => sum + ((item.bAmtRs is num) ? (item.bAmtRs as num).toDouble() : 0.0),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: "Today's Payments",
          icon: Icons.today_rounded,
          count: todayPayments.length,
          totalAmount: todayTotal,
          badgeColor: AppColors.warning,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 145,
          child: HorizontalListWithArrows(payments: todayPayments),
        ),
      ],
    );
  }

  // ==================== OVERDUE PAYMENTS SECTION ====================

  Widget _buildOverduePaymentSection() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final allDetails = defaultController.outstandingPurchaseSaleDetailsList;

    // Extract all overdue payments
    final overdueList = allDetails.where((details) {
      if (details.dueDate == null) return false;
      final dueDate = DateTime.tryParse(details.dueDate!);
      if (dueDate == null) return false;
      final targetDate = DateTime(dueDate.year, dueDate.month, dueDate.day);
      return targetDate.isBefore(todayDate);
    }).toList();

    // Sort by oldest overdue first
    overdueList.sort((a, b) {
      final da = DateTime.tryParse(a.dueDate ?? '') ?? DateTime.now();
      final db = DateTime.tryParse(b.dueDate ?? '') ?? DateTime.now();
      return da.compareTo(db);
    });

    // Apply Filters
    List<OutstandingPurchaseSaleDetails> filteredList = overdueList.where((p) {
      // Type filter
      if (_overdueFilterType == 'Purchase' && p.trnType != 'Purchase') return false;
      if (_overdueFilterType == 'Sale' && p.trnType != 'Sale') return false;

      // Aging filter
      final dueDate = DateTime.tryParse(p.dueDate ?? '');
      if (dueDate != null) {
        final daysOverdue = todayDate.difference(DateTime(dueDate.year, dueDate.month, dueDate.day)).inDays;
        if (_overdueAgingFilter == '< 30d' && daysOverdue >= 30) return false;
        if (_overdueAgingFilter == '30-90d' && (daysOverdue < 30 || daysOverdue > 90)) return false;
        if (_overdueAgingFilter == '> 90d' && daysOverdue <= 90) return false;
      }

      // Search query
      if (_overdueSearchQuery.isNotEmpty) {
        final q = _overdueSearchQuery.toLowerCase();
        final partyMatch = (p.partyName ?? '').toLowerCase().contains(q);
        final invMatch = (p.invNo ?? '').toLowerCase().contains(q);
        if (!partyMatch && !invMatch) return false;
      }

      return true;
    }).toList();

    final double totalOverdue = filteredList.fold(
      0.0,
      (sum, item) => sum + ((item.bAmtRs is num) ? (item.bAmtRs as num).toDouble() : 0.0),
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header Bar with Badges & Controls
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _buildSectionHeader(
                  title: 'Overdue Payments',
                  icon: Icons.error_outline_rounded,
                  count: filteredList.length,
                  totalAmount: totalOverdue,
                  badgeColor: AppColors.danger,
                ),
              ),

              // View Toggle: Cards vs Table
              _buildViewModeToggle(
                isTableView: _isOverdueTableView,
                onToggle: (val) => setState(() => _isOverdueTableView = val),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Filters & Search Bar
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 850;
              final filterChips = [
                _buildFilterChip('All', _overdueFilterType == 'All', () {
                  setState(() => _overdueFilterType = 'All');
                }),
                _buildFilterChip('Purchase', _overdueFilterType == 'Purchase', () {
                  setState(() => _overdueFilterType = 'Purchase');
                }),
                _buildFilterChip('Sale', _overdueFilterType == 'Sale', () {
                  setState(() => _overdueFilterType = 'Sale');
                }),
                if (!isCompact) ...[
                  const SizedBox(width: 6),
                  Container(width: 1, height: 20, color: AppColors.borderLight),
                  const SizedBox(width: 6),
                ],
                _buildFilterChip('All Ages', _overdueAgingFilter == 'All', () {
                  setState(() => _overdueAgingFilter = 'All');
                }),
                _buildFilterChip('< 30d', _overdueAgingFilter == '< 30d', () {
                  setState(() => _overdueAgingFilter = '< 30d');
                }),
                _buildFilterChip('30–90d', _overdueAgingFilter == '30-90d', () {
                  setState(() => _overdueAgingFilter = '30-90d');
                }),
                _buildFilterChip('> 90d', _overdueAgingFilter == '> 90d', () {
                  setState(() => _overdueAgingFilter = '> 90d');
                }),
              ];

              final searchInput = SizedBox(
                width: isCompact ? double.infinity : 200,
                height: 32,
                child: TextField(
                  controller: _overdueSearchController,
                  onChanged: (val) => setState(() => _overdueSearchQuery = val),
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'Search invoice / party...',
                    hintStyle: TextStyle(fontSize: 11, color: AppColors.textMuted),
                    prefixIcon: Icon(Icons.search_rounded, size: 15, color: AppColors.textMuted),
                    suffixIcon: _overdueSearchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 14),
                            onPressed: () {
                              _overdueSearchController.clear();
                              setState(() => _overdueSearchQuery = '');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: AppColors.borderLight),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: AppColors.borderLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: AppColors.primary, width: 1.2),
                    ),
                  ),
                ),
              );

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: filterChips,
                    ),
                    const SizedBox(height: 10),
                    searchInput,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: filterChips,
                    ),
                  ),
                  const SizedBox(width: 12),
                  searchInput,
                ],
              );
            },
          ),

          const SizedBox(height: 14),

          // Content: Card Carousel or AppDataGrid Table
          if (filteredList.isEmpty)
            _buildEmptySectionMessage(
              'No overdue payments found matching current filters.',
              Icons.check_circle_outline_rounded,
            )
          else if (_isOverdueTableView)
            SizedBox(
              height: 280,
              child: _buildPaymentsDataGrid(filteredList, isOverdue: true),
            )
          else
            SizedBox(
              height: 145,
              child: HorizontalListWithArrows(payments: filteredList),
            ),
        ],
      ),
    );
  }

  // ==================== UPCOMING PAYMENTS SECTION ====================

  Widget _buildUpcomingPaymentSection() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final allDetails = defaultController.outstandingPurchaseSaleDetailsList;

    // Extract all upcoming (future) payments
    final upcomingList = allDetails.where((details) {
      if (details.dueDate == null) return false;
      final dueDate = DateTime.tryParse(details.dueDate!);
      if (dueDate == null) return false;
      final targetDate = DateTime(dueDate.year, dueDate.month, dueDate.day);
      return targetDate.isAfter(todayDate);
    }).toList();

    // Sort by soonest due first
    upcomingList.sort((a, b) {
      final da = DateTime.tryParse(a.dueDate ?? '') ?? DateTime.now();
      final db = DateTime.tryParse(b.dueDate ?? '') ?? DateTime.now();
      return da.compareTo(db);
    });

    // Apply Filters
    List<OutstandingPurchaseSaleDetails> filteredList = upcomingList.where((p) {
      // Type filter
      if (_upcomingFilterType == 'Purchase' && p.trnType != 'Purchase') return false;
      if (_upcomingFilterType == 'Sale' && p.trnType != 'Sale') return false;

      // Range filter
      final dueDate = DateTime.tryParse(p.dueDate ?? '');
      if (dueDate != null) {
        final daysUntilDue = DateTime(dueDate.year, dueDate.month, dueDate.day).difference(todayDate).inDays;
        if (_upcomingRangeFilter == '7 Days' && daysUntilDue > 7) return false;
        if (_upcomingRangeFilter == '15 Days' && daysUntilDue > 15) return false;
        if (_upcomingRangeFilter == '30 Days' && daysUntilDue > 30) return false;
      }

      // Search query
      if (_upcomingSearchQuery.isNotEmpty) {
        final q = _upcomingSearchQuery.toLowerCase();
        final partyMatch = (p.partyName ?? '').toLowerCase().contains(q);
        final invMatch = (p.invNo ?? '').toLowerCase().contains(q);
        if (!partyMatch && !invMatch) return false;
      }

      return true;
    }).toList();

    final double totalUpcoming = filteredList.fold(
      0.0,
      (sum, item) => sum + ((item.bAmtRs is num) ? (item.bAmtRs as num).toDouble() : 0.0),
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header Bar with Badges & Controls
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _buildSectionHeader(
                  title: 'Upcoming Payments',
                  icon: Icons.calendar_month_outlined,
                  count: filteredList.length,
                  totalAmount: totalUpcoming,
                  badgeColor: AppColors.info,
                ),
              ),

              // View Toggle: Cards vs Table
              _buildViewModeToggle(
                isTableView: _isUpcomingTableView,
                onToggle: (val) => setState(() => _isUpcomingTableView = val),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Filters & Search Bar
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 850;
              final filterChips = [
                _buildFilterChip('All', _upcomingFilterType == 'All', () {
                  setState(() => _upcomingFilterType = 'All');
                }),
                _buildFilterChip('Purchase', _upcomingFilterType == 'Purchase', () {
                  setState(() => _upcomingFilterType = 'Purchase');
                }),
                _buildFilterChip('Sale', _upcomingFilterType == 'Sale', () {
                  setState(() => _upcomingFilterType = 'Sale');
                }),
                if (!isCompact) ...[
                  const SizedBox(width: 6),
                  Container(width: 1, height: 20, color: AppColors.borderLight),
                  const SizedBox(width: 6),
                ],
                _buildFilterChip('All Future', _upcomingRangeFilter == 'All', () {
                  setState(() => _upcomingRangeFilter = 'All');
                }),
                _buildFilterChip('Next 7 Days', _upcomingRangeFilter == '7 Days', () {
                  setState(() => _upcomingRangeFilter = '7 Days');
                }),
                _buildFilterChip('Next 15 Days', _upcomingRangeFilter == '15 Days', () {
                  setState(() => _upcomingRangeFilter = '15 Days');
                }),
                _buildFilterChip('Next 30 Days', _upcomingRangeFilter == '30 Days', () {
                  setState(() => _upcomingRangeFilter = '30 Days');
                }),
              ];

              final searchInput = SizedBox(
                width: isCompact ? double.infinity : 200,
                height: 32,
                child: TextField(
                  controller: _upcomingSearchController,
                  onChanged: (val) => setState(() => _upcomingSearchQuery = val),
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'Search invoice / party...',
                    hintStyle: TextStyle(fontSize: 11, color: AppColors.textMuted),
                    prefixIcon: Icon(Icons.search_rounded, size: 15, color: AppColors.textMuted),
                    suffixIcon: _upcomingSearchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 14),
                            onPressed: () {
                              _upcomingSearchController.clear();
                              setState(() => _upcomingSearchQuery = '');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: AppColors.borderLight),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: AppColors.borderLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: AppColors.primary, width: 1.2),
                    ),
                  ),
                ),
              );

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: filterChips,
                    ),
                    const SizedBox(height: 10),
                    searchInput,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: filterChips,
                    ),
                  ),
                  const SizedBox(width: 12),
                  searchInput,
                ],
              );
            },
          ),

          const SizedBox(height: 14),

          // Content: Card Carousel or AppDataGrid Table
          if (filteredList.isEmpty)
            _buildEmptySectionMessage(
              'No upcoming payments found matching current filters.',
              Icons.event_available_rounded,
            )
          else if (_isUpcomingTableView)
            SizedBox(
              height: 280,
              child: _buildPaymentsDataGrid(filteredList, isOverdue: false),
            )
          else
            SizedBox(
              height: 145,
              child: HorizontalListWithArrows(payments: filteredList),
            ),
        ],
      ),
    );
  }

  // ==================== REUSABLE DASHBOARD WIDGETS ====================

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required int count,
    required double totalAmount,
    required Color badgeColor,
  }) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 6,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: badgeColor),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),

        // Count Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: badgeColor,
            ),
          ),
        ),

        // Sum Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: badgeColor.withValues(alpha: 0.25),
              width: 0.8,
            ),
          ),
          child: Text(
            'Total: ${CurrencyFormatter.formatInr(totalAmount)}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: badgeColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildViewModeToggle({required bool isTableView, required ValueChanged<bool> onToggle}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderLight),
      ),
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleIconButton(
            icon: Icons.view_carousel_rounded,
            tooltip: 'Cards View',
            isActive: !isTableView,
            onTap: () => onToggle(false),
          ),
          _buildToggleIconButton(
            icon: Icons.table_chart_rounded,
            tooltip: 'Table View (DataGrid)',
            isActive: isTableView,
            onTap: () => onToggle(true),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleIconButton({
    required IconData icon,
    required String tooltip,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            boxShadow: isActive
                ? const [BoxShadow(color: Color(0x10000000), blurRadius: 2, offset: Offset(0, 1))]
                : null,
          ),
          child: Icon(
            icon,
            size: 15,
            color: isActive ? AppColors.primary : AppColors.textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySectionMessage(String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(icon, size: 32, color: AppColors.textMuted.withValues(alpha: 0.6)),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 12.5,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== DATAGRID TABLE VIEW ====================

  Widget _buildPaymentsDataGrid(List<OutstandingPurchaseSaleDetails> payments, {required bool isOverdue}) {
    final source = _DashboardDataGridSource(
      payments: payments,
      onSelectPayment: (payment) {
        final isSale = payment.trnType == 'Sale';
        final isHighlighted = payment.dueDate != null && _isSameDate(DateTime.parse(payment.dueDate!), DateTime.now());
        if (isSale) {
          showSaleInvoiceDetails(
            context,
            payment,
            defaultController.polishSaleList,
            defaultController.saleDetailsList,
            isHighlighted,
            isSale,
            isOverdue,
          );
        } else {
          showPurchaseInvoiceDetails(
            context,
            payment,
            defaultController.purchaseDataList,
            defaultController.roughDetailsModel,
            isHighlighted,
            isSale,
            isOverdue,
          );
        }
      },
    );

    return AppDataGrid(
      source: source,
      columnWidthMode: ColumnWidthMode.auto,
      rowHeight: 30,
      headerRowHeight: 34,
      allowSorting: true,
      allowMultiColumnSorting: true,
      showSortNumbers: true,
      allowFiltering: true,
      allowColumnsResizing: true,
      selectionMode: SelectionMode.single,
      columns: [
        AppDataGrid.buildColumn(
          columnName: 'TrnType',
          labelText: 'Type',
          width: 90,
          alignment: Alignment.center,
        ),
        AppDataGrid.buildColumn(
          columnName: 'InvNo',
          labelText: 'Invoice No',
          width: 140,
        ),
        AppDataGrid.buildColumn(
          columnName: 'PartyName',
          labelText: 'Party Name',
          columnWidthMode: ColumnWidthMode.fill,
        ),
        AppDataGrid.buildColumn(
          columnName: 'DueDate',
          labelText: 'Due Date',
          width: 110,
          alignment: Alignment.center,
        ),
        AppDataGrid.buildColumn(
          columnName: 'Status',
          labelText: isOverdue ? 'Overdue' : 'Due Status',
          width: 130,
          alignment: Alignment.center,
        ),
        AppDataGrid.buildColumn(
          columnName: 'BAmtRs',
          labelText: 'Outstanding (₹)',
          width: 130,
          alignment: Alignment.centerRight,
        ),
      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          title: 'Total (${payments.length})',
          showSummaryInRow: false,
          titleColumnSpan: 2,
          columns: const <GridSummaryColumn>[
            GridSummaryColumn(name: 'BAmtRsSum', columnName: 'BAmtRs', summaryType: GridSummaryType.sum),
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
    );
  }

  // ==================== SHIMMER SKELETON LOADING ====================

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (index) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Shimmer.fromColors(
                    baseColor: AppColors.isDark ? const Color(0xFF1E293B) : Colors.grey[200]!,
                    highlightColor: AppColors.isDark ? const Color(0xFF334155) : Colors.grey[50]!,
                    child: Container(
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          Shimmer.fromColors(
            baseColor: AppColors.isDark ? const Color(0xFF1E293B) : Colors.grey[200]!,
            highlightColor: AppColors.isDark ? const Color(0xFF334155) : Colors.grey[50]!,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Shimmer.fromColors(
            baseColor: AppColors.isDark ? const Color(0xFF1E293B) : Colors.grey[200]!,
            highlightColor: AppColors.isDark ? const Color(0xFF334155) : Colors.grey[50]!,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== DATAGRID SOURCE FOR PAYMENTS ====================

class _DashboardDataGridSource extends DataGridSource {
  final List<OutstandingPurchaseSaleDetails> payments;
  final ValueChanged<OutstandingPurchaseSaleDetails> onSelectPayment;
  List<DataGridRow> _rows = [];

  _DashboardDataGridSource({required this.payments, required this.onSelectPayment}) {
    _buildRows();
  }

  void _buildRows() {
    _rows = payments.map<DataGridRow>((p) {
      final isSale = p.trnType == 'Sale';
      final dueDateTime = p.dueDate != null ? DateTime.tryParse(p.dueDate!) : null;
      final amount = (p.bAmtRs is num) ? (p.bAmtRs as num).toDouble() : 0.0;

      String formattedDate = 'N/A';
      String statusText = 'N/A';
      if (dueDateTime != null) {
        formattedDate = DateFormat('dd-MM-yyyy').format(dueDateTime);
        final now = DateTime.now();
        final daysDiff = DateTime(dueDateTime.year, dueDateTime.month, dueDateTime.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays;
        if (daysDiff == 0) {
          statusText = 'Due Today';
        } else if (daysDiff < 0) {
          statusText = '${daysDiff.abs()}d overdue';
        } else {
          statusText = 'In ${daysDiff}d';
        }
      }

      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'TrnType', value: isSale ? 'Sale' : 'Purchase'),
        DataGridCell<String>(columnName: 'InvNo', value: p.invNo ?? ''),
        DataGridCell<String>(columnName: 'PartyName', value: p.partyName ?? ''),
        DataGridCell<String>(columnName: 'DueDate', value: formattedDate),
        DataGridCell<String>(columnName: 'Status', value: statusText),
        DataGridCell<double>(columnName: 'BAmtRs', value: amount),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final trnType = row.getCells()[0].value as String;
    final invNo = row.getCells()[1].value as String;
    final partyName = row.getCells()[2].value as String;
    final dueDate = row.getCells()[3].value as String;
    final status = row.getCells()[4].value as String;
    final bAmt = row.getCells()[5].value as double;

    final isSale = trnType == 'Sale';
    final isOverdue = status.contains('overdue');

    final originalPayment = payments.firstWhere(
      (p) => (p.invNo ?? '') == invNo,
      orElse: () => payments.first,
    );

    return DataGridRowAdapter(
      cells: [
        // Type Badge
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isSale ? AppColors.primary.withValues(alpha: 0.1) : const Color(0xFFEA580C).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              trnType,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSale ? AppColors.primary : const Color(0xFFEA580C),
              ),
            ),
          ),
        ),

        // Invoice No (clickable)
        InkWell(
          onTap: () => onSelectPayment(originalPayment),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              invNo,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                decoration: TextDecoration.underline,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        // Party Name
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            partyName,
            style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Due Date
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            dueDate,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ),

        // Status Badge
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isOverdue ? AppColors.danger.withValues(alpha: 0.1) : AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isOverdue ? AppColors.danger : AppColors.info,
              ),
            ),
          ),
        ),

        // Balance Amount
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            CurrencyFormatter.formatInr(bAmt),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isOverdue ? AppColors.danger : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
