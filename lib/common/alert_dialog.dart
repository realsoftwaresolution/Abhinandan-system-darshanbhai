import 'package:flutter/material.dart' show AlertDialog, Alignment, BuildContext, Container, EdgeInsets, FontWeight, OutlinedButton, SizedBox, StatelessWidget, Text, TextEditingController, TextStyle, Widget;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memo_issue_details_datagrid.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memo_issue_details_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// Common Widget for SfDataGrid in AlertDialog
class MemoIssueDialog extends StatelessWidget {
  final DataGridController dataGridController;
  final MemoIssueDetailsDataGridSource dataSource;
  final RxInt selectedMemoIssueDetID;
  final TextEditingController issWtController;
  final TextEditingController rateController;
  final TextEditingController recWtController;
  final TextEditingController descriptionController;
  final TextEditingController dateController;
  final RxString selectedType;
  final Rx<DateTime?> selectedDate;
  final Function enableFields;

  const MemoIssueDialog({super.key,
    required this.dataGridController,
    required this.dataSource,
    required this.selectedMemoIssueDetID,
    required this.issWtController,
    required this.rateController,
    required this.recWtController,
    required this.descriptionController,
    required this.dateController,
    required this.selectedType,
    required this.selectedDate,
    required this.enableFields,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Entry to Receive'),
      content: SizedBox(
        width: double.maxFinite,
        child: SfDataGrid(
            controller: dataGridController,
            source: dataSource,
            columns: <GridColumn>[
              GridColumn(
                columnName: 'Wt',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Wt',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'Rough Type',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Rough Type',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'Memo Issue ID',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Memo Issue ID',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'Memo Issue Detail ID',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Memo Issue Detail ID',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
            rowHeight: 30,
            headerRowHeight: 40,
            gridLinesVisibility: GridLinesVisibility.both,
            headerGridLinesVisibility: GridLinesVisibility.both,
            selectionMode: SelectionMode.singleDeselect,
            onSelectionChanged:
                (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
              if (addedRows.isNotEmpty) {
                final DataGridRow selectedRow = addedRows.first;

                // Retrieve the selected memo issue detail ID from the selected row
                selectedMemoIssueDetID.value = selectedRow.getCells()[3].value;

                // Find the corresponding rough data for the selected memo issue detail
                MemoIssueDetailsModel roughEntry = dataSource
                    .defaultController.memoIssueDetailsList
                    .firstWhere((entry) =>
                        entry.memoIssueDetID == selectedMemoIssueDetID.value);

                // Update the form fields with the selected rough entry details
                selectedType.value = roughEntry.roughTypeCode.toString();
                issWtController.text = roughEntry.carats.toString();
                rateController.text = roughEntry.rateRs.toString();
                recWtController.text = roughEntry.carats.toString();
                descriptionController.text = roughEntry.description.toString();
                dateController.text =
                    DateFormat('dd-MM-yyyy').format(DateTime.now());
                selectedDate.value = DateTime.now();

                enableFields(); // Call the passed function to enable fields
                Get.back(); // Close the dialog
              }
            },
            columnWidthMode: ColumnWidthMode.auto,
            frozenColumnsCount: 1,
          ),
        ),
      actions: <Widget>[
        OutlinedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Get.back();
          },
        ),
      ],
    );
  }
}
