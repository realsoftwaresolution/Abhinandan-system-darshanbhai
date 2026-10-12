import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/common/components/app_button.dart';
import 'package:real_web_rough_entry_system/common/components/app_data_grid.dart';
import 'package:real_web_rough_entry_system/common/components/app_dropdown.dart';
import 'package:real_web_rough_entry_system/common/components/app_shortcuts.dart';
import 'package:real_web_rough_entry_system/common/components/app_text_field.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/credit-debit/credit_debit_model.dart';
import 'package:real_web_rough_entry_system/header.dart';
import 'package:real_web_rough_entry_system/party-ledger/credit_debit_datagrid.dart';
import 'package:real_web_rough_entry_system/party-ledger/outstanding_payment_datagrid.dart';
import 'package:real_web_rough_entry_system/party-ledger/outstanding_payment_details_model.dart';
import 'package:real_web_rough_entry_system/responsive.dart';

class PartyLedgerFormScreen extends StatefulWidget {
  final bool showHeader;

  const PartyLedgerFormScreen({super.key, required this.showHeader});

  @override
  State<PartyLedgerFormScreen> createState() => _PartyLedgerFormScreenState();
}

class _PartyLedgerFormScreenState extends State<PartyLedgerFormScreen> {
  DateTime? fromDate;
  DateTime? toDate;

  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController creditTotalController = TextEditingController();
  final TextEditingController debitTotalController = TextEditingController();
  final TextEditingController debitBalanceController = TextEditingController();
  final TextEditingController creditBalanceController = TextEditingController();

  final TextEditingController crOpeningBalanceController = TextEditingController();
  final TextEditingController drOpeningBalanceController = TextEditingController();

  final FocusNode _partyFocus = FocusNode();
  final FocusNode _fromDateFocus = FocusNode();
  final FocusNode _toDateFocus = FocusNode();

  final RxString _selectedTypeParty = ''.obs;
  final RxBool _isFiltered = false.obs;
  final RxDouble openingBalance = 0.00.obs;

  final DataGridController _dataGridController = DataGridController();
  final DataGridController _outstandingDataGridController = DataGridController();

  RxList<CreditDebitMstModel> filteredDataGridSource = <CreditDebitMstModel>[].obs;
  RxList<CreditDebitMstModel> creditDebitDataGridSource = <CreditDebitMstModel>[].obs;
  RxList<OutstandingPaymentDetails> outstandingPaymentDataGridSource = <OutstandingPaymentDetails>[].obs;

