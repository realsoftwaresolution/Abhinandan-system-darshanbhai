import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/expense/expense_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ExpenseDataGridSource extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final DefaultController defaultController = Get.find<DefaultController>();

  ExpenseDataGridSource(RxList<ExpenseModel> expenseList) {
    _dataGridRows = expenseList.map<DataGridRow>((item) {
      String groupName = item.expGroupName ?? '';
      if (groupName.isEmpty && item.expGroupCode != null) {
        final grp = defaultController.expenseGroupDropdownList.firstWhereOrNull(
          (g) =>
              g.expGroupCode == item.expGroupCode ||
              g.expGroupMstId == item.expGroupCode,
        );
        if (grp != null) {
          groupName = grp.expGroupName ?? '';
        }
      }

      return DataGridRow(cells: [
        DataGridCell<int>(
            columnName: 'Code',
            value: item.expCode ?? item.expMstId),
        DataGridCell<String>(
            columnName: 'Name',
            value: item.expName ?? ''),
        DataGridCell<String>(
            columnName: 'Exp Group',
            value: groupName),
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
            dataGridCell.columnName == 'Sort ID';

        final Alignment alignment =
            isCentered ? Alignment.center : Alignment.centerLeft;

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
