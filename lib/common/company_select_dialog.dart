// Company Selection Dialog Widget
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';

class CompanySelectionDialog extends StatelessWidget {
  final bool isSwitchCompany;

  const CompanySelectionDialog({super.key, required this.isSwitchCompany});

  // final List<PartyMstModel> companies = defaultController.partyMstList.where((e)=> e.typeCode == 7).toList();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // isSwitchCompany ? const Text('Switch Company', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),) : const SizedBox.shrink(),
          // isSwitchCompany ? const SizedBox(height: 3,): const SizedBox.shrink(),
          Obx(() {
            return DropdownButtonFormField<int>(
              hint: const Text(
                'Tap to Select Company',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              value: defaultController.companyCode.value == 0
                  ? 3
                  : defaultController.companyCode.value,
              decoration: InputDecoration(
                errorStyle: const TextStyle(
                  height: 0,
                  // Hides the error message
                  fontSize: 0, // Ensures no space is taken by the error message
                ),
                focusedErrorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 1.0, // Thin border width
                  ),
                  borderRadius: BorderRadius.zero, // Squared corners
                ),
                errorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 1.0, // Thin border width
                  ),
                  borderRadius: BorderRadius.zero, // Squared corners
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 1.0, // Thin border width
                  ),
                  borderRadius: BorderRadius.zero, // Squared corners
                ),
                enabledBorder: isSwitchCompany
                    ? const OutlineInputBorder()
                    : const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0, // Thin border width
                        ),
                        borderRadius: BorderRadius.zero, // Squared corners
                      ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ),
              ),
              items: dropdownItemsCompanies,
              onChanged: null,
              // onChanged: (newValue) async {
              //         if (newValue != null) {
              //           // Update the companyCode in the controller
              //           defaultController.companyCode.value = newValue;
              //
              //           // Save the selected company code to SharedPreferences
              //           SharedPreferences prefs =
              //               await SharedPreferences.getInstance();
              //           await prefs.setInt('companyCode', newValue);
              //
              //           // Optionally, you can also close the dialog after selection
              //           isSwitchCompany ? Get.back() : null; // Close the dialog
              //           // Navigate to the main screen if needed
              //           // Get.offAllNamed('/MainScreen');
              //         }
              //       },
            );
          }),
        ],
      ),
      // child: Obx(
      //   () => DropdownButton<int>(
      //     hint: const Text("Select a company"),
      //     style: const TextStyle(fontSize: 14),
      //     value: defaultController.companyCode.value == 0
      //         ? null
      //         : defaultController.companyCode.value,
      //     onChanged: (value) {
      //       defaultController.companyCode.value = value!;
      //     },
      //     items: dropdownItemsCompanies,
      //   ),
      // ),
    );
  }

  List<DropdownMenuItem<int>> get dropdownItemsCompanies {
    return defaultController.companies
        .where((e) => e.companyCode == 3)
        .map((company) {
          return DropdownMenuItem<int>(
            value: company.companyCode,
            child: Text(company.companyName!),
          );
        })
        .toSet()
        .toList();
  }
}
