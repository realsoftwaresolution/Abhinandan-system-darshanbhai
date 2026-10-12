import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/common/components/app_button.dart';
import 'package:real_web_rough_entry_system/common/components/app_data_grid.dart';
import 'package:real_web_rough_entry_system/common/components/app_dropdown.dart';
import 'package:real_web_rough_entry_system/common/components/app_shortcuts.dart';
import 'package:real_web_rough_entry_system/common/components/app_text_field.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/header.dart';
import 'package:real_web_rough_entry_system/purchase/invoice_generator.dart';
import 'package:real_web_rough_entry_system/purchase/purchase_datagrid.dart';
import 'package:real_web_rough_entry_system/purchase/purchase_details_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PurchaseFormScreen extends StatefulWidget {
  final bool showHeader;

  const PurchaseFormScreen({super.key, required this.showHeader});

  @override
  PurchaseFormScreenState createState() => PurchaseFormScreenState();
}

class PurchaseFormScreenState extends State<PurchaseFormScreen> {
  final TextEditingController invNoController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController dueDaysController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();

  final TextEditingController descripController = TextEditingController();
  final TextEditingController wtController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  final FocusNode _partyFocus = FocusNode();
  final FocusNode _roughFocus = FocusNode();
  final FocusNode _invoiceFocus = FocusNode();
  final FocusNode _dateFocus = FocusNode();
  final FocusNode _brokerFocus = FocusNode();
  final FocusNode _dueDaysFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();
  final FocusNode _wtFocus = FocusNode();
  final FocusNode _rateFocus = FocusNode();

  final DataGridController _dataGridController = DataGridController();
  final DefaultController defaultController = Get.find<DefaultController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Map<String, String>> entries = [];
  final RxString _selectedType = ''.obs;
  final RxString _selectedTypeBroker = '22'.obs;
  final RxString _selectedTypeParty = ''.obs;
  final RxInt selectedRoughPurMstID = 0.obs;
  final RxString selectedRoughId = ''.obs;

  DateTime? selectedDate;
  String? dueDate;

  bool _isEnabled = false;
  bool _isSearch = false;
  bool _isFromEdit = false;
  final RxBool _isFiltered = false.obs;

  DateTime? fromDate;
  DateTime? toDate;
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  RxList<PurchaseDetailsModel> purchaseDataGridSource = <PurchaseDetailsModel>[].obs;
  RxList<PurchaseDetailsModel> filteredDataGridSource = <PurchaseDetailsModel>[].obs;
  Worker? _listWorker;

  double get totalWt => entries.fold(0.0, (prev, e) => prev + (double.tryParse(e['wt'] ?? '0') ?? 0.0));
  double get totalRate => totalWt == 0 ? 0 : totalAmount / totalWt;
  double get totalAmount => entries.fold(0.0, (prev, e) => prev + (double.tryParse(e['amount'] ?? '0') ?? 0.0));

  @override
  void initState() {
    super.initState();
    wtController.addListener(_updateAmount);
    rateController.addListener(_updateAmount);
    purchaseDataGridSource.value = defaultController.purchaseDataList;

    _listWorker = ever(defaultController.purchaseDataList, (list) {
      if (mounted) {
        purchaseDataGridSource.value = list;
        setState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (defaultController.purchaseDataList.isEmpty) {
        defaultController.getPurchaseData();
      }
      if (defaultController.roughDetailsModel.isEmpty) {
        defaultController.getPurchaseDetailsData();
      }
      if (defaultController.partyMstList.isEmpty) {
        defaultController.getPartyData();
      }
      if (defaultController.roughModel.isEmpty) {
        defaultController.getRoughData();
      }
    });
  }

  @override
  void dispose() {
    _listWorker?.dispose();
    invNoController.dispose();
    dateController.dispose();
    dueDaysController.dispose();
    dueDateController.dispose();
    descripController.dispose();
    wtController.dispose();
    rateController.dispose();
    amountController.dispose();
    fromDateController.dispose();
    toDateController.dispose();

    _partyFocus.dispose();
    _roughFocus.dispose();
    _invoiceFocus.dispose();
    _dateFocus.dispose();
    _brokerFocus.dispose();
    _dueDaysFocus.dispose();
    _descFocus.dispose();
    _wtFocus.dispose();
    _rateFocus.dispose();
    super.dispose();
  }

  void _updateAmount() {
    final double wt = double.tryParse(wtController.text) ?? 0;
    final double rate = double.tryParse(rateController.text) ?? 0;
    amountController.text = (wt * rate).toStringAsFixed(2);
  }

  void _enableFields({bool needFocus = true}) {
    setState(() {
      _isEnabled = true;
      if (needFocus) {
        Future.delayed(const Duration(milliseconds: 60), () {
          _partyFocus.requestFocus();
        });
      }
    });
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
      _dueDaysFocus.requestFocus();
    }
  }

