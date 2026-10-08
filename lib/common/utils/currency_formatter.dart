import 'package:intl/intl.dart';

/// Centralized utility for formatting currency in Indian numbering system.
class CurrencyFormatter {
  static final NumberFormat _inrFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹ ',
    decimalDigits: 2,
  );

  static final NumberFormat _inrNoSymbolFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '',
    decimalDigits: 2,
  );

  /// Formats amount into Indian Rupee format, e.g. "₹ 1,54,15,94,388.07"
  static String formatInr(num? amount, {bool showSymbol = true}) {
    if (amount == null) return showSymbol ? '₹ 0.00' : '0.00';
    final absVal = amount.abs();
    final formatted = showSymbol
        ? _inrFormatter.format(absVal)
        : _inrNoSymbolFormatter.format(absVal).trim();
    if (amount < 0) {
      return showSymbol ? '- $formatted' : '-$formatted';
    }
    return formatted;
  }

  /// Compact Indian notation for large numbers, e.g.:
  /// 1541594388.07 -> "₹ 154.16 Cr"
  /// 21074602.60   -> "₹ 2.11 Cr"
  /// 162159.00     -> "₹ 1.62 L"
  /// 81244.36      -> "₹ 81.24 K"
  static String formatInrCompact(num? amount, {bool showSymbol = true}) {
    if (amount == null) return showSymbol ? '₹ 0' : '0';
    final isNegative = amount < 0;
    final absVal = amount.abs();
    final prefix = isNegative
        ? (showSymbol ? '- ₹ ' : '-')
        : (showSymbol ? '₹ ' : '');

    if (absVal >= 10000000) {
      final cr = absVal / 10000000;
      return '$prefix${cr.toStringAsFixed(2)} Cr';
    } else if (absVal >= 100000) {
      final lakh = absVal / 100000;
      return '$prefix${lakh.toStringAsFixed(2)} L';
    } else if (absVal >= 1000) {
      final k = absVal / 1000;
      return '$prefix${k.toStringAsFixed(2)} K';
    } else {
      return '$prefix${absVal.toStringAsFixed(2)}';
    }
  }

  /// Formats negative amounts cleanly with accounting Dr/Cr or sign, e.g. "₹ 11,10,828.61 Dr"
  static String formatInrAccounting(num? amount) {
    if (amount == null) return '₹ 0.00';
    final absFormatted = formatInr(amount.abs());
    if (amount < 0) {
      return '$absFormatted Dr';
    }
    return absFormatted;
  }
}
