import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/payment/payment_mst_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PaymentDataGridSource extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final DefaultController defaultController = Get.find<DefaultController>();

  PaymentDataGridSource(RxList<PaymentMstModel> partyList) {
    _dataGridRows = partyList
        .where((e) => e.companyCode == defaultController.companyCode.value)
        .toList()
        .map<DataGridRow>((payment) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'Id', value: payment.paymentMstID),
        // DataGridCell<int>(columnName: 'Book Party', value: payment.partyCode),
        // DataGridCell<int>(columnName: 'Account Party', value: payment.accountCode),
        DataGridCell<String>(
            columnName: 'Date',
            value: formatDateFromString(payment.paymentDate!)),
        DataGridCell<String>(columnName: 'Day', value: payment.paymentDay),
        DataGridCell<String>(
            columnName: 'Cheque No.', value: payment.chequeNo!),
        DataGridCell<String>(
            columnName: 'Party', value: getPartyName(payment.partyCode)),
        DataGridCell<String>(
            columnName: 'Account', value: getPartyName(payment.accountCode)),
        DataGridCell<String>(columnName: 'Rate Type', value: payment.rateType),
        DataGridCell<double>(columnName: 'Jama AmtRs', value: payment.jAmtRs),
        DataGridCell<double>(columnName: 'Udhar AmtRs', value: payment.uAmtRs),
        DataGridCell<String>(columnName: 'Remarks', value: payment.remarks1),
        DataGridCell<double>(columnName: 'Acc. AmtRs', value: payment.aAmtRs),
      ]);
    }).toList();
  }

  void updateDataSource(List<PaymentMstModel> newData) {
    _dataGridRows = newData
        .map<DataGridRow>((payment) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'Id', value: payment.paymentMstID),
              DataGridCell<String>(
                  columnName: 'Date', value: formatDate(payment.paymentDate!)),
              DataGridCell<String>(
                  columnName: 'Day', value: payment.paymentDay),
              DataGridCell<String>(
                  columnName: 'Cheque No.', value: payment.chequeNo!),
              DataGridCell<String>(
                  columnName: 'Party', value: getPartyName(payment.partyCode)),
              DataGridCell<String>(
                  columnName: 'Account',
                  value: getPartyName(payment.accountCode)),
              DataGridCell<String>(
                  columnName: 'Rate Type', value: payment.rateType),
              DataGridCell<double>(
                  columnName: 'Jama AmtRs', value: payment.jAmtRs),
              DataGridCell<double>(
                  columnName: 'Udhar AmtRs', value: payment.uAmtRs),
              DataGridCell<String>(
                  columnName: 'Remarks', value: payment.remarks1),
              DataGridCell<double>(
                  columnName: 'Acc. AmtRs', value: payment.aAmtRs),
            ]))
        .toList();

    // Notify the DataGrid about the changes
    notifyListeners();
  }

  void resetData() {
    updateDataSource(
        defaultController.paymentMstList); // Reset to original data
  }

  // List<PartyMstModel> partyMstList = [...]; // Your list of PartyMstModel objects

  // String formatDateWithTime(String date) {
  //   // Parse the date string into a DateTime object
  //   DateTime parsedDate = DateTime.parse(date);
  //
  //   // Format the DateTime object into the desired format
  //   String formattedDate =
  //       DateFormat('dd-MM-yyyy hh:mm:ss a').format(parsedDate);
  //
  //   return formattedDate;
  // }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    // Check if it's the first column to show "Total" label
    bool isFirstColumn = false;
    // if (summaryColumn!.name == 'Date') {
    //   isFirstColumn = true;
    // }
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
