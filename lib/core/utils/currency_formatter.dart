import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _rupiahFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static String format(double value) {
    return _rupiahFormat.format(value);
  }

  /// Short form used inside tight stat tiles, e.g. 112500 -> "112,5rb".
  static String compact(double value) {
    final double abs = value.abs();
    if (abs >= 1000000000) {
      return '${_trim(value / 1000000000)}M';
    }
    if (abs >= 1000000) {
      return '${_trim(value / 1000000)}jt';
    }
    if (abs >= 1000) {
      return '${_trim(value / 1000)}rb';
    }
    return value.toStringAsFixed(0);
  }

  /// Rupiah without the symbol, e.g. 120000 -> "120.000".
  static String plain(double value) =>
      NumberFormat('#,###', 'id_ID').format(value);

  static String _trim(double value) {
    final String s = value.toStringAsFixed(1);
    return s.endsWith('.0') ? s.substring(0, s.length - 2) : s.replaceAll('.', ',');
  }
}

class RupiahInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Strip everything except digits
    final String cleanText = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (cleanText.isEmpty) {
      return newValue.copyWith(text: '', selection: const TextSelection.collapsed(offset: 0));
    }

    final int? value = int.tryParse(cleanText);
    if (value == null) {
      return oldValue;
    }

    // Format with dots
    final formatter = NumberFormat('#,###', 'id_ID');
    final String formattedText = formatter.format(value);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
