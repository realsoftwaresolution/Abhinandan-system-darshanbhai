import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/branch_transfer_confirm/branch_transfer_confirm_item_model.dart';
import 'package:real_web_rough_entry_system/branch_transfer_confirm/branch_transfer_confirm_mst_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// DataGridSource for Branch Transfer Confirm detail items
class BranchTransferConfirmDataGridSource extends DataGridSource {
  List<BranchTransferConfirmItemModel> items = [];
  List<DataGridRow> _dataGridRows = [];
  bool isEnabled = false;
  bool showCheckbox = true;
  final void Function(BranchTransferConfirmItemModel item)? onRowChanged;

  BranchTransferConfirmDataGridSource({
    required List<BranchTransferConfirmItemModel> initialItems,
    this.isEnabled = false,
    this.showCheckbox = true,
    this.onRowChanged,
  }) {
    items = initialItems;
    _rebuildAllRows();
  }

  void updateItems(List<BranchTransferConfirmItemModel> newItems) {
    items = newItems;
    _rebuildAllRows();
    notifyListeners();
  }

  void setEnabled(bool enabled) {
    isEnabled = enabled;
    notifyListeners();
  }

  void setShowCheckbox(bool show) {
    if (showCheckbox != show) {
      showCheckbox = show;
      _rebuildAllRows();
      notifyListeners();
    }
  }

  bool get isAllSelected =>
      items.isNotEmpty && items.every((e) => e.isSelected);
  bool get hasSomeSelected => items.any((e) => e.isSelected);

  void toggleSelectAll(bool select) {
    for (var item in items) {
      item.isSelected = select;
    }
    _rebuildAllRows();
    notifyListeners();
  }

  DataGridRow _createDataGridRow(BranchTransferConfirmItemModel item) {
    return DataGridRow(cells: [
      if (showCheckbox)
        DataGridCell<bool>(columnName: 'select', value: item.isSelected),
      DataGridCell<String>(columnName: 'source', value: item.source),
      DataGridCell<String>(columnName: 'type', value: item.resolveTypeName()),
      DataGridCell<String>(
          columnName: 'invoiceNo', value: item.invoiceNo ?? '-'),
      DataGridCell<String>(
          columnName: 'quality', value: item.resolveQualityName()),
      DataGridCell<String>(
          columnName: 'charni', value: item.resolveCharniName()),
      DataGridCell<String>(columnName: 'shape', value: item.resolveShapeName()),
      DataGridCell<String>(columnName: 'color', value: item.resolveColorName()),
      DataGridCell<String>(
          columnName: 'clarity', value: item.resolveClarityName()),
      DataGridCell<double>(
          columnName: 'rateDollar', value: item.stockRateDollar),
      DataGridCell<double>(columnName: 'rateRs', value: item.stockRateRs),
      DataGridCell<double>(
          columnName: 'amtDollar', value: item.stockAmtDollar),
      DataGridCell<double>(columnName: 'amtRs', value: item.stockAmtRs),
      DataGridCell<int>(columnName: 'stockPc', value: item.stockPc),
      DataGridCell<double>(columnName: 'stockWt', value: item.stockWt),
      DataGridCell<int>(columnName: 'issuePc', value: item.issuePc),
      DataGridCell<double>(columnName: 'issueWt', value: item.issueWt),
      DataGridCell<double>(columnName: 'issueRate', value: item.issueRate),
      DataGridCell<double>(columnName: 'issueAmt', value: item.issueAmt),
      DataGridCell<double>(columnName: 'diffWt', value: item.diffWt),
      DataGridCell<double>(columnName: 'diffRate', value: item.diffRate),
      DataGridCell<double>(columnName: 'diffAmt', value: item.diffAmt),
    ]);
  }

