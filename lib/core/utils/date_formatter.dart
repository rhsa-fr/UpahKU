import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateFormatter {
  static String formatShort(DateTime date) {
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }

  static String formatFull(DateTime date) {
    return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
  }

  static String formatOnlyDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatPeriode(DateTime start, DateTime end) {
    if (start.year == end.year) {
      if (start.month == end.month) {
        return '${start.day} - ${end.day} ${DateFormat('MMMM yyyy', 'id_ID').format(start)}';
      }
      return '${start.day} ${DateFormat('MMM', 'id_ID').format(start)} - ${end.day} ${DateFormat('MMM yyyy', 'id_ID').format(end)}';
    }
    return '${formatShort(start)} - ${formatShort(end)}';
  }

  static Future<void> init() async {
    await initializeDateFormatting('id_ID', null);
  }
}
