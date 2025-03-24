import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/header.dart';
import 'package:real_web_rough_entry_system/purchase/invoice_generator.dart';
import 'package:real_web_rough_entry_system/purchase/purchase_datagrid.dart';
import 'package:real_web_rough_entry_system/purchase/purchase_details_model.dart';
import 'package:real_web_rough_entry_system/responsive.dart';
import 'package:real_web_rough_entry_system/rough/rough_details_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PurchaseFormScreen extends StatefulWidget {
  final bool showHeader;

  const PurchaseFormScreen({super.key, required this.showHeader});

  @override
  PurchaseFormScreenState createState() => PurchaseFormScreenState();
}

class PurchaseFormScreenState extends State<PurchaseFormScreen> {
  final TextEditingController partyController = TextEditingController();
  final TextEditingController invNoController =
  TextEditingController(text: ' ');
  final TextEditingController dateController = TextEditingController();
  final TextEditingController purIdController = TextEditingController();
  final TextEditingController dueDaysController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();

  final TextEditingController roghController = TextEditingController();
  final TextEditingController descripController = TextEditingController();
  final TextEditingController wtController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final FocusNode _partyFocNode = FocusNode();
  final FocusNode _roughFocNode = FocusNode();
  final FocusNode _invoiceFocus = FocusNode();
  final FocusNode _dueDaysFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();
  final FocusNode _dateFocus = FocusNode();
  final FocusNode _brokerFocus = FocusNode();
  final FocusNode _wtFocus = FocusNode();
  final FocusNode _rateFocus = FocusNode();
  final FocusNode _formKeyBoardFocus = FocusNode();
  final FocusNode _searchKeyBoardFocus = FocusNode();
  final DataGridController _dataGridController = DataGridController();
  List<Map<String, String>> entries = [];
  final RxString _selectedType = ''.obs;
  final RxString _selectedTypeBroker = '22'.obs;
  final RxString _selectedTypeParty = ''.obs;
  final RxInt selectedRoughPurMstID = 0.obs;
  final RxString selectedRoughId = ''.obs;

  DateTime? selectedDate;
  String? dueDate;

  double get totalWt =>
      entries.fold(0.0, (prev, e) => prev + double.parse(e['wt']!));

  double get totalRate => totalWt == 0 ? 0 : totalAmount / totalWt;

  double get totalAmount =>
      entries.fold(0.0, (prev, e) => prev + double.parse(e['amount']!));

  bool _isEnabled = false;
  bool _isSearch = false;
  bool _isFromEdit = false;
  final RxBool _isFiltered = false.obs;
  final _formKey = GlobalKey<FormState>();
  final RxString selectedTypeAccountParty = ''.obs;
  final RxString selectedTypeBookParty = ''.obs;

  DateTime? fromDate;
  DateTime? toDate;
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  final DefaultController defaultController = Get.find<DefaultController>();

  RxList<PurchaseDetailsModel> purchaseDataGridSource =
      <PurchaseDetailsModel>[].obs;
  RxList<PurchaseDetailsModel> filteredDataGridSource =
      <PurchaseDetailsModel>[].obs;

