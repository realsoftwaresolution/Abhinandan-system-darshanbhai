import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/controllers/menu_app_controller.dart';
import 'package:real_web_rough_entry_system/header.dart';
import 'package:real_web_rough_entry_system/responsive.dart';
import 'package:real_web_rough_entry_system/rough/rough_model.dart';
import 'package:real_web_rough_entry_system/sale/sale_datagrid.dart';
import 'package:real_web_rough_entry_system/sale/sale_details_model.dart';
import 'package:real_web_rough_entry_system/sale/sale_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SaleFormScreen extends StatefulWidget {
  const SaleFormScreen({super.key});

  @override
  SaleFormScreenState createState() => SaleFormScreenState();
}

class SaleFormScreenState extends State<SaleFormScreen> {
  // final TextEditingController partyController = TextEditingController();
  final TextEditingController invNoController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController purIdController = TextEditingController();
  final TextEditingController dueDaysController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();

  final TextEditingController roghController = TextEditingController();
  final TextEditingController descripController = TextEditingController();
  final TextEditingController wtController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController stockcontroller =
      TextEditingController(text: '0.0');
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
  final RxString _selectedTypeBroker = ''.obs;
  final RxString _selectedTypeParty = ''.obs;
  final RxInt selectedPolishSaleMstID = 0.obs;
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
  final _formKey = GlobalKey<FormState>();

  final DefaultController defaultController = Get.find<DefaultController>();
  final MenuAppController menuController = Get.find<MenuAppController>();

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
      entries.add({
        if (selectedRoughId.value.isNotEmpty) 'id': selectedRoughId.value,
        'rough': _selectedType.value,
        'description': descripController.text,
        'wt': wtController.text,
        'rate': rateController.text,
        'amount': (double.parse(wtController.text) *
                double.parse(rateController.text))
            .toStringAsFixed(2),
      });
      // getCalculation();
      // Clear the input fields
      _selectedType.value = '';
      descripController.clear();
      wtController.clear();
      rateController.clear();
      amountController.clear();
      stockcontroller.clear();

