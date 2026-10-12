import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/company/company_model.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CompanyDataGridSource extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final Map<DataGridRow, CompanyMstModel> _rowToModel = {};
  final List<CompanyMstModel> _models = [];
  final DefaultController defaultController = Get.find<DefaultController>();

  CompanyDataGridSource(List<CompanyMstModel> companyList) {
    buildDataGridRows(companyList);
  }

  void buildDataGridRows(List<CompanyMstModel> companyList) {
    _models.clear();
    _models.addAll(companyList);
    _rowToModel.clear();
    _dataGridRows = companyList.map<DataGridRow>((item) {
      final row = DataGridRow(cells: [
        DataGridCell<int>(
          columnName: 'Code',
          value: item.companyCode ?? item.companyMstID,
        ),
        DataGridCell<String>(
          columnName: 'Name',
          value: item.companyName ?? '',
        ),
        DataGridCell<String>(
          columnName: 'Mobile',
          value: item.mobileNo ?? '',
        ),
        DataGridCell<String>(
          columnName: 'Email',
          value: item.email ?? '',
        ),
        DataGridCell<String>(
          columnName: 'GST No',
          value: item.gstNo ?? '',
        ),
        DataGridCell<String>(
          columnName: 'Bank',
          value: item.bankName ?? '',
        ),
        DataGridCell<dynamic>(
          columnName: 'Sort ID',
          value: item.sortID,
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

  void updateDataSource(List<CompanyMstModel> companyList) {
    buildDataGridRows(companyList);
    notifyListeners();
  }

  CompanyMstModel? modelForRow(DataGridRow row) => _rowToModel[row];

  CompanyMstModel? modelAt(int index) {
    if (index >= 0 && index < effectiveRows.length) {
      final row = effectiveRows[index];
      return _rowToModel[row] ?? findModelFromRow(row);
    }
    return null;
  }

  CompanyMstModel? findModelFromRow(DataGridRow row) {
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
        if ((m.companyMstID != null && m.companyMstID == codeVal) ||
            (m.companyCode != null && m.companyCode == codeVal)) {
          return m;
        }
      }
    }

    if (nameVal != null && nameVal.trim().isNotEmpty) {
      final trimmed = nameVal.trim().toLowerCase();
      for (final m in _models) {
        if (m.companyName != null &&
            m.companyName!.trim().toLowerCase() == trimmed) {
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
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
