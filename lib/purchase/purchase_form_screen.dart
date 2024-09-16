import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/controllers/menu_app_controller.dart';
import 'package:real_web_rough_entry_system/header.dart';
import 'package:real_web_rough_entry_system/purchase/purchase_datagrid.dart';
import 'package:real_web_rough_entry_system/purchase/purchase_details_model.dart';
import 'package:real_web_rough_entry_system/responsive.dart';
import 'package:real_web_rough_entry_system/rough/rough-details-model.dart';
import 'package:real_web_rough_entry_system/rough/rough_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PurchaseFormScreen extends StatefulWidget {
  const PurchaseFormScreen({super.key});

  @override
  PurchaseFormScreenState createState() => PurchaseFormScreenState();
}

class PurchaseFormScreenState extends State<PurchaseFormScreen> {
  final TextEditingController partyController = TextEditingController();
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
  final FocusNode _partyFocNode = FocusNode();
  final DataGridController _dataGridController = DataGridController();
  List<Map<String, String>> entries = [];
  final RxString _selectedType = ''.obs;
  final RxString _selectedTypeBroker = ''.obs;
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
    wtController.addListener(_updateAmount);
    rateController.addListener(_updateAmount);
    super.initState();
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    wtController.dispose();
    rateController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void _updateAmount() {
    final double wt = double.tryParse(wtController.text) ?? 0;
    final double rate = double.tryParse(rateController.text) ?? 0;
    final double amount = wt * rate;
    amountController.text = amount.toStringAsFixed(2);
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

      // Clear the input fields
      _selectedType.value = '';
      descripController.clear();
      wtController.clear();
      rateController.clear();
      amountController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isSearch == true
        ? SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Header(title: 'Purchase Search'),
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
                    controller: _dataGridController,
                    source: PurchaseDataGridSource(
                        defaultController.purchaseDataList),
                    columns: <GridColumn>[
                      GridColumn(
                        columnName: 'ID',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text(
                            'ID',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
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
                                fontWeight: FontWeight.bold, fontSize: 12),
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
                                fontWeight: FontWeight.bold, fontSize: 12),
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
                      //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
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
                                fontWeight: FontWeight.bold, fontSize: 12),
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
                      //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
                      //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
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
                                fontWeight: FontWeight.bold, fontSize: 12),
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
                      //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
                      //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
                      //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
                      //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
                      //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
                      //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
                      //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
                      //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
                        // if (kDebugMode) {
                        //   print("SELECTED ROW:  ::: $selectedRow");
                        // }
                        List<RoughDetailsModel> roughData =
                            defaultController.roughDetailsModel;
                        List<PurchaseDetailsModel> partyData =
                            defaultController.purchaseDataList;

                        // Extract the selected polishSaleMstID from the selectedRow
                        selectedRoughPurMstID.value = selectedRow
                            .getCells()[0]
                            .value; // Assuming the ID is in the first cell

