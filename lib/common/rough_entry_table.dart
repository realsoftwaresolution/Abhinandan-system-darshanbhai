import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class RoughEntryTable extends StatelessWidget {
  final RxString selectedType;
  final List<DropdownMenuItem<String>> dropdownItems;
  final TextEditingController descriptionController;
  final TextEditingController issWtController;
  final TextEditingController recWtController;
  final TextEditingController rateController;
  final TextEditingController amountController;
  final RxBool isEnabled;
  final GlobalKey<FormState> formKey;
  final Function(String?)? onDropdownChanged;
  final Function addEntry;

  const RoughEntryTable({
    super.key,
    required this.selectedType,
    required this.dropdownItems,
    required this.descriptionController,
    required this.issWtController,
    required this.recWtController,
    required this.rateController,
    required this.amountController,
    required this.isEnabled,
    required this.formKey,
    required this.onDropdownChanged,
    required this.addEntry,
  });

  Widget _buildTextField(String label, TextEditingController? controller,
      {List<TextInputFormatter>? inputFormatterList,
      VoidCallback? onTap,
      bool? isEnabled,
      ValueChanged<String>? onChanged,
      FocusNode? focusNode}) {
    return TextFormField(
      onTap: onTap,
      controller: controller,
      keyboardType: TextInputType.number,
      enabled: isEnabled,
      focusNode: focusNode,
      textInputAction: TextInputAction.next,
      inputFormatters: inputFormatterList,
      decoration: const InputDecoration(
        border: InputBorder.none,
        errorStyle: TextStyle(
          height: 0, // Hides the error message
          fontSize: 0, // Ensures no space is taken by the error message
        ),
        // focusedErrorBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(
        //     color: Colors.red,
        //     // Red border when focused with an error
        //     width: 1.0, // Thin border width
        //   ),
        //   borderRadius: BorderRadius.zero, // Squared corners
        // ),
        // errorBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(
        //     color: Colors.red,
        //     // Red border for errors
        //     width: 1.0, // Thin border width
        //   ),
        //   borderRadius: BorderRadius.zero, // Squared corners
        // ),
        // focusedBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(
        //     color: Colors.blue,
        //     // Black border when focused without error
        //     width: 1.0, // Thin border width
        //   ),
        //   borderRadius: BorderRadius.zero, // Squared corners
        // ),
        // enabledBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(
        //     color: Colors.grey,
        //     // Light grey border when enabled
        //     width: 1.0, // Thin border width
        //   ),
        //   borderRadius: BorderRadius.zero, // Squared corners
        // ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Table(
        border: TableBorder.all(color: Colors.grey),
        columnWidths: const {
          0: FlexColumnWidth(1), // ROUGH Type column
          1: FlexColumnWidth(3), // DESCRIPTION column
          2: FlexColumnWidth(1), // WT column
          3: FlexColumnWidth(1), // RATE column
          4: FlexColumnWidth(1), // RATE column
          5: FlexColumnWidth(1), // AMOUNT column
          6: FlexColumnWidth(0.25), // Action column
        },
        children: [
          // Header Row
          const TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Text('ROUGH',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.start),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Text('DESCRIPTION',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.start),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Text('WT',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.start),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Text('REC WT',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.start),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Text('RATE',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.start),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Text('AMOUNT',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.start),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Text('',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.start),
                ),
              ),
            ],
          ),

          // Input Row
          TableRow(
            children: [
              TableCell(
                child: DropdownButtonFormField<String>(
                  style: const TextStyle(fontSize: 12),
                  value: selectedType.value.isEmpty ? null : selectedType.value,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  ),
                  items: dropdownItems,
                  onChanged: null,
                ),
              ),
              TableCell(
                child: _buildTextField('DESCRIPTION', descriptionController,
                    isEnabled: false),
              ),
              TableCell(
                child: _buildTextField(
                  'ISS WT',
                  issWtController,
                  inputFormatterList: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}'))
                  ],
                  isEnabled: false,
                ),
              ),
              TableCell(
                child: _buildTextField(
                  'REC WT',
                  recWtController,
                  inputFormatterList: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}'))
                  ],
                  isEnabled: isEnabled.value,
                ),
              ),
              TableCell(
                child: _buildTextField(
                  'RATE',
                  rateController,
                  inputFormatterList: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}'))
                  ],
                  isEnabled: false,
                ),
              ),
              TableCell(
                child: _buildTextField('AMOUNT', amountController,
                    isEnabled: false),
              ),
              TableCell(
                child: InkWell(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      addEntry();
                    }
                  },
                  child: const Text(
                    '...',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
