import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/controllers/menu_app_controller.dart';
import 'package:real_web_rough_entry_system/header.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memo_issue_details_datagrid.dart';
import 'package:real_web_rough_entry_system/memo%20receive/memo_rec_details_model.dart';
import 'package:real_web_rough_entry_system/memo%20receive/memo_rec_model.dart';
import 'package:real_web_rough_entry_system/memo%20receive/memo_receive_datagrid.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memo_issue_details_model.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memo_issue_model.dart';
import 'package:real_web_rough_entry_system/responsive.dart';
import 'package:real_web_rough_entry_system/rough/rough_model.dart';
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
  final TextEditingController rateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController stockcontroller =
      TextEditingController(text: '0.0');
  final FocusNode _partyFocNode = FocusNode();

  final DataGridController _dataGridController = DataGridController();

  List<Map<String, String>> entries = [];
  List<Map<String, String>> recEntries = [];
  RxList<MemoIssueDetailsModel> allRoughDetails = <MemoIssueDetailsModel>[].obs;
  RxList<MemoIssueModel> allSelectedMemoIssue = <MemoIssueModel>[].obs;
  Map<int, List<MemoIssueDetailsModel>> groupedRoughDetails = {};
  RxList selectedBroker = <int>[].obs;
  final RxString _selectedType = ''.obs;
  final RxString _selectedTypeBroker = ''.obs;
  final RxString _selectedTypeParty = ''.obs;
  final RxInt selectedMemoRecMstID = 0.obs;
  final RxInt selectedMemoIssueDetID = 0.obs;
  final RxString selectedRoughId = ''.obs;

  DateTime? selectedDate;
  String? dueDate;

  double get totalWt =>
      entries.fold(0.0, (prev, e) => prev + double.parse(e['wt']!));

  double get totalRate => totalWt == 0 ? 0 : totalAmount / totalWt;

  double get totalAmount =>
      entries.fold(0.0, (prev, e) => prev + double.parse(e['amount']!));

  double get totalRecWt =>
      recEntries.fold(0.0, (prev, e) => prev + double.parse(e['recWt']!));

  double get totalRecRate => totalRecWt == 0 ? 0 : totalRecAmount / totalRecWt;

  double get totalRecAmount =>
      recEntries.fold(0.0, (prev, e) => prev + double.parse(e['amount']!));

  bool _isEnabled = false;
  bool _isSearch = false;
  bool _isFromEdit = false;
  final _formKey = GlobalKey<FormState>();

  final DefaultController defaultController = Get.find<DefaultController>();
  final MenuAppController menuController = Get.find<MenuAppController>();

  void _enableFields() {
    setState(() {
      _isEnabled = true;
      Future.delayed(const Duration(milliseconds: 100), () {
        _partyFocNode.requestFocus(); // Move focus to the first input field
      });
    });
  }

  @override
  void initState() {
    issWtController.addListener(_updateAmount);
    recWtController.addListener(_updateAmount);
    rateController.addListener(_updateAmount);
    super.initState();
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    issWtController.dispose();
    recWtController.dispose();
    rateController.dispose();
    amountController.dispose();
    super.dispose();
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

  void addEntry() {
    setState(() {
      recEntries.add({
        if (selectedRoughId.value.isNotEmpty) 'id': selectedRoughId.value,
        'rough': _selectedType.value,
        'description': descripController.text,
        'wt': issWtController.text,
        'recWt': recWtController.text,
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
      rateController.clear();
      amountController.clear();
      stockcontroller.clear();
    });
    // print("${entries.length}FROM ...");
  }

  @override
  Widget build(BuildContext context) {
    return _isSearch == true
        ? SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Header(title: 'Memo Receive Search'),
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
              SizedBox(
                height: MediaQuery.of(context).size.width - 550,
                child: Obx(
                  () => SfDataGrid(
                    // onCellTap: (DataGridCellTapDetails details) {
                    //   if (details.rowColumnIndex.rowIndex != 0 &&
                    //       details.rowColumnIndex.columnIndex != 0 ) {
                    //     _dataGridController.beginEdit(
                    //       details.rowColumnIndex,
                    //     );
                    //   }
                    // },
                    // allowEditing: true,
                    controller: _dataGridController,
                    source: MemoReceiveDataGridSource(
                        defaultController.memoRecList),
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
                              entry.memoRecMstID == selectedMemoRecMstID.value,
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
                              'rough': roughEntry.roughTypeCode.toString(),
                              'description': roughEntry.description.toString(),
                              'wt': roughEntry.carats.toString(),
                              'recWt': roughEntry.recCarats.toString(),
                              'rate': roughEntry.rateRs.toString(),
                              'amount': (double.parse(
                                          roughEntry.recCarats.toString()) *
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
            ],
          ))
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
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey)),
                                      child: Column(
                                        children: [
                                          _buildRow([
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
                                                    return DropdownButtonFormField<
                                                        String>(
                                                      focusNode: _partyFocNode,
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
                                                              BorderRadius.zero,
                                                        ),
                                                        errorBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .red,
                                                                  width: 1.0),
                                                          borderRadius:
                                                              BorderRadius.zero,
                                                        ),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .blue,
                                                                  width: 1.0),
                                                          borderRadius:
                                                              BorderRadius.zero,
                                                        ),
                                                        enabledBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1.0),
                                                          borderRadius:
                                                              BorderRadius.zero,
                                                        ),
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical: 8,
                                                                    horizontal:
                                                                        8),
                                                      ),
                                                      items: dropdownItemsParty,
                                                      onChanged: _isEnabled
                                                          ? (value) {
                                                              _selectedTypeParty
                                                                      .value =
                                                                  value ??
                                                                      ''; // Handle null case
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
                                                          borderRadius: BorderRadius
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
                                                          borderRadius: BorderRadius
                                                              .zero, // Squared corners
                                                        ),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.blue,
                                                            width:
                                                                1.0, // Thin border width
                                                          ),
                                                          borderRadius: BorderRadius
                                                              .zero, // Squared corners
                                                        ),
                                                        enabledBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.grey,
                                                            width:
                                                                1.0, // Thin border width
                                                          ),
                                                          borderRadius: BorderRadius
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
                                                      onChanged: _isEnabled
                                                          ? (value) {
                                                              if (_selectedTypeParty
                                                                  .isEmpty) {
                                                                Get.rawSnackbar(
                                                                  message:
                                                                      'Please Select Party.',
                                                                );
                                                              } else {
                                                                _selectedTypeBroker
                                                                        .value =
                                                                    value ?? '';
                                                                allSelectedMemoIssue
                                                                    .clear();
                                                                allSelectedMemoIssue
                                                                        .value =
                                                                    getMemoIssueByPartyAndBroker(
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
                                                                    List<MemoIssueDetailsModel> roughDetails = defaultController
                                                                        .memoIssueDetailsList
                                                                        .where((detail) =>
                                                                            detail.memoIssueMstID ==
                                                                            memo.memoIssueMstID)
                                                                        .toList();

                                                                    allRoughDetails
                                                                        .addAll(
                                                                            roughDetails); // Add the filtered results
                                                                  }

                                                                  if (allRoughDetails
                                                                      .isNotEmpty) {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              cnt) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              const Text('Select Entry to Receive'),
                                                                          content:
                                                                              SizedBox(
                                                                            width:
                                                                                double.maxFinite,
                                                                            child:
                                                                                Obx(
                                                                              () => SfDataGrid(
                                                                                controller: _dataGridController,
                                                                                source: MemoIssueDetailsDataGridSource(allRoughDetails),
                                                                                columns: <GridColumn>[
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
                                                                                    columnName: 'Rough Type',
                                                                                    label: Container(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      alignment: Alignment.center,
                                                                                      child: const Text(
                                                                                        'Rough Type',
                                                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  GridColumn(
                                                                                    columnName: 'Memo Issue ID',
                                                                                    label: Container(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      alignment: Alignment.center,
                                                                                      child: const Text(
                                                                                        'Memo Issue ID',
                                                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  GridColumn(
                                                                                    columnName: 'Memo Issue Detail ID',
                                                                                    label: Container(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      alignment: Alignment.center,
                                                                                      child: const Text(
                                                                                        'Memo Issue Detail ID',
                                                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                                rowHeight: 30,
                                                                                headerRowHeight: 40,
                                                                                gridLinesVisibility: GridLinesVisibility.both,
                                                                                headerGridLinesVisibility: GridLinesVisibility.both,
                                                                                selectionMode: SelectionMode.singleDeselect,
                                                                                onSelectionChanged: (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
                                                                                  if (addedRows.isNotEmpty) {
                                                                                    final DataGridRow selectedRow = addedRows.first;

                                                                                    // Retrieve the selected memo issue detail ID from the selected row
                                                                                    selectedMemoIssueDetID.value = selectedRow.getCells()[3].value;

                                                                                    // Find the corresponding rough data for the selected memo issue detail
                                                                                    MemoIssueDetailsModel roughEntry = defaultController.memoIssueDetailsList.firstWhere((entry) => entry.memoIssueDetID == selectedMemoIssueDetID.value);

                                                                                    // Update the form fields with the selected rough entry details
                                                                                    _selectedType.value = roughEntry.roughTypeCode.toString();
                                                                                    issWtController.text = roughEntry.carats.toString();
                                                                                    rateController.text = roughEntry.rateRs.toString();
                                                                                    recWtController.text = roughEntry.carats.toString();
                                                                                    descripController.text = roughEntry.description.toString();
                                                                                    dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
                                                                                    selectedDate = DateTime.now();

                                                                                    _enableFields();
                                                                                    Get.back(); // Close the dialog
                                                                                  }
                                                                                },
                                                                                columnWidthMode: ColumnWidthMode.auto,
                                                                                frozenColumnsCount: 1,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          actions: <Widget>[
                                                                            OutlinedButton(
                                                                              child: const Text('Cancel'),
                                                                              onPressed: () {
                                                                                Get.back();
                                                                              },
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  } else {
                                                                    // Show snackbar if no matching details found
                                                                    Get.rawSnackbar(
                                                                      message:
                                                                          'No memo issue details found for the selected broker.',
                                                                    );
                                                                  }
                                                                } else {
                                                                  // Show snackbar if no memo issue is selected
                                                                  Get.rawSnackbar(
                                                                    message:
                                                                        'No memo issue found for the selected party and broker.',
                                                                  );
                                                                }
                                                              }
                                                            }
                                                          : null,
                                                    );
                                                  }),
                                                ),
                                              ],
                                            ),
                                            _buildTextField(
                                              'DATE',
                                              dateController,
                                              isEnabled: _isEnabled,
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2000),
                                                  lastDate: DateTime(2101),
                                                );

                                                if (pickedDate != null) {
                                                  setState(() {
                                                    selectedDate = pickedDate;
                                                    dateController.text =
                                                        DateFormat('dd-MM-yyyy')
                                                            .format(pickedDate);
                                                  });
                                                  // _updateDueDate();
                                                }
                                              },
                                            ),
                                            // _buildTextField('PURID', 'AUTO', purIdController),
                                          ]),
                                        ],
                                      )),
                                  // const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Colors.grey),
                                        right: BorderSide(color: Colors.grey),
                                        left: BorderSide(color: Colors.grey),
                                        // bottom: BorderSide.none, // Bottom border is not added
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        _buildRow(
                                          [
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
                                                          borderRadius: BorderRadius
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
                                                          borderRadius: BorderRadius
                                                              .zero, // Squared corners
                                                        ),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.blue,
                                                            width:
                                                                1.0, // Thin border width
                                                          ),
                                                          borderRadius: BorderRadius
                                                              .zero, // Squared corners
                                                        ),
                                                        enabledBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.grey,
                                                            width:
                                                                1.0, // Thin border width
                                                          ),
                                                          borderRadius: BorderRadius
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
                                              ],
                                            ),
                                            _buildTextField('DESCRIPTION',
                                                descripController,
                                                isEnabled: false),
                                            _buildTextField(
                                                'ISS WT', issWtController,
                                                inputFormatterList: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(
                                                          r'^\d+\.?\d{0,3}')),
                                                ],
                                                isEnabled: false),
                                          ],
                                        ),
                                        _buildRow([
                                          _buildTextField(
                                            'REC WT',
                                            recWtController,
                                            inputFormatterList: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+\.?\d{0,3}')),
                                            ],
                                            isEnabled: _isEnabled,
                                            /*onChanged: (val) {
                                            if (_formKey.currentState!
                                                    .validate() &&
                                                val.isNotEmpty) {
                                              addEntry();
                                            }
                                          }*/
                                          ),
                                          _buildTextField(
                                              'RATE', rateController,
                                              inputFormatterList: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(
                                                        r'^\d+\.?\d{0,3}')),
                                              ],
                                              isEnabled: false),
                                          _buildTextField(
                                              'AMOUNT', amountController,
                                              isEnabled: false),
                                          // _buildTextField(
                                          //   'STOCK',
                                          //   stockcontroller,
                                          //   isEnabled:
                                          //       false, // Disable input since it's auto-filled
                                          // ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                width: 15,
                                                height: 15,
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      addEntry();
                                                    }
                                                  },
                                                  child: const Text("..."),
                                                ),
                                              )
                                            ],
                                          ),
                                        ])
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)),
                                // padding: const EdgeInsets.all(8.0),
                                child: _buildMemoRecDataTable()),
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
                                child: const Text("Add"),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: () {},
                                child: const Text("Edit"),
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
                                          Get.rawSnackbar(
                                              message: 'Please Add Rough Data');
                                        }
                                      }
                                    : () async {
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
                                          Get.rawSnackbar(
                                              message: 'Please Add Rough Data');
                                        }
                                      },
                                child: Obx(
                                  () => defaultController.isLoading.value
                                      ? const CupertinoActivityIndicator()
                                      : const Text("Save"),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: () {
                                  _isFromEdit
                                      ? defaultController
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
                                        })
                                      : Get.rawSnackbar(
                                          message:
                                              'Please Select Sale Entry to Delete.');
                                },
                                child: Obx(
                                  () => defaultController.isLoading.value
                                      ? const CupertinoActivityIndicator()
                                      : const Text("Delete"),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: () {
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
                                  });
                                },
                                child: const Text("Cancel"),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: () {
                                  menuController.selectedIndex.value = 0;
                                },
                                child: const Text("Exit"),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _isSearch = true;
                                  });
                                },
                                child: const Text("Search"),
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

  // void _updateDueDate() {
  //   if (selectedDate != null) {
  //     int dueDays = int.tryParse(dueDaysController.text) ?? 0;
  //     DateTime temp = selectedDate!.add(Duration(days: dueDays));
  //     dueDateController.text = DateFormat('dd-MM-yyyy').format(temp);
  //     dueDate = DateFormat('yyyy-MM-dd HH:MM:SS').format(temp);
  //   }
  // }

  Widget _buildTextField(String label, TextEditingController? controller,
      {List<TextInputFormatter>? inputFormatterList,
      VoidCallback? onTap,
      bool? isEnabled,
      ValueChanged<String>? onChanged,
      FocusNode? focusNode}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 12, // Font size for the label
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            width: 50,
            child: TextFormField(
              onTap: onTap,
              controller: controller,
              keyboardType: TextInputType.number,
              enabled: isEnabled,
              focusNode: focusNode,
              textInputAction: TextInputAction.next,
              inputFormatters: inputFormatterList,
              decoration: const InputDecoration(
                errorStyle: TextStyle(
                  height: 0, // Hides the error message
                  fontSize: 0, // Ensures no space is taken by the error message
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                    // Red border when focused with an error
                    width: 1.0, // Thin border width
                  ),
                  borderRadius: BorderRadius.zero, // Squared corners
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                    // Red border for errors
                    width: 1.0, // Thin border width
                  ),
                  borderRadius: BorderRadius.zero, // Squared corners
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                    // Black border when focused without error
                    width: 1.0, // Thin border width
                  ),
                  borderRadius: BorderRadius.zero, // Squared corners
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    // Light grey border when enabled
                    width: 1.0, // Thin border width
                  ),
                  borderRadius: BorderRadius.zero, // Squared corners
                ),
                // filled: true,
                // Fill the background
                // fillColor: Colors.white,
                // White background
                isDense: true,
                // Reduces the overall height of the TextField
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ), // Remove top padding, minimal horizontal padding
              ),
              cursorColor: Colors.black,
              // Black cursor color
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12, // Consistent font size with label
              ),
              onChanged: onChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return ''; // Validation still occurs, but no message is shown
                }
                return null;
              },
            ),
          ),
        ),
      ],
    ); /*TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: label,
        border: const UnderlineInputBorder(),
      ),
    );*/
  }

  Widget _buildDataTable() {
    return DataTable(
      columnSpacing: 10,
      headingRowHeight: 20,
      horizontalMargin: 10,
      dataRowHeight: 30.0,
      columns: const [
        DataColumn(
          label: Text(
            'SR.NO',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
            label: Text(
          'ROUGH TYPE',
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
        // DataColumn(
        //     label: Text(
        //   '',
        //   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        // )),
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
            DataCell(
              Text(
                (index + 1).toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ),
            DataCell(Text(
              getRoughName(entries[index]['rough']!),
              style: const TextStyle(fontSize: 12),
            )),
            DataCell(Text(
              entries[index]['description']!,
              style: const TextStyle(fontSize: 12),
            )),
            DataCell(Text(
              entries[index]['wt']!,
              style: const TextStyle(fontSize: 12),
            )),
            DataCell(Text(
              entries[index]['rate']!,
              style: const TextStyle(fontSize: 12),
            )),
            DataCell(Text(
              entries[index]['amount']!,
              style: const TextStyle(fontSize: 12),
            )),
            // DataCell(
            //   Obx(
            //     () => defaultController.isLoading.value
            //         ? const CupertinoActivityIndicator()
            //         : IconButton(
            //             icon: const Icon(Icons.delete),
            //             onPressed: () {
            //               setState(() {
            //                 defaultController
            //                     .deleteMemoIssueRoughData(
            //                         id: int.parse(entries[index]['id']!))
            //                     .then((onValue) {
            //                   setState(() {
            //                     entries.removeAt(index);
            //                   });
            //                 });
            //
            //                 // _updateTotals(); // Recalculate totals after deletion
            //               });
            //             },
            //           ),
            //   ),
            // ),
            DataCell(
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  size: 15,
                ),
                onPressed: () {
                  selectedRoughId.value = entries[index]['id']!;
                  _selectedType.value = entries[index]['rough']!;
                  issWtController.text = entries[index]['wt']!;
                  recWtController.text = entries[index]['wt']!;
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
              // const DataCell(Text(
              //   '',
              //   style: TextStyle(fontSize: 12),
              // )),
              const DataCell(Text(
                '',
                style: TextStyle(fontSize: 12),
              )),
            ],
          ),
        ),
    );
  }

  Widget _buildMemoRecDataTable() {
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
          ),
        ),
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
          'REC WT',
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
        recEntries.length,
        (index) => DataRow(
          cells: [
            DataCell(
              Text(
                (index + 1).toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ),
            DataCell(Text(
              getRoughName(recEntries[index]['rough']!),
              style: const TextStyle(fontSize: 12),
            )),
            DataCell(Text(
              recEntries[index]['description']!,
              style: const TextStyle(fontSize: 12),
            )),
            DataCell(Text(
              recEntries[index]['wt']!,
              style: const TextStyle(fontSize: 12),
            )),
            DataCell(Text(
              recEntries[index]['recWt']!,
              style: const TextStyle(fontSize: 12),
            )),
            DataCell(Text(
              recEntries[index]['rate']!,
              style: const TextStyle(fontSize: 12),
            )),
            DataCell(Text(
              recEntries[index]['amount']!,
              style: const TextStyle(fontSize: 12),
            )),
            DataCell(
              Obx(
                () => defaultController.isLoading.value
                    ? const CupertinoActivityIndicator()
                    : IconButton(
                        icon: const Icon(
                          Icons.delete,
                          size: 15,
                        ),
                        onPressed: () {
                          setState(() {
                            defaultController
                                .deleteMemoRecRoughData(
                                    id: int.parse(recEntries[index]['id']!))
                                .then((onValue) {
                              setState(() {
                                recEntries.removeAt(index);
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
                  selectedRoughId.value = recEntries[index]['id']!;
                  _selectedType.value = recEntries[index]['rough']!;
                  issWtController.text = recEntries[index]['wt']!;
                  recWtController.text = recEntries[index]['recWt']!;
                  rateController.text = recEntries[index]['rate']!;
                  // amountController.text = recEntries[index]['amount']!;
                  descripController.text = recEntries[index]['description']!;
                  updateStockControllerBasedOnType(recEntries[index]['rough']!);
                  setState(() {
                    recEntries.removeAt(index);
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
                  totalRecWt.toStringAsFixed(2),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              DataCell(Text(
                totalRecRate.toStringAsFixed(2),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              )),
              DataCell(
                Text(
                  totalRecAmount.toStringAsFixed(2),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const DataCell(Text(
                '',
                style: TextStyle(fontSize: 12),
              )),
              const DataCell(Text(
                '',
                style: TextStyle(fontSize: 12),
              )),
              const DataCell(Text(
                '',
                style: TextStyle(fontSize: 12),
              )),
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

  String getRoughName(String? typeCode) {
    final party = defaultController.roughModel.firstWhere(
        (p) => p.roughTypeCode == int.parse(typeCode!),
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

  // void displayRoughDetails(List<MemoIssueDetailsModel> roughDetails) {
  //   setState(() {
  //     // Clear the existing entries if needed
  //     entries.clear();
  //
  //     // Loop through each rough detail and add it to the entries
  //     for (var roughDetail in roughDetails) {
  //       entries.add({
  //         if (selectedRoughId.value.isNotEmpty) 'id': selectedRoughId.value,
  //         'rough': _selectedType.value,
  //         // assuming _selectedType contains the rough type
  //         'description': descripController.text,
  //         'wt': roughDetail.carats.toString(),
  //         // assuming `wt` is part of MemoIssueDetailsModel
  //         'rate': roughDetail.rateRs.toString(),
  //         // assuming `rate` is part of MemoIssueDetailsModel
  //         'amount':
  //             (roughDetail.carats! * roughDetail.rateRs!).toStringAsFixed(2),
  //       });
  //     }
  //   });
  //
  //   // Optional: log or display entries in UI
  //   if (kDebugMode) {
  //     print(entries);
  //   } // or update UI with entries
  // }

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
