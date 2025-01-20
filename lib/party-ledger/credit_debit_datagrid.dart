import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:universal_html/html.dart' as html;
import 'package:printing/printing.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/credit-debit/credit_debit_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

class CreditDebitDataGrid extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  final DefaultController defaultController = Get.find<DefaultController>();
  double? closingRs;

  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();

  CreditDebitDataGrid(
    RxList<CreditDebitMstModel> creditDebitData,
    this.closingRs,
  ) {
    List<CreditDebitMstModel> dataList = creditDebitData.toList();

    _dataGridRows = dataList.map<DataGridRow>((data) {
      closingRs =
          (closingRs ?? 0.0) + (data.creditRs ?? 0.0) - (data.debitRs ?? 0.0);

      return DataGridRow(cells: [
        DataGridCell<int>(
            columnName: 'Id', value: data.mstID),
        DataGridCell<String>(
            columnName: 'Date', value: formatDateFromString(data.invDate!)),
        DataGridCell<String>(
            columnName: 'Particulars', value: getPartyName(data.perPartyCode)),
        DataGridCell<String>(columnName: 'Inv No', value: data.invoiceNo),
        DataGridCell<double>(columnName: 'Cr Rs', value: data.creditRs),
        DataGridCell<double>(columnName: 'Dr Rs', value: data.debitRs),
        DataGridCell<double>(columnName: 'Closing Rs', value: closingRs),
        DataGridCell<String>(columnName: 'Remarks 1', value: data.remarks1),
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



  Future<void> exportToExcel(String partyName, fromDate, toDate) async {
    if (_dataGridRows.isEmpty) {
      infoDialog(messageText: 'No Data Available');
    } else {
      // Create a new Excel workbook.
      final xlsio.Workbook workbook = xlsio.Workbook();
      final xlsio.Worksheet sheet = workbook.worksheets[0];

      // Add header row.
      for (int i = 0; i < _dataGridRows[0].getCells().length; i++) {
        sheet
            .getRangeByIndex(1, i + 1)
            .setText(_dataGridRows[0].getCells()[i].columnName);
      }

      // Populate data rows.
      for (int rowIndex = 0; rowIndex < _dataGridRows.length; rowIndex++) {
        var row = _dataGridRows[rowIndex];
        for (int cellIndex = 0;
            cellIndex < row.getCells().length;
            cellIndex++) {
          sheet
              .getRangeByIndex(rowIndex + 2, cellIndex + 1)
              .setText(row.getCells()[cellIndex].value.toString());
        }
      }

      // Save the workbook as bytes.
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      if (kIsWeb) {
        // Create a blob and download the file on web
        final blob = html.Blob([
          Uint8List.fromList(bytes)
        ], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: url)
          ..setAttribute("download", "Party-Ledger/$partyName-From${fromDate}To$toDate.xlsx")
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        // For mobile and desktop, use path_provider to save the file
        final directory = await getTemporaryDirectory();
        final path = '${directory.path}/Party-Ledger/${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}.xlsx';
        final file = File(path);

        // Write the bytes to the file.
        await file.writeAsBytes(bytes, flush: true);
        if (kDebugMode) {
          print('Excel file saved at $path');
        }

        // Optionally open the file on mobile if needed
        // await OpenFile.open(path);
      }
    }
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
