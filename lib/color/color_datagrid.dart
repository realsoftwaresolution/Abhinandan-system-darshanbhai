import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/color/color_model.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ColorDataGridSource extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final DefaultController defaultController = Get.find<DefaultController>();

  ColorDataGridSource(RxList<ColorModel> colorList) {
    _dataGridRows = colorList.map<DataGridRow>((item) {
      return DataGridRow(cells: [
        DataGridCell<int>(
            columnName: 'Code',
            value: item.colorCode ?? item.colorMstID),
        DataGridCell<String>(
            columnName: 'Name',
            value: item.colorName ?? ''),
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

        final bool isCodeOrSort =
            dataGridCell.columnName == 'Code' || dataGridCell.columnName == 'Sort ID';

        return Container(
          alignment: isCodeOrSort ? Alignment.center : Alignment.centerLeft,
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
