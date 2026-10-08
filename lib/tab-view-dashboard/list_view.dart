import 'package:flutter/material.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/purchase/outstanding_purchase_details.dart';
import 'package:real_web_rough_entry_system/tab-view-dashboard/dashboard_payment_card.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateArrowVisibility());
  }

  @override
  void didUpdateWidget(covariant HorizontalListWithArrows oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateArrowVisibility());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateArrowVisibility);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateArrowVisibility() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    final canScrollLeft = currentScroll > 5;
    final canScrollRight = currentScroll < maxScroll - 5;

    if (showLeftArrow != canScrollLeft || showRightArrow != canScrollRight) {
      setState(() {
        showLeftArrow = canScrollLeft;
        showRightArrow = canScrollRight;
      });
    }
  }

  void _scrollLeft() {
    _scrollController.animateTo(
      (_scrollController.offset - 340).clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      (_scrollController.offset + 340).clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.payments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        ListView.separated(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          itemCount: widget.payments.length,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final payment = widget.payments[index];
            final dueDateTime = payment.dueDate != null ? DateTime.tryParse(payment.dueDate!) : null;
            final isHighlighted = dueDateTime != null && _isSameDate(dueDateTime, DateTime.now());
            final isSale = payment.trnType == 'Sale';
            final isOverdue = dueDateTime != null &&
                dueDateTime.isBefore(DateTime.now()) &&
                !isHighlighted;

            return DashboardPaymentCard(
              payment: payment,
              onTap: () => isSale
                  ? showSaleInvoiceDetails(
                      context,
                      payment,
                      defaultController.polishSaleList,
                      defaultController.saleDetailsList,
                      isHighlighted,
                      isSale,
                      isOverdue,
                    )
                  : showPurchaseInvoiceDetails(
                      context,
                      payment,
                      defaultController.purchaseDataList,
                      defaultController.roughDetailsModel,
                      isHighlighted,
                      isSale,
                      isOverdue,
                    ),
            );
          },
        ),

        // Left Navigation Arrow
        if (showLeftArrow)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: _buildArrowButton(
                icon: Icons.chevron_left_rounded,
                onTap: _scrollLeft,
              ),
            ),
          ),

        // Right Navigation Arrow
        if (showRightArrow)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: _buildArrowButton(
                icon: Icons.chevron_right_rounded,
                onTap: _scrollRight,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildArrowButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: Colors.black38,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.borderLight, width: 1),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
      ),
    );
  }
}