      Future.delayed(const Duration(milliseconds: 100), () {
        _roughFocNode.requestFocus(); // Move focus to the first input field
      });
    });
    // print("${entries.length}FROM ...");
  }

  @override
  Widget build(BuildContext context) {
    return _isSearch == true
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Header(title: 'Sale Search'),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _isSearch = false;
                  });
                },
                child: const Text("Exit"),
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(
                () => Expanded(
                  child: KeyboardListener(
                    focusNode: _searchKeyBoardFocus,
                    autofocus: true,
                    onKeyEvent: (KeyEvent event) {
                      if (event is KeyDownEvent) {
                        final int currentIndex =
                            _dataGridController.selectedIndex;
                        final int totalRows = defaultController
                            .polishSaleList
                            .length; // Use the length of your data source (MemoIssueDetailsDataGridSource)

                        // Handle the Enter key
                        if (event.logicalKey == LogicalKeyboardKey.enter) {
                          final DataGridRow? selectedRow =
                              _dataGridController.selectedRow;
                          setState(() {
                            entries.length = 0;
                            _isFromEdit = true;
                          });
                          List<SaleDetailsModel> roughData =
                              defaultController.saleDetailsList;
                          List<PolishSaleModel> partyData =
                              defaultController.polishSaleList;

                          // Extract the selected polishSaleMstID from the selectedRow
                          selectedPolishSaleMstID.value = selectedRow!
                              .getCells()[0]
                              .value; // Assuming the ID is in the first cell

                          // Find the corresponding party data entry with the matching polishSaleMstID
                          PolishSaleModel partyEntry = partyData.firstWhere(
                                (entry) =>
                            entry.polishSaleMstID ==
                                selectedPolishSaleMstID.value,
                            // orElse: () => null,
                          );

                          // Collect rough data entries with the matching polishSaleMstID
                          List<SaleDetailsModel> roughEntries = roughData
                              .where((entry) =>
                          entry.polishSaleMstID ==
                              selectedPolishSaleMstID.value)
                              .toList();
                          invNoController.text = partyEntry.invoiceNo!;
                          selectedDate = dateFormat(partyEntry.invoiceDate!);
                          dueDate = formatDateWithTime(partyEntry.dueDate!);
                          dateController.text =
                              formatDate(partyEntry.invoiceDate!);
                          dueDateController.text =
                              formatDate(partyEntry.dueDate!);
                          dueDaysController.text = partyEntry.dueDay.toString();
                          _selectedTypeParty.value =
                              partyEntry.partyCode.toString();
                          _selectedTypeBroker.value =
                              partyEntry.brokerCode.toString();
                          // _selectedTypeParty.value = partyEntry.partyCode;
                          setState(() {
                            for (var roughEntry in roughEntries) {
                              entries.add({
                                'id': roughEntry.polishSaleDetID.toString(),
                                'rough': roughEntry.roughTypeCode.toString(),
                                'description':
                                roughEntry.description.toString(),
                                'wt': roughEntry.carats.toString(),
                                'rate': roughEntry.rateRs.toString(),
                                'amount': (double.parse(
                                    roughEntry.carats.toString()) *
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

                        // Handle the down arrow key to go to the next row
                        if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                          if (currentIndex < totalRows - 1) {
                            _dataGridController.selectedIndex =
                                currentIndex + 1; // Select the next row
                            _scrollToSelectedRow(double.parse(
                                _dataGridController.selectedIndex
                                    .toString())); // Scroll to the selected row
                          }
                        }

                        // Handle the up arrow key to go to the previous row
                        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                          if (currentIndex > 0) {
                            _dataGridController.selectedIndex =
                                currentIndex - 1; // Select the previous row
                            _scrollToSelectedRow(double.parse(
                                _dataGridController.selectedIndex
                                    .toString())); // Scroll to the selected row
                          }
                        }

                        if (event.logicalKey == LogicalKeyboardKey.keyE) {
                          setState(() {
                            _isSearch = false;
                          });
                        }
                      }
                    },
                    child: SfDataGrid(
                      controller: _dataGridController,
                      source:
                          SaleDataGridSource(defaultController.polishSaleList),
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
                        GridColumn(
                          columnName: 'Invoice No',
                          label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text(
                              'Invoice No',
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                      rowHeight: 30,
                      headerRowHeight: 40,
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
                          entries.length = 0;
                          _isFromEdit = true;
                        });
                        if (addedRows.isNotEmpty) {
                          final DataGridRow selectedRow = addedRows.first;
                          List<SaleDetailsModel> roughData =
                              defaultController.saleDetailsList;
                          List<PolishSaleModel> partyData =
                              defaultController.polishSaleList;

                          // Extract the selected polishSaleMstID from the selectedRow
                          selectedPolishSaleMstID.value = selectedRow
                              .getCells()[0]
                              .value; // Assuming the ID is in the first cell

                          // Find the corresponding party data entry with the matching polishSaleMstID
                          PolishSaleModel partyEntry = partyData.firstWhere(
                            (entry) =>
                                entry.polishSaleMstID ==
                                selectedPolishSaleMstID.value,
                            // orElse: () => null,
                          );

                          // Collect rough data entries with the matching polishSaleMstID
                          List<SaleDetailsModel> roughEntries = roughData
                              .where((entry) =>
                                  entry.polishSaleMstID ==
                                  selectedPolishSaleMstID.value)
                              .toList();
                          invNoController.text = partyEntry.invoiceNo!;
                          selectedDate = dateFormat(partyEntry.invoiceDate!);
                          dueDate = formatDateWithTime(partyEntry.dueDate!);
                          dateController.text =
                              formatDate(partyEntry.invoiceDate!);
                          dueDateController.text =
                              formatDate(partyEntry.dueDate!);
                          dueDaysController.text = partyEntry.dueDay.toString();
                          _selectedTypeParty.value =
                              partyEntry.partyCode.toString();
                          _selectedTypeBroker.value =
                              partyEntry.brokerCode.toString();
                          // _selectedTypeParty.value = partyEntry.partyCode;
                          setState(() {
                            for (var roughEntry in roughEntries) {
                              entries.add({
                                'id': roughEntry.polishSaleDetID.toString(),
                                'rough': roughEntry.roughTypeCode.toString(),
                                'description':
                                    roughEntry.description.toString(),
                                'wt': roughEntry.carats.toString(),
                                'rate': roughEntry.rateRs.toString(),
                                'amount': (double.parse(
                                            roughEntry.carats.toString()) *
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
          )
        : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Header(title: 'Sale'),
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
                                            LogicalKeyboardKey.keyS) {
                                      if (_isFromEdit) {
                                        if (entries.isNotEmpty) {
                                          defaultController
                                              .updateSaleData(
                                                  id: selectedPolishSaleMstID
                                                      .value,
                                                  partyCode:
                                                      _selectedTypeParty.value,
                                                  invoiceNo:
                                                      invNoController.text,
                                                  invoiceDate: selectedDate,
                                                  brokerCode:
                                                      _selectedTypeBroker.value,
                                                  dueDays:
                                                      dueDaysController.text,
                                                  dueDate: dueDate,
                                                  entries: entries,
                                                  totalAmt: totalAmount,
                                                  totalWt: totalWt,
                                                  totalRate: totalRate)
                                              .then((onValue) {
                                            setState(() {
                                              entries.clear();
                                              _isFromEdit = false;
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
                                          _selectedTypeBroker.value = '';
                                        } else {
                                          infoDialog(
                                              messageText:
                                                  'Please Add Rough Data');
                                        }
                                      } else {
                                        if (entries.isNotEmpty) {
                                          defaultController
                                              .addSaleData(
                                                  partyCode:
                                                      _selectedTypeParty.value,
                                                  invoiceNo:
                                                      invNoController.text,
                                                  invoiceDate: selectedDate,
                                                  brokerCode:
                                                      _selectedTypeBroker.value,
                                                  dueDays:
                                                      dueDaysController.text,
                                                  dueDate: dueDate,
                                                  entries: entries,
                                                  totalAmt: totalAmount,
                                                  totalWt: totalWt,
                                                  totalRate: totalRate)
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
                                          _selectedTypeBroker.value = '';
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
                                        LogicalKeyboardKey.keyA) {
                                      _enableFields();
                                    }
                                  }
                                  if (!_descFocus.hasFocus &&
                                      !_dueDaysFocus.hasFocus &&
                                      !_invoiceFocus.hasFocus) {
                                    if (event.logicalKey ==
                                        LogicalKeyboardKey.keyD) {
                                      if (_isFromEdit) {
                                        defaultController
                                            .deleteSaleData(
                                                id: selectedPolishSaleMstID
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
                                          _selectedTypeBroker.value = '';
                                          setState(() {
                                            _isFromEdit = false;
                                            entries.length = 0;
                                          });
                                        });
                                      } else {
                                        infoDialog(
                                            messageText:
                                                'Please Select Sell Entry to Delete.');
                                      }
                                    }
                                  }
                                  if (!_descFocus.hasFocus &&
                                      !_dueDaysFocus.hasFocus &&
                                      !_invoiceFocus.hasFocus) {
                                    if (event.logicalKey ==
                                        LogicalKeyboardKey.keyC) {
                                      dateController.clear();
                                      dueDateController.clear();
                                      invNoController.clear();
                                      dueDaysController.clear();
                                      dateController.clear();
                                      _selectedTypeParty.value = '';
                                      _selectedType.value = '';
                                      _selectedTypeBroker.value = '';
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
                                      menuController.selectedIndex.value = 0;
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
                                                                  _invoiceFocus
                                                                      .requestFocus(); // Move focus to the first input field
                                                                }); // Handle null case
                                                              }
                                                            : null,
                                                      );
                                                    }),
                                                  ),
                                                ],
                                              ),
                                              buildTextField('INVOICE NO.',
                                                  invNoController,
                                                  focusNode: _invoiceFocus,
                                                  onEditingComplete: () {
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 100), () {
                                                  _dateFocus
                                                      .requestFocus(); // Move focus to the first input field
                                                });
                                              }, isEnabled: _isEnabled),
                                              Focus(
                                                onKeyEvent: (node, event) {
                                                  if (HardwareKeyboard.instance
                                                      .isLogicalKeyPressed(
                                                          LogicalKeyboardKey
                                                              .enter)) {
                                                    _openDatePicker(); // Open date picker when Enter key is pressed
                                                    return KeyEventResult
                                                        .handled;
                                                  }
                                                  return KeyEventResult.ignored;
                                                },
                                                child: buildTextField(
                                                  'DATE',
                                                  dateController,
                                                  focusNode: _dateFocus,
                                                  isEnabled: _isEnabled,
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
                                                        onChanged: _isEnabled
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
                                                            : null,
                                                      );
                                                    }),
                                                  ),
                                                ],
                                              ),
                                              buildTextField(
                                                  'DUE DAYS', dueDaysController,
                                                  focusNode: _dueDaysFocus,
                                                  inputFormatterList: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  onChanged: (value) {
                                                    _updateDueDate();
                                                  },
                                                  isEnabled: _isEnabled,
                                                  onEditingComplete: () {
                                                    Future.delayed(
                                                        const Duration(
                                                            milliseconds: 100),
                                                        () {
                                                      _roughFocNode
                                                          .requestFocus(); // Move focus to the first input field
                                                    });
                                                  }),
                                              buildTextField(
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
                                        4: FlexColumnWidth(1), // AMOUNT column
                                        5: FlexColumnWidth(1), // AMOUNT column
                                        6: FlexColumnWidth(
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
                                              child: Text('STOCK',
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
                                                          updateStockControllerBasedOnType(
                                                              value);
                                                          Future.delayed(
                                                              const Duration(
                                                                  milliseconds:
                                                                      100), () {
                                                            _descFocus
                                                                .requestFocus(); // Move focus to the first input field
                                                          });
                                                        }
                                                      : null,
                                                );
                                              }),
                                            ),
                                            TableCell(
                                              child: buildTextField2(
                                                'DESCRIPTION',
                                                focusNode: _descFocus,
                                                descripController,
                                                isEnabled: _isEnabled,
                                              ),
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
                                              child: buildTextField2(
                                                  'STOCK', stockcontroller,
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
                                // onPressed: _enableFields,
                                onPressed: _enableFields,
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
                                        if (entries.isNotEmpty) {
                                          defaultController
                                              .updateSaleData(
                                                  id: selectedPolishSaleMstID
                                                      .value,
                                                  partyCode:
                                                      _selectedTypeParty.value,
                                                  invoiceNo:
                                                      invNoController.text,
                                                  invoiceDate: selectedDate,
                                                  brokerCode:
                                                      _selectedTypeBroker.value,
                                                  dueDays:
                                                      dueDaysController.text,
                                                  dueDate: dueDate,
                                                  entries: entries,
                                                  totalAmt: totalAmount,
                                                  totalWt: totalWt,
                                                  totalRate: totalRate)
                                              .then((onValue) {
                                            setState(() {
                                              entries.clear();
                                              _isFromEdit = false;
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
                                          _selectedTypeBroker.value = '';
                                        } else {
                                          infoDialog(
                                              messageText:
                                                  'Please Add Rough Data');
                                        }
                                      }
                                    : () async {
                                        if (entries.isNotEmpty) {
                                          defaultController
                                              .addSaleData(
                                                  partyCode:
                                                      _selectedTypeParty.value,
                                                  invoiceNo:
                                                      invNoController.text,
                                                  invoiceDate: selectedDate,
                                                  brokerCode:
                                                      _selectedTypeBroker.value,
                                                  dueDays:
                                                      dueDaysController.text,
                                                  dueDate: dueDate,
                                                  entries: entries,
                                                  totalAmt: totalAmount,
                                                  totalWt: totalWt,
                                                  totalRate: totalRate)
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
                                          _selectedTypeBroker.value = '';
                                        } else {
                                          infoDialog(
                                              messageText:
                                                  'Please Add Rough Data');
                                        }
                                      },
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
                                onPressed: () {
                                  _isFromEdit
                                      ? defaultController
                                          .deleteSaleData(
                                              id: selectedPolishSaleMstID.value,
                                              entries: entries)
                                          .then((onValue) {
                                          dateController.clear();
                                          dueDateController.clear();
                                          dueDaysController.clear();
                                          dateController.clear();
                                          invNoController.clear();
                                          _selectedTypeParty.value = '';
                                          _selectedType.value = '';
                                          _selectedTypeBroker.value = '';
                                          setState(() {
                                            _isFromEdit = false;
                                            entries.length = 0;
                                          });
                                        })
                                      : infoDialog(
                                          messageText:
                                              'Please Select Sale Entry to Delete.');
                                },
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
                                onPressed: () {
                                  dateController.clear();
                                  dueDateController.clear();
                                  invNoController.clear();
                                  dueDaysController.clear();
                                  dateController.clear();
                                  _selectedTypeParty.value = '';
                                  _selectedType.value = '';
                                  _selectedTypeBroker.value = '';
                                  setState(() {
                                    entries.length = 0;
                                    _isFromEdit = false;
                                    _isEnabled = false;
                                  });
                                },
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
                    if (!Responsive.isMobile(context))
                      const SizedBox(width: 16),
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
        1: FlexColumnWidth(60),
        2: FlexColumnWidth(150),
        3: FixedColumnWidth(80),
        4: FixedColumnWidth(80),
        5: FixedColumnWidth(80),
        6: FixedColumnWidth(40),
        7: FixedColumnWidth(40),
        8: FixedColumnWidth(40),
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
                  () => defaultController.isDeleteLoading.value
                      ? const CupertinoActivityIndicator(radius: 10)
                      : GestureDetector(
                          child: const Icon(
                            Icons.delete,
                            size: 15,
                          ),
                          onTap: () {
                            if (_isFromEdit) {
                              defaultController
                                  .deleteSaleRoughData(
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
                    updateStockControllerBasedOnType(entries[index]['rough']!);
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

  Widget _buildDataTable() {
    return DataTable(
      columnSpacing: 10,
      headingRowHeight: 25,
      horizontalMargin: 20,
      dataRowHeight: 30.0,
      columns: const [
        DataColumn(
            label: Text(
          'SR.NO',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        )),
        DataColumn(
            label: Text(
          'ROUGH',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        )),
        DataColumn(
            label: Text(
          'DESCRIPTION',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        )),
        DataColumn(
            label: Text(
          'WT',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        )),
        DataColumn(
            label: Text(
          'RATE',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        )),
        DataColumn(
            label: Text(
          'AMOUNT',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        )),
        DataColumn(
            label: Text(
          '',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        )),
        DataColumn(
            label: Text(
          '',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        )),
      ],
      rows: List<DataRow>.generate(
        entries.length,
        (index) => DataRow(
          cells: [
            DataCell(Text((index + 1).toString(),
                style: const TextStyle(fontSize: 12))),
            DataCell(Text(getRoughName(entries[index]['rough']!),
                style: const TextStyle(fontSize: 12))),
            DataCell(Text(entries[index]['description']!,
                style: const TextStyle(fontSize: 12))),
            DataCell(Text(entries[index]['wt']!,
                style: const TextStyle(fontSize: 12))),
            DataCell(Text(entries[index]['rate']!,
                style: const TextStyle(fontSize: 12))),
            DataCell(Text(entries[index]['amount']!,
                style: const TextStyle(fontSize: 12))),
            DataCell(
              Obx(
                () => defaultController.isDeleteLoading.value
                    ? const CupertinoActivityIndicator()
                    : IconButton(
                        icon: const Icon(
                          Icons.delete,
                          size: 15,
                        ),
                        onPressed: () {
                          setState(() {
                            defaultController
                                .deleteSaleRoughData(
                                    id: int.parse(entries[index]['id']!))
                                .then((onValue) {
                              setState(() {
                                entries.removeAt(index);
                              });
                            });

                            // _updateTotals(); // Recalculate totals after deletion
                          });
                        },
                      ),
              ),
            ),
            DataCell(
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  size: 15,
                ),
                onPressed: () {
                  selectedRoughId.value = entries[index]['id']!;
                  _selectedType.value = entries[index]['rough']!;
                  wtController.text = entries[index]['wt']!;
                  rateController.text = entries[index]['rate']!;
                  descripController.text = entries[index]['description']!;
                  updateStockControllerBasedOnType(entries[index]['rough']!);
                  setState(() {
                    entries.removeAt(index);
                  });
                },
              ),
            ),
          ],
        ),
      )..add(
          DataRow(
            cells: [
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('TOTAL',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              DataCell(
                Text(
                  totalWt.toStringAsFixed(2),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              DataCell(Text(
                totalRate.toStringAsFixed(2),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              )),
              DataCell(
                Text(
                  totalAmount.toStringAsFixed(2),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const DataCell(Text('')),
              const DataCell(Text('')),
            ],
          ),
        ),
    );
  }

  String formatDate(String date) {
    // Parse the date string into a DateTime object
    DateTime parsedDate = DateTime.parse(date);

    // Format the DateTime object into the desired format
    String formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);

    return formattedDate;
  }

  String formatDateWithTime(String date) {
    // Parse the date string into a DateTime object
    DateTime parsedDate = DateTime.parse(date);

    // Format the DateTime object into the desired format
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedDate);

    return formattedDate;
  }

  DateTime dateFormat(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return parsedDate;
  }

  String getRoughName(String? partyCode) {
    final party = defaultController.roughModel.firstWhere(
        (p) => p.roughTypeCode == int.parse(partyCode!),
        orElse: () => RoughModel(roughTypeName: 'Unknown'));
    return party.roughTypeName ?? 'Unknown';
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
    return defaultController.partyMstList
        .where((partyType) => partyType.typeCode == 5)
        .map((partyType) {
      return DropdownMenuItem<String>(
        value: partyType.partyCode.toString(),
        child: Text(partyType.partyName!),
      );
    }).toList();
  }

  void updateStockControllerBasedOnType(String? value) {
    _selectedType.value = value ?? '';

    if (value != null) {
      // Find the corresponding total weight from groupedData
      int code = int.parse(value);
      if (defaultController.groupedData.containsKey(code)) {
        // Update the TextEditingController with the total weight
        stockcontroller.text =
            defaultController.groupedData[code]!.toStringAsFixed(3);
      } else {
        stockcontroller.text = '0.0'; // Default to 0 if not found
      }
    }
  }
}
