import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/branch_transfer/branch_transfer_item_model.dart';
import 'package:real_web_rough_entry_system/branch_transfer/branch_transfer_mst_model.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BranchTransferDataGridSource extends DataGridSource {
  final DefaultController defaultController = Get.find<DefaultController>();
  List<BranchTransferItemModel> items = [];
  List<DataGridRow> _dataGridRows = [];
  bool isEnabled = false;
  bool showCheckbox = true;
  final void Function(BranchTransferItemModel item)? onRowChanged;
  final void Function()? onSelectAllToggled;
  final double Function(BranchTransferItemModel item)? getMaxAllowedIssueWt;
  final double Function(BranchTransferItemModel item)? getMinAllowedIssueWt;
  final void Function(String message)? onValidationWarning;

  BranchTransferDataGridSource({
    required List<BranchTransferItemModel> initialItems,
    this.isEnabled = false,
    this.showCheckbox = true,
    this.onRowChanged,
    this.onSelectAllToggled,
    this.getMaxAllowedIssueWt,
    this.getMinAllowedIssueWt,
    this.onValidationWarning,
  }) {
    items = initialItems;
    _rebuildAllRows();
  }

  void updateItems(List<BranchTransferItemModel> newItems) {
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

  bool get isAllSelected => items.isNotEmpty && items.every((e) => e.isSelected);
  bool get hasSomeSelected => items.any((e) => e.isSelected);

  void toggleSelectAll(bool select) {
    for (var item in items) {
      item.setSelected(select);
    }
    _rebuildAllRows();
    notifyListeners();
  }

  String getRoughTypeName(dynamic code) {
    if (code == null || code.toString().isEmpty) return '-';
    final item = defaultController.roughModel.firstWhereOrNull(
      (r) =>
          r.roughTypeCode.toString() == code.toString() ||
          r.roughTypeMstID.toString() == code.toString(),
    );
    return item?.roughTypeName ?? 'Rough #$code';
  }

  String resolveTypeName(BranchTransferItemModel item) {
    if (item.source.toLowerCase() == 'rough') {
      return getRoughTypeName(item.roughTypeCode);
    } else if (item.source.toLowerCase() == 'polish') {
      return getPolishTypeName(item.polishTypeCode);
    }
    return '-';
  }

  String resolveQuality(BranchTransferItemModel item) {
    if (item.source.toLowerCase() == 'rough' && item.roughQualityCode != null) {
      return getQualityName(item.roughQualityCode);
    }
    return '-';
  }

  String resolveCharni(BranchTransferItemModel item) {
    if (item.source.toLowerCase() == 'rough' && item.roughCharniCode != null) {
      return getCharniName(item.roughCharniCode);
    } else if (item.charniCode != null) {
      return getCharniName(item.charniCode);
    }
    return '-';
  }

  String resolveShape(BranchTransferItemModel item) {
    if (item.source.toLowerCase() == 'polish' && item.shapeCode != null) {
      return getShapeName(item.shapeCode);
    }
    return '-';
  }

  String resolveColor(BranchTransferItemModel item) {
    if (item.source.toLowerCase() == 'polish' && item.colorCode != null) {
      return getColorName(item.colorCode);
    }
    return '-';
  }

  String resolveClarity(BranchTransferItemModel item) {
    if (item.source.toLowerCase() == 'polish' && item.clarityCode != null) {
      return getClarityName(item.clarityCode);
    }
    return '-';
  }

  DataGridRow _createDataGridRow(BranchTransferItemModel item) {
    return DataGridRow(cells: [
      if (showCheckbox)
        DataGridCell<bool>(columnName: 'select', value: item.isSelected),
      DataGridCell<String>(columnName: 'source', value: item.source),
      DataGridCell<String>(columnName: 'type', value: resolveTypeName(item)),
      DataGridCell<String>(columnName: 'invoiceNo', value: item.invoiceNo ?? '-'),
      DataGridCell<String>(columnName: 'quality', value: resolveQuality(item)),
      DataGridCell<String>(columnName: 'charni', value: resolveCharni(item)),
      DataGridCell<String>(columnName: 'shape', value: resolveShape(item)),
      DataGridCell<String>(columnName: 'color', value: resolveColor(item)),
      DataGridCell<String>(columnName: 'clarity', value: resolveClarity(item)),
      DataGridCell<double>(columnName: 'rateDollar', value: item.stockRateDollar),
      DataGridCell<double>(columnName: 'rateRs', value: item.stockRateRs),
      DataGridCell<double>(columnName: 'amtDollar', value: item.stockAmtDollar),
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
    _dataGridRows = items.map<DataGridRow>(_createDataGridRow).toList();
  }

  void updateRowCalculations(BranchTransferItemModel item) {
    item.updateCalculations();
    final index = items.indexOf(item);
    if (index != -1 && index < _dataGridRows.length) {
      _dataGridRows[index] = _createDataGridRow(item);
      notifyListeners();
    }
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
                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                onChanged: isEnabled
                    ? (val) {
                        item.setSelected(val ?? false);
                        updateRowCalculations(item);
                        onRowChanged?.call(item);
                      }
                    : null,
              ),
            ),
          );
        }

        // 2. Issue Pc Editable Cell
        if (colName == 'issuePc') {
          final isHighlighted = isEnabled;
          final yellowBg = isDark
              ? const Color(0xFF854D0E).withValues(alpha: 0.45)
              : const Color(0xFFFEF08A);
          final yellowBorder = isDark
              ? const Color(0xFFEAB308)
              : const Color(0xFFFACC15);

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: isHighlighted ? yellowBg : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isHighlighted ? yellowBorder : AppColors.borderLight,
                width: 1,
              ),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextField(
              controller: item.issuePcController,
              focusNode: item.issuePcFocusNode,
              enabled: isEnabled,
              textAlign: TextAlign.right,
              keyboardType: const TextInputType.numberWithOptions(decimal: false),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 4),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              onChanged: (val) {
                final parsed = int.tryParse(val) ?? 0;
                item.issuePc = parsed;
                if (parsed > 0 && !item.isSelected) {
                  item.isSelected = true;
                }
                updateRowCalculations(item);
                onRowChanged?.call(item);
              },
            ),
          );
        }

        // 3. Issue Wt Editable Cell with AllowPlus validation
        if (colName == 'issueWt') {
          final isHighlighted = isEnabled;
          final yellowBg = isDark
              ? const Color(0xFF854D0E).withValues(alpha: 0.45)
              : const Color(0xFFFEF08A);
          final yellowBorder = isDark
              ? const Color(0xFFEAB308)
              : const Color(0xFFFACC15);

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: isHighlighted ? yellowBg : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isHighlighted ? yellowBorder : AppColors.borderLight,
                width: 1,
              ),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Focus(
              onFocusChange: (hasFocus) {
                if (!hasFocus) {
                  final parsed = double.tryParse(item.issueWtController.text) ?? 0.0;
                  final minAllowed = getMinAllowedIssueWt?.call(item) ?? 0.0;
                  if (item.isSelected && minAllowed > 0.0 && parsed < minAllowed) {
                    item.issueWt = minAllowed;
                    item.issueWtController.text = minAllowed.toStringAsFixed(3);
                    onValidationWarning?.call(
                      'Issue Wt cannot be less than ${minAllowed.toStringAsFixed(3)} (Min allowed: ${minAllowed.toStringAsFixed(3)})',
                    );
                    updateRowCalculations(item);
                    onRowChanged?.call(item);
                  }
                }
              },
              child: TextField(
                controller: item.issueWtController,
                focusNode: item.issueWtFocusNode,
                enabled: isEnabled,
                textAlign: TextAlign.right,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                onSubmitted: (val) {
                  final parsed = double.tryParse(val) ?? 0.0;
                  final minAllowed = getMinAllowedIssueWt?.call(item) ?? 0.0;
                  if (item.isSelected && minAllowed > 0.0 && parsed < minAllowed) {
                    item.issueWt = minAllowed;
                    item.issueWtController.text = minAllowed.toStringAsFixed(3);
                    onValidationWarning?.call(
                      'Issue Wt cannot be less than ${minAllowed.toStringAsFixed(3)} (Min allowed: ${minAllowed.toStringAsFixed(3)})',
                    );
                    updateRowCalculations(item);
                    onRowChanged?.call(item);
                  }
                },
                onChanged: (val) {
                  final parsed = double.tryParse(val) ?? 0.0;
                  final maxAllowed = getMaxAllowedIssueWt?.call(item) ?? item.stockWt;

                  if (parsed > maxAllowed) {
                    item.issueWt = maxAllowed;
                    item.issueWtController.text = maxAllowed.toStringAsFixed(3);
                    item.issueWtController.selection = TextSelection.fromPosition(
                      TextPosition(offset: item.issueWtController.text.length),
                    );
                    onValidationWarning?.call(
                      'Issue Wt cannot exceed ${maxAllowed.toStringAsFixed(3)} (Stock: ${item.stockWt.toStringAsFixed(3)})',
                    );
                  } else {
                    item.issueWt = parsed;
                  }

                  if (item.issueWt > 0.0 && !item.isSelected) {
                    item.isSelected = true;
                  }
                  updateRowCalculations(item);
                  onRowChanged?.call(item);
                },
              ),
            ),
          );
        }

        // 4. Regular Cells formatting
        Alignment alignment = Alignment.centerLeft;
        String text = '';

        if (colName == 'source') {
          alignment = Alignment.center;
          text = value?.toString() ?? '';
        } else if (colName == 'type' ||
            colName == 'invoiceNo' ||
            colName == 'quality' ||
            colName == 'charni' ||
            colName == 'shape' ||
            colName == 'color' ||
            colName == 'clarity') {
          alignment = Alignment.centerLeft;
          text = value?.toString() ?? '-';
        } else if (colName == 'stockPc') {
          alignment = Alignment.centerRight;
          text = (value is num) ? value.toInt().toString() : '0';
        } else if (colName == 'stockWt' || colName == 'diffWt') {
          alignment = Alignment.centerRight;
          final d = (value is num) ? value.toDouble() : (double.tryParse(value.toString()) ?? 0.0);
          text = NumberFormat('#,##0.000').format(d);
        } else if (colName == 'rateDollar' ||
            colName == 'rateRs' ||
            colName == 'amtDollar' ||
            colName == 'amtRs' ||
            colName == 'issueRate' ||
            colName == 'issueAmt' ||
            colName == 'diffRate' ||
            colName == 'diffAmt') {
          alignment = Alignment.centerRight;
          final d = (value is num) ? value.toDouble() : (double.tryParse(value.toString()) ?? 0.0);
          text = NumberFormat('#,##0.00').format(d);
        } else {
          alignment = Alignment.centerLeft;
          text = value?.toString() ?? '';
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
      if (summaryColumn.name == 'stockPc_sum' || summaryColumn.name == 'issuePc_sum') {
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

/// DataGridSource for displaying Branch Transfer master records in Search View
class BranchTransferSearchDataGridSource extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  List<BranchTransferMstModel> _list = [];
  final void Function(BranchTransferMstModel item)? onSelect;
  final void Function(BranchTransferMstModel item)? onDelete;

  BranchTransferSearchDataGridSource({
    required List<BranchTransferMstModel> list,
    this.onSelect,
    this.onDelete,
  }) {
    updateList(list);
  }

  void updateList(List<BranchTransferMstModel> newList) {
    _list = List.from(newList);
    _buildRows();
    notifyListeners();
  }

  void _buildRows() {
    _dataGridRows = _list.map<DataGridRow>((item) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'ID', value: item.branchTransferMstID ?? 0),
        DataGridCell<String>(columnName: 'Date', value: item.displayDate),
        DataGridCell<String>(columnName: 'FromMan', value: item.fromManagerName),
        DataGridCell<String>(columnName: 'ToMan', value: item.toManagerName),
        DataGridCell<int>(columnName: 'Items', value: item.totalItems ?? item.items.length),
        DataGridCell<double>(columnName: 'StockWt', value: item.totalStockWt ?? 0.0),
        DataGridCell<double>(columnName: 'IssueWt', value: item.totalIssueWt ?? 0.0),
        DataGridCell<double>(columnName: 'IssueAmt', value: item.totalIssueAmt ?? 0.0),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: Colors.transparent,
      cells: row.getCells().map<Widget>((cell) {

        String displayVal = cell.value?.toString() ?? '-';
        if (cell.columnName == 'StockWt' || cell.columnName == 'IssueWt') {
          displayVal = (cell.value as double? ?? 0.0).toStringAsFixed(3);
        } else if (cell.columnName == 'IssueAmt') {
          displayVal =
              NumberFormat('#,##0.00').format(cell.value as double? ?? 0.0);
        }

        final isNumeric = cell.columnName == 'ID' ||
            cell.columnName == 'Items' ||
            cell.columnName == 'StockWt' ||
            cell.columnName == 'IssueWt' ||
            cell.columnName == 'IssueAmt';

        return Container(
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
        );
      }).toList(),
    );
  }
}

