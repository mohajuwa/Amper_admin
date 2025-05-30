import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:ecom_modwir/controllers/language_controller.dart';

class DateUtils {
  static final _languageController = Get.find<LanguageController>();

  static String formatDate(DateTime date, {String? pattern}) {
    final lang = _languageController.currentLanguage.value;

    pattern ??= (lang == 'ar' ? 'dd/MM/yyyy' : 'MMM dd, yyyy');

    return DateFormat(pattern, lang).format(date);
  }

  static String formatTime(DateTime time, {bool use24Hour = true}) {
    final pattern = use24Hour ? 'HH:mm' : 'hh:mm a';

    return DateFormat(pattern).format(time);
  }

  static String formatDateTime(DateTime dateTime, {String? pattern}) {
    final lang = _languageController.currentLanguage.value;

    pattern ??= (lang == 'ar' ? 'dd/MM/yyyy HH:mm' : 'MMM dd, yyyy HH:mm');

    return DateFormat(pattern, lang).format(dateTime);
  }

  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();

    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();

      return '$years ${'years_ago'.tr}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();

      return '$months ${'months_ago'.tr}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${'days_ago'.tr}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${'hours_ago'.tr}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${'minutes_ago'.tr}';
    } else {
      return 'just_now'.tr;
    }
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));

    return isSameDay(date, yesterday);
  }

  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  static List<DateTime> getDaysInRange(DateTime start, DateTime end) {
    final days = <DateTime>[];

    var current = startOfDay(start);

    final endDay = startOfDay(end);

    while (current.isBefore(endDay) || current.isAtSameMomentAs(endDay)) {
      days.add(current);

      current = current.add(const Duration(days: 1));
    }

    return days;
  }

  static int getDaysBetween(DateTime start, DateTime end) {
    final startDay = startOfDay(start);

    final endDay = startOfDay(end);

    return endDay.difference(startDay).inDays;
  }
}
