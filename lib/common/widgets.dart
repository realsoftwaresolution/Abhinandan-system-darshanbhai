import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future infoDialog ({required String messageText}){
  return Get.defaultDialog(
    title: 'Alert',
    content: KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true, // Automatically listens for keyboard events
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
          Get.back(); // Close dialog on Enter key press
        }
      },
      child: Text(messageText),
    ),
    barrierDismissible: false, // Prevent closing by tapping outside
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
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
          Get.back(); // Close dialog on Enter key press
        }
      },
      child: Text(messageText),
    ),
    barrierDismissible: false, // Prevent closing by tapping outside
    onConfirm: () {
      Get.back(); // Close the dialog on button press
    },
    textConfirm: 'OK',
  );
}


Future errorDialog ({required String messageText}){
  return Get.defaultDialog(
    title: 'Error',
    content: KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true, // Automatically listens for keyboard events
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
          Get.back(); // Close dialog on Enter key press
        }
      },
      child: Text(messageText),
    ),
    barrierDismissible: false, // Prevent closing by tapping outside
    onConfirm: () {
      Get.back(); // Close the dialog on button press
    },
    textConfirm: 'OK',
  );
}

Widget buildTextField(String label, TextEditingController? controller,
    {List<TextInputFormatter>? inputFormatterList,
      VoidCallback? onTap,
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