  void _addEntry() {
    final double wt = double.tryParse(wtController.text) ?? 0;
    final double rate = double.tryParse(rateController.text) ?? 0;

    if (_selectedType.value.isEmpty) {
      infoDialog(messageText: 'Please select a Rough Type');
      _roughFocus.requestFocus();
      return;
    }
    if (wt <= 0) {
      infoDialog(messageText: 'Please enter a valid weight');
      _wtFocus.requestFocus();
      return;
    }
    if (rate <= 0) {
      infoDialog(messageText: 'Please enter a valid rate');
      _rateFocus.requestFocus();
      return;
    }

    setState(() {
      entries.add({
        if (selectedRoughId.value.isNotEmpty) 'id': selectedRoughId.value,
        'rough': _selectedType.value,
        'description': descripController.text.trim(),
        'wt': wt.toStringAsFixed(2),
        'rate': rate.toStringAsFixed(2),
        'amount': (wt * rate).toStringAsFixed(2),
      });

      _selectedType.value = '';
      descripController.clear();
      wtController.clear();
      rateController.clear();
      amountController.clear();
      selectedRoughId.value = '';
    });

    _roughFocus.requestFocus();
  }

  Future<void> _handleSave() async {
    if (!_isEnabled) return;
    if (_selectedTypeParty.value.isEmpty) {
      infoDialog(messageText: 'Please Select Party');
      _partyFocus.requestFocus();
      return;
    }
    if (entries.isEmpty) {
      infoDialog(messageText: 'Please Add Rough Data');
      _roughFocus.requestFocus();
      return;
    }

    if (_isFromEdit) {
      await defaultController.updatePurchaseData(
        id: selectedRoughPurMstID.value,
        partyCode: _selectedTypeParty.value,
        invoiceNo: invNoController.text,
        invoiceDate: selectedDate,
        brokerCode: _selectedTypeBroker.value,
        dueDays: dueDaysController.text,
        dueDate: dueDate,
        onlyDueDate: dueDateController.text,
        entries: entries,
        totalAmt: totalAmount,
        totalWt: totalWt,
        totalRate: totalRate,
      );
    } else {
      await defaultController.addPurchaseData(
        partyCode: _selectedTypeParty.value,
        invoiceNo: invNoController.text,
        invoiceDate: selectedDate,
        brokerCode: _selectedTypeBroker.value,
        dueDays: dueDaysController.text,
        dueDate: dueDate,
        onlyDueDate: dueDateController.text,
        entries: entries,
        totalRate: totalRate,
        totalAmt: totalAmount,
        totalWt: totalWt,
      );
    }

    _handleCancel();
  }

  void _handleCancel() {
    setState(() {
      entries.clear();
      _isEnabled = false;
      _isFromEdit = false;
      _selectedTypeParty.value = '';
      _selectedType.value = '';
      _selectedTypeBroker.value = '22';
      selectedRoughPurMstID.value = 0;
      selectedRoughId.value = '';
      selectedDate = null;
      dueDate = null;
    });
    dateController.clear();
    dueDateController.clear();
    dueDaysController.clear();
    invNoController.clear();
    descripController.clear();
    wtController.clear();
    rateController.clear();
    amountController.clear();
  }

  Future<void> _handleDelete() async {
    if (!_isFromEdit) return;
    await defaultController.deletePurchaseData(
      id: selectedRoughPurMstID.value,
      entries: entries,
    );
    _handleCancel();
  }

