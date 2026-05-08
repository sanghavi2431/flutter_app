import 'dart:ui';

class AirQualityModel {
  final String title;
  final String timeRange;
  final double value;
  final double usage;
  final double maxValue;    // maximum AQI scale value
  final Color progressColor; //
  final List<BreakdownItemModel> breakdown;

  AirQualityModel({
    required this.title,
    required this.timeRange,
    required this.value,
    required this.usage,
    required this.maxValue,
    required this.progressColor,
    required this.breakdown,
  });
}

class BreakdownItemModel {
  final String time;
  final double value;
  final double usage;
  final String status;

  BreakdownItemModel({
    required this.time,
    required this.value,
    required this.usage,
    required this.status,
  });
}
