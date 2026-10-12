import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/charni/charni_model.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CharniDataGridSource extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final DefaultController defaultController = Get.find<DefaultController>();

  CharniDataGridSource(RxList<CharniModel> charniList) {
    _dataGridRows = charniList.map<DataGridRow>((item) {
      final String rptGroupName = item.rptGroup?.charniRptGroupName ??
          (item.charniRptGroupCode != null
              ? (defaultController.charniRptGroupList.firstWhereOrNull(
                      (g) =>
                          g.charniRptGroupCode == item.charniRptGroupCode ||
                          g.charniRptGroupMstID == item.charniRptGroupCode)
                      ?.charniRptGroupName ??
                  item.charniRptGroupCode.toString())
              : '-');

      return DataGridRow(cells: [
        DataGridCell<int>(
            columnName: 'Code',
            value: item.charniCode ?? item.charniMstID),
        DataGridCell<String>(
            columnName: 'Name',
            value: item.charniName ?? ''),
        DataGridCell<String>(
            columnName: 'Rpt Group',
            value: rptGroupName),
        DataGridCell<String>(
            columnName: 'From Size',
            value: item.fromSize != null
                ? item.fromSize!.toStringAsFixed(3)
                : '0.000'),
        DataGridCell<String>(
            columnName: 'To Size',
            value: item.toSize != null
                ? item.toSize!.toStringAsFixed(3)
                : '0.000'),
        DataGridCell<dynamic>(
            columnName: 'Sort ID',
            value: item.sortID),
        DataGridCell<bool>(
            columnName: 'Active',
            value: item.active ?? true),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    int rowIndex = rows.indexOf(row);

    return DataGridRowAdapter(
      color: rowIndex % 2 == 0 ? AppColors.tableRowAlt : AppColors.surface,
      cells: row.getCells().map<Widget>((dataGridCell) {
        if (dataGridCell.columnName == 'Active') {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Checkbox(
              value: (dataGridCell.value as bool?) ?? true,
              onChanged: null, // Read-only in table view
            ),
          );
        }

        final bool isCentered = dataGridCell.columnName == 'Code' ||
            dataGridCell.columnName == 'Sort ID' ||
            dataGridCell.columnName == 'Rpt Group';

        final bool isRightAligned = dataGridCell.columnName == 'From Size' ||
            dataGridCell.columnName == 'To Size';

        final Alignment alignment = isCentered
            ? Alignment.center
            : (isRightAligned ? Alignment.centerRight : Alignment.centerLeft);

        return Container(
          alignment: alignment,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            dataGridCell.value != null ? dataGridCell.value.toString() : '',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
            ),
          ),
        );
      }).toList(),
    );
  }
}