                        // Find the corresponding party data entry with the matching polishSaleMstID
                        PurchaseDetailsModel partyEntry = partyData.firstWhere(
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
                              'id': roughEntry.roughPurDetID.toString(),
                              'rough': roughEntry.roughTypeCode.toString(),
                              'description': roughEntry.description.toString(),
                              'wt': roughEntry.wt.toString(),
                              'rate': roughEntry.rateRs.toString(),
                              'amount':
                                  (double.parse(roughEntry.wt.toString()) *
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
                const Header(title: 'Purchase'),
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
                                            _buildTextField(
                                                'INVOICE NO.', invNoController,
                                                isEnabled: _isEnabled),
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
                                                  _updateDueDate();
                                                }
                                              },
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
                                                      onChanged: _isEnabled
                                                          ? (value) {
                                                              _selectedTypeBroker
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
                                            _buildTextField(
                                                'DUE DAYS', dueDaysController,
                                                inputFormatterList: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ], onChanged: (value) {
                                              _updateDueDate();
                                            }, isEnabled: _isEnabled),
                                            _buildTextField(
                                              'DUE DATE',
                                              dueDateController,
                                              isEnabled:
                                                  false, // Disable input since it's auto-filled
                                            ),
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
                                    child: _buildRow(
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
                                            const SizedBox(width: 0),
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
                                                      height:
                                                          0, // Hides the error message
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
                                                  items: dropdownItems,
                                                  onChanged: _isEnabled
                                                      ? (value) {
                                                          _selectedType.value =
                                                              value ??
                                                                  ''; // Handle null case
                                                        }
                                                      : null,
                                                );
                                              }),
                                            ),
                                          ],
                                        ),
                                        _buildTextField(
                                            'DESCRIPTION', descripController,
                                            isEnabled: _isEnabled),
                                        _buildTextField('WT', wtController,
                                            inputFormatterList: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+\.?\d{0,3}')),
                                            ],
                                            isEnabled: _isEnabled),
                                        _buildTextField('RATE', rateController,
                                            inputFormatterList: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+\.?\d{0,3}')),
                                            ],
                                            isEnabled: _isEnabled),
                                        _buildTextField(
                                            'AMOUNT', amountController,
                                            isEnabled: false),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IntrinsicWidth(
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
                                padding: const EdgeInsets.all(8.0),
                                child: _buildDataTable()),
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
                                        if (entries.isNotEmpty) {
                                          defaultController
                                              .updatePurchaseData(
                                                  id: selectedRoughPurMstID
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
                                              entries.length = 0;
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
                                          _selectedTypeBroker.value = '';
                                        } else {
                                          Get.rawSnackbar(
                                              message: 'Please Add Rough Data');
                                        }
                                      }
                                    : () async {
                                        if (entries.isNotEmpty) {
                                          defaultController
                                              .addPurchaseData(
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
                                                  totalRate: totalRate,
                                                  totalAmt: totalAmount,
                                                  totalWt: totalWt)
                                              .then((onValue) {
                                            setState(() {
                                              entries.length = 0;
                                            });
                                          });

                                          dateController.clear();
                                          dueDateController.clear();
                                          dueDaysController.clear();
                                          dateController.clear();
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
                                          .deletePurchaseData(
                                              id: selectedRoughPurMstID.value,
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
                                      : Get.rawSnackbar(
                                          message:
                                              'Please Select Purchase Entry to Delete.');
                                },
                                child: Obx(()=>
                                   defaultController.isLoading.value
                                      ? const CupertinoActivityIndicator()
                                      : const Text("Delete"),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: () {
                                  dateController.clear();
                                  invNoController.clear();
                                  dueDateController.clear();
                                  dueDaysController.clear();
                                  dateController.clear();
                                  _selectedTypeParty.value = '';
                                  _selectedType.value = '';
                                  _selectedTypeBroker.value = '';
                                  setState(() {
                                    entries.length = 0;
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

  void _updateDueDate() {
    if (selectedDate != null) {
      int dueDays = int.tryParse(dueDaysController.text) ?? 0;
      DateTime temp = selectedDate!.add(Duration(days: dueDays));
      dueDateController.text = DateFormat('dd-MM-yyyy').format(temp);
      dueDate = DateFormat('yyyy-MM-dd HH:MM:SS').format(temp);
    }
  }

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
      columnSpacing: 30,
      columns: const [
        DataColumn(label: Text('SR.NO')),
        DataColumn(label: Text('ROUGH TYPE')),
        DataColumn(label: Text('DESCRIPTION')),
        DataColumn(label: Text('WT')),
        DataColumn(label: Text('RATE')),
        DataColumn(label: Text('AMOUNT')),
        DataColumn(label: Text('')),
        DataColumn(label: Text('')),
      ],
      rows: List<DataRow>.generate(
        entries.length,
        (index) => DataRow(
          cells: [
            DataCell(Text((index + 1).toString())),
            DataCell((Text(getRoughName(entries[index]['rough']!)))),
            DataCell(Text(entries[index]['description']!)),
            DataCell(Text(entries[index]['wt']!)),
            DataCell(Text(entries[index]['rate']!)),
            DataCell(Text(entries[index]['amount']!)),
            DataCell(
              Obx(
                () => defaultController.isLoading.value
                    ? const CupertinoActivityIndicator()
                    : IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            defaultController
                                .deletePurchaseRoughData(
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
                icon: const Icon(Icons.edit),
                onPressed: () {
                  selectedRoughId.value = entries[index]['id']!;
                  _selectedType.value = entries[index]['rough']!;
                  wtController.text = entries[index]['wt']!;
                  rateController.text = entries[index]['rate']!;
                  descripController.text = entries[index]['description']!;
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
              const DataCell(
                  Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(
                totalWt.toStringAsFixed(2),
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
              DataCell(Text(
                totalRate.toStringAsFixed(2),
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
              DataCell(
                Text(
                  totalAmount.toStringAsFixed(2),
                  style: const TextStyle(fontWeight: FontWeight.bold),
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
}
