import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memo_issue_details_model.dart';
import 'package:real_web_rough_entry_system/party/party_model.dart';
import 'package:real_web_rough_entry_system/rough/rough_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MemoIssueDetailsDataGridSource extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final DefaultController defaultController = Get.find<DefaultController>();
  double totalWt = 0;

  MemoIssueDetailsDataGridSource(
      RxList<MemoIssueDetailsModel> memoIssueDetailsList) {
    totalWt =
        memoIssueDetailsList.fold(0, (sum, item) => sum + (item.carats ?? 0));
    _dataGridRows = memoIssueDetailsList.map<DataGridRow>((purchase) {
      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'Rough Type',
            value: getRoughName(purchase.roughTypeCode)),
        DataGridCell<double>(columnName: 'Wt', value: purchase.carats),
        DataGridCell<int>(
            columnName: 'Issue ID', value: purchase.memoIssueMstID),
        DataGridCell<int>(
            columnName: 'Detail ID', value: purchase.memoIssueDetID),
      ]);
    }).toList();
  }

  String getPartyName(int? partyCode) {
    final party = defaultController.partyMstList.firstWhere(
        (p) => p.partyCode == partyCode,
        orElse: () => PartyMstModel(partyName: 'Unknown'));
    return party.partyName ?? 'Unknown';
  }

  String getRoughName(int? typeCode) {
    final party = defaultController.roughModel.firstWhere(
        (p) => p.roughTypeCode == typeCode!,
        orElse: () => RoughModel(roughTypeName: 'Unknown'));
    return party.roughTypeName ?? 'Unknown';
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = rows.indexOf(row);
    return DataGridRowAdapter(
      color: rowIndex % 2 == 0
          ? Colors.grey[200] // Light color for even rows
          : null,
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(dataGridCell.value.toString(),
            style: const TextStyle(fontSize: 12),),
        );
      }).toList(),
    );
  }
}
