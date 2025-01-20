import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/party/party_datagrid.dart';
import 'package:real_web_rough_entry_system/party/party_model.dart';
import 'package:real_web_rough_entry_system/responsive.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PartyForm extends StatefulWidget {
  const PartyForm({super.key});

  @override
  PartyFormState createState() => PartyFormState();
}

class PartyFormState extends State<PartyForm> {
  final FocusNode _partyFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  bool _isEnabled = false;

  // bool _isFromEdit = false;

  void _enableFields() {
    setState(() {
      _isEnabled = true;
      if (defaultController.partyMstList.isEmpty) {
        _codeController.text = '1';
      } else {
        _codeController.text =
            (defaultController.partyMstList.reversed.last.partyCode! + 1)
                .toString();
      }

      Future.delayed(const Duration(milliseconds: 100), () {
        _partyFocusNode.requestFocus(); // Move focus to the first input field
      });

      if (_formKey.currentState != null) {
        _formKey.currentState!.validate();
      }
    });
  }

  void _enableEditFields() {
    setState(() {
      _isEnabled = true;

      // _codeController.text =
      //     (defaultController.partyMstList.last.partyCode! + 1).toString();

      Future.delayed(const Duration(milliseconds: 100), () {
        _partyFocusNode.requestFocus(); // Move focus to the first input field
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _panController.addListener(() {
      // Automatically capitalize input
      final text = _panController.text.toUpperCase();
      if (_panController.text != text) {
        _panController.value = _panController.value.copyWith(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      }
    });
    // _fetchSystemDetails();
    // _startClock();
  }

  @override
  Future<void> dispose() async {
    _panController.dispose();
    _partyFocusNode.dispose();
    super.dispose();
  }

  // void _fetchSystemDetails() async {
  //   // Get IP Address
  //   for (var interface in await NetworkInterface.list()) {
  //     for (var addr in interface.addresses) {
  //       if (addr.type == InternetAddressType.IPv4) {
  //         setState(() {
  //           _ipAddress = addr.address;
  //         });
  //         break;
  //       }
  //     }
  //   }
  //
  //   // Get Username
  //   setState(() {
  //     _username = Platform.environment['USERNAME'] ??
  //         Platform.environment['USER'] ??
  //         'Unknown User';
  //   });
  // }

  // void _startClock() {
  //   setState(() {
  //     _currentTime = DateFormat('hh:mm:ss a').format(DateTime.now());
  //   });
  //   Future.delayed(const Duration(seconds: 1), _startClock);
  // }

  // final List<DataRow> _rows = []; // Store DataRows

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactPersonController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _cgstController = TextEditingController();
  final TextEditingController _sgstController = TextEditingController();
  final TextEditingController _igstController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _faxController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _bankAddressController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _accountNoController = TextEditingController();
  final TextEditingController _sortIdController = TextEditingController();
  final TextEditingController _creditController = TextEditingController();
  final TextEditingController _creditControllerDollor = TextEditingController();
  final TextEditingController _debitController = TextEditingController();
  final TextEditingController _debitControllerDollor = TextEditingController();

  final DefaultController defaultController = Get.find<DefaultController>();

  RxString _selectedType = ''.obs;
  final RxInt selectedPartyMstID = 0.obs;
  bool _isActive = true;
  bool _isFromEdit = false;

  // void _addNewEntry() {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       _rows.add(
  //         DataRow(
  //           cells: [
  //             DataCell(Text(_codeController.text)),
  //             DataCell(Text(_selectedType.value)),
  //             DataCell(Text(_nameController.text)),
  //             DataCell(Text(_contactPersonController.text)),
  //             DataCell(Text(_locationController.text)),
  //             DataCell(Text(_addressController.text)),
  //             DataCell(Text(_mobileNoController.text)),
  //             DataCell(Text(_emailController.text)),
  //             DataCell(Text(_websiteController.text)),
  //             DataCell(Text(_cgstController.text)),
  //             DataCell(Text(_sgstController.text)),
  //             DataCell(Text(_igstController.text)),
  //             DataCell(Text(_phoneController.text)),
  //             DataCell(Text(_faxController.text)),
  //             DataCell(Text(_panController.text)),
  //             DataCell(Text(_aadharController.text)),
  //             DataCell(Text(_bankController.text)),
  //             DataCell(Text(_branchController.text)),
  //             DataCell(Text(_bankAddressController.text)),
  //             DataCell(Text(_ifscController.text)),
  //             DataCell(Text(_accountNoController.text)),
  //             DataCell(Text(_sortIdController.text)),
  //             DataCell(Text(_isActive ? 'Active' : 'Inactive')),
  //             DataCell(Text(_creditController.text)),
  //             DataCell(Text(_debitController.text)),
  //           ],
  //         ),
  //       );
  //       _clearFormFields(); // Clear form fields after adding
  //     });
  //   }
  // }

  void _clearFormFields() {
    // _codeController.clear();
    _nameController.clear();
    _contactPersonController.clear();
    _locationController.clear();
    _addressController.clear();
    _mobileNoController.clear();
    _emailController.clear();
    _websiteController.clear();
    _cgstController.clear();
    _sgstController.clear();
    _igstController.clear();
    _phoneController.clear();
    _faxController.clear();
    _panController.clear();
    _aadharController.clear();
    _bankController.clear();
    _branchController.clear();
    _bankAddressController.clear();
    _ifscController.clear();
    _accountNoController.clear();
    _sortIdController.clear();
    _creditController.clear();
    _debitController.clear();
    setState(() {
      _selectedType = ''.obs;
      _isActive = true;
      _isEnabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Align vertically centered
                    children: [
                      const Text(
                        'Code',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12, // Font size for the label
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Space between the label and TextFormField
                      Expanded(
                        child: TextFormField(
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          enabled: false,
                          // focusNode: _codeFocusNode,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                              height: 0, // Hides the error message
                              fontSize:
                                  0, // Ensures no space is taken by the error message
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border when focused with an error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border for errors
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                // Black border when focused without error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                // Light grey border when enabled
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
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
                          onChanged: (value) {
                            // Triggers validation on every input change
                            if (_formKey.currentState != null) {
                              _formKey.currentState!.validate();
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ''; // Validation still occurs, but no message is shown
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Text(formatNumber(2.0584212, 2)), //2.0584212
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Type',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12, // Font size for the label
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Obx(() {
                          return DropdownButtonFormField<String>(
                            focusNode: _partyFocusNode,
                            style: const TextStyle(fontSize: 12),
                            value: _selectedType.value.isEmpty
                                ? null
                                : _selectedType.value,
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(
                                height: 0, // Hides the error message
                                fontSize:
                                    0, // Ensures no space is taken by the error message
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 1.0, // Thin border width
                                ),
                                borderRadius:
                                    BorderRadius.zero, // Squared corners
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 1.0, // Thin border width
                                ),
                                borderRadius:
                                    BorderRadius.zero, // Squared corners
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.0, // Thin border width
                                ),
                                borderRadius:
                                    BorderRadius.zero, // Squared corners
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0, // Thin border width
                                ),
                                borderRadius:
                                    BorderRadius.zero, // Squared corners
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 8,
                              ),
                            ),
                            items: dropdownItems,
                            onChanged: _isEnabled
                                ? (value) {
                                    _selectedType.value = value ?? '';
                                    Future.delayed(
                                        const Duration(milliseconds: 100), () {
                                      _nameFocusNode
                                          .requestFocus(); // Move focus to the first input field
                                    }); // Handle null case
                                  }
                                : null,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Align vertically centered
                    children: [
                      const Text(
                        'Name',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12, // Font size for the label
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Space between the label and TextFormField
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          enabled: _isEnabled,
                          focusNode: _nameFocusNode,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z\s]')),
                          ],
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                              height: 0, // Hides the error message
                              fontSize:
                                  0, // Ensures no space is taken by the error message
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border when focused with an error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border for errors
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                // Black border when focused without error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                // Light grey border when enabled
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            // filled: true,
                            // Fill the background
                            // fillColor: Colors.white,
                            // White background
                            isDense: true,
                            // Reduces the overall height of the TextField
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal:
                                    8), // Remove top padding, minimal horizontal padding
                          ),
                          cursorColor: Colors.black,
                          // Black cursor color
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12, // Consistent font size with label
                          ),
                          onChanged: (value) {
                            // Triggers validation on every input change
                            if (_formKey.currentState != null) {
                              _formKey.currentState!.validate();
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ''; // Validation still occurs, but no message is shown
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Align vertically centered
                    children: [
                      const Text(
                        'Contact Person',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12, // Font size for the label
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Space between the label and TextFormField
                      Expanded(
                        child: TextFormField(
                          controller: _contactPersonController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          enabled: _isEnabled,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z\s]')),
                          ],
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                              height: 0, // Hides the error message
                              fontSize:
                                  0, // Ensures no space is taken by the error message
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border when focused with an error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border for errors
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                // Black border when focused without error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                // Light grey border when enabled
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            // filled: true,
                            // Fill the background
                            // fillColor: Colors.white,
                            // White background
                            isDense: true,
                            // Reduces the overall height of the TextField
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal:
                                    8), // Remove top padding, minimal horizontal padding
                          ),
                          cursorColor: Colors.black,
                          // Black cursor color
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12, // Consistent font size with label
                          ),
                          onChanged: (value) {
                            // Triggers validation on every input change
                            if (_formKey.currentState != null) {
                              _formKey.currentState!.validate();
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ''; // Validation still occurs, but no message is shown
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Align vertically centered
                    children: [
                      const Text(
                        'Location',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12, // Font size for the label
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Space between the label and TextFormField
                      Expanded(
                        child: TextFormField(
                          controller: _locationController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          enabled: _isEnabled,
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                              height: 0, // Hides the error message
                              fontSize:
                                  0, // Ensures no space is taken by the error message
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border when focused with an error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border for errors
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                // Black border when focused without error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                // Light grey border when enabled
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            // filled: true,
                            // Fill the background
                            // fillColor: Colors.white,
                            // White background
                            isDense: true,
                            // Reduces the overall height of the TextField
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal:
                                    8), // Remove top padding, minimal horizontal padding
                          ),
                          cursorColor: Colors.black,
                          // Black cursor color
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12, // Consistent font size with label
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return ''; // Validation still occurs, but no message is shown
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Align vertically centered
                    children: [
                      const Text(
                        'Address',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12, // Font size for the label
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Space between the label and TextFormField
                      Expanded(
                        child: TextFormField(
                          controller: _addressController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          enabled: _isEnabled,
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                              height: 0, // Hides the error message
                              fontSize:
                                  0, // Ensures no space is taken by the error message
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border when focused with an error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border for errors
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                // Black border when focused without error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                // Light grey border when enabled
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            // filled: true,
                            // Fill the background
                            // fillColor: Colors.white,
                            // White background
                            isDense: true,
                            // Reduces the overall height of the TextField
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal:
                                    8), // Remove top padding, minimal horizontal padding
                          ),
                          cursorColor: Colors.black,
                          // Black cursor color
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12, // Consistent font size with label
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return ''; // Validation still occurs, but no message is shown
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Row(
            //   children: [
            //     Expanded(
            //       child: Row(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         // Align vertically centered
            //         children: [
            //           const Text(
            //             'Mobile No.',
            //             style: TextStyle(
            //               color: Colors.black,
            //               fontWeight: FontWeight.w900,
            //               fontSize: 12, // Font size for the label
            //             ),
            //           ),
            //           const SizedBox(width: 8),
            //           // Space between the label and TextFormField
            //           Expanded(
            //             child: TextFormField(
            //               controller: _mobileNoController,
            //               keyboardType: TextInputType.phone,
            //               textInputAction: TextInputAction.next,
            //               enabled: _isEnabled,
            //               inputFormatters: [
            //                 FilteringTextInputFormatter.digitsOnly,
            //                 LengthLimitingTextInputFormatter(10),
            //               ],
            //               decoration: const InputDecoration(
            //                 errorStyle: TextStyle(
            //                   height: 0, // Hides the error message
            //                   fontSize:
            //                       0, // Ensures no space is taken by the error message
            //                 ),
            //                 focusedErrorBorder: UnderlineInputBorder(
            //                   borderSide: BorderSide(
            //                     color: Colors.red,
            //                     // Red border when focused with an error
            //                     width: 1.0, // Thin border width
            //                   ),
            //                   borderRadius:
            //                       BorderRadius.zero, // Squared corners
            //                 ),
            //                 errorBorder: UnderlineInputBorder(
            //                   borderSide: BorderSide(
            //                     color: Colors.red,
            //                     // Red border for errors
            //                     width: 1.0, // Thin border width
            //                   ),
            //                   borderRadius:
            //                       BorderRadius.zero, // Squared corners
            //                 ),
            //                 focusedBorder: UnderlineInputBorder(
            //                   borderSide: BorderSide(
            //                     color: Colors.blue,
            //                     // Black border when focused without error
            //                     width: 1.0, // Thin border width
            //                   ),
            //                   borderRadius:
            //                       BorderRadius.zero, // Squared corners
            //                 ),
            //                 enabledBorder: UnderlineInputBorder(
            //                   borderSide: BorderSide(
            //                     color: Colors.grey,
            //                     // Light grey border when enabled
            //                     width: 1.0, // Thin border width
            //                   ),
            //                   borderRadius:
            //                       BorderRadius.zero, // Squared corners
            //                 ),
            //                 // filled: true,
            //                 // Fill the background
            //                 // fillColor: Colors.white,
            //                 // White background
            //                 isDense: true,
            //                 // Reduces the overall height of the TextField
            //                 contentPadding: EdgeInsets.symmetric(
            //                     vertical: 8,
            //                     horizontal:
            //                         8), // Remove top padding, minimal horizontal padding
            //               ),
            //               cursorColor: Colors.black,
            //               // Black cursor color
            //               style: const TextStyle(
            //                 color: Colors.black,
            //                 fontSize: 12, // Consistent font size with label
            //               ),
            //               onChanged: (value) {
            //                 // Triggers validation on every input change
            //                 if (_formKey.currentState != null) {
            //                   _formKey.currentState!.validate();
            //                 }
            //               },
            //               validator: (value) {
            //                 if (value == null || value.isEmpty) {
            //                   return ''; // Validation still occurs, but no message is shown
            //                 }
            //                 return null;
            //               },
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     const SizedBox(width: 8),
            //     Expanded(
            //       child: Row(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         // Align vertically centered
            //         children: [
            //           const Text(
            //             'Email',
            //             style: TextStyle(
            //               color: Colors.black,
            //               fontWeight: FontWeight.w900,
            //               fontSize: 12, // Font size for the label
            //             ),
            //           ),
            //           const SizedBox(width: 8),
            //           // Space between the label and TextFormField
            //           Expanded(
            //             child: TextFormField(
            //               controller: _emailController,
            //               keyboardType: TextInputType.text,
            //               textInputAction: TextInputAction.next,
            //               enabled: _isEnabled,
            //               decoration: const InputDecoration(
            //                 errorStyle: TextStyle(
            //                   height: 0, // Hides the error message
            //                   fontSize:
            //                       0, // Ensures no space is taken by the error message
            //                 ),
            //                 focusedErrorBorder: UnderlineInputBorder(
            //                   borderSide: BorderSide(
            //                     color: Colors.red,
            //                     // Red border when focused with an error
            //                     width: 1.0, // Thin border width
            //                   ),
            //                   borderRadius:
            //                       BorderRadius.zero, // Squared corners
            //                 ),
            //                 errorBorder: UnderlineInputBorder(
            //                   borderSide: BorderSide(
            //                     color: Colors.red,
            //                     // Red border for errors
            //                     width: 1.0, // Thin border width
            //                   ),
            //                   borderRadius:
            //                       BorderRadius.zero, // Squared corners
            //                 ),
            //                 focusedBorder: UnderlineInputBorder(
            //                   borderSide: BorderSide(
            //                     color: Colors.blue,
            //                     // Black border when focused without error
            //                     width: 1.0, // Thin border width
            //                   ),
            //                   borderRadius:
            //                       BorderRadius.zero, // Squared corners
            //                 ),
            //                 enabledBorder: UnderlineInputBorder(
            //                   borderSide: BorderSide(
            //                     color: Colors.grey,
            //                     // Light grey border when enabled
            //                     width: 1.0, // Thin border width
            //                   ),
            //                   borderRadius:
            //                       BorderRadius.zero, // Squared corners
            //                 ),
            //                 // filled: true,
            //                 // Fill the background
            //                 // fillColor: Colors.white,
            //                 // White background
            //                 isDense: true,
            //                 // Reduces the overall height of the TextField
            //                 contentPadding: EdgeInsets.symmetric(
            //                     vertical: 8,
            //                     horizontal:
            //                         8), // Remove top padding, minimal horizontal padding
            //               ),
            //               cursorColor: Colors.black,
            //               // Black cursor color
            //               style: const TextStyle(
            //                 color: Colors.black,
            //                 fontSize: 12, // Consistent font size with label
            //               ),
            //               onChanged: (value) {
            //                 // Triggers validation on every input change
            //                 if (_formKey.currentState != null) {
            //                   _formKey.currentState!.validate();
            //                 }
            //               },
            //               validator: (value) {
            //                 if (value == null || value.isEmpty) {
            //                   return '';
            //                   // return 'Please enter an email';
            //                 }
            //                 if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
            //                     .hasMatch(value)) {
            //                   return '';
            //                   // return 'Please enter a valid email';
            //                 }
            //                 return null;
            //               },
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     const SizedBox(width: 8),
            //     Expanded(
            //       child: Row(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         // Align vertically centered
            //         children: [
            //           const Text(
            //             'Website',
            //             style: TextStyle(
            //               color: Colors.black,
            //               fontWeight: FontWeight.w900,
            //               fontSize: 12, // Font size for the label
            //             ),
            //           ),
            //           const SizedBox(width: 8),
            //           // Space between the label and TextFormField
            //           Expanded(
            //             child: TextFormField(
            //               controller: _websiteController,
            //               keyboardType: TextInputType.text,
            //               textInputAction: TextInputAction.next,
            //               enabled: _isEnabled,
            //               decoration: const InputDecoration(
            //                 errorStyle: TextStyle(
            //                   height: 0, // Hides the error message
            //                   fontSize:
            //                       0, // Ensures no space is taken by the error message
            //                 ),
            //                 focusedErrorBorder: UnderlineInputBorder(
            //                   borderSide: BorderSide(
            //                     color: Colors.red,
            //                     // Red border when focused with an error
            //                     width: 1.0, // Thin border width
            //                   ),
            //                   borderRadius:
            //                       BorderRadius.zero, // Squared corners
            //                 ),
            //                 errorBorder: UnderlineInputBorder(
            //                   borderSide: BorderSide(
            //                     color: Colors.red,
            //                     // Red border for errors
            //                     width: 1.0, // Thin border width
            //                   ),
            //                   borderRadius:
            //                       BorderRadius.zero, // Squared corners
            //                 ),
            //                 focusedBorder: UnderlineInputBorder(
            //                   borderSide: BorderSide(
            //                     color: Colors.blue,
            //                     // Black border when focused without error
            //                     width: 1.0, // Thin border width
            //                   ),
            //                   borderRadius:
            //                       BorderRadius.zero, // Squared corners
            //                 ),
            //                 enabledBorder: UnderlineInputBorder(
            //                   borderSide: BorderSide(
            //                     color: Colors.grey,
            //                     // Light grey border when enabled
            //                     width: 1.0, // Thin border width
            //                   ),
            //                   borderRadius:
            //                       BorderRadius.zero, // Squared corners
            //                 ),
            //                 // filled: true,
            //                 // Fill the background
            //                 // fillColor: Colors.white,
            //                 // White background
            //                 isDense: true,
            //                 // Reduces the overall height of the TextField
            //                 contentPadding: EdgeInsets.symmetric(
            //                     vertical: 8,
            //                     horizontal:
            //                         8), // Remove top padding, minimal horizontal padding
            //               ),
            //               cursorColor: Colors.black,
            //               // Black cursor color
            //               style: const TextStyle(
            //                 color: Colors.black,
            //                 fontSize: 12, // Consistent font size with label
            //               ),
            //               // validator: (value) {
            //               //   if (value == null || value.isEmpty) {
            //               //     return ''; // Validation still occurs, but no message is shown
            //               //   }
            //               //   return null;
            //               // },
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Align vertically centered
                    children: [
                      const Text(
                        'Ph No.',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12, // Font size for the label
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Space between the label and TextFormField
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          enabled: _isEnabled,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                              height: 0, // Hides the error message
                              fontSize:
                                  0, // Ensures no space is taken by the error message
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border when focused with an error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border for errors
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                // Black border when focused without error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                // Light grey border when enabled
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            // filled: true,
                            // Fill the background
                            // fillColor: Colors.white,
                            // White background
                            isDense: true,
                            // Reduces the overall height of the TextField
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal:
                                    8), // Remove top padding, minimal horizontal padding
                          ),
                          cursorColor: Colors.black,
                          // Black cursor color
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12, // Consistent font size with label
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return ''; // Validation still occurs, but no message is shown
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Align vertically centered
                    children: [
                      const Text(
                        'Fax',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12, // Font size for the label
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Space between the label and TextFormField
                      Expanded(
                        child: TextFormField(
                          controller: _faxController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          enabled: _isEnabled,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                              height: 0, // Hides the error message
                              fontSize:
                                  0, // Ensures no space is taken by the error message
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border when focused with an error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border for errors
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                // Black border when focused without error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                // Light grey border when enabled
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            // filled: true,
                            // Fill the background
                            // fillColor: Colors.white,
                            // White background
                            isDense: true,
                            // Reduces the overall height of the TextField
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal:
                                    8), // Remove top padding, minimal horizontal padding
                          ),
                          cursorColor: Colors.black,
                          // Black cursor color
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12, // Consistent font size with label
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return ''; // Validation still occurs, but no message is shown
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Align vertically centered
                    children: [
                      const Text(
                        'PAN No.',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12, // Font size for the label
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Space between the label and TextFormField
                      Expanded(
                        child: TextFormField(
                          controller: _panController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          enabled: _isEnabled,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9]')),
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                              height: 0, // Hides the error message
                              fontSize:
                                  0, // Ensures no space is taken by the error message
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border when focused with an error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border for errors
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                // Black border when focused without error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                // Light grey border when enabled
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            // filled: true,
                            // Fill the background
                            // fillColor: Colors.white,
                            // White background
                            isDense: true,
                            // Reduces the overall height of the TextField
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal:
                                    8), // Remove top padding, minimal horizontal padding
                          ),
                          cursorColor: Colors.black,
                          // Black cursor color
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12, // Consistent font size with label
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return ''; // Validation still occurs, but no message is shown
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Align vertically centered
                    children: [
                      const Text(
                        'Addhar No.',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12, // Font size for the label
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Space between the label and TextFormField
                      Expanded(
                        child: TextFormField(
                          controller: _aadharController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          enabled: _isEnabled,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(12),
                          ],
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                              height: 0, // Hides the error message
                              fontSize:
                                  0, // Ensures no space is taken by the error message
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border when focused with an error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border for errors
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                // Black border when focused without error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                // Light grey border when enabled
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            // filled: true,
                            // Fill the background
                            // fillColor: Colors.white,
                            // White background
                            isDense: true,
                            // Reduces the overall height of the TextField
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal:
                                    8), // Remove top padding, minimal horizontal padding
                          ),
                          cursorColor: Colors.black,
                          // Black cursor color
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12, // Consistent font size with label
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return ''; // Validation still occurs, but no message is shown
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Align vertically centered
                    children: [
                      const Text(
                        'CGST',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12, // Font size for the label
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Space between the label and TextFormField
                      Expanded(
                        child: TextFormField(
                          controller: _cgstController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          enabled: _isEnabled,
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                              height: 0, // Hides the error message
                              fontSize:
                                  0, // Ensures no space is taken by the error message
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border when focused with an error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border for errors
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                // Black border when focused without error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                // Light grey border when enabled
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            // filled: true,
                            // Fill the background
                            // fillColor: Colors.white,
                            // White background
                            isDense: true,
                            // Reduces the overall height of the TextField
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal:
                                    8), // Remove top padding, minimal horizontal padding
                          ),
                          cursorColor: Colors.black,
                          // Black cursor color
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12, // Consistent font size with label
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return ''; // Validation still occurs, but no message is shown
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Align vertically centered
                    children: [
                      const Text(
                        'SGST',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12, // Font size for the label
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Space between the label and TextFormField
                      Expanded(
                        child: TextFormField(
                          controller: _sgstController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          enabled: _isEnabled,
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                              height: 0, // Hides the error message
                              fontSize:
                                  0, // Ensures no space is taken by the error message
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border when focused with an error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border for errors
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                // Black border when focused without error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                // Light grey border when enabled
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            // filled: true,
                            // Fill the background
                            // fillColor: Colors.white,
                            // White background
                            isDense: true,
                            // Reduces the overall height of the TextField
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal:
                                    8), // Remove top padding, minimal horizontal padding
                          ),
                          cursorColor: Colors.black,
                          // Black cursor color
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12, // Consistent font size with label
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return ''; // Validation still occurs, but no message is shown
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Align vertically centered
                    children: [
                      const Text(
                        'IGST',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12, // Font size for the label
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Space between the label and TextFormField
                      Expanded(
                        child: TextFormField(
                          controller: _igstController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          enabled: _isEnabled,
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                              height: 0, // Hides the error message
                              fontSize:
                                  0, // Ensures no space is taken by the error message
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border when focused with an error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border for errors
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                // Black border when focused without error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                // Light grey border when enabled
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            // filled: true,
                            // Fill the background
                            // fillColor: Colors.white,
                            // White background
                            isDense: true,
                            // Reduces the overall height of the TextField
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal:
                                    8), // Remove top padding, minimal horizontal padding
                          ),
                          cursorColor: Colors.black,
                          // Black cursor color
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12, // Consistent font size with label
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return ''; // Validation still occurs, but no message is shown
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Align vertically centered
                    children: [
                      const Text(
                        'Bank',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12, // Font size for the label
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Space between the label and TextFormField
                      Expanded(
                        child: TextFormField(
                          controller: _bankController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          enabled: _isEnabled,
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                              height: 0, // Hides the error message
                              fontSize:
                                  0, // Ensures no space is taken by the error message
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border when focused with an error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border for errors
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                // Black border when focused without error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                // Light grey border when enabled
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            // filled: true,
                            // Fill the background
                            // fillColor: Colors.white,
                            // White background
                            isDense: true,
                            // Reduces the overall height of the TextField
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal:
                                    8), // Remove top padding, minimal horizontal padding
                          ),
                          cursorColor: Colors.black,
                          // Black cursor color
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12, // Consistent font size with label
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return ''; // Validation still occurs, but no message is shown
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Align vertically centered
                    children: [
                      const Text(
                        'Branch',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12, // Font size for the label
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Space between the label and TextFormField
                      Expanded(
                        child: TextFormField(
                          controller: _branchController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          enabled: _isEnabled,
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                              height: 0, // Hides the error message
                              fontSize:
                                  0, // Ensures no space is taken by the error message
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border when focused with an error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border for errors
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                // Black border when focused without error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                // Light grey border when enabled
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            // filled: true,
                            // Fill the background
                            // fillColor: Colors.white,
                            // White background
                            isDense: true,
                            // Reduces the overall height of the TextField
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal:
                                    8), // Remove top padding, minimal horizontal padding
                          ),
                          cursorColor: Colors.black,
                          // Black cursor color
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12, // Consistent font size with label
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return ''; // Validation still occurs, but no message is shown
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Align vertically centered
                    children: [
                      const Text(
                        'Bank Address',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12, // Font size for the label
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Space between the label and TextFormField
                      Expanded(
                        child: TextFormField(
                          controller: _bankAddressController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          enabled: _isEnabled,
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                              height: 0, // Hides the error message
                              fontSize:
                                  0, // Ensures no space is taken by the error message
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border when focused with an error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border for errors
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                // Black border when focused without error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                // Light grey border when enabled
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            // filled: true,
                            // Fill the background
                            // fillColor: Colors.white,
                            // White background
                            isDense: true,
                            // Reduces the overall height of the TextField
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal:
                                    8), // Remove top padding, minimal horizontal padding
                          ),
                          cursorColor: Colors.black,
                          // Black cursor color
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12, // Consistent font size with label
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return ''; // Validation still occurs, but no message is shown
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Align vertically centered
                    children: [
                      const Text(
                        'IFSC',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12, // Font size for the label
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Space between the label and TextFormField
                      Expanded(
                        child: TextFormField(
                          controller: _ifscController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          enabled: _isEnabled,
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                              height: 0, // Hides the error message
                              fontSize:
                                  0, // Ensures no space is taken by the error message
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border when focused with an error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border for errors
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                // Black border when focused without error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                // Light grey border when enabled
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            // filled: true,
                            // Fill the background
                            // fillColor: Colors.white,
                            // White background
                            isDense: true,
                            // Reduces the overall height of the TextField
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal:
                                    8), // Remove top padding, minimal horizontal padding
                          ),
                          cursorColor: Colors.black,
                          // Black cursor color
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12, // Consistent font size with label
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return ''; // Validation still occurs, but no message is shown
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Align vertically centered
                    children: [
                      const Text(
                        'Account No.',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12, // Font size for the label
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Space between the label and TextFormField
                      Expanded(
                        child: TextFormField(
                          controller: _accountNoController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          enabled: _isEnabled,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            // LengthLimitingTextInputFormatter(12),
                          ],
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                              height: 0, // Hides the error message
                              fontSize:
                                  0, // Ensures no space is taken by the error message
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border when focused with an error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border for errors
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                // Black border when focused without error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                // Light grey border when enabled
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            // filled: true,
                            // Fill the background
                            // fillColor: Colors.white,
                            // White background
                            isDense: true,
                            // Reduces the overall height of the TextField
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal:
                                    8), // Remove top padding, minimal horizontal padding
                          ),
                          cursorColor: Colors.black,
                          // Black cursor color
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12, // Consistent font size with label
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return ''; // Validation still occurs, but no message is shown
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Align vertically centered
                    children: [
                      const Text(
                        'Sort Id',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12, // Font size for the label
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Space between the label and TextFormField
                      Expanded(
                        child: TextFormField(
                          controller: _sortIdController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          enabled: _isEnabled,
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                              height: 0, // Hides the error message
                              fontSize:
                                  0, // Ensures no space is taken by the error message
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border when focused with an error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border for errors
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                // Black border when focused without error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                // Light grey border when enabled
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            // filled: true,
                            // Fill the background
                            // fillColor: Colors.white,
                            // White background
                            isDense: true,
                            // Reduces the overall height of the TextField
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal:
                                    8), // Remove top padding, minimal horizontal padding
                          ),
                          cursorColor: Colors.black,
                          // Black cursor color
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12, // Consistent font size with label
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return ''; // Validation still occurs, but no message is shown
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Align vertically centered
                    children: [
                      const Text(
                        'Credit ₹',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12, // Font size for the label
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Space between the label and TextFormField
                      Expanded(
                        child: TextFormField(
                          controller: _creditController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          enabled: _isEnabled,
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                              height: 0, // Hides the error message
                              fontSize:
                                  0, // Ensures no space is taken by the error message
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border when focused with an error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border for errors
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                // Black border when focused without error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                // Light grey border when enabled
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            // filled: true,
                            // Fill the background
                            // fillColor: Colors.white,
                            // White background
                            isDense: true,
                            // Reduces the overall height of the TextField
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal:
                                    8), // Remove top padding, minimal horizontal padding
                          ),
                          cursorColor: Colors.black,
                          // Black cursor color
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12, // Consistent font size with label
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _debitController.clear();
                            }
                          },
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return ''; // Validation still occurs, but no message is shown
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Align vertically centered
                    children: [
                      const Text(
                        'Debit ₹',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12, // Font size for the label
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Space between the label and TextFormField
                      Expanded(
                        child: TextFormField(
                          controller: _debitController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          enabled: _isEnabled,
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                              height: 0, // Hides the error message
                              fontSize:
                                  0, // Ensures no space is taken by the error message
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border when focused with an error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                // Red border for errors
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                // Black border when focused without error
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                // Light grey border when enabled
                                width: 1.0, // Thin border width
                              ),
                              borderRadius:
                                  BorderRadius.zero, // Squared corners
                            ),
                            // filled: true,
                            // Fill the background
                            // fillColor: Colors.white,
                            // White background
                            isDense: true,
                            // Reduces the overall height of the TextField
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal:
                                    8), // Remove top padding, minimal horizontal padding
                          ),
                          cursorColor: Colors.black,
                          // Black cursor color
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12, // Consistent font size with label
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return ''; // Validation still occurs, but no message is shown
                          //   }
                          //   return null;
                          // },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _creditController.clear();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Expanded(
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     // Align vertically centered
                //     children: [
                //       const Text(
                //         'Credit \$',
                //         style: TextStyle(
                //           color: Colors.black,
                //           fontWeight: FontWeight.w900,
                //           fontSize: 12, // Font size for the label
                //         ),
                //       ),
                //       const SizedBox(width: 8),
                //       // Space between the label and TextFormField
                //       Expanded(
                //         child: TextFormField(
                //           controller: _creditControllerDollor,
                //           keyboardType: TextInputType.text,
                //           textInputAction: TextInputAction.next,
                //           enabled: _isEnabled,
                //           decoration: const InputDecoration(
                //             errorStyle: TextStyle(
                //               height: 0, // Hides the error message
                //               fontSize:
                //                   0, // Ensures no space is taken by the error message
                //             ),
                //             focusedErrorBorder: UnderlineInputBorder(
                //               borderSide: BorderSide(
                //                 color: Colors.red,
                //                 // Red border when focused with an error
                //                 width: 1.0, // Thin border width
                //               ),
                //               borderRadius:
                //                   BorderRadius.zero, // Squared corners
                //             ),
                //             errorBorder: UnderlineInputBorder(
                //               borderSide: BorderSide(
                //                 color: Colors.red,
                //                 // Red border for errors
                //                 width: 1.0, // Thin border width
                //               ),
                //               borderRadius:
                //                   BorderRadius.zero, // Squared corners
                //             ),
                //             focusedBorder: UnderlineInputBorder(
                //               borderSide: BorderSide(
                //                 color: Colors.blue,
                //                 // Black border when focused without error
                //                 width: 1.0, // Thin border width
                //               ),
                //               borderRadius:
                //                   BorderRadius.zero, // Squared corners
                //             ),
                //             enabledBorder: UnderlineInputBorder(
                //               borderSide: BorderSide(
                //                 color: Colors.grey,
                //                 // Light grey border when enabled
                //                 width: 1.0, // Thin border width
                //               ),
                //               borderRadius:
                //                   BorderRadius.zero, // Squared corners
                //             ),
                //             // filled: true,
                //             // Fill the background
                //             // fillColor: Colors.white,
                //             // White background
                //             isDense: true,
                //             // Reduces the overall height of the TextField
                //             contentPadding: EdgeInsets.symmetric(
                //                 vertical: 8,
                //                 horizontal:
                //                     8), // Remove top padding, minimal horizontal padding
                //           ),
                //           cursorColor: Colors.black,
                //           // Black cursor color
                //           style: const TextStyle(
                //             color: Colors.black,
                //             fontSize: 12, // Consistent font size with label
                //           ),
                //           // validator: (value) {
                //           //   if (value == null || value.isEmpty) {
                //           //     return ''; // Validation still occurs, but no message is shown
                //           //   }
                //           //   return null;
                //           // },
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(width: 8),
                // Expanded(
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     // Align vertically centered
                //     children: [
                //       const Text(
                //         'Debit \$',
                //         style: TextStyle(
                //           color: Colors.black,
                //           fontWeight: FontWeight.w900,
                //           fontSize: 12, // Font size for the label
                //         ),
                //       ),
                //       const SizedBox(width: 8),
                //       // Space between the label and TextFormField
                //       Expanded(
                //         child: TextFormField(
                //           controller: _debitControllerDollor,
                //           keyboardType: TextInputType.text,
                //           textInputAction: TextInputAction.next,
                //           enabled: _isEnabled,
                //           decoration: const InputDecoration(
                //             errorStyle: TextStyle(
                //               height: 0, // Hides the error message
                //               fontSize:
                //                   0, // Ensures no space is taken by the error message
                //             ),
                //             focusedErrorBorder: UnderlineInputBorder(
                //               borderSide: BorderSide(
                //                 color: Colors.red,
                //                 // Red border when focused with an error
                //                 width: 1.0, // Thin border width
                //               ),
                //               borderRadius:
                //                   BorderRadius.zero, // Squared corners
                //             ),
                //             errorBorder: UnderlineInputBorder(
                //               borderSide: BorderSide(
                //                 color: Colors.red,
                //                 // Red border for errors
                //                 width: 1.0, // Thin border width
                //               ),
                //               borderRadius:
                //                   BorderRadius.zero, // Squared corners
                //             ),
                //             focusedBorder: UnderlineInputBorder(
                //               borderSide: BorderSide(
                //                 color: Colors.blue,
                //                 // Black border when focused without error
                //                 width: 1.0, // Thin border width
                //               ),
                //               borderRadius:
                //                   BorderRadius.zero, // Squared corners
                //             ),
                //             enabledBorder: UnderlineInputBorder(
                //               borderSide: BorderSide(
                //                 color: Colors.grey,
                //                 // Light grey border when enabled
                //                 width: 1.0, // Thin border width
                //               ),
                //               borderRadius:
                //                   BorderRadius.zero, // Squared corners
                //             ),
                //             // filled: true,
                //             // Fill the background
                //             // fillColor: Colors.white,
                //             // White background
                //             isDense: true,
                //             // Reduces the overall height of the TextField
                //             contentPadding: EdgeInsets.symmetric(
                //                 vertical: 8,
                //                 horizontal:
                //                     8), // Remove top padding, minimal horizontal padding
                //           ),
                //           cursorColor: Colors.black,
                //           // Black cursor color
                //           style: const TextStyle(
                //             color: Colors.black,
                //             fontSize: 12, // Consistent font size with label
                //           ),
                //           // validator: (value) {
                //           //   if (value == null || value.isEmpty) {
                //           //     return ''; // Validation still occurs, but no message is shown
                //           //   }
                //           //   return null;
                //           // },
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const Text(
                  'Active',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 12, // Font size for the label
                  ),
                ),
                Checkbox(
                  value: _isActive,
                  onChanged: _isEnabled
                      ? (value) {
                          setState(() {
                            _isActive = value!;
                          });
                        }
                      : (value) {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            !Responsive.isMobile(context)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed:
                            !_isEnabled && !_isFromEdit ? _enableFields : null,
                        child: const Text("Add"),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: _isFromEdit
                            ? () {
                                // if (_isFromEdit) {
                                _enableEditFields();
                                // } else {
                                //   infoDialog(
                                //       messageText: 'Please Select Party to Edit.');
                                // }
                              }
                            : null,
                        child: const Text("Edit"),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: _isFromEdit
                            ? () async {
                                if (_formKey.currentState!.validate()) {
                                  await defaultController
                                      .updatePartyData(
                                    id: selectedPartyMstID.value,
                                    partyName: _nameController.text.isEmpty
                                        ? null
                                        : _nameController.text,
                                    partyType: _selectedType.value.isEmpty
                                        ? null
                                        : _selectedType.value,
                                    contactPerson:
                                        _contactPersonController.text.isEmpty
                                            ? null
                                            : _contactPersonController.text,
                                    address: _addressController.text.isEmpty
                                        ? null
                                        : _addressController.text,
                                    mobileNo: _mobileNoController.text.isEmpty
                                        ? null
                                        : _mobileNoController.text,
                                    phNo: _phoneController.text.isEmpty
                                        ? null
                                        : _phoneController.text,
                                    fax: _faxController.text.isEmpty
                                        ? null
                                        : _faxController.text,
                                    email: _emailController.text.isEmpty
                                        ? null
                                        : _emailController.text,
                                    website: _websiteController.text.isEmpty
                                        ? null
                                        : _websiteController.text,
                                    pan: _panController.text.isEmpty
                                        ? null
                                        : _panController.text,
                                    adhar: _aadharController.text.isEmpty
                                        ? null
                                        : _aadharController.text,
                                    bankName: _bankController.text.isEmpty
                                        ? null
                                        : _bankController.text,
                                    branchName: _branchController.text.isEmpty
                                        ? null
                                        : _branchController.text,
                                    bankAdd: _bankAddressController.text.isEmpty
                                        ? null
                                        : _bankAddressController.text,
                                    ifscCode: _ifscController.text.isEmpty
                                        ? null
                                        : _ifscController.text,
                                    bankAcNo: _accountNoController.text.isEmpty
                                        ? null
                                        : _accountNoController.text,
                                    location: _locationController.text.isEmpty
                                        ? null
                                        : _locationController.text,
                                    city: _locationController.text.isEmpty
                                        ? null
                                        : _locationController.text,
                                    state: _locationController.text.isEmpty
                                        ? null
                                        : _locationController.text,
                                    // gstNo: '',
                                    // If you want to keep this field as an empty string
                                    // remarks: '',
                                    // If you want to keep this field as an empty string
                                    sortId: _sortIdController.text.isEmpty
                                        ? null
                                        : int.tryParse(_sortIdController.text),
                                    typeCode: _selectedType.value.isEmpty
                                        ? null
                                        : _selectedType.value,
                                    active: _isActive,
                                    cGst: _cgstController.text.isEmpty
                                        ? null
                                        : double.tryParse(_cgstController.text),
                                    sGst: _sgstController.text.isEmpty
                                        ? null
                                        : double.tryParse(_sgstController.text),
                                    iGst: _igstController.text.isEmpty
                                        ? null
                                        : double.tryParse(_igstController.text),
                                    creditOpBalRs:
                                        _creditController.text.isEmpty
                                            ? 0.00
                                            : double.tryParse(
                                                _creditController.text),
                                    creditOpBalDollor:
                                        _creditControllerDollor.text.isEmpty
                                            ? null
                                            : double.tryParse(
                                                _creditControllerDollor.text),
                                    debitOpBalRs: _debitController.text.isEmpty
                                        ? 0.00
                                        : double.tryParse(
                                            _debitController.text),
                                    debitOpBalDollor:
                                        _debitControllerDollor.text.isEmpty
                                            ? null
                                            : double.tryParse(
                                                _debitControllerDollor.text),
                                  )
                                      .then((onValue) {
                                    _codeController.clear();
                                    _clearFormFields();
                                    setState(() {
                                      _isFromEdit = false;
                                    });
                                  });
                                }
                              }
                            : _isEnabled
                                ? () async {
                                    if (_formKey.currentState!.validate()) {
                                      await defaultController
                                          .addPartyData(
                                        partyName: _nameController.text.isEmpty
                                            ? null
                                            : _nameController.text,
                                        partyType: _selectedType.value.isEmpty
                                            ? null
                                            : _selectedType.value,
                                        contactPerson: _contactPersonController
                                                .text.isEmpty
                                            ? null
                                            : _contactPersonController.text,
                                        address: _addressController.text.isEmpty
                                            ? null
                                            : _addressController.text,
                                        mobileNo:
                                            _mobileNoController.text.isEmpty
                                                ? null
                                                : _mobileNoController.text,
                                        phNo: _phoneController.text.isEmpty
                                            ? null
                                            : _phoneController.text,
                                        fax: _faxController.text.isEmpty
                                            ? null
                                            : _faxController.text,
                                        email: _emailController.text.isEmpty
                                            ? null
                                            : _emailController.text,
                                        website: _websiteController.text.isEmpty
                                            ? null
                                            : _websiteController.text,
                                        pan: _panController.text.isEmpty
                                            ? null
                                            : _panController.text,
                                        adhar: _aadharController.text.isEmpty
                                            ? null
                                            : _aadharController.text,
                                        bankName: _bankController.text.isEmpty
                                            ? null
                                            : _bankController.text,
                                        branchName:
                                            _branchController.text.isEmpty
                                                ? null
                                                : _branchController.text,
                                        bankAdd:
                                            _bankAddressController.text.isEmpty
                                                ? null
                                                : _bankAddressController.text,
                                        ifscCode: _ifscController.text.isEmpty
                                            ? null
                                            : _ifscController.text,
                                        bankAcNo:
                                            _accountNoController.text.isEmpty
                                                ? null
                                                : _accountNoController.text,
                                        location:
                                            _locationController.text.isEmpty
                                                ? null
                                                : _locationController.text,
                                        city: _locationController.text.isEmpty
                                            ? null
                                            : _locationController.text,
                                        state: _locationController.text.isEmpty
                                            ? null
                                            : _locationController.text,
                                        // gstNo: '',
                                        // If you want to keep this field as an empty string
                                        // remarks: '',
                                        // If you want to keep this field as an empty string
                                        sortId: _sortIdController.text.isEmpty
                                            ? null
                                            : int.tryParse(
                                                _sortIdController.text),
                                        typeCode: _selectedType.value.isEmpty
                                            ? null
                                            : _selectedType.value,
                                        active: _isActive,
                                        cGst: _cgstController.text.isEmpty
                                            ? null
                                            : double.tryParse(
                                                _cgstController.text),
                                        sGst: _sgstController.text.isEmpty
                                            ? null
                                            : double.tryParse(
                                                _sgstController.text),
                                        iGst: _igstController.text.isEmpty
                                            ? null
                                            : double.tryParse(
                                                _igstController.text),
                                        creditOpBalRs:
                                            _creditController.text.isEmpty
                                                ? 0.00
                                                : double.tryParse(
                                                    _creditController.text),
                                        creditOpBalDollor:
                                            _creditControllerDollor.text.isEmpty
                                                ? null
                                                : double.tryParse(
                                                    _creditControllerDollor
                                                        .text),
                                        debitOpBalRs:
                                            _debitController.text.isEmpty
                                                ? 0.00
                                                : double.tryParse(
                                                    _debitController.text),
                                        debitOpBalDollor: _debitControllerDollor
                                                .text.isEmpty
                                            ? null
                                            : double.tryParse(
                                                _debitControllerDollor.text),
                                      )
                                          .then((onValue) {
                                        _codeController.clear();
                                        _clearFormFields();
                                      });
                                    } else {
                                      infoDialog(
                                          messageText:
                                              'Please Fill Required Field');
                                    }
                                  }
                                : null,
                        child: Obx(
                          () => defaultController.isLoading.value
                              ? const CupertinoActivityIndicator()
                              : const Text("Save"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: _isFromEdit
                            ? () {
                                defaultController
                                    .deletePartyData(id: selectedPartyMstID)
                                    .then((onValue) {
                                  _clearFormFields();
                                  _codeController.clear();
                                  setState(() {
                                    _isFromEdit = false;
                                  });
                                });
                              }
                            : null,
                        child: Obx(
                          () => defaultController.isDeleteLoading.value
                              ? const CupertinoActivityIndicator()
                              : const Text("Delete"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: _isEnabled || _isFromEdit
                            ? () {
                                _clearFormFields();
                                _codeController.clear();
                                setState(() {
                                  _isEnabled = false;
                                  _isFromEdit = false;
                                });
                              }
                            : null,
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {
                          // menuController.selectedIndex.value = 0;
                          tabController
                              .removeTab(tabController.currentIndex.value);
                        },
                        child: const Text("Exit"),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text("Print"),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // const Text(
                          //   'Active',
                          //   style: TextStyle(
                          //     color: Colors.black,
                          //     fontWeight: FontWeight.w900,
                          //     fontSize: 12, // Font size for the label
                          //   ),
                          // ),
                          // Checkbox(
                          //   value: _isActive,
                          //   onChanged: (value) {
                          //     setState(() {
                          //       _isActive = value!;
                          //     });
                          //   },
                          // ),
                          OutlinedButton(
                            onPressed: !_isEnabled && !_isFromEdit
                                ? _enableFields
                                : null,
                            child: const Text("Add"),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: _isFromEdit
                                ? () {
                                    // if (_isFromEdit) {
                                    _enableEditFields();
                                    // } else {
                                    //   infoDialog(
                                    //       messageText:
                                    //           'Please Select Party to Edit.');
                                    // }
                                  }
                                : null,
                            child: const Text("Edit"),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: _isFromEdit
                                ? () async {
                                    if (_formKey.currentState!.validate()) {
                                      await defaultController
                                          .updatePartyData(
                                        id: selectedPartyMstID.value,
                                        partyName: _nameController.text.isEmpty
                                            ? null
                                            : _nameController.text,
                                        partyType: _selectedType.value.isEmpty
                                            ? null
                                            : _selectedType.value,
                                        contactPerson: _contactPersonController
                                                .text.isEmpty
                                            ? null
                                            : _contactPersonController.text,
                                        address: _addressController.text.isEmpty
                                            ? null
                                            : _addressController.text,
                                        mobileNo:
                                            _mobileNoController.text.isEmpty
                                                ? null
                                                : _mobileNoController.text,
                                        phNo: _phoneController.text.isEmpty
                                            ? null
                                            : _phoneController.text,
                                        fax: _faxController.text.isEmpty
                                            ? null
                                            : _faxController.text,
                                        email: _emailController.text.isEmpty
                                            ? null
                                            : _emailController.text,
                                        website: _websiteController.text.isEmpty
                                            ? null
                                            : _websiteController.text,
                                        pan: _panController.text.isEmpty
                                            ? null
                                            : _panController.text,
                                        adhar: _aadharController.text.isEmpty
                                            ? null
                                            : _aadharController.text,
                                        bankName: _bankController.text.isEmpty
                                            ? null
                                            : _bankController.text,
                                        branchName:
                                            _branchController.text.isEmpty
                                                ? null
                                                : _branchController.text,
                                        bankAdd:
                                            _bankAddressController.text.isEmpty
                                                ? null
                                                : _bankAddressController.text,
                                        ifscCode: _ifscController.text.isEmpty
                                            ? null
                                            : _ifscController.text,
                                        bankAcNo:
                                            _accountNoController.text.isEmpty
                                                ? null
                                                : _accountNoController.text,
                                        location:
                                            _locationController.text.isEmpty
                                                ? null
                                                : _locationController.text,
                                        city: _locationController.text.isEmpty
                                            ? null
                                            : _locationController.text,
                                        state: _locationController.text.isEmpty
                                            ? null
                                            : _locationController.text,
                                        // gstNo: '',
                                        // If you want to keep this field as an empty string
                                        // remarks: '',
                                        // If you want to keep this field as an empty string
                                        sortId: _sortIdController.text.isEmpty
                                            ? null
                                            : int.tryParse(
                                                _sortIdController.text),
                                        typeCode: _selectedType.value.isEmpty
                                            ? null
                                            : _selectedType.value,
                                        active: _isActive,
                                        cGst: _cgstController.text.isEmpty
                                            ? null
                                            : double.tryParse(
                                                _cgstController.text),
                                        sGst: _sgstController.text.isEmpty
                                            ? null
                                            : double.tryParse(
                                                _sgstController.text),
                                        iGst: _igstController.text.isEmpty
                                            ? null
                                            : double.tryParse(
                                                _igstController.text),
                                        creditOpBalRs:
                                            _creditController.text.isEmpty
                                                ? 0.00
                                                : double.tryParse(
                                                    _creditController.text),
                                        creditOpBalDollor:
                                            _creditControllerDollor.text.isEmpty
                                                ? null
                                                : double.tryParse(
                                                    _creditControllerDollor
                                                        .text),
                                        debitOpBalRs:
                                            _debitController.text.isEmpty
                                                ? 0.00
                                                : double.tryParse(
                                                    _debitController.text),
                                        debitOpBalDollor: _debitControllerDollor
                                                .text.isEmpty
                                            ? null
                                            : double.tryParse(
                                                _debitControllerDollor.text),
                                      )
                                          .then((onValue) {
                                        _codeController.clear();
                                        _clearFormFields();
                                        setState(() {
                                          _isFromEdit = false;
                                        });
                                      });
                                    }
                                  }
                                : _isEnabled
                                    ? () async {
                                        if (_formKey.currentState!.validate()) {
                                          await defaultController
                                              .addPartyData(
                                            partyName:
                                                _nameController.text.isEmpty
                                                    ? null
                                                    : _nameController.text,
                                            partyType:
                                                _selectedType.value.isEmpty
                                                    ? null
                                                    : _selectedType.value,
                                            contactPerson:
                                                _contactPersonController
                                                        .text.isEmpty
                                                    ? null
                                                    : _contactPersonController
                                                        .text,
                                            address:
                                                _addressController.text.isEmpty
                                                    ? null
                                                    : _addressController.text,
                                            mobileNo:
                                                _mobileNoController.text.isEmpty
                                                    ? null
                                                    : _mobileNoController.text,
                                            phNo: _phoneController.text.isEmpty
                                                ? null
                                                : _phoneController.text,
                                            fax: _faxController.text.isEmpty
                                                ? null
                                                : _faxController.text,
                                            email: _emailController.text.isEmpty
                                                ? null
                                                : _emailController.text,
                                            website:
                                                _websiteController.text.isEmpty
                                                    ? null
                                                    : _websiteController.text,
                                            pan: _panController.text.isEmpty
                                                ? null
                                                : _panController.text,
                                            adhar:
                                                _aadharController.text.isEmpty
                                                    ? null
                                                    : _aadharController.text,
                                            bankName:
                                                _bankController.text.isEmpty
                                                    ? null
                                                    : _bankController.text,
                                            branchName:
                                                _branchController.text.isEmpty
                                                    ? null
                                                    : _branchController.text,
                                            bankAdd: _bankAddressController
                                                    .text.isEmpty
                                                ? null
                                                : _bankAddressController.text,
                                            ifscCode:
                                                _ifscController.text.isEmpty
                                                    ? null
                                                    : _ifscController.text,
                                            bankAcNo: _accountNoController
                                                    .text.isEmpty
                                                ? null
                                                : _accountNoController.text,
                                            location:
                                                _locationController.text.isEmpty
                                                    ? null
                                                    : _locationController.text,
                                            city:
                                                _locationController.text.isEmpty
                                                    ? null
                                                    : _locationController.text,
                                            state:
                                                _locationController.text.isEmpty
                                                    ? null
                                                    : _locationController.text,
                                            // gstNo: '',
                                            // If you want to keep this field as an empty string
                                            // remarks: '',
                                            // If you want to keep this field as an empty string
                                            sortId:
                                                _sortIdController.text.isEmpty
                                                    ? null
                                                    : int.tryParse(
                                                        _sortIdController.text),
                                            typeCode:
                                                _selectedType.value.isEmpty
                                                    ? null
                                                    : _selectedType.value,
                                            active: _isActive,
                                            cGst: _cgstController.text.isEmpty
                                                ? null
                                                : double.tryParse(
                                                    _cgstController.text),
                                            sGst: _sgstController.text.isEmpty
                                                ? null
                                                : double.tryParse(
                                                    _sgstController.text),
                                            iGst: _igstController.text.isEmpty
                                                ? null
                                                : double.tryParse(
                                                    _igstController.text),
                                            creditOpBalRs:
                                                _creditController.text.isEmpty
                                                    ? 0.00
                                                    : double.tryParse(
                                                        _creditController.text),
                                            creditOpBalDollor:
                                                _creditControllerDollor
                                                        .text.isEmpty
                                                    ? null
                                                    : double.tryParse(
                                                        _creditControllerDollor
                                                            .text),
                                            debitOpBalRs:
                                                _debitController.text.isEmpty
                                                    ? 0.00
                                                    : double.tryParse(
                                                        _debitController.text),
                                            debitOpBalDollor:
                                                _debitControllerDollor
                                                        .text.isEmpty
                                                    ? null
                                                    : double.tryParse(
                                                        _debitControllerDollor
                                                            .text),
                                          )
                                              .then((onValue) {
                                            _codeController.clear();
                                            _clearFormFields();
                                          });
                                        } else {
                                          infoDialog(
                                              messageText:
                                                  'Please Fill Required Field');
                                        }
                                      }
                                    : null,
                            child: const Text("Save"),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          OutlinedButton(
                            onPressed: _isFromEdit
                                ? () {
                                    defaultController
                                        .deletePartyData(id: selectedPartyMstID)
                                        .then((onValue) {
                                      _clearFormFields();
                                      _codeController.clear();
                                      setState(() {
                                        _isFromEdit = false;
                                      });
                                    });
                                  }
                                : null,
                            child: Obx(
                              () => defaultController.isDeleteLoading.value
                                  ? const CupertinoActivityIndicator()
                                  : const Text("Delete"),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: _isEnabled || _isFromEdit
                                ? () {
                                    _clearFormFields();
                                    _codeController.clear();
                                    setState(() {
                                      _isEnabled = false;
                                      _isFromEdit = false;
                                    });
                                  }
                                : null,
                            child: const Text("Cancel"),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () {
                              tabController
                                  .removeTab(tabController.currentIndex.value);
                              // menuController.selectedIndex.value = 0;
                            },
                            child: const Text("Exit"),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () {},
                            child: const Text("Print"),
                          ),
                        ],
                      )
                    ],
                  ),
            const SizedBox(height: 16),
            Obx(
              () => SizedBox(
                height: 350,
                child: SfDataGrid(
                  source: PartyDataGridSource(defaultController.partyMstList),
                  columns: <GridColumn>[
                    GridColumn(
                      columnName: 'Code',
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'Code',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Type',
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'Type',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Name',
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Contact Person',
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'Contact Person',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                    // GridColumn(
                    //   columnName: 'Mobile No',
                    //   label: Container(
                    //     padding: const EdgeInsets.all(8.0),
                    //     alignment: Alignment.center,
                    //     child: const Text(
                    //       'Mobile No',
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.bold, fontSize: 12),
                    //     ),
                    //   ),
                    // ),
                    GridColumn(
                      columnName: 'Address',
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'Address',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Location',
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'Location',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                    // GridColumn(
                    //   columnName: 'Email ID',
                    //   label: Container(
                    //     padding: const EdgeInsets.all(8.0),
                    //     alignment: Alignment.center,
                    //     child: const Text(
                    //       'Email ID',
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.bold, fontSize: 12),
                    //     ),
                    //   ),
                    // ),
                    // GridColumn(
                    //   columnName: 'Website',
                    //   label: Container(
                    //     padding: const EdgeInsets.all(8.0),
                    //     alignment: Alignment.center,
                    //     child: const Text(
                    //       'Website',
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.bold, fontSize: 12),
                    //     ),
                    //   ),
                    // ),
                    GridColumn(
                      columnName: 'CGST',
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'CGST',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'SGST',
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'SGST',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'IGST',
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'IGST',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Sort Id',
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'Sort Id',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Active',
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'Active',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                  rowHeight: 25,
                  headerRowHeight: 35,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  // allowSorting: true,
                  // allowMultiColumnSorting: true,
                  // allowFiltering: true,
                  selectionMode: SelectionMode.single,
                  // onSelectionChanged: (List<DataGridRow> selectedRows) {
                  //   // Handle row selection change if needed
                  // },
                  onSelectionChanged: (List<DataGridRow> addedRows,
                      List<DataGridRow> removedRows) {
                    setState(() {
                      // entries.length = 0;
                      _isFromEdit = true;
                      _isEnabled = false;
                    });
                    if (addedRows.isNotEmpty) {
                      final DataGridRow selectedRow = addedRows.first;
                      List<PartyMstModel> partyData =
                          defaultController.partyMstList;
                      selectedPartyMstID.value = selectedRow
                          .getCells()[0]
                          .value; // Assuming the ID is in the first cell

                      PartyMstModel partyEntry = partyData.firstWhere(
                        (entry) => entry.partyMstID == selectedPartyMstID.value,
                      );

                      _codeController.text =
                          partyEntry.partyMstID?.toString() ?? '';
                      _nameController.text = partyEntry.partyName ?? '';
                      _contactPersonController.text =
                          partyEntry.contactPerson ?? '';
                      _locationController.text = partyEntry.city ?? '';
                      // _locationController.text = [
                      //   if (partyEntry.city != null) partyEntry.city,
                      //   if (partyEntry.state != null) partyEntry.state
                      // ].join(', ').trim();
                      _addressController.text = partyEntry.address ?? '';
                      _mobileNoController.text = partyEntry.mobileno ?? '';
                      _emailController.text = partyEntry.emailID ?? '';
                      _websiteController.text = partyEntry.webSite ?? '';
                      _cgstController.text = partyEntry.cGST?.toString() ?? '';
                      _igstController.text = partyEntry.iGST?.toString() ?? '';
                      _sgstController.text = partyEntry.sGST?.toString() ?? '';
                      _phoneController.text = partyEntry.phNo ?? '';
                      _faxController.text = partyEntry.fax ?? '';
                      _panController.text = partyEntry.panNo ?? '';
                      _aadharController.text = partyEntry.adharNo ?? '';
                      _bankController.text = partyEntry.bankName ?? '';
                      _branchController.text = partyEntry.branchName ?? '';
                      _bankAddressController.text = partyEntry.bankAdress ?? '';
                      _ifscController.text = partyEntry.iFSCCode ?? '';
                      _accountNoController.text = partyEntry.bankAcNo ?? '';
                      _sortIdController.text =
                          partyEntry.sortID?.toString() ?? '';
                      _creditController.text =
                          partyEntry.creditOpBalRs?.toString() ?? '0.00';
                      _creditControllerDollor.text =
                          partyEntry.creditOpBalDollar?.toString() ?? '';
                      _debitController.text =
                          partyEntry.debitOpBalRs?.toString() ?? '0.00';
                      _debitControllerDollor.text =
                          partyEntry.debitOpBalDollar?.toString() ?? '';
                      setState(() {
                        _isActive = partyEntry.active!;
                      });

                      _selectedType.value = partyEntry.typeCode.toString();
                      // _enableEditFields();
                    }
                  },
                  columnWidthMode: ColumnWidthMode.auto,
                  frozenColumnsCount: 1,
                  // gridLineStrokeWidth: 1.5,
                  // gridLineColor: Colors.grey.shade400,
                  // backgroundColor: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    return defaultController.partyTypeMstList.map((partyType) {
      return DropdownMenuItem<String>(
        value: partyType.typeCode.toString(),
        child: Text(partyType.typeName!),
      );
    }).toList();
  }
}
