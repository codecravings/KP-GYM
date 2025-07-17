import 'package:intl/intl.dart';

class DateFormatter {
  // Format date in standard format (e.g., '01 Jan 2023')
  static String formatDate(DateTime date, {String locale = 'en'}) {
    return DateFormat('dd MMM yyyy', locale).format(date);
  }
  
  // Format date in compact format (e.g., '01/01/2023')
  static String formatCompactDate(DateTime date, {String locale = 'en'}) {
    return DateFormat('dd/MM/yyyy', locale).format(date);
  }
  
  // Format month and year (e.g., 'January 2023')
  static String formatMonthYear(DateTime date, {String locale = 'en'}) {
    return DateFormat('MMMM yyyy', locale).format(date);
  }
  
  // Format short month and year (e.g., 'Jan 2023')
  static String formatShortMonthYear(DateTime date, {String locale = 'en'}) {
    return DateFormat('MMM yyyy', locale).format(date);
  }
  
  // Format day of week (e.g., 'Monday')
  static String formatDayOfWeek(DateTime date, {String locale = 'en'}) {
    return DateFormat('EEEE', locale).format(date);
  }
  
  // Calculate days between two dates
  static int daysBetween(DateTime from, DateTime to) {
    final fromDate = DateTime(from.year, from.month, from.day);
    final toDate = DateTime(to.year, to.month, to.day);
    return toDate.difference(fromDate).inDays;
  }
  
  // Calculate remaining days from today to a future date
  static int remainingDays(DateTime futureDate) {
    final today = DateTime.now();
    return daysBetween(today, futureDate);
  }
  
  // Get first day of month
  static DateTime firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }
  
  // Get last day of month
  static DateTime lastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }
  
  // Get start and end dates for current month
  static Map<String, DateTime> currentMonthRange() {
    final now = DateTime.now();
    return {
      'start': firstDayOfMonth(now),
      'end': lastDayOfMonth(now),
    };
  }
  
  // Format relative time (e.g., '2 days ago', 'in 3 days')
  static String formatRelativeTime(DateTime date, {String locale = 'en'}) {
    final now = DateTime.now();
    final difference = date.difference(now);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Now';
        } else if (difference.isNegative) {
          return '${-difference.inMinutes} minutes ago';
        } else {
          return 'in ${difference.inMinutes} minutes';
        }
      } else if (difference.isNegative) {
        return '${-difference.inHours} hours ago';
      } else {
        return 'in ${difference.inHours} hours';
      }
    } else if (difference.isNegative) {
      if (-difference.inDays == 1) {
        return 'Yesterday';
      } else if (-difference.inDays < 7) {
        return '${-difference.inDays} days ago';
      } else if (-difference.inDays < 30) {
        return '${(-difference.inDays / 7).floor()} weeks ago';
      } else {
        return formatDate(date, locale: locale);
      }
    } else {
      if (difference.inDays == 1) {
        return 'Tomorrow';
      } else if (difference.inDays < 7) {
        return 'in ${difference.inDays} days';
      } else if (difference.inDays < 30) {
        return 'in ${(difference.inDays / 7).floor()} weeks';
      } else {
        return formatDate(date, locale: locale);
      }
    }
  }
}