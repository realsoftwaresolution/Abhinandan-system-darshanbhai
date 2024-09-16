import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memo_issue_model.dart';
import 'package:real_web_rough_entry_system/party/party_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MemoIssueDataGridSource extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final DefaultController defaultController = Get.find<DefaultController>();

  MemoIssueDataGridSource(RxList<MemoIssueModel> memoIssueList) {
    _dataGridRows = memoIssueList.map<DataGridRow>((purchase) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'ID', value: purchase.memoIssueMstID),
        // DataGridCell<String>(
        //     columnName: 'Invoice No', value: purchase.invoiceNo),
        DataGridCell<String>(
            columnName: 'Invoice Date', value: purchase.invoiceDate),
        // DataGridCell<String>(
        //     columnName: 'Rec Date', value: purchase.recdate),
        DataGridCell<String>(
            columnName: 'Party', value: getPartyName(purchase.partyCode)),
        DataGridCell<String>(
            columnName: 'Broker', value: getPartyName(purchase.brokerCode)),
        // DataGridCell<double>(columnName: 'Rs /\$', value: purchase.addFixRs),
        // DataGridCell<double>(columnName: 'Exchange', value: purchase.exchange),
        DataGridCell<double>(columnName: 'Tot Wt', value: purchase.tWeight),
        DataGridCell<double>(
            columnName: 'Tot Amt Rs', value: purchase.totRsAmt),
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

  String getPartyName(int? partyCode) {
    final party = defaultController.partyMstList.firstWhere(
        (p) => p.partyCode == partyCode,
        orElse: () => PartyMstModel(partyName: 'Unknown'));
    return party.partyName ?? 'Unknown';
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      for (var cell in row.getCells())
        cell.columnName == 'Active'
            ? Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: Checkbox(
                  value: cell.value as bool,
                  onChanged: (value) {}, // Disable interaction
                ),
              )
            : Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  cell.value.toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
    ]);
  }
}
