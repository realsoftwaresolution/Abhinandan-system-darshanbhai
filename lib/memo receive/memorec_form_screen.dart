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
import 'package:real_web_rough_entry_system/memo%20issue/memo_issue_details_datagrid.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memo_issue_details_model.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memo_issue_model.dart';
import 'package:real_web_rough_entry_system/memo%20receive/invoice_generator.dart';
import 'package:real_web_rough_entry_system/memo%20receive/memo_rec_details_model.dart';
import 'package:real_web_rough_entry_system/memo%20receive/memo_rec_model.dart';
import 'package:real_web_rough_entry_system/memo%20receive/memo_receive_datagrid.dart';
import 'package:real_web_rough_entry_system/responsive.dart';

class MemoRecFormScreen extends StatefulWidget {
  final bool showHeader;

  const MemoRecFormScreen({super.key, required this.showHeader});

  @override
  MemoRecFormScreenState createState() => MemoRecFormScreenState();
}

class MemoRecFormScreenState extends State<MemoRecFormScreen> {
  // Master Controllers
  final TextEditingController dateController = TextEditingController();

  // Item Line Controllers
  final TextEditingController descripController = TextEditingController();
  final TextEditingController issWtController = TextEditingController();
  final TextEditingController recWtController = TextEditingController();
  final TextEditingController lossWtController = TextEditingController(text: '0.000');
  final TextEditingController rateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  // Search Filter Controllers
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  // Focus Nodes for Keyboard Navigation
  final FocusNode _partyFocNode = FocusNode();
  final FocusNode _dateFocus = FocusNode();
  final FocusNode _brokerFocus = FocusNode();
  final FocusNode _recWtFocus = FocusNode();
  final FocusNode _keyBoardFocus = FocusNode();
  final FocusNode _searchKeyBoardFocus = FocusNode();

  final DataGridController _dataGridController = DataGridController();
  final DataGridController _dialogDataGridController = DataGridController();

  // State Variables
  List<Map<String, String>> recEntries = [];
  RxList<MemoIssueDetailsModel> allRoughDetails = <MemoIssueDetailsModel>[].obs;
  RxList<MemoIssueDetailsModel> selectedRoughDetails = <MemoIssueDetailsModel>[].obs;
  RxList<MemoIssueModel> allSelectedMemoIssue = <MemoIssueModel>[].obs;

  final RxString _selectedType = ''.obs;
  final RxString _selectedTypeBroker = '22'.obs;
  final RxString _selectedTypeParty = ''.obs;
  final RxInt selectedMemoRecMstID = 0.obs;
  final RxString selectedMemoIssueDetID = ''.obs;
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

  RxList<MemoRecModel> memoRecDataGridSource = <MemoRecModel>[].obs;
  RxList<MemoRecModel> filteredDataGridSource = <MemoRecModel>[].obs;

  // Calculation Getters
  double get totalWt =>
      recEntries.fold(0.0, (prev, e) => prev + (double.tryParse(e['wt'] ?? '0') ?? 0.0));

  double get totalRecWt =>
      recEntries.fold(0.0, (prev, e) => prev + (double.tryParse(e['recWt'] ?? '0') ?? 0.0));

  double get totalLossWt => totalWt - totalRecWt;

  double get totalRecAmount =>
      recEntries.fold(0.0, (prev, e) => prev + (double.tryParse(e['amount'] ?? '0') ?? 0.0));

  double get totalRecRate => totalRecWt == 0 ? 0 : totalRecAmount / totalRecWt;

  double get totalAmount => totalRecAmount;
  double get totalRate => totalRecRate;

  @override
  void initState() {
    super.initState();
    _addListeners();
    memoRecDataGridSource.value = defaultController.memoRecList;
  }

  void _addListeners() {
    recWtController.addListener(_calculateLossAndAmount);
    issWtController.addListener(_calculateLossAndAmount);
    rateController.addListener(_calculateLossAndAmount);
  }

  @override
  void dispose() {
    recWtController.removeListener(_calculateLossAndAmount);
    issWtController.removeListener(_calculateLossAndAmount);
    rateController.removeListener(_calculateLossAndAmount);

    dateController.dispose();
    descripController.dispose();
    issWtController.dispose();
    recWtController.dispose();
    lossWtController.dispose();
    rateController.dispose();
    amountController.dispose();
    fromDateController.dispose();
    toDateController.dispose();

    _partyFocNode.dispose();
    _dateFocus.dispose();
    _brokerFocus.dispose();
    _recWtFocus.dispose();
    _keyBoardFocus.dispose();
    _searchKeyBoardFocus.dispose();
    super.dispose();
  }

  void _calculateLossAndAmount() {
    final double issWt = double.tryParse(issWtController.text) ?? 0.0;
    final double recWt = double.tryParse(recWtController.text) ?? 0.0;
    final double rate = double.tryParse(rateController.text) ?? 0.0;

    if (recWt <= issWt && recWt >= 0) {
      final double loss = issWt - recWt;
      lossWtController.text = loss.toStringAsFixed(3);
    } else {
      lossWtController.text = '0.000';
    }

    if (rate > 0) {
      final double amount = recWt * rate;
      amountController.text = amount.toStringAsFixed(2);
    } else {
      amountController.text = '0.00';
    }
  }

