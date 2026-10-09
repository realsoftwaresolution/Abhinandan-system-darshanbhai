import 'package:flutter/material.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/common/utils/currency_formatter.dart';
import 'package:real_web_rough_entry_system/purchase/outstanding_purchase_details.dart';

/// Modern interactive card for Overdue, Today, and Upcoming payment invoices.
class DashboardPaymentCard extends StatefulWidget {
  final OutstandingPurchaseSaleDetails payment;
  final VoidCallback onTap;

  const DashboardPaymentCard({
    super.key,
    required this.payment,
    required this.onTap,
  });

  @override
  State<DashboardPaymentCard> createState() => _DashboardPaymentCardState();
}

class _DashboardPaymentCardState extends State<DashboardPaymentCard> {
  bool _isHovered = false;

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final payment = widget.payment;
    final isSale = payment.trnType == 'Sale';
    final dueDateTime = payment.dueDate != null ? DateTime.tryParse(payment.dueDate!) : null;
    final now = DateTime.now();

    final isToday = dueDateTime != null && _isSameDate(dueDateTime, now);
    final isOverdue = dueDateTime != null &&
        dueDateTime.isBefore(DateTime(now.year, now.month, now.day)) &&
        !isToday;

    // Status colors
    final statusColor = isOverdue
        ? AppColors.danger
        : (isToday ? AppColors.warning : AppColors.info);

    // Days difference
    int daysDiff = 0;
    if (dueDateTime != null) {
      final todayDate = DateTime(now.year, now.month, now.day);
      final targetDate = DateTime(dueDateTime.year, dueDateTime.month, dueDateTime.day);
      daysDiff = targetDate.difference(todayDate).inDays;
    }

    String urgencyLabel;
    if (isToday) {
      urgencyLabel = 'Due Today';
    } else if (daysDiff < 0) {
      urgencyLabel = '${daysDiff.abs()}d overdue';
    } else if (daysDiff == 1) {
      urgencyLabel = 'Due Tomorrow';
    } else {
      urgencyLabel = 'Due in ${daysDiff}d';
    }

    final partyName = payment.partyName ?? 'Unknown Party';
    final invNo = payment.invNo ?? 'N/A';
    final amount = (payment.bAmtRs is num) ? (payment.bAmtRs as num).toDouble() : 0.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 310,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isHovered ? statusColor.withValues(alpha: 0.5) : AppColors.borderLight,
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered ? statusColor.withValues(alpha: 0.1) : Colors.black.withValues(alpha: AppColors.isDark ? 0.2 : 0.03),
                blurRadius: _isHovered ? 8 : 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Row: Type Tag, Invoice #, Urgency Pill
              Row(
                children: [
                  // Purchase/Sale Chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: isSale
                          ? AppColors.primary.withValues(alpha: 0.08)
                          : const Color(0xFFF97316).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSale ? Icons.sell_rounded : Icons.shopping_bag_rounded,
                          size: 11,
                          color: isSale ? AppColors.primary : const Color(0xFFEA580C),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          isSale ? 'Sale' : 'Purchase',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isSale ? AppColors.primary : const Color(0xFFEA580C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      invNo,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Urgency Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.3),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      urgencyLabel,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Middle: Party name
              Row(
                children: [
                  CircleAvatar(
                    radius: 11,
                    backgroundColor: AppColors.background,
                    child: Text(
                      partyName.isNotEmpty ? partyName[0].toUpperCase() : '?',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      partyName.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Bottom: Balance Amount & Action button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Outstanding',
                        style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                      ),
                      Text(
                        CurrencyFormatter.formatInr(amount),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isOverdue ? AppColors.danger : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _isHovered ? AppColors.primary : AppColors.background,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: _isHovered ? AppColors.primary : AppColors.borderLight,
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _isHovered ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 11,
                          color: _isHovered ? Colors.white : AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
