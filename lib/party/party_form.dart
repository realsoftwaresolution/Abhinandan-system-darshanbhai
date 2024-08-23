import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_web_rough_entry_system/responsive.dart';

class PartyForm extends StatefulWidget {
  const PartyForm({super.key});

  @override
  PartyFormState createState() => PartyFormState();
}

class PartyFormState extends State<PartyForm> {
  final String _ipAddress = 'REAL SOFTWARE SOLUTIONS';
  final String _currentTime = '';
  final String _username = 'Unknown User';

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
  void dispose() {
    _panController.dispose();
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

  final List<DataRow> _rows = []; // Store DataRows

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
  final TextEditingController _debitController = TextEditingController();

  String _selectedType = 'PURCHASE';
  bool _isActive = true;

  void _addNewEntry() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _rows.add(
          DataRow(
            cells: [
              DataCell(Text(_codeController.text)),
              DataCell(Text(_selectedType)),
              DataCell(Text(_nameController.text)),
              DataCell(Text(_contactPersonController.text)),
              DataCell(Text(_locationController.text)),
              DataCell(Text(_addressController.text)),
              DataCell(Text(_mobileNoController.text)),
              DataCell(Text(_emailController.text)),
              DataCell(Text(_websiteController.text)),
              DataCell(Text(_cgstController.text)),
              DataCell(Text(_sgstController.text)),
              DataCell(Text(_igstController.text)),
              DataCell(Text(_phoneController.text)),
              DataCell(Text(_faxController.text)),
              DataCell(Text(_panController.text)),
              DataCell(Text(_aadharController.text)),
              DataCell(Text(_bankController.text)),
              DataCell(Text(_branchController.text)),
              DataCell(Text(_bankAddressController.text)),
              DataCell(Text(_ifscController.text)),
              DataCell(Text(_accountNoController.text)),
              DataCell(Text(_sortIdController.text)),
              DataCell(Text(_isActive ? 'Active' : 'Inactive')),
              DataCell(Text(_creditController.text)),
              DataCell(Text(_debitController.text)),
            ],
          ),
        );
        _clearFormFields(); // Clear form fields after adding
      });
    }
  }

  void _clearFormFields() {
    _codeController.clear();
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
    _selectedType = 'PURCHASE';
    _isActive = true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: SizedBox(
                                    width: 50,
                                    child: TextFormField(
                                      controller: _codeController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      decoration: const InputDecoration(
                                        errorStyle: TextStyle(
                                          height: 0, // Hides the error message
                                          fontSize:
                                              0, // Ensures no space is taken by the error message
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                            // Red border when focused with an error
                                            width: 1.0, // Thin border width
                                          ),
                                          borderRadius: BorderRadius
                                              .zero, // Squared corners
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                            // Red border for errors
                                            width: 1.0, // Thin border width
                                          ),
                                          borderRadius: BorderRadius
                                              .zero, // Squared corners
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.blue,
                                            // Black border when focused without error
                                            width: 1.0, // Thin border width
                                          ),
                                          borderRadius: BorderRadius
                                              .zero, // Squared corners
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                            // Light grey border when enabled
                                            width: 1.0, // Thin border width
                                          ),
                                          borderRadius: BorderRadius
                                              .zero, // Squared corners
                                        ),
                                        filled: true,
                                        // Fill the background
                                        fillColor: Colors.white,
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
                                        fontSize:
                                            14, // Consistent font size with label
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
                                  'Type',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    style: const TextStyle(fontSize: 14),
                                    value: _selectedType,
                                    decoration: const InputDecoration(
                                      errorStyle: TextStyle(
                                        height: 0, // Hides the error message
                                        fontSize:
                                            0, // Ensures no space is taken by the error message
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border when focused with an error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border for errors
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          // Black border when focused without error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          // Light grey border when enabled
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      filled: true,
                                      // Fill the background
                                      fillColor: Colors.white,
                                      // White background
                                      isDense: true,
                                      // Reduces the overall height of the TextField
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal:
                                              8), // Remove top padding, minimal horizontal padding
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                          value: 'PURCHASE',
                                          child: Text('PURCHASE')),
                                      DropdownMenuItem(
                                          value: 'SALE', child: Text('SALE')),
                                      DropdownMenuItem(
                                          value: 'MANAGER',
                                          child: Text('MANAGER')),
                                      DropdownMenuItem(
                                          value: 'COMPANY',
                                          child: Text('COMPANY')),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedType = value ?? 'PURCHASE';
                                      });
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
                                  'Name',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: TextFormField(
                                    controller: _nameController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
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
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border when focused with an error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border for errors
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          // Black border when focused without error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          // Light grey border when enabled
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      filled: true,
                                      // Fill the background
                                      fillColor: Colors.white,
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
                                      fontSize:
                                          14, // Consistent font size with label
                                    ),
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
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: TextFormField(
                                    controller: _contactPersonController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
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
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border when focused with an error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border for errors
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          // Black border when focused without error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          // Light grey border when enabled
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      filled: true,
                                      // Fill the background
                                      fillColor: Colors.white,
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
                                      fontSize:
                                          14, // Consistent font size with label
                                    ),
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
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: TextFormField(
                                    controller: _locationController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      errorStyle: TextStyle(
                                        height: 0, // Hides the error message
                                        fontSize:
                                            0, // Ensures no space is taken by the error message
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border when focused with an error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border for errors
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          // Black border when focused without error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          // Light grey border when enabled
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      filled: true,
                                      // Fill the background
                                      fillColor: Colors.white,
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
                                      fontSize:
                                          14, // Consistent font size with label
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
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: TextFormField(
                                    controller: _addressController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      errorStyle: TextStyle(
                                        height: 0, // Hides the error message
                                        fontSize:
                                            0, // Ensures no space is taken by the error message
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border when focused with an error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border for errors
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          // Black border when focused without error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          // Light grey border when enabled
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      filled: true,
                                      // Fill the background
                                      fillColor: Colors.white,
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
                                      fontSize:
                                          14, // Consistent font size with label
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
                                  'Mobile No.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: TextFormField(
                                    controller: _mobileNoController,
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    decoration: const InputDecoration(
                                      errorStyle: TextStyle(
                                        height: 0, // Hides the error message
                                        fontSize:
                                            0, // Ensures no space is taken by the error message
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border when focused with an error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border for errors
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          // Black border when focused without error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          // Light grey border when enabled
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      filled: true,
                                      // Fill the background
                                      fillColor: Colors.white,
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
                                      fontSize:
                                          14, // Consistent font size with label
                                    ),
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
                                  'Email',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      errorStyle: TextStyle(
                                        height: 0, // Hides the error message
                                        fontSize:
                                            0, // Ensures no space is taken by the error message
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border when focused with an error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border for errors
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          // Black border when focused without error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          // Light grey border when enabled
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      filled: true,
                                      // Fill the background
                                      fillColor: Colors.white,
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
                                      fontSize:
                                          14, // Consistent font size with label
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '';
                                        // return 'Please enter an email';
                                      }
                                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                          .hasMatch(value)) {
                                        return '';
                                        // return 'Please enter a valid email';
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
                                  'Website',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: TextFormField(
                                    controller: _websiteController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      errorStyle: TextStyle(
                                        height: 0, // Hides the error message
                                        fontSize:
                                            0, // Ensures no space is taken by the error message
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border when focused with an error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border for errors
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          // Black border when focused without error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          // Light grey border when enabled
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      filled: true,
                                      // Fill the background
                                      fillColor: Colors.white,
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
                                      fontSize:
                                          14, // Consistent font size with label
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
                                  'Ph No.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: const InputDecoration(
                                      errorStyle: TextStyle(
                                        height: 0, // Hides the error message
                                        fontSize:
                                            0, // Ensures no space is taken by the error message
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border when focused with an error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border for errors
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          // Black border when focused without error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          // Light grey border when enabled
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      filled: true,
                                      // Fill the background
                                      fillColor: Colors.white,
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
                                      fontSize:
                                          14, // Consistent font size with label
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
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: TextFormField(
                                    controller: _faxController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: const InputDecoration(
                                      errorStyle: TextStyle(
                                        height: 0, // Hides the error message
                                        fontSize:
                                            0, // Ensures no space is taken by the error message
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border when focused with an error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border for errors
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          // Black border when focused without error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          // Light grey border when enabled
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      filled: true,
                                      // Fill the background
                                      fillColor: Colors.white,
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
                                      fontSize:
                                          14, // Consistent font size with label
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
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: TextFormField(
                                    controller: _panController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
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
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border when focused with an error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border for errors
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          // Black border when focused without error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          // Light grey border when enabled
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      filled: true,
                                      // Fill the background
                                      fillColor: Colors.white,
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
                                      fontSize:
                                          14, // Consistent font size with label
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
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: TextFormField(
                                    controller: _aadharController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
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
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border when focused with an error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border for errors
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          // Black border when focused without error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          // Light grey border when enabled
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      filled: true,
                                      // Fill the background
                                      fillColor: Colors.white,
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
                                      fontSize:
                                          14, // Consistent font size with label
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
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: TextFormField(
                                    controller: _cgstController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      errorStyle: TextStyle(
                                        height: 0, // Hides the error message
                                        fontSize:
                                            0, // Ensures no space is taken by the error message
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border when focused with an error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border for errors
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          // Black border when focused without error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          // Light grey border when enabled
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      filled: true,
                                      // Fill the background
                                      fillColor: Colors.white,
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
                                      fontSize:
                                          14, // Consistent font size with label
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
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: TextFormField(
                                    controller: _sgstController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      errorStyle: TextStyle(
                                        height: 0, // Hides the error message
                                        fontSize:
                                            0, // Ensures no space is taken by the error message
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border when focused with an error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border for errors
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          // Black border when focused without error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          // Light grey border when enabled
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      filled: true,
                                      // Fill the background
                                      fillColor: Colors.white,
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
                                      fontSize:
                                          14, // Consistent font size with label
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
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: TextFormField(
                                    controller: _igstController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      errorStyle: TextStyle(
                                        height: 0, // Hides the error message
                                        fontSize:
                                            0, // Ensures no space is taken by the error message
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border when focused with an error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border for errors
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          // Black border when focused without error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          // Light grey border when enabled
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      filled: true,
                                      // Fill the background
                                      fillColor: Colors.white,
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
                                      fontSize:
                                          14, // Consistent font size with label
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
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: TextFormField(
                                    controller: _bankController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      errorStyle: TextStyle(
                                        height: 0, // Hides the error message
                                        fontSize:
                                            0, // Ensures no space is taken by the error message
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border when focused with an error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border for errors
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          // Black border when focused without error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          // Light grey border when enabled
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      filled: true,
                                      // Fill the background
                                      fillColor: Colors.white,
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
                                      fontSize:
                                          14, // Consistent font size with label
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
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: TextFormField(
                                    controller: _branchController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      errorStyle: TextStyle(
                                        height: 0, // Hides the error message
                                        fontSize:
                                            0, // Ensures no space is taken by the error message
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border when focused with an error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border for errors
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          // Black border when focused without error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          // Light grey border when enabled
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      filled: true,
                                      // Fill the background
                                      fillColor: Colors.white,
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
                                      fontSize:
                                          14, // Consistent font size with label
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
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: TextFormField(
                                    controller: _bankAddressController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      errorStyle: TextStyle(
                                        height: 0, // Hides the error message
                                        fontSize:
                                            0, // Ensures no space is taken by the error message
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border when focused with an error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border for errors
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          // Black border when focused without error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          // Light grey border when enabled
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      filled: true,
                                      // Fill the background
                                      fillColor: Colors.white,
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
                                      fontSize:
                                          14, // Consistent font size with label
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
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: TextFormField(
                                    controller: _ifscController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      errorStyle: TextStyle(
                                        height: 0, // Hides the error message
                                        fontSize:
                                            0, // Ensures no space is taken by the error message
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border when focused with an error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border for errors
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          // Black border when focused without error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          // Light grey border when enabled
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      filled: true,
                                      // Fill the background
                                      fillColor: Colors.white,
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
                                      fontSize:
                                          14, // Consistent font size with label
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
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: TextFormField(
                                    controller: _accountNoController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
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
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border when focused with an error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border for errors
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          // Black border when focused without error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          // Light grey border when enabled
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      filled: true,
                                      // Fill the background
                                      fillColor: Colors.white,
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
                                      fontSize:
                                          14, // Consistent font size with label
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
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: TextFormField(
                                    controller: _sortIdController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      errorStyle: TextStyle(
                                        height: 0, // Hides the error message
                                        fontSize:
                                            0, // Ensures no space is taken by the error message
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border when focused with an error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border for errors
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          // Black border when focused without error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          // Light grey border when enabled
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      filled: true,
                                      // Fill the background
                                      fillColor: Colors.white,
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
                                      fontSize:
                                          14, // Consistent font size with label
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
                                  'Credit',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: TextFormField(
                                    controller: _creditController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      errorStyle: TextStyle(
                                        height: 0, // Hides the error message
                                        fontSize:
                                            0, // Ensures no space is taken by the error message
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border when focused with an error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border for errors
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          // Black border when focused without error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          // Light grey border when enabled
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      filled: true,
                                      // Fill the background
                                      fillColor: Colors.white,
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
                                      fontSize:
                                          14, // Consistent font size with label
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
                                  'Debit',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Space between the label and TextFormField
                                Expanded(
                                  child: TextFormField(
                                    controller: _debitController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      errorStyle: TextStyle(
                                        height: 0, // Hides the error message
                                        fontSize:
                                            0, // Ensures no space is taken by the error message
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border when focused with an error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          // Red border for errors
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          // Black border when focused without error
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          // Light grey border when enabled
                                          width: 1.0, // Thin border width
                                        ),
                                        borderRadius: BorderRadius
                                            .zero, // Squared corners
                                      ),
                                      filled: true,
                                      // Fill the background
                                      fillColor: Colors.white,
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
                                      fontSize:
                                          14, // Consistent font size with label
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
                      const SizedBox(height: 16),
                      !Responsive.isMobile(context)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(
                                  'Active',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14, // Font size for the label
                                  ),
                                ),
                                Checkbox(
                                  value: _isActive,
                                  onChanged: (value) {
                                    setState(() {
                                      _isActive = value!;
                                    });
                                  },
                                ),
                                OutlinedButton(
                                  onPressed: _addNewEntry,
                                  child: const Text("Add"),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: _addNewEntry,
                                  child: const Text("Edit"),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: _addNewEntry,
                                  child: const Text("Save"),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: _addNewEntry,
                                  child: const Text("Delete"),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: _addNewEntry,
                                  child: const Text("Cancel"),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: _addNewEntry,
                                  child: const Text("Exit"),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: _addNewEntry,
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
                                    const Text(
                                      'Active',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14, // Font size for the label
                                      ),
                                    ),
                                    Checkbox(
                                      value: _isActive,
                                      onChanged: (value) {
                                        setState(() {
                                          _isActive = value!;
                                        });
                                      },
                                    ),
                                    OutlinedButton(
                                      onPressed: _addNewEntry,
                                      child: const Text("Add"),
                                    ),
                                    const SizedBox(width: 8),
                                    OutlinedButton(
                                      onPressed: _addNewEntry,
                                      child: const Text("Edit"),
                                    ),
                                    const SizedBox(width: 8),
                                    OutlinedButton(
                                      onPressed: _addNewEntry,
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
                                      onPressed: _addNewEntry,
                                      child: const Text("Delete"),
                                    ),
                                    const SizedBox(width: 8),
                                    OutlinedButton(
                                      onPressed: _addNewEntry,
                                      child: const Text("Cancel"),
                                    ),
                                    const SizedBox(width: 8),
                                    OutlinedButton(
                                      onPressed: _addNewEntry,
                                      child: const Text("Exit"),
                                    ),
                                    const SizedBox(width: 8),
                                    OutlinedButton(
                                      onPressed: _addNewEntry,
                                      child: const Text("Print"),
                                    ),
                                  ],
                                )
                              ],
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(label: Text('Code')),
                      DataColumn(label: Text('Type')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Contact Person')),
                      DataColumn(label: Text('Location')),
                      DataColumn(label: Text('Address')),
                      DataColumn(label: Text('Mobile No')),
                      DataColumn(label: Text('Email ID')),
                      DataColumn(label: Text('Website')),
                      DataColumn(label: Text('CGST')),
                      DataColumn(label: Text('SGST')),
                      DataColumn(label: Text('IGST')),
                      DataColumn(label: Text('Ph No.')),
                      DataColumn(label: Text('Fax')),
                      DataColumn(label: Text('Pan No.')),
                      DataColumn(label: Text('Aadhar No.')),
                      DataColumn(label: Text('Bank')),
                      DataColumn(label: Text('Branch')),
                      DataColumn(label: Text('Bank Add.')),
                      DataColumn(label: Text('IFSC')),
                      DataColumn(label: Text('Account No.')),
                      DataColumn(label: Text('Sort Id')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Credit')),
                      DataColumn(label: Text('Debit')),
                    ],
                    rows: _rows,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          color: Colors.grey[300],
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_ipAddress),
              Text(_currentTime),
              Text(_username),
            ],
          ),
        ),
      ],
    );
  }
}
