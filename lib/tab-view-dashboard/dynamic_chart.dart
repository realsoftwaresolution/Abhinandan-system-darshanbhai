// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';
//
// import 'package:real_web_rough_entry_system/purchase/purchase_details_model.dart';
//
// class DynamicPurchaseChart extends StatefulWidget {
//   final List<PurchaseDetailsModel> purchaseData;
//
//   const DynamicPurchaseChart({
//     Key? key,
//     required this.purchaseData,
//   }) : super(key: key);
//
//   @override
//   _DynamicPurchaseChartState createState() => _DynamicPurchaseChartState();
// }
//
// class _DynamicPurchaseChartState extends State<DynamicPurchaseChart> {
//   String _selectedTimeFrame = 'Today'; // Default timeframe
//   late List<PurchaseDetailsModel> filteredData;
//   late Timer _updateTimer;
//
//   @override
//   void initState() {
//     super.initState();
//     _filterData();
//     _setupLiveUpdates();
//   }
//
//   @override
//   void dispose() {
//     _updateTimer.cancel();
//     super.dispose();
//   }
//
//   // Set up live updates based on the selected timeframe
//   void _setupLiveUpdates() {
//     if (_selectedTimeFrame == 'Today') {
//       _updateTimer = Timer.periodic(const Duration(hours: 1), (_) {
//         _filterData();
//       });
//     }
//   }
//
//   // Handle filtering logic based on the selected timeframe
//   void _filterData() {
//     final now = DateTime.now();
//     setState(() {
//       filteredData = widget.purchaseData.where((item) {
//         final invoiceDate = DateTime.parse(item.sDate!);
//         switch (_selectedTimeFrame) {
//           case 'Today':
//             return invoiceDate.year == now.year && invoiceDate.month == now.month && invoiceDate.day == now.day;
//           case 'Week':
//             final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
//             return invoiceDate.isAfter(startOfWeek) && invoiceDate.isBefore(now.add(const Duration(days: 1)));
//           case 'Month':
//             return invoiceDate.year == now.year && invoiceDate.month == now.month;
//           case 'Year':
//             return invoiceDate.year == now.year;
//           default:
//             return false;
//         }
//       }).toList();
//     });
//   }
//
//   // Group data based on the selected timeframe
//   Map<int, double> _groupDataByTime() {
//     Map<int, double> groupedData = {};
//
//     for (var item in filteredData) {
//       final invoiceDate = DateTime.parse(item.sDate!);
//       int key;
//       double amount = item.totAmtRs!;
//
//       switch (_selectedTimeFrame) {
//         case 'Today':
//           key = invoiceDate.hour;
//           break;
//         case 'Week':
//           key = invoiceDate.weekday;
//           break;
//         case 'Month':
//           key = invoiceDate.day;
//           break;
//         case 'Year':
//           key = invoiceDate.month;
//           break;
//         default:
//           continue;
//       }
//
//       groupedData[key] = (groupedData[key] ?? 0) + amount;
//     }
//
//     return groupedData;
//   }
//
//   // Build LineChart based on the grouped data
//   Widget _buildLineChart() {
//     final groupedData = _groupDataByTime();
//     final spots = groupedData.entries
//         .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
//         .toList();
//
//     return LineChart(
//       LineChartData(
//         lineBarsData: [
//           LineChartBarData(
//             spots: spots,
//             isCurved: true,
//             color: Colors.blue,
//             barWidth: 3,
//             belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
//           ),
//         ],
//         borderData: FlBorderData(show: false),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Dropdown for Timeframe Selection
//         DropdownButton<String>(
//           value: _selectedTimeFrame,
//           items: ['Today', 'Week', 'Month', 'Year']
//               .map((timeframe) => DropdownMenuItem<String>(
//             value: timeframe,
//             child: Text(timeframe),
//           ))
//               .toList(),
//           onChanged: (value) {
//             setState(() {
//               _selectedTimeFrame = value!;
//               _filterData();
//             });
//           },
//         ),
//         const SizedBox(height: 10),
//         // Line Chart
//         SizedBox(
//           height: 300,
//           child: _buildLineChart(),
//         ),
//       ],
//     );
//   }
// }
/*import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/purchase/purchase_details_model.dart';

class AnalyticsDashboard extends StatelessWidget {
  final RxList<PurchaseDetailsModel> purchaseData;

  const AnalyticsDashboard({super.key, required this.purchaseData});

  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
          // Top Section with Total Sales
          Row(
            children: [


              _buildCard(
                title: 'Total Purchase',
                value: '\$852.56',
                change: '+14%',
                color: Colors.green,
                child: _buildPurchaseLineChart(),
              ),
              const SizedBox(width: 16),
              _buildCard(
                title: 'Total Sales',
                value: '\$1,023.77',
                change: '-21%',
                color: Colors.red,
                child: _buildSaleLineChart(),
              ),
              // _buildCard(
              //   title: 'Sales by Channel',
              //   value: '',
              //   change: '',
              //   color: Colors.blue,
              //   child: Column(
              //     children: [
              //       _buildBar('Online Store', 86.6, 480.97, Colors.red),
              //       _buildBar('Subscriptions', 747.52, 808.27, Colors.blue),
              //       _buildBar('Marketplace', 159.66, 200.00, Colors.grey),
              //     ],
              //   ),
              // ),
            ],
          ),
          // const SizedBox(height: 16),
          // // Middle Section with Conversion and Total Orders
          // Row(
          //   children: [
          //     _buildCard(
          //       title: 'Conversion Rate',
          //       value: '1.1%',
          //       change: '-11%',
          //       color: Colors.orange,
          //       child: const Column(
          //         children: [
          //           Text('Added to Cart: 3.85%'),
          //           Text('Reached Checkout: 1.65%'),
          //           Text('Sessions Converted: 1.10%'),
          //         ],
          //       ),
          //     ),
          //     const SizedBox(width: 16),
          //     _buildCard(
          //       title: 'Total Orders',
          //       value: '12',
          //       change: '',
          //       color: Colors.green,
          //       child: _buildMiniChart(),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 16),
          // // Bottom Section with Avg Order Value and Sessions
          // Row(
          //   children: [
          //     _buildCard(
          //       title: 'Avg Order Value',
          //       value: '\$78.85',
          //       change: '-16%',
          //       color: Colors.red,
          //       child: _buildMiniChart(),
          //     ),
          //     const SizedBox(width: 16),
          //     _buildCard(
          //       title: 'Online Store Sessions',
          //       value: '182',
          //       change: '-25%',
          //       color: Colors.orange,
          //       child: _buildMiniChart(),
          //     ),
          //   ],
          // ),
        ],
      );
  }

  // Card Builder for Dashboard Sections
  Widget _buildCard({
    required String title,
    required String value,
    required String change,
    required Color color,
    required Widget child,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color:   Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
            Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  if (change.isNotEmpty)
                    Text(
                      change,
                      style: TextStyle(color: color, fontSize: 16),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }

  // Bar Graph Builder for Sales by Channel
  Widget _buildBar(String label, double value, double maxValue, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label)),
          Expanded(
            flex: 7,
            child: LinearProgressIndicator(
              value: value / maxValue,
              color: color,
              backgroundColor: Colors.grey.shade200,
            ),
          ),
          const SizedBox(width: 8),
          Text('\$${value.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  // Line Chart Placeholder
  Widget _buildPurchaseLineChart() {
    return SizedBox(
      height: 150,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 1),
                const FlSpot(1, 2),
                const FlSpot(2, 1.5),
                const FlSpot(3, 3),
              ],
              isCurved: true,
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.3),
                    Colors.lightBlueAccent.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ],
          gridData: FlGridData(
            show: false,
            drawVerticalLine: true,
            horizontalInterval: 1,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  );
                  return Text(value.toInt().toString(), style: style);
                },
                interval: 1,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  );
                  switch (value.toInt()) {
                    case 0:
                      return const Text('Jan', style: style);
                    case 1:
                      return const Text('Feb', style: style);
                    case 2:
                      return const Text('Mar', style: style);
                    case 3:
                      return const Text('Apr', style: style);
                    default:
                      return const Text('', style: style);
                  }
                },
                interval: 1,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          minX: 0,
          maxX: 3,
          minY: 0,
          maxY: 4,
        ),
      ),
    );
  }
  Widget _buildSaleLineChart() {
    return SizedBox(
      height: 150,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 1),
                const FlSpot(1, 2),
                const FlSpot(2, 1.5),
                const FlSpot(3, 3),
              ],
              isCurved: true,
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.3),
                    Colors.lightBlueAccent.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ],
          gridData: FlGridData(
            show: false,
            drawVerticalLine: true,
            horizontalInterval: 1,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  );
                  return Text(value.toInt().toString(), style: style);
                },
                interval: 1,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  );
                  switch (value.toInt()) {
                    case 0:
                      return const Text('Jan', style: style);
                    case 1:
                      return const Text('Feb', style: style);
                    case 2:
                      return const Text('Mar', style: style);
                    case 3:
                      return const Text('Apr', style: style);
                    default:
                      return const Text('', style: style);
                  }
                },
                interval: 1,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          minX: 0,
          maxX: 3,
          minY: 0,
          maxY: 4,
        ),
      ),
    );
  }


  // Mini Chart Placeholder
  Widget _buildMiniChart() {
    return SizedBox(
      height: 100,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 1),
                const FlSpot(1, 1.2),
                const FlSpot(2, 1.8),
              ],
              isCurved: true,
              color: Colors.green,
              barWidth: 2,
            ),
          ],
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}*/








