import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/common/input_formatters.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/payment/pending_payment_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AccountPartyCreditDebitDataGrid extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final DefaultController defaultController = Get.find<DefaultController>();
  final TextEditingController udharDebitController;
  final TextEditingController accountUdharController;
  final TextEditingController accountCreditController;
  final TextEditingController jamaCreditController;

  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();

  AccountPartyCreditDebitDataGrid(
      RxList<PendingPaymentModel> creditDebitData,
      this.udharDebitController,
      this.accountUdharController,
      this.accountCreditController,
      this.jamaCreditController) {
    // Convert the RxList to a standard list for calculations
    List<PendingPaymentModel> dataList = creditDebitData.toList();

    // Populate the data grid rows
    _dataGridRows = dataList.map<DataGridRow>((data) {
      if (kDebugMode) {
        print(' ACCOUNT JAMT: ${data.jAmtRs}');
        print(' ACCOUNT UAMT: ${data.uAmtRs}');
        print(' INVOICE NO: ${data.invNo}');
        print(' BAmt: ${data.bAmtRs}');
        print(' OAmt: ${data.oAmtRs}');
      }
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'Id', value: data.mstID),
        DataGridCell<String>(
            columnName: 'Due Date', value: formatDateFromString(data.dueDate!)),
        DataGridCell<String>(columnName: 'Inv No', value: data.invNo),
        DataGridCell<double>(columnName: 'Jama Rs', value: data.jAmtRs),
        DataGridCell<double>(columnName: 'Udhar Rs', value: data.uAmtRs),
        DataGridCell<double>(columnName: 'Out AmtRs', value: data.bAmtRs),
        DataGridCell<String>(columnName: 'Trn Type', value: data.trnType),
        DataGridCell<String>(columnName: 'TraType', value: data.traType),
        DataGridCell<String>(
            columnName: 'Inv Date',
            value: formatDateFromString(data.orgInvDate!)),
        DataGridCell<String>(columnName: 'Dr/Cr', value: data.drCr),
        DataGridCell<double>(columnName: 'Amt Rs', value: data.amtRs),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    // Alternate row colors based on the index of the row
    int rowIndex = rows.indexOf(row);

    // Check if the row is the summary row
    bool isSummaryRow =
        row.getCells().any((cell) => cell.value.toString().contains('Total'));

    return DataGridRowAdapter(
      color: isSummaryRow
          ? Colors.grey
          : rowIndex % 2 == 0
              ? Colors.grey[200] // Light color for even rows
              : null, // White for odd rows
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            dataGridCell.value.toString(),
            style: TextStyle(
              fontSize: 12,
              color: isSummaryRow ? Colors.white : Colors.black,
              fontWeight: isSummaryRow
                  ? FontWeight.bold
                  : FontWeight.normal, // Bold for summary row
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    final String displayText = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value
            ?.toString() ??
        '';

    // Reset new cell values to avoid persisting previous values
    newCellValue = null;

    return Container(
      constraints: const BoxConstraints(
        minHeight: 0,
        minWidth: 0,
        maxHeight: double.infinity,
        maxWidth: double.infinity,
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 12),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.all(4),
        ),
        inputFormatters: [DecimalTextInputFormatter()],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (String value) {
          if (value.isNotEmpty) {
            newCellValue = value;
          }
        },
        onSubmitted: (String value) {
          submitCell();
        },
      ),
    );
  }

  @override
  Future<void> onCellSubmit(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    final String? invNo = dataGridRow
        .getCells()
        .firstWhere((cell) => cell.columnName == 'Inv No',
            orElse: () =>
                const DataGridCell<String>(columnName: 'Inv No', value: null))
        .value;

    if (invNo == null) {
      return; // Handle the case where the ID is null
    }

    final int originalIndex = defaultController.pendingPaymentList
        .indexWhere((data) => data.invNo == invNo);

    if (originalIndex == -1) {
      infoDialog(messageText: "Data not found in the list for Invoice: $invNo");
      return; // Data not found, so we exit the method
    }

    final PendingPaymentModel currentData =
        defaultController.pendingPaymentList[originalIndex];

    // Parse the initial value from jamaCreditController.text
    double initialDebitValue =
        double.tryParse(udharDebitController.text) ?? 0.0;
    double initialCreditValue =
        double.tryParse(jamaCreditController.text) ?? 0.0;
    // currentData.oAmtRs = currentData.bAmtRs;

    if (column.columnName == 'Jama Rs') {
      if (newCellValue != null) {
        if (currentData.drCr!.toUpperCase() == 'DR') {
          currentData.jAmtRs = double.tryParse(newCellValue) ?? 0.0;
          currentData.uAmtRs = 0.0;
          currentData.oAmtRs = (currentData.bAmtRs ?? 0.00) +
              (currentData.uAmtRs ?? 0.00) -
              (double.tryParse(newCellValue) ?? 0.0);
        } else if (currentData.drCr!.toUpperCase() == 'CR') {
          currentData.jAmtRs = double.tryParse(newCellValue) ?? 0.0;
          currentData.uAmtRs = 0.0;
          currentData.oAmtRs = (currentData.bAmtRs ?? 0.00) +
              (double.tryParse(newCellValue) ?? 0.0) -
              (currentData.uAmtRs ?? 0.00);
        }
        if (kDebugMode) {
          print('CURRENT JAMT Jama Rs: ${currentData.jAmtRs}');
          print('CURRENT UAMT Jama Rs: ${currentData.uAmtRs}');
          print('CURRENT Invoice No: ${currentData.invNo}');
          print('CURRENT BAmt: ${currentData.bAmtRs}');
          print('CURRENT OAmt Rs: ${currentData.oAmtRs}');
        }
      } else {
        // currentData.jAmtRs = 0.0;
        currentData.uAmtRs = 0.0;
        if (currentData.drCr!.toUpperCase() == 'DR') {
          currentData.oAmtRs = (currentData.bAmtRs ?? 0.00) +
              (currentData.uAmtRs ?? 0.00) -
              (currentData.jAmtRs ?? 0.0);
        } else if (currentData.drCr!.toUpperCase() == 'CR') {
          currentData.oAmtRs = (currentData.bAmtRs ?? 0.00) +
              (currentData.jAmtRs ?? 0.00) -
              (currentData.uAmtRs ?? 0.0);
        }
      }
    } else if (column.columnName == 'Udhar Rs') {
      if (newCellValue != null) {
        if (currentData.drCr!.toUpperCase() == 'DR') {
          currentData.uAmtRs = double.tryParse(newCellValue);
          currentData.jAmtRs = 0.0;
          currentData.oAmtRs = (currentData.bAmtRs ?? 0.00) +
              (double.tryParse(newCellValue) ?? 0.0) -
              (currentData.jAmtRs ?? 0.00);
        } else if (currentData.drCr!.toUpperCase() == 'CR') {
          currentData.uAmtRs = double.tryParse(newCellValue);
          currentData.jAmtRs = 0.0;
          currentData.oAmtRs = (currentData.bAmtRs ?? 0.00) +
              (currentData.jAmtRs ?? 0.00) -
              (double.tryParse(newCellValue) ?? 0.0);
        }

        /// Need to Refactor this Logic
        // Need to Refactor this Logic
        if (kDebugMode) {
          print('CURRENT JAMT Udhar Rs: ${currentData.jAmtRs}');
          print('CURRENT UAMT Udhar Rs: ${currentData.uAmtRs}');
          print('CURRENT Invoice No: ${currentData.invNo}');
          print('CURRENT BAmt: ${currentData.bAmtRs}');
          print('CURRENT OAmt Rs: ${currentData.oAmtRs}');
        }
      } else {
        currentData.jAmtRs = 0.0;
        if (currentData.drCr!.toUpperCase() == 'DR') {
          currentData.oAmtRs = (currentData.bAmtRs ?? 0.00) +
              (currentData.uAmtRs ?? 0.00) -
              (currentData.jAmtRs ?? 0.0);
        } else if (currentData.drCr!.toUpperCase() == 'CR') {
          currentData.oAmtRs = (currentData.bAmtRs ?? 0.00) +
              (currentData.jAmtRs ?? 0.00) -
              (currentData.uAmtRs ?? 0.0);
        }
      }
    }

    // Update the grid row with the new data
    _dataGridRows[rowColumnIndex.rowIndex] = DataGridRow(cells: [
      DataGridCell<int>(columnName: 'Id', value: currentData.mstID),
      DataGridCell<String>(
          columnName: 'Due Date',
          value: formatDateFromString(currentData.dueDate!)),
      DataGridCell<String>(columnName: 'Inv No', value: currentData.invNo),
      DataGridCell<double>(columnName: 'Jama Rs', value: currentData.jAmtRs),
      DataGridCell<double>(columnName: 'Udhar Rs', value: currentData.uAmtRs),
      DataGridCell<double>(columnName: 'Out AmtRs', value: currentData.oAmtRs!.abs()),
      DataGridCell<String>(columnName: 'Trn Type', value: currentData.trnType),
      DataGridCell<String>(columnName: 'TraType', value: currentData.traType),
      DataGridCell<String>(
          columnName: 'Inv Date',
          value: formatDateFromString(currentData.orgInvDate!)),
      DataGridCell<String>(columnName: 'Dr/Cr', value: currentData.drCr),
      DataGridCell<double>(columnName: 'Amt Rs', value: currentData.amtRs),
    ]);

    if (column.columnName == 'Jama Rs') {
      double sumJamaRs = _dataGridRows.fold(0.0, (sum, row) {
        final DataGridCell jamaCell =
            row.getCells().firstWhere((cell) => cell.columnName == 'Jama Rs');
        return sum + (jamaCell.value ?? 0.0);
      });

      double updatedCreditValue = initialCreditValue - sumJamaRs;
      accountCreditController.text = updatedCreditValue.toString();
    } else if (column.columnName == 'Udhar Rs') {
      double sumUdharRs = _dataGridRows.fold(0.0, (sum, row) {
        final DataGridCell udharCell =
            row.getCells().firstWhere((cell) => cell.columnName == 'Udhar Rs');
        return sum + (udharCell.value ?? 0.0);
      });

      double updatedDebitValue = initialDebitValue - sumUdharRs;
      accountUdharController.text = updatedDebitValue.toString();
    }

    newCellValue = null;
    // Notify listeners to refresh the DataGrid
    notifyListeners();
  }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    // Check if it's the first column to show "Total" label
    // bool isFirstColumn = rowColumnIndex.columnIndex == 0;

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
}


