import '../../../../janitorial_services/model/iotdata_model.dart';

class PeakResult {
  final String value;
  final String time;

  PeakResult(this.value, this.time);
}

PeakResult getPeakOdor(List<AvgppmTimeRange> list) {
  double maxValue = 0;
  String maxTime = "";

  for (var item in list) {
    final value = double.tryParse(item.avgPpmAvg ?? "0") ?? 0;

    if (value > maxValue) {
      maxValue = value;
      maxTime = item.timeRange ?? "";
    }
  }

  return PeakResult(maxValue.toStringAsFixed(0), maxTime);
}

PeakResult getPeakUsage(List<AvgppmTimeRange> list) {
  double maxValue = 0;
  String maxTime = "";

  for (var item in list) {
    final value = double.tryParse(item.avgPcdMax ?? "0") ?? 0;

    if (value > maxValue) {
      maxValue = value;
      maxTime = item.timeRange ?? "";
    }
  }

  return PeakResult(maxValue.toStringAsFixed(0), maxTime);
}

String formatTimeRange(String? range) {
  if (range == null || range.isEmpty) return "";

  final parts = range.split("-");
  if (parts.length != 2) return range;

  int start = int.tryParse(parts[0]) ?? 0;
  int end = int.tryParse(parts[1]) ?? 0;

  String formatHour(int hour) {
    if (hour == 0) return "12 AM";
    if (hour == 12) return "12 PM";
    if (hour > 12) return "${hour - 12} PM";
    return "$hour AM";
  }

  return "${formatHour(start)} - ${formatHour(end)}";
}

double getMaxAlertValue(List<AlertsNotification>? alerts) {

  if (alerts == null || alerts.isEmpty) {
    return 0;
  }

  double maxValue = 0;

  for (final alert in alerts) {

    final value = double.tryParse(alert.ppmValue ?? "0") ?? 0;

    if (value > maxValue) {
      maxValue = value;
    }
  }

  return maxValue;
}

