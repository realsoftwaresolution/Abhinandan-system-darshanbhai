import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/assort/rough_assort_mst_model.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class RoughAssortDataGridSource extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final DefaultController defaultController = Get.find<DefaultController>();

  RoughAssortDataGridSource(RxList<RoughAssortMst> assortList) {
    _dataGridRows = assortList
        // .where((e) => e.companyCode == defaultController.companyCode.value)
        .toList()
        .map<DataGridRow>((assort) {
      double totalRate = defaultController.roughAssortMstDetList
          .where((e) => e.roughAssortMstID == assort.roughAssortMstID)
          .toList()
          .fold(0.0, (preV, e) => preV + e.ammount);
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'ID', value: assort.roughAssortMstID),
        DataGridCell<String>(columnName: 'Invoice No', value: assort.invoiceNo),
        DataGridCell<dynamic>(
            columnName: 'Assort Wt', value: (assort.assortWt!)),
        DataGridCell<double>(
            columnName: 'Amount',
            value: double.parse(totalRate.toStringAsFixed(2))),
        // DataGridCell<String>(
        //     columnName: 'Rec Date', value: purchase.recdate),
        // DataGridCell<String>(
        //     columnName: 'Party', value: getPartyName(assort.partyCode)),
        // DataGridCell<String>(
        //     columnName: 'Broker', value: getPartyName(assort.brokerCode)),
        // DataGridCell<double>(columnName: 'Rs /\$', value: purchase.addFixRs),
        // DataGridCell<double>(columnName: 'Exchange', value: purchase.exchange),
        // DataGridCell<dynamic>(columnName: 'Tot Wt', value: assort.tWeight),
        // DataGridCell<dynamic>(
        //     columnName: 'Tot Amt Rs', value: assort.totAmtRs),
        // DataGridCell<double>(columnName: 'Tot Amt (\$)', value: purchase.totAmtDollar),
        // DataGridCell<String>(columnName: 'Bill Type', value: purchase.bIllType),
        // DataGridCell<double>(columnName: 'Lin Fix Rs', value: purchase.linFixRs),
        // DataGridCell<double>(columnName: 'Tot Exp Fix Rs', value: purchase.totExpFixRs),
        // DataGridCell<double>(columnName: 'Add Fix Rs', value: purchase.addFixRs),
        // DataGridCell<double>(columnName: 'Less Fix Rs', value: purchase.lessFixRs),
        // DataGridCell<double>(columnName: 'Final Net Amt Dollar', value: purchase.finalNetAmtDollar),
        // DataGridCell<double>(columnName: 'Final Net Amt Rs', value: purchase.finalNetAmtRs),
      ]);
    }).toList();
  }

  String formatDateWithTime(String date) {
    // Parse the date string into a DateTime object
    DateTime parsedDate = DateTime.parse(date);

    // Format the DateTime object into the desired format
    String formattedDate =
        DateFormat('dd-MM-yyyy hh:mm:ss a').format(parsedDate);

    return formattedDate;
  }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    // Check if it's the first column to show "Total" label
    bool isFirstColumn = rowColumnIndex.columnIndex == 0;

    return Container(
      alignment: /*isFirstColumn ? Alignment.centerLeft : */
          Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Text(
        /*isFirstColumn ? 'Total' :*/
        summaryValue,
        // isFirstColumn ? summaryValue : double.parse(summaryValue).toStringAsFixed(2), // 'Total' in the first column
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