  void _rebuildAllRows() {
    _dataGridRows =
        items.map<DataGridRow>(_createDataGridRow).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    int rowIndex = _dataGridRows.indexOf(row);
    if (rowIndex < 0 || rowIndex >= items.length) {
      return const DataGridRowAdapter(cells: []);
    }
    final item = items[rowIndex];
    final isSelected = item.isSelected;

    final isDark = AppColors.isDark;
    final rowColor = isSelected
        ? AppColors.primary.withValues(alpha: isDark ? 0.22 : 0.12)
        : (rowIndex % 2 == 0 ? AppColors.tableRowAlt : AppColors.surface);

    return DataGridRowAdapter(
      color: rowColor,
      cells: row.getCells().map<Widget>((cell) {
        final colName = cell.columnName;
        final value = cell.value;

        // 1. Checkbox Selection Cell
        if (colName == 'select') {
          return Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: Checkbox(
                value: item.isSelected,
                activeColor: AppColors.primary,
                side: BorderSide(
                  color: isDark
                      ? const Color(0xFF64748B)
                      : const Color(0xFF94A3B8),
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3)),
                onChanged: isEnabled
                    ? (val) {
                        item.isSelected = val ?? false;
                        final idx = items.indexOf(item);
                        if (idx != -1 && idx < _dataGridRows.length) {
                          _dataGridRows[idx] = _createDataGridRow(item);
                          notifyListeners();
                        }
                        if (onRowChanged != null) {
                          onRowChanged!(item);
                        }
                      }
                    : null,
              ),
            ),
          );
        }

        // 2. Numeric and Text display
        String text = '-';
        Alignment alignment = Alignment.centerLeft;

        switch (colName) {
          case 'source':
            text = value?.toString() ?? '-';
            alignment = Alignment.center;
            break;
          case 'type':
          case 'invoiceNo':
          case 'quality':
          case 'charni':
          case 'shape':
          case 'color':
          case 'clarity':
            text = value?.toString() ?? '-';
            alignment = Alignment.centerLeft;
            break;
          case 'rateDollar':
          case 'rateRs':
          case 'amtDollar':
          case 'amtRs':
          case 'issueRate':
          case 'issueAmt':
          case 'diffRate':
          case 'diffAmt':
            final d = value is num ? value.toDouble() : 0.0;
            text = NumberFormat('#,##0.00').format(d);
            alignment = Alignment.centerRight;
            break;
          case 'stockPc':
          case 'issuePc':
            final i = value is num ? value.toInt() : 0;
            text = i.toString();
            alignment = Alignment.centerRight;
            break;
          case 'stockWt':
          case 'issueWt':
          case 'diffWt':
            final d = value is num ? value.toDouble() : 0.0;
            text = d.toStringAsFixed(3);
            alignment = Alignment.centerRight;
            break;
        }

        return Container(
          alignment: alignment,
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
              fontWeight: (colName == 'source' || colName == 'type')
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget? buildTableSummaryCellWidget(
    GridTableSummaryRow summaryRow,
    GridSummaryColumn? summaryColumn,
    RowColumnIndex rowColumnIndex,
    String summaryValue,
  ) {
    if (summaryColumn == null) return null;

    String displayValue = summaryValue;
    final doubleVal = double.tryParse(summaryValue);

    if (summaryColumn.name == 'total_title') {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(
          'Total :',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (doubleVal != null) {
      if (summaryColumn.name == 'stockPc_sum' ||
          summaryColumn.name == 'issuePc_sum') {
        displayValue = doubleVal.toInt().toString();
      } else if (summaryColumn.name == 'stockWt_sum' ||
          summaryColumn.name == 'issueWt_sum' ||
          summaryColumn.name == 'diffWt_sum') {
        displayValue = NumberFormat('#,##0.000').format(doubleVal);
      } else {
        displayValue = NumberFormat('#,##0.00').format(doubleVal);
      }
    }

    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Text(
        displayValue,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

/// DataGridSource for displaying Branch Transfer Confirm records in Search View
class BranchTransferConfirmSearchDataGridSource extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  List<BranchTransferConfirmMstModel> _list = [];
  final void Function(BranchTransferConfirmMstModel item)? onSelect;
  final void Function(BranchTransferConfirmMstModel item)? onDoubleTap;

  BranchTransferConfirmSearchDataGridSource({
    required List<BranchTransferConfirmMstModel> list,
    this.onSelect,
    this.onDoubleTap,
  }) {
    updateList(list);
  }

  void updateList(List<BranchTransferConfirmMstModel> newList) {
    _list = List.from(newList);
    _buildRows();
    notifyListeners();
  }

  void _buildRows() {
    _dataGridRows = _list.map<DataGridRow>((item) {
      return DataGridRow(cells: [
        DataGridCell<int>(
          columnName: 'ID',
          value: item.branchTransferConfirmMstID ?? 0,
        ),
        DataGridCell<String>(
          columnName: 'Date',
          value: item.displayDate,
        ),
        DataGridCell<String>(
          columnName: 'ManagerName',
          value: item.resolvedManagerName,
        ),
        DataGridCell<int>(
          columnName: 'ToCrId',
          value: item.toCrId ?? 0,
        ),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final int index = _dataGridRows.indexOf(row);
    final item = (index >= 0 && index < _list.length) ? _list[index] : null;

    return DataGridRowAdapter(
      color: Colors.transparent,
      cells: row.getCells().map<Widget>((cell) {
        String displayVal = cell.value?.toString() ?? '-';
        final isNumeric = cell.columnName == 'ID' || cell.columnName == 'ToCrId';

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onDoubleTap: () {
            if (item != null && onDoubleTap != null) {
              onDoubleTap!(item);
            }
          },
          child: Container(
            alignment: isNumeric ? Alignment.centerRight : Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              displayVal,
              style: TextStyle(
                fontSize: 12,
                fontWeight: cell.columnName == 'ID'
                    ? FontWeight.w600
                    : FontWeight.normal,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
