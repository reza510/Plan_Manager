import 'package:intl/intl.dart';

class DateFormatter {
  // تبدیل String به DateTime با فرمت dd/MM/yyyy
  static DateTime? parseDate(String dateStr) {
    try {
      return DateFormat('dd/MM/yyyy').parseStrict(dateStr);
    } catch (e) {
      return null;
    }
  }

  // تبدیل DateTime به String با فرمت dd/MM/yyyy
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // گرفتن اولین روز ماه برای استفاده در تقویم
  static DateTime firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  // گرفتن آخرین روز ماه
  static DateTime lastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }
}
