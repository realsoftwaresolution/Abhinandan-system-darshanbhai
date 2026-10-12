import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/user/user_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class UserDataGridSource extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final Map<DataGridRow, UserModel> _rowToModel = {};
  final List<UserModel> _models = [];
  final DefaultController defaultController = Get.find<DefaultController>();

  UserDataGridSource(List<UserModel> userList) {
    buildDataGridRows(userList);
  }

  void buildDataGridRows(List<UserModel> userList) {
    _models.clear();
    _models.addAll(userList);
    _rowToModel.clear();

    _dataGridRows = userList.map<DataGridRow>((item) {
      // Find branch name
      String branchDisplay = '';
      if (item.branchCode != null && item.branchCode != 0) {
        final b = defaultController.branchModelList.firstWhereOrNull(
          (element) =>
              element.branchCode == item.branchCode ||
              element.branchMstId == item.branchCode,
        );
        branchDisplay = b?.branchName ?? 'Branch #${item.branchCode}';
      }

      String permittedHours = '-';
      if ((item.loginTimeFrom != null && item.loginTimeFrom!.isNotEmpty) ||
          (item.loginTimeTo != null && item.loginTimeTo!.isNotEmpty)) {
        permittedHours =
            '${item.loginTimeFrom ?? ''} - ${item.loginTimeTo ?? ''}'.trim();
      }

      final row = DataGridRow(cells: [
        DataGridCell<int>(
          columnName: 'Code',
          value: item.counterMstId,
        ),
        DataGridCell<String>(
          columnName: 'Login Name',
          value: item.loginName ?? '',
        ),
        DataGridCell<String>(
          columnName: 'User Name',
          value: item.userName ?? '',
        ),
        DataGridCell<String>(
          columnName: 'Role',
          value: item.userGrp ?? 'USER',
        ),
        DataGridCell<String>(
          columnName: 'Branch',
          value: branchDisplay,
        ),
        DataGridCell<String>(
          columnName: 'Stock Limit',
          value: item.stockLimit != null
              ? item.stockLimit!.toStringAsFixed(2)
              : '-',
        ),
        DataGridCell<String>(
          columnName: 'Permitted Hours',
          value: permittedHours,
        ),
        DataGridCell<dynamic>(
          columnName: 'Sort ID',
          value: item.sortId,
        ),
        DataGridCell<bool>(
          columnName: 'Active',
          value: item.active ?? true,
        ),
      ]);
      _rowToModel[row] = item;
      return row;
    }).toList();
  }

  void updateDataSource(List<UserModel> userList) {
    buildDataGridRows(userList);
    notifyListeners();
  }

  UserModel? modelForRow(DataGridRow row) => _rowToModel[row];

  UserModel? modelAt(int index) {
    if (index >= 0 && index < effectiveRows.length) {
      final row = effectiveRows[index];
      return _rowToModel[row] ?? findModelFromRow(row);
    }
    return null;
  }

  UserModel? findModelFromRow(DataGridRow row) {
    if (_rowToModel.containsKey(row)) {
      return _rowToModel[row];
    }

    dynamic codeVal;
    String? loginVal;
    for (final cell in row.getCells()) {
      if (cell.columnName == 'Code') codeVal = cell.value;
      if (cell.columnName == 'Login Name') loginVal = cell.value?.toString();
    }

    if (codeVal != null && codeVal != 0) {
      for (final m in _models) {
        if (m.counterMstId != null && m.counterMstId == codeVal) {
          return m;
        }
      }
    }

    if (loginVal != null && loginVal.trim().isNotEmpty) {
      final trimmed = loginVal.trim().toLowerCase();
      for (final m in _models) {
        if (m.loginName != null &&
            m.loginName!.trim().toLowerCase() == trimmed) {
          return m;
        }
      }
    }

    return null;
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
              onChanged: null,
            ),
          );
        }

        final bool isCentered = dataGridCell.columnName == 'Code' ||
            dataGridCell.columnName == 'Sort ID' ||
            dataGridCell.columnName == 'Role';

        final bool isRightAligned = dataGridCell.columnName == 'Stock Limit';

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
              fontWeight: dataGridCell.columnName == 'Login Name'
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
