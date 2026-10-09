import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/common/components/app_button.dart';
import 'package:real_web_rough_entry_system/common/components/app_data_grid.dart';
import 'package:real_web_rough_entry_system/common/components/app_dropdown.dart';
import 'package:real_web_rough_entry_system/common/components/app_shortcuts.dart';
import 'package:real_web_rough_entry_system/common/components/app_text_field.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/header.dart';
import 'package:real_web_rough_entry_system/report/memo_pending_report_datagrid.dart';
import 'package:real_web_rough_entry_system/report/outstanding_purchase_details_datagrid.dart';
import 'package:real_web_rough_entry_system/report/outstanding_sale_details_datagrid.dart';
import 'package:real_web_rough_entry_system/report/stock_report_datagrid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ReportScreen extends StatefulWidget {
  final bool showHeader;

  const ReportScreen({super.key, required this.showHeader});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime? fromDate;
  DateTime? toDate;
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  final RxString _selectedTypeReport = ''.obs;
  final RxList<String> _selectedTypeParties = <String>[].obs;
  final RxList<String> _selectedTypeBrokers = <String>[].obs;
  final RxList<String> _selectedTypeRoughs = <String>[].obs;

  final DataGridController _dataGridController = DataGridController();

  late MemoPendingReportDataGridSource memoPendingDataGridSource;
  late OutstandingPurchaseReportDataGridSource outstandingPurchaseDataGridSource;
  late OutstandingSaleReportDataGridSource outstandingSaleDataGridSource;
  late StockReportDataGrid stockDataGridSource;

  @override
  void initState() {
    super.initState();
    memoPendingDataGridSource = MemoPendingReportDataGridSource();
    outstandingPurchaseDataGridSource = OutstandingPurchaseReportDataGridSource();
    outstandingSaleDataGridSource = OutstandingSaleReportDataGridSource();
    stockDataGridSource = StockReportDataGrid();
  }

  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final partiesInt = _selectedTypeParties.map((p) => int.tryParse(p) ?? 0).toList();
    final brokersInt = _selectedTypeBrokers.map((b) => int.tryParse(b) ?? 0).toList();
    final roughsInt = _selectedTypeRoughs.map((r) => int.tryParse(r) ?? 0).toList();

    memoPendingDataGridSource.setFromDate(fromDate);
    memoPendingDataGridSource.setToDate(toDate);
    memoPendingDataGridSource.setSelectedParties(partiesInt.isNotEmpty ? partiesInt : null);
    memoPendingDataGridSource.setSelectedBrokers(brokersInt.isNotEmpty ? brokersInt : null);
    if (roughsInt.isNotEmpty) {
      memoPendingDataGridSource.setSelectedRoughs(roughsInt);
    }

    outstandingPurchaseDataGridSource.setFromDate(fromDate);
    outstandingPurchaseDataGridSource.setToDate(toDate);
    outstandingPurchaseDataGridSource.setSelectedParties(partiesInt.isNotEmpty ? partiesInt : null);
    outstandingPurchaseDataGridSource.setSelectedBrokers(brokersInt.isNotEmpty ? brokersInt : null);
    if (roughsInt.isNotEmpty) {
      outstandingPurchaseDataGridSource.setSelectedRoughs(roughsInt);
    }

    outstandingSaleDataGridSource.setFromDate(fromDate);
    outstandingSaleDataGridSource.setToDate(toDate);
    outstandingSaleDataGridSource.setSelectedParties(partiesInt.isNotEmpty ? partiesInt : null);
    outstandingSaleDataGridSource.setSelectedBrokers(brokersInt.isNotEmpty ? brokersInt : null);
    if (roughsInt.isNotEmpty) {
      outstandingSaleDataGridSource.setSelectedRoughs(roughsInt);
    }

    stockDataGridSource = StockReportDataGrid();
    setState(() {});
  }

  void _resetFilters() {
    memoPendingDataGridSource.clearFilter();
    outstandingPurchaseDataGridSource.clearFilter();
    outstandingSaleDataGridSource.clearFilter();
    stockDataGridSource = StockReportDataGrid();

    fromDate = null;
    toDate = null;
    fromDateController.clear();
    toDateController.clear();

    _selectedTypeParties.clear();
    _selectedTypeBrokers.clear();
    _selectedTypeRoughs.clear();

    setState(() {});
  }

  void _printPdf() {
    if (_selectedTypeReport.value == 'PURCHASE OUTSTANDING') {
      outstandingPurchaseDataGridSource.exportToPdf();
    } else if (_selectedTypeReport.value == 'SALE OUTSTANDING') {
      outstandingSaleDataGridSource.exportToPdf(context);
    } else {
      infoDialog(messageText: 'PDF Print is available for Purchase Outstanding and Sale Outstanding reports.');
    }
  }

  void _exitScreen() {
    tabController.removeTab(tabController.currentIndex.value);
  }

  Future<void> _pickFromDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        fromDate = picked;
        fromDateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
      _applyFilters();
    }
  }

  Future<void> _pickToDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        toDate = picked;
        toDateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
      _applyFilters();
    }
  }

  int get _recordCount {
    switch (_selectedTypeReport.value) {
      case 'STOCK':
        return stockDataGridSource.rows.length;
      case 'MEMO PENDING':
        return memoPendingDataGridSource.rows.length;
      case 'PURCHASE OUTSTANDING':
        return outstandingPurchaseDataGridSource.rows.length;
      case 'SALE OUTSTANDING':
        return outstandingSaleDataGridSource.rows.length;
      default:
        return 0;
    }
  }

  List<AppDropdownItem<String>> get multiDropdownItemsParty {
    return defaultController.partyMstList
        .where((partyType) =>
            (partyType.typeCode == 1 || partyType.typeCode == 2) &&
            partyType.companyCode == defaultController.companyCode.value)
        .map((partyType) {
      return AppDropdownItem<String>(
        value: partyType.partyCode.toString(),
        label: partyType.partyName ?? '',
      );
    }).toList();
  }

  List<AppDropdownItem<String>> get multiDropdownItemsBroker {
    return defaultController.partyMstList
        .where((partyType) =>
            partyType.typeCode == 5 &&
            partyType.companyCode == defaultController.companyCode.value)
        .map((partyType) {
      return AppDropdownItem<String>(
        value: partyType.partyCode.toString(),
        label: partyType.partyName ?? '',
      );
    }).toList();
  }

  List<AppDropdownItem<String>> get dropdownItemsRough {
    return defaultController.roughModel.map((rough) {
      return AppDropdownItem<String>(
        value: rough.roughTypeCode.toString(),
        label: rough.roughTypeName ?? '',
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppKeyboardShortcutHandler(
        onSave: _applyFilters,
        onCancel: _resetFilters,
        onPrint: _printPdf,
        onExit: _exitScreen,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              if (widget.showHeader) const Header(title: 'Reports & Inquiries'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildFiltersCard(),
                      const SizedBox(height: 8),
                      _buildActionBar(),
                      const SizedBox(height: 8),
                      Expanded(child: _buildDataGridCard()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFiltersCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.filter_alt_rounded, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Report Selection & Filter Parameters',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Obx(() => _selectedTypeReport.value.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _selectedTypeReport.value,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : const SizedBox.shrink()),
            ],
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final reportTypeField = Obx(
                () => AppDropdown<String>(
                  key: ValueKey(_selectedTypeReport.value),
                  label: 'Report Type *',
                  value: _selectedTypeReport.value.isEmpty ? null : _selectedTypeReport.value,
                  hintText: 'Select Report...',
                  prefixIcon: Icon(Icons.analytics_outlined, size: 16, color: AppColors.primary),
                  items: reportList.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                  onChanged: (val) {
                    _selectedTypeReport.value = val ?? '';
                    _applyFilters();
                  },
                ),
              );

              final fromDateField = AppTextField(
                label: 'From Date',
                controller: fromDateController,
                readOnly: true,
                onTap: _pickFromDate,
                prefixIcon: Icon(Icons.calendar_today_rounded, size: 15, color: AppColors.textMuted),
                suffixIcon: fromDate != null
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 15),
                        onPressed: () {
                          setState(() {
                            fromDate = null;
                            fromDateController.clear();
                          });
                          _applyFilters();
                        },
                      )
                    : null,
              );

              final toDateField = AppTextField(
                label: 'To Date',
                controller: toDateController,
                readOnly: true,
                onTap: _pickToDate,
                prefixIcon: Icon(Icons.calendar_today_rounded, size: 15, color: AppColors.textMuted),
                suffixIcon: toDate != null
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 15),
                        onPressed: () {
                          setState(() {
                            toDate = null;
                            toDateController.clear();
                          });
                          _applyFilters();
                        },
                      )
                    : null,
              );

              final partyFilterField = Obx(
                () => AppDropdown<String>(
                  label: 'Party Filter',
                  isMultiSelect: true,
                  selectedValues: _selectedTypeParties.toList(),
                  dropdownItems: multiDropdownItemsParty,
                  hintText: 'All Parties...',
                  onMultiChanged: (values) {
                    _selectedTypeParties.assignAll(values);
                    final selectedInt = _selectedTypeParties.map((p) => int.parse(p)).toList();
                    memoPendingDataGridSource.setSelectedParties(selectedInt.isNotEmpty ? selectedInt : null);
                    outstandingPurchaseDataGridSource.setSelectedParties(selectedInt.isNotEmpty ? selectedInt : null);
                    outstandingSaleDataGridSource.setSelectedParties(selectedInt.isNotEmpty ? selectedInt : null);
                    setState(() {});
                  },
                ),
              );

              final brokerFilterField = Obx(
                () => AppDropdown<String>(
                  label: 'Broker Filter',
                  isMultiSelect: true,
                  selectedValues: _selectedTypeBrokers.toList(),
                  dropdownItems: multiDropdownItemsBroker,
                  hintText: 'All Brokers...',
                  onMultiChanged: (values) {
                    _selectedTypeBrokers.assignAll(values);
                    final selectedInt = _selectedTypeBrokers.map((b) => int.parse(b)).toList();
                    memoPendingDataGridSource.setSelectedBrokers(selectedInt.isNotEmpty ? selectedInt : null);
                    outstandingPurchaseDataGridSource.setSelectedBrokers(selectedInt.isNotEmpty ? selectedInt : null);
                    outstandingSaleDataGridSource.setSelectedBrokers(selectedInt.isNotEmpty ? selectedInt : null);
                    setState(() {});
                  },
                ),
              );

              final roughFilterField = Obx(
                () => AppDropdown<String>(
                  label: 'Rough Type Filter',
                  isMultiSelect: true,
                  selectedValues: _selectedTypeRoughs.toList(),
                  dropdownItems: dropdownItemsRough,
                  hintText: 'All Rough Types...',
                  onMultiChanged: (values) {
                    _selectedTypeRoughs.assignAll(values);
                    final selectedInt = _selectedTypeRoughs.map((r) => int.parse(r)).toList();
                    memoPendingDataGridSource.setSelectedRoughs(selectedInt);
                    outstandingPurchaseDataGridSource.setSelectedRoughs(selectedInt);
                    outstandingSaleDataGridSource.setSelectedRoughs(selectedInt);
                    setState(() {});
                  },
                ),
              );

              if (constraints.maxWidth >= 1000) {
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(flex: 3, child: reportTypeField),
                        const SizedBox(width: 12),
                        Expanded(flex: 2, child: fromDateField),
                        const SizedBox(width: 12),
                        Expanded(flex: 2, child: toDateField),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: partyFilterField),
                        const SizedBox(width: 12),
                        Expanded(child: brokerFilterField),
                        const SizedBox(width: 12),
                        Expanded(child: roughFilterField),
                      ],
                    ),
                  ],
                );
              } else if (constraints.maxWidth >= 650) {
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(flex: 3, child: reportTypeField),
                        const SizedBox(width: 12),
                        Expanded(flex: 2, child: fromDateField),
                        const SizedBox(width: 12),
                        Expanded(flex: 2, child: toDateField),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: partyFilterField),
                        const SizedBox(width: 12),
                        Expanded(child: brokerFilterField),
                      ],
                    ),
                    const SizedBox(height: 10),
                    roughFilterField,
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    reportTypeField,
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: fromDateField),
                        const SizedBox(width: 10),
                        Expanded(child: toDateField),
                      ],
                    ),
                    const SizedBox(height: 10),
                    partyFilterField,
                    const SizedBox(height: 10),
                    brokerFilterField,
                    const SizedBox(height: 10),
                    roughFilterField,
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    return Obx(() {
      final isPdfSupported = _selectedTypeReport.value == 'PURCHASE OUTSTANDING' ||
          _selectedTypeReport.value == 'SALE OUTSTANDING';

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 750;

            final buttons = Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AppButton(
                  text: 'Show Report',
                  icon: Icons.search_rounded,
                  variant: AppButtonVariant.primary,
                  onPressed: _applyFilters,
                ),
                AppButton(
                  text: 'Reset Filters',
                  icon: Icons.refresh_rounded,
                  variant: AppButtonVariant.secondary,
                  onPressed: _resetFilters,
                ),
                if (isPdfSupported)
                  AppButton(
                    text: 'Print PDF',
                    icon: Icons.print_rounded,
                    variant: AppButtonVariant.outline,
                    onPressed: _printPdf,
                  ),
                AppButton(
                  text: 'Exit',
                  icon: Icons.close_rounded,
                  variant: AppButtonVariant.danger,
                  onPressed: _exitScreen,
                ),
              ],
            );

            final recordBadge = _selectedTypeReport.value.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.tableRowAlt,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.format_list_bulleted_rounded, size: 14, color: AppColors.textMuted),
                        const SizedBox(width: 6),
                        Text(
                          'Total Records: $_recordCount',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink();

            if (isCompact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buttons,
                  if (_selectedTypeReport.value.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Align(alignment: Alignment.centerLeft, child: recordBadge),
                  ],
                ],
              );
            }

            return Row(
              children: [
                buttons,
                const Spacer(),
                recordBadge,
              ],
            );
          },
        ),
      );
    });
  }

  Widget _buildDataGridCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Obx(() {
          if (_selectedTypeReport.value.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.analytics_outlined, size: 54, color: AppColors.textMuted.withValues(alpha: 0.5)),
                  const SizedBox(height: 12),
                  Text(
                    'No Report Selected',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Please select a report type from the dropdown above to view data.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            );
          }

          switch (_selectedTypeReport.value) {
            case 'STOCK':
              return _buildStockDataGrid();
            case 'MEMO PENDING':
              return _buildMemoPendingDataGrid();
            case 'PURCHASE OUTSTANDING':
              return _buildPurchaseOutstandingDataGrid();
            case 'SALE OUTSTANDING':
              return _buildSaleOutstandingDataGrid();
            default:
              return Center(
                child: Text(
                  _selectedTypeReport.value,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              );
          }
        }),
      ),
    );
  }

  Widget _gridHeader(String label, {Alignment alignment = Alignment.center}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      alignment: alignment,
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildStockDataGrid() {
    return AppDataGrid(
      controller: _dataGridController,
      source: stockDataGridSource,
      columnWidthMode: ColumnWidthMode.fill,
      rowHeight: 28,
      headerRowHeight: 36,
      allowSorting: true,
      allowMultiColumnSorting: true,
      showSortNumbers: true,
      allowFiltering: true,
      allowColumnsResizing: true,
      selectionMode: SelectionMode.singleDeselect,
      columns: <GridColumn>[
        GridColumn(
          columnName: 'Rough',
          label: _gridHeader('Rough', alignment: Alignment.centerLeft),
        ),
        GridColumn(
          columnName: 'Pur Wt',
          label: _gridHeader('Pur Wt', alignment: Alignment.centerRight),
        ),
        GridColumn(
          columnName: 'Sell Wt',
          label: _gridHeader('Sell Wt', alignment: Alignment.centerRight),
        ),
        GridColumn(
          columnName: 'Memo Wt',
          label: _gridHeader('Memo Wt', alignment: Alignment.centerRight),
        ),
        GridColumn(
          columnName: 'Loss Wt',
          label: _gridHeader('Loss Wt', alignment: Alignment.centerRight),
        ),
        GridColumn(
          columnName: 'Stock Wt',
          label: _gridHeader('Stock Wt', alignment: Alignment.centerRight),
        ),
      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          title: 'Total',
          showSummaryInRow: false,
          titleColumnSpan: 1,
          columns: const <GridSummaryColumn>[
            GridSummaryColumn(name: 'Pur Wt', columnName: 'Pur Wt', summaryType: GridSummaryType.sum),
            GridSummaryColumn(name: 'Sell Wt', columnName: 'Sell Wt', summaryType: GridSummaryType.sum),
            GridSummaryColumn(name: 'Memo Wt', columnName: 'Memo Wt', summaryType: GridSummaryType.sum),
            GridSummaryColumn(name: 'Loss Wt', columnName: 'Loss Wt', summaryType: GridSummaryType.sum),
            GridSummaryColumn(name: 'Stock Wt', columnName: 'Stock Wt', summaryType: GridSummaryType.sum),
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
    );
  }

  Widget _buildMemoPendingDataGrid() {
    return AppDataGrid(
      controller: _dataGridController,
      source: memoPendingDataGridSource,
      columnWidthMode: ColumnWidthMode.fill,
      rowHeight: 28,
      headerRowHeight: 36,
      allowSorting: true,
      allowMultiColumnSorting: true,
      showSortNumbers: true,
      allowFiltering: true,
      allowColumnsResizing: true,
      selectionMode: SelectionMode.singleDeselect,
      columns: <GridColumn>[
        GridColumn(columnName: 'Id', label: _gridHeader('ID', alignment: Alignment.center)),
        GridColumn(columnName: 'Date', label: _gridHeader('Date', alignment: Alignment.center)),
        GridColumn(columnName: 'Rough', label: _gridHeader('Rough', alignment: Alignment.centerLeft)),
        GridColumn(columnName: 'Iss Wt', label: _gridHeader('Iss Wt', alignment: Alignment.centerRight)),
        GridColumn(columnName: 'Rate', label: _gridHeader('Rate', alignment: Alignment.centerRight)),
        GridColumn(columnName: 'Amount', label: _gridHeader('Amount', alignment: Alignment.centerRight)),
        GridColumn(columnName: 'Party', label: _gridHeader('Party', alignment: Alignment.centerLeft)),
        GridColumn(columnName: 'Broker', label: _gridHeader('Broker', alignment: Alignment.centerLeft)),
      ],
    );
  }

  Widget _buildPurchaseOutstandingDataGrid() {
    return AppDataGrid(
      controller: _dataGridController,
      source: outstandingPurchaseDataGridSource,
      columnWidthMode: ColumnWidthMode.fill,
      rowHeight: 28,
      headerRowHeight: 36,
      allowSorting: true,
      allowMultiColumnSorting: true,
      showSortNumbers: true,
      allowFiltering: true,
      allowColumnsResizing: true,
      selectionMode: SelectionMode.singleDeselect,
      columns: <GridColumn>[
        GridColumn(columnName: 'Inv No.', label: _gridHeader('Inv No.', alignment: Alignment.center)),
        GridColumn(columnName: 'Inv Date', label: _gridHeader('Inv Date', alignment: Alignment.center)),
        GridColumn(columnName: 'Due Days', label: _gridHeader('Due Days', alignment: Alignment.centerRight)),
        GridColumn(columnName: 'Due Date', label: _gridHeader('Due Date', alignment: Alignment.center)),
        GridColumn(columnName: 'Party', label: _gridHeader('Party', alignment: Alignment.centerLeft)),
        GridColumn(columnName: 'Inv Amt Rs', label: _gridHeader('Inv Amt (₹)', alignment: Alignment.centerRight)),
        GridColumn(columnName: 'Out Rs', label: _gridHeader('Out Amt (₹)', alignment: Alignment.centerRight)),
        GridColumn(columnName: 'Tot Out Rs', label: _gridHeader('Total Out (₹)', alignment: Alignment.centerRight)),
      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          title: 'Total',
          showSummaryInRow: false,
          titleColumnSpan: 1,
          columns: const <GridSummaryColumn>[
            GridSummaryColumn(name: 'Inv Amt Rs', columnName: 'Inv Amt Rs', summaryType: GridSummaryType.sum),
            GridSummaryColumn(name: 'Out Rs', columnName: 'Out Rs', summaryType: GridSummaryType.sum),
            GridSummaryColumn(name: 'Tot Out Rs', columnName: 'Tot Out Rs', summaryType: GridSummaryType.sum),
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
    );
  }

  Widget _buildSaleOutstandingDataGrid() {
    return AppDataGrid(
      controller: _dataGridController,
      source: outstandingSaleDataGridSource,
      columnWidthMode: ColumnWidthMode.fill,
      rowHeight: 28,
      headerRowHeight: 36,
      allowSorting: true,
      allowMultiColumnSorting: true,
      showSortNumbers: true,
      allowFiltering: true,
      allowColumnsResizing: true,
      selectionMode: SelectionMode.singleDeselect,
      columns: <GridColumn>[
        GridColumn(columnName: 'Inv No.', label: _gridHeader('Inv No.', alignment: Alignment.center)),
        GridColumn(columnName: 'Inv Date', label: _gridHeader('Inv Date', alignment: Alignment.center)),
        GridColumn(columnName: 'Due Days', label: _gridHeader('Due Days', alignment: Alignment.centerRight)),
        GridColumn(columnName: 'Due Date', label: _gridHeader('Due Date', alignment: Alignment.center)),
        GridColumn(columnName: 'Party', label: _gridHeader('Party', alignment: Alignment.centerLeft)),
        GridColumn(columnName: 'Inv Amt Rs', label: _gridHeader('Inv Amt (₹)', alignment: Alignment.centerRight)),
        GridColumn(columnName: 'Out Rs', label: _gridHeader('Out Amt (₹)', alignment: Alignment.centerRight)),
        GridColumn(columnName: 'Tot Out Rs', label: _gridHeader('Total Out (₹)', alignment: Alignment.centerRight)),
      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          title: 'Total',
          showSummaryInRow: false,
          titleColumnSpan: 1,
          columns: const <GridSummaryColumn>[
            GridSummaryColumn(name: 'Inv Amt Rs', columnName: 'Inv Amt Rs', summaryType: GridSummaryType.sum),
            GridSummaryColumn(name: 'Out Rs', columnName: 'Out Rs', summaryType: GridSummaryType.sum),
            GridSummaryColumn(name: 'Tot Out Rs', columnName: 'Tot Out Rs', summaryType: GridSummaryType.sum),
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
    );
  }
}
