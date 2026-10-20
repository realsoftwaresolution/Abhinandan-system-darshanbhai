import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/purchase/purchase_details_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PurchaseDataGridSource extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final DefaultController defaultController = Get.find<DefaultController>();

  PurchaseDataGridSource(RxList<PurchaseDetailsModel> partyList) {
    _buildRows(partyList);
  }

  void updateDataSource(List<PurchaseDetailsModel> newData) {
    _buildRows(newData);
    notifyListeners();
  }

  void resetData() {
    final int currentCompany = defaultController.companyCode.value;
    updateDataSource(
      defaultController.purchaseDataList.where((e) {
        if (currentCompany == 0) return true;
        if (e.companyCode == null || e.companyCode == 0) return true;
        return e.companyCode == currentCompany;
      }).toList(),
    );
  }

  void _buildRows(List<PurchaseDetailsModel> list) {
    final int currentCompany = defaultController.companyCode.value;
    List<PurchaseDetailsModel> sortedList = list.where((e) {
      if (currentCompany == 0) return true;
      if (e.companyCode == null || e.companyCode == 0) return true;
      return e.companyCode == currentCompany;
    }).toList();
    sortedList.sort((a, b) {
      if (a.invoiceDate == null && b.invoiceDate == null) return 0;
      if (a.invoiceDate == null) return 1;
      if (b.invoiceDate == null) return -1;
      return b.invoiceDate!.compareTo(a.invoiceDate!);
    });

    _dataGridRows = sortedList.map<DataGridRow>((purchase) {
      return DataGridRow(cells: [
        DataGridCell<int>(
          columnName: 'ID',
          value: purchase.roughPurMstID ?? 0,
        ),
        DataGridCell<dynamic>(
          columnName: 'CrId',
          value: purchase.crId ?? '',
        ),
        DataGridCell<String>(
          columnName: 'Invoice No',
          value: purchase.invoiceNo ?? '',
        ),
        DataGridCell<String>(
          columnName: 'Inv. Date',
          value: formatShortDate(purchase.invoiceDate),
        ),
        DataGridCell<String>(
          columnName: 'Rec Date',
          value: formatShortDate(purchase.recdate),
        ),
        DataGridCell<String>(
          columnName: 'Party',
          value: getPartyName(purchase.partyCode),
        ),
        DataGridCell<String>(
          columnName: 'Broker',
          value: _getBrokerDisplay(purchase.brokerCode),
        ),
        DataGridCell<String>(
          columnName: 'Rs / \$',
          value: purchase.rDType ?? 'RS',
        ),
        DataGridCell<double>(
          columnName: 'Exchange',
          value: _toDouble(purchase.exchange),
        ),
        DataGridCell<double>(
          columnName: 'Tot Wt',
          value: _toDouble(purchase.tWeight),
        ),
        DataGridCell<double>(
          columnName: 'Tot Amt Rs',
          value: _toDouble(purchase.totAmtRs ?? purchase.tAmtRs),
        ),
        DataGridCell<double>(
          columnName: 'Tot Amt (\$)',
          value: _toDouble(purchase.totAmtDollar ?? purchase.tAmtDollar),
        ),
        DataGridCell<String>(
          columnName: 'BillType',
          value: purchase.bIllType ?? 'BILL',
        ),
        DataGridCell<double>(
          columnName: 'Final Amt Rs 1',
          value: _toDouble(purchase.finalAmtRs ?? purchase.finalNetAmtRs ?? 0.0),
        ),
        DataGridCell<double>(
          columnName: 'Final Amt \$ 1',
          value: _toDouble(purchase.finalAmtD ?? purchase.finalNetAmtDollar ?? 0.0),
        ),
        DataGridCell<double>(
          columnName: 'Round Of Rs 1',
          value: _toDouble(purchase.roundOfRs ?? 0.0),
        ),
        DataGridCell<double>(
          columnName: 'Round Of \$ 1',
          value: _toDouble(purchase.roundOfD ?? 0.0),
        ),
        DataGridCell<double>(
          columnName: 'Final Net Amt Dollar',
          value: _toDouble(purchase.totNetAmtDollar ?? purchase.finalNetAmtDollar ?? purchase.totAmtDollar),
        ),
        DataGridCell<double>(
          columnName: 'Final Net Amt Rs',
          value: _toDouble(purchase.totNetAmtRs ?? purchase.finalNetAmtRs ?? purchase.totAmtRs),
        ),
        DataGridCell<double>(
          columnName: 'Final Amt Rs 2',
          value: _toDouble(purchase.finalAmtRs ?? purchase.finalNetAmtRs ?? purchase.netAmtRs ?? purchase.totAmtRs),
        ),
        DataGridCell<double>(
          columnName: 'Final Amt D',
          value: _toDouble(purchase.finalAmtD ?? purchase.finalNetAmtDollar ?? purchase.netAmtDollar ?? purchase.totAmtDollar),
        ),
        DataGridCell<double>(
          columnName: 'Round Of Rs 2',
          value: _toDouble(purchase.roundOfRs ?? 0.0),
        ),
        DataGridCell<double>(
          columnName: 'Round Of D',
          value: _toDouble(purchase.roundOfD ?? 0.0),
        ),
      ]);
    }).toList();
  }

  String _getBrokerDisplay(dynamic brokerCode) {
    if (brokerCode == null || brokerCode == 0 || brokerCode.toString().trim().isEmpty) {
      return 'NULL';
    }
    final name = getPartyName(brokerCode);
    return name.trim().isEmpty ? 'NULL' : name;
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

  String formatDateWithTime(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd-MM-yyyy hh:mm:ss a').format(parsedDate);
    } catch (_) {
      return date;
    }
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
        } else if (colName == 'Inv. Date' ||
            colName == 'Rec Date' ||
            colName == 'Rs / \$' ||
            colName == 'BillType') {
          alignment = Alignment.center;
          text = value?.toString() ?? '';
        } else if (colName == 'Party' ||
            colName == 'Broker' ||
            colName == 'Invoice No') {
          alignment = Alignment.centerLeft;
          text = value?.toString() ?? '';
        } else if (colName == 'Exchange') {
          alignment = Alignment.centerRight;
          final numVal = (value is num) ? value.toDouble() : _toDouble(value);
          text = numVal.toStringAsFixed(2);
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
