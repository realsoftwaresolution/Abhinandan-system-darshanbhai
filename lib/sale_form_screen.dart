import 'package:flutter/material.dart';
import 'package:real_web_rough_entry_system/header.dart';
import 'package:real_web_rough_entry_system/responsive.dart';

class SaleFormScreen extends StatefulWidget {
  const SaleFormScreen({super.key});

  @override
  SaleFormScreenState createState() => SaleFormScreenState();
}

class SaleFormScreenState extends State<SaleFormScreen> {
  final TextEditingController partyController = TextEditingController();
  final TextEditingController invNoController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController purIdController = TextEditingController();

  final TextEditingController roghController = TextEditingController();
  final TextEditingController descripController = TextEditingController();
  final TextEditingController wtController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController ammountController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  List<Map<String, String>> entries = [];

  void addEntry() {
    setState(() {
      entries.add({
        'rogh': roghController.text,
        'descrip': descripController.text,
        'wt': wtController.text,
        'rate': rateController.text,
        'amount': (double.parse(wtController.text) *
            double.parse(rateController.text))
            .toStringAsFixed(2),
      });

      // Clear the input fields
      roghController.clear();
      descripController.clear();
      wtController.clear();
      rateController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start
        ,
        children: [
          const Header(title: 'Sale'),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRow([
                            _buildTextField(
                                'PARTY', 'NAME SELECT', partyController),
                            _buildTextField(
                                'INV.NO', 'MANUAL', invNoController),
                            _buildTextField('DATE', 'MANUAL', dateController),
                            _buildTextField('PURID', 'AUTO', purIdController),
                          ]),
                          const SizedBox(height: 10),
                          _buildRow([
                            _buildTextField('BROKER', 'NAME SELECT', null),
                            _buildTextField('DUE DAYS', 'MANUAL', null),
                            _buildTextField(
                                'DUE DATE', 'DATE + DUE DAYS', null),
                            _buildTextField('STOCK', 'MANUAL', stockController),
                          ]),
                          const SizedBox(height: 10),
                          _buildRow([
                            _buildTextField(
                                'ROGH', 'SELECT ROUGH TYPE', roghController),
                            _buildTextField(
                                'DESCRIPTION', 'MANUAL', descripController),
                            _buildTextField('WT', 'MANUAL', wtController),
                            _buildTextField('RATE', 'MANUAL', rateController),
                            _buildTextField('AMMOUNT', 'MANUAL', ammountController),

                            Container(
                              alignment: Alignment.bottomCenter,
                              child: ElevatedButton(
                                onPressed: addEntry,
                                child: const Text('Add'),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildDataTable(),
                    )
                    // PartyForm(),
                    // MyFiles(),
                    // const SizedBox(height: 16),
                    // RecentFiles(),
                    // if (Responsive.isMobile(context)) const SizedBox(height: 16),
                    // if (Responsive.isMobile(context)) StorageDetails(),
                  ],
                ),
              ),
              if (!Responsive.isMobile(context)) const SizedBox(width: 16),
              // On Mobile means if the screen is less than 850 we don't want to show it
              // if (!Responsive.isMobile(context))
              //   const Expanded(
              //       flex: 2,
              //       // child: StorageDetails(),
              //       child: Column(
              //         children: [],
              //       )),
            ],
          ),
        ],
      ),
    );
  }

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

  Widget _buildTextField(
      String label, String hint, TextEditingController? controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(label),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: label,
            border: const UnderlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('SR.NO')),
        DataColumn(label: Text('ROGH')),
        DataColumn(label: Text('DESCRIP')),
        DataColumn(label: Text('WT')),
        DataColumn(label: Text('RATE')),
        DataColumn(label: Text('AMOUNT')),
      ],
      rows: List<DataRow>.generate(
        entries.length,
            (index) => DataRow(
          cells: [
            DataCell(Text((index + 1).toString())),
            DataCell(Text(entries[index]['rogh']!)),
            DataCell(Text(entries[index]['descrip']!)),
            DataCell(Text(entries[index]['wt']!)),
            DataCell(Text(entries[index]['rate']!)),
            DataCell(Text(entries[index]['amount']!)),
          ],
        ),
      )..add(
        DataRow(
          cells: [
            const DataCell(Text('')),
            const DataCell(Text('')),
            const DataCell(
                Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold))),
            DataCell(Text(
              entries
                  .fold(0.0, (prev, e) => prev + double.parse(e['wt']!))
                  .toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
            const DataCell(Text('')),
            DataCell(Text(
              entries
                  .fold(0.0, (prev, e) => prev + double.parse(e['amount']!))
                  .toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
          ],
        ),
      ),
    );
  }
}
