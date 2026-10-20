import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/designation/designation_model.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DesignationDataGridSource extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final DefaultController defaultController = Get.find<DefaultController>();

  DesignationDataGridSource(RxList<DesignationModel> designationList) {
    _dataGridRows = designationList.map<DataGridRow>((item) {
      return DataGridRow(cells: [
        DataGridCell<int>(
            columnName: 'Code',
            value: item.desiCode ?? item.desiMstID ?? item.designationCode),
        DataGridCell<String>(
            columnName: 'Name',
            value: item.desiName ?? item.designationName ?? ''),
        DataGridCell<dynamic>(
            columnName: 'Sort ID',
            value: item.sortID ?? item.sortNo),
        DataGridCell<bool>(
            columnName: 'Active',
            value: item.active ?? item.activeRecord ?? true),
        DataGridCell<String>(
            columnName: 'EditDel',
            value: item.editDel ?? 'Y'),
        DataGridCell<int>(
            columnName: 'DesiMstID',
            value: item.desiMstID ?? item.desiCode ?? 0),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    int rowIndex = rows.indexOf(row);

    final codeCell =
        row.getCells().firstWhereOrNull((c) => c.columnName == 'Code');
    final nameCell =
        row.getCells().firstWhereOrNull((c) => c.columnName == 'Name');
    final sortCell =
        row.getCells().firstWhereOrNull((c) => c.columnName == 'Sort ID');
    final activeCell =
        row.getCells().firstWhereOrNull((c) => c.columnName == 'Active');
    final editDelCell =
        row.getCells().firstWhereOrNull((c) => c.columnName == 'EditDel');

    final bool isLocked =
        (editDelCell?.value?.toString().toUpperCase().trim() ?? 'Y') == 'N';

    return DataGridRowAdapter(
      color: rowIndex % 2 == 0 ? AppColors.tableRowAlt : AppColors.surface,
      cells: [
        // 1. Code
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            codeCell?.value != null ? codeCell!.value.toString() : '',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
            ),
          ),
        ),

        // 2. Name with Locked Badge
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                nameCell?.value != null ? nameCell!.value.toString() : '',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),

        // 3. Sort ID
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            sortCell?.value != null ? sortCell!.value.toString() : '',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
            ),
          ),
        ),

        // 4. Active Checkbox
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Checkbox(
            value: (activeCell?.value as bool?) ?? true,
            onChanged: null, // Read-only in table view
          ),
        ),
      ],
    );
  }
}
