import 'package:flutter/foundation.dart';
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
import 'package:real_web_rough_entry_system/sale/invoice_generator.dart';
import 'package:real_web_rough_entry_system/sale/sale_datagrid.dart';
import 'package:real_web_rough_entry_system/sale/sale_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SaleFormScreen extends StatefulWidget {
  final bool showHeader;

  const SaleFormScreen({super.key, required this.showHeader});

  @override
  SaleFormScreenState createState() => SaleFormScreenState();
}

class SaleFormScreenState extends State<SaleFormScreen> {
  // Master header controllers
  final TextEditingController invNoController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController dueDaysController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();

  // Item input controllers
  final TextEditingController descripController = TextEditingController();
  final TextEditingController wtController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController stockController = TextEditingController(text: '0.000');

  // Focus nodes
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
  final RxInt selectedPolishSaleMstID = 0.obs;
  final RxString selectedRoughId = ''.obs;

  DateTime? selectedDate;
  String? dueDate;

  bool _isEnabled = false;
  bool _isSearch = false;
  bool _isFromEdit = false;
  final RxBool _isFiltered = false.obs;

  DateTime? fromDate;
  DateTime? toDate;
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  RxList<PolishSaleModel> saleDataGridSource = <PolishSaleModel>[].obs;
  RxList<PolishSaleModel> filteredDataGridSource = <PolishSaleModel>[].obs;

  double get totalWt => entries.fold(0.0, (prev, e) => prev + (double.tryParse(e['wt'] ?? '0') ?? 0.0));
  double get totalRate => totalWt == 0 ? 0 : totalAmount / totalWt;
  double get totalAmount => entries.fold(0.0, (prev, e) => prev + (double.tryParse(e['amount'] ?? '0') ?? 0.0));

  @override
  void initState() {
    super.initState();
    wtController.addListener(_updateAmount);
    rateController.addListener(_updateAmount);
    saleDataGridSource.value = defaultController.polishSaleList;
  }

  @override
  void dispose() {
    invNoController.dispose();
    dateController.dispose();
    dueDaysController.dispose();
    dueDateController.dispose();
    descripController.dispose();
    wtController.dispose();
    rateController.dispose();
    amountController.dispose();
    stockController.dispose();
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

  void _updateStock(String? val) {
    _selectedType.value = val ?? '';
    if (val != null && val.isNotEmpty) {
      final int code = int.tryParse(val) ?? 0;
      if (defaultController.groupedData.containsKey(code)) {
        stockController.text = defaultController.groupedData[code]!.toStringAsFixed(3);
      } else {
        stockController.text = '0.000';
      }
    } else {
      stockController.text = '0.000';
    }
  }

  void _updateDueDate() {
    if (selectedDate != null) {
      final int days = int.tryParse(dueDaysController.text) ?? 0;
      final DateTime temp = selectedDate!.add(Duration(days: days));
      dueDateController.text = DateFormat('dd-MM-yyyy').format(temp);
      dueDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(temp);
    }
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
        _updateDueDate();
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
        'wt': wt.toStringAsFixed(3),
        'rate': rate.toStringAsFixed(2),
        'amount': (wt * rate).toStringAsFixed(2),
      });

