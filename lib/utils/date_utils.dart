import 'package:intl/intl.dart';

class CustomDateUtils {
  static String formatDate(String date) {
    try {
      DateTime now = DateTime.parse(date);
      String formattedDate = DateFormat('dd-MM-yyyy hh:mm a').format(now);
      return formattedDate;
    } catch (e) {
      return '';
    }
  }
}
