import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/acc_type/acc_type_model.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AccTypeDataGridSource extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final Map<DataGridRow, AccTypeModel> _rowToModel = {};
  final List<AccTypeModel> _models = [];
  final DefaultController defaultController = Get.find<DefaultController>();

  AccTypeDataGridSource(List<AccTypeModel> typeList) {
    buildDataGridRows(typeList);
  }

  void buildDataGridRows(List<AccTypeModel> typeList) {
    _models.clear();
    _models.addAll(typeList);
    _rowToModel.clear();
    _dataGridRows = typeList.map<DataGridRow>((item) {
      String groupName = item.group ?? item.typeGroupName ?? '';
      if (groupName.isEmpty && item.typeGroupCode != null) {
        final grp = defaultController.typeGroupDropdownList.firstWhereOrNull(
          (g) => g.typeGroupCode == item.typeGroupCode,
        );
        if (grp != null) {
          groupName = grp.typeGroupName ?? '';
        }
      }

      final row = DataGridRow(cells: [
        DataGridCell<int>(
          columnName: 'Code',
          value: item.typeCode,
        ),
        DataGridCell<String>(
          columnName: 'Name',
          value: item.typeName ?? '',
        ),
        DataGridCell<String>(
          columnName: 'Group',
          value: groupName,
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

  void updateDataSource(List<AccTypeModel> typeList) {
    buildDataGridRows(typeList);
    notifyListeners();
  }

  AccTypeModel? modelForRow(DataGridRow row) => _rowToModel[row];

  AccTypeModel? modelAt(int index) {
    if (index >= 0 && index < effectiveRows.length) {
      final row = effectiveRows[index];
      return _rowToModel[row] ?? findModelFromRow(row);
    }
    return null;
  }

  AccTypeModel? findModelFromRow(DataGridRow row) {
    if (_rowToModel.containsKey(row)) {
      return _rowToModel[row];
    }

    dynamic codeVal;
    String? nameVal;
    for (final cell in row.getCells()) {
      if (cell.columnName == 'Code') codeVal = cell.value;
      if (cell.columnName == 'Name') nameVal = cell.value?.toString();
    }

    if (codeVal != null && codeVal != 0) {
      for (final m in _models) {
        if (m.typeCode != null && m.typeCode == codeVal) {
          return m;
        }
      }
    }

    if (nameVal != null && nameVal.trim().isNotEmpty) {
      final trimmed = nameVal.trim().toLowerCase();
      for (final m in _models) {
        if (m.typeName != null &&
            m.typeName!.trim().toLowerCase() == trimmed) {
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
