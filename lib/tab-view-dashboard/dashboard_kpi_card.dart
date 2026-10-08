import 'package:flutter/material.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/common/utils/currency_formatter.dart';

/// Executive KPI metric card for Dashboard summary row.
class DashboardKpiCard extends StatefulWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color accentColor;
  final String? badgeText;
  final Color? badgeColor;
  final String? subtitle;
  final VoidCallback? onTap;

  const DashboardKpiCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.accentColor,
    this.badgeText,
    this.badgeColor,
    this.subtitle,
    this.onTap,
  });

  @override
  State<DashboardKpiCard> createState() => _DashboardKpiCardState();
}

class _DashboardKpiCardState extends State<DashboardKpiCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isNegative = widget.amount < 0;
    final displayColor = isNegative ? AppColors.danger : widget.accentColor;
    final compactText = CurrencyFormatter.formatInrCompact(widget.amount);
    final fullText = CurrencyFormatter.formatInr(widget.amount);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isHovered
                  ? widget.accentColor.withValues(alpha: 0.5)
                  : AppColors.borderLight,
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? widget.accentColor.withValues(alpha: 0.08)
                    : const Color(0x05000000),
                blurRadius: _isHovered ? 10 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Row: Icon + Title + Badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: displayColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(widget.icon, size: 18, color: displayColor),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.badgeText != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: (widget.badgeColor ?? widget.accentColor).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: (widget.badgeColor ?? widget.accentColor).withValues(alpha: 0.3),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        widget.badgeText!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: widget.badgeColor ?? widget.accentColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),

              // Middle: Amount & Compact denomination
              Tooltip(
                message: fullText,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Flexible(
                      child: Text(
                        fullText,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: isNegative ? AppColors.danger : AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (widget.amount.abs() >= 100000)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.borderLight, width: 0.8),
                        ),
                        child: Text(
                          compactText,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Bottom: Subtitle / helper description
              if (widget.subtitle != null) ...[
                const SizedBox(height: 6),
                Text(
                  widget.subtitle!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
