import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/party-ledger/credit_debit_datagrid.dart';
import 'package:real_web_rough_entry_system/credit-debit/credit_debit_model.dart';
import 'package:real_web_rough_entry_system/header.dart';
import 'package:real_web_rough_entry_system/party-ledger/outstanding_payment_datagrid.dart';
import 'package:real_web_rough_entry_system/party-ledger/outstanding_payment_details_model.dart';
import 'package:real_web_rough_entry_system/payment/payment_details_model.dart';
import 'package:real_web_rough_entry_system/report/memo_pending_report_datagrid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PartyLedgerFormScreen extends StatefulWidget {
  final bool showHeader;

  const PartyLedgerFormScreen({super.key, required this.showHeader});

  @override
  State<PartyLedgerFormScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<PartyLedgerFormScreen> {
  DateTime? fromDate;
  DateTime? toDate;
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController creditTotalController = TextEditingController();
  final TextEditingController debitTotalController = TextEditingController();
  final TextEditingController debitBalanceController = TextEditingController();
  final TextEditingController creditBalanceController = TextEditingController();

  final TextEditingController crOpeningBalanceController =
      TextEditingController();
  final TextEditingController drOpeningBalanceController =
      TextEditingController();
  final GlobalKey bookPartyDataGridKey = GlobalKey();
  final GlobalKey bookPartyDataGridKey2 = GlobalKey();

  final FocusNode _partyFocus = FocusNode();
  final FocusNode _fromDateFocus = FocusNode();
  final FocusNode _toDateFocus = FocusNode();

  final RxString _selectedTypeParty = ''.obs;
  final RxBool _isFiltered = false.obs;
  final RxDouble openingBalance = 0.00.obs;
  final RxInt selectedPaymentMstID = 0.obs;
  RxList<PaymentDetailsModel> editBookPartyCreditDebitDataGridSource =
      <PaymentDetailsModel>[].obs;
  RxList<PaymentDetailsModel> editAccountPartyCreditDebitDataGridSource =
      <PaymentDetailsModel>[].obs;

  // final RxList<String> _selectedTypeBrokers = <String>[].obs;
  // final RxList<String> _selectedTypeRoughs = <String>[].obs;

  final DataGridController _dataGridController = DataGridController();

  // RxList<Pa> purchaseDataGridSource =
  //     <PurchaseDetailsModel>[].obs;
  RxList<CreditDebitMstModel> filteredDataGridSource =
      <CreditDebitMstModel>[].obs;
  RxList<CreditDebitMstModel> creditDebitDataGridSource =
      <CreditDebitMstModel>[].obs;
  RxList<OutstandingPaymentDetails> outstandingPaymentDataGridSource =
      <OutstandingPaymentDetails>[].obs;

  late MemoPendingReportDataGridSource dataGridSource;

  @override
  void initState() {
    dataGridSource = MemoPendingReportDataGridSource();
    super.initState();
  }

  void _applyDateFilter() async {
    if (fromDate != null && toDate != null) {
      _isFiltered.value = true;

      outstandingPaymentDataGridSource.value =
          await defaultController.getOutstandingPaymentDetails(
              partyCode: int.parse(_selectedTypeParty.value),
              fromDate: fromDate!,
              toDate: toDate!);

      final openingBalanceEntries = defaultController.creditDebitDataList
          .where((data) {
            final invoiceDate = DateTime.parse(data.invDate!);
            return invoiceDate.isBefore(fromDate!) &&
                invoiceDate.isBefore(toDate!.add(const Duration(days: 1)));
          })
          .where((e) => e.partyCode.toString() == _selectedTypeParty.value)
          .toList();

      final openingCrTotal = openingBalanceEntries.fold<double>(
        0.0,
        (sum, item) => sum + (item.creditRs ?? 0.0),
      );
      final openingDrTotal = openingBalanceEntries.fold<double>(
        0.0,
        (sum, item) => sum + (item.debitRs ?? 0.0),
      );
      openingBalance.value = openingCrTotal - openingDrTotal;

      if (openingBalance >= 0) {
        crOpeningBalanceController.text = openingBalance.toStringAsFixed(2);
        drOpeningBalanceController.text = '0.00';
      } else {
        drOpeningBalanceController.text =
            openingBalance.abs().toStringAsFixed(2);
        crOpeningBalanceController.text = '0.00';
      }

      // Filter data within the specified date range and selected party code
      filteredDataGridSource.value = defaultController.creditDebitDataList
          .where((purchase) {
            final invoiceDate = DateTime.parse(purchase.invDate!);
            return invoiceDate.isAfter(fromDate!) &&
                invoiceDate.isBefore(toDate!.add(const Duration(days: 1)));
          })
          .where((e) => e.partyCode.toString() == _selectedTypeParty.value)
          .toList();

      // outstandingPaymentDataGridSource.value = defaultController.pendingPaymentList.where((e)=> e.partyCode.toString() == _selectedTypeParty.value).toList();

      // Calculate the sums of Cr Rs and Dr Rs columns within the date range
      final crTotal = filteredDataGridSource.fold<double>(
        0.0,
        (sum, item) => sum + (item.creditRs ?? 0.0),
      );
      final drTotal = filteredDataGridSource.fold<double>(
        0.0,
        (sum, item) => sum + (item.debitRs ?? 0.0),
      );
      final balance = crTotal - drTotal;

      creditTotalController.text = crTotal.toStringAsFixed(2);
      debitTotalController.text = drTotal.toStringAsFixed(2);

      // Set balance display based on whether it's a credit or debit
      if (balance >= 0) {
        creditBalanceController.text =
            (balance + double.parse(crOpeningBalanceController.text))
                .toStringAsFixed(2);
        debitBalanceController.text = '0.00';
      } else {
        debitBalanceController.text =
            (balance.abs() + double.parse(drOpeningBalanceController.text))
                .toStringAsFixed(2);
        creditBalanceController.text = '0.00';
      }

      // Update the data grid source with the filtered data
      creditDebitDataGridSource.value = filteredDataGridSource;
    } else {
      infoDialog(messageText: 'Please select both From Date and To Date');
    }
  }

  void _removeDateFilter() {
    // Reset the data grid source to the full list
    creditDebitDataGridSource.clear();
    outstandingPaymentDataGridSource.clear();

    // Clear filter values
    toDateController.clear();
    fromDateController.clear();
    fromDate = null;
    toDate = null;

    _isFiltered.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          widget.showHeader
              ? const Header(title: 'Party Ledger')
              : const SizedBox.shrink(),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KeyboardListener(
                        focusNode: FocusNode(),
                        autofocus: true,
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Column(
                              children: [
                                buildRow([
                                  Row(
                                    children: [
                                      const Text(
                                        'A/C',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                          fontSize:
                                              12, // Font size for the label
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Obx(() {
                                          return DropdownButtonFormField<
                                              String>(
                                            focusNode: _partyFocus,
                                            style:
                                                const TextStyle(fontSize: 12),
                                            value:
                                                _selectedTypeParty.value.isEmpty
                                                    ? null
                                                    : _selectedTypeParty.value,
                                            decoration: const InputDecoration(
                                              errorStyle: TextStyle(
                                                height: 0,
                                                // Hides the error message
                                                fontSize:
                                                    0, // Ensures no space is taken by the error message
                                              ),
                                              focusedErrorBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.red,
                                                  width:
                                                      1.0, // Thin border width
                                                ),
                                                borderRadius: BorderRadius
                                                    .zero, // Squared corners
                                              ),
                                              errorBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.red,
                                                  width:
                                                      1.0, // Thin border width
                                                ),
                                                borderRadius: BorderRadius
                                                    .zero, // Squared corners
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.blue,
                                                  width:
                                                      1.0, // Thin border width
                                                ),
                                                borderRadius: BorderRadius
                                                    .zero, // Squared corners
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width:
                                                      1.0, // Thin border width
                                                ),
                                                borderRadius: BorderRadius
                                                    .zero, // Squared corners
                                              ),
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                vertical: 8,
                                                horizontal: 8,
                                              ),
                                            ),
                                            items: dropdownItemsParty,
                                            onChanged: (value) {
                                              _selectedTypeParty.value =
                                                  value ?? '';
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 100), () {
                                                _fromDateFocus
                                                    .requestFocus(); // Move focus to the first input field
                                              }); // Handle null case
                                            },
                                            selectedItemBuilder:
                                                (BuildContext context) {
                                              return dropdownItemsParty.map(
                                                  (DropdownMenuItem<String>
                                                      item) {
                                                return Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(item.value !=
                                                              null &&
                                                          _selectedTypeParty
                                                              .isNotEmpty
                                                      ? getPartyName(int.parse(
                                                          _selectedTypeParty
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
                                    'From Date',
                                    focusNode: _fromDateFocus,
                                    fromDateController,
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      if (pickedDate != null) {
                                        dataGridSource.setFromDate(pickedDate);
                                        setState(() {
                                          fromDate = pickedDate;
                                          fromDateController.text =
                                              DateFormat('dd-MM-yyyy')
                                                  .format(fromDate!);
                                          if (toDateController
                                              .text.isNotEmpty) {
                                            _applyDateFilter();
                                          }
                                        });
                                        Future.delayed(
                                            const Duration(milliseconds: 100),
                                            () {
                                          _toDateFocus
                                              .requestFocus(); // Move focus to the first input field
                                        });
                                      }
                                    },
                                  ),
                                  buildTextField(
                                    excludeFieldValidation: false,
                                    'To Date',
                                    focusNode: _toDateFocus,
                                    toDateController,
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      if (pickedDate != null) {
                                        dataGridSource.setToDate(pickedDate);

                                        setState(() {
                                          toDate = pickedDate;
                                          toDateController.text =
                                              DateFormat('dd-MM-yyyy')
                                                  .format(toDate!);
                                          if (fromDateController
                                              .text.isNotEmpty) {
                                            _applyDateFilter();
                                          }
                                        });
                                      }
                                    },
                                  ),

                                  // _buildTextField('PURID', 'AUTO', purIdController),
                                ]),
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: _applyDateFilter,
                            // onPressed: _enableFields,
                            // onPressed: !_isEnabled ? _enableFields : null,
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
                                    text: 'how', // Normal "dd"
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () {
                              _removeDateFilter();
                              dataGridSource.clearFilter();
                              fromDateController.clear();
                              toDateController.clear();
                              _selectedTypeParty.value = '';
                              crOpeningBalanceController.clear();
                              drOpeningBalanceController.clear();
                              creditBalanceController.clear();
                              creditTotalController.clear();
                              debitBalanceController.clear();
                              debitTotalController.clear();
                              // _selectedTypeBrokers.value = [];
                              // _selectedTypeRoughs.value = [];

                              // menuController.selectedIndex.value = 0;
                            },
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
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () {
                              // menuController.selectedIndex.value = 0;
                              tabController
                                  .removeTab(tabController.currentIndex.value);
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
                      const SizedBox(
                        height: 5,
                      ),

                      // Align(
                      //   alignment: Alignment.topRight,
                      //   child: Container(
                      //       padding: const EdgeInsets.all(5),
                      //       decoration: const BoxDecoration(
                      //           borderRadius: BorderRadius.only(
                      //               topLeft: Radius.circular(5),
                      //               topRight: Radius.circular(5)),
                      //           color: Colors.black87),
                      //       child: Row(
                      //         children: [
                      //           const Text(
                      //             'OUTSTANDING LIST (BOOK )',
                      //             style: TextStyle(
                      //                 fontSize: 12,
                      //                 fontWeight: FontWeight.w900,
                      //                 color: Colors.white),
                      //           ),
                      //         ],
                      //       )),
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              CreditDebitDataGrid(creditDebitDataGridSource,
                                      openingBalance.value)
                                  .exportToPdf(
                                      context,
                                      getPartyName(int.tryParse(
                                          _selectedTypeParty.value)),
                                      formatDateFromDateTime(
                                          fromDate ?? DateTime.now()),
                                      formatDateFromDateTime(
                                          toDate ?? DateTime.now()));
                            },
                            tooltip: 'Print as PDF',
                            icon: const Icon(
                              Icons.print,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              CreditDebitDataGrid(creditDebitDataGridSource,
                                      openingBalance.value)
                                  .exportToExcel(
                                      getPartyName(int.tryParse(
                                          _selectedTypeParty.value)),
                                      formatDateFromDateTime(
                                          fromDate ?? DateTime.now()),
                                      formatDateFromDateTime(
                                          toDate ?? DateTime.now()));
                            },
                            tooltip: 'Export as Excel',
                            icon: SvgPicture.asset(
                              'assets/icons/excel.svg',
                              height: 20,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey),
                            left: BorderSide(color: Colors.grey),
                            right: BorderSide(color: Colors.grey),
                            bottom: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: Column(
                          children: [
                            buildRow([
                              buildTextField(
                                'CR OPENING BALANCE',
                                crOpeningBalanceController,
                                excludeFieldValidation: true,
                                isEnabled:
                                    false, // Disable input since it's auto-filled
                              ),
                              buildTextField(
                                'DR OPENING BALANCE',
                                excludeFieldValidation: true,
                                drOpeningBalanceController,
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
                            Column(
                              children: [
                                Obx(
                                  () => defaultController.isLoading.value
                                      ? const LinearProgressIndicator()
                                      : const SizedBox.shrink(),
                                ),
                                SizedBox(
                                  height: 150,
                                  child: Obx(
                                    () => SfDataGrid(
                                      key: bookPartyDataGridKey2,
                                      controller: _dataGridController,
                                      source: CreditDebitDataGrid(
                                          creditDebitDataGridSource,
                                          openingBalance.value),
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
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'Date',
                                          allowEditing: false,
                                          visible: true,
                                          label: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Date',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'Particulars',
                                          allowEditing: false,
                                          label: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Particulars',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'Inv No',
                                          allowEditing: false,
                                          label: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Inv No',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'Cr Rs',
                                          allowEditing:
                                              crOpeningBalanceController
                                                      .text.isNotEmpty
                                                  ? true
                                                  : false,
                                          label: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Cr Rs',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'Dr Rs',
                                          allowEditing:
                                              drOpeningBalanceController
                                                      .text.isNotEmpty
                                                  ? true
                                                  : false,
                                          label: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Dr Rs',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'Closing Rs',
                                          allowEditing: false,
                                          label: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Closing Rs',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'Remarks',
                                          allowEditing: false,
                                          label: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Remarks',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                      gridLinesVisibility:
                                          GridLinesVisibility.both,
                                      // Both horizontal and vertical grid lines
                                      headerGridLinesVisibility:
                                          GridLinesVisibility.both,
                                      columnWidthMode: ColumnWidthMode.auto,
                                      navigationMode: GridNavigationMode.cell,
                                      frozenColumnsCount: 1,
                                      rowHeight: 25,
                                      headerRowHeight: 35,
                                      showSortNumbers: true,
                                      allowFiltering: true,
                                      selectionMode: SelectionMode.single,
                                      // onSelectionChanged: (List<DataGridRow>
                                      //         addedRows,
                                      //     List<DataGridRow> removedRows) async {
                                      /*setState(() {
                                          entries.length = 0;
                                          _isFromEdit = true;
                                        });*/
                                      // if (addedRows.isNotEmpty) {
                                      // final DataGridRow selectedRow =
                                      //     addedRows.first;

                                      // print(selectedRow.getCells()[0].value);

                                      // selectedPaymentMstID.value =
                                      //     selectedRow.getCells()[0].value;
                                      // print(selectedPaymentMstID.value);

                                      // PaymentMstModel selectedPaymentData =
                                      //     defaultController.paymentMstList
                                      //         .firstWhere((e) =>
                                      //             e.paymentMstID ==
                                      //             selectedPaymentMstID
                                      //                 .value);

                                      // editBookPartyCreditDebitDataGridSource
                                      //         .value =
                                      //     await defaultController
                                      //         .getBookPartyPaymentDetails(
                                      //             selectedPaymentData
                                      //                 .partyCode!,
                                      //             selectedPaymentMstID
                                      //                 .value);
                                      // editAccountPartyCreditDebitDataGridSource
                                      //         .value =
                                      //     await defaultController
                                      //         .getAccPartyPaymentDetails(
                                      //             selectedPaymentData
                                      //                 .accountCode!,
                                      //             selectedPaymentMstID
                                      //                 .value);

                                      // mstIdController.text =
                                      //     selectedPaymentMstID.value
                                      //         .toString();
                                      // balance1Controller.text =
                                      //     getSelectedPartyBalance(
                                      //             partyCode:
                                      //                 selectedPaymentData
                                      //                     .partyCode,
                                      //             isFromEdit: true)
                                      //         .toStringAsFixed(2);
                                      // balance2Controller.text =
                                      //     getSelectedPartyBalance(
                                      //             partyCode:
                                      //                 selectedPaymentData
                                      //                     .accountCode,
                                      //             isFromEdit: true)
                                      //         .toStringAsFixed(2);
                                      // checkNoController.text =
                                      //     selectedPaymentData.chequeNo!;
                                      // dateController.text = formatDate(
                                      //     selectedPaymentData.paymentDate!,
                                      //     showDayOfWeek: true);
                                      // jamaCreditController.text =
                                      //     selectedPaymentData.jAmtRs!
                                      //         .toStringAsFixed(2);
                                      // udharDebitController.text =
                                      //     selectedPaymentData.uAmtRs!
                                      //         .toStringAsFixed(2);
                                      // remarks1Controller.text =
                                      //     selectedPaymentData.remarks1!;
                                      // selectedTypeBookParty.value =
                                      //     selectedPaymentData.partyCode
                                      //         .toString();
                                      // selectedTypeAccountParty.value =
                                      //     selectedPaymentData.accountCode
                                      //         .toString();
                                      // if (selectedPaymentData.jAmtRs! >
                                      //     0.00) {
                                      // bookUdharController.text =
                                      //     (double.parse(
                                      //                 jamaCreditController
                                      //                     .text) -
                                      //             totalUAmtRsBook)
                                      //         .toStringAsFixed(2);
                                      //   accountCreditController.text =
                                      //       (double.parse(
                                      //                   jamaCreditController
                                      //                       .text) -
                                      //               totalJAmtRsAccount)
                                      //           .toStringAsFixed(2);
                                      // } else if (selectedPaymentData
                                      //         .uAmtRs! >
                                      //     0.00) {
                                      // bookCreditController.text =
                                      //     (double.parse(
                                      //                 udharDebitController
                                      //                     .text) -
                                      //             totalJAmtRsBook)
                                      //         .toStringAsFixed(2);
                                      // accountUdharController.text =
                                      //     (double.parse(
                                      //                 udharDebitController
                                      //                     .text) -
                                      //             totalUAmtRsAccount)
                                      //         .toStringAsFixed(2);
                                      // }
                                      // _enableFields();
                                      // setState(() {
                                      // _isSearch = false;
                                      // });
                                      // tabController.addTab(TabItem(
                                      //     view: PaymentFormScreen(
                                      //       showHeader: false,
                                      //       editAccountPartyCreditDebitDataGridSource:
                                      //           editAccountPartyCreditDebitDataGridSource,
                                      //       editBookPartyCreditDebitDataGridSource:
                                      //           editBookPartyCreditDebitDataGridSource,
                                      //       // selectedTypeBookParty:
                                      //       //     selectedPaymentData
                                      //       //         .partyCode
                                      //       //         .toString()
                                      //       //         .obs,
                                      //       // selectedTypeAccountParty:
                                      //       //     selectedPaymentData
                                      //       //         .accountCode
                                      //       //         .toString()
                                      //       //         .obs,
                                      //       preFilledData: {
                                      //         // 'invNo': '12345',
                                      //         // 'date': formatDate(
                                      //         //     selectedPaymentData
                                      //         //         .paymentDate!,
                                      //         //     showDayOfWeek: true),
                                      //         // 'date' : '2024-10-30',
                                      //         // 'checkNo': selectedPaymentData
                                      //         //     .chequeNo!,
                                      //         // 'dueDate': '2024-11-30',
                                      //         // 'balance1':
                                      //         //     getSelectedPartyBalance(
                                      //         //             partyCode:
                                      //         //                 selectedPaymentData
                                      //         //                     .partyCode,
                                      //         //             isFromEdit: true)
                                      //         //         .toStringAsFixed(2),
                                      //         // 'balance2': getSelectedPartyBalance(
                                      //         //         partyCode:
                                      //         //             selectedPaymentData
                                      //         //                 .accountCode,
                                      //         //         isFromEdit: true)
                                      //         //     .toStringAsFixed(2),
                                      //         // 'jamaCredit':
                                      //         //     selectedPaymentData
                                      //         //         .jAmtRs!
                                      //         //         .toStringAsFixed(2),
                                      //         // 'udharDebit':
                                      //         //     selectedPaymentData
                                      //         //         .uAmtRs!
                                      //         //         .toStringAsFixed(2),
                                      //         'mstId': selectedPaymentMstID
                                      //             .value
                                      //             .toString(),
                                      //         // 'remarks1':
                                      //         //     selectedPaymentData
                                      //         //         .remarks1!,
                                      //         // 'bookUdhar': '4000',
                                      //         // 'bookCredit': '6000',
                                      //         // 'accountUdhar': '7000',
                                      //         // 'accountCredit': '8000',
                                      //       },
                                      //     ),
                                      //     label: 'Payment',
                                      //     icon: const Icon(Icons.payment)));
                                      // }
                                      // },
                                      // allowEditing: true,
                                      // editingGestureType:
                                      // EditingGestureType.tap,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            buildRow([
                              buildTextField(
                                'CREDIT TOTAL',
                                creditTotalController,
                                excludeFieldValidation: true,
                                isEnabled:
                                    false, // Disable input since it's auto-filled
                              ),
                              buildTextField(
                                'DEBIT TOTAL',
                                excludeFieldValidation: true,
                                debitTotalController,
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
                            buildRow([
                              buildTextField(
                                'BALANCE',
                                creditBalanceController,
                                excludeFieldValidation: true,
                                isEnabled:
                                    false, // Disable input since it's auto-filled
                              ),
                              buildTextField(
                                'BALANCE',
                                excludeFieldValidation: true,
                                debitBalanceController,
                                isEnabled:
                                    false, // Disable input since it's auto-filled
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                            ]),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5)),
                                  color: Colors.black87),
                              child: const Text(
                                'OUTSTANDING',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white),
                              )),
                          IconButton(
                              onPressed: () {
                                OutstandingPaymentDataGrid(
                                        outstandingPaymentDataGridSource)
                                    .exportToPdf(
                                        context,
                                        getPartyName(int.tryParse(
                                            _selectedTypeParty.value)),
                                        formatDateFromDateTime(
                                            fromDate ?? DateTime.now()),
                                        formatDateFromDateTime(
                                            toDate ?? DateTime.now()));
                              },
                              tooltip: 'Print as PDF',
                              icon: const Icon(
                                Icons.print,
                                color: Colors.black,
                              )),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey),
                            left: BorderSide(color: Colors.grey),
                            right: BorderSide(color: Colors.grey),
                            bottom: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: Column(
                          children: [
                            Obx(
                              () => defaultController.isLoading.value
                                  ? const LinearProgressIndicator()
                                  : const SizedBox.shrink(),
                            ),
                            SizedBox(
                              height: 150,
                              child: Obx(
                                () => SfDataGrid(
                                    key: bookPartyDataGridKey,
                                    controller: _dataGridController,
                                    source: OutstandingPaymentDataGrid(
                                        outstandingPaymentDataGridSource),
                                    columns: <GridColumn>[
                                      GridColumn(
                                        columnName: 'Inv No',
                                        allowEditing: false,
                                        visible: true,
                                        label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Inv No',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Inv Date',
                                        allowEditing: false,
                                        label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Inv Date',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Due Days',
                                        allowEditing: false,
                                        label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Due Days',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Due Date',
                                        label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Due Date',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Trn Type',
                                        label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Trn Type',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Dr/Cr',
                                        allowEditing: false,
                                        label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Dr/Cr',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Amt Rs',
                                        allowEditing: false,
                                        label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Amt Rs',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Balance AmtRs',
                                        allowEditing: false,
                                        label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Balance AmtRs',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Status',
                                        allowEditing: false,
                                        label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Status',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        allowEditing: false,
                                        columnName: 'Avg Days',
                                        label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Avg Days',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Late Days',
                                        allowEditing: false,
                                        label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Late Days',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                    gridLinesVisibility:
                                        GridLinesVisibility.both,
                                    // Both horizontal and vertical grid lines
                                    headerGridLinesVisibility:
                                        GridLinesVisibility.both,
                                    // tableSummaryRows: [
                                    //   GridTableSummaryRow(
                                    //       title: 'Total',
                                    //       showSummaryInRow: false,
                                    //       titleColumnSpan: 1,
                                    //       columns: <GridSummaryColumn>[
                                    //         const GridSummaryColumn(
                                    //             name: 'JamaRsSum',
                                    //             columnName: 'Jama Rs',
                                    //             summaryType: GridSummaryType.sum),
                                    //         const GridSummaryColumn(
                                    //             name: 'OutAmtRsSum',
                                    //             columnName: 'Out AmtRs',
                                    //             summaryType: GridSummaryType.sum),
                                    //         const GridSummaryColumn(
                                    //             name: 'UdharRsSum',
                                    //             columnName: 'Udhar Rs',
                                    //             summaryType: GridSummaryType.sum),
                                    //         const GridSummaryColumn(
                                    //             name: 'AmtRsSum',
                                    //             columnName: 'Amt Rs',
                                    //             summaryType: GridSummaryType.sum),
                                    //       ],
                                    //       position:
                                    //           GridTableSummaryRowPosition.bottom)
                                    // ],
                                    columnWidthMode: ColumnWidthMode.auto,
                                    navigationMode: GridNavigationMode.cell,
                                    frozenColumnsCount: 1,
                                    rowHeight: 25,
                                    headerRowHeight: 35,
                                    showSortNumbers: true,
                                    allowFiltering: true,
                                    selectionMode: SelectionMode.single,
                                    // allowEditing: true,
                                    editingGestureType: EditingGestureType.tap),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropdownItemsReport {
    return reportList.map((reportName) {
      return DropdownMenuItem<String>(
        value: reportName.toString(),
        child: Text(reportName),
      );
    }).toList();
  }

// Convert partyMstList to MultiSelectItem list
  List<DropdownItem<String>> get multiDropdownItemsParty {
    return defaultController.partyMstList
        .where((partyType) =>
            partyType.typeCode == 1 &&
            partyType.companyCode == defaultController.companyCode.value)
        .map((partyType) {
      return DropdownItem<String>(
        value: partyType.partyCode.toString(),
        label: partyType.partyName!,
      );
    }).toList();
  }

  List<DropdownItem<String>> get multiDropdownItemsBroker {
    return defaultController.partyMstList
        .where((partyType) =>
            partyType.typeCode == 5 &&
            partyType.companyCode == defaultController.companyCode.value)
        .map((partyType) {
      return DropdownItem<String>(
        value: partyType.partyCode.toString(),
        label: partyType.partyName!,
      );
    }).toList();
  }

// Convert partyMstList to MultiSelectItem list
//   List<DropdownMenuItem<String>> get dropdownItemsParty {
//     return defaultController.partyMstList
//         .where((partyType) =>
//             // partyType.typeCode == 1 &&
//             partyType.companyCode ==
//             defaultController.companyCode.value /*|| partyType.typeCode == 5*/)
//         .map((partyType) {
//       // Get the list of credit and debit transactions for this party
//       var partyTransactions = defaultController.creditDebitDataList
//           .where((cd) => cd.partyCode == partyType.partyCode)
//           .toList();
//
//       double sumCredit = partyTransactions.fold(0.0, (previousValue, cd) {
//         return previousValue + (cd.creditRs ?? 0);
//       });
//       double sumDebit = partyTransactions.fold(0.0, (previousValue, cd) {
//         return previousValue + (cd.debitRs ?? 0);
//       });
//
//       // Calculate the balance: sum credits, subtract debits
//       double balance = (sumCredit - sumDebit) +
//           ((partyType.creditOpBalRs ?? 0) - (partyType.debitOpBalRs ?? 0));
//
//       return DropdownMenuItem<String>(
//         value: partyType.partyCode.toString(),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(partyType.partyName!),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text(getPartyType(partyType.typeCode!)),
//               ],
//             ), // Party name
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(balance.abs().toStringAsFixed(2)),
//                 const SizedBox(width: 10),
//                 Text(balance > 0 ? "Cr" : "Dr"),
//                 // Cr or Dr based on balance// Display balance
//               ],
//             ),
//           ],
//         ),
//       );
//     }).toList();
//   }

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

  List<DropdownItem<String>> get dropdownItemsRough {
    return defaultController.roughModel.map((partyType) {
      return DropdownItem<String>(
        value: partyType.roughTypeCode.toString(),
        label: partyType.roughTypeName!,
      );
    }).toList();
  }
}
