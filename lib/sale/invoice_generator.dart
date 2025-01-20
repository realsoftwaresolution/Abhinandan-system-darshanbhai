import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:real_web_rough_entry_system/common/widgets.dart';

class SaleInvoiceGenerator {
  Future<Uint8List> generateInvoice({
    required int id,
    required String invoiceNo,
    required String partyCode,
    required DateTime invoiceDate,
    required String dueDate,
    required String dueDays,
    required String brokerCode,
    required List entries,
    required double totalAmt,
    required double totalRate,
    required double totalWt,
  }) async {
    final pdf = pw.Document();

    // Define A4 Page size
    const pdfPageFormat = PdfPageFormat.a6;
    final Uint8List imageData =
        await _loadImageFromAssets('assets/images/1.png');
    final image = pw.MemoryImage(imageData);
    // final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        pageFormat: pdfPageFormat,
        orientation: pw.PageOrientation.portrait,
        margin: const pw.EdgeInsets.all(10),
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(0),
            child: pw.Expanded(
              child: pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 1),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Image(image, height: 5),
                    // pw.Align(
                    //     alignment: pw.Alignment.topRight,
                    //     child: pw.Row(
                    //       children: [
                    //         // Spacer before the image to push it to the center
                    //         pw.Spacer(flex: 2),
                    //         // Image in the center
                    //         pw.Image(image, height: 10),
                    //         // Spacer between the image and the text
                    //         pw.Spacer(flex: 1),
                    //         // Text at the end
                    //         pw.Text(
                    //           'ORIGINAL',
                    //           style: pw.TextStyle(
                    //             fontSize: 9,
                    //             fontWeight: pw.FontWeight.bold,
                    //           ),
                    //         ),
                    //       ],
                    //     )),
                    // pw.Text(getCompanyDetails(defaultController.companyCode.value).companyName!,
                    //     textAlign: pw.TextAlign.center,
                    //     style: pw.TextStyle(
                    //       fontSize: 12,
                    //       fontWeight: pw.FontWeight.bold,
                    //     )),
                    // pw.SizedBox(height: 1),
                    // pw.Divider(height: 1),
                    // pw.SizedBox(height: 1),
                    //
                    // pw.Text(
                    //     getCompanyDetails(defaultController.companyCode.value).address!,
                    //     maxLines: 2,
                    //     textAlign: pw.TextAlign.center,
                    //     style: const pw.TextStyle(
                    //       fontSize: 9,
                    //     )),
                    // pw.SizedBox(height: 2),
                    // pw.Divider(height: 1),
                    // pw.SizedBox(height: 2),

                    pw.Row(
                        mainAxisAlignment:
                            pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'ORIGINAL',
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          // pw.Text("Mo. ${getCompanyDetails(defaultController.companyCode.value).mobileno!}",
                          //     style: pw.TextStyle(
                          //         fontSize: 9,
                          //         fontWeight: pw.FontWeight.bold)),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(3),
                            decoration: const pw.BoxDecoration(
                                color: PdfColors.black),
                            child: pw.Text("SALE",
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColors.white,
                                    fontWeight: pw.FontWeight.bold)),
                          )
                        ]),
                    pw.SizedBox(height: 2),
                    pw.Divider(height: 1),
                    pw.SizedBox(height: 5),
                    // pw.Row(
                    //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     pw.Text("Jangad No:$id",
                    //         style: const pw.TextStyle(fontSize: 9)),
                    //     pw.Text("Date: $invoiceDate",
                    //         style: const pw.TextStyle(fontSize: 9)),
                    //   ],
                    // ),
                    pw.Table(
                      border: pw.TableBorder.all(width: 0.1),
                      // Optional: Adds border to the table
                      columnWidths: {
                        0: const pw.FlexColumnWidth(2),
                        // Adjust the column widths if needed
                        1: const pw.FlexColumnWidth(0.65),
                        // 2: const pw.FlexColumnWidth(0.65),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(2),
                              // Padding around the text
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                        text: 'Jangad No.:',
                                        // Underlined "S"
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 9)),
                                    pw.TextSpan(
                                      text: ' $invoiceNo', // Normal text
                                      style:
                                          const pw.TextStyle(fontSize: 9),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // pw.Padding(
                            //   padding: const pw.EdgeInsets.all(2),
                            //   // Padding around the text
                            //   child: pw.RichText(
                            //     text: pw.TextSpan(
                            //       children: [
                            //         pw.TextSpan(
                            //             text: 'Date: ',
                            //             // Underlined "S"
                            //             style: pw.TextStyle(
                            //                 fontWeight: pw.FontWeight.bold,
                            //                 fontSize: 9)),
                            //         pw.TextSpan(
                            //           text: DateFormat('dd-MM-yyyy')
                            //               .format(invoiceDate),
                            //           // Normal text
                            //           style:
                            //               const pw.TextStyle(fontSize: 9),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(2),
                              // Padding around the text
                              child: pw.Text("Date ",
                                  textAlign: pw.TextAlign.end,
                                  style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(2),
                              // Padding around the text
                              child: pw.Text(
                                  DateFormat('dd-MM-yyyy')
                                      .format(invoiceDate),
                                  style: const pw.TextStyle(fontSize: 9)),
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(2),
                              // Padding around the text
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                        text: 'Party: ',
                                        // Underlined "S"
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 9)),
                                    pw.TextSpan(
                                      // text: 'MANGUKIYA NISARG DHIRUBHAI',
                                      text: getPartyName(
                                          int.tryParse(partyCode)),
                                      // Normal text
                                      style:
                                          const pw.TextStyle(fontSize: 9),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)
                            // pw.Padding(
                            //     padding: const pw.EdgeInsets.all(2),
                            //     child: pw.Text(
                            //       "Party",
                            //       style: pw.TextStyle(
                            //           fontSize: 9,
                            //           fontWeight: pw.FontWeight.bold),
                            //     )),
                            // pw.Padding(
                            //     padding: const pw.EdgeInsets.all(2),
                            //     child: pw.Text(
                            //       getPartyName(int.tryParse(partyCode)),
                            //       style: const pw.TextStyle(fontSize: 9),
                            //     )),
                            // pw.Padding(
                            //   padding: const pw.EdgeInsets.all(2),
                            //   child: pw.Text("Due Date ",
                            //       textAlign: pw.TextAlign.end,
                            //       style: pw.TextStyle(
                            //           fontSize: 9,
                            //           fontWeight: pw.FontWeight.bold)),
                            // ),
                            // pw.Padding(
                            //   padding: const pw.EdgeInsets.all(2),
                            //   child: pw.Text(dueDate,
                            //       style: const pw.TextStyle(fontSize: 9)),
                            // ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(2),
                              child: pw.Text("Due Day ",
                                  textAlign: pw.TextAlign.end,
                                  style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(2),
                              child: pw.Text(
                                dueDays,
                                style: const pw.TextStyle(fontSize: 9),
                              ),
                            ),
                          ],
                        ),
                        // pw.TableRow(
                        //   children: [
                        //     pw.Padding(
                        //       padding: const pw.EdgeInsets.all(2),
                        //       // Padding around the text
                        //       child: pw.RichText(
                        //         text: pw.TextSpan(
                        //           children: [
                        //             pw.TextSpan(
                        //                 text: 'Broker: ',
                        //                 // Underlined "S"
                        //                 style: pw.TextStyle(
                        //                     fontWeight: pw.FontWeight.bold,
                        //                     fontSize: 9)),
                        //             pw.TextSpan(
                        //               text: getPartyName(
                        //                   int.parse(brokerCode)),
                        //               // Normal text
                        //               style:
                        //                   const pw.TextStyle(fontSize: 9),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //     // pw.Padding(
                        //     //   padding: const pw.EdgeInsets.all(2),
                        //     //   child: pw.Text("Broker",
                        //     //       style: pw.TextStyle(
                        //     //           fontSize: 9,
                        //     //           fontWeight: pw.FontWeight.bold)),
                        //     // ),
                        //     // pw.Padding(
                        //     //   padding: const pw.EdgeInsets.all(2),
                        //     //   child: pw.Text(
                        //     //     getPartyName(int.parse(brokerCode)),
                        //     //     style: const pw.TextStyle(fontSize: 9),
                        //     //   ),
                        //     // ),
                        //     pw.Padding(
                        //       padding: const pw.EdgeInsets.all(2),
                        //       child: pw.Text("Due Day ",
                        //           textAlign: pw.TextAlign.end,
                        //           style: pw.TextStyle(
                        //               fontSize: 9,
                        //               fontWeight: pw.FontWeight.bold)),
                        //     ),
                        //     pw.Padding(
                        //       padding: const pw.EdgeInsets.all(2),
                        //       child: pw.Text(
                        //         dueDays,
                        //         style: const pw.TextStyle(fontSize: 9),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                    pw.SizedBox(height: 10),

                    // Table for invoice data
                    pw.Table(
                      border: pw.TableBorder.all(),
                      columnWidths: {
                        0: const pw.FlexColumnWidth(0.75),
                        1: const pw.FlexColumnWidth(1.5),
                        2: const pw.FlexColumnWidth(1),
                        3: const pw.FlexColumnWidth(1),
                        4: const pw.FlexColumnWidth(1.5),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(2),
                                child: pw.Text("Sr No",
                                    textAlign: pw.TextAlign.center,
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold))),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(2),
                                child: pw.Text("Rough",
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold))),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(2),
                                child: pw.Text("Ct",
                                    textAlign: pw.TextAlign.right,
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold))),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(2),
                                child: pw.Text("Rate",
                                    textAlign: pw.TextAlign.right,
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold))),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(2),
                                child: pw.Text("Amt",
                                    textAlign: pw.TextAlign.right,
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold))),
                          ],
                        ),
                        for (int i = 0; i < entries.length; i++)
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                  padding: const pw.EdgeInsets.all(2),
                                  child: pw.Text("${i + 1}",
                                      textAlign: pw.TextAlign.center,
                                      style:
                                          const pw.TextStyle(fontSize: 9))),
                              pw.Padding(
                                  padding: const pw.EdgeInsets.all(2),
                                  child: pw.Text(
                                      getRoughName(entries[i]['rough']),
                                      style:
                                          const pw.TextStyle(fontSize: 9))),
                              pw.Padding(
                                  padding: const pw.EdgeInsets.all(2),
                                  child: pw.Text("${entries[i]['wt']}",
                                      textAlign: pw.TextAlign.right,
                                      style:
                                          const pw.TextStyle(fontSize: 9))),
                              pw.Padding(
                                  padding: const pw.EdgeInsets.all(2),
                                  child: pw.Text("${entries[i]['rate']}",
                                      textAlign: pw.TextAlign.right,
                                      style:
                                          const pw.TextStyle(fontSize: 9))),
                              pw.Padding(
                                  padding: const pw.EdgeInsets.all(2),
                                  child: pw.Text("${entries[i]['amount']}",
                                      textAlign: pw.TextAlign.right,
                                      style:
                                          const pw.TextStyle(fontSize: 9))),
                            ],
                          ),
                      ],
                    ),

                    // Total section
                    pw.Table(
                      border: pw.TableBorder.all(),
                      columnWidths: {
                        0: const pw.FlexColumnWidth(2.25),
                        1: const pw.FlexColumnWidth(1),
                        2: const pw.FlexColumnWidth(1),
                        3: const pw.FlexColumnWidth(1.5),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(2),
                                child: pw.Text("Total",
                                    textAlign: pw.TextAlign.center,
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold))),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(2),
                                child: pw.Text(totalWt.toStringAsFixed(2),
                                    textAlign: pw.TextAlign.right,
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold))),
                            pw.Text(""),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(2),
                                child: pw.Text(totalAmt.toStringAsFixed(2),
                                    textAlign: pw.TextAlign.right,
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold))),
                          ],
                        ),
                      ],
                    ),

                    pw.SizedBox(height: 30),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        // pw.Text("Deliver Sign",
                        //     style: pw.TextStyle(
                        //         fontSize: 10,
                        //         fontWeight: pw.FontWeight.bold)),
                        pw.Text("Receiver Sign",
                            style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
    pdf.addPage(
      pw.Page(
        pageFormat: pdfPageFormat,
        orientation: pw.PageOrientation.portrait,
        margin: const pw.EdgeInsets.all(10),
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(0),
            child: pw.Expanded(
              child: pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 1),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Image(image, height: 5),
                    // pw.Align(
                    //     alignment: pw.Alignment.topRight,
                    //     child: pw.Row(
                    //       children: [
                    //         // Spacer before the image to push it to the center
                    //         pw.Spacer(flex: 2),
                    //         // Image in the center
                    //         pw.Image(image, height: 10),
                    //         // Spacer between the image and the text
                    //         pw.Spacer(flex: 1),
                    //         // Text at the end
                    //         pw.Text(
                    //           'ORIGINAL',
                    //           style: pw.TextStyle(
                    //             fontSize: 9,
                    //             fontWeight: pw.FontWeight.bold,
                    //           ),
                    //         ),
                    //       ],
                    //     )),
                    // pw.Text(getCompanyDetails(defaultController.companyCode.value).companyName!,
                    //     textAlign: pw.TextAlign.center,
                    //     style: pw.TextStyle(
                    //       fontSize: 12,
                    //       fontWeight: pw.FontWeight.bold,
                    //     )),
                    // pw.SizedBox(height: 1),
                    // pw.Divider(height: 1),
                    // pw.SizedBox(height: 1),
                    //
                    // pw.Text(
                    //     getCompanyDetails(defaultController.companyCode.value).address!,
                    //     maxLines: 2,
                    //     textAlign: pw.TextAlign.center,
                    //     style: const pw.TextStyle(
                    //       fontSize: 9,
                    //     )),
                    // pw.SizedBox(height: 2),
                    // pw.Divider(height: 1),
                    // pw.SizedBox(height: 2),

                    pw.Row(
                        mainAxisAlignment:
                        pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'DUPLICATE',
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          // pw.Text("Mo. ${getCompanyDetails(defaultController.companyCode.value).mobileno!}",
                          //     style: pw.TextStyle(
                          //         fontSize: 9,
                          //         fontWeight: pw.FontWeight.bold)),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(3),
                            decoration: const pw.BoxDecoration(
                                color: PdfColors.black),
                            child: pw.Text("SALE",
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColors.white,
                                    fontWeight: pw.FontWeight.bold)),
                          )
                        ]),
                    pw.SizedBox(height: 2),
                    pw.Divider(height: 1),
                    pw.SizedBox(height: 5),
                    // pw.Row(
                    //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     pw.Text("Jangad No:$id",
                    //         style: const pw.TextStyle(fontSize: 9)),
                    //     pw.Text("Date: $invoiceDate",
                    //         style: const pw.TextStyle(fontSize: 9)),
                    //   ],
                    // ),
                    pw.Table(
                      border: pw.TableBorder.all(width: 0.1),
                      // Optional: Adds border to the table
                      columnWidths: {
                        0: const pw.FlexColumnWidth(2),
                        // Adjust the column widths if needed
                        1: const pw.FlexColumnWidth(0.65),
                        // 2: const pw.FlexColumnWidth(0.65),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(2),
                              // Padding around the text
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                        text: 'Jangad No.:',
                                        // Underlined "S"
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 9)),
                                    pw.TextSpan(
                                      text: ' $invoiceNo', // Normal text
                                      style:
                                      const pw.TextStyle(fontSize: 9),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // pw.Padding(
                            //   padding: const pw.EdgeInsets.all(2),
                            //   // Padding around the text
                            //   child: pw.RichText(
                            //     text: pw.TextSpan(
                            //       children: [
                            //         pw.TextSpan(
                            //             text: 'Date: ',
                            //             // Underlined "S"
                            //             style: pw.TextStyle(
                            //                 fontWeight: pw.FontWeight.bold,
                            //                 fontSize: 9)),
                            //         pw.TextSpan(
                            //           text: DateFormat('dd-MM-yyyy')
                            //               .format(invoiceDate),
                            //           // Normal text
                            //           style:
                            //               const pw.TextStyle(fontSize: 9),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(2),
                              // Padding around the text
                              child: pw.Text("Date ",
                                  textAlign: pw.TextAlign.end,
                                  style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(2),
                              // Padding around the text
                              child: pw.Text(
                                  DateFormat('dd-MM-yyyy')
                                      .format(invoiceDate),
                                  style: const pw.TextStyle(fontSize: 9)),
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(2),
                              // Padding around the text
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                        text: 'Party: ',
                                        // Underlined "S"
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 9)),
                                    pw.TextSpan(
                                      // text: 'MANGUKIYA NISARG DHIRUBHAI',
                                      text: getPartyName(
                                          int.tryParse(partyCode)),
                                      // Normal text
                                      style:
                                      const pw.TextStyle(fontSize: 9),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)
                            // pw.Padding(
                            //     padding: const pw.EdgeInsets.all(2),
                            //     child: pw.Text(
                            //       "Party",
                            //       style: pw.TextStyle(
                            //           fontSize: 9,
                            //           fontWeight: pw.FontWeight.bold),
                            //     )),
                            // pw.Padding(
                            //     padding: const pw.EdgeInsets.all(2),
                            //     child: pw.Text(
                            //       getPartyName(int.tryParse(partyCode)),
                            //       style: const pw.TextStyle(fontSize: 9),
                            //     )),
                            // pw.Padding(
                            //   padding: const pw.EdgeInsets.all(2),
                            //   child: pw.Text("Due Date ",
                            //       textAlign: pw.TextAlign.end,
                            //       style: pw.TextStyle(
                            //           fontSize: 9,
                            //           fontWeight: pw.FontWeight.bold)),
                            // ),
                            // pw.Padding(
                            //   padding: const pw.EdgeInsets.all(2),
                            //   child: pw.Text(dueDate,
                            //       style: const pw.TextStyle(fontSize: 9)),
                            // ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(2),
                              child: pw.Text("Due Day ",
                                  textAlign: pw.TextAlign.end,
                                  style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(2),
                              child: pw.Text(
                                dueDays,
                                style: const pw.TextStyle(fontSize: 9),
                              ),
                            ),
                          ],
                        ),
                        // pw.TableRow(
                        //   children: [
                        //     pw.Padding(
                        //       padding: const pw.EdgeInsets.all(2),
                        //       // Padding around the text
                        //       child: pw.RichText(
                        //         text: pw.TextSpan(
                        //           children: [
                        //             pw.TextSpan(
                        //                 text: 'Broker: ',
                        //                 // Underlined "S"
                        //                 style: pw.TextStyle(
                        //                     fontWeight: pw.FontWeight.bold,
                        //                     fontSize: 9)),
                        //             pw.TextSpan(
                        //               text: getPartyName(
                        //                   int.parse(brokerCode)),
                        //               // Normal text
                        //               style:
                        //                   const pw.TextStyle(fontSize: 9),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //     // pw.Padding(
                        //     //   padding: const pw.EdgeInsets.all(2),
                        //     //   child: pw.Text("Broker",
                        //     //       style: pw.TextStyle(
                        //     //           fontSize: 9,
                        //     //           fontWeight: pw.FontWeight.bold)),
                        //     // ),
                        //     // pw.Padding(
                        //     //   padding: const pw.EdgeInsets.all(2),
                        //     //   child: pw.Text(
                        //     //     getPartyName(int.parse(brokerCode)),
                        //     //     style: const pw.TextStyle(fontSize: 9),
                        //     //   ),
                        //     // ),
                        //     pw.Padding(
                        //       padding: const pw.EdgeInsets.all(2),
                        //       child: pw.Text("Due Day ",
                        //           textAlign: pw.TextAlign.end,
                        //           style: pw.TextStyle(
                        //               fontSize: 9,
                        //               fontWeight: pw.FontWeight.bold)),
                        //     ),
                        //     pw.Padding(
                        //       padding: const pw.EdgeInsets.all(2),
                        //       child: pw.Text(
                        //         dueDays,
                        //         style: const pw.TextStyle(fontSize: 9),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                    pw.SizedBox(height: 10),

                    // Table for invoice data
                    pw.Table(
                      border: pw.TableBorder.all(),
                      columnWidths: {
                        0: const pw.FlexColumnWidth(0.75),
                        1: const pw.FlexColumnWidth(1.5),
                        2: const pw.FlexColumnWidth(1),
                        3: const pw.FlexColumnWidth(1),
                        4: const pw.FlexColumnWidth(1.5),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(2),
                                child: pw.Text("Sr No",
                                    textAlign: pw.TextAlign.center,
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold))),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(2),
                                child: pw.Text("Rough",
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold))),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(2),
                                child: pw.Text("Ct",
                                    textAlign: pw.TextAlign.right,
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold))),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(2),
                                child: pw.Text("Rate",
                                    textAlign: pw.TextAlign.right,
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold))),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(2),
                                child: pw.Text("Amt",
                                    textAlign: pw.TextAlign.right,
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold))),
                          ],
                        ),
                        for (int i = 0; i < entries.length; i++)
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                  padding: const pw.EdgeInsets.all(2),
                                  child: pw.Text("${i + 1}",
                                      textAlign: pw.TextAlign.center,
                                      style:
                                      const pw.TextStyle(fontSize: 9))),
                              pw.Padding(
                                  padding: const pw.EdgeInsets.all(2),
                                  child: pw.Text(
                                      getRoughName(entries[i]['rough']),
                                      style:
                                      const pw.TextStyle(fontSize: 9))),
                              pw.Padding(
                                  padding: const pw.EdgeInsets.all(2),
                                  child: pw.Text("${entries[i]['wt']}",
                                      textAlign: pw.TextAlign.right,
                                      style:
                                      const pw.TextStyle(fontSize: 9))),
                              pw.Padding(
                                  padding: const pw.EdgeInsets.all(2),
                                  child: pw.Text("${entries[i]['rate']}",
                                      textAlign: pw.TextAlign.right,
                                      style:
                                      const pw.TextStyle(fontSize: 9))),
                              pw.Padding(
                                  padding: const pw.EdgeInsets.all(2),
                                  child: pw.Text("${entries[i]['amount']}",
                                      textAlign: pw.TextAlign.right,
                                      style:
                                      const pw.TextStyle(fontSize: 9))),
                            ],
                          ),
                      ],
                    ),

                    // Total section
                    pw.Table(
                      border: pw.TableBorder.all(),
                      columnWidths: {
                        0: const pw.FlexColumnWidth(2.25),
                        1: const pw.FlexColumnWidth(1),
                        2: const pw.FlexColumnWidth(1),
                        3: const pw.FlexColumnWidth(1.5),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(2),
                                child: pw.Text("Total",
                                    textAlign: pw.TextAlign.center,
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold))),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(2),
                                child: pw.Text(totalWt.toStringAsFixed(2),
                                    textAlign: pw.TextAlign.right,
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold))),
                            pw.Text(""),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(2),
                                child: pw.Text(totalAmt.toStringAsFixed(2),
                                    textAlign: pw.TextAlign.right,
                                    style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold))),
                          ],
                        ),
                      ],
                    ),

                    pw.SizedBox(height: 30),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        // pw.Text("Deliver Sign",
                        //     style: pw.TextStyle(
                        //         fontSize: 10,
                        //         fontWeight: pw.FontWeight.bold)),
                        pw.Text("Receiver Sign",
                            style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    // Return PDF document as Uint8List
    return await pdf.save();
  }

  Future<Uint8List> _loadImageFromAssets(String path) async {
    return await rootBundle
        .load(path)
        .then((data) => data.buffer.asUint8List());
  }
}