  final DefaultController defaultController = Get.find<DefaultController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (defaultController.partyMstList.isEmpty) {
        defaultController.getPartyData();
      }
    });
  }

  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    creditTotalController.dispose();
    debitTotalController.dispose();
    debitBalanceController.dispose();
    creditBalanceController.dispose();
    crOpeningBalanceController.dispose();
    drOpeningBalanceController.dispose();

    _partyFocus.dispose();
    _fromDateFocus.dispose();
    _toDateFocus.dispose();
    super.dispose();
  }

  Future<void> _applyDateFilter() async {
    if (_selectedTypeParty.value.isEmpty) {
      infoDialog(messageText: 'Please select an Account / Party first.');
      _partyFocus.requestFocus();
      return;
    }
    if (fromDate == null || toDate == null) {
      infoDialog(messageText: 'Please select both From Date and To Date');
      return;
    }

    _isFiltered.value = true;

    try {
      defaultController.isLoading.value = true;
      final partyCode = int.tryParse(_selectedTypeParty.value);
      if (partyCode != null) {
        outstandingPaymentDataGridSource.value =
            await defaultController.getOutstandingPaymentDetails(
                partyCode: partyCode,
                fromDate: fromDate!,
                toDate: toDate!);
      }

      final openingBalanceEntries = defaultController.creditDebitDataList
          .where((data) {
            if (data.invDate == null) return false;
            final invoiceDate = DateTime.tryParse(data.invDate!);
            if (invoiceDate == null) return false;
            return invoiceDate.isBefore(fromDate!);
          })
          .where((e) => e.partyCode.toString() == _selectedTypeParty.value)
          .toList();

      final openingCrTotal = openingBalanceEntries.fold<double>(
        0.0,
        (sum, item) => sum + (item.creditRs != null ? (double.tryParse(item.creditRs.toString()) ?? 0.0) : 0.0),
      );
      final openingDrTotal = openingBalanceEntries.fold<double>(
        0.0,
        (sum, item) => sum + (item.debitRs != null ? (double.tryParse(item.debitRs.toString()) ?? 0.0) : 0.0),
      );
      openingBalance.value = openingCrTotal - openingDrTotal;

      if (openingBalance.value >= 0) {
        crOpeningBalanceController.text = openingBalance.value.toStringAsFixed(2);
        drOpeningBalanceController.text = '0.00';
      } else {
        drOpeningBalanceController.text = openingBalance.value.abs().toStringAsFixed(2);
        crOpeningBalanceController.text = '0.00';
      }

      // Filter transactions within the specified date range and selected party code
      filteredDataGridSource.value = defaultController.creditDebitDataList
          .where((transaction) {
            if (transaction.invDate == null) return false;
            final invoiceDate = DateTime.tryParse(transaction.invDate!);
            if (invoiceDate == null) return false;
            return invoiceDate.isAfter(fromDate!.subtract(const Duration(seconds: 1))) &&
                invoiceDate.isBefore(toDate!.add(const Duration(days: 1)));
          })
          .where((e) => e.partyCode.toString() == _selectedTypeParty.value)
          .toList();

      // Calculate the sums of Cr Rs and Dr Rs columns within the date range
      final crTotal = filteredDataGridSource.fold<double>(
        0.0,
        (sum, item) => sum + (item.creditRs != null ? (double.tryParse(item.creditRs.toString()) ?? 0.0) : 0.0),
      );
      final drTotal = filteredDataGridSource.fold<double>(
        0.0,
        (sum, item) => sum + (item.debitRs != null ? (double.tryParse(item.debitRs.toString()) ?? 0.0) : 0.0),
      );

      creditTotalController.text = crTotal.toStringAsFixed(2);
      debitTotalController.text = drTotal.toStringAsFixed(2);

      final crOp = double.tryParse(crOpeningBalanceController.text) ?? 0.0;
      final drOp = double.tryParse(drOpeningBalanceController.text) ?? 0.0;

      // Net closing balance
      final netBalance = (crTotal + crOp) - (drTotal + drOp);
      if (netBalance >= 0) {
        creditBalanceController.text = netBalance.toStringAsFixed(2);
        debitBalanceController.text = '0.00';
      } else {
        debitBalanceController.text = netBalance.abs().toStringAsFixed(2);
        creditBalanceController.text = '0.00';
      }

      creditDebitDataGridSource.value = filteredDataGridSource;
    } finally {
      defaultController.isLoading.value = false;
    }
  }

  void _removeDateFilter() {
    creditDebitDataGridSource.clear();
    outstandingPaymentDataGridSource.clear();
    toDateController.clear();
    fromDateController.clear();
    _selectedTypeParty.value = '';
    crOpeningBalanceController.clear();
    drOpeningBalanceController.clear();
    creditBalanceController.clear();
    creditTotalController.clear();
    debitBalanceController.clear();
    debitTotalController.clear();
    fromDate = null;
    toDate = null;
    _isFiltered.value = false;
  }

  void _handlePrintPdf() {
    if (creditDebitDataGridSource.isEmpty) {
      infoDialog(messageText: 'No ledger data available to print.');
      return;
    }
    CreditDebitDataGrid(creditDebitDataGridSource, openingBalance.value).exportToPdf(
      context,
      getPartyName(int.tryParse(_selectedTypeParty.value)),
      formatDateFromDateTime(fromDate ?? DateTime.now()),
      formatDateFromDateTime(toDate ?? DateTime.now()),
    );
  }

  void _handleExportExcel() {
    if (creditDebitDataGridSource.isEmpty) {
      infoDialog(messageText: 'No ledger data available to export.');
      return;
    }
    CreditDebitDataGrid(creditDebitDataGridSource, openingBalance.value).exportToExcel(
      getPartyName(int.tryParse(_selectedTypeParty.value)),
      formatDateFromDateTime(fromDate ?? DateTime.now()),
      formatDateFromDateTime(toDate ?? DateTime.now()),
    );
  }

  void _handlePrintOutstandingPdf() {
    if (outstandingPaymentDataGridSource.isEmpty) {
      infoDialog(messageText: 'No outstanding data available to print.');
      return;
    }
    OutstandingPaymentDataGrid(outstandingPaymentDataGridSource).exportToPdf(
      context,
      getPartyName(int.tryParse(_selectedTypeParty.value)),
      formatDateFromDateTime(fromDate ?? DateTime.now()),
      formatDateFromDateTime(toDate ?? DateTime.now()),
    );
  }

  // Dropdown list for parties
  List<DropdownMenuItem<String>> get dropdownItemsParty {
    final seenCodes = <int>{};
    return defaultController.partyMstList
        .where((p) =>
            p.companyCode == defaultController.companyCode.value &&
            p.partyCode != null &&
            seenCodes.add(p.partyCode!))
        .map((p) {
      final partyTransactions = defaultController.creditDebitDataList
          .where((cd) => cd.partyCode == p.partyCode)
          .toList();

      final double sumCredit = partyTransactions.fold(0.0, (prev, cd) => prev + (cd.creditRs != null ? (double.tryParse(cd.creditRs.toString()) ?? 0.0) : 0.0));
      final double sumDebit = partyTransactions.fold(0.0, (prev, cd) => prev + (cd.debitRs != null ? (double.tryParse(cd.debitRs.toString()) ?? 0.0) : 0.0));
      final double balance = (sumCredit - sumDebit) +
          ((p.creditOpBalRs ?? 0.0) - (p.debitOpBalRs ?? 0.0));

      final Color badgeBg = getPartyTypeColor(p.typeCode ?? 0);
      final IconData badgeIcon = getPartyTypeIcon(p.typeCode ?? 0);

      return DropdownMenuItem<String>(
        value: p.partyCode.toString(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeBg.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: badgeBg.withValues(alpha: 0.3), width: 0.8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(badgeIcon, size: 10, color: badgeBg),
                      const SizedBox(width: 3),
                      Text(
                        getPartyType(p.typeCode ?? 0),
                        style: TextStyle(fontSize: 10, color: badgeBg, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  p.partyName ?? '',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '₹ ${balance.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: balance >= 0 ? AppColors.success : AppColors.danger,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: (balance >= 0 ? AppColors.success : AppColors.danger).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    balance >= 0 ? 'Cr' : 'Dr',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: balance >= 0 ? AppColors.success : AppColors.danger,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppKeyboardShortcutHandler(
        onSave: _applyDateFilter,
        onCancel: _removeDateFilter,
        onPrint: _handlePrintPdf,
        onExit: () => tabController.removeTab(tabController.currentIndex.value),
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.isMobile(context) ? 10 : 20,
              vertical: Responsive.isMobile(context) ? 10 : 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.showHeader) ...[
                  const Header(title: 'Party Ledger'),
                  const SizedBox(height: 16),
                ],

                // Card 1: Filters & Action Buttons
                _buildFilterCard(),
                const SizedBox(height: 16),

                // Card 2: Financial Balances Summary
                _buildBalancesCard(),
                const SizedBox(height: 16),

                // Card 3: Ledger Transactions DataGrid
                _buildTransactionsCard(),
                const SizedBox(height: 16),

                // Card 4: Outstanding Invoices DataGrid
                _buildOutstandingCard(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==================== CARD 1: FILTERS & ACTIONS ====================

  Widget _buildFilterCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.account_balance_wallet_rounded, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                'Ledger Account & Date Range Filter',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final partyField = Obx(
                () => AppDropdown<String>(
                  label: 'Account / Party *',
                  value: _selectedTypeParty.value.isEmpty ? null : _selectedTypeParty.value,
                  items: dropdownItemsParty,
                  focusNode: _partyFocus,
                  nextFocusNode: _fromDateFocus,
                  hintText: 'Select Party',
                  onChanged: (value) {
                    if (value != null) {
                      _selectedTypeParty.value = value;
                    }
                  },
                ),
              );

              final fromDateField = Focus(
                onKeyEvent: (node, event) {
                  if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
                    _pickFromDate();
                    return KeyEventResult.handled;
                  }
                  return KeyEventResult.ignored;
                },
                child: AppTextField(
                  label: 'From Date *',
                  controller: fromDateController,
                  focusNode: _fromDateFocus,
                  nextFocusNode: _toDateFocus,
                  readOnly: true,
                  prefixIcon: Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.primary),
                  onTap: _pickFromDate,
                ),
              );

              final toDateField = Focus(
                onKeyEvent: (node, event) {
                  if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
                    _pickToDate();
                    return KeyEventResult.handled;
                  }
                  return KeyEventResult.ignored;
                },
                child: AppTextField(
                  label: 'To Date *',
                  controller: toDateController,
                  focusNode: _toDateFocus,
                  readOnly: true,
                  prefixIcon: Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.primary),
                  onTap: _pickToDate,
                ),
              );

              if (constraints.maxWidth >= 750) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: partyField),
                    const SizedBox(width: 12),
                    Expanded(flex: 3, child: fromDateField),
                    const SizedBox(width: 12),
                    Expanded(flex: 3, child: toDateField),
                  ],
                );
              } else if (constraints.maxWidth >= 500) {
                return Column(
                  children: [
                    partyField,
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: fromDateField),
                        const SizedBox(width: 12),
                        Expanded(child: toDateField),
                      ],
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    partyField,
                    const SizedBox(height: 10),
                    fromDateField,
                    const SizedBox(height: 10),
                    toDateField,
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 14),

          // Action Buttons Bar
          Obx(
            () => Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                spacing: 10,
                runSpacing: 8,
                alignment: WrapAlignment.end,
                children: [
                  AppButton(
                    text: 'Show',
                    icon: Icons.visibility_rounded,
                    variant: AppButtonVariant.primary,
                    isLoading: defaultController.isLoading.value,
                    onPressed: _applyDateFilter,
                  ),
                  AppButton(
                    text: 'Reset',
                    icon: Icons.refresh_rounded,
                    variant: AppButtonVariant.secondary,
                    onPressed: _removeDateFilter,
                  ),
                  AppButton(
                    text: 'Print PDF',
                    icon: Icons.print_outlined,
                    variant: AppButtonVariant.outline,
                    onPressed: creditDebitDataGridSource.isNotEmpty ? _handlePrintPdf : null,
                  ),
                  AppButton(
                    text: 'Export Excel',
                    icon: Icons.table_view_rounded,
                    variant: AppButtonVariant.outline,
                    onPressed: creditDebitDataGridSource.isNotEmpty ? _handleExportExcel : null,
                  ),
                  AppButton(
                    text: 'Exit',
                    icon: Icons.exit_to_app_rounded,
                    variant: AppButtonVariant.outline,
                    onPressed: () => tabController.removeTab(tabController.currentIndex.value),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFromDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        fromDate = pickedDate;
        fromDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        _toDateFocus.requestFocus();
      });
      if (toDate != null) {
        _applyDateFilter();
      }
    }
  }

  Future<void> _pickToDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        toDate = pickedDate;
        toDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
      if (fromDate != null) {
        _applyDateFilter();
      }
    }
  }

  // ==================== CARD 2: FINANCIAL BALANCES ====================

  Widget _buildBalancesCard() {
    final crClosing = double.tryParse(creditBalanceController.text) ?? 0.0;
    final drClosing = double.tryParse(debitBalanceController.text) ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.analytics_rounded, color: AppColors.success, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                'Financial Balances & Statement Summary',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final crOpeningCard = _buildBalanceStatCard(
                'CR OPENING',
                '₹ ${crOpeningBalanceController.text.isEmpty ? '0.00' : crOpeningBalanceController.text}',
                AppColors.primary,
                Icons.arrow_upward_rounded,
              );

              final drOpeningCard = _buildBalanceStatCard(
                'DR OPENING',
                '₹ ${drOpeningBalanceController.text.isEmpty ? '0.00' : drOpeningBalanceController.text}',
                const Color(0xFF64748B),
                Icons.arrow_downward_rounded,
              );

              final crTotalCard = _buildBalanceStatCard(
                'TOTAL CREDIT (CR)',
                '₹ ${creditTotalController.text.isEmpty ? '0.00' : creditTotalController.text}',
                AppColors.success,
                Icons.add_circle_outline_rounded,
              );

              final drTotalCard = _buildBalanceStatCard(
                'TOTAL DEBIT (DR)',
                '₹ ${debitTotalController.text.isEmpty ? '0.00' : debitTotalController.text}',
                AppColors.danger,
                Icons.remove_circle_outline_rounded,
              );

              final closingCard = _buildClosingBalanceStatCard(crClosing, drClosing);

              if (constraints.maxWidth >= 950) {
                return Row(
                  children: [
                    Expanded(child: crOpeningCard),
                    const SizedBox(width: 10),
                    Expanded(child: drOpeningCard),
                    const SizedBox(width: 10),
                    Expanded(child: crTotalCard),
                    const SizedBox(width: 10),
                    Expanded(child: drTotalCard),
                    const SizedBox(width: 10),
                    Expanded(child: closingCard),
                  ],
                );
              } else if (constraints.maxWidth >= 600) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: crOpeningCard),
                        const SizedBox(width: 10),
                        Expanded(child: drOpeningCard),
                        const SizedBox(width: 10),
                        Expanded(child: crTotalCard),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: drTotalCard),
                        const SizedBox(width: 10),
                        Expanded(child: closingCard),
                      ],
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: crOpeningCard),
                        const SizedBox(width: 10),
                        Expanded(child: drOpeningCard),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: crTotalCard),
                        const SizedBox(width: 10),
                        Expanded(child: drTotalCard),
                      ],
                    ),
                    const SizedBox(height: 10),
                    closingCard,
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceStatCard(String label, String amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            amount,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildClosingBalanceStatCard(double crClosing, double drClosing) {
    final bool isCredit = crClosing > 0 || (crClosing == 0 && drClosing == 0);
    final String amountStr = isCredit ? '₹ ${crClosing.toStringAsFixed(2)}' : '₹ ${drClosing.toStringAsFixed(2)}';
    final Color color = isCredit ? AppColors.success : AppColors.danger;
    final String badge = isCredit ? 'Cr' : 'Dr';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.account_balance_rounded, size: 14, color: color),
                  const SizedBox(width: 5),
                  Text(
                    'NET CLOSING',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: color),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            amountStr,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ==================== CARD 3: TRANSACTIONS LEDGER ====================

  Widget _buildTransactionsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 550;
              final headerContent = Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(Icons.receipt_rounded, color: AppColors.primary, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Obx(
                      () => Text(
                        'Ledger Transactions (${creditDebitDataGridSource.length})',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              );

              final actionButtons = Obx(
                () => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.print_outlined, size: 18, color: AppColors.primary),
                      tooltip: 'Print Ledger PDF',
                      splashRadius: 18,
                      onPressed: creditDebitDataGridSource.isNotEmpty ? _handlePrintPdf : null,
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: Icon(Icons.table_view_rounded, size: 18, color: AppColors.success),
                      tooltip: 'Export to Excel',
                      splashRadius: 18,
                      onPressed: creditDebitDataGridSource.isNotEmpty ? _handleExportExcel : null,
                    ),
                  ],
                ),
              );

              return isNarrow
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headerContent,
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: actionButtons,
                        ),
                      ],
                    )
                  : Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: headerContent),
                        actionButtons,
                      ],
                    );
            },
          ),
          const SizedBox(height: 12),
          Obx(
            () => defaultController.isLoading.value
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: LinearProgressIndicator(color: AppColors.primary),
                  )
                : const SizedBox.shrink(),
          ),
          Obx(
            () => creditDebitDataGridSource.isEmpty
                ? Container(
                    height: 140,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.menu_book_rounded, size: 38, color: AppColors.textMuted.withValues(alpha: 0.6)),
                        const SizedBox(height: 8),
                        Text(
                          'No ledger transactions displayed.',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Select an Account and Date Range above, then click Show (Alt+S).',
                          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: 350,
                    child: AppDataGrid(
                      controller: _dataGridController,
                      source: CreditDebitDataGrid(creditDebitDataGridSource, openingBalance.value),
                      columnWidthMode: ColumnWidthMode.auto,
                      navigationMode: GridNavigationMode.cell,
                      frozenColumnsCount: 1,
                      rowHeight: 30,
                      headerRowHeight: 36,
                      allowSorting: true,
                      allowMultiColumnSorting: true,
                      showSortNumbers: true,
                      allowFiltering: true,
                      allowColumnsResizing: true,
                      selectionMode: SelectionMode.single,
                      columns: <GridColumn>[
                        GridColumn(
                          columnName: 'Id',
                          visible: false,
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.center,
                            child: const Text('Id', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Date',
                          allowEditing: false,
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.centerLeft,
                            child: const Text('Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Particulars',
                          allowEditing: false,
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.centerLeft,
                            child: const Text('Particulars', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Inv No',
                          allowEditing: false,
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.centerLeft,
                            child: const Text('Inv No', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Cr Rs',
                          allowEditing: false,
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.centerRight,
                            child: const Text('Cr Rs (₹)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Dr Rs',
                          allowEditing: false,
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.centerRight,
                            child: const Text('Dr Rs (₹)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Closing Rs',
                          allowEditing: false,
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.centerRight,
                            child: const Text('Closing Rs (₹)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Remarks 1',
                          allowEditing: false,
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.centerLeft,
                            child: const Text('Remarks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ==================== CARD 4: OUTSTANDING INVOICES ====================

  Widget _buildOutstandingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 550;
              final headerContent = Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(Icons.pending_actions_rounded, color: AppColors.warning, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Obx(
                      () => Text(
                        'Outstanding Unpaid Invoices (${outstandingPaymentDataGridSource.where((e) => e.status == 'UNPAID').length})',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              );

              final actionButton = Obx(
                () => IconButton(
                  icon: Icon(Icons.print_outlined, size: 18, color: AppColors.warning),
                  tooltip: 'Print Outstanding PDF',
                  splashRadius: 18,
                  onPressed: outstandingPaymentDataGridSource.isNotEmpty ? _handlePrintOutstandingPdf : null,
                ),
              );

              return isNarrow
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headerContent,
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: actionButton,
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: headerContent),
                        actionButton,
                      ],
                    );
            },
          ),
          const SizedBox(height: 12),
          Obx(
            () => outstandingPaymentDataGridSource.isEmpty
                ? Container(
                    height: 100,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline_rounded, size: 32, color: AppColors.success.withValues(alpha: 0.6)),
                        const SizedBox(height: 6),
                        Text(
                          'No outstanding unpaid invoices for this account.',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: 280,
                    child: AppDataGrid(
                      controller: _outstandingDataGridController,
                      source: OutstandingPaymentDataGrid(outstandingPaymentDataGridSource),
                      columnWidthMode: ColumnWidthMode.auto,
                      navigationMode: GridNavigationMode.cell,
                      frozenColumnsCount: 1,
                      rowHeight: 30,
                      headerRowHeight: 36,
                      allowSorting: true,
                      allowMultiColumnSorting: true,
                      showSortNumbers: true,
                      allowFiltering: true,
                      allowColumnsResizing: true,
                      selectionMode: SelectionMode.single,
                      columns: <GridColumn>[
                        GridColumn(
                          columnName: 'Inv No',
                          allowEditing: false,
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.centerLeft,
                            child: const Text('Inv No', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Inv Date',
                          allowEditing: false,
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.centerLeft,
                            child: const Text('Inv Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Due Days',
                          allowEditing: false,
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.centerRight,
                            child: const Text('Due Days', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Due Date',
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.centerLeft,
                            child: const Text('Due Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Trn Type',
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.center,
                            child: const Text('Trn Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Dr/Cr',
                          allowEditing: false,
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.center,
                            child: const Text('Dr/Cr', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Amt Rs',
                          allowEditing: false,
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.centerRight,
                            child: const Text('Amt Rs (₹)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Balance AmtRs',
                          allowEditing: false,
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.centerRight,
                            child: const Text('Balance (₹)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Status',
                          allowEditing: false,
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.center,
                            child: const Text('Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Avg Days',
                          allowEditing: false,
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.centerRight,
                            child: const Text('Avg Days', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Late Days',
                          allowEditing: false,
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.centerRight,
                            child: const Text('Late Days', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
