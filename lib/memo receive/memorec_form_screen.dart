import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/controllers/menu_app_controller.dart';
import 'package:real_web_rough_entry_system/header.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memo_issue_details_datagrid.dart';
import 'package:real_web_rough_entry_system/memo%20receive/memo_rec_details_model.dart';
import 'package:real_web_rough_entry_system/memo%20receive/memo_rec_model.dart';
import 'package:real_web_rough_entry_system/memo%20receive/memo_receive_datagrid.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memo_issue_details_model.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memo_issue_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MemoRecFormScreen extends StatefulWidget {
  const MemoRecFormScreen({super.key});

  @override
  MemoRecFormScreenState createState() => MemoRecFormScreenState();
}

class MemoRecFormScreenState extends State<MemoRecFormScreen> {
  // final TextEditingController partyController = TextEditingController();
  // final TextEditingController invNoController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  // final TextEditingController purIdController = TextEditingController();
  // final TextEditingController dueDaysController = TextEditingController();
  // final TextEditingController dueDateController = TextEditingController();

  final TextEditingController roghController = TextEditingController();
  final TextEditingController descripController = TextEditingController();
  final TextEditingController issWtController = TextEditingController();
  final TextEditingController recWtController = TextEditingController();
  final TextEditingController lossWtController =
      TextEditingController(text: '0.0');
  final TextEditingController rateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController stockcontroller =
      TextEditingController(text: '0.0');
  final FocusNode _partyFocNode = FocusNode();
  final FocusNode _brokerFocus = FocusNode();
  final FocusNode _buttonFocus = FocusNode();
  final FocusNode _keyBoardFocus = FocusNode();
  final FocusNode _formKeyBoardFocus = FocusNode();
  final FocusNode _searchKeyBoardFocus = FocusNode();

  final DataGridController _dataGridController = DataGridController();

  List<Map<String, String>> entries = [];
  List<Map<String, String>> recEntries = [];
  RxList<MemoIssueDetailsModel> allRoughDetails = <MemoIssueDetailsModel>[].obs;
  RxList<MemoIssueDetailsModel> selectedRoughDetails =
      <MemoIssueDetailsModel>[].obs;
  RxList<MemoIssueModel> allSelectedMemoIssue = <MemoIssueModel>[].obs;
  Map<int, List<MemoIssueDetailsModel>> groupedRoughDetails = {};
  RxList selectedBroker = <int>[].obs;
  final RxString _selectedType = ''.obs;
  final RxString _selectedTypeBroker = ''.obs;
  final RxString _selectedTypeParty = ''.obs;
  final RxInt selectedMemoRecMstID = 0.obs;
  final RxString selectedMemoIssueDetID = ''.obs;
  final RxString selectedRoughId = ''.obs;

  DateTime? selectedDate;
  String? dueDate;

  double get totalWt =>
      recEntries.fold(0.0, (prev, e) => prev + double.parse(e['wt']!));

  double get totalRate => totalWt == 0 ? 0 : totalAmount / totalWt;

  double get totalAmount =>
      entries.fold(0.0, (prev, e) => prev + double.parse(e['amount']!));

  double get totalRecWt =>
      recEntries.fold(0.0, (prev, e) => prev + double.parse(e['recWt']!));

  double get totalLossWt => totalWt - totalRecWt;

  double get totalRecRate => totalRecWt == 0 ? 0 : totalRecAmount / totalRecWt;

  double get totalRecAmount =>
      recEntries.fold(0.0, (prev, e) => prev + double.parse(e['amount']!));

  bool _isEnabled = false;
  bool _isSearch = false;
  bool _isFromEdit = false;
  final RxBool _isFiltered = false.obs;

  final _formKey = GlobalKey<FormState>();

  DateTime? fromDate;
  DateTime? toDate;
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  final DefaultController defaultController = Get.find<DefaultController>();
  final MenuAppController menuController = Get.find<MenuAppController>();

  RxList<MemoRecModel> memoRecDataGridSource = <MemoRecModel>[].obs;
  RxList<MemoRecModel> filteredDataGridSource = <MemoRecModel>[].obs;

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
    super.initState();

    // Adding listeners for calculating amount and loss
    _addListeners();

    // Initializing memoRecDataGridSource with defaultController.memoRecList
    memoRecDataGridSource.value = defaultController.memoRecList;

    // Post-frame callbacks for focusing on specific text fields
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setInitialFocus();
    });
  }

// Method to add listeners to controllers for calculations
  void _addListeners() {
    issWtController.addListener(_updateAmount);
    recWtController.addListener(_updateAmount);
    rateController.addListener(_updateAmount);

    issWtController.addListener(_calculateLoss);
    recWtController.addListener(_calculateLoss);
  }

