import 'package:flutter/material.dart';
import 'package:real_web_rough_entry_system/purchase/outstanding_purchase_details.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../common/widgets.dart';

class HorizontalListWithArrows extends StatefulWidget {
  final List<OutstandingPurchaseSaleDetails> payments;

  const HorizontalListWithArrows({super.key, required this.payments});

  @override
  State<HorizontalListWithArrows> createState() =>
      _HorizontalListWithArrowsState();
}

class _HorizontalListWithArrowsState extends State<HorizontalListWithArrows> {
  final ScrollController _scrollController = ScrollController();
  bool showLeftArrow = false;
  bool showRightArrow = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateArrowVisibility);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateArrowVisibility);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateArrowVisibility() {
    setState(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;

      showLeftArrow = currentScroll > 0;
      showRightArrow = currentScroll < maxScroll;
    });
  }

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 300, // Scroll by 200 pixels to the left
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 300, // Scroll by 200 pixels to the right
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // @override
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.separated(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          // Enable horizontal scrolling
          itemCount: widget.payments.length,
          // padding: const EdgeInsets.all(8.0),
          separatorBuilder: (context, index) => const SizedBox(width: 10),
          // Horizontal separator with 5 pixels width
          itemBuilder: (context, index) {
            final payment = widget.payments[index];
            final isHighlighted =
                isSameDate(DateTime.parse(payment.dueDate!), DateTime.now());
            final isSale = payment.trnType == 'Sale';
            final isOverdue =
                DateTime.parse(payment.dueDate!).isBefore(DateTime.now());
            return GestureDetector(
              onTap: () => isSale
                  ? showSaleInvoiceDetails(
                      context,
                      payment,
                      defaultController.polishSaleList,
                      defaultController.saleDetailsList,
                      isHighlighted,
                      isSale,
                      isOverdue)
                  : showPurchaseInvoiceDetails(
                      context,
                      payment,
                      defaultController.purchaseDataList,
                      defaultController.roughDetailsModel,
                      isHighlighted,
                      isSale,
                      isOverdue),
              child: Container(
                width: 300,
                // Set the width for each list item (card)
                // margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: isHighlighted
                      ? isSale
                          ? Colors.purple[50]
                          : Colors.yellow[50]
                      : isOverdue
                          ? Colors.red[50]
                          : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isHighlighted
                        ? isSale
                            ? Colors.purpleAccent
                            : Colors.orangeAccent
                        : isOverdue
                            ? Colors.transparent
                            : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Icon(
                          isHighlighted
                              ? Icons.warning_amber_rounded
                              : isOverdue
                                  ? Icons.error_outline_rounded
                                  : Icons.receipt_long_rounded,
                          color: isHighlighted
                              ? isSale
                                  ? Colors.purpleAccent
                                  : Colors.orangeAccent
                              : isOverdue
                                  ? Colors.redAccent
                                  : Colors.grey[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            payment.invNo!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '₹${payment.bAmtRs!.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isHighlighted || isOverdue
                                ? Colors.redAccent
                                : Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(Icons.person, size: 16, color: Colors.blue[600]),
                        const SizedBox(width: 4),
                        Text(
                          payment.partyName!.toUpperCase(),
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                              color: isHighlighted
                                  ? isSale
                                      ? Colors.purple[600]
                                      : Colors.orange[600]
                                  : isOverdue
                                      ? Colors.white70
                                      : Colors.grey[100]),
                          child: Row(
                            children: [
                              Icon(isSale ? Icons.sell : Icons.shopping_bag,
                                  size: 18,
                                  color: isHighlighted
                                      ? Colors.white
                                      : isSale
                                          ? Colors.purple[600]
                                          : Colors.orange[600]),
                              const SizedBox(width: 4),
                              Text(
                                payment.trnType ?? "N/A",
                                style: TextStyle(
                                    color: isHighlighted
                                        ? Colors.white
                                        : Colors.grey[600],
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined,
                                size: 14, color: Colors.green[600]),
                            const SizedBox(width: 4),
                            Text(
                              getDueStatusText(payment.dueDate!),
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        if (showRightArrow)
          Align(
            alignment: Alignment.centerRight,
            child: Material(
              shape: const CircleBorder(),
              elevation: 4, // Set the elevation for the shadow effect
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.white,
                // Optional: Set the background color
                child: GestureDetector(
                  onTap: _scrollRight,
                  child: const Icon(
                    Icons.keyboard_arrow_right,
                    size: 15,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        if (showLeftArrow)
          Align(
            alignment: Alignment.centerLeft,
            child: Material(
              shape: const CircleBorder(),
              elevation: 4, // Set the elevation for the shadow effect
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.white,
                // Optional: Set the background color
                child: GestureDetector(
                  onTap: _scrollLeft,
                  child: const Icon(
                    Icons.keyboard_arrow_left,
                    size: 15,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
