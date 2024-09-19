import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/common/alert_dialog.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memo_issue_details_datagrid.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memo_issue_details_model.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memo_issue_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PartyEntryTable extends StatelessWidget {
  final RxString selectedType;
  final FocusNode partyFocusNode;
  final RxString selectedTypeParty;
  final RxString selectedTypeBroker;
  final RxList<MemoIssueDetailsModel> allRoughDetails;
  final RxList<MemoIssueModel> allSelectedMemoIssue;
  final DefaultController defaultController;
  final DataGridController dataGridController;
  final List<DropdownMenuItem<String>> dropdownItemsParty;
  final List<DropdownMenuItem<String>> dropdownItemsBroker;
  final RxInt selectedMemoRecMstID;
  final RxInt selectedMemoIssueDetID;
  final TextEditingController descriptionController;
  final TextEditingController issWtController;
  final TextEditingController recWtController;
  final TextEditingController rateController;

  // final TextEditingController amountController;
  final TextEditingController dateController;
  final Rx<DateTime?> selectedDate;
  final RxBool isEnabled;
  final Function enableFields;
  final GlobalKey<FormState> formKey;
  final Function(String?)? onDropdownChanged;

  const PartyEntryTable(
      {super.key,
      required this.selectedType,
      required this.partyFocusNode,
      required this.selectedTypeParty,
      required this.selectedTypeBroker,
      required this.allRoughDetails,
      required this.allSelectedMemoIssue,
      required this.defaultController,
      required this.dataGridController,
      required this.dropdownItemsParty,
      required this.dropdownItemsBroker,
      required this.selectedMemoRecMstID,
      required this.selectedMemoIssueDetID,
      required this.descriptionController,
      required this.issWtController,
      required this.recWtController,
      required this.rateController,
      required this.dateController,
      required this.selectedDate,
      required this.isEnabled,
      required this.formKey,
      this.onDropdownChanged,
      required this.enableFields});

  Widget _buildRow(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children
          .map(
            (child) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: child,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildTextField(String label, TextEditingController? controller,
      {List<TextInputFormatter>? inputFormatterList,
      VoidCallback? onTap,
      bool? isEnabled,
      ValueChanged<String>? onChanged,
      FocusNode? focusNode}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 12, // Font size for the label
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            width: 50,
            child: TextFormField(
              onTap: onTap,
              controller: controller,
              keyboardType: TextInputType.number,
              enabled: isEnabled,
              focusNode: focusNode,
              textInputAction: TextInputAction.next,
              inputFormatters: inputFormatterList,
              decoration: const InputDecoration(
                // border: InputBorder.none,
                errorStyle: TextStyle(
                  height: 0, // Hides the error message
                  fontSize: 0, // Ensures no space is taken by the error message
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                    // Red border when focused with an error
                    width: 1.0, // Thin border width
                  ),
                  borderRadius: BorderRadius.zero, // Squared corners
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                    // Red border for errors
                    width: 1.0, // Thin border width
                  ),
                  borderRadius: BorderRadius.zero, // Squared corners
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                    // Black border when focused without error
                    width: 1.0, // Thin border width
                  ),
                  borderRadius: BorderRadius.zero, // Squared corners
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    // Light grey border when enabled
                    width: 1.0, // Thin border width
                  ),
                  borderRadius: BorderRadius.zero, // Squared corners
                ),
                // filled: true,
                // Fill the background
                // fillColor: Colors.white,
                // White background
                isDense: true,
                // Reduces the overall height of the TextField
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ), // Remove top padding, minimal horizontal padding
              ),
              cursorColor: Colors.black,
              // Black cursor color
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12, // Consistent font size with label
              ),
              onChanged: onChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return ''; // Validation still occurs, but no message is shown
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey),
            left: BorderSide(color: Colors.grey),
            right: BorderSide(color: Colors.grey),
          ),
        ),
        child: _buildRow([
          Obx(
            () => Row(
              children: [
                const Text(
                  'PARTY',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 12, // Font size for the label
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                      focusNode: partyFocusNode,
                      style: const TextStyle(fontSize: 12),
                      value: selectedTypeParty.value.isEmpty
                          ? null
                          : selectedTypeParty.value,
                      decoration: const InputDecoration(
                        errorStyle: TextStyle(height: 0, fontSize: 0),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.0),
                          borderRadius: BorderRadius.zero,
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.0),
                          borderRadius: BorderRadius.zero,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                          borderRadius: BorderRadius.zero,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.zero,
                        ),
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      ),
                      items: dropdownItemsParty,
                      onChanged: isEnabled.value
                          ? (value) {
                              selectedTypeParty.value =
                                  value ?? ''; // Handle null case
                            }
                          : null),
                ),
              ],
            ),
          ),
          Obx(
            () => Row(children: [
              const Text(
                'BROKER',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 12, // Font size for the label
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  style: const TextStyle(fontSize: 12),
                  value: selectedTypeBroker.value.isEmpty
                      ? null
                      : selectedTypeBroker.value,
                  decoration: const InputDecoration(
                    errorStyle: TextStyle(
                      height: 0,
                      // Hides the error message
                      fontSize:
                          0, // Ensures no space is taken by the error message
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1.0, // Thin border width
                      ),
                      borderRadius: BorderRadius.zero, // Squared corners
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1.0, // Thin border width
                      ),
                      borderRadius: BorderRadius.zero, // Squared corners
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 1.0, // Thin border width
                      ),
                      borderRadius: BorderRadius.zero, // Squared corners
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0, // Thin border width
                      ),
                      borderRadius: BorderRadius.zero, // Squared corners
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
                  ),
                  items: dropdownItemsBroker,
                  // onChanged: null,
                  onChanged: isEnabled.value
                      ? (value) {
                          if (selectedTypeParty.isEmpty) {
                            infoDialog(messageText: 'Please Select Party.');
                          } else {
                            selectedTypeBroker.value = value ?? '';
                            allSelectedMemoIssue.clear();
                            allSelectedMemoIssue.value =
                                getMemoIssueByPartyAndBroker(
                                    int.parse(selectedTypeParty.value),
                                    int.parse(selectedTypeBroker
                                        .value))!; // Handle null case

                            if (allSelectedMemoIssue.isNotEmpty) {
                              // Clear the rough details list to avoid duplicating data on subsequent calls
                              allRoughDetails.clear();

                              for (var memo in allSelectedMemoIssue) {
                                // Filter the rough details matching the selected memoIssueMstID
                                List<MemoIssueDetailsModel> roughDetails =
                                    defaultController.memoIssueDetailsList
                                        .where((detail) =>
                                            detail.memoIssueMstID ==
                                            memo.memoIssueMstID)
                                        .toList();

                                allRoughDetails.addAll(
                                    roughDetails); // Add the filtered results
                              }

                              if (allRoughDetails.isNotEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return MemoIssueDialog(
                                      dataGridController: dataGridController,
                                      dataSource:
                                          MemoIssueDetailsDataGridSource(
                                              allRoughDetails),
                                      selectedMemoIssueDetID:
                                          selectedMemoIssueDetID,
                                      issWtController: issWtController,
                                      rateController: rateController,
                                      recWtController: recWtController,
                                      descriptionController:
                                          descriptionController,
                                      dateController: dateController,
                                      selectedType: selectedType,
                                      selectedDate: selectedDate,
                                      enableFields:
                                          enableFields, // Function to enable form fields
                                    );
                                  },
                                );
                              } else {
                                infoDialog(messageText: 'No memo issue details found for the selected broker.');
                              }
                            } else {
                           infoDialog(messageText: 'No memo issue found for the selected party and broker.');
                            }
                          }
                        }
                      : null,
                ),
              ),
            ]),
          ),
          Obx(
            () => _buildTextField(
              'DATE',
              dateController,
              isEnabled: isEnabled.value,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );

                if (pickedDate != null) {
                  selectedDate.value = pickedDate;
                  dateController.text =
                      DateFormat('dd-MM-yyyy').format(pickedDate);
                }
              },
            ),
          ),
        ]));
  }

  List<MemoIssueModel>? getMemoIssueByPartyAndBroker(
      int selectedPartyCode, int selectedBrokerCode) {
    // Use `where` to filter entries that match both partyCode and brokerCode
    return defaultController.memoIssueList
        .where((memo) =>
            memo.partyCode == selectedPartyCode &&
            memo.brokerCode == selectedBrokerCode)
        .toList();
  }
}