  // ==================== WORKFLOW & CRUD METHODS ====================

  void _enableFields({bool? needFocus}) {
    setState(() {
      _isEnabled = true;
      _isFromEdit = false;
      selectedMemoRecMstID.value = 0;
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

  List<MemoIssueModel>? getMemoIssueByPartyAndBroker(int selectedPartyCode, int selectedBrokerCode) {
    return defaultController.memoIssueList
        .where((memo) =>
            memo.partyCode == selectedPartyCode &&
            (memo.brokerCode == selectedBrokerCode || (memo.brokerCode == null && selectedBrokerCode == 22)))
        .toList();
  }

  void _fetchPendingMemoIssueItems() {
    if (_selectedTypeParty.value.isEmpty || _selectedTypeBroker.value.isEmpty) return;

    final partyCode = int.tryParse(_selectedTypeParty.value);
    final brokerCode = int.tryParse(_selectedTypeBroker.value);
    if (partyCode == null || brokerCode == null) return;

    allSelectedMemoIssue.value = getMemoIssueByPartyAndBroker(partyCode, brokerCode) ?? [];
    allRoughDetails.clear();

    for (var memo in allSelectedMemoIssue) {
      List<MemoIssueDetailsModel> roughDetails = defaultController.memoIssueDetailsList
          .where((detail) => detail.memoIssueMstID == memo.memoIssueMstID && detail.rec == 'N')
          .toList();
      allRoughDetails.addAll(roughDetails);
    }
  }

  void _openPendingItemsDialog() {
    if (_selectedTypeParty.value.isEmpty) {
      infoDialog(messageText: 'Please select Party first.');
      _partyFocNode.requestFocus();
      return;
    }

    _fetchPendingMemoIssueItems();

    if (allRoughDetails.isEmpty) {
      infoDialog(messageText: 'No pending memo issue details found for the selected party and broker.');
      return;
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext cnt) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            width: 780,
            height: 480,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.inventory_2_rounded, color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Memo Issue Item to Receive',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                            ),
                            Text(
                              'Use Arrow Up/Down to navigate, Enter or double-click to select',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close_rounded, size: 20),
                      splashRadius: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // DataGrid
                Expanded(
                  child: KeyboardListener(
                    focusNode: _keyBoardFocus,
                    autofocus: true,
                    onKeyEvent: (KeyEvent event) {
                      if (event is KeyDownEvent) {
                        final int currentIndex = _dialogDataGridController.selectedIndex;
                        final int totalRows = allRoughDetails.length;

                        if (event.logicalKey == LogicalKeyboardKey.enter) {
                          final DataGridRow? selectedRow = _dialogDataGridController.selectedRow;
                          if (selectedRow != null) {
                            _selectPendingItemFromRow(selectedRow);
                          }
                        } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                          if (currentIndex < totalRows - 1) {
                            _dialogDataGridController.selectedIndex = currentIndex + 1;
                            _dialogDataGridController.scrollToRow((currentIndex + 1).toDouble());
                          }
                        } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                          if (currentIndex > 0) {
                            _dialogDataGridController.selectedIndex = currentIndex - 1;
                            _dialogDataGridController.scrollToRow((currentIndex - 1).toDouble());
                          }
                        } else if (event.logicalKey == LogicalKeyboardKey.escape) {
                          Get.back();
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Obx(
                        () => AppDataGrid(
                          controller: _dialogDataGridController,
                          source: MemoIssueDetailsDataGridSource(allRoughDetails),
                          selectionMode: SelectionMode.singleDeselect,
                          columnWidthMode: ColumnWidthMode.fill,
                          rowHeight: 32,
                          headerRowHeight: 36,
                          allowSorting: true,
                          allowMultiColumnSorting: true,
                          showSortNumbers: true,
                          allowFiltering: true,
                          allowColumnsResizing: true,
                          onSelectionChanged: (addedRows, removedRows) {
                            if (addedRows.isNotEmpty) {
                              _selectPendingItemFromRow(addedRows.first);
                            }
                          },
                          columns: <GridColumn>[
                            GridColumn(
                              columnName: 'Rough',
                              label: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: const Text('Rough Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Wt',
                              label: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: const Text('Issued Wt (Cts)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Issue ID',
                              label: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: const Text('Memo Issue #', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Detail ID',
                              label: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: const Text('Detail ID', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        'Total Pending Wt: ${MemoIssueDetailsDataGridSource(allRoughDetails).totalWt.toStringAsFixed(3)} Cts',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.primary),
                      ),
                    ),
                    AppButton(
                      text: 'Cancel',
                      shortcutLabel: 'Esc',
                      variant: AppButtonVariant.secondary,
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _selectPendingItemFromRow(DataGridRow selectedRow) {
    final int detailId = int.tryParse(selectedRow.getCells()[3].value.toString()) ?? 0;
    final roughEntryIndex = defaultController.memoIssueDetailsList.indexWhere((entry) => entry.memoIssueDetID == detailId);

    if (roughEntryIndex != -1) {
      final roughEntry = defaultController.memoIssueDetailsList[roughEntryIndex];
      selectedRoughDetails.add(roughEntry);
      selectedMemoIssueDetID.value = detailId.toString();
      _selectedType.value = (roughEntry.roughTypeCode ?? '').toString();
      issWtController.text = (roughEntry.carats ?? 0.0).toString();
      recWtController.text = (roughEntry.carats ?? 0.0).toString();
      lossWtController.text = '0.000';
      rateController.text = (roughEntry.rateRs ?? 0.0).toString();
      descripController.text = roughEntry.description?.toString() ?? '';
      _calculateLossAndAmount();

      allRoughDetails.removeWhere((item) => item.memoIssueDetID == detailId);
      defaultController.memoIssueDetailsList.removeAt(roughEntryIndex);

      Get.back(); // close dialog

      Future.delayed(const Duration(milliseconds: 100), () {
        _recWtFocus.requestFocus();
        recWtController.selection = TextSelection(baseOffset: 0, extentOffset: recWtController.text.length);
      });
    }
  }

  void _addEntry() {
    final double issWt = double.tryParse(issWtController.text) ?? 0.0;
    final double recWt = double.tryParse(recWtController.text) ?? 0.0;
    final double rate = double.tryParse(rateController.text) ?? 0.0;

    if (_selectedType.value.isEmpty) {
      infoDialog(messageText: 'Please select a pending memo issue item first.');
      return;
    }
    if (recWt <= 0) {
      infoDialog(messageText: 'Received weight must be greater than 0.');
      _recWtFocus.requestFocus();
      return;
    }
    if (recWt > issWt) {
      infoDialog(messageText: 'Received weight cannot exceed issued weight.');
      _recWtFocus.requestFocus();
      return;
    }

    final double lossWt = issWt - recWt;
    final double amount = recWt * rate;

    setState(() {
      recEntries.add({
        if (selectedRoughId.value.isNotEmpty) 'id': selectedRoughId.value,
        if (selectedMemoIssueDetID.value.isNotEmpty) 'detId': selectedMemoIssueDetID.value,
        'rough': _selectedType.value,
        'description': descripController.text,
        'wt': issWtController.text,
        'recWt': recWtController.text,
        'lossWt': lossWt.toStringAsFixed(3),
        'rate': rateController.text,
        'amount': amount.toStringAsFixed(2),
      });

      _selectedType.value = '';
      descripController.clear();
      issWtController.clear();
      recWtController.clear();
      lossWtController.text = '0.000';
      rateController.clear();
      amountController.clear();
      selectedRoughId.value = '';
      selectedMemoIssueDetID.value = '';
    });

    if (allRoughDetails.isNotEmpty) {
      _openPendingItemsDialog();
    }
  }

  void _editEntry(int index) {
    final entry = recEntries[index];
    if (_isFromEdit) {
      selectedRoughId.value = entry['id'] ?? '';
    }
    selectedMemoIssueDetID.value = entry['detId'] ?? '';
    _selectedType.value = entry['rough'] ?? '';
    descripController.text = entry['description'] ?? '';
    issWtController.text = entry['wt'] ?? '';
    recWtController.text = entry['recWt'] ?? '';
    lossWtController.text = entry['lossWt'] ?? '';
    rateController.text = entry['rate'] ?? '';
    amountController.text = entry['amount'] ?? '';

    setState(() {
      recEntries.removeAt(index);
    });
    _recWtFocus.requestFocus();
  }

  Future<void> _deleteEntry(int index) async {
    final entry = recEntries[index];
    if (_isFromEdit) {
      if (recEntries.length == 1) {
        infoDialog(messageText: 'Cannot delete the only remaining rough entry.');
        return;
      }
      final detId = int.tryParse(entry['detId'] ?? '') ?? 0;
      final id = int.tryParse(entry['id'] ?? '') ?? 0;
      await defaultController.deleteMemoRecRoughData(detId: detId, id: id);
      setState(() {
        recEntries.removeAt(index);
      });
    } else {
      final detIdStr = entry['detId'];
      if (detIdStr != null) {
        final matchingIndex = selectedRoughDetails.indexWhere((w) => w.memoIssueDetID.toString() == detIdStr);
        if (matchingIndex != -1) {
          defaultController.memoIssueDetailsList.add(selectedRoughDetails[matchingIndex]);
          selectedRoughDetails.removeAt(matchingIndex);
        }
      }
      setState(() {
        recEntries.removeAt(index);
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_isEnabled) return;

    if (_selectedTypeParty.value.isEmpty) {
      infoDialog(messageText: 'Please select a Party.');
      _partyFocNode.requestFocus();
      return;
    }

    if (recEntries.isEmpty) {
      infoDialog(messageText: 'Please add at least one rough entry.');
      return;
    }

    if (_isFromEdit) {
      await defaultController.updateMemoRecData(
        id: selectedMemoRecMstID.value,
        partyCode: _selectedTypeParty.value,
        invoiceDate: selectedDate,
        brokerCode: _selectedTypeBroker.value,
        entries: recEntries,
        totalAmt: totalRecAmount,
        totalWt: totalRecWt,
        totalRate: totalRecRate,
      );
      _handleCancel();
    } else {
      await defaultController.addMemoRecData(
        partyCode: _selectedTypeParty.value,
        invoiceDate: selectedDate,
        brokerCode: _selectedTypeBroker.value,
        dueDate: dueDate,
        entries: recEntries,
        totalAmt: totalRecAmount,
        totalWt: totalWt,
        totalRecWt: totalRecWt,
        totalRecAmount: totalRecAmount,
        totalLossWt: totalLossWt,
        totalRate: totalRecRate,
      );
      _handleCancel();
    }
  }

  Future<void> _handleDelete() async {
    if (!_isEnabled || !_isFromEdit) {
      infoDialog(messageText: 'Please select a memo receive entry to delete.');
      return;
    }

    await defaultController.deleteMemoRecData(
      id: selectedMemoRecMstID.value,
      entries: recEntries,
    );
    _handleCancel();
  }

  void _handleCancel() {
    dateController.clear();
    descripController.clear();
    issWtController.clear();
    recWtController.clear();
    lossWtController.text = '0.000';
    rateController.clear();
    amountController.clear();
    _selectedTypeParty.value = '';
    _selectedType.value = '';
    _selectedTypeBroker.value = '22';
    selectedRoughId.value = '';
    selectedMemoIssueDetID.value = '';
    selectedMemoRecMstID.value = 0;
    allRoughDetails.clear();
    allSelectedMemoIssue.clear();
    selectedRoughDetails.clear();
    recEntries.clear();
    setState(() {
      _isFromEdit = false;
      _isEnabled = false;
    });
  }

  Future<void> _handlePrint() async {
    if (!_isFromEdit || selectedDate == null || _selectedTypeParty.value.isEmpty) return;

    final invoiceGenerator = MemoRecInvoiceGenerator();
    final pdfData = await invoiceGenerator.generateInvoice(
      id: selectedMemoRecMstID.value,
      invoiceDate: selectedDate!,
      partyCode: _selectedTypeParty.value,
      entries: recEntries,
      totalWt: totalWt,
      totalLossWt: totalLossWt,
      totalRecWt: totalRecWt,
      totalAmt: totalAmount,
      totalRecAmt: totalRecAmount,
      totalRate: totalRate,
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfData,
    );

    if (!kDebugMode) {
      await Printing.sharePdf(
        bytes: pdfData,
        filename: 'Memo-Receive/${getPartyName(int.tryParse(_selectedTypeParty.value) ?? 0)}/${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    }
  }

  void _selectMemoById(int id) {
    selectedMemoRecMstID.value = id;

    final MemoRecModel partyEntry = defaultController.memoRecList.firstWhere(
      (entry) => entry.memoRecMstID == id,
    );

    final List<MemoRecDetailsModel> roughEntries = defaultController.memoRecDetailsList
        .where((entry) => entry.memoRecMstID == id)
        .toList();

    selectedDate = dateFormat(partyEntry.invoiceDate!);
    dateController.text = formatDate(partyEntry.invoiceDate!);
    _selectedTypeParty.value = partyEntry.partyCode.toString();
    _selectedTypeBroker.value = (partyEntry.brokerCode ?? 22).toString();

    recEntries.clear();
    for (var roughEntry in roughEntries) {
      recEntries.add({
        'id': roughEntry.memoRecDetID.toString(),
        'detId': roughEntry.memoIssueDetID.toString(),
        'rough': roughEntry.roughTypeCode.toString(),
        'description': roughEntry.description?.toString() ?? '',
        'wt': (roughEntry.carats ?? 0.0).toString(),
        'recWt': (roughEntry.recCarats ?? 0.0).toString(),
        'lossWt': (roughEntry.lossCarats ?? 0.0).toString(),
        'rate': (roughEntry.rateRs ?? 0.0).toString(),
        'amount': ((roughEntry.recCarats ?? 0.0) * (roughEntry.rateRs ?? 0.0)).toStringAsFixed(2),
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
      filteredDataGridSource.value = defaultController.memoRecList.where((memo) {
        if (memo.invoiceDate == null) return false;
        final invoiceDate = DateTime.parse(memo.invoiceDate!);
        return invoiceDate.isAfter(fromDate!) &&
            invoiceDate.isBefore(toDate!.add(const Duration(days: 1)));
      }).toList();
      memoRecDataGridSource.value = filteredDataGridSource;
      _searchKeyBoardFocus.requestFocus();
    } else {
      infoDialog(messageText: 'Please select both From Date and To Date');
    }
  }

  void _removeDateFilter() {
    memoRecDataGridSource.value = defaultController.memoRecList;
    toDateController.clear();
    fromDateController.clear();
    fromDate = null;
    toDate = null;
    _isFiltered.value = false;
  }

  // ==================== DROPDOWNS ====================

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
    if (_isSearch) {
      return _buildSearchView();
    }

    return AppKeyboardShortcutHandler(
      onAdd: !_isEnabled ? _enableFields : null,
      onSave: _isEnabled ? _handleSave : null,
      onDelete: (_isEnabled && _isFromEdit) ? _handleDelete : null,
      onCancel: _isEnabled ? _handleCancel : null,
      onSearch: () => setState(() => _isSearch = true),
      onPrint: _isFromEdit ? _handlePrint : null,
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
                const Header(title: 'Memo Receive'),
                const SizedBox(height: 16),
              ],

              // Card 1: Memo Receive Header
              _buildHeaderCard(),
              const SizedBox(height: 16),

              // Card 2: Received Items Input Bar
              _buildRoughInputCard(),
              const SizedBox(height: 16),

              // Card 3: Received Items Table & Summary Bar
              _buildItemsTableCard(),
              const SizedBox(height: 20),

              // Card 4: Action Buttons Bar
              _buildActionBar(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== CARD 1: HEADER ====================

  Widget _buildHeaderCard() {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.receipt_long_rounded, color: AppColors.primary, size: 18),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Memo Receive Header',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                ],
              ),
              if (_isFromEdit)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    'Editing Voucher #${selectedMemoRecMstID.value}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.warning),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final partyField = Obx(
                () => AppDropdown<String>(
                  label: 'Memo Party *',
                  value: _selectedTypeParty.value.isEmpty ? null : _selectedTypeParty.value,
                  items: dropdownItemsParty,
                  focusNode: _partyFocNode,
                  nextFocusNode: _dateFocus,
                  hintText: 'Select Party',
                  isEnabled: _isEnabled && !_isFromEdit,
                  onChanged: (value) {
                    if (value != null) {
                      _selectedTypeParty.value = value;
                      allSelectedMemoIssue.clear();
                      allRoughDetails.clear();
                      selectedRoughDetails.clear();
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
                  label: 'Receive Date *',
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
                  hintText: 'Select Broker',
                  isEnabled: _isEnabled && !_isFromEdit,
                  onChanged: (value) {
                    if (value != null) {
                      _selectedTypeBroker.value = value;
                      _fetchPendingMemoIssueItems();
                      if (allRoughDetails.isNotEmpty) {
                        _openPendingItemsDialog();
                      } else {
                        infoDialog(messageText: 'No pending memo issue details found for this party and broker.');
                      }
                    }
                  },
                ),
              );

              final pendingBtn = (_isEnabled && !_isFromEdit)
                  ? Obx(
                      () => OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          backgroundColor: AppColors.primary.withValues(alpha: 0.05),
                        ),
                        icon: const Icon(Icons.inventory_2_outlined, size: 16, color: AppColors.primary),
                        label: Text(
                          allRoughDetails.isEmpty ? 'Select Pending Items' : 'Pending Items (${allRoughDetails.length})',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                        ),
                        onPressed: _openPendingItemsDialog,
                      ),
                    )
                  : null;

              if (constraints.maxWidth >= 950) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: partyField),
                    const SizedBox(width: 12),
                    Expanded(flex: 3, child: dateField),
                    const SizedBox(width: 12),
                    Expanded(flex: 4, child: brokerField),
                    if (pendingBtn != null) ...[
                      const SizedBox(width: 12),
                      Padding(
                        padding: const EdgeInsets.only(top: 21),
                        child: pendingBtn,
                      ),
                    ],
                  ],
                );
              } else if (constraints.maxWidth >= 600) {
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 1, child: partyField),
                        const SizedBox(width: 12),
                        Expanded(flex: 1, child: dateField),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: brokerField),
                        if (pendingBtn != null) ...[
                          const SizedBox(width: 12),
                          Padding(
                            padding: const EdgeInsets.only(top: 21),
                            child: pendingBtn,
                          ),
                        ],
                      ],
                    ),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    partyField,
                    const SizedBox(height: 10),
                    dateField,
                    const SizedBox(height: 10),
                    brokerField,
                    if (pendingBtn != null) ...[
                      const SizedBox(height: 12),
                      pendingBtn,
                    ],
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // ==================== CARD 2: ROUGH INPUT BAR ====================

  Widget _buildRoughInputCard() {
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.brandRed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.diamond_rounded, color: AppColors.brandRed, size: 18),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Item Details & Auto-Loss Calc',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                const Text(
                  'Loss Wt = Iss Wt - Rec Wt | Amount = Rec Wt × Rate',
                  style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final roughField = Obx(
                  () => AppTextField(
                    label: 'Rough Type',
                    controller: TextEditingController(
                      text: _selectedType.value.isEmpty ? '' : getRoughName(_selectedType.value),
                    ),
                    enabled: false,
                  ),
                );

                final descField = AppTextField(
                  label: 'Description',
                  controller: descripController,
                  enabled: false,
                );

                final issWtField = AppTextField(
                  label: 'Issued Wt',
                  controller: issWtController,
                  enabled: false,
                );

                final recWtField = AppTextField(
                  label: 'Received Wt *',
                  controller: recWtController,
                  focusNode: _recWtFocus,
                  enabled: _isEnabled && _selectedType.value.isNotEmpty,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),
                  ],
                  onFieldSubmitted: (_) => _addEntry(),
                );

                final lossWtField = AppTextField(
                  label: 'Loss Wt',
                  controller: lossWtController,
                  enabled: false,
                );

                final rateField = AppTextField(
                  label: 'Rate (₹)',
                  controller: rateController,
                  enabled: false,
                );

                final amountField = AppTextField(
                  label: 'Amount (₹)',
                  controller: amountController,
                  enabled: false,
                );

                final addButton = Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: AppButton(
                    text: 'Add',
                    icon: Icons.add_rounded,
                    variant: AppButtonVariant.primary,
                    onPressed: (_isEnabled && _selectedType.value.isNotEmpty) ? _addEntry : null,
                  ),
                );

                if (constraints.maxWidth >= 1150) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(flex: 3, child: roughField),
                      const SizedBox(width: 10),
                      Expanded(flex: 4, child: descField),
                      const SizedBox(width: 10),
                      Expanded(flex: 2, child: issWtField),
                      const SizedBox(width: 10),
                      Expanded(flex: 3, child: recWtField),
                      const SizedBox(width: 10),
                      Expanded(flex: 2, child: lossWtField),
                      const SizedBox(width: 10),
                      Expanded(flex: 2, child: rateField),
                      const SizedBox(width: 10),
                      Expanded(flex: 3, child: amountField),
                      const SizedBox(width: 10),
                      addButton,
                    ],
                  );
                } else if (constraints.maxWidth >= 700) {
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: roughField),
                          const SizedBox(width: 10),
                          Expanded(flex: 4, child: descField),
                          const SizedBox(width: 10),
                          Expanded(flex: 2, child: issWtField),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(flex: 3, child: recWtField),
                          const SizedBox(width: 10),
                          Expanded(flex: 2, child: lossWtField),
                          const SizedBox(width: 10),
                          Expanded(flex: 2, child: rateField),
                          const SizedBox(width: 10),
                          Expanded(flex: 3, child: amountField),
                          const SizedBox(width: 10),
                          addButton,
                        ],
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      roughField,
                      const SizedBox(height: 10),
                      descField,
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: issWtField),
                          const SizedBox(width: 10),
                          Expanded(child: recWtField),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: lossWtField),
                          const SizedBox(width: 10),
                          Expanded(child: rateField),
                          const SizedBox(width: 10),
                          Expanded(child: amountField),
                        ],
                      ),
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

