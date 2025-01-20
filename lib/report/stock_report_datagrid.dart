import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class StockReportDataGrid extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final DefaultController defaultController = Get.find<DefaultController>();

  StockReportDataGrid() {
    _dataGridRows = defaultController.roughModel.map<DataGridRow>((entry) {
      // Calculate 'Pur Wt' for the current roughTypeCode
      double purWt = _calculatePurWt(entry.roughTypeCode!) + _calculateMemoRecWt(entry.roughTypeCode!);
      double sellWt = _calculateSellWt(entry.roughTypeCode!);
      double memoWt = _calculateMemoIssueWt(entry.roughTypeCode!);
      double lossWt = _calculateLossWt(entry.roughTypeCode!);
      double stockWt = (purWt + memoWt) - sellWt - lossWt;

      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Rough', value: entry.roughTypeName),
        DataGridCell<double>(
            columnName: 'Pur Wt', value: double.parse(purWt.toStringAsFixed(2))),
        DataGridCell<double>(
            columnName: 'Sell Wt', value: double.parse(sellWt.toStringAsFixed(2))),
        DataGridCell<double>(columnName: 'Memo Wt', value: double.parse(memoWt.toStringAsFixed(2))),
        DataGridCell<double>(columnName: 'Loss Wt', value: double.parse(lossWt.toStringAsFixed(2))),
        DataGridCell<double>(columnName: 'Stock Wt', value: double.parse(stockWt.toStringAsFixed(2))),
      ]);
    }).toList();
  }

  double _calculatePurWt(int roughTypeCode) {
    final relevantDetails = defaultController.roughDetailsModel
        .where((detail) => detail.roughTypeCode == roughTypeCode)
        .toList();
    double totalWt =
        relevantDetails.fold(0.0, (sum, detail) => sum + detail.wt!);

    return totalWt;
  }

  double _calculateSellWt(int roughTypeCode) {
    final relevantDetails = defaultController.saleDetailsList
        .where((detail) => detail.roughTypeCode == roughTypeCode)
        .toList();
    double totalWt =
        relevantDetails.fold(0.0, (sum, detail) => sum + detail.carats!);

    return totalWt;
  }

  double _calculateMemoIssueWt(int roughTypeCode) {
    final relevantDetails = defaultController.memoIssueDetailsList
        .where((detail) => detail.roughTypeCode == roughTypeCode && detail.rec == 'N')
        .toList();
    double totalWt =
    relevantDetails.fold(0.0, (sum, detail) => sum + detail.carats!);

    return totalWt;
  }

  double _calculateMemoRecWt(int roughTypeCode) {
    final relevantDetails = defaultController.memoRecDetailsList
        .where((detail) => detail.roughTypeCode == roughTypeCode)
        .toList();
    double totalWt =
    relevantDetails.fold(0.0, (sum, detail) => sum + detail.carats!);

    return totalWt;
  }

  double _calculateLossWt(int roughTypeCode) {
    final relevantDetails = defaultController.memoRecDetailsList
        .where((detail) => detail.roughTypeCode == roughTypeCode)
        .toList();
    double totalWt =
    relevantDetails.fold(0.0, (sum, detail) => sum + detail.lossCarats!);

    return totalWt;
  }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    // Check if it's the first column to show "Total" label
    // bool isFirstColumn = rowColumnIndex.columnIndex == 0;
    if (kDebugMode) {
      print(summaryValue);
    }
    return Container(
      alignment: /*isFirstColumn ? Alignment.centerLeft : */
      Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Text(
        /*isFirstColumn ? 'Total' :*/
        summaryValue, // 'Total' in the first column
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    // Alternate row colors based on the index of the row
    int rowIndex = rows.indexOf(row);

    return DataGridRowAdapter(
      color: rowIndex % 2 == 0
          ? Colors.grey[200] // Light color for even rows
          : null, // White for odd rows
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            dataGridCell.value.toString(),
            style: const TextStyle(fontSize: 12),
          ),
        );
      }).toList(),
    );
  }
}
