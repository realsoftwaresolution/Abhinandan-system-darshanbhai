import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/polish_type/polish_type_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PolishTypeDataGridSource extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final Map<DataGridRow, PolishTypeModel> _rowToModel = {};
  final List<PolishTypeModel> _models = [];
  final DefaultController defaultController = Get.find<DefaultController>();

  PolishTypeDataGridSource(List<PolishTypeModel> polishTypeList) {
    buildDataGridRows(polishTypeList);
  }

  void buildDataGridRows(List<PolishTypeModel> polishTypeList) {
    _models.clear();
    _models.addAll(polishTypeList);
    _rowToModel.clear();
    _dataGridRows = polishTypeList.map<DataGridRow>((item) {
      final row = DataGridRow(cells: [
        DataGridCell<int>(
          columnName: 'Code',
          value: item.polishTypeCode ?? item.polishTypeMstId,
        ),
        DataGridCell<String>(
          columnName: 'Name',
          value: item.polishTypeName ?? '',
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

  void updateDataSource(List<PolishTypeModel> polishTypeList) {
    buildDataGridRows(polishTypeList);
    notifyListeners();
  }

  PolishTypeModel? modelForRow(DataGridRow row) => _rowToModel[row];

  PolishTypeModel? modelAt(int index) {
    if (index >= 0 && index < effectiveRows.length) {
      final row = effectiveRows[index];
      return _rowToModel[row] ?? findModelFromRow(row);
    }
    return null;
  }

  PolishTypeModel? findModelFromRow(DataGridRow row) {
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
        if ((m.polishTypeMstId != null && m.polishTypeMstId == codeVal) ||
            (m.polishTypeCode != null && m.polishTypeCode == codeVal)) {
          return m;
        }
      }
    }

    if (nameVal != null && nameVal.trim().isNotEmpty) {
      final trimmed = nameVal.trim().toLowerCase();
      for (final m in _models) {
        if (m.polishTypeName != null &&
            m.polishTypeName!.trim().toLowerCase() == trimmed) {
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