  // ==================== CARD 3: ITEMS TABLE & SUMMARY ====================

  Widget _buildItemsTableCard() {
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
              final titleWidget = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.table_chart_rounded, color: AppColors.success, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Received Items List (${recEntries.length})',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                ],
              );

              final summaryBadges = Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _buildSummaryBadge('Iss Wt', '${totalWt.toStringAsFixed(3)} Cts', AppColors.primary),
                  _buildSummaryBadge('Rec Wt', '${totalRecWt.toStringAsFixed(3)} Cts', AppColors.success),
                  _buildSummaryBadge('Loss Wt', '${totalLossWt.toStringAsFixed(3)} Cts', totalLossWt > 0 ? AppColors.warning : AppColors.textMuted),
                  _buildSummaryBadge('Rec Amt', '₹${totalRecAmount.toStringAsFixed(2)}', AppColors.brandRed),
                ],
              );

              if (constraints.maxWidth < 650) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleWidget,
                    const SizedBox(height: 10),
                    summaryBadges,
                  ],
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  titleWidget,
                  summaryBadges,
                ],
              );
            },
          ),
          const SizedBox(height: 14),

          // Items Table
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias,
            child: recEntries.isEmpty
                ? Container(
                    height: 120,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 36, color: AppColors.textMuted.withValues(alpha: 0.6)),
                        const SizedBox(height: 6),
                        const Text(
                          'No received items added yet.',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Select Party and Broker above to pick pending items from the memo issue register.',
                          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth < 800 ? 800 : constraints.maxWidth,
                          ),
                          child: Table(
                            columnWidths: const {
                              0: FixedColumnWidth(48), // SR NO
                              1: FlexColumnWidth(2), // ROUGH
                              2: FlexColumnWidth(3), // DESCRIPTION
                              3: FlexColumnWidth(1.5), // ISS WT
                              4: FlexColumnWidth(1.5), // REC WT
                              5: FlexColumnWidth(1.5), // LOSS WT
                              6: FlexColumnWidth(1.5), // RATE
                              7: FlexColumnWidth(2), // AMOUNT
                              8: FixedColumnWidth(70), // ACTIONS
                            },
                            children: [
                              // Table Header
                              TableRow(
                                decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
                                children: [
                                  _buildTableHeaderCell('SR'),
                                  _buildTableHeaderCell('ROUGH'),
                                  _buildTableHeaderCell('DESCRIPTION'),
                                  _buildTableHeaderCell('ISS WT', align: TextAlign.right),
                                  _buildTableHeaderCell('REC WT', align: TextAlign.right),
                                  _buildTableHeaderCell('LOSS WT', align: TextAlign.right),
                                  _buildTableHeaderCell('RATE', align: TextAlign.right),
                                  _buildTableHeaderCell('AMOUNT', align: TextAlign.right),
                                  _buildTableHeaderCell('ACTIONS', align: TextAlign.center),
                                ],
                              ),
                              // Data Rows
                              for (int i = 0; i < recEntries.length; i++)
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: i.isEven ? Colors.white : const Color(0xFFFAFAFA),
                                  ),
                                  children: [
                                    _buildTableCell('${i + 1}', align: TextAlign.center),
                                    _buildTableCell(getRoughName(recEntries[i]['rough'] ?? '')),
                                    _buildTableCell(recEntries[i]['description'] ?? '-'),
                                    _buildTableCell(recEntries[i]['wt'] ?? '0.000', align: TextAlign.right),
                                    _buildTableCell(recEntries[i]['recWt'] ?? '0.000', align: TextAlign.right, isBold: true),
                                    _buildTableCell(
                                      recEntries[i]['lossWt'] ?? '0.000',
                                      align: TextAlign.right,
                                      color: (double.tryParse(recEntries[i]['lossWt'] ?? '0') ?? 0) > 0 ? AppColors.warning : null,
                                    ),
                                    _buildTableCell(recEntries[i]['rate'] ?? '0.00', align: TextAlign.right),
                                    _buildTableCell('₹${recEntries[i]['amount'] ?? '0.00'}', align: TextAlign.right, isBold: true),
                                    TableCell(
                                      verticalAlignment: TableCellVerticalAlignment.middle,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.primary),
                                            splashRadius: 16,
                                            tooltip: 'Edit Item',
                                            onPressed: _isEnabled ? () => _editEntry(i) : null,
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.danger),
                                            splashRadius: 16,
                                            tooltip: 'Delete Item',
                                            onPressed: _isEnabled ? () => _deleteEntry(i) : null,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              // Summary Row
                              TableRow(
                                decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
                                children: [
                                  _buildTableCell(''),
                                  _buildTableCell('TOTAL', isBold: true),
                                  _buildTableCell(''),
                                  _buildTableCell(totalWt.toStringAsFixed(3), align: TextAlign.right, isBold: true),
                                  _buildTableCell(totalRecWt.toStringAsFixed(3), align: TextAlign.right, isBold: true),
                                  _buildTableCell(
                                    totalLossWt.toStringAsFixed(3),
                                    align: TextAlign.right,
                                    isBold: true,
                                    color: totalLossWt > 0 ? AppColors.warning : null,
                                  ),
                                  _buildTableCell(totalRecRate.toStringAsFixed(2), align: TextAlign.right, isBold: true),
                                  _buildTableCell('₹${totalRecAmount.toStringAsFixed(2)}', align: TextAlign.right, isBold: true),
                                  _buildTableCell(''),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBadge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }

  Widget _buildTableHeaderCell(String text, {TextAlign align = TextAlign.left}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Text(
          text,
          textAlign: align,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {TextAlign align = TextAlign.left, bool isBold = false, Color? color}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Text(
          text,
          textAlign: align,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  // ==================== CARD 4: ACTION BAR ====================

  Widget _buildActionBar() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 8,
          children: [
            AppButton(
              text: 'Add',
              icon: Icons.add_rounded,
              variant: AppButtonVariant.primary,
              onPressed: !_isEnabled ? _enableFields : null,
            ),
            AppButton(
              text: 'Save',
              icon: Icons.save_rounded,
              variant: AppButtonVariant.success,
              isLoading: defaultController.isLoading.value,
              onPressed: _isEnabled ? _handleSave : null,
            ),
            AppButton(
              text: 'Delete',
              icon: Icons.delete_outline_rounded,
              variant: AppButtonVariant.danger,
              isLoading: defaultController.isDeleteLoading.value,
              onPressed: (_isEnabled && _isFromEdit) ? _handleDelete : null,
            ),
            AppButton(
              text: 'Cancel',
              icon: Icons.cancel_outlined,
              variant: AppButtonVariant.secondary,
              onPressed: _isEnabled ? _handleCancel : null,
            ),
            AppButton(
              text: 'Exit',
              icon: Icons.exit_to_app_rounded,
              variant: AppButtonVariant.outline,
              onPressed: () => tabController.removeTab(tabController.currentIndex.value),
            ),
            AppButton(
              text: 'Search',
              icon: Icons.search_rounded,
              variant: AppButtonVariant.outline,
              onPressed: () => setState(() => _isSearch = true),
            ),
            AppButton(
              text: 'Print',
              icon: Icons.print_outlined,
              variant: AppButtonVariant.outline,
              onPressed: _isFromEdit ? _handlePrint : null,
            ),
          ],
        ),
      ),
    );
  }

  // ==================== SEARCH VIEW ====================

  Widget _buildSearchView() {
    return KeyboardListener(
      focusNode: _searchKeyBoardFocus,
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          final int currentIndex = _dataGridController.selectedIndex;
          final int totalRows = memoRecDataGridSource.length;

          if (event.logicalKey == LogicalKeyboardKey.enter) {
            final DataGridRow? selectedRow = _dataGridController.selectedRow;
            if (selectedRow != null) {
              final id = selectedRow.getCells()[0].value;
              _selectMemoById(id);
            }
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            if (currentIndex < totalRows - 1) {
              _dataGridController.selectedIndex = currentIndex + 1;
              _dataGridController.scrollToRow((currentIndex + 1).toDouble());
            }
          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            if (currentIndex > 0) {
              _dataGridController.selectedIndex = currentIndex - 1;
              _dataGridController.scrollToRow((currentIndex - 1).toDouble());
            }
          } else if (event.logicalKey == LogicalKeyboardKey.keyE || event.logicalKey == LogicalKeyboardKey.escape) {
            setState(() => _isSearch = false);
          } else if (event.logicalKey == LogicalKeyboardKey.keyR && _isFiltered.value) {
            _removeDateFilter();
          } else if (event.logicalKey == LogicalKeyboardKey.keyF) {
            _applyDateFilter();
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showHeader) ...[
                const Header(title: 'Memo Receive Search'),
                const SizedBox(height: 12),
              ],

              // Filter Controls Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isCompact = constraints.maxWidth < 700;
                    final fromDateField = AppTextField(
                      label: 'From Date',
                      controller: fromDateController,
                      readOnly: true,
                      prefixIcon: const Icon(Icons.date_range_rounded, size: 16, color: AppColors.primary),
                      onTap: () async {
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
                            if (toDate != null) _applyDateFilter();
                          });
                        }
                      },
                    );

                    final toDateField = AppTextField(
                      label: 'To Date',
                      controller: toDateController,
                      readOnly: true,
                      prefixIcon: const Icon(Icons.date_range_rounded, size: 16, color: AppColors.primary),
                      onTap: () async {
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
                            if (fromDate != null) _applyDateFilter();
                          });
                        }
                      },
                    );

                    final actionButtons = Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        AppButton(
                          text: 'Filter',
                          shortcutLabel: 'F',
                          variant: AppButtonVariant.primary,
                          onPressed: _applyDateFilter,
                        ),
                        AppButton(
                          text: 'Reset',
                          shortcutLabel: 'R',
                          variant: AppButtonVariant.secondary,
                          onPressed: _removeDateFilter,
                        ),
                        AppButton(
                          text: 'Exit Search',
                          shortcutLabel: 'Esc / E',
                          variant: AppButtonVariant.outline,
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
                              Expanded(child: fromDateField),
                              const SizedBox(width: 10),
                              Expanded(child: toDateField),
                            ],
                          ),
                          const SizedBox(height: 10),
                          actionButtons,
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(child: fromDateField),
                        const SizedBox(width: 12),
                        Expanded(child: toDateField),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: actionButtons,
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // DataGrid
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Obx(
                    () => AppDataGrid(
                      controller: _dataGridController,
                      source: MemoReceiveDataGridSource(memoRecDataGridSource),
                      rowHeight: 32,
                      headerRowHeight: 36,
                      allowSorting: true,
                      allowMultiColumnSorting: true,
                      showSortNumbers: true,
                      allowFiltering: true,
                      allowColumnsResizing: true,
                      selectionMode: SelectionMode.singleDeselect,
                      columnWidthMode: ColumnWidthMode.auto,
                      frozenColumnsCount: 1,
                      onSelectionChanged: (addedRows, removedRows) {
                        if (addedRows.isNotEmpty) {
                          final id = addedRows.first.getCells()[0].value;
                          _selectMemoById(id);
                        }
                      },
                      columns: <GridColumn>[
                        GridColumn(
                          columnName: 'ID',
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.center,
                            child: const Text('ID', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Date',
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.center,
                            child: const Text('Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Party',
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.centerLeft,
                            child: const Text('Party', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Broker',
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.centerLeft,
                            child: const Text('Broker', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Tot Wt',
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.centerRight,
                            child: const Text('Tot Wt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Tot Amt Rs',
                          label: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.centerRight,
                            child: const Text('Tot Amt (₹)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                      ],
                      tableSummaryRows: [
                        GridTableSummaryRow(
                          title: 'Total ${memoRecDataGridSource.length}',
                          showSummaryInRow: false,
                          titleColumnSpan: 1,
                          columns: <GridSummaryColumn>[
                            const GridSummaryColumn(name: 'Tot Wt', columnName: 'Tot Wt', summaryType: GridSummaryType.sum),
                            const GridSummaryColumn(name: 'Tot Amt Rs', columnName: 'Tot Amt Rs', summaryType: GridSummaryType.sum),
                          ],
                          position: GridTableSummaryRowPosition.bottom,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
