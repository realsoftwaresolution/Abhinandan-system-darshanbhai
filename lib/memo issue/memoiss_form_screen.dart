import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/common/components/app_button.dart';
import 'package:real_web_rough_entry_system/common/components/app_data_grid.dart';
import 'package:real_web_rough_entry_system/common/components/app_dropdown.dart';
import 'package:real_web_rough_entry_system/common/components/app_shortcuts.dart';
import 'package:real_web_rough_entry_system/common/components/app_text_field.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/header.dart';
import 'package:real_web_rough_entry_system/memo%20issue/invoice_generator.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memo_issue_datagrid.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memo_issue_details_model.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memo_issue_model.dart';
import 'package:real_web_rough_entry_system/responsive.dart';

class MemoIssFormScreen extends StatefulWidget {
  final bool showHeader;
  const MemoIssFormScreen({super.key, required this.showHeader});

  @override
  MemoIssFormScreenState createState() => MemoIssFormScreenState();
}

class MemoIssFormScreenState extends State<MemoIssFormScreen> {
  // Master Controllers
  final TextEditingController dateController = TextEditingController();

  // Rough Item Line Controllers
  final TextEditingController descripController = TextEditingController();
  final TextEditingController wtController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  // Search Filter Controllers
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  // Focus Nodes for ERP Keyboard Navigation
  final FocusNode _partyFocNode = FocusNode();
  final FocusNode _dateFocus = FocusNode();
  final FocusNode _brokerFocus = FocusNode();
  final FocusNode _roughFocNode = FocusNode();
  final FocusNode _descFocus = FocusNode();
  final FocusNode _wtFocus = FocusNode();
  final FocusNode _rateFocus = FocusNode();
  final FocusNode _searchKeyBoardFocus = FocusNode();

  final DataGridController _dataGridController = DataGridController();

  // State Variables
  List<Map<String, String>> entries = [];
  final RxString _selectedType = ''.obs;
  final RxString _selectedTypeBroker = '22'.obs;
  final RxString _selectedTypeParty = ''.obs;
  final RxInt selectedMemoIssueMstID = 0.obs;
  final RxString selectedRoughId = ''.obs;

  DateTime? selectedDate;
  String? dueDate;
  DateTime? fromDate;
  DateTime? toDate;

  bool _isEnabled = false;
  bool _isSearch = false;
  bool _isFromEdit = false;
  final RxBool _isFiltered = false.obs;
  final _formKey = GlobalKey<FormState>();

  final DefaultController defaultController = Get.find<DefaultController>();

  RxList<MemoIssueModel> memoIssueDataGridSource = <MemoIssueModel>[].obs;
  RxList<MemoIssueModel> filteredDataGridSource = <MemoIssueModel>[].obs;

  // Calculation Getters
  double get totalWt =>
      entries.fold(0.0, (prev, e) => prev + (double.tryParse(e['wt'] ?? '0') ?? 0.0));

  double get totalAmount =>
      entries.fold(0.0, (prev, e) => prev + (double.tryParse(e['amount'] ?? '0') ?? 0.0));

  double get totalRate => totalWt == 0 ? 0 : totalAmount / totalWt;

  @override
  void initState() {
    super.initState();
    wtController.addListener(_updateAmount);
    rateController.addListener(_updateAmount);
    memoIssueDataGridSource.value = defaultController.memoIssueList;
  }

  @override
  void dispose() {
    wtController.removeListener(_updateAmount);
    rateController.removeListener(_updateAmount);

    dateController.dispose();
    descripController.dispose();
    wtController.dispose();
    rateController.dispose();
    amountController.dispose();
    fromDateController.dispose();
    toDateController.dispose();

    _partyFocNode.dispose();
    _dateFocus.dispose();
    _brokerFocus.dispose();
    _roughFocNode.dispose();
    _descFocus.dispose();
    _wtFocus.dispose();
    _rateFocus.dispose();
    _searchKeyBoardFocus.dispose();
    super.dispose();
  }

  void _updateAmount() {
    final double wt = double.tryParse(wtController.text) ?? 0.0;
    final double rate = double.tryParse(rateController.text) ?? 0.0;
    final double amount = wt * rate;
    amountController.text = amount.toStringAsFixed(2);
  }

  // ==================== WORKFLOW & CRUD METHODS ====================

