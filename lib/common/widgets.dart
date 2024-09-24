import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/party/party_model.dart';
import 'package:real_web_rough_entry_system/rough/rough_model.dart';

final DefaultController defaultController = Get.find<DefaultController>();

Future infoDialog({required String messageText}) {
  return Get.defaultDialog(
    title: 'Alert',
    content: KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true, // Automatically listens for keyboard events
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          Get.back(); // Close dialog on Enter key press
        }
      },
      child: Text(messageText),
    ),
    barrierDismissible: false,
    // Prevent closing by tapping outside
    onConfirm: () {
      Get.back(); // Close the dialog on button press
    },
    textConfirm: 'OK',
  );
}

Future successDialog({required String messageText}) {
  return Get.defaultDialog(
    title: 'Success',
    content: KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true, // Automatically listens for keyboard events
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          Get.back(); // Close dialog on Enter key press
        }
      },
      child: Text(messageText),
    ),
    barrierDismissible: false,
    // Prevent closing by tapping outside
    onConfirm: () {
      Get.back(); // Close the dialog on button press
    },
    textConfirm: 'OK',
  );
}

Future errorDialog({required String messageText}) {
  return Get.defaultDialog(
    title: 'Error',
    content: KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true, // Automatically listens for keyboard events
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          Get.back(); // Close dialog on Enter key press
        }
      },
      child: Text(messageText),
    ),
    barrierDismissible: false,
    // Prevent closing by tapping outside
    onConfirm: () {
      Get.back(); // Close the dialog on button press
    },
    textConfirm: 'OK',
  );
}

Widget buildTextField(String label, TextEditingController? controller,
    {List<TextInputFormatter>? inputFormatterList,
    VoidCallback? onTap,
    bool? readOnly,
    bool? isEnabled,
    ValueChanged<String>? onChanged,
    VoidCallback? onEditingComplete,
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
            readOnly: readOnly ?? false,
            onTap: onTap,
            controller: controller,
            keyboardType: TextInputType.number,
            enabled: isEnabled,
            focusNode: focusNode,
            textInputAction: TextInputAction.next,
            inputFormatters: inputFormatterList,
            decoration: const InputDecoration(
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
            onEditingComplete: onEditingComplete,
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

Widget buildTextField2(String label, TextEditingController? controller,
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

String getRoughName(String? typeCode) {
  final party = defaultController.roughModel.firstWhere(
      (p) => p.roughTypeCode == int.parse(typeCode!),
      orElse: () => RoughModel(roughTypeName: 'Unknown'));
  return party.roughTypeName ?? 'Unknown';
}

String getPartyName(int? partyCode) {
  final party = defaultController.partyMstList.firstWhere(
          (p) => p.partyCode == partyCode,
      orElse: () => PartyMstModel(partyName: 'Unknown'));
  return party.partyName ?? 'Unknown';
}

String formatDate(String date) {
  // Parse the date string into a DateTime object
  DateTime parsedDate = DateTime.parse(date);

  // Format the DateTime object into the desired format
  String formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);

  return formattedDate;
}

String formatDateWithTime(String date) {
  // Parse the date string into a DateTime object
  DateTime parsedDate = DateTime.parse(date);

  // Format the DateTime object into the desired format
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedDate);

  return formattedDate;
}

DateTime dateFormat(String date) {
  DateTime parsedDate = DateTime.parse(date);
  return parsedDate;
}
