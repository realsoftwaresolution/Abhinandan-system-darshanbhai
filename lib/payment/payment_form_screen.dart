import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/payment/account_party_credit_debit_datagrid.dart';
import 'package:real_web_rough_entry_system/payment/book_party_credit_debit_datagrid.dart';
import 'package:real_web_rough_entry_system/header.dart';
import 'package:real_web_rough_entry_system/payment/edit_account_party_credit_debit_datagrid.dart';
import 'package:real_web_rough_entry_system/payment/edit_book_party_credit_debit_datagrid.dart';
import 'package:real_web_rough_entry_system/payment/payment_datagrid.dart';
import 'package:real_web_rough_entry_system/payment/payment_details_model.dart';
import 'package:real_web_rough_entry_system/payment/payment_mst_model.dart';
import 'package:real_web_rough_entry_system/payment/pending_payment_model.dart';
import 'package:real_web_rough_entry_system/purchase/purchase_details_model.dart';
import 'package:real_web_rough_entry_system/rough/rough_details_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PaymentFormScreen extends StatefulWidget {
  final bool showHeader;
  final Map<String, String>? preFilledData;
  final RxList<PaymentDetailsModel>? editAccountPartyCreditDebitDataGridSource;
  final RxList<PaymentDetailsModel>? editBookPartyCreditDebitDataGridSource;
  final RxString? selectedTypeAccountParty;
  final RxString? selectedTypeBookParty;

  const PaymentFormScreen(
      {super.key,
      required this.showHeader,
      this.preFilledData,
      this.editAccountPartyCreditDebitDataGridSource,
      this.editBookPartyCreditDebitDataGridSource,
      this.selectedTypeAccountParty,
      this.selectedTypeBookParty});

  @override
  PaymentFormScreenState createState() => PaymentFormScreenState();
}

class PaymentFormScreenState extends State<PaymentFormScreen> {
  TextEditingController invNoController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController checkNoController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController balance1Controller = TextEditingController();
  TextEditingController balance2Controller = TextEditingController();
  TextEditingController jamaCreditController = TextEditingController();
  TextEditingController udharDebitController = TextEditingController();
  TextEditingController mstIdController = TextEditingController();
  TextEditingController remarks1Controller = TextEditingController();
  TextEditingController bookUdharController = TextEditingController();
  TextEditingController bookCreditController = TextEditingController();
  TextEditingController accountUdharController = TextEditingController();
  TextEditingController accountCreditController = TextEditingController();

  // final TextEditingController remarks2Controller = TextEditingController();

  final FocusNode _bookPartyFocNode = FocusNode();
  final FocusNode _roughFocNode = FocusNode();
  final FocusNode _invoiceFocus = FocusNode();
  final FocusNode _checkNoFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();
  final FocusNode _dateFocus = FocusNode();
  final FocusNode _accountPartyFocus = FocusNode();
  final FocusNode _wtFocus = FocusNode();
  final FocusNode _rateFocus = FocusNode();
  final FocusNode _jamaCreditFocus = FocusNode();
  final FocusNode _udharDebitFocus = FocusNode();
  final FocusNode _remarks1Focus = FocusNode();
  final FocusNode _formKeyBoardFocus = FocusNode();
  final FocusNode _searchKeyBoardFocus = FocusNode();
  final DataGridController _dataGridController = DataGridController();
  final DataGridController _bookDataGridController = DataGridController();
  final DataGridController _accountDataGridController = DataGridController();
  final GlobalKey bookPartyDataGridKey = GlobalKey();
  final GlobalKey accountPartyDataGridKey = GlobalKey();
  List<Map<String, String>> entries = [];
  final RxString _selectedType = ''.obs;
  final RxInt selectedPaymentMstID = 0.obs;
   RxString selectedTypeAccountParty = ''.obs;
   RxString selectedTypeBookParty = ''.obs;

  DateTime? selectedDate;
  String? paymentDay;
  String? dueDate;

  // double? balance;

  double get totalWt =>
      entries.fold(0.0, (prev, e) => prev + double.parse(e['wt']!));

  double get totalRate => totalWt == 0 ? 0 : totalAmount / totalWt;

  double get totalAmount =>
      entries.fold(0.0, (prev, e) => prev + double.parse(e['amount']!));

  double get totalJAmtRsBook => editBookPartyCreditDebitDataGridSource.fold(
      0.0, (prev, e) => prev + e.jAmtRs!);

  double get totalUAmtRsBook => editBookPartyCreditDebitDataGridSource.fold(
      0.0, (prev, e) => prev + e.uAmtRs!);

  double get totalJAmtRsAccount => editAccountPartyCreditDebitDataGridSource
      .fold(0.0, (prev, e) => prev + e.jAmtRs!);

  double get totalUAmtRsAccount => editAccountPartyCreditDebitDataGridSource
      .fold(0.0, (prev, e) => prev + e.uAmtRs!);

  bool _isEnabled = false;
  bool _isCreditEnabled = false;
  bool _isDebitEnabled = false;
  bool _isSearch = false;
  bool _isFromEdit = false;
  final RxBool _isFiltered = false.obs;
  final _formKey = GlobalKey<FormState>();

  DateTime? fromDate;
  DateTime? toDate;
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  final DefaultController defaultController = Get.find<DefaultController>();

  RxList<PaymentMstModel> paymentDataGridSource = <PaymentMstModel>[].obs;
  RxList<PendingPaymentModel> bookPartyCreditDebitDataGridSource =
      <PendingPaymentModel>[].obs;
  RxList<PaymentDetailsModel> editBookPartyCreditDebitDataGridSource =
      <PaymentDetailsModel>[].obs;
  RxList<PendingPaymentModel> accountPartyCreditDebitDataGridSource =
      <PendingPaymentModel>[].obs;
  RxList<PaymentDetailsModel> editAccountPartyCreditDebitDataGridSource =
      <PaymentDetailsModel>[].obs;
  RxList<PaymentMstModel> filteredDataGridSource = <PaymentMstModel>[].obs;

