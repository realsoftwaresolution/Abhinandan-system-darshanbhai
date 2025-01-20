import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/header.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memoiss_form_screen.dart';
import 'package:real_web_rough_entry_system/memo%20receive/memorec_form_screen.dart';
import 'package:real_web_rough_entry_system/party-ledger/party_ledger_form_screen.dart';
import 'package:real_web_rough_entry_system/party/party_form_screen.dart';
import 'package:real_web_rough_entry_system/payment/payment_form_screen.dart';
import 'package:real_web_rough_entry_system/purchase/purchase_form_screen.dart';
import 'package:real_web_rough_entry_system/report/report_screen.dart';
import 'package:real_web_rough_entry_system/responsive.dart';
import 'package:real_web_rough_entry_system/sale/sale_form_screen.dart';
import 'package:real_web_rough_entry_system/tab-view-dashboard/advanced_dashboard.dart';
import 'package:real_web_rough_entry_system/tab-view-dashboard/tab_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardWithDynamicTabs extends StatelessWidget {
  const DashboardWithDynamicTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Row(
            children: [
              !Responsive.isMobile(context)
                  ? SvgPicture.asset(
                      "assets/images/logo.svg",
                      height: 30, // Reduced logo size to fit smaller header
                    )
                  : const SizedBox.shrink(),
              const SizedBox(
                width: 10,
              ),
              !Responsive.isMobile(context)
                  ? Obx(
                      () => Text(
                        getCompanyName(defaultController.companyCode.value),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          backgroundColor: Colors.white,
          actions: [
            // Dynamic buttons to add new tabs
            IconButton(
              icon: const Icon(Icons.people_alt_sharp),
              tooltip: 'Party',
              onPressed: () {
                tabController.isReportForm.value = false;

                // Example: Add a new Party view tab
                tabController.addTab(TabItem(
                    view: const PartyFormScreen(
                      showHeader: false,
                    ),
                    label: 'Party',
                    icon: const Icon(Icons.people_alt_sharp)));
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_bag),
              tooltip: 'Purchase',
              onPressed: () {
                tabController.isReportForm.value = false;

                // Example: Add a new Purchase view tab
                tabController.addTab(TabItem(
                    view: const PurchaseFormScreen(
                      showHeader: false,
                    ),
                    label: 'Purchase',
                    icon: const Icon(Icons.shopping_bag)));
              },
            ),
            IconButton(
              icon: const Icon(Icons.sell),
              tooltip: 'Sale',
              onPressed: () {
                tabController.isReportForm.value = false;

                // Example: Add a new Purchase view tab
                tabController.addTab(TabItem(
                    view: const SaleFormScreen(
                      showHeader: false,
                    ),
                    label: 'Sale',
                    icon: const Icon(Icons.sell)));
              },
            ),
            IconButton(
              icon: const Icon(Icons.checklist_sharp),
              tooltip: 'Memo Issue',
              onPressed: () {
                tabController.isReportForm.value = false;

                // Example: Add a new Purchase view tab
                tabController.addTab(TabItem(
                    view: const MemoIssFormScreen(showHeader: false),
                    label: 'Memo Issue',
                    icon: const Icon(Icons.checklist_sharp)));
              },
            ),
            IconButton(
              icon: const Icon(Icons.checklist_rtl_sharp),
              tooltip: 'Memo Receive',
              onPressed: () {
                tabController.isReportForm.value = false;

                // Example: Add a new Purchase view tab
                tabController.addTab(TabItem(
                    view: const MemoRecFormScreen(showHeader: false),
                    label: 'Memo Receive',
                    icon: const Icon(Icons.checklist_rtl_sharp)));
              },
            ),
            // IconButton(
            //   icon: const Icon(Icons.list_alt),
            //   tooltip: 'Expense',
            //   onPressed: () {
            //     tabController.isReportForm.value = false;
            //
            //     // Example: Add a new Purchase view tab
            //     tabController.addTab(TabItem(
            //         view: const ExpenseFormScreen(showHeader: false),
            //         label: 'Expense',
            //         icon: const Icon(Icons.payment)));
            //   },
            // ),
            IconButton(
              icon: const Icon(Icons.payment),
              tooltip: 'Payment',
              onPressed: () {
                tabController.isReportForm.value = false;

                // Example: Add a new Purchase view tab
                tabController.addTab(TabItem(
                    view: const PaymentFormScreen(showHeader: false),
                    label: 'Payment',
                    icon: const Icon(Icons.payment)));
              },
            ),
            IconButton(
              icon: const Icon(Icons.receipt_long),
              tooltip: 'Reports',
              onPressed: () {
                tabController.isReportForm.value = true;
                // Example: Add a new Purchase view tab
                // tabController.addTab(TabItem(
                //     view: const ReportScreen(showHeader: false),
                //     label: 'Reports',
                //     icon: const Icon(Icons.file_copy_outlined)));
              },
            ),
            // if (!Responsive.isMobile(context))
            //   Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
            // // const Expanded(child: SearchField()),
            const SizedBox(width: 150, child: SearchField()),
            Obx(
              () => IconButton(
                icon: const Icon(Icons.account_circle_rounded),
                tooltip: getCompanyName(defaultController.companyCode.value),
                onPressed: () {
                  _showAccountMenu(context);
                },
              ),
            ),
          ],
          // bottom: const PreferredSize(
          //     preferredSize: Size.fromHeight(kToolbarHeight * 1.2),
          //     child: Padding(
          //       padding: EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
          //     )),
          bottom: tabController.isReportForm.value
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight * 1.2),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, bottom: 8.0, right: 8.0),
                child: Row(children: [
                  GestureDetector(
                    onTap: () {
                      // Example: Add a new Purchase view tab
                      // tabController.addTab(TabItem(
                      //     view: const PartyLedgerFormScreen(showHeader: false),
                      //     label: ' Party\nLedger',
                      //     icon: const Icon(Icons.account_balance)));
                      tabController.addTab(TabItem(
                          view: const ReportScreen(showHeader: false),
                          label: 'Reports',
                          icon: const Icon(Icons.file_copy_outlined)));
                      // tabController.isPArtyLedgerForm.value = false;
                      // tabController.isReportForm.value = true;
                    },
                    // style: OutlinedButton.styleFrom(
                    //   // backgroundColor: Colors.grey,
                    //   // minimumSize: const Size(50, 70),
                    //   padding: const EdgeInsets.symmetric(vertical: 8),
                    // ),
                    child: Container(
                      // width: 50,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8),
                        // border: Border.all()
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.receipt_long, // Choose an icon
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Report',
                            // maxLines: 1,
                            textAlign: TextAlign.justify,
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // tabController.isReportForm.value = false;
                      // tabController.isPArtyLedgerForm.value = true;
                      tabController.addTab(TabItem(
                          view: const PartyLedgerFormScreen(
                              showHeader: false),
                          label: 'Party Ledger',
                          icon: const Icon(Icons.account_balance)));

                      // Example: Add a new Purchase view tab
                      // tabController.addTab(TabItem(
                      //     view: const PartyLedgerFormScreen(showHeader: false),
                      //     label: ' Party\nLedger',
                      //     icon: const Icon(Icons.account_balance)));
                    },
                    // style: OutlinedButton.styleFrom(
                    //   // backgroundColor: Colors.grey,
                    //   // minimumSize: const Size(50, 70),
                    //   padding: const EdgeInsets.symmetric(vertical: 8),
                    // ),
                    child: Container(
                      // width: 50,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8),
                        // border: Border.all()
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.account_balance, // Choose an icon
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Party Ledger',
                            maxLines: 1,
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  )
                ]
                    // reportList.map((report)=> getBottomAppMenu(onTap: onTap, context: context, label: report, icon: Icons.account_balance)).toList(),
                    ),
              ))
          : null,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return tabController.tabList.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Listener(
                        onPointerSignal: (pointerSignal) {
                          if (pointerSignal is PointerScrollEvent) {
                            scrollController.jumpTo(scrollController.offset +
                                pointerSignal.scrollDelta.dy);
                          }
                        },
                        child: SingleChildScrollView(
                          controller: scrollController,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              tabController.tabList.length,
                              (i) => Obx(
                                () => LongPressDraggable<int>(
                                  data: i,
                                  axis: Axis.horizontal,
                                  onDragStarted: () {
                                    tabController.draggingIndex.value = i;
                                  },
                                  onDraggableCanceled: (_, __) {
                                    tabController.draggingIndex.value = -1;
                                  },
                                  onDragCompleted: () {
                                    tabController.draggingIndex.value = -1;
                                  },
                                  feedback: Material(
                                    color: Colors.transparent,
                                    child: Chip(
                                      avatar: tabController.tabList[i].icon,
                                      // backgroundColor: Colors.grey[100],
                                      // Highlight while dragging
                                      label: Text(
                                        tabController.tabList[i].label,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10),
                                        ),
                                      ),
                                      side: BorderSide(
                                        color:
                                            tabController.currentIndex.value ==
                                                    i
                                                ? Colors.grey[300]!
                                                : Colors.grey[300]!,
                                      ),
                                      deleteIcon: const Icon(Icons.close),
                                      deleteButtonTooltipMessage: 'Close Tab',
                                      // onDeleted: () {
                                      //   tabController.removeTab(i);
                                      // },
                                      onDeleted: () {
                                        if (tabController.currentIndex.value ==
                                            i) {
                                          tabController.removeTab(i);
                                        } else {
                                          infoDialog(
                                              messageText:
                                                  'You can only remove the currently selected tab.');
                                        }
                                      },
                                    ),
                                  ),
                                  // childWhenDragging: Chip(
                                  //   avatar: tabController.tabList[i].icon,
                                  //   backgroundColor: Colors.grey[100],
                                  //   // Highlight while dragging
                                  //   label: Text(
                                  //     tabController.tabList[i].label,
                                  //     style: const TextStyle(color: Colors.white),
                                  //   ),
                                  // ),
                                  // Placeholder while dragging
                                  child: DragTarget<int>(
                                    onWillAcceptWithDetails: (oldIndex) => true,
                                    onAcceptWithDetails: (fromIndex) {
                                      tabController.moveTab(fromIndex.data,
                                          i); // Move the tab when dropped
                                    },
                                    builder:
                                        (context, candidateData, rejectedData) {
                                      return Obx(() {
                                        // Determine the offset for the current item based on draggingIndex
                                        // double offset = 0.0;
                                        //
                                        // // If dragging, determine the offset for this chip
                                        // if (tabController.draggingIndex.value != -1) {
                                        //   // Calculate the offset for the dragged item
                                        //   if (tabController.draggingIndex.value == i) {
                                        //     offset = 0.0; // No offset when it's the current chip being dragged
                                        //   } else if (tabController.draggingIndex.value == i + 1) {
                                        //     offset = 50.0; // Adjust for next item
                                        //   } else if (tabController.draggingIndex.value == i - 1) {
                                        //     offset = -50.0; // Adjust for previous item
                                        //   } else if (tabController.draggingIndex.value > i) {
                                        //     // Adjust the offset for items before the dragged item
                                        //     offset = -50.0; // Move left when dragging from the right
                                        //   } else {
                                        //     // Adjust the offset for items after the dragged item
                                        //     offset = 50.0; // Move right when dragging from the left
                                        //   }
                                        // }
                                        return ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                            top: Radius.circular(10),
                                          ),
                                          child: AnimatedContainer(
                                            // transform: Matrix4.translationValues(offset, 0, 0),
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: GestureDetector(
                                              onTap: () {
                                                tabController
                                                    .currentIndex.value = i;
                                                tabController.update();
                                              },
                                              onPanUpdate: (details) {
                                                // Determine drag direction and update draggingIndex accordingly
                                                if (details.delta.dx > 0) {
                                                  // Dragging right
                                                  tabController.draggingIndex
                                                      .value = (i >
                                                          0)
                                                      ? i - 1
                                                      : i; // Ensure not going out of bounds
                                                } else if (details.delta.dx <
                                                    0) {
                                                  // Dragging left
                                                  tabController.draggingIndex
                                                      .value = (i <
                                                          tabController.tabList
                                                                  .length -
                                                              1)
                                                      ? i + 1
                                                      : i; // Ensure not going out of bounds
                                                }
                                              },
                                              onPanEnd: (details) {
                                                // Reset draggingIndex to -1 when the drag ends
                                                if (tabController
                                                        .draggingIndex.value !=
                                                    i) {
                                                  // Reset position if moved away
                                                  tabController.moveTab(
                                                      i,
                                                      tabController
                                                          .draggingIndex.value);
                                                }
                                                tabController
                                                        .draggingIndex.value =
                                                    -1; // Reset dragging index
                                              },
                                              child: ColorFiltered(
                                                colorFilter: tabController
                                                                .draggingIndex
                                                                .value !=
                                                            -1 &&
                                                        tabController
                                                                .draggingIndex
                                                                .value !=
                                                            i
                                                    ? ColorFilter.mode(
                                                        Colors.grey[300]!,
                                                        BlendMode.saturation,
                                                      )
                                                    : const ColorFilter.mode(
                                                        Colors.transparent,
                                                        BlendMode.multiply,
                                                      ),
                                                child: Chip(
                                                    avatar: tabController
                                                        .tabList[i].icon,
                                                    backgroundColor:
                                                        tabController
                                                                    .currentIndex
                                                                    .value ==
                                                                i
                                                            ? Colors.grey[300]
                                                            : Colors.white,
                                                    label: Text(
                                                      tabController
                                                          .tabList[i].label,
                                                      style: TextStyle(
                                                          fontWeight: tabController
                                                                      .currentIndex
                                                                      .value ==
                                                                  i
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal,
                                                          color: tabController
                                                                      .currentIndex
                                                                      .value ==
                                                                  i
                                                              ? Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                              : Colors.black),
                                                    ),
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                        top:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    side: BorderSide(
                                                      color: tabController
                                                                  .currentIndex
                                                                  .value ==
                                                              i
                                                          ? Colors.grey[300]!
                                                          : Colors.grey[300]!,
                                                    ),
                                                    deleteIcon:
                                                        const Icon(Icons.close),
                                                    deleteButtonTooltipMessage:
                                                        'Close Tab',
                                                    // onDeleted: () {
                                                    //   tabController.removeTab(i);
                                                    // },
                                                    onDeleted: () {
                                                      if (tabController
                                                              .currentIndex
                                                              .value ==
                                                          i) {
                                                        tabController
                                                            .removeTab(i);
                                                      } else {
                                                        infoDialog(
                                                            messageText:
                                                                'You can only remove the currently selected tab.');
                                                      }
                                                    }),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            }),
            Expanded(
              child: Obx(() {
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey[300]!, // Color of the top border
                        width: 1, // Width of the top border
                      ),
                      // Other borders are implicitly none
                    ),
                    // border: Border.all(
                    //     color: Colors.grey[300]!, // Color of the top border
                    //     width:1, // Width of the top border
                    //   ),
                    // Other borders can be left uninitialized (implicitly none)
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: tabController.tabList.isNotEmpty
                              ? IndexedStack(
                                  index: tabController.currentIndex.value,
                                  children: tabController.tabList
                                      .map((tab) => tab.view)
                                      .toList(),
                                )
                              : !defaultController.enabledAdvancedDashboard.value ?  Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/logo.svg",
                                        // ignore: deprecated_member_use
                                        color: Colors.grey[200],
                                        height:
                                            200, // Reduced logo size to fit smaller header
                                      ),
                                      Text(
                                        'Real Software Solutions',
                                        style: TextStyle(
                                            color: Colors.grey[200]!,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ) : const AdvancedDashboard(),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          // Set the margin around the container
                          decoration: const BoxDecoration(
                            color:
                                Colors.black45, // Fill color// Rounded corners
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            // Padding inside the container
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.person,
                                        color: Colors.white),
                                    const SizedBox(width: 4),
                                    // Add some spacing
                                    FutureBuilder<String?>(
                                      future: getUsername(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Text(
                                            'Loading...',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          );
                                        } else if (snapshot.hasError) {
                                          return const Text(
                                            'Error',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                            ),
                                          );
                                        } else if (snapshot.hasData) {
                                          return Text(
                                            snapshot.data ?? 'Unknown User',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          );
                                        } else {
                                          return const Text(
                                            'No Username Found',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.storage,
                                        color: Colors.white),
                                    const SizedBox(width: 4),
                                    // Add some spacing
                                    Text(
                                      defaultController.baseUrl
                                          .split('//')
                                          .last
                                          .split('/')
                                          .first,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                // Obx(
                                //   () => Row(
                                //     children: [
                                //       const Icon(Icons.computer,
                                //           color: Colors.white),
                                //       const SizedBox(width: 4),
                                //       // Add some spacing
                                //       Text(
                                //         defaultController.deviceInfo.value,
                                //         style: const TextStyle(
                                //           color: Colors.white,
                                //           fontSize: 12,
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_month,
                                        color: Colors.white),
                                    const SizedBox(width: 4),
                                    // Add some spacing
                                    Text(
                                      DateFormat('dd-MM-yyyy')
                                          .format(DateTime.now()),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time,
                                        color: Colors.white),
                                    const SizedBox(width: 4),
                                    // Add some spacing
                                    StreamBuilder(
                                      stream: Stream.periodic(
                                          const Duration(seconds: 1)),
                                      builder: (context, snapshot) {
                                        return Text(
                                          DateFormat('hh:mm:ss a')
                                              .format(DateTime.now()),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileOptionsDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), // Rounded corners for the dialog
        ),
        contentPadding: const EdgeInsets.all(20), // Padding around content
        content: SizedBox(
          height: 200, // Adjusted height for better content spacing
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
            children: [
              // Profile Header
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent, // Header background color
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26, // Shadow for the header
                      blurRadius: 5,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Company Name
                      Text(
                        getCompanyName(defaultController.companyCode.value),
                        style: const TextStyle(
                          color: Colors.white, // Text color in header
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Company Mobile Number
                      Text(
                        getCompanyDetails(defaultController.companyCode.value)
                            .mobileno!,
                        style: const TextStyle(
                          color: Colors.white, // Text color in header
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15), // Spacing between header and details
              // Company Address
              SizedBox(
                width: double.infinity,
                child: Text(
                  getCompanyDetails(defaultController.companyCode.value)
                      .address!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis, // Ensure text doesn't overflow
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700], // Text color for address
                  ),
                ),
              ),
              // const SizedBox(height: 20), // Spacing between address and button
              // const Divider(color: Colors.grey), // Divider for separation
              // const SizedBox(height: 10),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            // style: OutlinedButton.styleFrom(
            //   side: const BorderSide(color: Colors.blueAccent), // Border color
            //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(10), // Rounded corners for button
            //   ),
            // ),
            onPressed: () {
              if (tabController.tabList.isEmpty) {
                _logout();
                Get.back(); // Close dialog on logout
              } else {
                infoDialog(messageText: 'Please Close Inner Form.');
              }
            },
            child: const Text(
              "Logout",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent, // Button text color
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed('/'); // Redirect to your login screen
  }

  void _showAccountMenu(BuildContext context) async {
    await showMenu(
      context: context,
      color: Colors.white,
      shadowColor: Colors.grey,
      // position: position,
      position: const RelativeRect.fromLTRB(10, 50, 0, 0),
      /*position: RelativeRect.fromLTRB(
        position.dx, // The x position of the button
        position.dy + buttonSize.height, // The y position just below the button
        overlaySize.width - position.dx - buttonSize.width, // Right position
        0, // Bottom offset
      ),*/
      items: <PopupMenuItem>[
        PopupMenuItem(
          child: ListTile(
            onTap: null,
            leading: const CircleAvatar(
              child: Icon(Icons.store),
            ),
            title: Text(
              getCompanyName(defaultController.companyCode.value),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: Text(
              getCompanyDetails(defaultController.companyCode.value).mobileno!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        // const PopupMenuDivider(),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Switch Company'),
            enabled: false,
            onTap: () {
              Get.back();
              showCompanySelectionDialog(isFromSwitchCompany: true);
              // Handle switch account
              // Navigator.of(context).pop(); // Close the menu after selection
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              _showProfileOptionsDialog(context);
              // Handle profile tap
              // Navigator.of(context).pop(); // Close the menu after selection
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
             showSettingsDialog(context);
              // Handle settings tap
              // Navigator.of(context).pop(); // Close the menu after selection
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: () {
              if (tabController.tabList.isEmpty) {
                _logout();
                Get.back();
              } else {
                infoDialog(messageText: 'Please Close Inner Form.');
              }

              // Handle log out
              // Navigator.of(context).pop(); // Close the menu after selection
            },
          ),
        ),
      ],
    );
  }
}
