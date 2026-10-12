import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/party/party_model.dart';
import 'package:real_web_rough_entry_system/party/party_type_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PartyDataGridSource extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final DefaultController defaultController = Get.find<DefaultController>();

  PartyDataGridSource(RxList<PartyMstModel> partyList) {
    _dataGridRows = partyList
        .where((e) =>
            e.companyCode == null ||
            e.companyCode == 0 ||
            defaultController.companyCode.value == 0 ||
            e.companyCode == defaultController.companyCode.value)
        .toList()
        .map<DataGridRow>((party) {
      final String resolvedType = (party.partyType != null && party.partyType!.isNotEmpty)
          ? party.partyType!
          : getTypeName(party.typeCode);

      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'Code', value: party.partyCode ?? party.partyMstID),
        DataGridCell<String>(columnName: 'Type', value: resolvedType),
        DataGridCell<String>(columnName: 'Name', value: party.partyName ?? ''),
        DataGridCell<String>(
            columnName: 'Contact Person', value: party.contactPerson ?? ''),
        DataGridCell<String>(columnName: 'Address', value: party.address ?? ''),
        DataGridCell<String>(columnName: 'Location', value: party.location ?? party.city ?? ''),
        DataGridCell<dynamic>(columnName: 'CGST', value: party.cGST),
        DataGridCell<dynamic>(columnName: 'SGST', value: party.sGST),
        DataGridCell<dynamic>(columnName: 'IGST', value: party.iGST),
        DataGridCell<int>(columnName: 'Sort Id', value: party.sortID),
        DataGridCell<bool>(columnName: 'Active', value: party.active ?? true),
      ]);
    }).toList();
  }

  String getTypeName(int? typeCode) {
    if (typeCode == null) return '';
    final party = defaultController.partyTypeMstList.firstWhere(
        (p) => p.typeCode == typeCode,
        orElse: () => PartyTypeMstModel(typeName: ''));
    return party.typeName ?? '';
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    // Get the index of the current row
    int rowIndex = rows.indexOf(row);

    // Alternate row colors: AppColors.tableRowAlt for even rows, AppColors.surface for odd rows
    return DataGridRowAdapter(
      color: rowIndex % 2 == 0
          ? AppColors.tableRowAlt
          : AppColors.surface,
      cells: [
        for (var cell in row.getCells())
          cell.columnName == 'Active'
              ? Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Checkbox(
                    value: (cell.value as bool?) ?? true,
                    onChanged: null, // Disable interaction
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    cell.value != null ? cell.value.toString() : '',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
      ],
    );
  }
}