      _selectedType.value = '';
      descripController.clear();
      wtController.clear();
      rateController.clear();
      amountController.clear();
      stockController.text = '0.000';
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
      await defaultController.updateSaleData(
        id: selectedPolishSaleMstID.value,
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
      await defaultController.addSaleData(
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
      selectedPolishSaleMstID.value = 0;
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
    stockController.text = '0.000';
  }

  Future<void> _handleDelete() async {
    if (!_isFromEdit) return;
    await defaultController.deleteSaleData(
      id: selectedPolishSaleMstID.value,
      entries: entries,
    );
    _handleCancel();
  }

  Future<void> _handlePrint() async {
    if (!_isFromEdit || selectedDate == null) return;
    final invoiceGenerator = SaleInvoiceGenerator();
    final pdfData = await invoiceGenerator.generateInvoice(
      id: defaultController.polishSaleList.length + 1,
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
    if (!kDebugMode) {
      await Printing.sharePdf(
        bytes: pdfData,
        filename: '${invNoController.text}.pdf',
      );
    }
  }

  void _applyDateFilter() {
    if (fromDate != null && toDate != null) {
      _isFiltered.value = true;
      filteredDataGridSource.value = defaultController.polishSaleList.where((sale) {
        final invoiceDate = DateTime.parse(sale.invoiceDate!);
        return invoiceDate.isAfter(fromDate!) && invoiceDate.isBefore(toDate!.add(const Duration(days: 1)));
      }).toList();
      saleDataGridSource.value = filteredDataGridSource;
    } else {
      infoDialog(messageText: 'Please select both From Date and To Date');
    }
  }

  void _removeDateFilter() {
    saleDataGridSource.value = defaultController.polishSaleList;
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
        child: Text(item.roughTypeName ?? '', style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> get dropdownItemsParty {
    return defaultController.partyMstList
        .where((p) => p.typeCode == 2 && p.companyCode == defaultController.companyCode.value)
        .map((p) {
          return DropdownMenuItem<String>(
            value: p.partyCode.toString(),
            child: Text(p.partyName ?? '', style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
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
            child: Text(p.partyName ?? '', style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
          );
        })
        .toSet()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
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
            if (widget.showHeader) Header(title: _isSearch ? 'Sale Search' : 'Sale Entry'),
            Expanded(
              child: _isSearch ? _buildSearchView() : _buildFormView(),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== SEARCH / DATAGRID VIEW ====================
  Widget _buildSearchView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
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
              source: SaleDataGridSource(saleDataGridSource),
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
                  title: 'Total ${saleDataGridSource.length} entries',
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
    selectedPolishSaleMstID.value = id;

    final partyEntry = defaultController.polishSaleList.firstWhere(
      (entry) => entry.polishSaleMstID == id,
    );
    final roughEntries = defaultController.saleDetailsList.where(
      (entry) => entry.polishSaleMstID == id,
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
          'id': r.polishSaleDetID.toString(),
          'rough': r.roughTypeCode.toString(),
          'description': r.description?.toString() ?? '',
          'wt': r.carats?.toString() ?? '0.00',
          'rate': r.rateRs?.toString() ?? '0.00',
          'amount': ((r.carats ?? 0) * (r.rateRs ?? 0)).toStringAsFixed(2),
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
                    const Row(
                      children: [
                        Icon(Icons.point_of_sale_rounded, size: 18, color: AppColors.primary),
                        SizedBox(width: 8),
                        Text(
                          'Sale Invoice Header',
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
                            _updateDueDate();
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
                        final isCompact = constraints.maxWidth < 650;
                        return Row(
                          children: [
                            const Icon(Icons.diamond_outlined, size: 18, color: AppColors.primary),
                            const SizedBox(width: 8),
                            const Text(
                              'Add Polish / Rough Details',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            if (!isCompact) ...[
                              const Spacer(),
                              const Text(
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
                              _updateStock(val);
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
                          hintText: '0.000',
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

                        final stockField = AppTextField(
                          label: 'Avail Stock',
                          controller: stockController,
                          enabled: false,
                          hintText: '0.000',
                        );

                        final addButton = AppButton(
                          text: 'Add',
                          icon: Icons.add_rounded,
                          shortcutLabel: 'Enter',
                          onPressed: _isEnabled ? _addEntry : null,
                        );

                        if (constraints.maxWidth >= 1100) {
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
                              const SizedBox(width: 10),
                              Expanded(flex: 2, child: stockField),
                              const SizedBox(width: 12),
                              addButton,
                            ],
                          );
                        } else if (constraints.maxWidth >= 650) {
                          return Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(flex: 2, child: roughTypeField),
                                  const SizedBox(width: 10),
                                  Expanded(flex: 2, child: descField),
                                  const SizedBox(width: 10),
                                  Expanded(flex: 1, child: stockField),
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
                              Row(
                                children: [
                                  Expanded(flex: 2, child: roughTypeField),
                                  const SizedBox(width: 10),
                                  Expanded(flex: 1, child: stockField),
                                ],
                              ),
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

            // Entries Table Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.table_chart_outlined, size: 18, color: AppColors.primary),
                        const SizedBox(width: 8),
                        const Text(
                          'Items List',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${entries.length} items',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    if (entries.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(32),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Icon(Icons.inbox_outlined, size: 40, color: Colors.grey.shade400),
                            const SizedBox(height: 8),
                            Text(
                              'No rough items added yet. Fill fields above and press Enter.',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                            ),
                          ],
                        ),
                      )
                    else
                      _buildEntriesTable(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Bottom Action Bar
            _buildActionBar(),
          ],
        ),
      ),
    );
  }

  // ==================== ENTRIES TABLE ====================
  Widget _buildEntriesTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(6),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 700),
            child: Table(
        columnWidths: const {
          0: FixedColumnWidth(55), // SR.NO
          1: FlexColumnWidth(100), // ROUGH
          2: FlexColumnWidth(160), // DESCRIPTION
          3: FlexColumnWidth(80), // WT
          4: FlexColumnWidth(80), // RATE
          5: FlexColumnWidth(100), // AMOUNT
          6: FixedColumnWidth(85), // ACTIONS
        },
        children: [
          // Table Header
          TableRow(
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            children: [
              _headerCell('SR.NO'),
              _headerCell('ROUGH TYPE'),
              _headerCell('DESCRIPTION'),
              _headerCell('WT (CTS)', textAlign: TextAlign.right),
              _headerCell('RATE (₹)', textAlign: TextAlign.right),
              _headerCell('AMOUNT (₹)', textAlign: TextAlign.right),
              _headerCell('ACTIONS', textAlign: TextAlign.center),
            ],
          ),

          // Data Rows
          for (int i = 0; i < entries.length; i++)
            TableRow(
              decoration: BoxDecoration(
                color: i.isEven ? Colors.white : const Color(0xFFF8FAFC),
                border: const Border(bottom: BorderSide(color: AppColors.borderLight, width: 0.5)),
              ),
              children: [
                _dataCell('${i + 1}', alignment: Alignment.center),
                _dataCell(getRoughName(entries[i]['rough'])),
                _dataCell(entries[i]['description'] ?? '-'),
                _dataCell(entries[i]['wt'] ?? '0.000', alignment: Alignment.centerRight),
                _dataCell(entries[i]['rate'] ?? '0.00', alignment: Alignment.centerRight),
                _dataCell(entries[i]['amount'] ?? '0.00', alignment: Alignment.centerRight, isBold: true),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Edit button
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.primary),
                        tooltip: 'Edit Item',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          if (_isFromEdit) {
                            selectedRoughId.value = entries[i]['id'] ?? '';
                          }
                          _selectedType.value = entries[i]['rough'] ?? '';
                          wtController.text = entries[i]['wt'] ?? '';
                          rateController.text = entries[i]['rate'] ?? '';
                          descripController.text = entries[i]['description'] ?? '';
                          _updateStock(entries[i]['rough']);
                          setState(() {
                            entries.removeAt(i);
                          });
                          _roughFocus.requestFocus();
                        },
                      ),
                      const SizedBox(width: 8),

                      // Delete button
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.danger),
                        tooltip: 'Delete Item',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () async {
                          if (_isFromEdit) {
                            if (entries.length == 1) {
                              infoDialog(messageText: 'Cannot delete the only remaining rough entry');
                              return;
                            }
                            final String? idStr = entries[i]['id'];
                            if (idStr != null && idStr.isNotEmpty) {
                              await defaultController.deleteSaleRoughData(id: int.parse(idStr));
                            }
                          }
                          setState(() {
                            entries.removeAt(i);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

          // Total Summary Row
          TableRow(
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              border: Border(top: BorderSide(color: AppColors.borderLight, width: 1.5)),
            ),
            children: [
              _summaryCell(''),
              _summaryCell(''),
              _summaryCell('TOTAL', textAlign: TextAlign.right, isBold: true),
              _summaryCell(totalWt.toStringAsFixed(3), textAlign: TextAlign.right, isBold: true),
              _summaryCell(totalRate.toStringAsFixed(2), textAlign: TextAlign.right, isBold: true),
              _summaryCell(totalAmount.toStringAsFixed(2), textAlign: TextAlign.right, isBold: true, isPrimary: true),
              _summaryCell(''),
            ],
          ),
        ],
      ),
    ),
  ),
),
);
  }

  Widget _headerCell(String title, {TextAlign textAlign = TextAlign.left}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
        textAlign: textAlign,
      ),
    );
  }

  Widget _dataCell(String value, {Alignment alignment = Alignment.centerLeft, bool isBold = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      alignment: alignment,
      child: Text(
        value,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _summaryCell(String value,
      {TextAlign textAlign = TextAlign.left, bool isBold = false, bool isPrimary = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: isPrimary ? AppColors.primary : AppColors.textPrimary,
        ),
        textAlign: textAlign,
      ),
    );
  }

  // ==================== BOTTOM ACTION BAR ====================
  Widget _buildActionBar() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Add Button
            AppButton(
              text: 'Add',
              icon: Icons.add_rounded,
              onPressed: !_isEnabled ? () => _enableFields() : null,
            ),

            // Save Button
            Obx(
              () => AppButton(
                text: 'Save',
                icon: Icons.save_rounded,
                isLoading: defaultController.isLoading.value,
                onPressed: _isEnabled ? _handleSave : null,
              ),
            ),

            // Delete Button
            Obx(
              () => AppButton(
                text: 'Delete',
                icon: Icons.delete_outline_rounded,
                variant: AppButtonVariant.danger,
                isLoading: defaultController.isDeleteLoading.value,
                onPressed: (_isEnabled && _isFromEdit) ? _handleDelete : null,
              ),
            ),

            // Cancel Button
            AppButton(
              text: 'Cancel',
              icon: Icons.refresh_rounded,
              variant: AppButtonVariant.secondary,
              onPressed: _isEnabled ? _handleCancel : null,
            ),

            // Exit Button
            AppButton(
              text: 'Exit',
              icon: Icons.exit_to_app_rounded,
              variant: AppButtonVariant.outline,
              onPressed: () => tabController.closeCurrentTab(),
            ),

            // Search Button
            AppButton(
              text: 'Search',
              icon: Icons.search_rounded,
              variant: AppButtonVariant.secondary,
              onPressed: () {
                setState(() {
                  _isSearch = true;
                });
              },
            ),

            // Print Button
            AppButton(
              text: 'Print',
              icon: Icons.print_rounded,
              variant: AppButtonVariant.outline,
              onPressed: _isFromEdit ? _handlePrint : null,
            ),
          ],
        ),
      ),
    );
  }
}
