import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // If the new value is empty, return it
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Regular expression to check if the new value is valid (digits and one decimal point)
    final RegExp regex = RegExp(r'^\d*\.?\d*?$');

    // Check if the new value matches the regex
    if (regex.hasMatch(newValue.text)) {
      return newValue; // Valid value
    }

    // If the value is invalid, return the old value
    return oldValue;
  }
}