  Future<void> _handlePrint() async {
    if (!_isFromEdit || selectedDate == null) return;
    final invoiceGenerator = PurchaseInvoiceGenerator();
    final pdfData = await invoiceGenerator.generateInvoice(
      id: defaultController.purchaseDataList.length + 1,
      invoiceDate: selectedDate!,
      invoiceNo: invNoController.text,
      partyCode: _selectedTypeParty.value,
      brokerCode: _selectedTypeBroker.value,
      dueDate: dueDateController.text,
      dueDays: dueDaysController.text,
      entries: entries,
      totalWt: totalWt,
      totalAmt: totalAmount,
      totalRate: totalRate,
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfData,
    );
  }

  void _applyDateFilter() {
    if (fromDate != null && toDate != null) {
      _isFiltered.value = true;
      filteredDataGridSource.value = defaultController.purchaseDataList.where((purchase) {
        final invoiceDate = DateTime.parse(purchase.invoiceDate!);
        return invoiceDate.isAfter(fromDate!) && invoiceDate.isBefore(toDate!.add(const Duration(days: 1)));
      }).toList();
      purchaseDataGridSource.value = filteredDataGridSource;
    } else {
      infoDialog(messageText: 'Please select both From Date and To Date');
    }
  }

  void _removeDateFilter() {
    purchaseDataGridSource.value = defaultController.purchaseDataList;
    toDateController.clear();
    fromDateController.clear();
    fromDate = null;
    toDate = null;
    _isFiltered.value = false;
  }

