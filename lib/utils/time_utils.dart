import 'package:intl/intl.dart';

class TimeUtils {
  static String toCommonDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    } else {
      return DateFormat('dd MMM yyyy').format(dateTime);
    }
  }

  static String toFullDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    } else {
      return DateFormat('dd MMMM yyyy').format(dateTime);
    }
  }

  static String toServerDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    } else {
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }
  }
}
