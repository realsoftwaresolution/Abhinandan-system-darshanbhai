// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
// import 'package:real_web_rough_entry_system/memo%20issue/memoiss_form_screen.dart';
// import 'package:real_web_rough_entry_system/memo%20receive/memorec_form_screen.dart';
// import 'package:real_web_rough_entry_system/party/party_form_screen.dart';
// import 'package:real_web_rough_entry_system/payment/payment_form_screen.dart';
// import 'package:real_web_rough_entry_system/purchase/purchase_form_screen.dart';
// import 'package:real_web_rough_entry_system/sale/sale_form_screen.dart';
// import 'package:real_web_rough_entry_system/tab-view-dashboard/tab_item.dart';
//
// import 'common/widgets.dart';
// import 'header.dart';
//
// class TabBarActionsScreen extends StatelessWidget {
//   final TabControllerX mainTabController = Get.put(TabControllerX());
//   final TabControllerX subTabController = Get.put(TabControllerX(), tag: 'subTabs');
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3, // Main tabs: Master, Transaction, Payment
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Tab-based Actions'),
//           bottom: TabBar(
//             controller: mainTabController,
//             tabs: const [
//               Tab(text: 'Master', icon: Icon(Icons.apps)),
//               Tab(text: 'Transaction', icon: Icon(Icons.swap_horiz)),
//               Tab(text: 'Payment', icon: Icon(Icons.attach_money)),
//             ],
//             onTap: (index) {
//               subTabController.clearTabs(); // Clear sub-tabs when switching main tabs
//               switch (index) {
//                 case 0: // Master
//                   _populateMasterTabs();
//                   break;
//                 case 1: // Transaction
//                   _populateTransactionTabs();
//                   break;
//                 case 2: // Payment
//                   _populatePaymentTabs();
//                   break;
//               }
//             },
//           ),
//           actions: [
//             const SizedBox(width: 150, child: SearchField()),
//             Obx(
//                   () => IconButton(
//                 icon: const Icon(Icons.account_circle_rounded),
//                 tooltip: getCompanyName(
//                     Get.find<DefaultController>().companyCode.value),
//                 onPressed: () {
//                   _showAccountMenu(context);
//                 },
//               ),
//             ),
//           ],
//         ),
//         body: Column(
//           children: [
//             // Sub-tabs for detailed navigation
//             Obx(
//                   () => TabBar(
//                 controller: subTabController.tabController,
//                 tabs: subTabController.tabs
//                     .map((tab) => Tab(text: tab.label, icon: tab.icon))
//                     .toList(),
//               ),
//             ),
//             Expanded(
//               child: Obx(
//                     () => TabBarView(
//                   controller: subTabController.tabController,
//                   children: subTabController.tabs
//                       .map((tab) => tab.view)
//                       .toList(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _populateMasterTabs() {
//     subTabController.addTab(TabItem(
//       view: const PartyFormScreen(showHeader: false),
//       label: 'Party',
//       icon: const Icon(Icons.people_alt_sharp),
//     ));
//     subTabController.addTab(TabItem(
//       view: const PurchaseFormScreen(showHeader: false),
//       label: 'Purchase',
//       icon: const Icon(Icons.shopping_bag),
//     ));
//     subTabController.addTab(TabItem(
//       view: const SaleFormScreen(showHeader: false),
//       label: 'Sale',
//       icon: const Icon(Icons.sell),
//     ));
//   }
//
//   void _populateTransactionTabs() {
//     subTabController.addTab(TabItem(
//       view: const MemoIssFormScreen(showHeader: false),
//       label: 'Memo Issue',
//       icon: const Icon(Icons.checklist_sharp),
//     ));
//     subTabController.addTab(TabItem(
//       view: const MemoRecFormScreen(showHeader: false),
//       label: 'Memo Receive',
//       icon: const Icon(Icons.checklist_rtl_sharp),
//     ));
//   }
//
//   void _populatePaymentTabs() {
//     subTabController.addTab(TabItem(
//       view: const ExpenseFormScreen(showHeader: false),
//       label: 'Expense',
//       icon: const Icon(Icons.payment),
//     ));
//     subTabController.addTab(TabItem(
//       view: const PaymentFormScreen(showHeader: false),
//       label: 'Payment',
//       icon: const Icon(Icons.payment),
//     ));
//   }
// }
