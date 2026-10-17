import 'package:intl/intl.dart';

String formatDate(String? date) {
  final dateTime = DateTime.tryParse(date ?? "");
  if (dateTime == null) return "";
  return DateFormat("d MMM").format(dateTime);
}

String formatTime(String? date) {
  final dateTime = DateTime.tryParse(date ?? "");
  if (dateTime == null) return "";
  return DateFormat("h.mm a").format(dateTime);
}

String getApiType(String range) {
  switch (range) {
    case 'Today':
      return 'today';
    case '7 days':
      return 'last_7_days';
    case 'Month':
      return 'past_month';
    default:
      return 'today';
  }
}