  void _enableFields({bool? needFocus}) {
    setState(() {
      if (needFocus == null || needFocus) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _partyFocNode.requestFocus(); // Move focus to the first input field
        });
        _isEnabled = true;
      } else {
        _isEnabled = true;
      }
    });
  }

  @override
  void initState() {
    wtController.addListener(_updateAmount);
    rateController.addListener(_updateAmount);
    // invNoController.text = defaultController.purchaseDataList.last.invoiceNo ?? '0';
    purchaseDataGridSource.value = defaultController.purchaseDataList;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _formKeyBoardFocus.requestFocus();
      if (_isSearch) {
        _searchKeyBoardFocus.requestFocus();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    wtController.dispose();
    rateController.dispose();
    amountController.dispose();
    _dateFocus.dispose();
    _partyFocNode.dispose();
    _descFocus.dispose();
    _wtFocus.dispose();
    _rateFocus.dispose();
    _roughFocNode.dispose();
    _brokerFocus.dispose();
    _invoiceFocus.dispose();
    _dueDaysFocus.dispose();
    _formKeyBoardFocus.dispose();
    _searchKeyBoardFocus.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
  }

  void _updateAmount() {
    final double wt = double.tryParse(wtController.text) ?? 0;
    final double rate = double.tryParse(rateController.text) ?? 0;
    final double amount = wt * rate;
    amountController.text = amount.toStringAsFixed(2);
  }

  void _scrollToSelectedRow(double index) {
    // Scroll to the currently selected row
    _dataGridController.scrollToRow(index);
  }

  // void onSelectBookParty() {
  //   if (selectedTypeBookParty.isNotEmpty) {
  //     defaultController.bookPartyCreditDebitDataGridSource.value = defaultController
  //         .creditDebitDataList
  //         .where((e) => e.partyCode == int.parse(selectedTypeBookParty.value))
  //         .toList();
  //     print('BOOK PARTY${defaultController.bookPartyCreditDebitDataGridSource.length}');
  //   }
  // }
  //
  // void onSelectAccountParty() {
  //   if (selectedTypeAccountParty.isNotEmpty) {
  //     defaultController.accountPartyCreditDebitDataGridSource.value = defaultController
  //         .creditDebitDataList
  //         .where(
  //             (e) => e.partyCode == int.parse(selectedTypeAccountParty.value))
  //         .toList();
  //     print('ACCOUNT PARTY${defaultController.accountPartyCreditDebitDataGridSource.length}');
  //   }
  // }
  void _applyDateFilter() {
    if (fromDate != null && toDate != null) {
      _isFiltered.value = true;
      // setState(() {
      filteredDataGridSource.value =
          defaultController.purchaseDataList.where((purchase) {
            // Assuming invoiceDate is in 'yyyy-MM-dd' format; adjust as needed
            final invoiceDate = DateTime.parse(purchase.invoiceDate!);

            // Include the boundaries
            return invoiceDate.isAfter(fromDate!) &&
                invoiceDate.isBefore(toDate!.add(const Duration(days: 1)));
          }).toList();
      // Update the data grid source with the filtered data
      purchaseDataGridSource.value = filteredDataGridSource;
      _searchKeyBoardFocus.requestFocus();
      // });
    } else {
      infoDialog(messageText: 'Please select both From Date and To Date');
    }
  }

  void _removeDateFilter() {
    // Reset the data grid source to the full list
    purchaseDataGridSource.value = defaultController.purchaseDataList;

    // Clear filter values
    toDateController.clear();
    fromDateController.clear();
    fromDate = null;
    toDate = null;

    _isFiltered.value = false;
  }

  void _openDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
        Future.delayed(const Duration(milliseconds: 100), () {
          _dueDaysFocus.requestFocus(); // Move focus to the first input field
        });
      });
      // _updateDueDate();
    }
  }

  void addEntry() {
    setState(() {
      entries.add({
        if (selectedRoughId.value.isNotEmpty) 'id': selectedRoughId.value,
        'rough': _selectedType.value,
        'description': descripController.text,
        'wt': double.parse(wtController.text).toStringAsFixed(2),
        'rate': double.parse(rateController.text).toStringAsFixed(2),
        'amount': (double.parse(wtController.text) *
            double.parse(rateController.text))
            .toStringAsFixed(2),
      });

      // Clear the input fields
      _selectedType.value = '';
      descripController.clear();
      wtController.clear();
      rateController.clear();
      amountController.clear();
      Future.delayed(const Duration(milliseconds: 100), () {
        _roughFocNode.requestFocus(); // Move focus to the first input field
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _isSearch == true
          ? Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.showHeader
              ? const Header(title: 'Purchase Search')
              : const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0, vertical: 8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: buildTextField(
                        'From Date',
                        excludeFieldValidation: false,
                        fromDateController,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              fromDate = pickedDate;
                              fromDateController.text =
                                  DateFormat('dd-MM-yyyy')
                                      .format(fromDate!);
                              if (toDateController.text.isNotEmpty) {
                                _applyDateFilter();
                              }
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: buildTextField(
                        'To Date',
                        excludeFieldValidation: false,
                        toDateController,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              toDate = pickedDate;
                              toDateController.text =
                                  DateFormat('dd-MM-yyyy').format(toDate!);
                              if (fromDateController.text.isNotEmpty) {
                                _applyDateFilter();
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildBottomButton(
                        text: 'Filter', onPressed: _applyDateFilter),
                    Obx(() => _isFiltered.value
                        ? buildBottomButton(
                        text: 'Reset', onPressed: _removeDateFilter)
                        : const SizedBox.shrink()),
                    buildBottomButton(text: 'Exit', onPressed: () {
                      setState(() {
                        _isSearch = false;
                      });
                    },),
                  ],
                ),

              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Obx(
                    () =>
                    SfDataGrid(
                      controller: _dataGridController,
                      source:
                      PurchaseDataGridSource(purchaseDataGridSource),
                      columns: <GridColumn>[
                        GridColumn(
                          columnName: 'ID',
                          visible: false,
                          label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text(
                              'ID',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Invoice No',
                          label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text(
                              'Invoice No',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Invoice Date',
                          label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text(
                              'Invoice Date',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Party',
                          label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text(
                              'Party',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Broker',
                          label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text(
                              'Broker',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Tot Wt',
                          label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text(
                              'Tot Wt',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Tot Amt Rs',
                          label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text(
                              'Tot Amt Rs',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                      tableSummaryRows: [
                        GridTableSummaryRow(
                            title: 'Total ${purchaseDataGridSource.length}',
                            showSummaryInRow: false,
                            titleColumnSpan: 2,
                            columns: <GridSummaryColumn>[
                              const GridSummaryColumn(
                                  name: 'Tot Wt',
                                  columnName: 'Tot Wt',
                                  summaryType: GridSummaryType.sum),
                              const GridSummaryColumn(
                                  name: 'Tot Amt Rs',
                                  columnName: 'Tot Amt Rs',
                                  summaryType: GridSummaryType.sum),
                            ],
                            position: GridTableSummaryRowPosition.bottom)
                      ],
                      rowHeight: 25,
                      headerRowHeight: 35,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      showSortNumbers: true,
                      // allowSorting: true,
                      // allowMultiColumnSorting: true,
                      allowFiltering: true,
                      selectionMode: SelectionMode.single,
                      // onSelectionChanged: (List<DataGridRow> selectedRows) {
                      //   // Handle row selection change if needed
                      // },
                      onSelectionChanged: (List<DataGridRow> addedRows,
                          List<DataGridRow> removedRows) {
                        setState(() {
                          entries.length = 0;
                          _isFromEdit = true;
                        });
                        if (addedRows.isNotEmpty) {
                          final DataGridRow selectedRow = addedRows.first;
                          List<RoughDetailsModel> roughData =
                              defaultController.roughDetailsModel;
                          List<PurchaseDetailsModel> partyData =
                              defaultController.purchaseDataList;

                          // Extract the selected polishSaleMstID from the selectedRow
                          selectedRoughPurMstID.value = selectedRow
                              .getCells()[0]
                              .value; // Assuming the ID is in the first cell

                          // Find the corresponding party data entry with the matching polishSaleMstID
                          PurchaseDetailsModel partyEntry =
                          partyData.firstWhere(
                                (entry) =>
                            entry.roughPurMstID ==
                                selectedRoughPurMstID.value,
                            // orElse: () => null,
                          );

                          // Collect rough data entries with the matching polishSaleMstID
                          List<RoughDetailsModel> roughEntries = roughData
                              .where((entry) =>
                          entry.roughPurMstID ==
                              selectedRoughPurMstID.value)
                              .toList();

                          // if (kDebugMode) {
                          //   print(
                          //       "ROUGH ID:  ${roughEntries.first.roughPurMstID}  ${roughEntries.first.roughPurDetID}");
                          //   print(
                          //       "ROUGH ID:  ${roughEntries.last.roughPurMstID} ${roughEntries.last.roughPurDetID}");
                          // }
                          invNoController.text = partyEntry.invoiceNo!;
                          selectedDate =
                              dateFormat(partyEntry.invoiceDate!);
                          dueDate = formatDateWithTime(partyEntry.dueDate!);
                          dateController.text =
                              formatDate(partyEntry.invoiceDate!);
                          dueDateController.text =
                              formatDate(partyEntry.dueDate!);
                          dueDaysController.text =
                              partyEntry.dueDay.toString();
                          _selectedTypeParty.value =
                              partyEntry.partyCode.toString();
                          _selectedTypeBroker.value = _selectedTypeBroker
                              .value = partyEntry.brokerCode.toString();
                          // _selectedTypeParty.value = partyEntry.partyCode;
                          setState(() {
                            for (var roughEntry in roughEntries) {
                              entries.add({
                                'id': roughEntry.roughPurDetID.toString(),
                                'rough':
                                roughEntry.roughTypeCode.toString(),
                                'description':
                                roughEntry.description.toString(),
                                'wt': roughEntry.wt!.toStringAsFixed(2),
                                'rate':
                                roughEntry.rateRs!.toStringAsFixed(2),
                                'amount': (double.parse(
                                    roughEntry.wt.toString()) *
                                    double.parse(
                                        roughEntry.rateRs.toString()))
                                    .toStringAsFixed(2),
                              });
                            }
                          });

                          _enableFields();
                          setState(() {
                            _isSearch = false;
                          });
                        }
                      },
                      columnWidthMode: ColumnWidthMode.auto,
                      frozenColumnsCount: 2,
                      // gridLineStrokeWidth: 1.5,
                      // gridLineColor: Colors.grey.shade400,
                      // backgroundColor: Colors.white,
                    ),
              ),
            ),
          ),
        ],
      )
          : SingleChildScrollView(
        child: Obx(
              () =>
              Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      widget.showHeader
                          ? const Header(title: 'Purchase')
                          : const SizedBox.shrink(),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                    color: Colors.grey),
                                                left:
                                                BorderSide(color: Colors.grey),
                                                right:
                                                BorderSide(color: Colors.grey),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                _buildRow([
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'PARTY',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.w900,
                                                          fontSize:
                                                          12, // Font size for the label
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Obx(() {
                                                          return DropdownButtonFormField<
                                                              String>(
                                                            focusNode:
                                                            _partyFocNode,
                                                            style: const TextStyle(
                                                                fontSize: 12),
                                                            value: _selectedTypeParty
                                                                .value.isEmpty
                                                                ? null
                                                                : _selectedTypeParty
                                                                .value,
                                                            decoration:
                                                            const InputDecoration(
                                                              errorStyle: TextStyle(
                                                                height: 0,
                                                                // Hides the error message
                                                                fontSize:
                                                                0, // Ensures no space is taken by the error message
                                                              ),
                                                              focusedErrorBorder:
                                                              UnderlineInputBorder(
                                                                borderSide:
                                                                BorderSide(
                                                                  color: Colors
                                                                      .red,
                                                                  width:
                                                                  1.0, // Thin border width
                                                                ),
                                                                borderRadius:
                                                                BorderRadius
                                                                    .zero, // Squared corners
                                                              ),
                                                              errorBorder:
                                                              UnderlineInputBorder(
                                                                borderSide:
                                                                BorderSide(
                                                                  color: Colors
                                                                      .red,
                                                                  width:
                                                                  1.0, // Thin border width
                                                                ),
                                                                borderRadius:
                                                                BorderRadius
                                                                    .zero, // Squared corners
                                                              ),
                                                              focusedBorder:
                                                              UnderlineInputBorder(
                                                                borderSide:
                                                                BorderSide(
                                                                  color:
                                                                  Colors.blue,
                                                                  width:
                                                                  1.0, // Thin border width
                                                                ),
                                                                borderRadius:
                                                                BorderRadius
                                                                    .zero, // Squared corners
                                                              ),
                                                              enabledBorder:
                                                              UnderlineInputBorder(
                                                                borderSide:
                                                                BorderSide(
                                                                  color:
                                                                  Colors.grey,
                                                                  width:
                                                                  1.0, // Thin border width
                                                                ),
                                                                borderRadius:
                                                                BorderRadius
                                                                    .zero, // Squared corners
                                                              ),
                                                              isDense: true,
                                                              contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                vertical: 8,
                                                                horizontal: 8,
                                                              ),
                                                            ),
                                                            items:
                                                            dropdownItemsParty,
                                                            onChanged: _isEnabled
                                                                ? (value) {
                                                              _selectedTypeParty
                                                                  .value =
                                                                  value ?? '';
                                                              Future.delayed(
                                                                  const Duration(
                                                                      milliseconds:
                                                                      100),
                                                                      () {
                                                                    _dateFocus
                                                                        .requestFocus(); // Move focus to the first input field
                                                                  }); // Handle null case
                                                            }
                                                                : null,
                                                          );
                                                        }),
                                                      ),
                                                    ],
                                                  ),

                                                  // _buildTextField('PURID', 'AUTO', purIdController),
                                                ]),
                                                const SizedBox(height: 5),
                                                _buildRow([
                                                  buildTextField(
                                                      'INVOICE NO.',
                                                      excludeFieldValidation: true,
                                                      invNoController,
                                                      isEnabled: false,
                                                      focusNode: _invoiceFocus,
                                                      onEditingComplete: () {
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds: 100), () {
                                                          _dateFocus
                                                              .requestFocus(); // Move focus to the first input field
                                                        });
                                                      },
                                                      onChanged: (value) {}),
                                                ]),
                                                const SizedBox(height: 5),
                                                _buildRow([
                                                  Focus(
                                                    onKeyEvent: (node, event) {
                                                      if (HardwareKeyboard
                                                          .instance
                                                          .isLogicalKeyPressed(
                                                          LogicalKeyboardKey
                                                              .enter)) {
                                                        _openDatePicker(); // Open date picker when Enter key is pressed
                                                        return KeyEventResult
                                                            .handled;
                                                      }
                                                      return KeyEventResult
                                                          .ignored;
                                                    },
                                                    child: buildTextField(
                                                      excludeFieldValidation: false,
                                                      'DATE',
                                                      dateController,
                                                      isEnabled: _isEnabled,
                                                      focusNode: _dateFocus,
                                                      onTap: () {
                                                        _openDatePicker();
                                                      },
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'BROKER',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.w900,
                                                          fontSize:
                                                          12, // Font size for the label
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Obx(() {
                                                          return DropdownButtonFormField<
                                                              String>(
                                                            focusNode: _brokerFocus,
                                                            style: const TextStyle(
                                                                fontSize: 12),
                                                            value: _selectedTypeBroker
                                                                .value
                                                                .toString()
                                                                .isEmpty
                                                                ? null
                                                                : _selectedTypeBroker
                                                                .value
                                                                .toString(),
                                                            decoration:
                                                            const InputDecoration(
                                                              errorStyle: TextStyle(
                                                                height: 0,
                                                                // Hides the error message
                                                                fontSize:
                                                                0, // Ensures no space is taken by the error message
                                                              ),
                                                              focusedErrorBorder:
                                                              UnderlineInputBorder(
                                                                borderSide:
                                                                BorderSide(
                                                                  color: Colors
                                                                      .red,
                                                                  width:
                                                                  1.0, // Thin border width
                                                                ),
                                                                borderRadius:
                                                                BorderRadius
                                                                    .zero, // Squared corners
                                                              ),
                                                              errorBorder:
                                                              UnderlineInputBorder(
                                                                borderSide:
                                                                BorderSide(
                                                                  color: Colors
                                                                      .red,
                                                                  width:
                                                                  1.0, // Thin border width
                                                                ),
                                                                borderRadius:
                                                                BorderRadius
                                                                    .zero, // Squared corners
                                                              ),
                                                              focusedBorder:
                                                              UnderlineInputBorder(
                                                                borderSide:
                                                                BorderSide(
                                                                  color:
                                                                  Colors.blue,
                                                                  width:
                                                                  1.0, // Thin border width
                                                                ),
                                                                borderRadius:
                                                                BorderRadius
                                                                    .zero, // Squared corners
                                                              ),
                                                              enabledBorder:
                                                              UnderlineInputBorder(
                                                                borderSide:
                                                                BorderSide(
                                                                  color:
                                                                  Colors.grey,
                                                                  width:
                                                                  1.0, // Thin border width
                                                                ),
                                                                borderRadius:
                                                                BorderRadius
                                                                    .zero, // Squared corners
                                                              ),
                                                              isDense: true,
                                                              contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                vertical: 8,
                                                                horizontal: 8,
                                                              ),
                                                            ),
                                                            items:
                                                            dropdownItemsBroker,
                                                            onChanged: /*_isEnabled
                                                                  ? (value) {
                                                                      _selectedTypeBroker
                                                                              .value =
                                                                          value ?? '';
                                                                      Future.delayed(
                                                                          const Duration(
                                                                              milliseconds:
                                                                                  100),
                                                                          () {
                                                                        _dueDaysFocus
                                                                            .requestFocus(); // Move focus to the first input field
                                                                      }); // Handle null case
                                                                    }
                                                                  :*/
                                                            null,
                                                          );
                                                        }),
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                                const SizedBox(height: 5),
                                                _buildRow([
                                                  // Row(
                                                  //   children: [
                                                  //     const Text(
                                                  //       'BROKER',
                                                  //       style: TextStyle(
                                                  //         color: Colors.black,
                                                  //         fontWeight:
                                                  //         FontWeight.w900,
                                                  //         fontSize:
                                                  //         12, // Font size for the label
                                                  //       ),
                                                  //     ),
                                                  //     const SizedBox(width: 8),
                                                  //     Expanded(
                                                  //       child: Obx(() {
                                                  //         return DropdownButtonFormField<
                                                  //             String>(
                                                  //           focusNode: _brokerFocus,
                                                  //           style: const TextStyle(
                                                  //               fontSize: 12),
                                                  //           value: _selectedTypeBroker
                                                  //               .value
                                                  //               .toString()
                                                  //               .isEmpty
                                                  //               ? null
                                                  //               : _selectedTypeBroker
                                                  //               .value
                                                  //               .toString(),
                                                  //           decoration:
                                                  //           const InputDecoration(
                                                  //             errorStyle: TextStyle(
                                                  //               height: 0,
                                                  //               // Hides the error message
                                                  //               fontSize:
                                                  //               0, // Ensures no space is taken by the error message
                                                  //             ),
                                                  //             focusedErrorBorder:
                                                  //             UnderlineInputBorder(
                                                  //               borderSide:
                                                  //               BorderSide(
                                                  //                 color: Colors.red,
                                                  //                 width:
                                                  //                 1.0, // Thin border width
                                                  //               ),
                                                  //               borderRadius:
                                                  //               BorderRadius
                                                  //                   .zero, // Squared corners
                                                  //             ),
                                                  //             errorBorder:
                                                  //             UnderlineInputBorder(
                                                  //               borderSide:
                                                  //               BorderSide(
                                                  //                 color: Colors.red,
                                                  //                 width:
                                                  //                 1.0, // Thin border width
                                                  //               ),
                                                  //               borderRadius:
                                                  //               BorderRadius
                                                  //                   .zero, // Squared corners
                                                  //             ),
                                                  //             focusedBorder:
                                                  //             UnderlineInputBorder(
                                                  //               borderSide:
                                                  //               BorderSide(
                                                  //                 color:
                                                  //                 Colors.blue,
                                                  //                 width:
                                                  //                 1.0, // Thin border width
                                                  //               ),
                                                  //               borderRadius:
                                                  //               BorderRadius
                                                  //                   .zero, // Squared corners
                                                  //             ),
                                                  //             enabledBorder:
                                                  //             UnderlineInputBorder(
                                                  //               borderSide:
                                                  //               BorderSide(
                                                  //                 color:
                                                  //                 Colors.grey,
                                                  //                 width:
                                                  //                 1.0, // Thin border width
                                                  //               ),
                                                  //               borderRadius:
                                                  //               BorderRadius
                                                  //                   .zero, // Squared corners
                                                  //             ),
                                                  //             isDense: true,
                                                  //             contentPadding:
                                                  //             EdgeInsets
                                                  //                 .symmetric(
                                                  //               vertical: 8,
                                                  //               horizontal: 8,
                                                  //             ),
                                                  //           ),
                                                  //           items:
                                                  //           dropdownItemsBroker,
                                                  //           onChanged: /*_isEnabled
                                                  //                     ? (value) {
                                                  //                         _selectedTypeBroker
                                                  //                                 .value =
                                                  //                             value ?? '';
                                                  //                         Future.delayed(
                                                  //                             const Duration(
                                                  //                                 milliseconds:
                                                  //                                     100),
                                                  //                             () {
                                                  //                           _dueDaysFocus
                                                  //                               .requestFocus(); // Move focus to the first input field
                                                  //                         }); // Handle null case
                                                  //                       }
                                                  //                     :*/
                                                  //           null,
                                                  //         );
                                                  //       }),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  buildTextField(
                                                      excludeFieldValidation: false,
                                                      'DUE DAYS',
                                                      dueDaysController,
                                                      focusNode: _dueDaysFocus,
                                                      inputFormatterList: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                      onEditingComplete: () {
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds: 100), () {
                                                          _roughFocNode
                                                              .requestFocus(); // Move focus to the first input field
                                                        });
                                                      },
                                                      onChanged: (value) {
                                                        _updateDueDate();
                                                      },
                                                      isEnabled: _isEnabled),
                                                  buildTextField(
                                                    excludeFieldValidation: false,

                                                    'DUE DATE',
                                                    dueDateController,
                                                    isEnabled:
                                                    false, // Disable input since it's auto-filled
                                                  ),
                                                ]),
                                              ],
                                            )),
                                        // const SizedBox(height: 10),
                                        Table(
                                          border:
                                          TableBorder.all(color: Colors.grey),
                                          columnWidths: const {
                                            0: FlexColumnWidth(2),
                                            // ROUGH Type column
                                            1: FlexColumnWidth(3),
                                            // DESCRIPTION column
                                            2: FlexColumnWidth(1),
                                            // WT column
                                            3: FlexColumnWidth(1),
                                            // RATE column
                                            4: FlexColumnWidth(1),
                                            // AMOUNT column
                                            // 5: FlexColumnWidth(
                                            //     0.25), // AMOUNT column
                                          },
                                          children: [
                                            // Header Row
                                            const TableRow(
                                              // decoration: BoxDecoration(
                                              //     color: Colors.grey.shade200),
                                              children: [
                                                TableCell(
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          3.0),
                                                      child: Text('ROUGH',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight
                                                                .w900,
                                                            fontSize:
                                                            12, // Font size for the label
                                                          ),
                                                          textAlign: TextAlign
                                                              .start),
                                                    )),
                                                TableCell(
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          3.0),
                                                      child: Text('DESCRIPTION',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight
                                                                .w900,
                                                            fontSize:
                                                            12, // Font size for the label
                                                          ),
                                                          textAlign: TextAlign
                                                              .start),
                                                    )),
                                                TableCell(
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          3.0),
                                                      child: Text('WT',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight
                                                                .w900,
                                                            fontSize:
                                                            12, // Font size for the label
                                                          ),
                                                          textAlign: TextAlign
                                                              .start),
                                                    )),
                                                TableCell(
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          3.0),
                                                      child: Text('RATE',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight
                                                                .w900,
                                                            fontSize:
                                                            12, // Font size for the label
                                                          ),
                                                          textAlign: TextAlign
                                                              .start),
                                                    )),
                                                TableCell(
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          3.0),
                                                      child: Text('AMT',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight
                                                                .w900,
                                                            fontSize:
                                                            12, // Font size for the label
                                                          ),
                                                          textAlign: TextAlign
                                                              .start),
                                                    )),
                                                // TableCell(
                                                //     child: Padding(
                                                //       padding: EdgeInsets.all(3.0),
                                                //       child: Text('',
                                                //           style: TextStyle(
                                                //             color: Colors.black,
                                                //             fontWeight: FontWeight.w900,
                                                //             fontSize:
                                                //             12, // Font size for the label
                                                //           ),
                                                //           textAlign: TextAlign.start),
                                                //     )),
                                              ],
                                            ),

                                            // Input Row
                                            TableRow(
                                              children: [
                                                TableCell(
                                                  child: Obx(() {
                                                    return DropdownButtonFormField<
                                                        String>(
                                                      focusNode: _roughFocNode,
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                      value: _selectedType
                                                          .value.isEmpty
                                                          ? null
                                                          : _selectedType.value,
                                                      decoration:
                                                      const InputDecoration(
                                                        border: InputBorder
                                                            .none,
                                                        errorStyle: TextStyle(
                                                          height: 0,
                                                          // Hides the error message
                                                          fontSize:
                                                          0, // Ensures no space is taken by the error message
                                                        ),
                                                        isDense: true,
                                                        contentPadding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 8,
                                                          horizontal: 8,
                                                        ),
                                                      ),
                                                      items: dropdownItems,
                                                      onChanged: _isEnabled
                                                          ? (value) {
                                                        _selectedType.value =
                                                            value ?? '';
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                100), () {
                                                          _descFocus
                                                              .requestFocus(); // Move focus to the first input field
                                                        }); // Handle null case
                                                      }
                                                          : null,
                                                    );
                                                  }),
                                                ),
                                                TableCell(
                                                  child: buildTextField2(
                                                      'DESCRIPTION',
                                                      descripController,
                                                      focusNode: _descFocus,
                                                      isEnabled: _isEnabled),
                                                ),
                                                TableCell(
                                                  child: buildTextField2(
                                                      'WT', wtController,
                                                      focusNode: _wtFocus,
                                                      inputFormatterList: [
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                            r'^\d+\.?\d{0,3}')),
                                                      ],
                                                      isEnabled: _isEnabled),
                                                ),
                                                TableCell(
                                                  child: buildTextField2(
                                                      focusNode: _rateFocus,
                                                      'RATE',
                                                      rateController,
                                                      inputFormatterList: [
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                            r'^\d+\.?\d{0,3}')),
                                                      ],
                                                      isEnabled: _isEnabled),
                                                ),
                                                TableCell(
                                                  child: buildTextField2(
                                                      'AMT', amountController,
                                                      isEnabled: false),
                                                ),
                                                // TableCell(
                                                //     child: InkWell(
                                                //       onTap: () {
                                                //         if (_formKey.currentState!
                                                //             .validate()) {
                                                //           addEntry();
                                                //         }
                                                //       },
                                                //       child: const Text(
                                                //         '...',
                                                //         textAlign: TextAlign.center,
                                                //       ),
                                                //     )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: buildBottomButton(
                                      text: 'Add Rough',
                                      width: 100,
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          addEntry();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey)),
                                      // padding: const EdgeInsets.all(8.0),
                                      child: _buildRoughTable()),
                                ),
                                // const SizedBox(height: 16),
                                // RecentFiles(),
                                // if (Responsive.isMobile(context)) const SizedBox(height: 16),
                                // if (Responsive.isMobile(context)) StorageDetails(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    !_isEnabled
                                        ? buildBottomButton(
                                      text: 'Add',
                                      onPressed: _enableFields,
                                    )
                                        : const SizedBox.shrink(),
                                    // const SizedBox(width: 5),
                                    _isFromEdit
                                        ? buildBottomButton(
                                      text: 'Save',
                                      onPressed: () async {
                                        if (entries.isNotEmpty) {
                                          defaultController
                                              .updatePurchaseData(
                                              id: selectedRoughPurMstID
                                                  .value,
                                              partyCode:
                                              _selectedTypeParty
                                                  .value,
                                              invoiceNo:
                                              invNoController.text,
                                              invoiceDate: selectedDate,
                                              brokerCode:
                                              _selectedTypeBroker
                                                  .value,
                                              dueDays:
                                              dueDaysController.text,
                                              dueDate: dueDate,
                                              onlyDueDate:
                                              dueDateController.text,
                                              entries: entries,
                                              totalAmt: totalAmount,
                                              totalWt: totalWt,
                                              totalRate: totalRate)
                                              .then((onValue) {
                                            setState(() {
                                              entries.clear();
                                              _isEnabled = false;
                                              _isFromEdit = false;
                                            });
                                            dateController.clear();
                                            dueDateController.clear();
                                            dueDaysController.clear();
                                            dateController.clear();
                                            invNoController.clear();
                                            _selectedTypeParty.value = '';
                                            _selectedType.value = '';
                                            _selectedTypeBroker.value = '22';
                                          });
                                        } else {
                                          infoDialog(
                                              messageText:
                                              'Please Add Rough Data');
                                        }
                                      },
                                    )
                                        : _isEnabled
                                        ? buildBottomButton(
                                        text: 'Save',
                                        onPressed: () async {
                                          if (entries.isNotEmpty &&
                                              _selectedTypeParty
                                                  .isNotEmpty) {
                                            defaultController
                                                .addPurchaseData(
                                                partyCode:
                                                _selectedTypeParty
                                                    .value,
                                                invoiceNo:
                                                invNoController
                                                    .text,
                                                invoiceDate:
                                                selectedDate,
                                                brokerCode:
                                                _selectedTypeBroker
                                                    .value,
                                                dueDays:
                                                dueDaysController
                                                    .text,
                                                dueDate: dueDate,
                                                onlyDueDate:
                                                dueDateController
                                                    .text,
                                                entries: entries,
                                                totalRate: totalRate,
                                                totalAmt: totalAmount,
                                                totalWt: totalWt)
                                                .then((onValue) {
                                              setState(() {
                                                entries.clear();
                                                _isEnabled = false;
                                              });
                                            });

                                            dateController.clear();
                                            dueDateController.clear();
                                            dueDaysController.clear();
                                            dateController.clear();
                                            invNoController.clear();
                                            _selectedTypeParty.value = '';
                                            _selectedType.value = '';
                                            _selectedTypeBroker.value =
                                            '22';
                                          } else {
                                            if (_selectedTypeParty
                                                .isNotEmpty) {
                                              infoDialog(
                                                  messageText:
                                                  'Please Add Rough Data');
                                            } else {
                                              infoDialog(
                                                  messageText:
                                                  'Please Select Party');
                                            }
                                          }
                                        })
                                        : const SizedBox.shrink(),
                                    // const SizedBox(width: 5),
                                    _isFromEdit
                                        ? buildBottomButton(
                                      text: 'Delete',
                                      onPressed: () {
                                        defaultController
                                            .deletePurchaseData(
                                            id: selectedRoughPurMstID
                                                .value,
                                            entries: entries)
                                            .then((onValue) {
                                          dateController.clear();
                                          dueDateController.clear();
                                          dueDaysController.clear();
                                          dateController.clear();
                                          invNoController.clear();
                                          _selectedTypeParty.value = '';
                                          _selectedType.value = '';
                                          _selectedTypeBroker.value = '22';
                                          setState(() {
                                            _isFromEdit = false;
                                            entries.length = 0;
                                          });
                                        });
                                      },
                                    )
                                        : const SizedBox.shrink(),
                                    // const SizedBox(width: 5),
                                    _isEnabled
                                        ? buildBottomButton(
                                      text: 'Cancel',
                                      onPressed: () {
                                        dateController.clear();
                                        invNoController.clear();
                                        dueDateController.clear();
                                        dueDaysController.clear();
                                        dateController.clear();
                                        _selectedTypeParty.value = '';
                                        _selectedType.value = '';
                                        _selectedTypeBroker.value = '22';
                                        setState(() {
                                          entries.length = 0;
                                          _isFromEdit = false;
                                          _isEnabled = false;
                                        });
                                      },
                                    )
                                        : const SizedBox.shrink(),
                                    // const SizedBox(width: 5),
                                    buildBottomButton(
                                      text: 'Exit',
                                      onPressed: () {
                                        // menuController.selectedIndex.value = 0;
                                        tabController.removeTab(
                                            tabController.currentIndex.value);
                                      },
                                    ),
                                    // const SizedBox(width: 5),
                                    buildBottomButton(
                                      text: 'Search',
                                      onPressed: () {
                                        setState(() {
                                          _isSearch = true;
                                        });
                                      },
                                    ),
                                    // const SizedBox(width: 5),
                                    _isFromEdit
                                        ? buildBottomButton(
                                      text: 'Print',
                                      onPressed: () async {
                                        final invoiceGenerator =
                                        PurchaseInvoiceGenerator();
                                        final pdfData = await invoiceGenerator
                                            .generateInvoice(
                                            id: defaultController
                                                .purchaseDataList
                                                .length +
                                                1,
                                            invoiceDate: selectedDate!,
                                            invoiceNo:
                                            invNoController.text,
                                            partyCode:
                                            _selectedTypeParty.value,
                                            brokerCode:
                                            _selectedTypeBroker.value,
                                            dueDate:
                                            dueDateController.text,
                                            dueDays:
                                            dueDaysController.text,
                                            entries: entries,
                                            totalWt: totalWt,
                                            totalAmt: totalAmount,
                                            totalRate: totalRate);
                                        await Printing.layoutPdf(
                                          onLayout:
                                              (PdfPageFormat format) async =>
                                          pdfData,
                                        );
                                        if (!kDebugMode) {
                                          await Printing.sharePdf(
                                            bytes: pdfData,
                                            filename:
                                            '${invNoController
                                                .text}.pdf', // Set the custom name here
                                          );
                                        }
                                      },
                                    )
                                        : const SizedBox.shrink(),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  defaultController.isLoading.value
                      ? Container(
                    color: Colors.black54,
                    child: Center(
                      child: Container(
                        width: 150,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CupertinoActivityIndicator(),
                            SizedBox(width: 10),
                            Text(
                              'Loading...',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                      : const SizedBox.shrink(),
                ],
              ),
        ),
      ),
      desktop: _isSearch == true
          ? KeyboardListener(
        focusNode: _searchKeyBoardFocus,
        autofocus: true,
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent) {
            final int currentIndex = _dataGridController.selectedIndex;
            final int totalRows = defaultController.purchaseDataList
                .length; // Use the length of your data source (MemoIssueDetailsDataGridSource)

            // Handle the Enter key
            if (event.logicalKey == LogicalKeyboardKey.enter) {
              final DataGridRow? selectedRow =
                  _dataGridController.selectedRow;
              setState(() {
                entries.length = 0;
                _isFromEdit = true;
              });
              List<RoughDetailsModel> roughData =
                  defaultController.roughDetailsModel;
              List<PurchaseDetailsModel> partyData =
                  defaultController.purchaseDataList;

              // Extract the selected polishSaleMstID from the selectedRow
              selectedRoughPurMstID.value = selectedRow!
                  .getCells()[0]
                  .value; // Assuming the ID is in the first cell

              // Find the corresponding party data entry with the matching polishSaleMstID
              PurchaseDetailsModel partyEntry = partyData.firstWhere(
                    (entry) =>
                entry.roughPurMstID == selectedRoughPurMstID.value,
                // orElse: () => null,
              );

              // Collect rough data entries with the matching polishSaleMstID
              List<RoughDetailsModel> roughEntries = roughData
                  .where((entry) =>
              entry.roughPurMstID == selectedRoughPurMstID.value)
                  .toList();

              // if (kDebugMode) {
              //   print(
              //       "ROUGH ID:  ${roughEntries.first.roughPurMstID}  ${roughEntries.first.roughPurDetID}");
              //   print(
              //       "ROUGH ID:  ${roughEntries.last.roughPurMstID} ${roughEntries.last.roughPurDetID}");
              // }
              invNoController.text = partyEntry.invoiceNo!;
              selectedDate = dateFormat(partyEntry.invoiceDate!);
              dueDate = formatDateWithTime(partyEntry.dueDate!);
              dateController.text = formatDate(partyEntry.invoiceDate!);
              dueDateController.text = formatDate(partyEntry.dueDate!);
              dueDaysController.text = partyEntry.dueDay.toString();
              _selectedTypeParty.value = partyEntry.partyCode.toString();
              _selectedTypeBroker.value =
                  partyEntry.brokerCode.toString();
              // _selectedTypeParty.value = partyEntry.partyCode;
              setState(() {
                for (var roughEntry in roughEntries) {
                  entries.add({
                    'id': roughEntry.roughPurDetID.toString(),
                    'rough': roughEntry.roughTypeCode.toString(),
                    'description': roughEntry.description.toString(),
                    'wt': roughEntry.wt.toString(),
                    'rate': roughEntry.rateRs.toString(),
                    'amount': (double.parse(roughEntry.wt.toString()) *
                        double.parse(roughEntry.rateRs.toString()))
                        .toStringAsFixed(2),
                  });
                }
              });

              _enableFields();
              setState(() {
                _isSearch = false;
              });
            }

            // Handle the down arrow key to go to the next row
            if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
              if (currentIndex < totalRows - 1) {
                _dataGridController.selectedIndex =
                    currentIndex + 1; // Select the next row
                _scrollToSelectedRow(double.parse(_dataGridController
                    .selectedIndex
                    .toString())); // Scroll to the selected row
              }
            }

            // Handle the up arrow key to go to the previous row
            if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              if (currentIndex > 0) {
                _dataGridController.selectedIndex =
                    currentIndex - 1; // Select the previous row
                _scrollToSelectedRow(double.parse(_dataGridController
                    .selectedIndex
                    .toString())); // Scroll to the selected row
              }
            }

            if (event.logicalKey == LogicalKeyboardKey.keyE) {
              setState(() {
                _isSearch = false;
              });
            }
            if (event.logicalKey == LogicalKeyboardKey.keyR &&
                _isFiltered.value) {
              _removeDateFilter();
            }
            if (event.logicalKey == LogicalKeyboardKey.keyF) {
              _applyDateFilter();
            }
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.showHeader
                ? const Header(title: 'Purchase Search')
                : const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: buildTextField(
                      'From Date',
                      excludeFieldValidation: false,
                      fromDateController,
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            fromDate = pickedDate;
                            fromDateController.text =
                                DateFormat('dd-MM-yyyy')
                                    .format(fromDate!);
                            if (toDateController.text.isNotEmpty) {
                              _applyDateFilter();
                            }
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: buildTextField(
                      'To Date',
                      excludeFieldValidation: false,
                      toDateController,
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            toDate = pickedDate;
                            toDateController.text =
                                DateFormat('dd-MM-yyyy').format(toDate!);
                            if (fromDateController.text.isNotEmpty) {
                              _applyDateFilter();
                            }
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: _applyDateFilter,
                    // Method to filter data based on date
                    child: const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'F', // Underlined "A"
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(
                            text: 'ilter', // Normal "dd"
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Obx(() =>
                      OutlinedButton(
                        onPressed:
                        _isFiltered.value ? _removeDateFilter : null,
                        // Method to filter data based on date
                        child: const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'R', // Underlined "A"
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(
                                text: 'eset', // Normal "dd"
                              ),
                            ],
                          ),
                        ),
                      )),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _isSearch = false;
                      });
                    },
                    child: const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'E', // Underlined "A"
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(
                            text: 'xit', // Normal "dd"
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(
                      () =>
                      SfDataGrid(
                        controller: _dataGridController,
                        source:
                        PurchaseDataGridSource(purchaseDataGridSource),
                        columns: <GridColumn>[
                          GridColumn(
                            columnName: 'ID',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'ID',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Invoice No',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Invoice No',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Invoice Date',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Invoice Date',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Party',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Party',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Broker',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Broker',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Tot Wt',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Tot Wt',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Tot Amt Rs',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Tot Amt Rs',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                        tableSummaryRows: [
                          GridTableSummaryRow(
                              title: 'Total ${purchaseDataGridSource.length}',
                              showSummaryInRow: false,
                              titleColumnSpan: 1,
                              columns: <GridSummaryColumn>[
                                const GridSummaryColumn(
                                    name: 'Tot Wt',
                                    columnName: 'Tot Wt',
                                    summaryType: GridSummaryType.sum),
                                const GridSummaryColumn(
                                    name: 'Tot Amt Rs',
                                    columnName: 'Tot Amt Rs',
                                    summaryType: GridSummaryType.sum),
                              ],
                              position: GridTableSummaryRowPosition.bottom)
                        ],
                        rowHeight: 25,
                        headerRowHeight: 35,
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        showSortNumbers: true,
                        // allowSorting: true,
                        // allowMultiColumnSorting: true,
                        allowFiltering: true,
                        selectionMode: SelectionMode.single,
                        // onSelectionChanged: (List<DataGridRow> selectedRows) {
                        //   // Handle row selection change if needed
                        // },
                        onSelectionChanged: (List<DataGridRow> addedRows,
                            List<DataGridRow> removedRows) {
                          setState(() {
                            entries.length = 0;
                            _isFromEdit = true;
                          });
                          if (addedRows.isNotEmpty) {
                            final DataGridRow selectedRow = addedRows.first;
                            List<RoughDetailsModel> roughData =
                                defaultController.roughDetailsModel;
                            List<PurchaseDetailsModel> partyData =
                                defaultController.purchaseDataList;

                            // Extract the selected polishSaleMstID from the selectedRow
                            selectedRoughPurMstID.value = selectedRow
                                .getCells()[0]
                                .value; // Assuming the ID is in the first cell

                            // Find the corresponding party data entry with the matching polishSaleMstID
                            PurchaseDetailsModel partyEntry =
                            partyData.firstWhere(
                                  (entry) =>
                              entry.roughPurMstID ==
                                  selectedRoughPurMstID.value,
                              // orElse: () => null,
                            );

                            // Collect rough data entries with the matching polishSaleMstID
                            List<RoughDetailsModel> roughEntries = roughData
                                .where((entry) =>
                            entry.roughPurMstID ==
                                selectedRoughPurMstID.value)
                                .toList();

                            // if (kDebugMode) {
                            //   print(
                            //       "ROUGH ID:  ${roughEntries.first.roughPurMstID}  ${roughEntries.first.roughPurDetID}");
                            //   print(
                            //       "ROUGH ID:  ${roughEntries.last.roughPurMstID} ${roughEntries.last.roughPurDetID}");
                            // }
                            invNoController.text = partyEntry.invoiceNo!;
                            selectedDate =
                                dateFormat(partyEntry.invoiceDate!);
                            dueDate = formatDateWithTime(partyEntry.dueDate!);
                            dateController.text =
                                formatDate(partyEntry.invoiceDate!);
                            dueDateController.text =
                                formatDate(partyEntry.dueDate!);
                            dueDaysController.text =
                                partyEntry.dueDay.toString();
                            _selectedTypeParty.value =
                                partyEntry.partyCode.toString();
                            _selectedTypeBroker.value = _selectedTypeBroker
                                .value = partyEntry.brokerCode.toString();
                            // _selectedTypeParty.value = partyEntry.partyCode;
                            setState(() {
                              for (var roughEntry in roughEntries) {
                                entries.add({
                                  'id': roughEntry.roughPurDetID.toString(),
                                  'rough':
                                  roughEntry.roughTypeCode.toString(),
                                  'description':
                                  roughEntry.description.toString(),
                                  'wt': roughEntry.wt!.toStringAsFixed(2),
                                  'rate':
                                  roughEntry.rateRs!.toStringAsFixed(2),
                                  'amount': (double.parse(
                                      roughEntry.wt.toString()) *
                                      double.parse(
                                          roughEntry.rateRs.toString()))
                                      .toStringAsFixed(2),
                                });
                              }
                            });

                            _enableFields();
                            setState(() {
                              _isSearch = false;
                            });
                          }
                        },
                        columnWidthMode: ColumnWidthMode.auto,
                        frozenColumnsCount: 1,
                        // gridLineStrokeWidth: 1.5,
                        // gridLineColor: Colors.grey.shade400,
                        // backgroundColor: Colors.white,
                      ),
                ),
              ),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.showHeader
                ? const Header(title: 'Purchase')
                : const SizedBox.shrink(),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: KeyboardListener(
                          focusNode: _formKeyBoardFocus,
                          autofocus: true,
                          onKeyEvent: (KeyEvent event) {
                            if (event is KeyDownEvent) {
                              if (!_descFocus.hasFocus &&
                                  !_dueDaysFocus.hasFocus &&
                                  !_invoiceFocus.hasFocus) {
                                if (!HardwareKeyboard
                                    .instance.isShiftPressed &&
                                    event.logicalKey ==
                                        LogicalKeyboardKey.keyS &&
                                    _isEnabled) {
                                  if (_isFromEdit) {
                                    if (entries.isNotEmpty) {
                                      defaultController
                                          .updatePurchaseData(
                                          id: selectedRoughPurMstID
                                              .value,
                                          partyCode:
                                          _selectedTypeParty
                                              .value,
                                          invoiceNo:
                                          invNoController.text,
                                          invoiceDate: selectedDate,
                                          brokerCode:
                                          _selectedTypeBroker
                                              .value,
                                          dueDays:
                                          dueDaysController.text,
                                          dueDate: dueDate,
                                          onlyDueDate:
                                          dueDateController.text,
                                          entries: entries,
                                          totalAmt: totalAmount,
                                          totalWt: totalWt,
                                          totalRate: totalRate)
                                          .then((onValue) {
                                        setState(() {
                                          entries.clear();
                                          _isEnabled = false;
                                          _isFromEdit = false;
                                        });
                                      });

                                      dateController.clear();
                                      dueDateController.clear();
                                      dueDaysController.clear();
                                      dateController.clear();
                                      invNoController.clear();
                                      _selectedTypeParty.value = '';
                                      _selectedType.value = '';
                                      _selectedTypeBroker.value = '22';
                                    } else {
                                      infoDialog(
                                          messageText:
                                          'Please Add Rough Data');
                                    }
                                  } else {
                                    if (entries.isNotEmpty) {
                                      defaultController
                                          .addPurchaseData(
                                          partyCode:
                                          _selectedTypeParty
                                              .value,
                                          invoiceNo:
                                          invNoController.text,
                                          invoiceDate: selectedDate,
                                          brokerCode:
                                          _selectedTypeBroker
                                              .value,
                                          dueDays:
                                          dueDaysController.text,
                                          dueDate: dueDate,
                                          onlyDueDate:
                                          dueDateController.text,
                                          entries: entries,
                                          totalRate: totalRate,
                                          totalAmt: totalAmount,
                                          totalWt: totalWt)
                                          .then((onValue) {
                                        setState(() {
                                          entries.clear();
                                          _isEnabled = false;
                                        });
                                      });

                                      dateController.clear();
                                      dueDateController.clear();
                                      dueDaysController.clear();
                                      dateController.clear();
                                      invNoController.clear();
                                      _selectedTypeParty.value = '';
                                      _selectedType.value = '';
                                      _selectedTypeBroker.value = '22';
                                    } else {
                                      infoDialog(
                                          messageText:
                                          'Please Add Rough Data');
                                    }
                                  }
                                }
                              }
                              if (!_descFocus.hasFocus &&
                                  !_dueDaysFocus.hasFocus &&
                                  !_invoiceFocus.hasFocus) {
                                if (event.logicalKey ==
                                    LogicalKeyboardKey.keyA &&
                                    !_isEnabled) {
                                  _enableFields();
                                }
                              }
                              if (!_descFocus.hasFocus &&
                                  !_dueDaysFocus.hasFocus &&
                                  !_invoiceFocus.hasFocus) {
                                if (event.logicalKey ==
                                    LogicalKeyboardKey.keyD &&
                                    _isEnabled &&
                                    _isFromEdit) {
                                  if (_isFromEdit) {
                                    defaultController
                                        .deletePurchaseData(
                                        id: selectedRoughPurMstID
                                            .value,
                                        entries: entries)
                                        .then((onValue) {
                                      dateController.clear();
                                      dueDateController.clear();
                                      dueDaysController.clear();
                                      dateController.clear();
                                      invNoController.clear();
                                      _selectedTypeParty.value = '';
                                      _selectedType.value = '';
                                      _selectedTypeBroker.value = '22';
                                      setState(() {
                                        _isFromEdit = false;
                                        entries.length = 0;
                                      });
                                    });
                                  } else {
                                    infoDialog(
                                        messageText:
                                        'Please Select Purchase Entry to Delete.');
                                  }
                                }
                              }
                              if (!_descFocus.hasFocus &&
                                  !_dueDaysFocus.hasFocus &&
                                  !_invoiceFocus.hasFocus) {
                                if (event.logicalKey ==
                                    LogicalKeyboardKey.keyC &&
                                    _isEnabled) {
                                  dateController.clear();
                                  invNoController.clear();
                                  dueDateController.clear();
                                  dueDaysController.clear();
                                  dateController.clear();
                                  _selectedTypeParty.value = '';
                                  _selectedType.value = '';
                                  _selectedTypeBroker.value = '22';
                                  setState(() {
                                    entries.length = 0;
                                    _isFromEdit = false;
                                    _isEnabled = false;
                                  });
                                }
                              }
                              if (!_descFocus.hasFocus &&
                                  !_dueDaysFocus.hasFocus &&
                                  !_invoiceFocus.hasFocus) {
                                if (event.logicalKey ==
                                    LogicalKeyboardKey.keyE) {
                                  // menuController.selectedIndex.value = 0;
                                  tabController.removeTab(
                                      tabController.currentIndex.value);
                                }
                              }
                              if (!_descFocus.hasFocus &&
                                  !_dueDaysFocus.hasFocus &&
                                  !_invoiceFocus.hasFocus) {
                                if (HardwareKeyboard
                                    .instance.isShiftPressed &&
                                    event.logicalKey ==
                                        LogicalKeyboardKey.keyS) {
                                  setState(() {
                                    _isSearch = true;
                                  });
                                }
                              }
                            }
                          },
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                            color: Colors.grey),
                                        left: BorderSide(
                                            color: Colors.grey),
                                        right: BorderSide(
                                            color: Colors.grey),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        _buildRow([
                                          Row(
                                            children: [
                                              const Text(
                                                'PARTY',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight:
                                                  FontWeight.w900,
                                                  fontSize:
                                                  12, // Font size for the label
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Obx(() {
                                                  return DropdownButtonFormField<
                                                      String>(
                                                    focusNode:
                                                    _partyFocNode,
                                                    style:
                                                    const TextStyle(
                                                        fontSize: 12),
                                                    value: _selectedTypeParty
                                                        .value.isEmpty
                                                        ? null
                                                        : _selectedTypeParty
                                                        .value,
                                                    decoration:
                                                    const InputDecoration(
                                                      errorStyle:
                                                      TextStyle(
                                                        height: 0,
                                                        // Hides the error message
                                                        fontSize:
                                                        0, // Ensures no space is taken by the error message
                                                      ),
                                                      focusedErrorBorder:
                                                      UnderlineInputBorder(
                                                        borderSide:
                                                        BorderSide(
                                                          color:
                                                          Colors.red,
                                                          width:
                                                          1.0, // Thin border width
                                                        ),
                                                        borderRadius:
                                                        BorderRadius
                                                            .zero, // Squared corners
                                                      ),
                                                      errorBorder:
                                                      UnderlineInputBorder(
                                                        borderSide:
                                                        BorderSide(
                                                          color:
                                                          Colors.red,
                                                          width:
                                                          1.0, // Thin border width
                                                        ),
                                                        borderRadius:
                                                        BorderRadius
                                                            .zero, // Squared corners
                                                      ),
                                                      focusedBorder:
                                                      UnderlineInputBorder(
                                                        borderSide:
                                                        BorderSide(
                                                          color:
                                                          Colors.blue,
                                                          width:
                                                          1.0, // Thin border width
                                                        ),
                                                        borderRadius:
                                                        BorderRadius
                                                            .zero, // Squared corners
                                                      ),
                                                      enabledBorder:
                                                      UnderlineInputBorder(
                                                        borderSide:
                                                        BorderSide(
                                                          color:
                                                          Colors.grey,
                                                          width:
                                                          1.0, // Thin border width
                                                        ),
                                                        borderRadius:
                                                        BorderRadius
                                                            .zero, // Squared corners
                                                      ),
                                                      isDense: true,
                                                      contentPadding:
                                                      EdgeInsets
                                                          .symmetric(
                                                        vertical: 8,
                                                        horizontal: 8,
                                                      ),
                                                    ),
                                                    items:
                                                    dropdownItemsParty,
                                                    onChanged: _isEnabled
                                                        ? (value) {
                                                      _selectedTypeParty
                                                          .value =
                                                          value ??
                                                              '';
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                              100),
                                                              () {
                                                            _dateFocus
                                                                .requestFocus(); // Move focus to the first input field
                                                          }); // Handle null case
                                                    }
                                                        : null,
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                          buildTextField(
                                              'INVOICE NO.',
                                              excludeFieldValidation:
                                              true,
                                              invNoController,
                                              isEnabled: false,
                                              focusNode: _invoiceFocus,
                                              onEditingComplete: () {
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 100),
                                                        () {
                                                      _dateFocus
                                                          .requestFocus(); // Move focus to the first input field
                                                    });
                                              },
                                              onChanged: (value) {}),
                                          Focus(
                                            onKeyEvent: (node, event) {
                                              if (HardwareKeyboard
                                                  .instance
                                                  .isLogicalKeyPressed(
                                                  LogicalKeyboardKey
                                                      .enter)) {
                                                _openDatePicker(); // Open date picker when Enter key is pressed
                                                return KeyEventResult
                                                    .handled;
                                              }
                                              return KeyEventResult
                                                  .ignored;
                                            },
                                            child: buildTextField(
                                              excludeFieldValidation:
                                              false,
                                              'DATE',
                                              dateController,
                                              isEnabled: _isEnabled,
                                              focusNode: _dateFocus,
                                              onTap: () {
                                                _openDatePicker();
                                              },
                                            ),
                                          ),

                                          // _buildTextField('PURID', 'AUTO', purIdController),
                                        ]),
                                        const SizedBox(height: 10),
                                        _buildRow([
                                          Row(
                                            children: [
                                              const Text(
                                                'BROKER',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight:
                                                  FontWeight.w900,
                                                  fontSize:
                                                  12, // Font size for the label
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Obx(() {
                                                  return DropdownButtonFormField<
                                                      String>(
                                                    focusNode:
                                                    _brokerFocus,
                                                    style:
                                                    const TextStyle(
                                                        fontSize: 12),
                                                    value: _selectedTypeBroker
                                                        .value
                                                        .toString()
                                                        .isEmpty
                                                        ? null
                                                        : _selectedTypeBroker
                                                        .value
                                                        .toString(),
                                                    decoration:
                                                    const InputDecoration(
                                                      errorStyle:
                                                      TextStyle(
                                                        height: 0,
                                                        // Hides the error message
                                                        fontSize:
                                                        0, // Ensures no space is taken by the error message
                                                      ),
                                                      focusedErrorBorder:
                                                      UnderlineInputBorder(
                                                        borderSide:
                                                        BorderSide(
                                                          color:
                                                          Colors.red,
                                                          width:
                                                          1.0, // Thin border width
                                                        ),
                                                        borderRadius:
                                                        BorderRadius
                                                            .zero, // Squared corners
                                                      ),
                                                      errorBorder:
                                                      UnderlineInputBorder(
                                                        borderSide:
                                                        BorderSide(
                                                          color:
                                                          Colors.red,
                                                          width:
                                                          1.0, // Thin border width
                                                        ),
                                                        borderRadius:
                                                        BorderRadius
                                                            .zero, // Squared corners
                                                      ),
                                                      focusedBorder:
                                                      UnderlineInputBorder(
                                                        borderSide:
                                                        BorderSide(
                                                          color:
                                                          Colors.blue,
                                                          width:
                                                          1.0, // Thin border width
                                                        ),
                                                        borderRadius:
                                                        BorderRadius
                                                            .zero, // Squared corners
                                                      ),
                                                      enabledBorder:
                                                      UnderlineInputBorder(
                                                        borderSide:
                                                        BorderSide(
                                                          color:
                                                          Colors.grey,
                                                          width:
                                                          1.0, // Thin border width
                                                        ),
                                                        borderRadius:
                                                        BorderRadius
                                                            .zero, // Squared corners
                                                      ),
                                                      isDense: true,
                                                      contentPadding:
                                                      EdgeInsets
                                                          .symmetric(
                                                        vertical: 8,
                                                        horizontal: 8,
                                                      ),
                                                    ),
                                                    items:
                                                    dropdownItemsBroker,
                                                    onChanged: /*_isEnabled
                                                              ? (value) {
                                                                  _selectedTypeBroker
                                                                          .value =
                                                                      value ?? '';
                                                                  Future.delayed(
                                                                      const Duration(
                                                                          milliseconds:
                                                                              100),
                                                                      () {
                                                                    _dueDaysFocus
                                                                        .requestFocus(); // Move focus to the first input field
                                                                  }); // Handle null case
                                                                }
                                                              :*/
                                                    null,
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                          buildTextField(
                                              excludeFieldValidation:
                                              false,
                                              'DUE DAYS',
                                              dueDaysController,
                                              focusNode: _dueDaysFocus,
                                              inputFormatterList: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              onEditingComplete: () {
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 100),
                                                        () {
                                                      _roughFocNode
                                                          .requestFocus(); // Move focus to the first input field
                                                    });
                                              },
                                              onChanged: (value) {
                                                _updateDueDate();
                                              },
                                              isEnabled: _isEnabled),
                                          buildTextField(
                                            excludeFieldValidation: false,

                                            'DUE DATE',
                                            dueDateController,
                                            isEnabled:
                                            false, // Disable input since it's auto-filled
                                          ),
                                        ]),
                                      ],
                                    )),
                                // const SizedBox(height: 10),
                                Table(
                                  border:
                                  TableBorder.all(color: Colors.grey),
                                  columnWidths: const {
                                    0: FlexColumnWidth(
                                        1), // ROUGH Type column
                                    1: FlexColumnWidth(
                                        3), // DESCRIPTION column
                                    2: FlexColumnWidth(1), // WT column
                                    3: FlexColumnWidth(1), // RATE column
                                    4: FlexColumnWidth(
                                        1), // AMOUNT column
                                    5: FlexColumnWidth(
                                        0.25), // AMOUNT column
                                  },
                                  children: [
                                    // Header Row
                                    const TableRow(
                                      // decoration: BoxDecoration(
                                      //     color: Colors.grey.shade200),
                                      children: [
                                        TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(3.0),
                                              child: Text('ROUGH',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w900,
                                                    fontSize:
                                                    12, // Font size for the label
                                                  ),
                                                  textAlign: TextAlign.start),
                                            )),
                                        TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(3.0),
                                              child: Text('DESCRIPTION',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w900,
                                                    fontSize:
                                                    12, // Font size for the label
                                                  ),
                                                  textAlign: TextAlign.start),
                                            )),
                                        TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(3.0),
                                              child: Text('WT',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w900,
                                                    fontSize:
                                                    12, // Font size for the label
                                                  ),
                                                  textAlign: TextAlign.start),
                                            )),
                                        TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(3.0),
                                              child: Text('RATE',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w900,
                                                    fontSize:
                                                    12, // Font size for the label
                                                  ),
                                                  textAlign: TextAlign.start),
                                            )),
                                        TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(3.0),
                                              child: Text('AMOUNT',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w900,
                                                    fontSize:
                                                    12, // Font size for the label
                                                  ),
                                                  textAlign: TextAlign.start),
                                            )),
                                        TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(3.0),
                                              child: Text('',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w900,
                                                    fontSize:
                                                    12, // Font size for the label
                                                  ),
                                                  textAlign: TextAlign.start),
                                            )),
                                      ],
                                    ),

                                    // Input Row
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Obx(() {
                                            return DropdownButtonFormField<
                                                String>(
                                              focusNode: _roughFocNode,
                                              style: const TextStyle(
                                                  fontSize: 12),
                                              value: _selectedType
                                                  .value.isEmpty
                                                  ? null
                                                  : _selectedType.value,
                                              decoration:
                                              const InputDecoration(
                                                border: InputBorder.none,
                                                errorStyle: TextStyle(
                                                  height: 0,
                                                  // Hides the error message
                                                  fontSize:
                                                  0, // Ensures no space is taken by the error message
                                                ),
                                                isDense: true,
                                                contentPadding:
                                                EdgeInsets.symmetric(
                                                  vertical: 8,
                                                  horizontal: 8,
                                                ),
                                              ),
                                              items: dropdownItems,
                                              onChanged: _isEnabled
                                                  ? (value) {
                                                _selectedType
                                                    .value =
                                                    value ?? '';
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds:
                                                        100),
                                                        () {
                                                      _descFocus
                                                          .requestFocus(); // Move focus to the first input field
                                                    }); // Handle null case
                                              }
                                                  : null,
                                            );
                                          }),
                                        ),
                                        TableCell(
                                          child: buildTextField2(
                                              'DESCRIPTION',
                                              descripController,
                                              focusNode: _descFocus,
                                              isEnabled: _isEnabled),
                                        ),
                                        TableCell(
                                          child: buildTextField2(
                                              'WT', wtController,
                                              focusNode: _wtFocus,
                                              inputFormatterList: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(
                                                    r'^\d+\.?\d{0,3}')),
                                              ],
                                              isEnabled: _isEnabled),
                                        ),
                                        TableCell(
                                          child: buildTextField2(
                                              focusNode: _rateFocus,
                                              'RATE',
                                              rateController,
                                              inputFormatterList: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(
                                                    r'^\d+\.?\d{0,3}')),
                                              ],
                                              isEnabled: _isEnabled),
                                        ),
                                        TableCell(
                                          child: buildTextField2(
                                              'AMOUNT', amountController,
                                              isEnabled: false),
                                        ),
                                        TableCell(
                                            child: InkWell(
                                              onTap: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  addEntry();
                                                }
                                              },
                                              child: const Text(
                                                '...',
                                                textAlign: TextAlign.center,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)),
                            // padding: const EdgeInsets.all(8.0),
                            child: _buildRoughTable()),
                      ),
                      // const SizedBox(height: 16),
                      // RecentFiles(),
                      // if (Responsive.isMobile(context)) const SizedBox(height: 16),
                      // if (Responsive.isMobile(context)) StorageDetails(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            // onPressed: _enableFields,
                            onPressed: !_isEnabled ? _enableFields : null,
                            child: const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'A', // Underlined "A"
                                    style: TextStyle(
                                      decoration:
                                      TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'dd', // Normal "dd"
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: _isFromEdit
                                ? () async {
                              if (entries.isNotEmpty) {
                                defaultController
                                    .updatePurchaseData(
                                    id: selectedRoughPurMstID
                                        .value,
                                    partyCode:
                                    _selectedTypeParty
                                        .value,
                                    invoiceNo:
                                    invNoController.text,
                                    invoiceDate: selectedDate,
                                    brokerCode:
                                    _selectedTypeBroker
                                        .value,
                                    dueDays:
                                    dueDaysController.text,
                                    dueDate: dueDate,
                                    onlyDueDate:
                                    dueDateController.text,
                                    entries: entries,
                                    totalAmt: totalAmount,
                                    totalWt: totalWt,
                                    totalRate: totalRate)
                                    .then((onValue) {
                                  setState(() {
                                    entries.clear();
                                    _isEnabled = false;
                                    _isFromEdit = false;
                                  });
                                  dateController.clear();
                                  dueDateController.clear();
                                  dueDaysController.clear();
                                  dateController.clear();
                                  invNoController.clear();
                                  _selectedTypeParty.value = '';
                                  _selectedType.value = '';
                                  _selectedTypeBroker.value = '22';
                                });
                              } else {
                                infoDialog(
                                    messageText:
                                    'Please Add Rough Data');
                              }
                            }
                                : _isEnabled
                                ? () async {
                              if (entries.isNotEmpty &&
                                  _selectedTypeParty
                                      .isNotEmpty) {
                                defaultController
                                    .addPurchaseData(
                                    partyCode:
                                    _selectedTypeParty
                                        .value,
                                    invoiceNo:
                                    invNoController
                                        .text,
                                    invoiceDate:
                                    selectedDate,
                                    brokerCode:
                                    _selectedTypeBroker
                                        .value,
                                    dueDays:
                                    dueDaysController
                                        .text,
                                    dueDate: dueDate,
                                    onlyDueDate:
                                    dueDateController
                                        .text,
                                    entries: entries,
                                    totalRate: totalRate,
                                    totalAmt: totalAmount,
                                    totalWt: totalWt)
                                    .then((onValue) {
                                  setState(() {
                                    entries.clear();
                                    _isEnabled = false;
                                  });
                                });

                                dateController.clear();
                                dueDateController.clear();
                                dueDaysController.clear();
                                dateController.clear();
                                invNoController.clear();
                                _selectedTypeParty.value = '';
                                _selectedType.value = '';
                                _selectedTypeBroker.value =
                                '22';
                              } else {
                                if (_selectedTypeParty
                                    .isNotEmpty) {
                                  infoDialog(
                                      messageText:
                                      'Please Add Rough Data');
                                } else {
                                  infoDialog(
                                      messageText:
                                      'Please Select Party');
                                }
                              }
                            }
                                : null,
                            child: Obx(
                                  () =>
                              defaultController.isLoading.value
                                  ? const CupertinoActivityIndicator()
                                  : const Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'S', // Underlined "A"
                                      style: TextStyle(
                                        decoration: TextDecoration
                                            .underline,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'ave', // Normal "dd"
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: _isFromEdit
                                ? () {
                              defaultController
                                  .deletePurchaseData(
                                  id: selectedRoughPurMstID
                                      .value,
                                  entries: entries)
                                  .then((onValue) {
                                dateController.clear();
                                dueDateController.clear();
                                dueDaysController.clear();
                                dateController.clear();
                                invNoController.clear();
                                _selectedTypeParty.value = '';
                                _selectedType.value = '';
                                _selectedTypeBroker.value = '22';
                                setState(() {
                                  _isFromEdit = false;
                                  entries.length = 0;
                                });
                              });
                            }
                                : null,
                            child: Obx(
                                  () =>
                              defaultController
                                  .isDeleteLoading.value
                                  ? const CupertinoActivityIndicator()
                                  : const Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'D', // Underlined "A"
                                      style: TextStyle(
                                        decoration: TextDecoration
                                            .underline,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'elete', // Normal "dd"
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: _isEnabled
                                ? () {
                              dateController.clear();
                              invNoController.clear();
                              dueDateController.clear();
                              dueDaysController.clear();
                              dateController.clear();
                              _selectedTypeParty.value = '';
                              _selectedType.value = '';
                              _selectedTypeBroker.value = '22';
                              setState(() {
                                entries.length = 0;
                                _isFromEdit = false;
                                _isEnabled = false;
                              });
                            }
                                : null,
                            child: const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'C', // Underlined "A"
                                    style: TextStyle(
                                      decoration:
                                      TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'ancel', // Normal "dd"
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () {
                              // menuController.selectedIndex.value = 0;
                              tabController.removeTab(
                                  tabController.currentIndex.value);
                            },
                            child: const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'E', // Underlined "A"
                                    style: TextStyle(
                                      decoration:
                                      TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'xit', // Normal "dd"
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _isSearch = true;
                              });
                            },
                            child: const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'S', // Underlined "A"
                                    style: TextStyle(
                                      decoration:
                                      TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'earch', // Normal "dd"
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: _isFromEdit
                                ? () async {
                              final invoiceGenerator =
                              PurchaseInvoiceGenerator();
                              final pdfData = await invoiceGenerator
                                  .generateInvoice(
                                  id: defaultController
                                      .purchaseDataList
                                      .length +
                                      1,
                                  invoiceDate: selectedDate!,
                                  invoiceNo:
                                  invNoController.text,
                                  partyCode:
                                  _selectedTypeParty.value,
                                  brokerCode:
                                  _selectedTypeBroker.value,
                                  dueDate:
                                  dueDateController.text,
                                  dueDays:
                                  dueDaysController.text,
                                  entries: entries,
                                  totalWt: totalWt,
                                  totalAmt: totalAmount,
                                  totalRate: totalRate);
                              await Printing.layoutPdf(
                                onLayout:
                                    (PdfPageFormat format) async =>
                                pdfData,
                              );
                              if (!kDebugMode) {
                                await Printing.sharePdf(
                                  bytes: pdfData,
                                  filename:
                                  '${invNoController
                                      .text}.pdf', // Set the custom name here
                                );
                              }
                            }
                                : null,
                            child: const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'P', // Underlined "A"
                                    style: TextStyle(
                                      decoration:
                                      TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'rint', // Normal "dd"
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children
          .map(
            (child) =>
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: child,
              ),
            ),
      )
          .toList(),
    );
  }

  void _updateDueDate() {
    if (selectedDate != null) {
      int dueDays = int.tryParse(dueDaysController.text) ?? 0;
      DateTime temp = selectedDate!.add(Duration(days: dueDays));
      dueDateController.text = DateFormat('dd-MM-yyyy').format(temp);
      dueDate = DateFormat('yyyy-MM-dd HH:MM:SS').format(temp);
    }
  }

  Widget _buildRoughTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey, width: 0.25),
      columnWidths: const {
        0: FixedColumnWidth(50), // Adjust this based on your needs
        1: FlexColumnWidth(20),
        2: FlexColumnWidth(30),
        3: FixedColumnWidth(40),
        4: FixedColumnWidth(40),
        5: FixedColumnWidth(50),
        6: FixedColumnWidth(20),
        7: FixedColumnWidth(20),
        8: FixedColumnWidth(20),
      },
      children: [
        // Table Header Row
        const TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(3.0),
              child: Text(
                'SR.NO',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3.0),
              child: Text(
                'ROUGH',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3.0),
              child: Text(
                'DESCRIPTION',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3.0),
              child: Text(
                'WT',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3.0),
              child: Text(
                'RATE',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3.0),
              child: Text(
                'AMT',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3.0),
              child: Text(
                '',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3.0),
              child: Text(
                '',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ), // Placeholder for edit icon
          ],
        ),
        // Data Rows
        for (int index = 0; index < entries.length; index++)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  (index + 1).toString(),
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  getRoughName(entries[index]['rough']!),
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  entries[index]['description']!,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  entries[index]['wt']!,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  entries[index]['rate']!,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  entries[index]['amount']!,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Obx(
                      () =>
                  defaultController.isDeleteLoading.value
                      ? const CupertinoActivityIndicator(radius: 10)
                      : GestureDetector(
                    child: const Icon(
                      Icons.delete,
                      size: 15,
                    ),
                    onTap: () {
                      if (_isFromEdit) {
                        entries.length == 1
                            ? infoDialog(
                            messageText:
                            'Can not delete Single Rough Entry')
                            : defaultController
                            .deletePurchaseRoughData(
                            id: int.parse(entries[index]['id']!))
                            .then((onValue) {
                          setState(() {
                            entries.removeAt(index);
                          });
                        });
                      } else {
                        setState(() {
                          entries.removeAt(index);
                        });
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: GestureDetector(
                  child: const Icon(
                    Icons.edit,
                    size: 15,
                  ),
                  onTap: () {
                    if (_isFromEdit) {
                      selectedRoughId.value = entries[index]['id']!;
                    }
                    _selectedType.value = entries[index]['rough']!;
                    wtController.text = entries[index]['wt']!;
                    rateController.text = entries[index]['rate']!;
                    descripController.text = entries[index]['description']!;
                    // updateStockControllerBasedOnType(entries[index]['rough']!);
                    setState(() {
                      entries.removeAt(index);
                    });
                  },
                ),
              ),
            ],
          ),
        // Total Row
        TableRow(
          children: [
            const Padding(padding: EdgeInsets.all(3.0), child: Text('')),
            const Padding(padding: EdgeInsets.all(3.0), child: Text('')),
            const Padding(
              padding: EdgeInsets.all(3.0),
              child: Text(
                'TOTAL',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                textAlign: TextAlign.end,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                totalWt.toStringAsFixed(2),
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                totalRate.toStringAsFixed(2),
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                totalAmount.toStringAsFixed(2),
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                textAlign: TextAlign.start,
              ),
            ),
            const Padding(padding: EdgeInsets.all(3.0), child: Text('')),
            const Padding(padding: EdgeInsets.all(3.0), child: Text('')),
          ],
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    return defaultController.roughModel.map((partyType) {
      return DropdownMenuItem<String>(
        value: partyType.roughTypeCode.toString(),
        child: Text(
          partyType.roughTypeName!,
          style: TextStyle(color: Colors.black),
        ),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> get dropdownItemsParty {
    return defaultController.partyMstList
        .where((partyType) =>
    partyType.typeCode == 1 &&
        partyType.companyCode == defaultController.companyCode.value)
        .map((partyType) {
      return DropdownMenuItem<String>(
        value: partyType.partyCode.toString(),
        child: Text(
          partyType.partyName!,
          style: TextStyle(color: Colors.black),
        ),
      );
    })
        .toList()
        .toSet()
        .toList();
  }

  List<DropdownMenuItem<String>> get dropdownItemsBroker {
    return defaultController.partyMstList
        .where((partyType) =>
    partyType.typeCode == 5 &&
        partyType.companyCode == defaultController.companyCode.value)
        .map((partyType) {
      return DropdownMenuItem<String>(
        value: partyType.partyCode.toString(),
        child: Text(partyType.partyName!),
      );
    }).toList();
  }
}