  void _enableFields({bool? needFocus}) {
    setState(() {
      if (needFocus == null || needFocus) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _dateFocus.requestFocus();
          String formattedDate =
              DateFormat('dd-MM-yyyy').format(DateTime.now());
          paymentDay = DateFormat('EEEE').format(DateTime.now());
          selectedDate = DateTime.now();
          dateController.text = '$formattedDate     $paymentDay';
        });
        _isEnabled = true;
        _isCreditEnabled = true;
        _isDebitEnabled = true;
      } else {
        _isEnabled = true;
        _isCreditEnabled = true;
        _isDebitEnabled = true;
      }
    });
  }

  @override
  void initState() {
    // print("PAYMENT SCREENNNNNNNN ::::::: ${widget.preFilledData?['mstId']}");
    // if(widget.preFilledData?['mstId'] != ''){
    //   PaymentMstModel selectedPaymentData =
    //       defaultController.paymentMstList
    //           .firstWhere((e) =>
    //               e.paymentMstID ==
    //               5);
    //
    //   print(selectedPaymentData.chequeNo);
    // }
    // editAccountPartyCreditDebitDataGridSource =
    //     widget.editAccountPartyCreditDebitDataGridSource ??
    //         <PaymentDetailsModel>[].obs;
    // editBookPartyCreditDebitDataGridSource =
    //     widget.editBookPartyCreditDebitDataGridSource ??
    //         <PaymentDetailsModel>[].obs;
    // selectedTypeBookParty = widget.selectedTypeBookParty ?? ''.obs;
    selectedTypeAccountParty = widget.selectedTypeAccountParty ?? ''.obs;
    // invNoController =
    //     TextEditingController(text: widget.preFilledData?['invNo'] ?? '');
    // dateController =
    //     TextEditingController(text: widget.preFilledData?['date'] ?? '');
    // checkNoController =
    //     TextEditingController(text: widget.preFilledData?['checkNo'] ?? '');
    // dueDateController =
    //     TextEditingController(text: widget.preFilledData?['dueDate'] ?? '');
    // balance1Controller =
    //     TextEditingController(text: widget.preFilledData?['balance1'] ?? '');
    // balance2Controller =
    //     TextEditingController(text: widget.preFilledData?['balance2'] ?? '');
    // jamaCreditController =
    //     TextEditingController(text: widget.preFilledData?['jamaCredit'] ?? '');
    // udharDebitController =
    //     TextEditingController(text: widget.preFilledData?['udharDebit'] ?? '');
    // mstIdController =
    //     TextEditingController(text: widget.preFilledData?['mstId'] ?? '');
    // remarks1Controller =
    //     TextEditingController(text: widget.preFilledData?['remarks1'] ?? '');
    // bookUdharController =
    //     TextEditingController(text: widget.preFilledData?['bookUdhar'] ?? '');
    // bookCreditController =
    //     TextEditingController(text: widget.preFilledData?['bookCredit'] ?? '');
    // accountUdharController = TextEditingController(
    //     text: widget.preFilledData?['accountUdhar'] ?? '');
    // accountCreditController = TextEditingController(
    //     text: widget.preFilledData?['accountCredit'] ?? '');
    jamaCreditController.addListener(() {
      if (jamaCreditController.text.isNotEmpty) {
        setState(() {
          // if(_isFromEdit){
          //   bookUdharController.text = (double.parse(jamaCreditController.text) - totalUAmtRsBook).toStringAsFixed(2);
          //   accountCreditController.text = (double.parse(jamaCreditController.text) - totalJAmtRsAccount).toStringAsFixed(2);
          // }
          _isDebitEnabled = false;
          // remarks2Controller.text =
          //     'BEING AMOUNT ADJUSTED FROM ${getPartyName(int.parse(_selectedTypeAccountParty.value))} WITH ON A/C: RS:${jamaCreditController.text}';
        });
      } else {
        setState(() {
          _isDebitEnabled = true;
        });
      }
    });

    udharDebitController.addListener(() {
      if (udharDebitController.text.isNotEmpty) {
        setState(() {
          // if (_isFromEdit) {
          //   bookCreditController.text =
          //       (double.parse(udharDebitController.text) - totalJAmtRsBook)
          //           .toStringAsFixed(2);
          //   accountUdharController.text =
          //       (double.parse(udharDebitController.text) - totalUAmtRsAccount)
          //           .toStringAsFixed(2);
          // }
          _isCreditEnabled = false;
          // remarks2Controller.text =
          //     'BEING AMOUNT ADJUSTED FROM ${getPartyName(int.parse(_selectedTypeBookParty.value))} WITH ON A/C: RS:${udharDebitController.text}';
        });
      } else {
        setState(() {
          _isCreditEnabled = true;
        });
      }
    });
    paymentDataGridSource.value = defaultController.paymentMstList;
    // creditDebitDataGridSource.value = defaultController.creditDebitDataList;
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
    _dateFocus.dispose();
    _bookPartyFocNode.dispose();
    _descFocus.dispose();
    _wtFocus.dispose();
    _rateFocus.dispose();
    _roughFocNode.dispose();
    _accountPartyFocus.dispose();
    _invoiceFocus.dispose();
    _checkNoFocus.dispose();
    _formKeyBoardFocus.dispose();
    _searchKeyBoardFocus.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
  }

  void _scrollToSelectedRow(double index) {
    // Scroll to the currently selected row
    _dataGridController.scrollToRow(index);
  }

  void onSelectBookParty() {
    if (selectedTypeBookParty.isNotEmpty) {
      bookPartyCreditDebitDataGridSource.value = defaultController
          .pendingPaymentList
          .where((e) =>
              e.partyCode == int.parse(selectedTypeBookParty.value) &&
              e.companyCode == defaultController.companyCode.value)
          /*.map((e) => e.copyWith())*/ // Create a copy of each item
          .toList();
      if (kDebugMode) {
        print('BOOK PARTY ${bookPartyCreditDebitDataGridSource.length}');
      }
    }
  }

  void onSelectAccountParty() {
    if (selectedTypeAccountParty.isNotEmpty) {
      accountPartyCreditDebitDataGridSource.value = defaultController
          .pendingPaymentList
          .where((e) =>
              e.partyCode == int.parse(selectedTypeAccountParty.value) &&
              e.companyCode == defaultController.companyCode.value)
          /*.map((e) => e.copyWith())*/ // Create a copy of each item
          .toList();
      if (kDebugMode) {
        print('ACCOUNT PARTY ${accountPartyCreditDebitDataGridSource.length}');
      }
    }
  }

  void _applyDateFilter() {
    if (fromDate != null && toDate != null) {
      _isFiltered.value = true;
      // setState(() {
      filteredDataGridSource.value =
          defaultController.paymentMstList.where((purchase) {
        // Assuming invoiceDate is in 'yyyy-MM-dd' format; adjust as needed
        final paymentDate = DateTime.parse(purchase.paymentDate!);

        // Include the boundaries
        return paymentDate.isAfter(fromDate!) &&
            paymentDate.isBefore(toDate!.add(const Duration(days: 1)));
      }).toList();
      // Update the data grid source with the filtered data
      paymentDataGridSource.value = filteredDataGridSource;
      _searchKeyBoardFocus.requestFocus();
      // });
    } else {
      infoDialog(messageText: 'Please select both From Date and To Date');
    }
  }

  void _removeDateFilter() {
    // Reset the data grid source to the full list
    paymentDataGridSource.value = defaultController.paymentMstList;

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
        paymentDay = DateFormat('EEEE').format(pickedDate);
        String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
        dateController.text = '$formattedDate     $paymentDay';
        Future.delayed(const Duration(milliseconds: 100), () {
          _checkNoFocus.requestFocus(); // Move focus to the first input field
        });
      });
      // _updateDueDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    // return const MultiColumnDropdown();
    return _isSearch == true
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
                  selectedPaymentMstID.value = selectedRow!
                      .getCells()[0]
                      .value; // Assuming the ID is in the first cell

                  // Find the corresponding party data entry with the matching polishSaleMstID
                  PurchaseDetailsModel partyEntry = partyData.firstWhere(
                    (entry) =>
                        entry.roughPurMstID == selectedPaymentMstID.value,
                    // orElse: () => null,
                  );

                  // Collect rough data entries with the matching polishSaleMstID
                  List<RoughDetailsModel> roughEntries = roughData
                      .where((entry) =>
                          entry.roughPurMstID == selectedPaymentMstID.value)
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
                  dateController.text =
                      formatDate(partyEntry.invoiceDate!, showDayOfWeek: true);
                  dueDateController.text = formatDate(partyEntry.dueDate!);
                  // dueDaysController.text = partyEntry.dueDay.toString();
                  selectedTypeBookParty.value = partyEntry.partyCode.toString();
                  selectedTypeAccountParty.value =
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
                    ? const Header(title: 'Payment Search')
                    : const SizedBox.shrink(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: buildTextField(
                          excludeFieldValidation: false,
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
                          excludeFieldValidation: false,
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
                defaultController.isLoading.value
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: LinearProgressIndicator(),
                      )
                    : const SizedBox.shrink(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Obx(
                      () => SfDataGrid(
                        controller: _dataGridController,
                        source: PaymentDataGridSource(paymentDataGridSource),
                        columns: <GridColumn>[
                          GridColumn(
                            columnName: 'Id',
                            visible: false,
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Id',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Date',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Date',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Day',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Day',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Cheque No.',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Cheque No.',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
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
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Account',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Account',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Rate Type',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Rate Type',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Jama AmtRs',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Jama AmtRs',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Udhar AmtRs',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Udhar AmtRs',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Remarks',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Remarks',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Acc. AmtRs',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Acc. AmtRs',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                        tableSummaryRows: [
                          GridTableSummaryRow(
                              title:
                              'Total ${paymentDataGridSource.length}',
                              showSummaryInRow:
                              false,
                              titleColumnSpan: 1,
                              columns: <GridSummaryColumn>[
                                const GridSummaryColumn(
                                    name:
                                    'Jama AmtRs',
                                    columnName:
                                    'Jama AmtRs',
                                    summaryType:
                                    GridSummaryType
                                        .sum),
                                const GridSummaryColumn(
                                    name:
                                    'Udhar AmtRs',
                                    columnName:
                                    'Udhar AmtRs',
                                    summaryType:
                                    GridSummaryType
                                        .sum),
                                const GridSummaryColumn(
                                    name:
                                    'Acc. AmtRs',
                                    columnName:
                                    'Acc. AmtRs',
                                    summaryType:
                                    GridSummaryType
                                        .sum),
                              ],
                              position:
                              GridTableSummaryRowPosition
                                  .bottom)
                        ],
                        rowHeight: 25,
                        headerRowHeight: 35,
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        showSortNumbers: true,
                        allowFiltering: true,
                        selectionMode: SelectionMode.single,
                        onSelectionChanged: (List<DataGridRow> addedRows,
                            List<DataGridRow> removedRows) async {
                          setState(() {
                            entries.length = 0;
                            _isFromEdit = true;
                          });
                          if (addedRows.isNotEmpty) {
                            final DataGridRow selectedRow = addedRows.first;

                            selectedPaymentMstID.value =
                                selectedRow.getCells()[0].value;

                            PaymentMstModel selectedPaymentData =
                                defaultController.paymentMstList.firstWhere(
                                    (e) =>
                                        e.paymentMstID ==
                                        selectedPaymentMstID.value);

                            editBookPartyCreditDebitDataGridSource.value =
                                await defaultController
                                    .getBookPartyPaymentDetails(
                                        selectedPaymentData.partyCode!,
                                        selectedPaymentMstID.value);

                            editAccountPartyCreditDebitDataGridSource.value =
                                await defaultController
                                    .getAccPartyPaymentDetails(
                                        selectedPaymentData.accountCode!,
                                        selectedPaymentMstID.value);

                            mstIdController.text =
                                selectedPaymentMstID.value.toString();
                            balance1Controller.text = getSelectedPartyBalance(
                                    partyCode: selectedPaymentData.partyCode,
                                    isFromEdit: true)
                                .toStringAsFixed(2);
                            balance2Controller.text = getSelectedPartyBalance(
                                    partyCode: selectedPaymentData.accountCode,
                                    isFromEdit: true)
                                .toStringAsFixed(2);
                            checkNoController.text =
                                selectedPaymentData.chequeNo!;
                            dateController.text = formatDate(
                                selectedPaymentData.paymentDate!,
                                showDayOfWeek: true);
                            jamaCreditController.text =
                                selectedPaymentData.jAmtRs!.toStringAsFixed(2);
                            udharDebitController.text =
                                selectedPaymentData.uAmtRs!.toStringAsFixed(2);
                            remarks1Controller.text =
                                selectedPaymentData.remarks1!;
                            selectedTypeBookParty.value =
                                selectedPaymentData.partyCode.toString();
                            selectedTypeAccountParty.value =
                                selectedPaymentData.accountCode.toString();
                            if (selectedPaymentData.jAmtRs! > 0.00) {
                              bookUdharController.text =
                                  (double.parse(jamaCreditController.text) -
                                          totalUAmtRsBook)
                                      .toStringAsFixed(2);
                              accountCreditController.text =
                                  (double.parse(jamaCreditController.text) -
                                          totalJAmtRsAccount)
                                      .toStringAsFixed(2);
                            } else if (selectedPaymentData.uAmtRs! > 0.00) {
                              bookCreditController.text =
                                  (double.parse(udharDebitController.text) -
                                          totalJAmtRsBook)
                                      .toStringAsFixed(2);
                              accountUdharController.text =
                                  (double.parse(udharDebitController.text) -
                                          totalUAmtRsAccount)
                                      .toStringAsFixed(2);
                            }
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
        // ? const SizedBox.shrink()
        : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                widget.showHeader
                    ? const Header(title: 'Payment')
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
                              // onKeyEvent: (KeyEvent event) {
                              //   if (event is KeyDownEvent) {
                              //     if (!_descFocus.hasFocus &&
                              //         !_remarks1Focus.hasFocus &&
                              //         !_checkNoFocus.hasFocus &&
                              //         !_invoiceFocus.hasFocus) {
                              //       if (!HardwareKeyboard
                              //               .instance.isShiftPressed &&
                              //           event.logicalKey ==
                              //               LogicalKeyboardKey.keyS &&
                              //           _isEnabled) {
                              //         if (_isFromEdit) {
                              //           if (entries.isNotEmpty) {
                              //             defaultController
                              //                 .updatePurchaseData(
                              //                     id: selectedPaymentMstID
                              //                         .value,
                              //                     partyCode:
                              //                         selectedTypeBookParty
                              //                             .value,
                              //                     invoiceNo:
                              //                         invNoController.text,
                              //                     invoiceDate: selectedDate,
                              //                     brokerCode:
                              //                         selectedTypeAccountParty
                              //                             .value,
                              //                     // dueDays:
                              //                     // dueDaysController.text,
                              //                     dueDate: dueDate,
                              //                     onlyDueDate:
                              //                         dueDateController.text,
                              //                     entries: entries,
                              //                     totalAmt: totalAmount,
                              //                     totalWt: totalWt,
                              //                     totalRate: totalRate)
                              //                 .then((onValue) {
                              //               setState(() {
                              //                 entries.clear();
                              //                 _isEnabled = false;
                              //                 _isFromEdit = false;
                              //               });
                              //             });
                              //
                              //             dateController.clear();
                              //             dueDateController.clear();
                              //             // dueDaysController.clear();
                              //             dateController.clear();
                              //             invNoController.clear();
                              //             selectedTypeBookParty.value = '';
                              //             _selectedType.value = '';
                              //             selectedTypeAccountParty.value = '';
                              //           } else {
                              //             infoDialog(
                              //                 messageText:
                              //                     'Please Add Rough Data');
                              //           }
                              //         } else {
                              //           if (entries.isNotEmpty) {
                              //             defaultController
                              //                 .addPurchaseData(
                              //                     partyCode:
                              //                         selectedTypeBookParty
                              //                             .value,
                              //                     invoiceNo:
                              //                         invNoController.text,
                              //                     invoiceDate: selectedDate,
                              //                     brokerCode:
                              //                         selectedTypeAccountParty
                              //                             .value,
                              //                     // dueDays:
                              //                     // dueDaysController.text,
                              //                     dueDate: dueDate,
                              //                     onlyDueDate:
                              //                         dueDateController.text,
                              //                     entries: entries,
                              //                     totalRate: totalRate,
                              //                     totalAmt: totalAmount,
                              //                     totalWt: totalWt)
                              //                 .then((onValue) {
                              //               setState(() {
                              //                 entries.clear();
                              //                 _isEnabled = false;
                              //               });
                              //             });
                              //
                              //             dateController.clear();
                              //             dueDateController.clear();
                              //             // dueDaysController.clear();
                              //             dateController.clear();
                              //             invNoController.clear();
                              //             selectedTypeBookParty.value = '';
                              //             _selectedType.value = '';
                              //             selectedTypeAccountParty.value = '';
                              //           } else {
                              //             infoDialog(
                              //                 messageText:
                              //                     'Please Add Rough Data');
                              //           }
                              //         }
                              //       }
                              //     }
                              //     if (!_descFocus.hasFocus &&
                              //         !_remarks1Focus.hasFocus &&
                              //         !_checkNoFocus.hasFocus &&
                              //         !_invoiceFocus.hasFocus) {
                              //       if (event.logicalKey ==
                              //               LogicalKeyboardKey.keyA &&
                              //           !_isEnabled) {
                              //         _enableFields();
                              //       }
                              //     }
                              //     if (!_descFocus.hasFocus &&
                              //         !_remarks1Focus.hasFocus &&
                              //         !_checkNoFocus.hasFocus &&
                              //         !_invoiceFocus.hasFocus) {
                              //       if (event.logicalKey ==
                              //               LogicalKeyboardKey.keyD &&
                              //           _isEnabled &&
                              //           _isFromEdit) {
                              //         if (_isFromEdit) {
                              //           defaultController
                              //               .deletePurchaseData(
                              //                   id: selectedPaymentMstID.value,
                              //                   entries: entries)
                              //               .then((onValue) {
                              //             dateController.clear();
                              //             dueDateController.clear();
                              //             // dueDaysController.clear();
                              //             dateController.clear();
                              //             invNoController.clear();
                              //             selectedTypeBookParty.value = '';
                              //             _selectedType.value = '';
                              //             selectedTypeAccountParty.value = '';
                              //             setState(() {
                              //               _isFromEdit = false;
                              //               entries.length = 0;
                              //             });
                              //           });
                              //         } else {
                              //           infoDialog(
                              //               messageText:
                              //                   'Please Select Purchase Entry to Delete.');
                              //         }
                              //       }
                              //     }
                              //     if (!_descFocus.hasFocus &&
                              //         !_remarks1Focus.hasFocus &&
                              //         !_checkNoFocus.hasFocus &&
                              //         !_invoiceFocus.hasFocus) {
                              //       if (event.logicalKey ==
                              //               LogicalKeyboardKey.keyC &&
                              //           _isEnabled) {
                              //         dateController.clear();
                              //         invNoController.clear();
                              //         dueDateController.clear();
                              //         // dueDaysController.clear();
                              //         dateController.clear();
                              //         selectedTypeBookParty.value = '';
                              //         _selectedType.value = '';
                              //         selectedTypeAccountParty.value = '';
                              //         setState(() {
                              //           entries.length = 0;
                              //           _isFromEdit = false;
                              //           _isEnabled = false;
                              //         });
                              //       }
                              //     }
                              //     if (!_descFocus.hasFocus &&
                              //         !_remarks1Focus.hasFocus &&
                              //         !_checkNoFocus.hasFocus &&
                              //         !_invoiceFocus.hasFocus) {
                              //       if (event.logicalKey ==
                              //           LogicalKeyboardKey.keyE) {
                              //         menuController.selectedIndex.value = 0;
                              //       }
                              //     }
                              //     if (!_descFocus.hasFocus &&
                              //         !_remarks1Focus.hasFocus &&
                              //         !_checkNoFocus.hasFocus &&
                              //         !_invoiceFocus.hasFocus) {
                              //       if (HardwareKeyboard
                              //               .instance.isShiftPressed &&
                              //           event.logicalKey ==
                              //               LogicalKeyboardKey.keyS) {
                              //         setState(() {
                              //           _isSearch = true;
                              //         });
                              //       }
                              //     }
                              //   }
                              // },
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
                                            bottom:
                                                BorderSide(color: Colors.grey),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            _buildRow(<Widget>[
                                              buildTextField(
                                                  'MST ID', mstIdController,
                                                  excludeFieldValidation: true,
                                                  isEnabled: false),
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
                                              buildTextField(
                                                  'CHECK NO.',
                                                  excludeFieldValidation: false,
                                                  checkNoController,
                                                  focusNode: _checkNoFocus,
                                                  // inputFormatterList: [
                                                  //   FilteringTextInputFormatter
                                                  //       .digitsOnly
                                                  // ],
                                                  onEditingComplete: () {
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 100), () {
                                                  _bookPartyFocNode
                                                      .requestFocus(); // Move focus to the first input field
                                                });
                                              }, onChanged: (value) {
                                                // _updateDueDate();
                                              }, isEnabled: _isEnabled),
                                              const SizedBox(
                                                width: 50,
                                              ),
                                            ]),
                                            const SizedBox(height: 10),
                                            _buildRow([
                                              Row(
                                                children: [
                                                  const Text(
                                                    'BOOK PARTY',
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
                                                            _bookPartyFocNode,
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                        value: selectedTypeBookParty
                                                                .value.isEmpty
                                                            ? null
                                                            : selectedTypeBookParty
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
                                                                selectedTypeBookParty
                                                                        .value =
                                                                    value ?? '';
                                                                // Fetch the selected party
                                                                var selectedParty =
                                                                    defaultController
                                                                        .partyMstList
                                                                        .firstWhere(
                                                                  (partyType) =>
                                                                      partyType
                                                                          .partyCode
                                                                          .toString() ==
                                                                      value,
                                                                );

                                                                onSelectBookParty();

                                                                balance1Controller
                                                                    .text = getSelectedPartyBalance(
                                                                        selectedParty:
                                                                            selectedParty)
                                                                    .toStringAsFixed(
                                                                        2);
                                                                // onSelectBookParty();
                                                                Future.delayed(
                                                                    const Duration(
                                                                        milliseconds:
                                                                            100),
                                                                    () {
                                                                  _accountPartyFocus
                                                                      .requestFocus(); // Move focus to the first input field
                                                                }); // Handle null case
                                                              }
                                                            : null,
                                                        selectedItemBuilder:
                                                            (BuildContext
                                                                context) {
                                                          return dropdownItemsParty.map(
                                                              (DropdownMenuItem<
                                                                      String>
                                                                  item) {
                                                            return Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(item.value !=
                                                                          null &&
                                                                      selectedTypeBookParty
                                                                          .isNotEmpty
                                                                  ? getPartyName(
                                                                      int.parse(
                                                                          selectedTypeBookParty
                                                                              .value))
                                                                  : ''),
                                                            );
                                                          }).toList();
                                                        },
                                                      );
                                                    }),
                                                  ),
                                                ],
                                              ),
                                              buildTextField(
                                                excludeFieldValidation: false,
                                                'BALANCE (BOOK)',
                                                balance1Controller,
                                                isEnabled:
                                                    false, // Disable input since it's auto-filled
                                              ),

                                              // _buildTextField('PURID', 'AUTO', purIdController),
                                            ]),
                                            const SizedBox(height: 10),
                                            _buildRow([
                                              Row(
                                                children: [
                                                  const Text(
                                                    'ACCOUNT PARTY',
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
                                                            _accountPartyFocus,
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                        value: selectedTypeAccountParty
                                                                .value.isEmpty
                                                            ? null
                                                            : selectedTypeAccountParty
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
                                                                selectedTypeAccountParty
                                                                        .value =
                                                                    value ?? '';
                                                                var selectedParty =
                                                                    defaultController
                                                                        .partyMstList
                                                                        .firstWhere(
                                                                  (partyType) =>
                                                                      partyType
                                                                          .partyCode
                                                                          .toString() ==
                                                                      value,
                                                                );
                                                          onSelectAccountParty();
                                                                // Update balance in the balanceController
                                                                balance2Controller
                                                                    .text = getSelectedPartyBalance(
                                                                        selectedParty:
                                                                            selectedParty)
                                                                    .toStringAsFixed(
                                                                        2);
                                                                // onSelectAccountParty();
                                                                Future.delayed(
                                                                    const Duration(
                                                                        milliseconds:
                                                                            100),
                                                                    () {
                                                                  _jamaCreditFocus
                                                                      .requestFocus(); // Move focus to the first input field
                                                                }); // Handle null case
                                                              }
                                                            : null,
                                                        selectedItemBuilder:
                                                            (BuildContext
                                                                context) {
                                                          return dropdownItemsParty.map(
                                                              (DropdownMenuItem<
                                                                      String>
                                                                  item) {
                                                            return Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(item.value !=
                                                                          null &&
                                                                      selectedTypeAccountParty
                                                                          .isNotEmpty
                                                                  ? getPartyName(
                                                                      int.parse(
                                                                          selectedTypeAccountParty
                                                                              .value))
                                                                  : ''),
                                                            );
                                                          }).toList();
                                                        },
                                                      );
                                                    }),
                                                  ),
                                                ],
                                              ),
                                              buildTextField(
                                                'BALANCE (ACCOUNT)',
                                                excludeFieldValidation: false,

                                                balance2Controller,
                                                isEnabled:
                                                    false, // Disable input since it's auto-filled
                                              ),
                                            ]),
                                            const SizedBox(height: 10),
                                            _buildRow([
                                              buildTextField(
                                                  'JAMA (CREDIT)',
                                                  focusNode: _jamaCreditFocus,
                                                  excludeFieldValidation: true,
                                                  jamaCreditController,
                                                  isEnabled: _isCreditEnabled,
                                                  onEditingComplete: () {
                                                if (_isDebitEnabled) {
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 100),
                                                      () {
                                                    _udharDebitFocus
                                                        .requestFocus(); // Move focus to the first input field
                                                  });
                                                } else {
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 100),
                                                      () {
                                                    _remarks1Focus
                                                        .requestFocus(); // Move focus to the first input field
                                                  });
                                                }
                                              }, onChanged: (value) {
                                                if (_isFromEdit) {
                                                  bookUdharController
                                                      .text = (double.tryParse(
                                                              jamaCreditController
                                                                  .text) ?? 0.00 -
                                                          totalUAmtRsBook)
                                                      .toStringAsFixed(2);
                                                  accountCreditController
                                                      .text = (double.tryParse(
                                                              jamaCreditController
                                                                  .text) ?? 0.00 -
                                                          totalJAmtRsAccount)
                                                      .toStringAsFixed(2);
                                                } else {
                                                  bookUdharController.text =
                                                      value;
                                                  accountCreditController.text =
                                                      value;
                                                }
                                              }),
                                              buildTextField('UDHAR (DEBIT)',
                                                  udharDebitController,
                                                  focusNode: _udharDebitFocus,
                                                  excludeFieldValidation: true,
                                                  isEnabled: _isDebitEnabled,
                                                  onEditingComplete: () {
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 100), () {
                                                  _remarks1Focus
                                                      .requestFocus(); // Move focus to the first input field
                                                });
                                              }, onChanged: (value) {
                                                if (_isFromEdit) {
                                                  bookCreditController
                                                      .text = (double.tryParse(
                                                              udharDebitController
                                                                  .text) ?? 0.00 -
                                                          totalJAmtRsBook)
                                                      .toStringAsFixed(2);
                                                  accountUdharController
                                                      .text = (double.tryParse(
                                                              udharDebitController
                                                                  .text) ?? 0.00 -
                                                          totalUAmtRsAccount)
                                                      .toStringAsFixed(2);
                                                } else {
                                                  bookCreditController.text =
                                                      value;
                                                  accountUdharController.text =
                                                      value;
                                                }
                                              } // Disable input since it's auto-filled
                                                  ),
                                            ]),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            _buildRow([
                                              buildTextField('REMARKS 1',
                                                  remarks1Controller,
                                                  excludeFieldValidation: false,
                                                  focusNode: _remarks1Focus,
                                                  isEnabled: _isEnabled,
                                                  onEditingComplete: () {
                                                if (selectedTypeBookParty
                                                        .isNotEmpty &&
                                                    selectedTypeAccountParty
                                                        .isNotEmpty) {
                                                  _remarks1Focus.unfocus();
                                                  // FocusScope.of(context).unfocus();
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 10),
                                                      () {
                                                    // Move focus to SfDataGrid

                                                    // int lastIndex = bookPartyCreditDebitDataGridSource.length - 1;  // Select the first row
                                                    if (udharDebitController
                                                        .text.isNotEmpty) {
                                                      _bookDataGridController
                                                          .beginEdit(
                                                              RowColumnIndex(
                                                                  0, 3));
                                                    } else {
                                                      _bookDataGridController
                                                          .beginEdit(
                                                              RowColumnIndex(
                                                                  0, 4));
                                                    }
                                                    // Step 3: Start editing a specific cell (rowIndex 0, columnIndex 1 for "Jama Rs")
                                                  }); // This will remove focus from the Remarks field
                                                }
                                              } // Disable input since it's auto-filled
                                                  ),
                                              // buildTextField(
                                              //   'REMARKS 2',
                                              //   remarks2Controller,
                                              //   isEnabled:
                                              //       false, // Disable input since it's auto-filled
                                              // ),
                                            ]),
                                          ],
                                        )),
                                    const SizedBox(height: 10),
                                    Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(5)),
                                            color: Colors.black87),
                                        child: const Text(
                                          'OUTSTANDING LIST (BOOK )',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white),
                                        )),
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(color: Colors.grey),
                                          left: BorderSide(color: Colors.grey),
                                          right: BorderSide(color: Colors.grey),
                                          bottom:
                                              BorderSide(color: Colors.grey),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          _buildRow([
                                            buildTextField(
                                              'On Account JAMA (CREDIT)',
                                              bookCreditController,
                                              excludeFieldValidation: true,
                                              isEnabled:
                                                  false, // Disable input since it's auto-filled
                                            ),
                                            buildTextField(
                                              'UDHAR (DEBIT)',
                                              excludeFieldValidation: true,
                                              bookUdharController,
                                              isEnabled:
                                                  false, // Disable input since it's auto-filled
                                            ),
                                            const SizedBox(
                                              width: 50,
                                            ),
                                          ]),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                              height: 150,
                                              child: Obx(
                                                () => SfDataGrid(
                                                    key: bookPartyDataGridKey,
                                                    controller:
                                                        _bookDataGridController,
                                                    source: _isFromEdit
                                                        ? EditBookPartyCreditDebitDataGrid(
                                                            editBookPartyCreditDebitDataGridSource,
                                                            _accountDataGridController,
                                                            udharDebitController,
                                                            bookUdharController,
                                                            bookCreditController,
                                                            jamaCreditController)
                                                        : BookPartyCreditDebitDataGrid(
                                                            bookPartyCreditDebitDataGridSource,
                                                            _accountDataGridController,
                                                            udharDebitController,
                                                            bookUdharController,
                                                            bookCreditController,
                                                            jamaCreditController),
                                                    columns: <GridColumn>[
                                                      GridColumn(
                                                        columnName: 'Id',
                                                        allowEditing: false,
                                                        visible: false,
                                                        label: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Text(
                                                            'Id',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ),
                                                      GridColumn(
                                                        columnName: 'Due Date',
                                                        allowEditing: false,
                                                        label: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Text(
                                                            'Due Date',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ),
                                                      GridColumn(
                                                        columnName: 'Inv No',
                                                        allowEditing: false,
                                                        label: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Text(
                                                            'Inv No',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ),
                                                      GridColumn(
                                                        columnName: 'Jama Rs',
                                                        allowEditing:
                                                            bookCreditController
                                                                    .text
                                                                    .isNotEmpty
                                                                ? true
                                                                : false,
                                                        label: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Text(
                                                            'Jama Rs',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ),
                                                      GridColumn(
                                                        columnName: 'Udhar Rs',
                                                        allowEditing:
                                                            bookUdharController
                                                                    .text
                                                                    .isNotEmpty
                                                                ? true
                                                                : false,
                                                        label: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Text(
                                                            'Udhar Rs',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ),
                                                      GridColumn(
                                                        columnName: 'Out AmtRs',
                                                        allowEditing: false,
                                                        label: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Text(
                                                            'Out AmtRs',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ),
                                                      GridColumn(
                                                        columnName: 'Trn Type',
                                                        allowEditing: false,
                                                        label: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Text(
                                                            'Trn Type',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ),
                                                      GridColumn(
                                                        columnName: 'TraType',
                                                        allowEditing: false,
                                                        label: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Text(
                                                            'TraType',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ),
                                                      GridColumn(
                                                        columnName: 'Inv Date',
                                                        allowEditing: false,
                                                        label: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Text(
                                                            'Inv Date',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ),
                                                      GridColumn(
                                                        allowEditing: false,
                                                        columnName: 'Dr/Cr',
                                                        label: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Text(
                                                            'Dr/Cr',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ),
                                                      GridColumn(
                                                        columnName: 'Amt Rs',
                                                        allowEditing: false,
                                                        label: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Text(
                                                            'Amt Rs',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                    gridLinesVisibility:
                                                        GridLinesVisibility
                                                            .both,
                                                    // Both horizontal and vertical grid lines
                                                    headerGridLinesVisibility:
                                                        GridLinesVisibility
                                                            .both,
                                                    tableSummaryRows: [
                                                      GridTableSummaryRow(
                                                          title:
                                                              'Total ${bookPartyCreditDebitDataGridSource.length}',
                                                          showSummaryInRow:
                                                              false,
                                                          titleColumnSpan: 1,
                                                          columns: <GridSummaryColumn>[
                                                            const GridSummaryColumn(
                                                                name:
                                                                    'JamaRsSum',
                                                                columnName:
                                                                    'Jama Rs',
                                                                summaryType:
                                                                    GridSummaryType
                                                                        .sum),
                                                            const GridSummaryColumn(
                                                                name:
                                                                    'OutAmtRsSum',
                                                                columnName:
                                                                    'Out AmtRs',
                                                                summaryType:
                                                                    GridSummaryType
                                                                        .sum),
                                                            const GridSummaryColumn(
                                                                name:
                                                                    'UdharRsSum',
                                                                columnName:
                                                                    'Udhar Rs',
                                                                summaryType:
                                                                    GridSummaryType
                                                                        .sum),
                                                            const GridSummaryColumn(
                                                                name:
                                                                    'AmtRsSum',
                                                                columnName:
                                                                    'Amt Rs',
                                                                summaryType:
                                                                    GridSummaryType
                                                                        .sum),
                                                          ],
                                                          position:
                                                              GridTableSummaryRowPosition
                                                                  .bottom)
                                                    ],
                                                    columnWidthMode:
                                                        ColumnWidthMode.auto,
                                                    navigationMode:
                                                        GridNavigationMode.cell,
                                                    frozenColumnsCount: 1,
                                                    rowHeight: 25,
                                                    headerRowHeight: 35,
                                                    showSortNumbers: true,
                                                    allowFiltering: true,
                                                    selectionMode:
                                                        SelectionMode.single,
                                                    allowEditing: true,
                                                    editingGestureType:
                                                        EditingGestureType.tap),
                                              ))
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(5)),
                                            color: Colors.black87),
                                        child: const Text(
                                          'OUTSTANDING LIST (ACCOUNT)',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white),
                                        )),
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(color: Colors.grey),
                                          left: BorderSide(color: Colors.grey),
                                          right: BorderSide(color: Colors.grey),
                                          bottom:
                                              BorderSide(color: Colors.grey),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          _buildRow([
                                            buildTextField(
                                              'On Account JAMA (CREDIT)',
                                              excludeFieldValidation: true,
                                              accountCreditController,
                                              isEnabled:
                                                  false, // Disable input since it's auto-filled
                                            ),
                                            buildTextField(
                                              'UDHAR (DEBIT)',
                                              accountUdharController,
                                              excludeFieldValidation: true,
                                              isEnabled:
                                                  false, // Disable input since it's auto-filled
                                            ),
                                            const SizedBox(
                                              width: 50,
                                            ),
                                          ]),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            height: 150,
                                            child: Obx(
                                              () => SfDataGrid(
                                                  key: accountPartyDataGridKey,
                                                  controller:
                                                      _accountDataGridController,
                                                  source: _isFromEdit
                                                      ? EditAccountPartyCreditDebitDataGrid(
                                                          editAccountPartyCreditDebitDataGridSource,
                                                          udharDebitController,
                                                          accountUdharController,
                                                          accountCreditController,
                                                          jamaCreditController)
                                                      : AccountPartyCreditDebitDataGrid(
                                                          accountPartyCreditDebitDataGridSource,
                                                          udharDebitController,
                                                          accountUdharController,
                                                          accountCreditController,
                                                          jamaCreditController),
                                                  columns: <GridColumn>[
                                                    GridColumn(
                                                      columnName: 'Id',
                                                      allowEditing: false,
                                                      visible: false,
                                                      label: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Text(
                                                          'Id',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                    GridColumn(
                                                      columnName: 'Due Date',
                                                      allowEditing: false,
                                                      label: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Text(
                                                          'Due Date',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                    GridColumn(
                                                      columnName: 'Inv No',
                                                      allowEditing: false,
                                                      label: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Text(
                                                          'Inv No',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                    GridColumn(
                                                      columnName: 'Jama Rs',
                                                      allowEditing:
                                                          accountCreditController
                                                                  .text
                                                                  .isNotEmpty
                                                              ? true
                                                              : false,
                                                      label: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Text(
                                                          'Jama Rs',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                    GridColumn(
                                                      columnName: 'Udhar Rs',
                                                      allowEditing:
                                                          accountUdharController
                                                                  .text
                                                                  .isNotEmpty
                                                              ? true
                                                              : false,
                                                      label: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Text(
                                                          'Udhar Rs',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                    GridColumn(
                                                      columnName: 'Out AmtRs',
                                                      allowEditing: false,
                                                      label: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Text(
                                                          'Out AmtRs',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                    GridColumn(
                                                      columnName: 'Trn Type',
                                                      allowEditing: false,
                                                      label: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Text(
                                                          'Trn Type',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                    GridColumn(
                                                      columnName: 'TraType',
                                                      allowEditing: false,
                                                      label: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Text(
                                                          'TraType',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                    GridColumn(
                                                      columnName: 'Inv Date',
                                                      allowEditing: false,
                                                      label: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Text(
                                                          'Inv Date',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                    GridColumn(
                                                      columnName: 'Dr/Cr',
                                                      allowEditing: false,
                                                      label: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Text(
                                                          'Dr/Cr',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                    GridColumn(
                                                      columnName: 'Amt Rs',
                                                      allowEditing: false,
                                                      label: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Text(
                                                          'Amt Rs',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  tableSummaryRows: [
                                                    GridTableSummaryRow(
                                                        title:
                                                            'Total ${accountPartyCreditDebitDataGridSource.length}',
                                                        showSummaryInRow: false,
                                                        titleColumnSpan: 1,
                                                        columns: <GridSummaryColumn>[
                                                          const GridSummaryColumn(
                                                              name: 'JamaRsSum',
                                                              columnName:
                                                                  'Jama Rs',
                                                              summaryType:
                                                                  GridSummaryType
                                                                      .sum),
                                                          const GridSummaryColumn(
                                                              name:
                                                                  'OutAmtRsSum',
                                                              columnName:
                                                                  'Out AmtRs',
                                                              summaryType:
                                                                  GridSummaryType
                                                                      .sum),
                                                          const GridSummaryColumn(
                                                              name:
                                                                  'UdharRsSum',
                                                              columnName:
                                                                  'Udhar Rs',
                                                              summaryType:
                                                                  GridSummaryType
                                                                      .sum),
                                                          const GridSummaryColumn(
                                                              name: 'AmtRsSum',
                                                              columnName:
                                                                  'Amt Rs',
                                                              summaryType:
                                                                  GridSummaryType
                                                                      .sum),
                                                        ],
                                                        position:
                                                            GridTableSummaryRowPosition
                                                                .bottom)
                                                  ],
                                                  columnWidthMode:
                                                      ColumnWidthMode.auto,
                                                  frozenColumnsCount: 1,
                                                  navigationMode:
                                                      GridNavigationMode.cell,
                                                  rowHeight: 25,
                                                  headerRowHeight: 35,
                                                  gridLinesVisibility:
                                                      GridLinesVisibility.both,
                                                  headerGridLinesVisibility:
                                                      GridLinesVisibility.both,
                                                  showSortNumbers: true,
                                                  // allowSorting: true,
                                                  // allowMultiColumnSorting: true,
                                                  allowFiltering: true,
                                                  selectionMode:
                                                      SelectionMode.single,
                                                  allowEditing: true,
                                                  editingGestureType:
                                                      EditingGestureType.tap
                                                  // onSelectionChanged: (List<DataGridRow> selectedRows) {
                                                  //   // Handle row selection change if needed
                                                  // },),
                                                  ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(16.0),
                          //   child: Container(
                          //       decoration: BoxDecoration(
                          //           border: Border.all(color: Colors.grey)),
                          //       // padding: const EdgeInsets.all(8.0),
                          //       child: _buildRoughTable()),
                          // ),
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
                                        // if (editAccountPartyCreditDebitDataGridSource
                                        //         .isNotEmpty ||
                                        //     editBookPartyCreditDebitDataGridSource
                                        //         .isNotEmpty) {
                                          defaultController
                                              .updatePaymentData(
                                            mstId: selectedPaymentMstID.value,
                                            bookJAmtRs: double.tryParse(
                                                    bookCreditController
                                                        .text) ??
                                                0.00,
                                            bookUAmtRs: double.tryParse(
                                                    bookUdharController.text) ??
                                                0.00,
                                            accJAmtRs: double.tryParse(
                                                    accountCreditController
                                                        .text) ??
                                                0.00,
                                            accUAmtRs: double.tryParse(
                                                    accountUdharController
                                                        .text) ??
                                                0.00,
                                            accountDataGridSource:
                                                editAccountPartyCreditDebitDataGridSource,
                                            bookDataGridSource:
                                                editBookPartyCreditDebitDataGridSource,
                                            paymentDate: selectedDate,
                                            paymentDay: paymentDay,
                                            chequeNo: checkNoController.text,
                                            jAmtRs: double.tryParse(
                                                    jamaCreditController
                                                        .text) ??
                                                0.00,
                                            uAmtRs: double.tryParse(
                                                    udharDebitController
                                                        .text) ??
                                                0.00,
                                            remarks1: remarks1Controller.text,
                                            pAmtRs: double.tryParse(
                                                    udharDebitController
                                                        .text) ??
                                                0.00,
                                            aAmtRs: double.tryParse(
                                                    jamaCreditController
                                                        .text) ??
                                                0.00,
                                            partyCode: int.parse(
                                                selectedTypeBookParty.value),
                                            accountCode: int.parse(
                                                selectedTypeAccountParty.value),
                                          )
                                              .then((onValue) {
                                            dateController.clear();
                                            dueDateController.clear();
                                            remarks1Controller.clear();
                                            jamaCreditController.clear();
                                            udharDebitController.clear();
                                            checkNoController.clear();
                                            balance1Controller.clear();
                                            balance2Controller.clear();
                                            bookCreditController.clear();
                                            bookUdharController.clear();
                                            accountUdharController
                                                .clear();
                                            accountCreditController
                                                .clear();
                                            selectedTypeBookParty.value =
                                            '';
                                            selectedTypeAccountParty
                                                .value = '';
                                            editAccountPartyCreditDebitDataGridSource
                                                .clear();
                                            editBookPartyCreditDebitDataGridSource
                                                .clear();
                                            setState(() {
                                              entries.clear();
                                              _isEnabled = false;
                                            });
                                          });
                                         /* }else {
                                          infoDialog(
                                              messageText:
                                                  'Please Add Rough Data');
                                        }*/
                                      }
                                    : _isEnabled
                                        ? () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              // print(bookPartyCreditDebitDataGridSource.length);
                                              // print(accountPartyCreditDebitDataGridSource.length);
                                              // if (accountPartyCreditDebitDataGridSource
                                              //         .isNotEmpty ||
                                              //     bookPartyCreditDebitDataGridSource
                                              //         .isNotEmpty) {
                                                defaultController
                                                    .addPaymentData(
                                                  bookJAmtRs: double.tryParse(
                                                          bookCreditController
                                                              .text) ??
                                                      0.00,
                                                  bookUAmtRs: double.tryParse(
                                                          bookUdharController
                                                              .text) ??
                                                      0.00,
                                                  accJAmtRs: double.tryParse(
                                                          accountCreditController
                                                              .text) ??
                                                      0.00,
                                                  accUAmtRs: double.tryParse(
                                                          accountUdharController
                                                              .text) ??
                                                      0.00,
                                                  accountDataGridSource:
                                                      accountPartyCreditDebitDataGridSource,
                                                  bookDataGridSource:
                                                      bookPartyCreditDebitDataGridSource,
                                                  paymentDate: selectedDate,
                                                  paymentDay: paymentDay,
                                                  chequeNo:
                                                      checkNoController.text,
                                                  jAmtRs: double.tryParse(
                                                          jamaCreditController
                                                              .text) ??
                                                      0.00,
                                                  uAmtRs: double.tryParse(
                                                          udharDebitController
                                                              .text) ??
                                                      0.00,
                                                  remarks1:
                                                      remarks1Controller.text,
                                                  pAmtRs: double.tryParse(
                                                          udharDebitController
                                                              .text) ??
                                                      0.00,
                                                  aAmtRs: double.tryParse(
                                                          jamaCreditController
                                                              .text) ??
                                                      0.00,
                                                  partyCode: int.parse(
                                                      selectedTypeBookParty
                                                          .value),
                                                  accountCode: int.parse(
                                                      selectedTypeAccountParty
                                                          .value),
                                                )
                                                    .then((onValue) {
                                                  dateController.clear();
                                                  dueDateController.clear();
                                                  remarks1Controller.clear();
                                                  jamaCreditController.clear();
                                                  udharDebitController.clear();
                                                  checkNoController.clear();
                                                  balance1Controller.clear();
                                                  balance2Controller.clear();
                                                  bookCreditController.clear();
                                                  bookUdharController.clear();
                                                  accountUdharController
                                                      .clear();
                                                  accountCreditController
                                                      .clear();
                                                  selectedTypeBookParty.value =
                                                      '';
                                                  selectedTypeAccountParty
                                                      .value = '';
                                                  accountPartyCreditDebitDataGridSource
                                                      .clear();
                                                  bookPartyCreditDebitDataGridSource
                                                      .clear();
                                                  setState(() {
                                                    entries.clear();
                                                    _isEnabled = false;
                                                  });
                                                });
                                              // } else {
                                              //   infoDialog(
                                              //       messageText:
                                              //           'Please Book or Account Payment Data');
                                              // }
                                            } else {
                                              infoDialog(
                                                  messageText:
                                                      'Please Add Missing Data');
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
                                onPressed: _isFromEdit && _isEnabled
                                    ? () {
                                        defaultController
                                            .deletePaymentData(
                                                id: selectedPaymentMstID.value)
                                            .then((onValue) {
                                          dateController.clear();
                                          dueDateController.clear();
                                          remarks1Controller.clear();
                                          jamaCreditController.clear();
                                          udharDebitController.clear();
                                          checkNoController.clear();
                                          balance1Controller.clear();
                                          balance2Controller.clear();
                                          bookCreditController.clear();
                                          bookUdharController.clear();
                                          mstIdController.clear();
                                          accountUdharController.clear();
                                          accountCreditController.clear();
                                          selectedTypeBookParty.value = '';
                                          selectedTypeAccountParty.value = '';
                                          editAccountPartyCreditDebitDataGridSource
                                              .clear();
                                          editBookPartyCreditDebitDataGridSource
                                              .clear();
                                          setState(() {
                                            entries.clear();
                                            _isEnabled = false;
                                            _isFromEdit = false;
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
                                                text: 'D', // Underlined "D"
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
                                        invNoController.clear();
                                        dueDateController.clear();
                                        accountPartyCreditDebitDataGridSource
                                            .clear();
                                        bookPartyCreditDebitDataGridSource
                                            .clear();
                                        remarks1Controller.clear();
                                        // remarks2Controller.clear();
                                        jamaCreditController.clear();
                                        udharDebitController.clear();
                                        balance1Controller.clear();
                                        balance2Controller.clear();
                                        checkNoController.clear();
                                        bookUdharController.clear();
                                        bookCreditController.clear();
                                        accountCreditController.clear();
                                        accountUdharController.clear();
                                        // dueDaysController.clear();
                                        dateController.clear();
                                        selectedTypeBookParty.value = '';
                                        _selectedType.value = '';
                                        selectedTypeAccountParty.value = '';
                                        mstIdController.clear();
                                        setState(() {
                                          entries.length = 0;
                                          _isFromEdit = false;
                                          _isEnabled = false;
                                          _isDebitEnabled = false;
                                          _isCreditEnabled = false;
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
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: _isFromEdit && _isEnabled
                                    ? () async {
                                        // final invoiceGenerator =
                                        //     InvoiceGenerator();
                                        // final pdfData = await invoiceGenerator
                                        //     .generateInvoice(
                                        //         id: defaultController
                                        //                 .purchaseDataList
                                        //                 .length +
                                        //             1,
                                        //         invoiceDate: selectedDate!,
                                        //         invoiceNo: invNoController.text,
                                        //         partyCode:
                                        //             _selectedTypeParty.value,
                                        //         brokerCode:
                                        //             _selectedTypeBroker.value,
                                        //         dueDate: dueDateController.text,
                                        //         // dueDays: dueDaysController.text,
                                        //         entries: entries,
                                        //         totalWt: totalWt,
                                        //         totalAmt: totalAmount,
                                        //         totalRate: totalRate);
                                        // await Printing.layoutPdf(
                                        //   onLayout:
                                        //       (PdfPageFormat format) async =>
                                        //           pdfData,
                                        // );
                                      }
                                    : null,
                                child: const Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'P', // Underlined "A"
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
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

  List<DropdownMenuItem<String>> get dropdownItems {
    return defaultController.roughModel.map((partyType) {
      return DropdownMenuItem<String>(
        value: partyType.roughTypeCode.toString(),
        child: Text(partyType.roughTypeName!),
      );
    }).toList();
  }

  // List<DropdownMenuItem<String>> get dropdownItemsParty {
  //   return defaultController.partyMstList
  //       .where((partyType) =>
  //           // partyType.typeCode == 1 &&
  //           partyType.companyCode ==
  //           defaultController.companyCode.value /*|| partyType.typeCode == 5*/)
  //       .map((partyType) {
  //     // Get the list of credit and debit transactions for this party
  //     var partyTransactions = defaultController.creditDebitDataList
  //         .where((cd) => cd.partyCode == partyType.partyCode)
  //         .toList();
  //
  //     double sumCredit = partyTransactions.fold(0.0, (previousValue, cd) {
  //       return previousValue + (cd.creditRs ?? 0);
  //     });
  //     double sumDebit = partyTransactions.fold(0.0, (previousValue, cd) {
  //       return previousValue + (cd.debitRs ?? 0);
  //     });
  //
  //     // Calculate the balance: sum credits, subtract debits
  //     double balance = (sumCredit - sumDebit) +
  //         ((partyType.creditOpBalRs ?? 0) - (partyType.debitOpBalRs ?? 0));
  //
  //     return DropdownMenuItem<String>(
  //       value: partyType.partyCode.toString(),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(partyType.partyName!),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               Text(getPartyType(partyType.typeCode!)),
  //             ],
  //           ), // Party name
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(balance.abs().toStringAsFixed(2)),
  //               const SizedBox(width: 10),
  //               Text(balance > 0 ? "Cr" : "Dr"),
  //               // Cr or Dr based on balance// Display balance
  //             ],
  //           ),
  //         ],
  //       ),
  //     );
  //   }).toList();
  // }
  List<DropdownMenuItem<String>> get dropdownItemsParty {
    return defaultController.partyMstList
        .where((partyType) =>
    partyType.companyCode == defaultController.companyCode.value)
        .map((partyType) {
      // Calculate transactions and balance
      var partyTransactions = defaultController.creditDebitDataList
          .where((cd) => cd.partyCode == partyType.partyCode)
          .toList();

      double sumCredit = partyTransactions.fold(0.0, (previousValue, cd) {
        return previousValue + (cd.creditRs ?? 0);
      });
      double sumDebit = partyTransactions.fold(0.0, (previousValue, cd) {
        return previousValue + (cd.debitRs ?? 0);
      });

      double balance = (sumCredit - sumDebit) +
          ((partyType.creditOpBalRs ?? 0) - (partyType.debitOpBalRs ?? 0));

      // Get background color based on party type
      Color backgroundColor = getPartyTypeColor(partyType.typeCode!);
      IconData icon = getPartyTypeIcon(partyType.typeCode!);
      bool showProfileIcon = !const {3, 4, 6, 7, 10}.contains(partyType.typeCode);

      return DropdownMenuItem<String>(
        value: partyType.partyCode.toString(),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(0.1),
            // border: Border.all(color: backgroundColor, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  // border: Border.all(color: backgroundColor, width: 1),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(icon, size: 12, color: Colors.white,),
                    const SizedBox(width: 3),
                    Text(
                      getPartyType(partyType.typeCode!),
                      style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      showProfileIcon ? const Icon(Icons.person, size: 14) : const SizedBox.shrink(),
                      showProfileIcon ? const SizedBox(width: 3,): const SizedBox.shrink(),
                      Text(
                        partyType.partyName!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "₹ ${balance.abs().toStringAsFixed(2)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: balance > 0 ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        balance > 0 ? "Cr" : "Dr",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: balance > 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

}
