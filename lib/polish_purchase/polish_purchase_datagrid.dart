import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/polish_purchase/polish_purchase_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PolishPurchaseDataGridSource extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final DefaultController defaultController = Get.find<DefaultController>();

  PolishPurchaseDataGridSource(RxList<PolishPurchaseModel> list) {
    _buildRows(list);
  }

  void updateDataSource(List<PolishPurchaseModel> newData) {
    _buildRows(newData);
    notifyListeners();
  }

  void _buildRows(List<PolishPurchaseModel> list) {
    final int currentCompany = defaultController.companyCode.value;
    List<PolishPurchaseModel> filteredList = list.where((e) {
      if (currentCompany == 0) return true;
      if (e.companyCode == null || e.companyCode == 0) return true;
      return e.companyCode == currentCompany;
    }).toList();

    filteredList.sort((a, b) {
      if (a.invoiceDate == null && b.invoiceDate == null) return 0;
      if (a.invoiceDate == null) return 1;
      if (b.invoiceDate == null) return -1;
      return b.invoiceDate!.compareTo(a.invoiceDate!);
    });

    _dataGridRows = filteredList.map<DataGridRow>((item) {
      return DataGridRow(cells: [
        DataGridCell<int>(
          columnName: 'ID',
          value: item.polishPurMstID ?? 0,
        ),
        DataGridCell<dynamic>(
          columnName: 'CrId',
          value: item.crId ?? '',
        ),
        DataGridCell<String>(
          columnName: 'InvoiceDate',
          value: formatShortDate(item.invoiceDate),
        ),
        DataGridCell<String>(
          columnName: 'Invoice No',
          value: item.invoiceNo ?? '',
        ),
        DataGridCell<String>(
          columnName: 'Party',
          value: item.partyName ?? getPartyName(item.partyCode),
        ),
        DataGridCell<String>(
          columnName: 'Broker',
          value: _getBrokerDisplay(item.brokerName, item.brokerCode),
        ),
        DataGridCell<String>(
          columnName: 'Rs / \$',
          value: item.rdType ?? 'RS',
        ),
        DataGridCell<double>(
          columnName: 'Exchange',
          value: _toDouble(item.exchange),
        ),
        DataGridCell<double>(
          columnName: 'Tot Wt',
          value: _toDouble(item.totWt),
        ),
        DataGridCell<double>(
          columnName: 'Rate Rs',
          value: _toDouble(item.rateRs),
        ),
        DataGridCell<double>(
          columnName: 'Tot Amt Rs',
          value: _toDouble(item.totAmtRs),
        ),
        DataGridCell<double>(
          columnName: 'Rate (\$)',
          value: _toDouble(item.rateDollar),
        ),
        DataGridCell<double>(
          columnName: 'Tot Amt (\$)',
          value: _toDouble(item.totAmtDollar),
        ),
        DataGridCell<double>(
          columnName: 'Net Amt Dollar',
          value: _toDouble(item.netAmtDollar),
        ),
        DataGridCell<double>(
          columnName: 'Net Amt Rs',
          value: _toDouble(item.netAmtRs),
        ),
        DataGridCell<String>(
          columnName: 'Remarks',
          value: item.remarks ?? '',
        ),
        DataGridCell<double>(
          columnName: 'Final Amt Rs',
          value: _toDouble(item.finalAmtRs),
        ),
        DataGridCell<double>(
          columnName: 'Final Amt \$',
          value: _toDouble(item.finalAmtD),
        ),
        DataGridCell<double>(
          columnName: 'Round Of Rs',
          value: _toDouble(item.roundOfRs),
        ),
        DataGridCell<double>(
          columnName: 'Round Of \$',
          value: _toDouble(item.roundOfD),
        ),
      ]);
    }).toList();
  }

  String _getBrokerDisplay(String? brokerName, dynamic brokerCode) {
    if (brokerName != null && brokerName.trim().isNotEmpty) {
      return brokerName;
    }
    if (brokerCode == null || brokerCode == 0 || brokerCode.toString().trim().isEmpty) {
      return '';
    }
    final name = getPartyName(brokerCode);
    return name.trim().isEmpty ? '' : name;
  }

  double _toDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    return double.tryParse(val.toString()) ?? 0.0;
  }

  String formatShortDate(dynamic date) {
    if (date == null) return '';
    final str = date.toString().trim();
    if (str.isEmpty) return '';
    DateTime? parsed = DateTime.tryParse(str);
    if (parsed == null) {
      try {
        parsed = DateFormat('yyyy-MM-dd').parse(str);
      } catch (_) {
        try {
          parsed = DateFormat('dd-MM-yyyy').parse(str);
        } catch (_) {
          return str;
        }
      }
    }
    return DateFormat('dd-MMM-yy').format(parsed);
  }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    if (summaryColumn == null) return null;

    String displayValue = summaryValue;
    final doubleVal = double.tryParse(summaryValue);

    if (doubleVal != null) {
      if (summaryColumn.name == 'ID_count') {
        displayValue = doubleVal.toInt().toString();
      } else if (summaryColumn.name == 'Tot Wt') {
        displayValue = NumberFormat('#,##0.000').format(doubleVal);
      } else {
        displayValue = NumberFormat('#,##0.00').format(doubleVal);
      }
    }

    final bool isCount = summaryColumn.name == 'ID_count';

    return Container(
      alignment: isCount ? Alignment.center : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Text(
        displayValue,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    int rowIndex = rows.indexOf(row);

    return DataGridRowAdapter(
      color: rowIndex % 2 == 0
          ? AppColors.tableRowAlt
          : AppColors.surface,
      cells: row.getCells().map<Widget>((dataGridCell) {
        final colName = dataGridCell.columnName;
        final value = dataGridCell.value;

        Alignment alignment = Alignment.centerLeft;
        String text = '';

        if (colName == 'ID' || colName == 'CrId') {
          alignment = Alignment.center;
          text = value?.toString() ?? '';
        } else if (colName == 'InvoiceDate' || colName == 'Rs / \$') {
          alignment = Alignment.center;
          text = value?.toString() ?? '';
        } else if (colName == 'Party' ||
            colName == 'Broker' ||
            colName == 'Invoice No' ||
            colName == 'Remarks') {
          alignment = Alignment.centerLeft;
          text = value?.toString() ?? '';
        } else if (colName == 'Exchange') {
          alignment = Alignment.centerRight;
          final numVal = (value is num) ? value.toDouble() : _toDouble(value);
          text = numVal.toStringAsFixed(2);
        } else if (colName == 'Tot Wt') {
          alignment = Alignment.centerRight;
          final numVal = (value is num) ? value.toDouble() : _toDouble(value);
          text = numVal.toStringAsFixed(3);
        } else {
          alignment = Alignment.centerRight;
          final numVal = (value is num) ? value.toDouble() : _toDouble(value);
          text = numVal.toStringAsFixed(3);
        }

        return Container(
          alignment: alignment,
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Text(
            text,
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