  void _enableFields({bool? needFocus}) {
    setState(() {
      _isEnabled = true;
      _isFromEdit = false;
      selectedMemoIssueMstID.value = 0;
      selectedDate = DateTime.now();
      dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
    });

    if (needFocus == null || needFocus) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _partyFocNode.requestFocus();
      });
    }
  }

  void _openDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        _brokerFocus.requestFocus();
      });
    }
  }

  void addEntry() {
    if (_selectedType.value.isEmpty) {
      infoDialog(messageText: 'Please select a Rough Type');
      _roughFocNode.requestFocus();
      return;
    }
    final double wt = double.tryParse(wtController.text) ?? 0.0;
    if (wt <= 0) {
      infoDialog(messageText: 'Please enter valid Weight');
      _wtFocus.requestFocus();
      return;
    }
    final double rate = double.tryParse(rateController.text) ?? 0.0;
    if (rate <= 0) {
      infoDialog(messageText: 'Please enter valid Rate');
      _rateFocus.requestFocus();
      return;
    }

    final double amount = wt * rate;

    setState(() {
      entries.add({
        if (selectedRoughId.value.isNotEmpty) 'id': selectedRoughId.value,
        'rough': _selectedType.value,
        'description': descripController.text,
        'wt': wtController.text,
        'rate': rateController.text,
        'amount': amount.toStringAsFixed(2),
      });

      _selectedType.value = '';
      selectedRoughId.value = '';
      descripController.clear();
      wtController.clear();
      rateController.clear();
      amountController.clear();

      Future.delayed(const Duration(milliseconds: 50), () {
        _roughFocNode.requestFocus();
      });
    });
  }

  void _deleteRoughEntry(int index) {
    if (_isFromEdit) {
      if (entries.length == 1) {
        infoDialog(messageText: 'Cannot delete the only remaining rough item.');
        return;
      }
      final entryId = int.tryParse(entries[index]['id'] ?? '');
      if (entryId != null) {
        defaultController.deleteMemoIssueRoughData(id: entryId).then((_) {
          setState(() {
            entries.removeAt(index);
          });
        });
      } else {
        setState(() {
          entries.removeAt(index);
        });
      }
    } else {
      setState(() {
        entries.removeAt(index);
      });
    }
  }

  void _editRoughEntry(int index) {
    final entry = entries[index];
    if (_isFromEdit) {
      selectedRoughId.value = entry['id'] ?? '';
    }
    _selectedType.value = entry['rough'] ?? '';
    descripController.text = entry['description'] ?? '';
    wtController.text = entry['wt'] ?? '';
    rateController.text = entry['rate'] ?? '';
    _updateAmount();

    setState(() {
      entries.removeAt(index);
    });
    _roughFocNode.requestFocus();
  }

  Future<void> _handleSave() async {
    if (!_isEnabled) return;

    if (_selectedTypeParty.value.isEmpty) {
      infoDialog(messageText: 'Please select a Party.');
      _partyFocNode.requestFocus();
      return;
    }

    if (entries.isEmpty) {
      infoDialog(messageText: 'Please add at least one rough item.');
      _roughFocNode.requestFocus();
      return;
    }

    if (_isFromEdit) {
      await defaultController.updateMemoIssueData(
        id: selectedMemoIssueMstID.value,
        partyCode: _selectedTypeParty.value,
        invoiceDate: selectedDate,
        brokerCode: _selectedTypeBroker.value,
        entries: entries,
        totalAmt: totalAmount,
        totalWt: totalWt,
        totalRate: totalRate,
      );
      _handleCancel();
    } else {
      await defaultController.addMemoIssueData(
        partyCode: _selectedTypeParty.value,
        invoiceDate: selectedDate,
        brokerCode: _selectedTypeBroker.value,
        dueDate: dueDate,
        entries: entries,
        totalAmt: totalAmount,
        totalWt: totalWt,
        totalRate: totalRate,
      );
      _handleCancel();
    }
  }

  Future<void> _handleDelete() async {
    if (!_isEnabled || !_isFromEdit) return;
    await defaultController.deleteMemoIssueData(
      id: selectedMemoIssueMstID.value,
      entries: entries,
    );
    _handleCancel();
  }

  void _handleCancel() {
    dateController.clear();
    descripController.clear();
    wtController.clear();
    rateController.clear();
    amountController.clear();
    _selectedTypeParty.value = '';
    _selectedType.value = '';
    _selectedTypeBroker.value = '22';
    selectedRoughId.value = '';
    selectedMemoIssueMstID.value = 0;
    entries.clear();
    setState(() {
      _isFromEdit = false;
      _isEnabled = false;
    });
  }

  Future<void> _handlePrint() async {
    if (!_isFromEdit || selectedDate == null || _selectedTypeParty.value.isEmpty) return;

    final invoiceGenerator = MemoIssueInvoiceGenerator();
    final pdfData = await invoiceGenerator.generateInvoice(
      id: selectedMemoIssueMstID.value,
      invoiceDate: selectedDate!,
      partyCode: _selectedTypeParty.value,
      entries: entries,
      totalWt: totalWt,
      totalAmt: totalAmount,
      totalRate: totalRate,
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfData,
    );

    if (!kDebugMode) {
      await Printing.sharePdf(
        bytes: pdfData,
        filename: 'Memo-Issue/${getPartyName(int.parse(_selectedTypeParty.value))}/${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    }
  }

  void _selectMemoById(int id) {
    selectedMemoIssueMstID.value = id;

    final MemoIssueModel partyEntry = defaultController.memoIssueList.firstWhere(
      (entry) => entry.memoIssueMstID == id,
    );

    final List<MemoIssueDetailsModel> roughEntries = defaultController.memoIssueDetailsList
        .where((entry) => entry.memoIssueMstID == id)
        .toList();

    selectedDate = dateFormat(partyEntry.invoiceDate!);
    dateController.text = formatDate(partyEntry.invoiceDate!);
    _selectedTypeParty.value = partyEntry.partyCode.toString();
    _selectedTypeBroker.value = (partyEntry.brokerCode ?? 22).toString();

    entries.clear();
    for (var roughEntry in roughEntries) {
      entries.add({
        'id': roughEntry.memoIssueDetID.toString(),
        'rough': roughEntry.roughTypeCode.toString(),
        'description': roughEntry.description?.toString() ?? '',
        'wt': (roughEntry.carats ?? 0.0).toString(),
        'rate': (roughEntry.rateRs ?? 0.0).toString(),
        'amount': ((roughEntry.carats ?? 0.0) * (roughEntry.rateRs ?? 0.0)).toStringAsFixed(2),
      });
    }

    setState(() {
      _isFromEdit = true;
      _isEnabled = true;
      _isSearch = false;
    });
  }

  // ==================== SEARCH DATE FILTERING ====================

  void _applyDateFilter() {
    if (fromDate != null && toDate != null) {
      _isFiltered.value = true;
      filteredDataGridSource.value = defaultController.memoIssueList.where((memo) {
        if (memo.invoiceDate == null) return false;
        final invoiceDate = DateTime.parse(memo.invoiceDate!);
        return invoiceDate.isAfter(fromDate!) &&
            invoiceDate.isBefore(toDate!.add(const Duration(days: 1)));
      }).toList();
      memoIssueDataGridSource.value = filteredDataGridSource;
      _searchKeyBoardFocus.requestFocus();
    } else {
      infoDialog(messageText: 'Please select both From Date and To Date');
    }
  }

  void _removeDateFilter() {
    memoIssueDataGridSource.value = defaultController.memoIssueList;
    toDateController.clear();
    fromDateController.clear();
    fromDate = null;
    toDate = null;
    _isFiltered.value = false;
  }

  // ==================== DROPDOWNS ====================

  List<DropdownMenuItem<String>> get dropdownItemsRough {
    return defaultController.roughModel
        .map((item) => DropdownMenuItem<String>(
              value: item.roughTypeCode.toString(),
              child: Text(item.roughTypeName ?? '', style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
            ))
        .toList();
  }

  List<DropdownMenuItem<String>> get dropdownItemsParty {
    final seen = <int>{};
    return defaultController.partyMstList
        .where((p) =>
            (p.typeCode == 2 || p.partyCode.toString() == _selectedTypeParty.value) &&
            p.companyCode == defaultController.companyCode.value &&
            p.partyCode != null &&
            seen.add(p.partyCode!))
        .map((p) => DropdownMenuItem<String>(
              value: p.partyCode.toString(),
              child: Text(p.partyName ?? '', style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
            ))
        .toList();
  }

  List<DropdownMenuItem<String>> get dropdownItemsBroker {
    final seen = <int>{};
    return defaultController.partyMstList
        .where((p) =>
            (p.typeCode == 5 || p.partyCode.toString() == _selectedTypeBroker.value) &&
            p.companyCode == defaultController.companyCode.value &&
            p.partyCode != null &&
            seen.add(p.partyCode!))
        .map((p) => DropdownMenuItem<String>(
              value: p.partyCode.toString(),
              child: Text(p.partyName ?? '', style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
            ))
        .toList();
  }

  // ==================== MAIN BUILD METHOD ====================

  @override
  Widget build(BuildContext context) {
    return AppKeyboardShortcutHandler(
      onAdd: !_isEnabled ? () => _enableFields() : null,
      onSave: _isEnabled ? _handleSave : null,
      onDelete: (_isEnabled && _isFromEdit) ? _handleDelete : null,
      onCancel: _isEnabled ? _handleCancel : null,
      onExit: () {
        if (_isSearch) {
          setState(() => _isSearch = false);
        } else {
          tabController.closeCurrentTab();
        }
      },
      onSearch: () {
        setState(() {
          _isSearch = !_isSearch;
        });
      },
      onPrint: _isFromEdit ? _handlePrint : null,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            if (widget.showHeader) Header(title: _isSearch ? 'Memo Issue Search' : 'Memo Issue Entry'),
            Expanded(
              child: _isSearch ? _buildSearchView() : _buildFormView(),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== SEARCH / DIRECTORY VIEW ====================

  Widget _buildSearchView() {
    return KeyboardListener(
      focusNode: _searchKeyBoardFocus,
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          final int currentIndex = _dataGridController.selectedIndex;
          final int totalRows = memoIssueDataGridSource.length;

          if (event.logicalKey == LogicalKeyboardKey.enter && _dataGridController.selectedRow != null) {
            final int id = _dataGridController.selectedRow!.getCells()[0].value;
            _selectMemoById(id);
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown && currentIndex < totalRows - 1) {
            _dataGridController.selectedIndex = currentIndex + 1;
            _dataGridController.scrollToRow(double.parse(_dataGridController.selectedIndex.toString()));
          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp && currentIndex > 0) {
            _dataGridController.selectedIndex = currentIndex - 1;
            _dataGridController.scrollToRow(double.parse(_dataGridController.selectedIndex.toString()));
          } else if (event.logicalKey == LogicalKeyboardKey.escape || event.logicalKey == LogicalKeyboardKey.keyE) {
            setState(() => _isSearch = false);
          } else if (event.logicalKey == LogicalKeyboardKey.keyR && _isFiltered.value) {
            _removeDateFilter();
          } else if (event.logicalKey == LogicalKeyboardKey.keyF) {
            _applyDateFilter();
          }
        }
      },
      child: Column(
        children: [
          // Filter Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 700;
              final dateFields = [
                AppTextField(
                  label: 'From Date',
                  controller: fromDateController,
                  readOnly: true,
                  prefixIcon: const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.textSecondary),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        fromDate = picked;
                        fromDateController.text = DateFormat('dd-MM-yyyy').format(picked);
                        if (toDateController.text.isNotEmpty) _applyDateFilter();
                      });
                    }
                  },
                ),
                AppTextField(
                  label: 'To Date',
                  controller: toDateController,
                  readOnly: true,
                  prefixIcon: const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.textSecondary),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        toDate = picked;
                        toDateController.text = DateFormat('dd-MM-yyyy').format(picked);
                        if (fromDateController.text.isNotEmpty) _applyDateFilter();
                      });
                    }
                  },
                ),
              ];

              final actionButtons = Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  AppButton(
                    text: 'Filter',
                    shortcutLabel: 'F',
                    icon: Icons.filter_alt_rounded,
                    onPressed: _applyDateFilter,
                  ),
                  Obx(() => AppButton(
                        text: 'Reset',
                        shortcutLabel: 'R',
                        icon: Icons.refresh_rounded,
                        variant: AppButtonVariant.secondary,
                        onPressed: _isFiltered.value ? _removeDateFilter : null,
                      )),
                  AppButton(
                    text: 'Close Search',
                    shortcutLabel: 'Esc',
                    icon: Icons.close_rounded,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => setState(() => _isSearch = false),
                  ),
                ],
              );

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(child: dateFields[0]),
                        const SizedBox(width: 10),
                        Expanded(child: dateFields[1]),
                      ],
                    ),
                    const SizedBox(height: 10),
                    actionButtons,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: dateFields[0]),
                  const SizedBox(width: 12),
                  Expanded(child: dateFields[1]),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: actionButtons,
                  ),
                ],
              );
            },
          ),
          ),
          Obx(() => defaultController.isLoading.value
              ? const LinearProgressIndicator(color: AppColors.primary, minHeight: 2)
              : const SizedBox.shrink()),
          // Table of Memos
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Obx(
                    () => AppDataGrid(
                      controller: _dataGridController,
                      source: MemoIssueDataGridSource(memoIssueDataGridSource),
                      columns: _buildSearchGridColumns(),
                      tableSummaryRows: [
                        GridTableSummaryRow(
                          title: 'Total ${memoIssueDataGridSource.length}',
                          showSummaryInRow: false,
                          titleColumnSpan: 1,
                          columns: const <GridSummaryColumn>[
                            GridSummaryColumn(name: 'Tot Wt', columnName: 'Tot Wt', summaryType: GridSummaryType.sum),
                            GridSummaryColumn(name: 'Tot Amt Rs', columnName: 'Tot Amt Rs', summaryType: GridSummaryType.sum),
                          ],
                          position: GridTableSummaryRowPosition.bottom,
                        )
                      ],
                      rowHeight: 30,
                      headerRowHeight: 36,
                      allowSorting: true,
                      allowMultiColumnSorting: true,
                      showSortNumbers: true,
                      allowFiltering: true,
                      allowColumnsResizing: true,
                      selectionMode: SelectionMode.single,
                      columnWidthMode: ColumnWidthMode.auto,
                      frozenColumnsCount: 1,
                      onSelectionChanged: (addedRows, removedRows) {
                        if (addedRows.isNotEmpty) {
                          final int id = addedRows.first.getCells()[0].value;
                          _selectMemoById(id);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== MAIN FORM VIEW ====================

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(Responsive.isMobile(context) ? 10 : 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Toolbar & Mode Badge
            _buildTopToolbar(),
            const SizedBox(height: 12),

            // Card 1: Memo Header & Parties
            _buildHeaderCard(),
            const SizedBox(height: 12),

            // Card 2: Rough Item Quick Entry Bar
            _buildQuickEntryCard(),
            const SizedBox(height: 12),

            // Card 3: Memo Items Table
            _buildEntriesTableCard(),
            const SizedBox(height: 16),

            // Bottom Action Bar
            _buildBottomActionBar(),
          ],
        ),
      ),
    );
  }

  // ==================== SUB-COMPONENTS ====================

  Widget _buildTopToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 650;
          final titleWidget = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.outbox_rounded, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Memo Issue Entry',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  Text(
                    _isFromEdit
                        ? 'Editing Memo #${selectedMemoIssueMstID.value}'
                        : (_isEnabled ? 'New Memo Issue' : 'Press [Alt+A] to create a new memo'),
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          );

          final actionsWidget = Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _isFromEdit
                      ? AppColors.warning.withValues(alpha: 0.12)
                      : (_isEnabled ? AppColors.success.withValues(alpha: 0.12) : AppColors.border),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _isFromEdit
                        ? AppColors.warning
                        : (_isEnabled ? AppColors.success : AppColors.textMuted),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isFromEdit
                          ? Icons.edit_note_rounded
                          : (_isEnabled ? Icons.add_circle_outline_rounded : Icons.lock_outline_rounded),
                      size: 14,
                      color: _isFromEdit
                          ? AppColors.warning
                          : (_isEnabled ? AppColors.success : AppColors.textSecondary),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _isFromEdit
                          ? 'EDIT MODE: #${selectedMemoIssueMstID.value}'
                          : (_isEnabled ? 'CREATE MODE' : 'READ ONLY'),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _isFromEdit
                            ? AppColors.warning
                            : (_isEnabled ? AppColors.success : AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              AppButton(
                text: 'Search List',
                icon: Icons.search_rounded,
                variant: AppButtonVariant.outline,
                onPressed: () => setState(() => _isSearch = true),
              ),
            ],
          );

          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleWidget,
                const SizedBox(height: 10),
                actionsWidget,
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              titleWidget,
              actionsWidget,
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MEMO IDENTIFICATION & PARTIES',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 0.5),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final partyField = Obx(
                  () => AppDropdown<String>(
                    label: 'Memo Party',
                    value: _selectedTypeParty.value.isEmpty ? null : _selectedTypeParty.value,
                    items: dropdownItemsParty,
                    focusNode: _partyFocNode,
                    nextFocusNode: _dateFocus,
                    hintText: 'Select Party',
                    isEnabled: _isEnabled,
                    onChanged: (value) {
                      if (value != null) {
                        _selectedTypeParty.value = value;
                      }
                    },
                  ),
                );

                final dateField = Focus(
                  onKeyEvent: (node, event) {
                    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
                      _openDatePicker();
                      return KeyEventResult.handled;
                    }
                    return KeyEventResult.ignored;
                  },
                  child: AppTextField(
                    label: 'Issue Date',
                    controller: dateController,
                    focusNode: _dateFocus,
                    nextFocusNode: _brokerFocus,
                    enabled: _isEnabled && !_isFromEdit,
                    readOnly: true,
                    prefixIcon: const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.primary),
                    onTap: (_isEnabled && !_isFromEdit) ? _openDatePicker : null,
                  ),
                );

                final brokerField = Obx(
                  () => AppDropdown<String>(
                    label: 'Broker',
                    value: _selectedTypeBroker.value.isEmpty ? null : _selectedTypeBroker.value,
                    items: dropdownItemsBroker,
                    focusNode: _brokerFocus,
                    nextFocusNode: _roughFocNode,
                    hintText: 'Select Broker',
                    isEnabled: _isEnabled,
                    onChanged: (value) {
                      if (value != null) {
                        _selectedTypeBroker.value = value;
                      }
                    },
                  ),
                );

                if (constraints.maxWidth >= 750) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: partyField),
                      const SizedBox(width: 12),
                      Expanded(flex: 3, child: dateField),
                      const SizedBox(width: 12),
                      Expanded(flex: 3, child: brokerField),
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
                          Expanded(child: dateField),
                          const SizedBox(width: 12),
                          Expanded(child: brokerField),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      partyField,
                      const SizedBox(height: 10),
                      dateField,
                      const SizedBox(height: 10),
                      brokerField,
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickEntryCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ROUGH ITEM ENTRY (Press Enter to Add Row)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 0.5),
                ),
                Obx(
                  () => selectedRoughId.value.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('Editing Item #${selectedRoughId.value}',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.warning)),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final roughDropdown = Obx(
                  () => AppDropdown<String>(
                    label: 'Rough Type',
                    value: _selectedType.value.isEmpty ? null : _selectedType.value,
                    items: dropdownItemsRough,
                    focusNode: _roughFocNode,
                    nextFocusNode: _descFocus,
                    hintText: 'Select Rough',
                    isEnabled: _isEnabled,
                    onChanged: (value) {
                      if (value != null) {
                        _selectedType.value = value;
                      }
                    },
                  ),
                );

                final descField = AppTextField(
                  label: 'Description',
                  controller: descripController,
                  focusNode: _descFocus,
                  nextFocusNode: _wtFocus,
                  enabled: _isEnabled,
                  prefixIcon: const Icon(Icons.description_outlined, size: 16, color: AppColors.textSecondary),
                );

                final wtField = AppTextField(
                  label: 'Weight (Carats)',
                  controller: wtController,
                  focusNode: _wtFocus,
                  nextFocusNode: _rateFocus,
                  enabled: _isEnabled,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}'))],
                  prefixIcon: const Icon(Icons.scale_rounded, size: 16, color: AppColors.textSecondary),
                );

                final rateField = AppTextField(
                  label: 'Rate (Rs)',
                  controller: rateController,
                  focusNode: _rateFocus,
                  enabled: _isEnabled,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}'))],
                  prefixIcon: const Icon(Icons.currency_rupee_rounded, size: 16, color: AppColors.textSecondary),
                  onFieldSubmitted: (_) => addEntry(),
                );

                final amountField = AppTextField(
                  label: 'Amount (Rs)',
                  controller: amountController,
                  enabled: false,
                  prefixIcon: const Icon(Icons.calculate_outlined, size: 16, color: AppColors.textSecondary),
                );

                final addButton = Obx(
                  () => AppButton(
                    text: selectedRoughId.value.isNotEmpty ? 'Update' : 'Add Item',
                    shortcutLabel: 'Enter',
                    icon: selectedRoughId.value.isNotEmpty ? Icons.check_rounded : Icons.add_rounded,
                    onPressed: _isEnabled ? addEntry : null,
                  ),
                );

                if (constraints.maxWidth >= 1050) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: roughDropdown),
                      const SizedBox(width: 10),
                      Expanded(flex: 4, child: descField),
                      const SizedBox(width: 10),
                      Expanded(flex: 2, child: wtField),
                      const SizedBox(width: 10),
                      Expanded(flex: 2, child: rateField),
                      const SizedBox(width: 10),
                      Expanded(flex: 2, child: amountField),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: addButton,
                      ),
                    ],
                  );
                } else if (constraints.maxWidth >= 650) {
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 1, child: roughDropdown),
                          const SizedBox(width: 10),
                          Expanded(flex: 1, child: descField),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: wtField),
                          const SizedBox(width: 10),
                          Expanded(flex: 2, child: rateField),
                          const SizedBox(width: 10),
                          Expanded(flex: 2, child: amountField),
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: addButton,
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      roughDropdown,
                      const SizedBox(height: 10),
                      descField,
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: wtField),
                          const SizedBox(width: 10),
                          Expanded(child: rateField),
                        ],
                      ),
                      const SizedBox(height: 10),
                      amountField,
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: addButton,
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntriesTableCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final titleWidget = Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.format_list_bulleted_rounded, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      'MEMO ITEMS LIST (${entries.length})',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ],
                );

                final summaryPills = Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _buildSummaryPill('Total Wt: ', '${totalWt.toStringAsFixed(2)} Cts', AppColors.primary),
                    _buildSummaryPill('Avg Rate: ', '₹ ${totalRate.toStringAsFixed(2)}', AppColors.textPrimary),
                    _buildSummaryPill('Total Amt: ', '₹ ${totalAmount.toStringAsFixed(2)}', AppColors.success),
                  ],
                );

                if (constraints.maxWidth < 600) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleWidget,
                      const SizedBox(height: 8),
                      summaryPills,
                    ],
                  );
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    titleWidget,
                    summaryPills,
                  ],
                );
              },
            ),
            const SizedBox(height: 10),

            // Entries Table
            if (entries.isEmpty)
              Container(
                height: 120,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.diamond_outlined, size: 28, color: AppColors.textMuted),
                    SizedBox(height: 6),
                    Text('No rough items added yet', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    Text('Select a rough type, weight, rate, and press Enter to add', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth < 700 ? 700 : constraints.maxWidth,
                      ),
                      child: Table(
                        border: TableBorder.all(color: AppColors.border, width: 1),
                        columnWidths: const {
                          0: FixedColumnWidth(55),
                          1: FlexColumnWidth(2.5),
                          2: FlexColumnWidth(3.5),
                          3: FlexColumnWidth(2),
                          4: FlexColumnWidth(2),
                          5: FlexColumnWidth(2.5),
                          6: FixedColumnWidth(80),
                        },
                        children: [
                          // Table Header
                          TableRow(
                            decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
                            children: [
                              _buildTableHeaderCell('SR.NO', align: TextAlign.center),
                              _buildTableHeaderCell('ROUGH TYPE'),
                              _buildTableHeaderCell('DESCRIPTION'),
                              _buildTableHeaderCell('WT (CTS)', align: TextAlign.right),
                              _buildTableHeaderCell('RATE (RS)', align: TextAlign.right),
                              _buildTableHeaderCell('AMOUNT (RS)', align: TextAlign.right),
                              _buildTableHeaderCell('ACTIONS', align: TextAlign.center),
                            ],
                          ),
                          // Data Rows
                          for (int i = 0; i < entries.length; i++)
                            TableRow(
                              decoration: BoxDecoration(
                                color: i % 2 == 0 ? Colors.white : const Color(0xFFF8FAFC),
                              ),
                              children: [
                                _buildTableCell('${i + 1}', align: TextAlign.center),
                                _buildTableCell(getRoughName(entries[i]['rough']!)),
                                _buildTableCell(entries[i]['description']!),
                                _buildTableCell(entries[i]['wt']!, align: TextAlign.right),
                                _buildTableCell('₹ ${entries[i]['rate']!}', align: TextAlign.right),
                                _buildTableCell('₹ ${entries[i]['amount']!}', align: TextAlign.right, isBold: true),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () => _editRoughEntry(i),
                                          borderRadius: BorderRadius.circular(4),
                                          child: const Padding(
                                            padding: EdgeInsets.all(4),
                                            child: Icon(Icons.edit_outlined, size: 15, color: AppColors.primary),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        InkWell(
                                          onTap: () => _deleteRoughEntry(i),
                                          borderRadius: BorderRadius.circular(4),
                                          child: const Padding(
                                            padding: EdgeInsets.all(4),
                                            child: Icon(Icons.delete_outline_rounded, size: 15, color: AppColors.danger),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          // Totals Row
                          TableRow(
                            decoration: const BoxDecoration(color: Color(0xFFE2E8F0)),
                            children: [
                              _buildTableCell('', align: TextAlign.center),
                              _buildTableCell('TOTAL', isBold: true),
                              _buildTableCell('${entries.length} items', isBold: true),
                              _buildTableCell(totalWt.toStringAsFixed(2), align: TextAlign.right, isBold: true),
                              _buildTableCell('₹ ${totalRate.toStringAsFixed(2)}', align: TextAlign.right, isBold: true),
                              _buildTableCell('₹ ${totalAmount.toStringAsFixed(2)}', align: TextAlign.right, isBold: true, color: AppColors.primary),
                              _buildTableCell(''),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryPill(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  TableCell _buildTableHeaderCell(String text, {TextAlign align = TextAlign.left}) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Text(
          text,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          textAlign: align,
        ),
      ),
    );
  }

  TableCell _buildTableCell(String text, {TextAlign align = TextAlign.left, bool isBold = false, Color? color}) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color ?? AppColors.textPrimary,
          ),
          textAlign: align,
        ),
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          AppButton(
            text: 'Add',
            icon: Icons.add_rounded,
            onPressed: !_isEnabled ? () => _enableFields() : null,
          ),
          Obx(() => AppButton(
                text: 'Save',
                icon: Icons.save_rounded,
                isLoading: defaultController.isLoading.value,
                onPressed: _isEnabled ? _handleSave : null,
              )),
          Obx(() => AppButton(
                text: 'Delete',
                icon: Icons.delete_outline_rounded,
                variant: AppButtonVariant.danger,
                isLoading: defaultController.isDeleteLoading.value,
                onPressed: (_isFromEdit && _isEnabled) ? _handleDelete : null,
              )),
          AppButton(
            text: 'Cancel',
            icon: Icons.cancel_outlined,
            variant: AppButtonVariant.secondary,
            onPressed: _isEnabled ? _handleCancel : null,
          ),
          AppButton(
            text: 'Print Voucher',
            icon: Icons.print_rounded,
            variant: AppButtonVariant.outline,
            onPressed: (_isFromEdit && _isEnabled) ? _handlePrint : null,
          ),
          AppButton(
            text: 'Search',
            icon: Icons.search_rounded,
            variant: AppButtonVariant.outline,
            onPressed: () => setState(() => _isSearch = true),
          ),
          AppButton(
            text: 'Exit',
            icon: Icons.exit_to_app_rounded,
            variant: AppButtonVariant.secondary,
            onPressed: () => tabController.closeCurrentTab(),
          ),
        ],
      ),
    );
  }

  // ==================== DATAGRID COLUMNS DEFINITIONS ====================

  List<GridColumn> _buildSearchGridColumns() {
    return <GridColumn>[
      GridColumn(
        columnName: 'ID',
        visible: false,
        label: _buildGridHeader('ID'),
      ),
      GridColumn(
        columnName: 'Invoice Date',
        label: _buildGridHeader('Invoice Date'),
      ),
      GridColumn(
        columnName: 'Party',
        label: _buildGridHeader('Party'),
      ),
      GridColumn(
        columnName: 'Broker',
        label: _buildGridHeader('Broker'),
      ),
      GridColumn(
        columnName: 'Tot Wt',
        label: _buildGridHeader('Tot Wt'),
      ),
      GridColumn(
        columnName: 'Tot Amt Rs',
        label: _buildGridHeader('Tot Amt Rs'),
      ),
    ];
  }

  Widget _buildGridHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
