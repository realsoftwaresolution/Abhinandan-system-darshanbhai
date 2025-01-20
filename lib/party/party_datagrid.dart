import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/party/party_model.dart';
import 'package:real_web_rough_entry_system/party/party_type_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PartyDataGridSource extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final DefaultController defaultController = Get.find<DefaultController>();

  PartyDataGridSource(RxList<PartyMstModel> partyList) {
    _dataGridRows = partyList.where((e)=> e.companyCode == defaultController.companyCode.value).toList().map<DataGridRow>((party) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'Code', value: party.partyCode),
        DataGridCell<String>(
            columnName: 'Type', value: getTypeName(party.typeCode)),
        DataGridCell<String>(columnName: 'Name', value: party.partyName),
        DataGridCell<String>(
            columnName: 'Contact Person', value: party.contactPerson),
        // DataGridCell<String>(columnName: 'Mobile No', value: party.mobileno),
        DataGridCell<String>(columnName: 'Address', value: party.address),
        DataGridCell<String>(columnName: 'Location', value: party.location),
        // DataGridCell<String>(columnName: 'Email ID', value: party.emailID),
        // DataGridCell<String>(columnName: 'Website', value: party.webSite),
        DataGridCell<double>(columnName: 'CGST', value: party.cGST),
        DataGridCell<double>(columnName: 'SGST', value: party.sGST),
        DataGridCell<double>(columnName: 'IGST', value: party.iGST),
        DataGridCell<int>(columnName: 'Sort Id', value: party.sortID),
        DataGridCell<bool>(columnName: 'Active', value: party.active),
      ]);
    }).toList();
  }

  String getTypeName(int? typeCode) {
    final party = defaultController.partyTypeMstList.firstWhere(
        (p) => p.typeCode == typeCode,
        orElse: () => PartyTypeMstModel(typeName: 'Unknown'));
    return party.typeName ?? 'Unknown';
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    // Get the index of the current row
    int rowIndex = rows.indexOf(row);

    // Alternate row colors: light grey for even rows, white for odd rows
    return DataGridRowAdapter(
      color: rowIndex % 2 == 0
          ? Colors.grey[200] // Light grey for even rows
          : null, // White for odd rows
      cells: [
        for (var cell in row.getCells())
          cell.columnName == 'Active'
              ? Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Checkbox(
                    value: cell.value as bool,
                    onChanged: null, // Disable interaction
                  ),
                )
              : Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    cell.value.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
      ],
    );
  }
}