// Method to handle setting initial focus on widgets
  void _setInitialFocus() {
    _keyBoardFocus.requestFocus();
    _formKeyBoardFocus.requestFocus();

    if (_isSearch) {
      _searchKeyBoardFocus.requestFocus();
    }
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    issWtController.dispose();
    recWtController.dispose();
    rateController.dispose();
    amountController.dispose();
    _partyFocNode.dispose();
    _brokerFocus.dispose();
    _buttonFocus.dispose();
    _searchKeyBoardFocus.dispose();
    _keyBoardFocus.dispose();
    _formKeyBoardFocus.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
  }

  void _calculateLoss() {
    double issWt = double.tryParse(issWtController.text) ?? 0.0;
    double recWt = double.tryParse(recWtController.text) ?? 0.0;
    if (recWt <= issWt) {
      // Parse the text values as doubles

      // Calculate the loss weight
      double lossWt = issWt - recWt;

      // Update the lossWtController value
      lossWtController.text = lossWt.toStringAsFixed(3);
    } else {
      // Handle any error that might occur during parsing
      lossWtController.text = '0.00';
    }
  }

  void _updateAmount() {
    final double wt = double.tryParse(issWtController.text) ?? 0;
    final double recWt = double.tryParse(recWtController.text) ?? 0;
    final double rate = double.tryParse(rateController.text) ?? 0;

    if (rate > 0) {
      // Ensure rate is valid before proceeding
      final double amount = wt * rate;
      final double recAmount = recWt * rate;

      if (_isFromEdit) {
        amountController.text = recAmount.toStringAsFixed(2);
      } else {
        amountController.text = amount.toStringAsFixed(2);
      }
    } else {
      amountController.text = "0.00"; // Handle case where rate is 0 or invalid
    }
  }

  void _applyDateFilter() {
    if (fromDate != null && toDate != null) {
      _isFiltered.value = true;
      // setState(() {
      filteredDataGridSource.value =
          defaultController.memoRecList.where((purchase) {
        // Assuming invoiceDate is in 'yyyy-MM-dd' format; adjust as needed
        final invoiceDate = DateTime.parse(purchase.invoiceDate!);

        // Include the boundaries
        return invoiceDate.isAfter(fromDate!) &&
            invoiceDate.isBefore(toDate!.add(const Duration(days: 1)));
      }).toList();
      // Update the data grid source with the filtered data
      memoRecDataGridSource.value = filteredDataGridSource;
      _searchKeyBoardFocus.requestFocus();
      // });
    } else {
      infoDialog(messageText: 'Please select both From Date and To Date');
    }
  }

  void _removeDateFilter() {
    // Reset the data grid source to the full list
    memoRecDataGridSource.value = defaultController.memoRecList;

    // Clear filter values
    toDateController.clear();
    fromDateController.clear();
    fromDate = null;
    toDate = null;

    _isFiltered.value = false;
  }

  void _scrollToSelectedRow(double index) {
    // Scroll to the currently selected row
    _dataGridController.scrollToRow(index);
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
          _brokerFocus.requestFocus(); // Move focus to the first input field
        });
      });
      // _updateDueDate();
    }
  }

  void addEntry() {
    setState(() {
      recEntries.add({
        if (selectedRoughId.value.isNotEmpty) 'id': selectedRoughId.value,
        if (selectedMemoIssueDetID.value.isNotEmpty)
          'detId': selectedMemoIssueDetID.value.toString(),
        'rough': _selectedType.value,
        'description': descripController.text,
        'wt': issWtController.text,
        'recWt': recWtController.text,
        'lossWt': lossWtController.text,
        'rate': rateController.text,
        'amount': (double.parse(recWtController.text) *
                double.parse(rateController.text))
            .toStringAsFixed(2),
      });
      // getCalculation();
      // Clear the input fields
      _selectedType.value = '';
      descripController.clear();
      issWtController.clear();
      recWtController.clear();
      lossWtController.clear();
      rateController.clear();
      amountController.clear();
      stockcontroller.clear();
      Future.delayed(const Duration(milliseconds: 100), () {
        _brokerFocus.requestFocus(); // Move focus to the first input field
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isSearch == true
        ? KeyboardListener(
            focusNode: _searchKeyBoardFocus,
            autofocus: true,
            onKeyEvent: (KeyEvent event) {
              if (event is KeyDownEvent) {
                final int currentIndex = _dataGridController.selectedIndex;
                final int totalRows = defaultController.memoRecList
                    .length; // Use the length of your data source (MemoIssueDetailsDataGridSource)

                // Handle the Enter key
                if (event.logicalKey == LogicalKeyboardKey.enter) {
                  final DataGridRow? selectedRow =
                      _dataGridController.selectedRow;
                  setState(() {
                    recEntries.clear();
                    _isFromEdit = true;
                  });
                  List<MemoRecDetailsModel> roughData =
                      defaultController.memoRecDetailsList;
                  List<MemoRecModel> partyData = defaultController.memoRecList;

                  // Extract the selected polishSaleMstID from the selectedRow
                  selectedMemoRecMstID.value = selectedRow!
                      .getCells()[0]
                      .value; // Assuming the ID is in the first cell

                  // Find the corresponding party data entry with the matching polishSaleMstID
                  MemoRecModel partyEntry = partyData.firstWhere(
                    (entry) => entry.memoRecMstID == selectedMemoRecMstID.value,
                    // orElse: () => null,
                  );

                  // Collect rough data entries with the matching polishSaleMstID
                  List<MemoRecDetailsModel> roughEntries = roughData
                      .where((entry) =>
                          entry.memoRecMstID == selectedMemoRecMstID.value)
                      .toList();
                  // invNoController.text = partyEntry.invoiceNo!;
                  selectedDate = dateFormat(partyEntry.invoiceDate!);
                  // dueDate = formatDateWithTime(partyEntry.dueDate!);
                  dateController.text = formatDate(partyEntry.invoiceDate!);
                  // dueDateController.text =
                  //     formatDate(partyEntry.dueDate!);
                  // dueDaysController.text = partyEntry.dueDay.toString();
                  _selectedTypeParty.value = partyEntry.partyCode.toString();
                  _selectedTypeBroker.value = partyEntry.brokerCode.toString();
                  // _selectedTypeParty.value = partyEntry.partyCode;
                  setState(() {
                    for (var roughEntry in roughEntries) {
                      recEntries.add({
                        'id': roughEntry.memoRecDetID.toString(),
                        'detId': roughEntry.memoIssueDetID.toString(),
                        'rough': roughEntry.roughTypeCode.toString(),
                        'description': roughEntry.description.toString(),
                        'wt': roughEntry.carats.toString(),
                        'recWt': roughEntry.recCarats.toString(),
                        'lossWt': roughEntry.lossCarats.toString(),
                        'rate': roughEntry.rateRs.toString(),
                        'amount':
                            (double.parse(roughEntry.recCarats.toString()) *
                                    double.parse(roughEntry.rateRs.toString()))
                                .toStringAsFixed(2),
                      });
                    }
                  });

                  _enableFields(needFocus: true);
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
                const Header(title: 'Memo Receive Search'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: buildTextField(
                          'From Date',
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
                                    DateFormat('dd-MM-yyyy').format(fromDate!);
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
                      Obx(() => OutlinedButton(
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
                      () => SfDataGrid(
                        controller: _dataGridController,
                        source:
                            MemoReceiveDataGridSource(memoRecDataGridSource),
                        columns: <GridColumn>[
                          GridColumn(
                            columnName: 'ID',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'ID',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // GridColumn(
                          //   columnName: 'Invoice No',
                          //   label: Container(
                          //     padding: const EdgeInsets.all(8.0),
                          //     alignment: Alignment.center,
                          //     child: const Text(
                          //       'Invoice No',
                          //       style: TextStyle(fontWeight: FontWeight.bold),
                          //     ),
                          //   ),
                          // ),
                          GridColumn(
                            columnName: 'Date',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Date',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // GridColumn(
                          //   columnName: 'Rec Date',
                          //   label: Container(
                          //     padding: const EdgeInsets.all(8.0),
                          //     alignment: Alignment.center,
                          //     child: const Text(
                          //       'Rec Date',
                          //       style: TextStyle(fontWeight: FontWeight.bold),
                          //     ),
                          //   ),
                          // ),
                          GridColumn(
                            columnName: 'Party',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Party',
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // GridColumn(
                          //   columnName: 'Rs /\$',
                          //   label: Container(
                          //     padding: const EdgeInsets.all(8.0),
                          //     alignment: Alignment.center,
                          //     child: const Text(
                          //       'Rs /\$',
                          //       style: TextStyle(fontWeight: FontWeight.bold),
                          //     ),
                          //   ),
                          // ),
                          // GridColumn(
                          //   columnName: 'Exchange',
                          //   label: Container(
                          //     padding: const EdgeInsets.all(8.0),
                          //     alignment: Alignment.center,
                          //     child: const Text(
                          //       'Exchange',
                          //       style: TextStyle(fontWeight: FontWeight.bold),
                          //     ),
                          //   ),
                          // ),
                          GridColumn(
                            columnName: 'Tot Wt',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Tot Wt',
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // GridColumn(
                          //   columnName: 'Tot Amt (\$)',
                          //   label: Container(
                          //     padding: const EdgeInsets.all(8.0),
                          //     alignment: Alignment.center,
                          //     child: const Text(
                          //       'Tot Amt (\$)',
                          //       style: TextStyle(fontWeight: FontWeight.bold),
                          //     ),
                          //   ),
                          // ),
                          // GridColumn(
                          //   columnName: 'Bill Type',
                          //   label: Container(
                          //     padding: const EdgeInsets.all(8.0),
                          //     alignment: Alignment.center,
                          //     child: const Text(
                          //       'Bill Type',
                          //       style: TextStyle(fontWeight: FontWeight.bold),
                          //     ),
                          //   ),
                          // ),
                          // GridColumn(
                          //   columnName: 'Lin Fix Rs',
                          //   label: Container(
                          //     padding: const EdgeInsets.all(8.0),
                          //     alignment: Alignment.center,
                          //     child: const Text(
                          //       'Lin Fix Rs',
                          //       style: TextStyle(fontWeight: FontWeight.bold),
                          //     ),
                          //   ),
                          // ),
                          // GridColumn(
                          //   columnName: 'Tot Exp Fix Rs',
                          //   label: Container(
                          //     padding: const EdgeInsets.all(8.0),
                          //     alignment: Alignment.center,
                          //     child: const Text(
                          //       'Tot Exp Fix Rs',
                          //       style: TextStyle(fontWeight: FontWeight.bold),
                          //     ),
                          //   ),
                          // ),
                          // GridColumn(
                          //   columnName: 'Add Fix Rs',
                          //   label: Container(
                          //     padding: const EdgeInsets.all(8.0),
                          //     alignment: Alignment.center,
                          //     child: const Text(
                          //       'Add Fix Rs',
                          //       style: TextStyle(fontWeight: FontWeight.bold),
                          //     ),
                          //   ),
                          // ),
                          // GridColumn(
                          //   columnName: 'Less Fix Rs',
                          //   label: Container(
                          //     padding: const EdgeInsets.all(8.0),
                          //     alignment: Alignment.center,
                          //     child: const Text(
                          //       'Less Fix Rs',
                          //       style: TextStyle(fontWeight: FontWeight.bold),
                          //     ),
                          //   ),
                          // ),
                          // GridColumn(
                          //   columnName: 'Final Net Amt Dollar',
                          //   label: Container(
                          //     padding: const EdgeInsets.all(8.0),
                          //     alignment: Alignment.center,
                          //     child: const Text(
                          //       'Final Net Amt Dollar',
                          //       style: TextStyle(fontWeight: FontWeight.bold),
                          //     ),
                          //   ),
                          // ),
                          // GridColumn(
                          //   columnName: 'Final Net Amt Rs',
                          //   label: Container(
                          //     padding: const EdgeInsets.all(8.0),
                          //     alignment: Alignment.center,
                          //     child: const Text(
                          //       'Final Net Amt Rs',
                          //       style: TextStyle(fontWeight: FontWeight.bold),
                          //     ),
                          //   ),
                          // ),
                        ],
                        rowHeight: 25,
                        headerRowHeight: 35,
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        showSortNumbers: true,
                        // allowSorting: true,
                        // allowMultiColumnSorting: true,
                        allowFiltering: true,
                        selectionMode: SelectionMode.singleDeselect,
                        onSelectionChanged: (List<DataGridRow> addedRows,
                            List<DataGridRow> removedRows) {
                          setState(() {
                            recEntries.clear();
                            _isFromEdit = true;
                          });
                          if (addedRows.isNotEmpty) {
                            final DataGridRow selectedRow = addedRows.first;
                            List<MemoRecDetailsModel> roughData =
                                defaultController.memoRecDetailsList;
                            List<MemoRecModel> partyData =
                                defaultController.memoRecList;

                            // Extract the selected polishSaleMstID from the selectedRow
                            selectedMemoRecMstID.value = selectedRow
                                .getCells()[0]
                                .value; // Assuming the ID is in the first cell

                            // Find the corresponding party data entry with the matching polishSaleMstID
                            MemoRecModel partyEntry = partyData.firstWhere(
                              (entry) =>
                                  entry.memoRecMstID ==
                                  selectedMemoRecMstID.value,
                              // orElse: () => null,
                            );

                            // Collect rough data entries with the matching polishSaleMstID
                            List<MemoRecDetailsModel> roughEntries = roughData
                                .where((entry) =>
                                    entry.memoRecMstID ==
                                    selectedMemoRecMstID.value)
                                .toList();
                            // invNoController.text = partyEntry.invoiceNo!;
                            selectedDate = dateFormat(partyEntry.invoiceDate!);
                            // dueDate = formatDateWithTime(partyEntry.dueDate!);
                            dateController.text =
                                formatDate(partyEntry.invoiceDate!);
                            // dueDateController.text =
                            //     formatDate(partyEntry.dueDate!);
                            // dueDaysController.text = partyEntry.dueDay.toString();
                            _selectedTypeParty.value =
                                partyEntry.partyCode.toString();
                            _selectedTypeBroker.value =
                                partyEntry.brokerCode.toString();
                            // _selectedTypeParty.value = partyEntry.partyCode;
                            setState(() {
                              for (var roughEntry in roughEntries) {
                                recEntries.add({
                                  'id': roughEntry.memoRecDetID.toString(),
                                  'detId': roughEntry.memoIssueDetID.toString(),
                                  'rough': roughEntry.roughTypeCode.toString(),
                                  'description':
                                      roughEntry.description.toString(),
                                  'wt': roughEntry.carats.toString(),
                                  'recWt': roughEntry.recCarats.toString(),
                                  'lossWt': roughEntry.lossCarats.toString(),
                                  'rate': roughEntry.rateRs.toString(),
                                  'amount': (double.parse(
                                              roughEntry.recCarats.toString()) *
                                          double.parse(
                                              roughEntry.rateRs.toString()))
                                      .toStringAsFixed(2),
                                });
                              }
                            });

                            _enableFields(needFocus: true);
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
                const Header(title: 'Memo Receive'),
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
                                  if (!HardwareKeyboard
                                          .instance.isShiftPressed &&
                                      event.logicalKey ==
                                          LogicalKeyboardKey.keyS &&
                                      _isEnabled) {
                                    if (_isFromEdit) {
                                      if (recEntries.isNotEmpty) {
                                        defaultController
                                            .updateMemoRecData(
                                                id: selectedMemoRecMstID.value,
                                                partyCode:
                                                    _selectedTypeParty.value,
                                                // invoiceNo:
                                                //     invNoController.text,
                                                invoiceDate: selectedDate,
                                                brokerCode:
                                                    _selectedTypeBroker.value,
                                                // dueDays:
                                                //     dueDaysController.text,
                                                // dueDate: dueDate,
                                                entries: recEntries,
                                                totalAmt: totalRecAmount,
                                                totalWt: totalRecWt,
                                                totalRate: totalRecRate)
                                            .then((onValue) {
                                          setState(() {
                                            recEntries.clear();
                                            _isFromEdit = false;
                                            _isEnabled = false;
                                          });
                                        });

                                        dateController.clear();
                                        // dueDateController.clear();
                                        // dueDaysController.clear();
                                        dateController.clear();
                                        // invNoController.clear();
                                        _selectedTypeParty.value = '';
                                        _selectedType.value = '';
                                        _selectedTypeBroker.value = '';
                                      } else {
                                        infoDialog(
                                            messageText:
                                                'Please Add Rough Data');
                                      }
                                    } else {
                                      if (recEntries.isNotEmpty) {
                                        defaultController
                                            .addMemoRecData(
                                                partyCode:
                                                    _selectedTypeParty.value,
                                                // invoiceNo:
                                                //     invNoController.text,
                                                invoiceDate: selectedDate,
                                                brokerCode:
                                                    _selectedTypeBroker.value,
                                                // dueDays:
                                                //     dueDaysController.text,
                                                dueDate: dueDate,
                                                entries: recEntries,
                                                totalAmt: totalRecAmount,
                                                totalWt: totalRecWt,
                                                totalRate: totalRecRate)
                                            .then((onValue) {
                                          setState(() {
                                            recEntries.clear();
                                            entries.clear();
                                            _isEnabled = false;
                                          });
                                        });

                                        dateController.clear();
                                        // dueDateController.clear();
                                        // dueDaysController.clear();
                                        dateController.clear();
                                        // invNoController.clear();
                                        _selectedTypeParty.value = '';
                                        _selectedType.value = '';
                                        _selectedTypeBroker.value = '';
                                      } else {
                                        infoDialog(
                                            messageText:
                                                'Please Add Rough Data');
                                      }
                                    }
                                  }
                                  if (event.logicalKey ==
                                          LogicalKeyboardKey.keyA &&
                                      !_isEnabled) {
                                    _enableFields();
                                  }
                                  if (event.logicalKey ==
                                          LogicalKeyboardKey.keyD &&
                                      _isEnabled &&
                                      _isFromEdit) {
                                    if (_isFromEdit) {
                                      defaultController
                                          .deleteMemoRecData(
                                              id: selectedMemoRecMstID.value,
                                              entries: recEntries)
                                          .then((onValue) {
                                        dateController.clear();
                                        // dueDateController.clear();
                                        // dueDaysController.clear();
                                        // invNoController.clear();
                                        _selectedTypeParty.value = '';
                                        _selectedType.value = '';
                                        _selectedTypeBroker.value = '';
                                        setState(() {
                                          _isFromEdit = false;
                                          recEntries.clear();
                                        });
                                      });
                                    } else {
                                      infoDialog(
                                          messageText:
                                              'Please Select Memo Rec Entry to Delete.');
                                    }
                                  }
                                  if (event.logicalKey ==
                                          LogicalKeyboardKey.keyC &&
                                      _isEnabled) {
                                    dateController.clear();
                                    // dueDateController.clear();
                                    // invNoController.clear();
                                    // dueDaysController.clear();
                                    dateController.clear();
                                    issWtController.clear();
                                    amountController.clear();
                                    descripController.clear();
                                    rateController.clear();
                                    _selectedTypeParty.value = '';
                                    _selectedType.value = '';
                                    _selectedTypeBroker.value = '';
                                    recWtController.clear();
                                    setState(() {
                                      entries.clear();
                                      recEntries.clear();
                                      _isFromEdit = false;
                                      _isEnabled = false;
                                    });
                                  }
                                  if (event.logicalKey ==
                                      LogicalKeyboardKey.keyE) {
                                    menuController.selectedIndex.value = 0;
                                  }
                                  if (HardwareKeyboard
                                          .instance.isShiftPressed &&
                                      event.logicalKey ==
                                          LogicalKeyboardKey.keyS) {
                                    setState(() {
                                      _isSearch = true;
                                    });
                                  }
                                }
                              },
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            top: BorderSide(color: Colors.grey),
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
                                                              fontSize: 0),
                                                          focusedErrorBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .red,
                                                                    width: 1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .zero,
                                                          ),
                                                          errorBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .red,
                                                                    width: 1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .zero,
                                                          ),
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .blue,
                                                                    width: 1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .zero,
                                                          ),
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .zero,
                                                          ),
                                                          isDense: true,
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          8),
                                                        ),
                                                        items:
                                                            dropdownItemsParty,
                                                        onChanged: _isFromEdit
                                                            ? null
                                                            : _isEnabled
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
                                                                      _brokerFocus
                                                                          .requestFocus(); // Move focus to the first input field
                                                                    }); // Handle null case
                                                                  }
                                                                : null,
                                                      );
                                                    }),
                                                  ),
                                                ],
                                              ),
                                              // _buildTextField(
                                              //     'INVOICE NO.', invNoController,
                                              //     isEnabled: _isEnabled),

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
                                                                .value.isEmpty
                                                            ? null
                                                            : _selectedTypeBroker
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
                                                              color: Colors.red,
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
                                                              color: Colors.red,
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
                                                        // onChanged: null,
                                                        onChanged: _isFromEdit
                                                            ? null
                                                            : _isEnabled
                                                                ? (value) {
                                                                    if (_selectedTypeParty
                                                                        .isEmpty) {
                                                                      infoDialog(
                                                                          messageText:
                                                                              'Please Select Party.');
                                                                    } else {
                                                                      _selectedTypeBroker
                                                                              .value =
                                                                          value ??
                                                                              '';
                                                                      allSelectedMemoIssue
                                                                          .clear();
                                                                      allSelectedMemoIssue.value = getMemoIssueByPartyAndBroker(
                                                                          int.parse(_selectedTypeParty
                                                                              .value),
                                                                          int.parse(
                                                                              _selectedTypeBroker.value))!; // Handle null case

                                                                      if (allSelectedMemoIssue
                                                                          .isNotEmpty) {
                                                                        // Clear the rough details list to avoid duplicating data on subsequent calls
                                                                        allRoughDetails
                                                                            .clear();

                                                                        for (var memo
                                                                            in allSelectedMemoIssue) {
                                                                          // Filter the rough details matching the selected memoIssueMstID
                                                                          List<MemoIssueDetailsModel>
                                                                              roughDetails =
                                                                              defaultController.memoIssueDetailsList.where((detail) => detail.memoIssueMstID == memo.memoIssueMstID && detail.rec == 'N').toList();

                                                                          allRoughDetails
                                                                              .addAll(roughDetails); // Add the filtered results
                                                                        }

                                                                        if (allRoughDetails
                                                                            .isNotEmpty) {
                                                                          showDialog(
                                                                            barrierDismissible:
                                                                                false,
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext cnt) {
                                                                              return AlertDialog(
                                                                                title: const Text('Select Entry to Receive'),
                                                                                content: SizedBox(
                                                                                  width: MediaQuery.of(context).size.width * 0.5,
                                                                                  // Adjusts width dynamically
                                                                                  height: MediaQuery.of(context).size.height * 0.2,
                                                                                  // Adjusts height dynamically
                                                                                  child: KeyboardListener(
                                                                                    focusNode: _keyBoardFocus,
                                                                                    autofocus: true,
                                                                                    onKeyEvent: (KeyEvent event) {
                                                                                      if (event is KeyDownEvent) {
                                                                                        final int currentIndex = _dataGridController.selectedIndex;
                                                                                        final int totalRows = allRoughDetails.length; // Use the length of your data source (MemoIssueDetailsDataGridSource)

                                                                                        // Handle the Enter key
                                                                                        if (event.logicalKey == LogicalKeyboardKey.enter) {
                                                                                          final DataGridRow? selectedRow = _dataGridController.selectedRow;

                                                                                          if (selectedRow != null) {
                                                                                            // Get the Memo Issue Detail ID from the selected row
                                                                                            selectedMemoIssueDetID.value = selectedRow.getCells()[3].value.toString();

                                                                                            // Find the corresponding rough data for the selected memo issue detail
                                                                                            MemoIssueDetailsModel roughEntry = defaultController.memoIssueDetailsList.firstWhere((entry) => entry.memoIssueDetID == int.parse(selectedMemoIssueDetID.value));
                                                                                            selectedRoughDetails.add(roughEntry); // Update the form fields with the selected rough entry details
                                                                                            // Update the form fields with the selected rough entry details
                                                                                            _selectedType.value = roughEntry.roughTypeCode.toString();
                                                                                            issWtController.text = roughEntry.carats.toString();
                                                                                            rateController.text = roughEntry.rateRs.toString();
                                                                                            recWtController.text = roughEntry.carats.toString();
                                                                                            descripController.text = roughEntry.description.toString();
                                                                                            dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
                                                                                            selectedDate = DateTime.now();
                                                                                            defaultController.memoIssueDetailsList.remove(roughEntry);
                                                                                            Future.delayed(const Duration(milliseconds: 100), () {
                                                                                              _buttonFocus.requestFocus();
                                                                                            });
                                                                                            Get.back();

                                                                                            // Enable the fields and close the dialog
                                                                                            _enableFields(needFocus: false);
                                                                                          }
                                                                                        }

                                                                                        // Handle the down arrow key to go to the next row
                                                                                        if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                                                                                          if (currentIndex < totalRows - 1) {
                                                                                            _dataGridController.selectedIndex = currentIndex + 1; // Select the next row
                                                                                            _scrollToSelectedRow(double.parse(_dataGridController.selectedIndex.toString())); // Scroll to the selected row
                                                                                          }
                                                                                        }

                                                                                        // Handle the up arrow key to go to the previous row
                                                                                        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                                                                                          if (currentIndex > 0) {
                                                                                            _dataGridController.selectedIndex = currentIndex - 1; // Select the previous row
                                                                                            _scrollToSelectedRow(double.parse(_dataGridController.selectedIndex.toString())); // Scroll to the selected row
                                                                                          }
                                                                                        }
                                                                                      }
                                                                                    },
                                                                                    child: Obx(
                                                                                      () => SfDataGrid(
                                                                                        controller: _dataGridController,
                                                                                        source: MemoIssueDetailsDataGridSource(allRoughDetails),
                                                                                        columns: <GridColumn>[
                                                                                          GridColumn(
                                                                                            columnName: 'Rough',
                                                                                            label: Container(
                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                              alignment: Alignment.center,
                                                                                              child: const Text(
                                                                                                'Rough',
                                                                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          GridColumn(
                                                                                            columnName: 'Wt',
                                                                                            label: Container(
                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                              alignment: Alignment.center,
                                                                                              child: const Text(
                                                                                                'Wt',
                                                                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          GridColumn(
                                                                                            columnName: 'Issue ID',
                                                                                            label: Container(
                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                              alignment: Alignment.center,
                                                                                              child: const Text(
                                                                                                'Issue ID',
                                                                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          GridColumn(
                                                                                            columnName: 'Detail ID',
                                                                                            label: Container(
                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                              alignment: Alignment.center,
                                                                                              child: const Text(
                                                                                                'Detail ID',
                                                                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                        rowHeight: 25,
                                                                                        headerRowHeight: 35,
                                                                                        gridLinesVisibility: GridLinesVisibility.both,
                                                                                        headerGridLinesVisibility: GridLinesVisibility.both,
                                                                                        selectionMode: SelectionMode.singleDeselect,
                                                                                        onSelectionChanged: (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
                                                                                          if (addedRows.isNotEmpty) {
                                                                                            final DataGridRow selectedRow = addedRows.first;

                                                                                            // Retrieve the selected memo issue detail ID from the selected row
                                                                                            selectedMemoIssueDetID.value = selectedRow.getCells()[3].value.toString();

                                                                                            // Find the corresponding rough data for the selected memo issue detail
                                                                                            MemoIssueDetailsModel roughEntry = defaultController.memoIssueDetailsList.firstWhere((entry) => entry.memoIssueDetID == int.parse(selectedMemoIssueDetID.value));
                                                                                            selectedRoughDetails.add(roughEntry); // Update the form fields with the selected rough entry details
                                                                                            _selectedType.value = roughEntry.roughTypeCode.toString();
                                                                                            issWtController.text = roughEntry.carats.toString();
                                                                                            rateController.text = roughEntry.rateRs.toString();
                                                                                            recWtController.text = roughEntry.carats.toString();
                                                                                            descripController.text = roughEntry.description.toString();
                                                                                            dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
                                                                                            selectedDate = DateTime.now();
                                                                                            defaultController.memoIssueDetailsList.remove(roughEntry);
                                                                                            _enableFields();
                                                                                            Get.back(); // Close the dialog
                                                                                          }
                                                                                          Future.delayed(const Duration(milliseconds: 100), () {
                                                                                            _buttonFocus.requestFocus(); // Move focus to the first input field
                                                                                          });
                                                                                        },
                                                                                        columnWidthMode: ColumnWidthMode.fill,
                                                                                        frozenColumnsCount: 1,
                                                                                        allowFiltering: true,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                actions: <Widget>[
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Container(
                                                                                        padding: const EdgeInsets.all(5.0),
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(5),
                                                                                          color: Theme.of(context).hoverColor,
                                                                                        ),
                                                                                        child: Row(
                                                                                          children: [
                                                                                            const Text('Total Wt : ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                                                                            Text(
                                                                                              MemoIssueDetailsDataGridSource(allRoughDetails).totalWt.toStringAsFixed(3),
                                                                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                                                                              textAlign: TextAlign.left,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      OutlinedButton(
                                                                                        child: const Text('Cancel'),
                                                                                        onPressed: () {
                                                                                          Get.back();
                                                                                        },
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          );
                                                                        } else {
                                                                          // Show snackbar if no matching details found
                                                                          infoDialog(
                                                                              messageText: 'No memo issue details found for the selected broker.');
                                                                        }
                                                                      } else {
                                                                        // Show snackbar if no memo issue is selected
                                                                        infoDialog(
                                                                            messageText:
                                                                                'No memo issue found for the selected party and broker.');
                                                                      }
                                                                    }
                                                                  }
                                                                : null,
                                                      );
                                                    }),
                                                  ),
                                                ],
                                              ),
                                              Focus(
                                                onKeyEvent: _isFromEdit
                                                    ? null
                                                    : (node, event) {
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
                                                  'DATE',
                                                  dateController,
                                                  isEnabled: _isFromEdit
                                                      ? false
                                                      : _isEnabled,
                                                  onTap: _isFromEdit
                                                      ? null
                                                      : () {
                                                          _openDatePicker();
                                                        },
                                                ),
                                              ),
                                              // _buildTextField('PURID', 'AUTO', purIdController),
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
                                        4: FlexColumnWidth(1), // RATE column
                                        5: FlexColumnWidth(1), // RATE column
                                        6: FlexColumnWidth(1), // AMOUNT column
                                        7: FlexColumnWidth(
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
                                                    fontWeight: FontWeight.w900,
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
                                                    fontWeight: FontWeight.w900,
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
                                                    fontWeight: FontWeight.w900,
                                                    fontSize:
                                                        12, // Font size for the label
                                                  ),
                                                  textAlign: TextAlign.start),
                                            )),
                                            TableCell(
                                                child: Padding(
                                              padding: EdgeInsets.all(3.0),
                                              child: Text('REC WT',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize:
                                                        12, // Font size for the label
                                                  ),
                                                  textAlign: TextAlign.start),
                                            )),
                                            TableCell(
                                                child: Padding(
                                              padding: EdgeInsets.all(3.0),
                                              child: Text('LOSS WT',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w900,
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
                                                    fontWeight: FontWeight.w900,
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
                                                    fontWeight: FontWeight.w900,
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
                                                    fontWeight: FontWeight.w900,
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
                                                    // focusedErrorBorder:
                                                    //     UnderlineInputBorder(
                                                    //   borderSide: BorderSide(
                                                    //     color: Colors.red,
                                                    //     width:
                                                    //         1.0, // Thin border width
                                                    //   ),
                                                    //   borderRadius: BorderRadius
                                                    //       .zero, // Squared corners
                                                    // ),
                                                    // errorBorder:
                                                    //     UnderlineInputBorder(
                                                    //   borderSide: BorderSide(
                                                    //     color: Colors.red,
                                                    //     width:
                                                    //         1.0, // Thin border width
                                                    //   ),
                                                    //   borderRadius: BorderRadius
                                                    //       .zero, // Squared corners
                                                    // ),
                                                    // focusedBorder:
                                                    //     UnderlineInputBorder(
                                                    //   borderSide: BorderSide(
                                                    //     color: Colors.blue,
                                                    //     width:
                                                    //         1.0, // Thin border width
                                                    //   ),
                                                    //   borderRadius: BorderRadius
                                                    //       .zero, // Squared corners
                                                    // ),
                                                    // enabledBorder:
                                                    //     UnderlineInputBorder(
                                                    //   borderSide: BorderSide(
                                                    //     color: Colors.grey,
                                                    //     width:
                                                    //         1.0, // Thin border width
                                                    //   ),
                                                    //   borderRadius: BorderRadius
                                                    //       .zero, // Squared corners
                                                    // ),
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 8,
                                                    ),
                                                  ),
                                                  items: dropdownItems,
                                                  onChanged: /*_isEnabled
                                                        ? (value) {
                                                            updateStockControllerBasedOnType(
                                                                value);
                                                          }
                                                        :*/
                                                      null,
                                                );
                                              }),
                                            ),
                                            TableCell(
                                              child: buildTextField2(
                                                  'DESCRIPTION',
                                                  descripController,
                                                  isEnabled: false),
                                            ),
                                            TableCell(
                                              child: buildTextField2(
                                                  'ISS WT', issWtController,
                                                  inputFormatterList: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'^\d+\.?\d{0,3}')),
                                                  ],
                                                  isEnabled: false),
                                            ),
                                            TableCell(
                                              child: buildTextField2(
                                                'REC WT',
                                                recWtController,
                                                inputFormatterList: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(
                                                          r'^\d+\.?\d{0,3}')),
                                                ],
                                                isEnabled: _isEnabled,
                                              ),
                                            ),
                                            TableCell(
                                              child: buildTextField2(
                                                'LOSS WT',
                                                lossWtController,
                                                inputFormatterList: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(
                                                          r'^\d+\.?\d{0,3}')),
                                                ],
                                                isEnabled: false,
                                              ),
                                            ),
                                            TableCell(
                                              child: buildTextField2(
                                                  'RATE', rateController,
                                                  inputFormatterList: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'^\d+\.?\d{0,3}')),
                                                  ],
                                                  isEnabled: false),
                                            ),
                                            TableCell(
                                              child: buildTextField2(
                                                  'AMOUNT', amountController,
                                                  isEnabled: false),
                                            ),
                                            TableCell(
                                                child: InkWell(
                                              focusNode: _buttonFocus,
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
                                    )
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
                              // child: _buildDataTable(),
                              child: _buildRoughTable(),
                            ),
                          ),
                          // PartyForm(),
                          // MyFiles(),
                          // const SizedBox(height: 16),
                          // RecentFiles(),
                          // if (Responsive.isMobile(context)) const SizedBox(height: 16),
                          // if (Responsive.isMobile(context)) StorageDetails(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                onPressed: !_isEnabled ? _enableFields : null,
                                child: const Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'A', // Underlined "A"
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
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
                                        if (recEntries.isNotEmpty) {
                                          defaultController
                                              .updateMemoRecData(
                                                  id: selectedMemoRecMstID
                                                      .value,
                                                  partyCode:
                                                      _selectedTypeParty.value,
                                                  // invoiceNo:
                                                  //     invNoController.text,
                                                  invoiceDate: selectedDate,
                                                  brokerCode:
                                                      _selectedTypeBroker.value,
                                                  // dueDays:
                                                  //     dueDaysController.text,
                                                  // dueDate: dueDate,
                                                  entries: recEntries,
                                                  totalAmt: totalRecAmount,
                                                  totalWt: totalRecWt,
                                                  totalRate: totalRecRate)
                                              .then((onValue) {
                                            setState(() {
                                              recEntries.clear();
                                              _isFromEdit = false;
                                              _isEnabled = false;
                                            });
                                          });

                                          dateController.clear();
                                          // dueDateController.clear();
                                          // dueDaysController.clear();
                                          dateController.clear();
                                          // invNoController.clear();
                                          _selectedTypeParty.value = '';
                                          _selectedType.value = '';
                                          _selectedTypeBroker.value = '';
                                        } else {
                                          infoDialog(
                                              messageText:
                                                  'Please Add Rough Data');
                                        }
                                      }
                                    : _isEnabled
                                        ? () async {
                                            if (recEntries.isNotEmpty) {
                                              defaultController
                                                  .addMemoRecData(
                                                      partyCode:
                                                          _selectedTypeParty
                                                              .value,
                                                      // invoiceNo:
                                                      //     invNoController.text,
                                                      invoiceDate: selectedDate,
                                                      brokerCode:
                                                          _selectedTypeBroker
                                                              .value,
                                                      // dueDays:
                                                      //     dueDaysController.text,
                                                      dueDate: dueDate,
                                                      entries: recEntries,
                                                      totalAmt: totalRecAmount,
                                                      totalWt: totalRecWt,
                                                      totalRate: totalRecRate)
                                                  .then((onValue) {
                                                setState(() {
                                                  recEntries.clear();
                                                  entries.clear();
                                                  _isEnabled = false;
                                                });
                                              });

                                              dateController.clear();
                                              // dueDateController.clear();
                                              // dueDaysController.clear();
                                              dateController.clear();
                                              // invNoController.clear();
                                              _selectedTypeParty.value = '';
                                              _selectedType.value = '';
                                              _selectedTypeBroker.value = '';
                                            } else {
                                              infoDialog(
                                                  messageText:
                                                      'Please Add Rough Data');
                                            }
                                          }
                                        : null,
                                child: Obx(
                                  () => defaultController.isLoading.value
                                      ? const CupertinoActivityIndicator()
                                      : const Text.rich(
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
                                            .deleteMemoRecData(
                                                id: selectedMemoRecMstID.value,
                                                entries: recEntries)
                                            .then((onValue) {
                                          dateController.clear();
                                          // dueDateController.clear();
                                          // dueDaysController.clear();
                                          // invNoController.clear();
                                          _selectedTypeParty.value = '';
                                          _selectedType.value = '';
                                          _selectedTypeBroker.value = '';
                                          setState(() {
                                            _isFromEdit = false;
                                            recEntries.clear();
                                          });
                                        });
                                      }
                                    : null,
                                child: Obx(
                                  () => defaultController.isDeleteLoading.value
                                      ? const CupertinoActivityIndicator()
                                      : const Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'D', // Underlined "A"
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
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
                                        // dueDateController.clear();
                                        // invNoController.clear();
                                        // dueDaysController.clear();
                                        dateController.clear();
                                        issWtController.clear();
                                        amountController.clear();
                                        descripController.clear();
                                        rateController.clear();
                                        _selectedTypeParty.value = '';
                                        _selectedType.value = '';
                                        _selectedTypeBroker.value = '';
                                        recWtController.clear();
                                        setState(() {
                                          entries.clear();
                                          recEntries.clear();
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
                                          decoration: TextDecoration.underline,
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
                                  menuController.selectedIndex.value = 0;
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
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'earch', // Normal "dd"
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
                    // if (!Responsive.isMobile(context))
                    //   const SizedBox(width: 16),
                    // On Mobile means if the screen is less than 850 we don't want to show it
                    // if (!Responsive.isMobile(context))
                    //   const Expanded(
                    //       flex: 2,
                    //       // child: StorageDetails(),
                    //       child: Column(
                    //         children: [],
                    //       )),
                  ],
                ),
              ],
            ),
          );
  }

  Widget _buildRow(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children
          .map(
            (child) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: child,
              ),
            ),
          )
          .toList(),
    );
  }

  // void _updateDueDate() {
  //   if (selectedDate != null) {
  //     int dueDays = int.tryParse(dueDaysController.text) ?? 0;
  //     DateTime temp = selectedDate!.add(Duration(days: dueDays));
  //     dueDateController.text = DateFormat('dd-MM-yyyy').format(temp);
  //     dueDate = DateFormat('yyyy-MM-dd HH:MM:SS').format(temp);
  //   }
  // }

  Widget _buildRoughTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey, width: 0.25),
      columnWidths: const {
        0: FixedColumnWidth(50), // Adjust this based on your needs
        1: FlexColumnWidth(60),
        2: FlexColumnWidth(150),
        3: FixedColumnWidth(80),
        4: FixedColumnWidth(80),
        5: FixedColumnWidth(80),
        6: FixedColumnWidth(80),
        7: FixedColumnWidth(80),
        8: FixedColumnWidth(40),
        9: FixedColumnWidth(40),
        10: FixedColumnWidth(40),
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
                'REC WT',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3.0),
              child: Text(
                'LOSS WT',
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
                'AMOUNT',
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
        for (int index = 0; index < recEntries.length; index++)
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
                  getRoughName(recEntries[index]['rough']!),
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  recEntries[index]['description']!,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  recEntries[index]['wt']!,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  recEntries[index]['recWt']!,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  recEntries[index]['lossWt']!,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  recEntries[index]['rate']!,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  recEntries[index]['amount']!,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Obx(
                  () => defaultController.isDeleteLoading.value
                      ? const CupertinoActivityIndicator(radius: 10)
                      : GestureDetector(
                          child: const Icon(
                            Icons.delete,
                            size: 15,
                          ),
                          onTap: () {
                            if (_isFromEdit) {
                              recEntries.length == 1
                                  ? infoDialog(
                                      messageText:
                                          'Can not delete Single Rough Entry')
                                  : defaultController
                                      .deleteMemoRecRoughData(
                                          detId: int.parse(
                                              recEntries[index]['detId']!),
                                          id: int.parse(
                                              recEntries[index]['id']!))
                                      .then((onValue) {
                                      setState(() {
                                        recEntries.removeAt(index);
                                      });
                                      // defaultController.memoIssueDetailsList
                                      //     .add(removedEntry);
                                    });
                            } else {
                              MemoIssueDetailsModel removedEntry =
                              selectedRoughDetails.firstWhere((w) =>
                              w.memoIssueDetID.toString() ==
                                  recEntries[index]['detId']);
                              defaultController.memoIssueDetailsList
                                  .add(removedEntry);
                              setState(() {
                                recEntries.removeAt(index);
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
                      selectedRoughId.value = recEntries[index]['id']!;
                    }
                    _selectedType.value = recEntries[index]['rough']!;
                    issWtController.text = recEntries[index]['wt']!;
                    recWtController.text = recEntries[index]['recWt']!;
                    rateController.text = recEntries[index]['rate']!;
                    // amountController.text = recEntries[index]['amount']!;
                    descripController.text = recEntries[index]['description']!;
                    setState(() {
                      recEntries.removeAt(index);
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
                totalRecWt.toStringAsFixed(2),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                totalLossWt.toStringAsFixed(2),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                totalRecRate.toStringAsFixed(2),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                totalRecAmount.toStringAsFixed(2),
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
        child: Text(partyType.roughTypeName!),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> get dropdownItemsParty {
    return defaultController.partyMstList
        .where((partyType) => partyType.typeCode == 1)
        .map((partyType) {
      return DropdownMenuItem<String>(
        value: partyType.partyCode.toString(),
        child: Text(partyType.partyName!),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> get dropdownItemsBroker {
    if (groupedRoughDetails.isNotEmpty) {}
    return defaultController.partyMstList
        .where((partyType) => partyType.typeCode == 5)
        .map((partyType) {
      return DropdownMenuItem<String>(
        value: partyType.partyCode.toString(),
        child: Text(partyType.partyName!),
      );
    }).toList();
  }

  // Assuming memoIssueList is a list of MemoIssueModel and memoIssueDetailsList is a list of MemoIssueDetailsModel
  List<MemoIssueModel>? getMemoIssueByPartyAndBroker(
      int selectedPartyCode, int selectedBrokerCode) {
    // Use `where` to filter entries that match both partyCode and brokerCode
    return defaultController.memoIssueList
        .where((memo) =>
            memo.partyCode == selectedPartyCode &&
            memo.brokerCode == selectedBrokerCode)
        .toList();
  }
}