import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/purchase/purchase_details_model.dart';

class AnalyticsDashboard extends StatefulWidget {
  final RxList<PurchaseDetailsModel> purchaseData;

  const AnalyticsDashboard({super.key, required this.purchaseData});

  @override
  State<AnalyticsDashboard> createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends State<AnalyticsDashboard> {
  @override
  Widget build(BuildContext context) {
    preparePurchaseData();
    return Column(
      children: [
        // Top Section with Total Purchase
        Row(
          children: [
            _buildCard(
              title: 'Total Purchase',
              value: calculateTotalPurchase().toStringAsFixed(2),
              change: '+14%',
              color: Colors.green,
              child: _buildPurchaseLineChart(),
            ),
            const SizedBox(width: 16),
            _buildCard(
              title: 'Total Sales',
              value: calculateTotalSales().toStringAsFixed(2),
              change: '-21%',
              color: Colors.red,
              child: _buildSaleLineChart(),
            ),
          ],
        ),
      ],
    );
  }

  // Calculate total purchase
  double calculateTotalPurchase() {
    return widget.purchaseData.fold<double>(
      0.0,
          (sum, item) => sum + (item.totAmtRs ?? 0),
    );
  }

  // Calculate total sales (example logic, update based on your model)
  double calculateTotalSales() {
    return widget.purchaseData.fold<double>(
      0.0,
          (sum, item) => sum + (item.totAmtRs ?? 0),
    );
  }

  // Prepare line chart data for purchases
  List<FlSpot> preparePurchaseData() {

    if (kDebugMode) {
      print(widget.purchaseData.length);
    }
    // Validate input data
    if (widget.purchaseData.isEmpty) return [];

    // Group and aggregate purchases by month
    final Map<int, double> monthlyData = {};
    for (var item in widget.purchaseData) {
      if (item.sDate != null && item.totAmtRs != null) {
        final date = DateTime.tryParse(item.sDate!);
        if (date != null) {
          final month = date.month;
          monthlyData[month] = (monthlyData[month] ?? 0) + item.totAmtRs!;
        }
      }
    }

    // Fill missing months with zero for seamless data continuity (optional)
    for (int month = 1; month <= 12; month++) {
      monthlyData.putIfAbsent(month, () => 0.0);
    }

    // Ensure data is sorted by month
    final sortedMonthlyData = monthlyData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    if (kDebugMode) {
      print('MONTHLY DATA (Sorted): $sortedMonthlyData');
    }

    // Map to FlSpot for chart
    return sortedMonthlyData
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList();
  }


  // Prepare line chart data for sales
  // List<FlSpot> prepareSalesData() {
  //   // Example logic: Group sales by month and calculate totals
  //   final Map<int, double> monthlyData = {};
  //   for (var item in widget.purchaseData) {
  //     if (item.sDate != null && item.totAmtRs != null) {
  //       final month = DateTime.parse(item.sDate!).month;
  //       monthlyData[month] = (monthlyData[month] ?? 0) + item.totAmtRs!;
  //     }
  //   }
  //   return monthlyData.entries
  //       .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
  //       .toList();
  // }

  Widget _buildPurchaseLineChart() {
    // final data = preparePurchaseData();
    return SizedBox(
      height: 150,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              // spots: data,
              isCurved: true,
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
              ),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withValues(alpha: 0.3),
                    Colors.lightBlueAccent.withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),
          ],
          gridData: const FlGridData(
            show: false,
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) => Text(
                  'M${value.toInt()}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          minX: 1,
          maxX: 12,
          minY: 0,
          // maxY: data.isNotEmpty
          //     ? data.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 10
          //     : 10,
        ),
      ),
    );
  }

  Widget _buildSaleLineChart() {
    final data = preparePurchaseData();
    return SizedBox(
      height: 150,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: data,
              isCurved: true,
              gradient: const LinearGradient(
                colors: [Colors.orange, Colors.redAccent],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.withValues(alpha: 0.3),
                    Colors.redAccent.withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),
          ],
          gridData: const FlGridData(
            show: false,
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) => Text(
                  'M${value.toInt()}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          minX: 1,
          maxX: 12,
          minY: 0,
          maxY: data.isNotEmpty
              ? data.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 10
              : 10,
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String value,
    required String change,
    required Color color,
    required Widget child,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color:   Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
            Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  if (change.isNotEmpty)
                    Text(
                      change,
                      style: TextStyle(color: color, fontSize: 16),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

