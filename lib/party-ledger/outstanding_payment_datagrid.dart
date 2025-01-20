import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/party-ledger/outstanding_payment_details_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class OutstandingPaymentDataGrid extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final DefaultController defaultController = Get.find<DefaultController>();

  // double? closingRs;

  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();

  OutstandingPaymentDataGrid(
    RxList<OutstandingPaymentDetails> creditDebitData,
    // this.closingRs,
  ) {
    List<OutstandingPaymentDetails> dataList = creditDebitData.toList();

    _dataGridRows = dataList
        .where((e) => e.status == 'UNPAID')
        .toList()
        .map<DataGridRow>((data) {
      // closingRs = (closingRs ?? 0.0) + (data.creditRs ?? 0.0) - (data.debitRs ?? 0.0);

      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Inv No', value: data.invNo),
        DataGridCell<String>(
            columnName: 'Inv Date',
            value: formatDateFromString(
                data.orgInvDate ?? DateTime.now().toIso8601String())),
        DataGridCell<int>(columnName: 'Due Days', value: data.dueDays),
        DataGridCell<String>(
            columnName: 'Due Date',
            value: formatDateFromString(
                data.dueDate ?? DateTime.now().toIso8601String())),
        DataGridCell<String>(columnName: 'Trn Type', value: data.traType),
        DataGridCell<String>(columnName: 'Dr/Cr', value: data.drCr),
        DataGridCell<double>(columnName: 'Amt Rs', value: data.amtRs),
        DataGridCell<double>(columnName: 'Balance AmtRs', value: data.bAmtRs),
        DataGridCell<String>(columnName: 'Status', value: data.status),
        DataGridCell<double>(columnName: 'Avg Days', value: data.avgDays),
        DataGridCell<double>(columnName: 'Late Days', value: data.lateDays),
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

  Future<void> exportToPdf(BuildContext context, String partyName, fromDate, toDate) async {
    if (_dataGridRows.isEmpty) {
      infoDialog(messageText: 'No Data Available');
      return;
    }

    // Create PDF document and add a page
    final PdfDocument document = PdfDocument();
    document.pageSettings.orientation = PdfPageOrientation.landscape;
    final PdfPage page = document.pages.add();

    // Get graphics of the page to draw text
    final PdfGraphics graphics = page.graphics;

    // Define title text and style
    String title = '.:: Party Ledger ::. $partyName .:: [From $fromDate to $toDate] ::.';
    final PdfFont titleFont = PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
    final Size titleSize = titleFont.measureString(title);

    // Draw the title at the top center of the page
    graphics.drawString(
      title,
      titleFont,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(
        (page.getClientSize().width - titleSize.width) / 2, // Center align
        0, // Position from the top
        titleSize.width,
        titleSize.height,
      ),
    );

    // Create PDF Grid
    final PdfGrid pdfGrid = PdfGrid();
    pdfGrid.columns.add(count: _dataGridRows[0].getCells().length);

    // Add Header Row
    _addHeaderRow(pdfGrid);

    // Add Data Rows
    _addDataRows(pdfGrid);

    // Apply Grid Style (No Padding)
    _applyNoPaddingGridStyle(pdfGrid);

    // Draw the grid below the title
    pdfGrid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, titleSize.height + 5, page.getClientSize().width, page.getClientSize().height),
    );

    // Add footer at the bottom of the page
    const String pageText = 'Page No.: 1                User : A'; // Footer text
    final PdfFont footerFont = PdfStandardFont(PdfFontFamily.helvetica, 10); // Font for footer
    final Size footerSize = footerFont.measureString(pageText); // Measure footer width

    // Draw the footer text at the bottom center
    graphics.drawString(
      pageText,
      footerFont,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(
        (page.getClientSize().width - footerSize.width) / 2, // Center align footer
        page.getClientSize().height - footerSize.height - 10, // Position near bottom
        footerSize.width,
        footerSize.height,
      ),
    );

    // Save and display the PDF
    await _saveAndDisplayPdf(document);
  }

  void _addHeaderRow(PdfGrid pdfGrid) {
    final PdfGridRow headerRow = pdfGrid.headers.add(1)[0];
    for (int i = 0; i < _dataGridRows[0].getCells().length; i++) {
      headerRow.cells[i].value = _dataGridRows[0].getCells()[i].columnName;
      headerRow.cells[i].style = PdfGridCellStyle(
        font: PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
      );
    }
  }

  void _addDataRows(PdfGrid pdfGrid) {
    for (var row in _dataGridRows) {
      final PdfGridRow pdfRow = pdfGrid.rows.add();
      for (int i = 0; i < row.getCells().length; i++) {
        pdfRow.cells[i].value = row.getCells()[i].value?.toString() ?? '';
      }
    }
  }

  void _applyNoPaddingGridStyle(PdfGrid pdfGrid) {
    pdfGrid.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 5, right: 5, top: 2, bottom: 2), // Remove all padding
      font: PdfStandardFont(PdfFontFamily.helvetica, 12),
    );
  }

  Future<void> _saveAndDisplayPdf(PdfDocument document) async {
    // Save the PDF document
    final List<int> bytes = await document.save();
    document.dispose();

    // Convert to Uint8List and display using Printing package
    final Uint8List pdfData = Uint8List.fromList(bytes);
    await Printing.layoutPdf(
      onLayout: (pdf.PdfPageFormat format) async => pdfData,
    );
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
