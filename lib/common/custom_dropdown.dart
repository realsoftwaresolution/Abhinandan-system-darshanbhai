import 'package:flutter/material.dart';

class MultiColumnDropdown extends StatefulWidget {
  const MultiColumnDropdown({super.key});

  @override
  MultiColumnDropdownState createState() => MultiColumnDropdownState();
}

class MultiColumnDropdownState extends State<MultiColumnDropdown> {
  String selectedValue = 'Select an Item';

  List<Map<String, String>> dropdownItems = [
    {"name": "NILKANTH", "typeName": "COMPANY", "balance": "1142030.00", "crDr": "Dr"},
    {"name": "ASIN LABGROWN", "typeName": "PURCHASE", "balance": "1670140.76", "crDr": "Cr"},
    {"name": "BHARATBHAI MEPANI", "typeName": "MANAGER", "balance": "0.00", "crDr": "Dr"},
    {"name": "SELF", "typeName": "DALALI A/C.", "balance": "10000.00", "crDr": "Cr"},
    {"name": "NAYANBHAI", "typeName": "DALALI A/C.", "balance": "0.00", "crDr": "Dr"},
    {"name": "JIGAR PATEL", "typeName": "DALALI A/C.", "balance": "0.00", "crDr": "Cr"},
    {"name": "CASH", "typeName": "CASH", "balance": "10000.00", "crDr": "Dr"},
    {"name": "ROHITBHAI", "typeName": "PARTNER", "balance": "77600000.00", "crDr": "Cr"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multi-Column Dropdown Example')),
      body: Center(
        child: PopupMenuButton<String>(
          onSelected: (String value) {
            setState(() {
              selectedValue = value;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(selectedValue),
          ),
          itemBuilder: (BuildContext context) {
            return dropdownItems.map((item) {
              return PopupMenuItem<String>(
                value: item['name'], // This is the selected value
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 2, child: Text(item['name'] ?? '')),
                    Expanded(flex: 2, child: Text(item['typeName'] ?? '')),
                    Expanded(flex: 1, child: Text(item['balance'] ?? '')),
                    Expanded(flex: 1, child: Text(item['crDr'] ?? '')),
                  ],
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}

