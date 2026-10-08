import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';

enum AppButtonVariant { primary, secondary, outline, danger, success }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final String? shortcutLabel;
  final AppButtonVariant variant;
  final bool isLoading;
  final double? width;
  final double height;
  final FocusNode? focusNode;
  final bool autofocus;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.shortcutLabel,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.width,
    this.height = 36,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color fgColor;
    BorderSide? borderSide;

    switch (variant) {
      case AppButtonVariant.primary:
        bgColor = AppColors.primary;
        fgColor = Colors.white;
        borderSide = BorderSide.none;
        break;
      case AppButtonVariant.secondary:
        bgColor = const Color(0xFFE2E8F0);
        fgColor = AppColors.textPrimary;
        borderSide = BorderSide.none;
        break;
      case AppButtonVariant.outline:
        bgColor = Colors.white;
        fgColor = AppColors.textPrimary;
        borderSide = const BorderSide(color: AppColors.border, width: 1);
        break;
      case AppButtonVariant.danger:
        bgColor = AppColors.danger;
        fgColor = Colors.white;
        borderSide = BorderSide.none;
        break;
      case AppButtonVariant.success:
        bgColor = AppColors.success;
        fgColor = Colors.white;
        borderSide = BorderSide.none;
        break;
    }

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          CupertinoActivityIndicator(
            radius: 7,
            color: fgColor,
          ),
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          Icon(icon, size: 16, color: fgColor),
          const SizedBox(width: 6),
        ],
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: fgColor,
          ),
        ),
        if (shortcutLabel != null) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: fgColor.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              shortcutLabel!,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: fgColor,
              ),
            ),
          ),
        ],
      ],
    );

    Widget btn = ElevatedButton(
      focusNode: focusNode,
      autofocus: autofocus,
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        elevation: 0,
        disabledBackgroundColor: bgColor.withValues(alpha: 0.6),
        disabledForegroundColor: fgColor.withValues(alpha: 0.6),
        side: borderSide,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        minimumSize: Size(width ?? 0, height),
      ),
      child: content,
    );

    if (width != null) {
      return SizedBox(width: width, height: height, child: btn);
    }
    return SizedBox(height: height, child: btn);
  }
}
