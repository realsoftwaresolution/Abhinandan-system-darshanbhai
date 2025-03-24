import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:real_web_rough_entry_system/assort/assort_datagrid.dart';
import 'package:real_web_rough_entry_system/assort/assort_model.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/header.dart';
import 'package:real_web_rough_entry_system/purchase/invoice_generator.dart';
import 'package:real_web_rough_entry_system/purchase/purchase_datagrid.dart';
import 'package:real_web_rough_entry_system/purchase/purchase_details_model.dart';
import 'package:real_web_rough_entry_system/responsive.dart';
import 'package:real_web_rough_entry_system/rough/rough_details_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AssortFormScreen extends StatefulWidget {
  final bool showHeader;

  const AssortFormScreen({super.key, required this.showHeader});

  @override
  AssortFormScreenState createState() => AssortFormScreenState();
}

class AssortFormScreenState extends State<AssortFormScreen> {
  final TextEditingController nameController = TextEditingController(text: ' ');
  final TextEditingController sortIdController = TextEditingController();

  final FocusNode _groupFocusNode = FocusNode();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _sortIdFocusNode = FocusNode();
  final FocusNode _formKeyBoardFocus = FocusNode();
  final FocusNode _searchKeyBoardFocus = FocusNode();
  final DataGridController _dataGridController = DataGridController();
  List<Map<String, String>> entries = [];
  final RxString _selectedTypeGroup = ''.obs;
  final RxInt selectedAssortMstID = 0.obs;

  bool _isEnabled = false;
  bool _isSearch = false;
  bool _isFromEdit = false;
  final _formKey = GlobalKey<FormState>();

  final DefaultController defaultController = Get.find<DefaultController>();

  RxList<AssortMst> assortDataGridSource = <AssortMst>[].obs;

  // RxList<PurchaseDetailsModel> filteredDataGridSource =
  //     <PurchaseDetailsModel>[].obs;

