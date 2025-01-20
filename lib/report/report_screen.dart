import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
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
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  final RxString _selectedTypeReport = ''.obs;
  final RxList<String> _selectedTypeParties = <String>[].obs;
  final RxList<String> _selectedTypeBrokers = <String>[].obs;
  final RxList<String> _selectedTypeRoughs = <String>[].obs;

  final DataGridController _dataGridController = DataGridController();

  late MemoPendingReportDataGridSource dataGridSource;
  late OutstandingPurchaseReportDataGridSource
      outstandingPurchaseDataGridSource;
  late OutstandingSaleReportDataGridSource outstandingSaleDataGridSource;

  @override
  void initState() {
    dataGridSource = MemoPendingReportDataGridSource();
    outstandingPurchaseDataGridSource =
        OutstandingPurchaseReportDataGridSource();
    outstandingSaleDataGridSource = OutstandingSaleReportDataGridSource();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        widget.showHeader
            ? const Header(title: 'Report')
            : const SizedBox.shrink(),
        Row(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // OutlinedButton(
                  //     onPressed: () {}, child: const Text('Party\nLedger')),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: KeyboardListener(
                      focusNode: FocusNode(),
                      autofocus: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
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
                                          'REPORT',
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
                                              // focusNode:
                                              // _partyFocNode,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                              value: _selectedTypeReport
                                                      .value.isEmpty
                                                  ? null
                                                  : _selectedTypeReport.value,
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
                                                errorBorder:
                                                    UnderlineInputBorder(
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
                                              items: dropdownItemsReport,
                                              onChanged: /*_isEnabled
                                                    ?*/
                                                  (value) {
                                                _selectedTypeReport.value =
                                                    value ?? '';
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 100), () {
                                                  // _invoiceFocus
                                                  //     .requestFocus(); // Move focus to the first input field
                                                }); // Handle null case
                                              } /*: null*/,
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                    buildTextField(
                                      excludeFieldValidation: false,
                                      'From Date',
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
                                          dataGridSource
                                              .setFromDate(pickedDate);
                                          outstandingPurchaseDataGridSource
                                              .setFromDate(pickedDate);
                                          outstandingSaleDataGridSource
                                              .setFromDate(pickedDate);
                                          setState(() {
                                            fromDate = pickedDate;
                                            fromDateController.text =
                                                DateFormat('dd-MM-yyyy')
                                                    .format(fromDate!);
                                            if (toDateController
                                                .text.isNotEmpty) {
                                              // _applyDateFilter();
                                            }
                                          });
                                        }
                                      },
                                    ),
                                    buildTextField(
                                      excludeFieldValidation: false,
                                      'To Date',
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
                                          outstandingPurchaseDataGridSource
                                              .setToDate(pickedDate);
                                          outstandingSaleDataGridSource
                                              .setToDate(pickedDate);

                                          setState(() {
                                            toDate = pickedDate;
                                            toDateController.text =
                                                DateFormat('dd-MM-yyyy')
                                                    .format(toDate!);
                                            if (fromDateController
                                                .text.isNotEmpty) {
                                              // _applyDateFilter();
                                            }
                                          });
                                        }
                                      },
                                    ),

                                    // _buildTextField('PURID', 'AUTO', purIdController),
                                  ]),
                                  const SizedBox(height: 10),
                                  buildRow([
                                    Row(
                                      children: [
                                        const Text(
                                          'PARTY',
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
                                            return Container(
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.grey,
                                                    // Underline color
                                                    width:
                                                        1.0, // Underline thickness
                                                  ),
                                                ),
                                              ),
                                              child: MultiDropdown(
                                                items: multiDropdownItemsParty,
                                                fieldDecoration:
                                                    const FieldDecoration(
                                                  // Adjust the padding to reduce height
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  hintText: '',
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  // No background color
                                                  border: InputBorder.none,
                                                  // Remove default border
                                                  borderRadius: 0,
                                                  // No rounded corners
                                                  showClearIcon: true,
                                                  // Optional: Show clear icon if needed
                                                  hintStyle:
                                                      TextStyle(fontSize: 14),
                                                  // Smaller hint text size
                                                  labelStyle: TextStyle(
                                                      fontSize:
                                                          14), // Smaller label text size
                                                ),
                                                dropdownDecoration:
                                                    DropdownDecoration(
                                                  maxHeight: 200.0,
                                                  // Reduce dropdown height
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                dropdownItemDecoration:
                                                    DropdownItemDecoration(
                                                  // padding: EdgeInsets.symmetric(vertical: 6), // Reduce padding between items
                                                  selectedBackgroundColor:
                                                      Colors.blue
                                                          .withOpacity(0.2),
                                                ),
                                                chipDecoration: ChipDecoration(
                                                  backgroundColor: Colors.black
                                                      .withOpacity(0.1),
                                                  labelStyle: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10),
                                                ),
                                                searchEnabled: true,
                                                enabled: true,
                                                onSelectionChange: (value) {
                                                  _selectedTypeParties.value =
                                                      value.cast<String>();
                                                  List<int>
                                                      selectedPartiesAsInt =
                                                      _selectedTypeParties
                                                          .map((party) =>
                                                              int.parse(party))
                                                          .toList();
                                                  dataGridSource
                                                      .setSelectedParties(
                                                          selectedPartiesAsInt);
                                                  outstandingPurchaseDataGridSource
                                                      .setSelectedParties(
                                                          selectedPartiesAsInt);
                                                  outstandingSaleDataGridSource
                                                      .setSelectedParties(
                                                      selectedPartiesAsInt);
                                                  // print('Selected Values: $value');
                                                },
                                                closeOnBackButton: true,
                                                focusNode: FocusNode(),
                                              ),
                                            );
                                          }),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'BROKER',
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
                                            return Container(
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.grey,
                                                    // Underline color
                                                    width:
                                                        1.0, // Underline thickness
                                                  ),
                                                ),
                                              ),
                                              child: MultiDropdown(
                                                items: multiDropdownItemsBroker,
                                                fieldDecoration:
                                                    const FieldDecoration(
                                                  // Adjust the padding to reduce height
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  hintText: '',
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  // No background color
                                                  border: InputBorder.none,
                                                  // Remove default border
                                                  borderRadius: 0,
                                                  // No rounded corners
                                                  showClearIcon: true,
                                                  // Optional: Show clear icon if needed
                                                  hintStyle:
                                                      TextStyle(fontSize: 14),
                                                  // Smaller hint text size
                                                  labelStyle: TextStyle(
                                                      fontSize:
                                                          14), // Smaller label text size
                                                ),
                                                dropdownDecoration:
                                                    DropdownDecoration(
                                                  maxHeight: 200.0,
                                                  // Reduce dropdown height
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                dropdownItemDecoration:
                                                    DropdownItemDecoration(
                                                  // padding: EdgeInsets.symmetric(vertical: 6), // Reduce padding between items
                                                  selectedBackgroundColor:
                                                      Colors.blue
                                                          .withOpacity(0.2),
                                                ),
                                                chipDecoration: ChipDecoration(
                                                  backgroundColor: Colors.black
                                                      .withOpacity(0.1),
                                                  labelStyle: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10),
                                                ),
                                                searchEnabled: true,
                                                enabled: true,
                                                onSelectionChange: (value) {
                                                  _selectedTypeBrokers.value =
                                                      value.cast<String>();
                                                  List<int>
                                                      selectedBrokersAsInt =
                                                      _selectedTypeBrokers
                                                          .map((party) =>
                                                              int.parse(party))
                                                          .toList();
                                                  dataGridSource
                                                      .setSelectedBrokers(
                                                          selectedBrokersAsInt);
                                                  outstandingPurchaseDataGridSource
                                                      .setSelectedBrokers(
                                                          selectedBrokersAsInt);
                                                  outstandingSaleDataGridSource
                                                      .setSelectedBrokers(
                                                      selectedBrokersAsInt);
                                                  // print('Selected Values: $value');
                                                },
                                                closeOnBackButton: true,
                                                focusNode: FocusNode(),
                                              ),
                                            );
                                          }),
                                        )
                                        // Expanded(
                                        //   child: Obx(() {
                                        //     return DropdownButtonFormField<
                                        //         String>(
                                        //       // focusNode: _brokerFocus,
                                        //       style:
                                        //           const TextStyle(fontSize: 12),
                                        //       value: _selectedTypeBroker
                                        //               .value.isEmpty
                                        //           ? null
                                        //           : _selectedTypeBroker.value,
                                        //       decoration: const InputDecoration(
                                        //         errorStyle: TextStyle(
                                        //           height: 0,
                                        //           // Hides the error message
                                        //           fontSize:
                                        //               0, // Ensures no space is taken by the error message
                                        //         ),
                                        //         focusedErrorBorder:
                                        //             UnderlineInputBorder(
                                        //           borderSide: BorderSide(
                                        //             color: Colors.red,
                                        //             width:
                                        //                 1.0, // Thin border width
                                        //           ),
                                        //           borderRadius: BorderRadius
                                        //               .zero, // Squared corners
                                        //         ),
                                        //         errorBorder:
                                        //             UnderlineInputBorder(
                                        //           borderSide: BorderSide(
                                        //             color: Colors.red,
                                        //             width:
                                        //                 1.0, // Thin border width
                                        //           ),
                                        //           borderRadius: BorderRadius
                                        //               .zero, // Squared corners
                                        //         ),
                                        //         focusedBorder:
                                        //             UnderlineInputBorder(
                                        //           borderSide: BorderSide(
                                        //             color: Colors.blue,
                                        //             width:
                                        //                 1.0, // Thin border width
                                        //           ),
                                        //           borderRadius: BorderRadius
                                        //               .zero, // Squared corners
                                        //         ),
                                        //         enabledBorder:
                                        //             UnderlineInputBorder(
                                        //           borderSide: BorderSide(
                                        //             color: Colors.grey,
                                        //             width:
                                        //                 1.0, // Thin border width
                                        //           ),
                                        //           borderRadius: BorderRadius
                                        //               .zero, // Squared corners
                                        //         ),
                                        //         isDense: true,
                                        //         contentPadding:
                                        //             EdgeInsets.symmetric(
                                        //           vertical: 8,
                                        //           horizontal: 8,
                                        //         ),
                                        //       ),
                                        //       items: dropdownItemsBroker,
                                        //       onChanged: /*_isEnabled
                                        //           ?*/
                                        //           (value) {
                                        //         _selectedTypeBroker.value =
                                        //             value ?? '';
                                        //        dataGridSource
                                        //             .setSelectedBroker(
                                        //                 int.parse(
                                        //                     _selectedTypeBroker
                                        //                         .value));
                                        //         Future.delayed(
                                        //             const Duration(
                                        //                 milliseconds: 100), () {
                                        //           // _dueDaysFocus
                                        //           //     .requestFocus(); // Move focus to the first input field
                                        //         }); // Handle null case
                                        //       } /*: null*/,
                                        //     );
                                        //   }),
                                        // ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'ROUGH',
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
                                            return Container(
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.grey,
                                                    // Underline color
                                                    width:
                                                        1.0, // Underline thickness
                                                  ),
                                                ),
                                              ),
                                              child: MultiDropdown(
                                                items: dropdownItemsRough,
                                                fieldDecoration:
                                                    const FieldDecoration(
                                                  // Adjust the padding to reduce height
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  hintText: '',
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  // No background color
                                                  border: InputBorder.none,
                                                  // Remove default border
                                                  borderRadius: 0,
                                                  // No rounded corners
                                                  showClearIcon: true,
                                                  // Optional: Show clear icon if needed
                                                  hintStyle:
                                                      TextStyle(fontSize: 14),
                                                  // Smaller hint text size
                                                  labelStyle: TextStyle(
                                                      fontSize:
                                                          14), // Smaller label text size
                                                ),
                                                dropdownDecoration:
                                                    DropdownDecoration(
                                                  maxHeight: 200.0,
                                                  // Reduce dropdown height
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                dropdownItemDecoration:
                                                    DropdownItemDecoration(
                                                  // padding: EdgeInsets.symmetric(vertical: 6), // Reduce padding between items
                                                  selectedBackgroundColor:
                                                      Colors.blue
                                                          .withOpacity(0.2),
                                                ),
                                                chipDecoration: ChipDecoration(
                                                  backgroundColor: Colors.black
                                                      .withOpacity(0.1),
                                                  labelStyle: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10),
                                                ),
                                                searchEnabled: true,
                                                enabled: true,
                                                onSelectionChange: (value) {
                                                  _selectedTypeRoughs.value =
                                                      value.cast<String>();
                                                  List<int>
                                                      selectedRoughsAsInt =
                                                      _selectedTypeRoughs
                                                          .map((rough) =>
                                                              int.parse(rough))
                                                          .toList();
                                                  dataGridSource
                                                      .setSelectedRoughs(
                                                          selectedRoughsAsInt);
                                                  outstandingPurchaseDataGridSource
                                                      .setSelectedRoughs(
                                                          selectedRoughsAsInt);
                                                  outstandingSaleDataGridSource
                                                      .setSelectedRoughs(
                                                      selectedRoughsAsInt);
                                                  // print('Selected Values: $value');
                                                },
                                                closeOnBackButton: true,
                                                focusNode: FocusNode(),
                                              ),
                                            );
                                          }),
                                        )
                                      ],
                                    ),
                                  ]),
                                ],
                              )),
                          // const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {},
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
                          dataGridSource.clearFilter();
                          outstandingPurchaseDataGridSource.clearFilter();
                          outstandingSaleDataGridSource.clearFilter();
                          fromDateController.clear();
                          toDateController.clear();
                          _selectedTypeParties.value = [];
                          _selectedTypeBrokers.value = [];
                          _selectedTypeRoughs.value = [];

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
                  )
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: Obx(() => _selectedTypeReport.isEmpty
              ? const Center(child: Text('Please Select Report Type'))
              : _selectedTypeReport.value == 'STOCK'
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Obx(
                        () => SfDataGrid(
                          controller: _dataGridController,
                          source: StockReportDataGrid(),
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
                              columnName: 'Pur Wt',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Pur Wt',
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
                              columnName: 'Sell Wt',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Sell Wt',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Memo Wt',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Memo Wt',
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
                              columnName: 'Loss Wt',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Loss Wt',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Stock Wt',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Stock Wt',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                          tableSummaryRows: [
                            GridTableSummaryRow(
                                title: 'Total',
                                showSummaryInRow: false,
                                titleColumnSpan: 1,
                                columns: <GridSummaryColumn>[
                                  const GridSummaryColumn(
                                      name: 'Pur Wt',
                                      columnName: 'Pur Wt',
                                      summaryType: GridSummaryType.sum),
                                  const GridSummaryColumn(
                                      name: 'Sell Wt',
                                      columnName: 'Sell Wt',
                                      summaryType: GridSummaryType.sum),
                                  const GridSummaryColumn(
                                      name: 'Memo Wt',
                                      columnName: 'Memo Wt',
                                      summaryType: GridSummaryType.sum),
                                  const GridSummaryColumn(
                                      name: 'Loss Wt',
                                      columnName: 'Loss Wt',
                                      summaryType: GridSummaryType.sum),
                                  const GridSummaryColumn(
                                      name: 'Stock Wt',
                                      columnName: 'Stock Wt',
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
                          selectionMode: SelectionMode.singleDeselect,
                          columnWidthMode: ColumnWidthMode.auto,
                          frozenColumnsCount: 1,
                          // gridLineStrokeWidth: 1.5,
                          // gridLineColor: Colors.grey.shade400,
                          // backgroundColor: Colors.white,
                        ),
                      ),
                    )
                  : _selectedTypeReport.value == 'MEMO PENDING'
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SfDataGrid(
                            controller: _dataGridController,
                            source: dataGridSource,
                            columns: <GridColumn>[
                              GridColumn(
                                columnName: 'Id',
                                label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Id',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Rough',
                                label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Rough',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Iss Wt',
                                label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Iss Wt',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Rate',
                                label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Rate',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Amount',
                                label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Amount',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
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
                            columnWidthMode: ColumnWidthMode.auto,
                            frozenColumnsCount: 1,
                            // gridLineStrokeWidth: 1.5,
                            // gridLineColor: Colors.grey.shade400,
                            // backgroundColor: Colors.white,
                          ),
                        )
                      : _selectedTypeReport.value == 'PURCHASE OUTSTANDING'
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5)),
                                              color: Colors.black87),
                                          child: Obx(
                                            () => Text(
                                              _selectedTypeReport.value,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white),
                                            ),
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            final call =
                                                OutstandingPurchaseReportDataGridSource();
                                            call.exportToPdf();
                                          },
                                          tooltip: 'Print as PDF',
                                          icon: const Icon(
                                            Icons.print,
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                  SfDataGrid(
                                    controller: _dataGridController,
                                    source: outstandingPurchaseDataGridSource,
                                    columns: <GridColumn>[
                                      GridColumn(
                                        columnName: 'Inv No.',
                                        label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Inv No.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Inv Date',
                                        label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Inv Date',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Due Days',
                                        label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Due Days',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
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
                                                fontWeight: FontWeight.bold),
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
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      // GridColumn(
                                      //   columnName: 'Broker',
                                      //   label: Container(
                                      //     padding: const EdgeInsets.all(8.0),
                                      //     alignment: Alignment.center,
                                      //     child: const Text(
                                      //       'Broker',
                                      //       style:
                                      //           TextStyle(fontWeight: FontWeight.bold),
                                      //     ),
                                      //   ),
                                      // ),
                                      // GridColumn(
                                      //   columnName: 'Ct',
                                      //   label: Container(
                                      //     padding: const EdgeInsets.all(8.0),
                                      //     alignment: Alignment.center,
                                      //     child: const Text(
                                      //       'Ct',
                                      //       style:
                                      //           TextStyle(fontWeight: FontWeight.bold),
                                      //     ),
                                      //   ),
                                      // ),
                                      GridColumn(
                                        columnName: 'Inv Amt Rs',
                                        label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Inv Amt Rs',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Out Rs',
                                        label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Out Rs',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Tot Out Rs',
                                        label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Tot Out Rs',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                    tableSummaryRows: [
                                      GridTableSummaryRow(
                                          title: 'Total',
                                          showSummaryInRow: false,
                                          titleColumnSpan: 1,
                                          columns: <GridSummaryColumn>[
                                            const GridSummaryColumn(
                                                name: 'Inv Amt Rs',
                                                columnName: 'Inv Amt Rs',
                                                summaryType:
                                                    GridSummaryType.sum),
                                            const GridSummaryColumn(
                                                name: 'Out Rs',
                                                columnName: 'Out Rs',
                                                summaryType:
                                                    GridSummaryType.sum),
                                            const GridSummaryColumn(
                                                name: 'Tot Out Rs',
                                                columnName: 'Tot Out Rs',
                                                summaryType:
                                                    GridSummaryType.sum),
                                          ],
                                          position: GridTableSummaryRowPosition
                                              .bottom)
                                    ],
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
                                    selectionMode: SelectionMode.singleDeselect,
                                    columnWidthMode: ColumnWidthMode.auto,
                                    frozenColumnsCount: 1,
                                    // gridLineStrokeWidth: 1.5,
                                    // gridLineColor: Colors.grey.shade400,
                                    // backgroundColor: Colors.white,
                                  ),
                                ],
                              ),
                            )
                          : _selectedTypeReport.value == 'SALE OUTSTANDING'
                              ? Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: Radius
                                                              .circular(5),
                                                          topRight:
                                                              Radius.circular(
                                                                  5)),
                                                  color: Colors.black87),
                                              child: Obx(
                                                () => Text(
                                                  _selectedTypeReport.value,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: Colors.white),
                                                ),
                                              )),
                                          IconButton(
                                              onPressed: () {
                                                OutstandingSaleReportDataGridSource()
                                                    .exportToPdf(context);
                                              },
                                              tooltip: 'Print as PDF',
                                              icon: const Icon(
                                                Icons.print,
                                                color: Colors.black,
                                              )),
                                        ],
                                      ),
                                      SfDataGrid(
                                        controller: _dataGridController,
                                        source: outstandingSaleDataGridSource,
                                        columns: <GridColumn>[
                                          GridColumn(
                                            columnName: 'Inv No.',
                                            label: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Inv No.',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          GridColumn(
                                            columnName: 'Inv Date',
                                            label: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Inv Date',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          GridColumn(
                                            columnName: 'Due Days',
                                            label: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Due Days',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          GridColumn(
                                            columnName: 'Due Date',
                                            label: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Due Date',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          GridColumn(
                                            columnName: 'Party',
                                            label: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Party',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          // GridColumn(
                                          //   columnName: 'Broker',
                                          //   label: Container(
                                          //     padding: const EdgeInsets.all(8.0),
                                          //     alignment: Alignment.center,
                                          //     child: const Text(
                                          //       'Broker',
                                          //       style:
                                          //           TextStyle(fontWeight: FontWeight.bold),
                                          //     ),
                                          //   ),
                                          // ),
                                          // GridColumn(
                                          //   columnName: 'Ct',
                                          //   label: Container(
                                          //     padding: const EdgeInsets.all(8.0),
                                          //     alignment: Alignment.center,
                                          //     child: const Text(
                                          //       'Ct',
                                          //       style:
                                          //           TextStyle(fontWeight: FontWeight.bold),
                                          //     ),
                                          //   ),
                                          // ),
                                          GridColumn(
                                            columnName: 'Inv Amt Rs',
                                            label: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Inv Amt Rs',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          GridColumn(
                                            columnName: 'Out Rs',
                                            label: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Out Rs',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          GridColumn(
                                            columnName: 'Tot Out Rs',
                                            label: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Tot Out Rs',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                        tableSummaryRows: [
                                          GridTableSummaryRow(
                                              title: 'Total',
                                              showSummaryInRow: false,
                                              titleColumnSpan: 1,
                                              columns: <GridSummaryColumn>[
                                                const GridSummaryColumn(
                                                    name: 'Inv Amt Rs',
                                                    columnName: 'Inv Amt Rs',
                                                    summaryType:
                                                        GridSummaryType.sum),
                                                const GridSummaryColumn(
                                                    name: 'Out Rs',
                                                    columnName: 'Out Rs',
                                                    summaryType:
                                                        GridSummaryType.sum),
                                                const GridSummaryColumn(
                                                    name: 'Tot Out Rs',
                                                    columnName: 'Tot Out Rs',
                                                    summaryType:
                                                        GridSummaryType.sum),
                                              ],
                                              position:
                                                  GridTableSummaryRowPosition
                                                      .bottom)
                                        ],
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
                                            SelectionMode.singleDeselect,
                                        columnWidthMode: ColumnWidthMode.auto,
                                        frozenColumnsCount: 1,

                                        // gridLineStrokeWidth: 1.5,
                                        // gridLineColor: Colors.grey.shade400,
                                        // backgroundColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                )
                              : _selectedTypeReport.value ==
                                      'TOTAL PURCHASE OUTSTANDING'
                                  ? const Center(
                                      child: Text('TOTAL PURCHASE OUTSTANDING'))
                                  : const Center(
                                      child: Text('TOTAL SALE OUTSTANDING'))),
        ),
      ],
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
    // int typeCode;
    // if(_selectedTypeReport.value == 'SALE OUTSTANDING' || _selectedTypeReport.value == 'MEMO PENDING'){
    //   typeCode = 2;
    // } else {
    //   typeCode = 1;
    // }
    // print(typeCode);
    return defaultController.partyMstList
        .where((partyType) =>
            (partyType.typeCode == 1 || partyType.typeCode == 2) &&
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
  List<DropdownMenuItem<String>> get dropdownItemsParty {
    return defaultController.partyMstList
        .where((partyType) =>
            partyType.typeCode == 1 &&
            partyType.companyCode == defaultController.companyCode.value)
        .map((partyType) {
      return DropdownMenuItem<String>(
        value: partyType.partyCode.toString(),
        child: Text(partyType.partyName!),
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
