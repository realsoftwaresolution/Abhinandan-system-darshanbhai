import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/rough/rough_model.dart';

class RoughDataTable extends StatelessWidget {
  final RxList<Map<String, String>> recEntries;
  final DefaultController defaultController;
  final RxBool isFromEdit;
  final TextEditingController descriptionController;
  final TextEditingController issWtController;
  final TextEditingController recWtController;
  final TextEditingController rateController;
  final RxString selectedType;
  final RxString selectedRoughId;
  final RxDouble totalRecWt;
  final RxDouble totalWt;
  final double totalRecRate;
  final RxDouble totalRecAmount;

  const RoughDataTable(
      {super.key,
      required this.recEntries,
      required this.defaultController,
      required this.isFromEdit,
      required this.descriptionController,
      required this.issWtController,
      required this.recWtController,
      required this.rateController,
      required this.selectedType,
      required this.selectedRoughId,
      required this.totalRecWt,
      required this.totalRecRate,
      required this.totalRecAmount, required this.totalWt});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Table(
        border: TableBorder.all(color: Colors.grey),
        columnWidths: const {
          0: FixedColumnWidth(50), // Adjust this based on your needs
          1: FlexColumnWidth(60),
          2: FlexColumnWidth(150),
          3: FixedColumnWidth(80),
          4: FixedColumnWidth(80),
          5: FixedColumnWidth(80),
          6: FixedColumnWidth(80),
          7: FixedColumnWidth(40),
          8: FixedColumnWidth(40),
          9: FixedColumnWidth(40),
        },
        children: [
          // Table Header Row
          const TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  'SR.NO',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  'ROUGH',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  'DESCRIPTION',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  'WT',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  'REC WT',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  'RATE',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  'AMOUNT',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  '',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  '',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ), // Placeholder for edit icon
            ],
          ),
          // Data Rows
          for (int index = 0; index < recEntries.length; index++)
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    (index + 1).toString(),
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    getRoughName(recEntries[index]['rough']!),
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    recEntries[index]['description']!,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    recEntries[index]['wt']!,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    recEntries[index]['recWt']!,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    recEntries[index]['rate']!,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    recEntries[index]['amount']!,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Obx(
                    () => defaultController.isLoading.value
                        ? const CupertinoActivityIndicator()
                        : GestureDetector(
                            child: const Icon(
                              Icons.delete,
                              size: 15,
                            ),
                            onTap: () {
                              if (isFromEdit.value) {
                                defaultController
                                    .deleteMemoRecRoughData(
                                        id: int.parse(recEntries[index]['id']!))
                                    .then((onValue) {
                                  // setState(() {
                                  recEntries.removeAt(index);
                                  // });
                                });
                              } else {
                                // setState(() {
                                recEntries.removeAt(index);
                                // });
                              }
                            },
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: GestureDetector(
                    child: const Icon(
                      Icons.edit,
                      size: 15,
                    ),
                    onTap: () {
                      selectedRoughId.value = recEntries[index]['id']!;
                      selectedType.value = recEntries[index]['rough']!;
                      issWtController.text = recEntries[index]['wt']!;
                      recWtController.text = recEntries[index]['recWt']!;
                      rateController.text = recEntries[index]['rate']!;
                      descriptionController.text =
                          recEntries[index]['description']!;
                      // setState(() {
                      recEntries.removeAt(index);
                      // });
                    },
                  ),
                ),
              ],
            ),
          // Total Row
          TableRow(
            children: [
              const Padding(padding: EdgeInsets.all(3.0), child: Text('')),
              const Padding(padding: EdgeInsets.all(3.0), child: Text('')),
              const Padding(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  'TOTAL',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  textAlign: TextAlign.end,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  totalWt.value.toStringAsFixed(2),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  totalRecWt.value.toStringAsFixed(2),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  totalRecRate.toStringAsFixed(2),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  totalRecAmount.value.toStringAsFixed(2),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                  textAlign: TextAlign.start,
                ),
              ),
              const Padding(padding: EdgeInsets.all(3.0), child: Text('')),
              const Padding(padding: EdgeInsets.all(3.0), child: Text('')),
            ],
          ),
        ],
      ),
    );
  }

  String getRoughName(String? typeCode) {
    final party = defaultController.roughModel.firstWhere(
        (p) => p.roughTypeCode == int.parse(typeCode!),
        orElse: () => RoughModel(roughTypeName: 'Unknown'));
    return party.roughTypeName ?? 'Unknown';
  }
}
