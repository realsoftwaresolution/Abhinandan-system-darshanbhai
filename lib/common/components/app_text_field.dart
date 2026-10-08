import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final String? hintText;
  final bool readOnly;
  final bool enabled;
  final bool obscureText;
  final bool autofocus;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;
  final EdgeInsetsGeometry? contentPadding;
  final bool isDense;
  final double? width;
  final TextAlign textAlign;
  final TextStyle? style;

  const AppTextField({
    super.key,
    this.label,
    this.controller,
    this.focusNode,
    this.nextFocusNode,
    this.hintText,
    this.readOnly = false,
    this.enabled = true,
    this.obscureText = false,
    this.autofocus = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    this.contentPadding,
    this.isDense = true,
    this.width,
    this.textAlign = TextAlign.start,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    Widget field = TextFormField(
      controller: controller,
      focusNode: focusNode,
      readOnly: readOnly,
      enabled: enabled,
      obscureText: obscureText,
      autofocus: autofocus,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      textAlign: textAlign,
      style: style ??
          TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: enabled ? AppColors.textPrimary : AppColors.textMuted,
          ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        prefixIconConstraints: prefixIconConstraints ??
            (prefixIcon != null ? const BoxConstraints(minWidth: 32, minHeight: 32) : null),
        suffixIcon: suffixIcon,
        suffixIconConstraints: suffixIconConstraints ??
            (suffixIcon != null ? const BoxConstraints(minWidth: 32, minHeight: 32) : null),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        isDense: isDense,
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        filled: true,
        fillColor: enabled ? Colors.white : const Color(0xFFF1F5F9),
      ),
      onTap: onTap,
      onChanged: onChanged,
      onFieldSubmitted: (value) {
        if (onFieldSubmitted != null) {
          onFieldSubmitted!(value);
        } else if (nextFocusNode != null) {
          nextFocusNode!.requestFocus();
        } else {
          FocusScope.of(context).nextFocus();
        }
      },
      validator: validator,
    );

    if (label != null && label!.isNotEmpty) {
      field = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 5),
          field,
        ],
      );
    }

    if (width != null) {
      return SizedBox(width: width, child: field);
    }
    return field;
  }
}
