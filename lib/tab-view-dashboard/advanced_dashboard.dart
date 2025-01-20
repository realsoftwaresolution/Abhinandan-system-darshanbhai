import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/purchase/outstanding_purchase_details.dart';
import 'package:real_web_rough_entry_system/tab-view-dashboard/list_view.dart';
import 'package:shimmer/shimmer.dart';

class AdvancedDashboard extends StatelessWidget {
  const AdvancedDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTotalPurchaseSaleOutstandingCard(false),
                    _buildTotalPurchaseSaleOutstandingCard(true),
                    _buildTotalCashBankOutstandingCard(false),
                    // _buildTotalCashBankOutstandingCard(true)
                  ],
                ),
              )
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSectionTitle("Today's Payment"),
                    defaultController.isLoadingDashboardData.value
                        ? _buildShimmerEffect()
                        : _buildTodayPaymentCard(),
                    const SizedBox(height: 16),
                    buildSectionTitle("Overdue Payment"),
                    defaultController.isLoadingDashboardData.value
                        ? _buildShimmerEffect()
                        : _buildOutstandingPaymentCard(),
                    const SizedBox(height: 16),
                    buildSectionTitle("Upcoming Payment"),
                    defaultController.isLoadingDashboardData.value
                        ? _buildShimmerEffect()
                        : _buildUpcomingDuePaymentCard(),
                    // Outstanding Payments
                    // Today's Due Purchases and Sales
                    // _buildSectionTitle("Today's Due Invoices"),
                    // Obx(
                    //   () => defaultController.isLoadingDashboardData.value
                    //       ? CircularProgressIndicator()
                    //       : AnalyticsDashboard(
                    //           purchaseData: defaultController.purchaseDataList,
                    //         ),
                    // ),

                    // const SizedBox(height: 20),
                    // // Pending Memos
                    // _buildSectionTitle('Pending Memos'),
                    // _buildCard(
                    //   child: Column(
                    //     children: [
                    //       _buildDataRow('Memo #101', 'Pending', '₹50,000'),
                    //       _buildDataRow('Memo #102', 'Pending', '₹75,000'),
                    //       _buildDataRow('Memo #103', 'Pending', '₹30,000'),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(height: 20),

                    // Current Stock
                    // _buildSectionTitle('Current Stock'),
                    // _buildCard(
                    //   // title: 'Stock Overview',
                    //   child: _buildDonutChart(data: [40, 30, 20, 10]),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  // Widget _buildSectionTitle(String title) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Text(
  //       title,
  //       style: const TextStyle(
  //         fontSize: 18,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildCard({String? title, required Widget child}) {
  //   return Card(
  //     elevation: 4,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           if (title != null)
  //             Padding(
  //               padding: const EdgeInsets.only(bottom: 8.0),
  //               child: Text(
  //                 title,
  //                 style: const TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //             ),
  //           child,
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildShimmerEffect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      // Adjust spacing between shimmer blocks
      children: List.generate(6, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            // Adjust horizontal spacing
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildIndicator({
    required Color color,
    required String label,
    required int value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart({
    required List<int> data,
    required Color barColor,
    required String label,
  }) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          barGroups: data.asMap().entries.map((entry) {
            int index = entry.key;
            int value = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: value.toDouble(),
                  color: barColor,
                  width: 8,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDataRow(String label1, String label2, String label3) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(child: Text(label1)),
          Expanded(child: Text(label2, textAlign: TextAlign.center)),
          Expanded(child: Text(label3, textAlign: TextAlign.end)),
        ],
      ),
    );
  }

  Widget _buildDonutChart({required List<int> data}) {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: data.map((value) {
            final index = data.indexOf(value);
            final colors = [
              Colors.blue,
              Colors.green,
              Colors.orange,
              Colors.red
            ];
            return PieChartSectionData(
              color: colors[index],
              value: value.toDouble(),
              title: '$value%',
              radius: 50,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildUpcomingDuePaymentCard() {
    final today = DateTime.now();
    final List<OutstandingPurchaseSaleDetails> sortedList = defaultController
        .outstandingPurchaseSaleDetailsList
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

    // print("SORTED LIST:${sortedList.length}");

// Filter for today's due payments
    final todayDuePayments = sortedList.where((details) {
      final dueDate = DateTime.parse(details.dueDate!);
      return isSameDate(dueDate, today);
    }).toList();

    // print('TODAYS PAYMENT : ${todayDuePayments.length}');

// Add all outstanding payments (including today's and future ones)
    List<OutstandingPurchaseSaleDetails> displayPayments = sortedList;

    // print('DISPLAY PAYMENT: ${displayPayments.length}');

// If you want to prioritize showing today's due payments first, you can do that here
    displayPayments = [
      // ...todayDuePayments,
      ...sortedList.where((details) {
        final dueDate = DateTime.parse(details.dueDate!);
        return dueDate.isAfter(today);
      }),
    ];

    // print("DISPAY PAYMENT AFETR SORT :${displayPayments.length}");
    // print('FIRST AF SORT DP:${displayPayments.first.invNo}');
    // print("LAST AF SORT DP: ${displayPayments.last.invNo}");

    return _buildCard(
      // title: "Today's Due Payments",
      child: displayPayments.isNotEmpty
          ? _buildDuePaymentsList(displayPayments)
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.payment_outlined,
                    // You can choose another icon like Icons.error or any other
                    size: 50,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "No Upcoming Payments",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "It looks like everything is up to date. Keep up the good work!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      defaultController.getOutstandingPurchaseSaleDetails();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      "Refresh",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildOutstandingPaymentCard() {
    final today = DateTime.now();
    final List<OutstandingPurchaseSaleDetails> sortedList = defaultController
        .outstandingPurchaseSaleDetailsList
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

    // final todayDuePayments = sortedList.where((details) {
    //   final dueDate = DateTime.parse(details.dueDate!);
    //   return isSameDate(dueDate, today);
    // }).toList();
    // final todayDuePayments = sortedList.where((details) {
    //   final dueDate = DateTime.parse(details.dueDate!);
    //   return isSameDate(dueDate, today);
    // }).toList();

    final overduePayments = sortedList.where((details) {
      final dueDate = DateTime.parse(details.dueDate!);
      return dueDate.isBefore(today) &&
          !isSameDate(dueDate, today); // Include only overdue payments
    }).toList();

    // final futurePayments = sortedList.where((details) {
    //   final dueDate = DateTime.parse(details.dueDate!);
    //   return dueDate.isAfter(today);
    // }).toList();

    List<OutstandingPurchaseSaleDetails> displayPayments = sortedList;

    displayPayments = [
      ...overduePayments, // Add overdue payments first
      // ...todayDuePayments, // Then today's due payments
      // ...futurePayments,  // Then future payments
    ];

    // displayPayments = [
    //   ...todayDuePayments,
    //   ...sortedList.where((details) {
    //     final dueDate = DateTime.parse(details.dueDate!);
    //     return dueDate.isBefore(today);
    //   }),
    // ];

    return _buildCard(
      // title: "Today's Due Payments",
      child: displayPayments.isNotEmpty
          ? _buildDuePaymentsList(displayPayments)
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    // You can choose another icon like Icons.error or any other
                    size: 50,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "No Outstanding Payments",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "It looks like everything is up to date. Keep up the good work!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      defaultController.getOutstandingPurchaseSaleDetails();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      "Refresh",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTodayPaymentCard() {
    final today = DateTime.now();
    final List<OutstandingPurchaseSaleDetails> sortedList = defaultController
        .outstandingPurchaseSaleDetailsList
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

    // final todayDuePayments = sortedList.where((details) {
    //   final dueDate = DateTime.parse(details.dueDate!);
    //   return isSameDate(dueDate, today);
    // }).toList();
    final todayDuePayments = sortedList.where((details) {
      final dueDate = DateTime.parse(details.dueDate!);
      return isSameDate(dueDate, today);
    }).toList();

    // final overduePayments = sortedList.where((details) {
    //   final dueDate = DateTime.parse(details.dueDate!);
    //   return dueDate.isBefore(today) && !isSameDate(dueDate, today); // Include only overdue payments
    // }).toList();

    // final futurePayments = sortedList.where((details) {
    //   final dueDate = DateTime.parse(details.dueDate!);
    //   return dueDate.isAfter(today);
    // }).toList();

    List<OutstandingPurchaseSaleDetails> displayPayments = sortedList;

    displayPayments = [
      // ...overduePayments, // Add overdue payments first
      ...todayDuePayments, // Then today's due payments
      // ...futurePayments,  // Then future payments
    ];

    // displayPayments = [
    //   ...todayDuePayments,
    //   ...sortedList.where((details) {
    //     final dueDate = DateTime.parse(details.dueDate!);
    //     return dueDate.isBefore(today);
    //   }),
    // ];

    return _buildCard(
      // title: "Today's Due Payments",
      child: displayPayments.isNotEmpty
          ? _buildDuePaymentsList(displayPayments)
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.payment_outlined,
                    // You can choose another icon like Icons.error or any other
                    size: 50,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "No Today's Payments",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "It looks like everything is up to date. Keep up the good work!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      defaultController.getOutstandingPurchaseSaleDetails();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      "Refresh",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTotalPurchaseSaleOutstandingCard(bool isSale) {
    final today = DateTime.now();

    // Calculate outstanding amounts for purchase and sale
    final List<OutstandingPurchaseSaleDetails> purchaseList = defaultController
        .outstandingPurchaseSaleDetailsList
        .where((e) => e.trnType == 'Purchase')
        .toList();
    // final double totalInvAmtPur =
    //     purchaseList.fold(0.0, (sum, item) => sum + (item.amtRs ?? 0.0));
    final double totalOutAmtPur =
        purchaseList.fold(0.0, (sum, item) => sum + (item.bAmtRs ?? 0.0));
    // final double totalOutstandingPur = totalInvAmtPur - totalOutAmtPur;

    final List<OutstandingPurchaseSaleDetails> saleList = defaultController
        .outstandingPurchaseSaleDetailsList
        .where((e) => e.trnType == 'Sale')
        .toList();
    // final double totalInvAmtSale =
    //     saleList.fold(0.0, (sum, item) => sum + (item.amtRs ?? 0.0));
    final double totalOutAmtSale =
        saleList.fold(0.0, (sum, item) => sum + (item.bAmtRs ?? 0.0));
    // final double totalOutstandingSale = totalInvAmtSale - totalOutAmtSale;

    // Build the card
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSale
                ? [Colors.purple[50]!, Colors.purple[100]!]
                : [Colors.orange[50]!, Colors.orange[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSale ? Icons.sell : Icons.shopping_bag,
                  color: isSale ? Colors.purple : Colors.orange,
                  size: 22,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  isSale ? 'Sale Outstanding' : 'Purchase Outstanding',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isSale ? Colors.purple : Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              isSale
                  ? '₹ ${totalOutAmtSale.toStringAsFixed(2)}'
                  : '₹ ${totalOutAmtPur.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            // const SizedBox(height: 10),
            // Text(
            //   isSale
            //       ? 'As of ${DateFormat('dd MMM yyyy').format(today)}'
            //       : 'Updated on ${DateFormat('dd MMM yyyy').format(today)}',
            //   style: TextStyle(
            //     fontSize: 14,
            //     color: Colors.black54,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCashBankOutstandingCard(bool isSale) {
    final today = DateTime.now();

    // Filter and map transactions
    final List<Widget> cards = defaultController.partyMstList
        .where((partyType) =>
            partyType.typeCode == 3 ||
            partyType.typeCode == 4 &&
                partyType.companyCode == defaultController.companyCode.value)
        .map((partyType) {
      var partyTransactions = defaultController.creditDebitDataList
          .where((cd) => cd.partyCode == partyType.partyCode)
          .toList();

      double sumCredit = partyTransactions.fold(
          0.0, (previousValue, cd) => previousValue + (cd.creditRs ?? 0));
      double sumDebit = partyTransactions.fold(
          0.0, (previousValue, cd) => previousValue + (cd.debitRs ?? 0));

      double balance = (sumCredit - sumDebit) +
          ((partyType.creditOpBalRs ?? 0) - (partyType.debitOpBalRs ?? 0));

      IconData iconData = getPartyTypeIcon(partyType.typeCode!);

      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          width: 250,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: partyType.typeCode == 3
                  ? [Colors.blue[50]!, Colors.blue[100]!]
                  : [Colors.teal[50]!, Colors.teal[100]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: partyType.typeCode == 3
                              ? Colors.blue
                              : Colors.teal),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          iconData,
                          color: partyType.typeCode == 3
                              ? Colors.blue
                              : Colors.teal,
                          size: 14,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          getPartyType(partyType.typeCode),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: partyType.typeCode == 3
                                  ? Colors.blue
                                  : Colors.teal),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    getPartyName(partyType.partyCode),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color:
                          partyType.typeCode == 3 ? Colors.blue : Colors.teal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '₹${balance.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              // const SizedBox(height: 10),
              // Center(
              //   child: Text(
              //     isSale
              //         ? 'As of ${DateFormat('dd MMM yyyy').format(today)}'
              //         : 'Updated on ${DateFormat('dd MMM yyyy').format(today)}',
              //     style: const TextStyle(
              //       fontSize: 14,
              //       color: Colors.black54,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      );
    }).toList();

    // Return a column or placeholder if no data
    return cards.isNotEmpty
        ? Row(
            children: cards,
          )
        : /*const Center(
            child: Text(
              'No Account Details Available',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )*/
        const SizedBox.shrink();
  }

  Widget _buildDuePaymentsList(List<OutstandingPurchaseSaleDetails> payments) {
    if (payments.isEmpty) {
      return const Center(
        child: Text(
          'No due payments available.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      height: 150, // Adjust the height as needed
      child: HorizontalListWithArrows(payments: payments),
    );
  }

  Widget _buildCard({required Widget child}) {
    return child;
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }
}