  void _enableFields({bool? needFocus}) {
    setState(() {
      if (needFocus == null || needFocus) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _groupFocusNode.requestFocus(); // Move focus to the first input field
        });
        _isEnabled = true;
      } else {
        _isEnabled = true;
      }
    });
  }

  @override
  void initState() {
    // invNoController.text = defaultController.purchaseDataList.last.invoiceNo ?? '0';
    assortDataGridSource.value = defaultController.assortMstList;
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
    _groupFocusNode.dispose();
    _nameFocus.dispose();
    _sortIdFocusNode.dispose();
    _formKeyBoardFocus.dispose();
    _searchKeyBoardFocus.dispose();
    super.dispose();
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
                    ? const Header(title: 'Assort Search')
                    : const SizedBox.shrink(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildBottomButton(
                            text: 'Exit',
                            onPressed: () {
                              setState(() {
                                _isSearch = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Obx(
                      () => SfDataGrid(
                        controller: _dataGridController,
                        source: AssortDataGridSource(assortDataGridSource),
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
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Name',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Group',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Group',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
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
                            List<AssortMst> assortData =
                                defaultController.assortMstList;
                            // Extract the selected polishSaleMstID from the selectedRow
                            selectedAssortMstID.value = selectedRow
                                .getCells()[0]
                                .value; // Assuming the ID is in the first cell
                            // Find the corresponding party data entry with the matching polishSaleMstID
                            AssortMst assortEntry = assortData.firstWhere(
                              (entry) =>
                                  entry.assortMstID ==
                                  selectedAssortMstID.value,
                              // orElse: () => null,
                            );
                            nameController.text = assortEntry.name!;
                            sortIdController.text =
                                assortEntry.sortID.toString();
                            _selectedTypeGroup.value =
                                assortEntry.assortGroup.toString();

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
                () => Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        widget.showHeader
                            ? const Header(title: 'Assort')
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
                                                  bottom: BorderSide(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  _buildRow([
                                                    buildTextField(
                                                        'NAME',
                                                        excludeFieldValidation:
                                                            false,
                                                        nameController,
                                                        isEnabled: _isEnabled,
                                                        focusNode: _nameFocus,
                                                        onEditingComplete: () {
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  100), () {
                                                        _groupFocusNode
                                                            .requestFocus(); // Move focus to the first input field
                                                      });
                                                    }, onChanged: (value) {}),
                                                  ]),
                                                  const SizedBox(height: 5),
                                                  _buildRow([
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          'GROUP',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            fontSize:
                                                                12, // Font size for the label
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Expanded(
                                                          child: Obx(() {
                                                            return DropdownButtonFormField<
                                                                String>(
                                                              focusNode:
                                                                  _groupFocusNode,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          12),
                                                              value: _selectedTypeGroup
                                                                      .value
                                                                      .isEmpty
                                                                  ? null
                                                                  : _selectedTypeGroup
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
                                                                    color: Colors
                                                                        .blue,
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
                                                                    color: Colors
                                                                        .grey,
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
                                                                  dropdownItemsAssortGroup,
                                                              onChanged:
                                                                  _isEnabled
                                                                      ? (value) {
                                                                          _selectedTypeGroup.value =
                                                                              value ?? '';
                                                                          Future.delayed(
                                                                              const Duration(milliseconds: 100),
                                                                              () {
                                                                            _sortIdFocusNode.requestFocus(); // Move focus to the first input field
                                                                          }); // Handle null case
                                                                        }
                                                                      : null,
                                                            );
                                                          }),
                                                        ),
                                                      ],
                                                    ),
                                                    buildTextField(
                                                        excludeFieldValidation:
                                                            false,
                                                        'SORT ID',
                                                        sortIdController,
                                                        focusNode:
                                                            _sortIdFocusNode,
                                                        inputFormatterList: [
                                                          FilteringTextInputFormatter
                                                              .digitsOnly
                                                        ],
                                                        onEditingComplete: () {
                                                      // Future.delayed(
                                                      //     const Duration(
                                                      //         milliseconds:
                                                      //             100), () {
                                                      //   _roughFocNode
                                                      //       .requestFocus(); // Move focus to the first input field
                                                      // });
                                                    }, isEnabled: _isEnabled),
                                                    // _buildTextField('PURID', 'AUTO', purIdController),
                                                  ]),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Align(
                                  //   alignment: Alignment.center,
                                  //   child: Padding(
                                  //     padding:
                                  //     const EdgeInsets.symmetric(horizontal: 8.0),
                                  //     child: buildBottomButton(
                                  //       text: 'Add Rough',
                                  //       width: 100,
                                  //       onPressed: () {
                                  //         if (_formKey.currentState!.validate()) {
                                  //           addEntry();
                                  //         }
                                  //       },
                                  //     ),
                                  //   ),
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: Container(
                                  //       decoration: BoxDecoration(
                                  //           border: Border.all(
                                  //               color: Colors.grey)),
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
                                                defaultController
                                                    .updateAssortData(
                                                        id: selectedAssortMstID
                                                            .value,
                                                        name: nameController
                                                            .text
                                                            .trim(),
                                                        sortId: sortIdController
                                                            .text,
                                                        group:
                                                            _selectedTypeGroup
                                                                .value)
                                                    .then((v) {
                                                  setState(() {
                                                    _isEnabled = false;
                                                    _isFromEdit = false;
                                                  });
                                                  nameController.clear();
                                                  sortIdController.clear();
                                                  _selectedTypeGroup.value = '';
                                                });
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                } else {
                                                  infoDialog(
                                                      messageText:
                                                          'Please Add Required Data');
                                                }
                                              },
                                            )
                                          : _isEnabled
                                              ? buildBottomButton(
                                                  text: 'Save',
                                                  onPressed: () async {
                                                    defaultController
                                                        .addAssortData(
                                                            name: nameController
                                                                .text
                                                                .trim(),
                                                            sortId:
                                                                sortIdController
                                                                    .text,
                                                            group:
                                                                _selectedTypeGroup
                                                                    .value)
                                                        .then((v) {
                                                      setState(() {
                                                        _isEnabled = false;
                                                      });
                                                      nameController.clear();
                                                      sortIdController.clear();
                                                      _selectedTypeGroup.value =
                                                          '';
                                                    });
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                    } else {
                                                      infoDialog(
                                                          messageText:
                                                              'Please Add Required Data');
                                                    }
                                                  })
                                              : const SizedBox.shrink(),
                                      // const SizedBox(width: 5),
                                      _isFromEdit
                                          ? buildBottomButton(
                                              text: 'Delete',
                                              onPressed: () {
                                                defaultController
                                                    .deleteAssortData(
                                                  id: selectedAssortMstID.value,
                                                )
                                                    .then((onValue) {
                                                  sortIdController.clear();

                                                  nameController.clear();
                                                  _selectedTypeGroup.value = '';

                                                  setState(() {
                                                    _isFromEdit = false;
                                                    _isEnabled = false;
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
                                                nameController.clear();

                                                sortIdController.clear();

                                                _selectedTypeGroup.value = '';

                                                setState(() {
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
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    defaultController.isLoading.value ||
                            defaultController.isDeleteLoading.value
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
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
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
      desktop: const Text('Desktop View'),
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
        child: Text(
          partyType.roughTypeName!,
          style: TextStyle(color: Colors.black),
        ),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> get dropdownItemsAssortGroup {
    return defaultController.assortGroupMstList
        //     .where((partyType) =>
        // partyType.typeCode == 1 &&
        //     partyType.companyCode == defaultController.companyCode.value)
        .map((partyType) {
          return DropdownMenuItem<String>(
            value: partyType.name.toString(),
            child: Text(
              partyType.name!,
              style: const TextStyle(color: Colors.black),
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