  List<DropdownMenuItem<String>> get dropdownItemsRough {
    return defaultController.roughModel.map((item) {
      return DropdownMenuItem<String>(
        value: item.roughTypeCode.toString(),
        child: Text(item.roughTypeName ?? '', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> get dropdownItemsParty {
    return defaultController.partyMstList
        .where((p) => p.typeCode == 1 && p.companyCode == defaultController.companyCode.value)
        .map((p) {
          return DropdownMenuItem<String>(
            value: p.partyCode.toString(),
            child: Text(p.partyName ?? '', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
          );
        })
        .toSet()
        .toList();
  }

  List<DropdownMenuItem<String>> get dropdownItemsBroker {
    return defaultController.partyMstList
        .where((p) => p.typeCode == 5 && p.companyCode == defaultController.companyCode.value)
        .map((p) {
          return DropdownMenuItem<String>(
            value: p.partyCode.toString(),
            child: Text(p.partyName ?? '', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
          );
        })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = AppColors.isDark;
      return AppKeyboardShortcutHandler(
        onAdd: !_isEnabled ? () => _enableFields() : null,
        onSave: _isEnabled ? _handleSave : null,
        onDelete: (_isEnabled && _isFromEdit) ? _handleDelete : null,
        onCancel: _isEnabled ? _handleCancel : null,
        onExit: () => tabController.closeCurrentTab(),
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
              if (widget.showHeader) Header(title: _isSearch ? 'Purchase Search' : 'Purchase Entry'),
              Expanded(
                child: _isSearch ? _buildSearchView() : _buildFormView(),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ==================== SEARCH / DATAGRID VIEW ====================
  Widget _buildSearchView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.borderLight)),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 700;
              final dateFields = [
                AppTextField(
                  label: 'From Date',
                  controller: fromDateController,
                  readOnly: true,
                  prefixIcon: const Icon(Icons.calendar_today_rounded, size: 16),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
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
                  prefixIcon: const Icon(Icons.calendar_today_rounded, size: 16),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
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
                    icon: Icons.filter_alt_rounded,
                    onPressed: _applyDateFilter,
                  ),
                  Obx(() => _isFiltered.value
                      ? AppButton(
                          text: 'Reset',
                          variant: AppButtonVariant.outline,
                          onPressed: _removeDateFilter,
                        )
                      : const SizedBox.shrink()),
                  AppButton(
                    text: 'Close Search',
                    variant: AppButtonVariant.secondary,
                    icon: Icons.close_rounded,
                    onPressed: () {
                      setState(() {
                        _isSearch = false;
                      });
                    },
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: dateFields[0]),
                  const SizedBox(width: 12),
                  Expanded(child: dateFields[1]),
                  const SizedBox(width: 16),
                  actionButtons,
                ],
              );
            },
          ),
        ),
        Expanded(
          child: Obx(
            () => AppDataGrid(
              controller: _dataGridController,
              source: PurchaseDataGridSource(purchaseDataGridSource),
              allowSorting: true,
              allowMultiColumnSorting: true,
              showSortNumbers: true,
              allowFiltering: true,
              allowColumnsResizing: true,
              rowHeight: 30,
              headerRowHeight: 36,
              columnWidthMode: ColumnWidthMode.auto,
              selectionMode: SelectionMode.single,
              columns: <GridColumn>[
                GridColumn(
                  columnName: 'ID',
                  visible: false,
                  label: Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: const Text('ID', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
                GridColumn(
                  columnName: 'Invoice No',
                  label: Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: const Text('Invoice No', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
                GridColumn(
                  columnName: 'Invoice Date',
                  label: Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: const Text('Invoice Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
                GridColumn(
                  columnName: 'Party',
                  label: Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: const Text('Party', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
                GridColumn(
                  columnName: 'Broker',
                  label: Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: const Text('Broker', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
                GridColumn(
                  columnName: 'Tot Wt',
                  label: Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: const Text('Tot Wt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
                GridColumn(
                  columnName: 'Tot Amt Rs',
                  label: Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: const Text('Tot Amt Rs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
              ],
              tableSummaryRows: [
                GridTableSummaryRow(
                  title: 'Total ${purchaseDataGridSource.length} entries',
                  showSummaryInRow: false,
                  titleColumnSpan: 2,
                  columns: const <GridSummaryColumn>[
                    GridSummaryColumn(name: 'Tot Wt', columnName: 'Tot Wt', summaryType: GridSummaryType.sum),
                    GridSummaryColumn(name: 'Tot Amt Rs', columnName: 'Tot Amt Rs', summaryType: GridSummaryType.sum),
                  ],
                  position: GridTableSummaryRowPosition.bottom,
                ),
              ],
              onSelectionChanged: (addedRows, _) {
                if (addedRows.isNotEmpty) {
                  _loadSelectedRowForEdit(addedRows.first);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  void _loadSelectedRowForEdit(DataGridRow row) {
    setState(() {
      entries.clear();
      _isFromEdit = true;
    });

    final id = row.getCells()[0].value;
    selectedRoughPurMstID.value = id;

    final partyEntry = defaultController.purchaseDataList.firstWhere(
      (entry) => entry.roughPurMstID == id,
    );
    final roughEntries = defaultController.roughDetailsModel.where(
      (entry) => entry.roughPurMstID == id,
    ).toList();

    invNoController.text = partyEntry.invoiceNo ?? '';
    selectedDate = dateFormat(partyEntry.invoiceDate!);
    dueDate = formatDateWithTime(partyEntry.dueDate!);
    dateController.text = formatDate(partyEntry.invoiceDate!);
    dueDateController.text = formatDate(partyEntry.dueDate!);
    dueDaysController.text = partyEntry.dueDay?.toString() ?? '';
    _selectedTypeParty.value = partyEntry.partyCode?.toString() ?? '';
    _selectedTypeBroker.value = partyEntry.brokerCode?.toString() ?? '22';

    setState(() {
      for (var r in roughEntries) {
        entries.add({
          'id': r.roughPurDetID.toString(),
          'rough': r.roughTypeCode.toString(),
          'description': r.description ?? '',
          'wt': r.wt?.toStringAsFixed(2) ?? '0.00',
          'rate': r.rateRs?.toStringAsFixed(2) ?? '0.00',
          'amount': ((r.wt ?? 0) * (r.rateRs ?? 0)).toStringAsFixed(2),
        });
      }
    });

    _enableFields(needFocus: false);
    setState(() {
      _isSearch = false;
    });
  }

  // ==================== MAIN DATA ENTRY FORM ====================
  Widget _buildFormView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Master Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.receipt_rounded, size: 18, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Purchase Invoice Header',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final partyField = Obx(
                          () => AppDropdown<String>(
                            label: 'Party *',
                            focusNode: _partyFocus,
                            nextFocusNode: _dateFocus,
                            isEnabled: _isEnabled,
                            value: _selectedTypeParty.value.isEmpty ? null : _selectedTypeParty.value,
                            items: dropdownItemsParty,
                            hintText: 'Select Party',
                            onChanged: (val) {
                              _selectedTypeParty.value = val ?? '';
                            },
                          ),
                        );

                        final invoiceNoField = AppTextField(
                          label: 'Invoice No',
                          controller: invNoController,
                          focusNode: _invoiceFocus,
                          enabled: false,
                          hintText: 'Auto Generated',
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
                            label: 'Invoice Date',
                            controller: dateController,
                            focusNode: _dateFocus,
                            nextFocusNode: _brokerFocus,
                            enabled: _isEnabled,
                            readOnly: true,
                            prefixIcon: const Icon(Icons.calendar_today_rounded, size: 16),
                            onTap: _isEnabled ? _openDatePicker : null,
                          ),
                        );

                        final brokerField = Obx(
                          () => AppDropdown<String>(
                            label: 'Broker',
                            focusNode: _brokerFocus,
                            nextFocusNode: _dueDaysFocus,
                            isEnabled: _isEnabled,
                            value: _selectedTypeBroker.value.isEmpty ? null : _selectedTypeBroker.value,
                            items: dropdownItemsBroker,
                            onChanged: (val) {
                              _selectedTypeBroker.value = val ?? '22';
                            },
                          ),
                        );

                        final dueDaysField = AppTextField(
                          label: 'Due Days',
                          controller: dueDaysController,
                          focusNode: _dueDaysFocus,
                          nextFocusNode: _roughFocus,
                          enabled: _isEnabled,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: (val) {
                            if (selectedDate != null && val.isNotEmpty) {
                              final days = int.tryParse(val) ?? 0;
                              final calcDue = selectedDate!.add(Duration(days: days));
                              dueDate = formatDateWithTime(calcDue.toIso8601String());
                              dueDateController.text = DateFormat('dd-MM-yyyy').format(calcDue);
                            }
                          },
                        );

                        final dueDateField = AppTextField(
                          label: 'Due Date',
                          controller: dueDateController,
                          enabled: false,
                          readOnly: true,
                          hintText: 'Auto Calculated',
                        );

                        if (constraints.maxWidth >= 1000) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: partyField),
                              const SizedBox(width: 12),
                              Expanded(flex: 2, child: invoiceNoField),
                              const SizedBox(width: 12),
                              Expanded(flex: 2, child: dateField),
                              const SizedBox(width: 12),
                              Expanded(flex: 2, child: brokerField),
                              const SizedBox(width: 12),
                              Expanded(flex: 1, child: dueDaysField),
                              const SizedBox(width: 12),
                              Expanded(flex: 2, child: dueDateField),
                            ],
                          );
                        } else if (constraints.maxWidth >= 600) {
                          return Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(flex: 3, child: partyField),
                                  const SizedBox(width: 12),
                                  Expanded(flex: 2, child: invoiceNoField),
                                  const SizedBox(width: 12),
                                  Expanded(flex: 2, child: dateField),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(flex: 3, child: brokerField),
                                  const SizedBox(width: 12),
                                  Expanded(flex: 2, child: dueDaysField),
                                  const SizedBox(width: 12),
                                  Expanded(flex: 2, child: dueDateField),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              partyField,
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(child: invoiceNoField),
                                  const SizedBox(width: 10),
                                  Expanded(child: dateField),
                                ],
                              ),
                              const SizedBox(height: 10),
                              brokerField,
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(child: dueDaysField),
                                  const SizedBox(width: 10),
                                  Expanded(child: dueDateField),
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Rough Item Input Row Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isCompact = constraints.maxWidth < 600;
                        return Row(
                          children: [
                            Icon(Icons.diamond_outlined, size: 18, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              'Add Rough Details',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            if (!isCompact) ...[
                              const Spacer(),
                              Text(
                                'Keyboard: Enter on Rate automatically adds item to table',
                                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                    const Divider(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final roughTypeField = Obx(
                          () => AppDropdown<String>(
                            label: 'Rough Type',
                            focusNode: _roughFocus,
                            nextFocusNode: _descFocus,
                            isEnabled: _isEnabled,
                            value: _selectedType.value.isEmpty ? null : _selectedType.value,
                            items: dropdownItemsRough,
                            hintText: 'Select Rough',
                            onChanged: (val) {
                              _selectedType.value = val ?? '';
                            },
                          ),
                        );

                        final descField = AppTextField(
                          label: 'Description',
                          controller: descripController,
                          focusNode: _descFocus,
                          nextFocusNode: _wtFocus,
                          enabled: _isEnabled,
                          hintText: 'Notes',
                        );

                        final wtField = AppTextField(
                          label: 'Weight (Carats)',
                          controller: wtController,
                          focusNode: _wtFocus,
                          nextFocusNode: _rateFocus,
                          enabled: _isEnabled,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),
                          ],
                          hintText: '0.00',
                        );

                        final rateField = AppTextField(
                          label: 'Rate (₹)',
                          controller: rateController,
                          focusNode: _rateFocus,
                          enabled: _isEnabled,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                          hintText: '0.00',
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _addEntry(),
                        );

                        final amountField = AppTextField(
                          label: 'Amount (₹)',
                          controller: amountController,
                          enabled: false,
                          hintText: '0.00',
                        );

                        final addButton = AppButton(
                          text: 'Add',
                          icon: Icons.add_rounded,
                          shortcutLabel: 'Enter',
                          onPressed: _isEnabled ? _addEntry : null,
                        );

                        if (constraints.maxWidth >= 1000) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(flex: 3, child: roughTypeField),
                              const SizedBox(width: 10),
                              Expanded(flex: 3, child: descField),
                              const SizedBox(width: 10),
                              Expanded(flex: 2, child: wtField),
                              const SizedBox(width: 10),
                              Expanded(flex: 2, child: rateField),
                              const SizedBox(width: 10),
                              Expanded(flex: 2, child: amountField),
                              const SizedBox(width: 12),
                              addButton,
                            ],
                          );
                        } else if (constraints.maxWidth >= 600) {
                          return Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: roughTypeField),
                                  const SizedBox(width: 10),
                                  Expanded(child: descField),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(child: wtField),
                                  const SizedBox(width: 10),
                                  Expanded(child: rateField),
                                  const SizedBox(width: 10),
                                  Expanded(child: amountField),
                                  const SizedBox(width: 12),
                                  addButton,
                                ],
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              roughTypeField,
                              const SizedBox(height: 10),
                              descField,
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(child: wtField),
                                  const SizedBox(width: 10),
                                  Expanded(child: rateField),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(child: amountField),
                                  const SizedBox(width: 10),
                                  addButton,
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Rough Items Table Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.table_chart_outlined, size: 18, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Rough Items (${entries.length})',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildEntriesTable(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Action Toolbar Bar
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (!_isEnabled)
                      AppButton(
                        text: 'Add',
                        icon: Icons.add_circle_outline_rounded,
                        onPressed: () => _enableFields(),
                      ),
                    if (_isEnabled)
                      AppButton(
                        text: 'Save',
                        icon: Icons.save_rounded,
                        isLoading: defaultController.isLoading.value,
                        onPressed: _handleSave,
                      ),
                    if (_isFromEdit) ...[
                      AppButton(
                        text: 'Delete',
                        variant: AppButtonVariant.danger,
                        icon: Icons.delete_outline_rounded,
                        isLoading: defaultController.isDeleteLoading.value,
                        onPressed: _handleDelete,
                      ),
                      AppButton(
                        text: 'Print',
                        variant: AppButtonVariant.outline,
                        icon: Icons.print_rounded,
                        onPressed: _handlePrint,
                      ),
                    ],
                    if (_isEnabled)
                      AppButton(
                        text: 'Cancel',
                        variant: AppButtonVariant.outline,
                        icon: Icons.cancel_outlined,
                        onPressed: _handleCancel,
                      ),
                    AppButton(
                      text: 'Search',
                      variant: AppButtonVariant.secondary,
                      icon: Icons.search_rounded,
                      onPressed: () {
                        setState(() {
                          _isSearch = true;
                        });
                      },
                    ),
                    AppButton(
                      text: 'Exit',
                      variant: AppButtonVariant.secondary,
                      icon: Icons.exit_to_app_rounded,
                      onPressed: () => tabController.closeCurrentTab(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== ENTRIES TABLE WIDGET ====================
  Widget _buildEntriesTable() {
    if (entries.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 36),
        alignment: Alignment.center,
        child: Column(
          children: [
            Icon(Icons.inventory_2_outlined, size: 36, color: AppColors.textMuted),
            const SizedBox(height: 8),
            Text(
              'No rough items added yet.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 700),
            child: Table(
          border: TableBorder(
            horizontalInside: BorderSide(color: AppColors.borderLight, width: 1),
          ),
          columnWidths: const {
            0: FixedColumnWidth(55), // SR
            1: FlexColumnWidth(3),   // Rough
            2: FlexColumnWidth(4),   // Description
            3: FixedColumnWidth(110), // Wt
            4: FixedColumnWidth(110), // Rate
            5: FixedColumnWidth(130), // Amt
            6: FixedColumnWidth(80),  // Actions
          },
          children: [
            // Header
            TableRow(
              decoration: BoxDecoration(color: AppColors.isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
              children: [
                _buildTableCell('SR.', isHeader: true, align: TextAlign.center),
                _buildTableCell('ROUGH TYPE', isHeader: true),
                _buildTableCell('DESCRIPTION', isHeader: true),
                _buildTableCell('WT (CTS)', isHeader: true, align: TextAlign.right),
                _buildTableCell('RATE (₹)', isHeader: true, align: TextAlign.right),
                _buildTableCell('AMOUNT (₹)', isHeader: true, align: TextAlign.right),
                _buildTableCell('ACTIONS', isHeader: true, align: TextAlign.center),
              ],
            ),

            // Rows
            for (int i = 0; i < entries.length; i++)
              TableRow(
                decoration: BoxDecoration(
                  color: i.isEven ? AppColors.surface : AppColors.tableRowAlt,
                ),
                children: [
                  _buildTableCell('${i + 1}', align: TextAlign.center),
                  _buildTableCell(getRoughName(entries[i]['rough']!)),
                  _buildTableCell(entries[i]['description'] ?? '-'),
                  _buildTableCell(entries[i]['wt']!, align: TextAlign.right),
                  _buildTableCell(entries[i]['rate']!, align: TextAlign.right),
                  _buildTableCell(entries[i]['amount']!, align: TextAlign.right),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit_outlined, size: 16, color: AppColors.primary),
                          splashRadius: 14,
                          tooltip: 'Edit Item',
                          onPressed: () {
                            if (_isFromEdit) {
                              selectedRoughId.value = entries[i]['id'] ?? '';
                            }
                            _selectedType.value = entries[i]['rough']!;
                            wtController.text = entries[i]['wt']!;
                            rateController.text = entries[i]['rate']!;
                            descripController.text = entries[i]['description'] ?? '';
                            setState(() {
                              entries.removeAt(i);
                            });
                            _roughFocus.requestFocus();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.danger),
                          splashRadius: 14,
                          tooltip: 'Delete Item',
                          onPressed: () {
                            if (_isFromEdit) {
                              if (entries.length == 1) {
                                infoDialog(messageText: 'Cannot delete the only rough entry in edit mode.');
                                return;
                              }
                              defaultController.deletePurchaseRoughData(
                                id: int.parse(entries[i]['id']!),
                              ).then((_) {
                                setState(() {
                                  entries.removeAt(i);
                                });
                              });
                            } else {
                              setState(() {
                                entries.removeAt(i);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            // Total Summary Row
            TableRow(
              decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
              children: [
                _buildTableCell('', isHeader: true),
                _buildTableCell('', isHeader: true),
                _buildTableCell('TOTAL', isHeader: true, align: TextAlign.right),
                _buildTableCell(totalWt.toStringAsFixed(2), isHeader: true, align: TextAlign.right),
                _buildTableCell(totalRate.toStringAsFixed(2), isHeader: true, align: TextAlign.right),
                _buildTableCell(totalAmount.toStringAsFixed(2), isHeader: true, align: TextAlign.right),
                _buildTableCell('', isHeader: true),
              ],
            ),
          ],
        ),
      ),
    ),
  ),
);
  }

  Widget _buildTableCell(String text, {bool isHeader = false, TextAlign align = TextAlign.left}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
          color: isHeader ? AppColors.textPrimary : AppColors.textSecondary,
        ),
      ),
    );
  }
}
