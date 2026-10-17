import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/client_flow/utils/client_images.dart';
import '../../../../janitorial_services/model/iotdata_model.dart';
import 'dart:math' as math;

import 'calculate_max_values.dart';
import 'hourly_landscape_graph.dart';


class CombinedChartReverse extends StatelessWidget {

  final List<AvgppmTimeRange> ammoniaList;
  final double threshold;
  final List<HourlyData> hourlyData;
  final String selectedRange;

   CombinedChartReverse({
    super.key,
    required this.ammoniaList,
    required this.threshold,
    required this.hourlyData,
    required this.selectedRange,
  });



  double get maxPpm {
    if (ammoniaList.isEmpty) return 10;

    return ammoniaList
        .map((e) => double.tryParse(e.avgPpmAvg ?? "0") ?? 0)
        .reduce((a, b) => a > b ? a : b);
  }

  double get baseMax {
    return math.max(maxPpm, threshold);
  }

 // double get roundedMax => getRoundedMax(maxPpm);
  double get roundedMax => getRoundedMax(baseMax);

  double get interval => roundedMax / 10;
  double get chartMaxY => roundedMax + interval * 0.2;

  double get maxUsageRaw {
    if (ammoniaList.isEmpty) return 100;

    return ammoniaList
        .map((e) => double.tryParse(e.avgPcdMax ?? "0") ?? 0)
        .reduce((a, b) => a > b ? a : b);
  }

  double get roundedUsageMax => getRoundedUsageMax(maxUsageRaw);

  //double get usageInterval => roundedUsageMax / 10;

  double get usageInterval {
    if (roundedUsageMax <= 10) {
      return 1; // show 0,1,2,3...roundedUsageMax
    }
    return roundedUsageMax / 10;
  }

  double get usageScaleFactor {
    if (roundedUsageMax == 0) return 1;
    return roundedMax / roundedUsageMax;
  }

  /// Convert timeRange (0-3) into hourly bar data
  List<BarChartGroupData> get barGroups {

    return ammoniaList.map((item) {

      if (item.timeRange == null) {
        return BarChartGroupData(x: 0, barRods: []);
      }

      var split = item.timeRange!.split('-');

      int start = int.tryParse(split[0]) ?? 0;
      int end = int.tryParse(split[1]) ?? 0;

      /// center position between range
      double center = (start + end) / 2;

      double value =
          double.tryParse(item.avgPpmAvg ?? "0") ?? 0;


      return BarChartGroupData(
        x: center.round(),   /// place in middle
        barRods: [
          BarChartRodData(
            toY: value,
            width: 18,
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );

    }).toList();

  }


  /// Convert usage list into hourly points evenly
  /*List<FlSpot> get lineSpots {
    if (ammoniaList.isEmpty) return [];
    double step = 24 / ammoniaList.length;
    List<FlSpot> spots = [];
    for (int i = 0; i < ammoniaList.length; i++) {

      double y =
          double.tryParse(ammoniaList[i].avgPcdMax ?? "0") ?? 0;

     *//* spots.add(
        FlSpot(i * step, y),
      );*//*
      spots.add(
        FlSpot(i * step, y * usageScaleFactor),
      );

    }

    return spots;

  }*/

  List<FlSpot> get lineSpots {
    List<FlSpot> spots = [];
    for (var item in ammoniaList) {

      if (item.timeRange == null) continue;

      var split = item.timeRange!.split('-');

      int start = int.tryParse(split[0]) ?? 0;
      int end = int.tryParse(split[1]) ?? 0;

      double center = (start + end) / 2;

      double y =
          (double.tryParse(item.avgPcdMax ?? "0") ?? 0) * usageScaleFactor;

      spots.add(
        FlSpot(center, y),   // ✅ FIX — SAME center as bars
      );

    }

    return spots;

  }


  double get maxAmmonia {

    return ammoniaList
        .map((e) => double.tryParse(e.avgPpmAvg ?? "0") ?? 0.0)
        .fold<double>(0.0, (double a, double b) => math.max(a, b).toDouble())
        + 10.0;

  }


  double get maxUsage {

    return ammoniaList
        .map((e) => double.tryParse(e.avgPcdMax ?? "0") ?? 0.0)
        .fold<double>(0.0, (double a, double b) => math.max(a, b).toDouble())
        + 200.0;

  }


  /// Time labels
  String getHourLabel(int hour) {

    if (hour == 0) return "12\nAM";
    if (hour < 12) return "$hour\nAM";
    if (hour == 12) return "12\nPM";
    return "${hour - 12}\nPM";

  }

  /// Usage labels format
  String formatUsage(double value) {

    if (value >= 1000) {
      return "${(value / 1000).toStringAsFixed(1)}k";
    }

    return value.toInt().toString();

  }

  @override
  Widget build(BuildContext context) {
    String status = selectedRange.toLowerCase() == "today" ? "max" : "average";
    return Container(
      key: const ValueKey("combined_chart_container"),
      height: 480,



      child: Column(
          key: const ValueKey("main_column"),
          children: [
      Row(
        key: const ValueKey("chart_row"),
        children: [

          /// LEFT TITLE
          Semantics(
            label: "bar_chart",
            value: "left_axis",
            child:
          RotatedBox(
            key: const ValueKey("left_title"),
            quarterTurns: -1,
            child: Text("Odour ($status)"),
          ),),

          Expanded(
            key: const ValueKey("chart_expanded"),
            child:
                SizedBox(
                  height: 420,
                  child:
            Padding(
              padding: const EdgeInsets.only(bottom: 8), // ✅ FIX overflow
              child:Stack(
                key: const ValueKey("chart_stack"),
                children: [

                /// BAR CHART
              /*Semantics(
              label: "bar_chart",
                value: chartMaxY.toString(),
                child:*/
              Positioned.fill(   // ✅ FIX
              child:
                BarChart(
    key: const ValueKey("bar_chart"),
                  BarChartData(

                    minY: 0,
                    maxY: chartMaxY,

                    barGroups: barGroups,

                    gridData: FlGridData(show: false),

                    barTouchData: BarTouchData(
                      enabled: true,
                      handleBuiltInTouches: true,
                      mouseCursorResolver: (event, response) => SystemMouseCursors.click,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) => Colors.black87,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {

                          final item = ammoniaList[groupIndex];

                          final usage =
                              double.tryParse(item.avgPcdMax ?? "0") ?? 0;

                          final ammonia =
                              double.tryParse(item.avgPpmAvg ?? "0") ?? 0;

                          final range = getRangeLabel(group.x.toDouble());

                          return BarTooltipItem(
                            "$range\nAQI: ${ammonia.toInt()} ppm\nUsage: ${usage.toInt()}",
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),

                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        bottom: BorderSide(color: Colors.black),
                      ),
                    ),

                    titlesData: FlTitlesData(

                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                         interval: 2,
                            reservedSize: 40,
                        /*  getTitlesWidget: (value, meta) {

                            int hour = value.toInt();

                            if (hour < 0 || hour > 23) {
                              return const SizedBox();
                            }

                            final displayHour = hour == 0
                                ? 12
                                : hour > 12
                                ? hour - 12
                                : hour;

                            final period = hour < 12 ? "AM" : "PM";


                            return Container(
                              //padding: const EdgeInsets.only(top: 6),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [

                                  /// number
                                  Text(
                                    "$displayHour",
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),

                                  /// AM / PM
                                  Text(
                                    period,
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey,
                                    ),
                                  ),

                                ],
                              ),
                            );
                          },*/
                          getTitlesWidget: (value, meta) {

                            final parts = getRangeParts(value);

                            if (parts == null) {
                              return const SizedBox();
                            }

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                Text(
                                  parts["start"]!,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                const Text(
                                  "-",
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                Text(
                                  parts["end"]!,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                              ],
                            );

                          },
                        ),
                      ),


                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval:  interval,
                          reservedSize: 25,

                          getTitlesWidget: (value, meta) {

                            if (value > roundedMax) {
                              return const SizedBox();
                            }

                            // hide non-interval values
                            if ((value / interval).round() != (value / interval)) {
                              return const SizedBox();
                            }

                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 10),
                            );

                          },
                        ),
                      ),

                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: usageInterval * usageScaleFactor,
                          reservedSize: 40,

                          /*getTitlesWidget: (value, meta) {

                            return Text(
                              formatUsage(value),
                              style: const TextStyle(fontSize: 10),
                            );

                          },*/
                          getTitlesWidget: (value, meta) {

                            final originalValue = value / usageScaleFactor;

                            // hide values above rounded usage max
                            if (originalValue > roundedUsageMax) {
                              return const SizedBox();
                            }

                            // hide non-interval values
                            if ((originalValue / usageInterval).round() !=
                                (originalValue / usageInterval)) {
                              return const SizedBox();
                            }

                            return Text(
                              formatUsage(originalValue),
                              style: const TextStyle(fontSize: 10),
                            );
                          },

                        ),
                      ),

                      topTitles: const AxisTitles(),

                    ),

                  ),

                ),), //),

                /// LINE CHART
            /*  Semantics(
                label: "bar_chart",
                value: chartMaxY.toString(),
                child:*/
      Positioned.fill(   // ✅ FIX
        child:
                LineChart(
                  key: const ValueKey("line_chart"),
                  LineChartData(


                    minY: 0,
                    maxY: chartMaxY,
                    baselineY: 0,
                   // extraLinesData: ExtraLinesData(),
                    extraLinesData: ExtraLinesData(
                      horizontalLines: [
                        HorizontalLine(
                          y: threshold,
                          color: Colors.red,
                          strokeWidth: 2,
                          dashArray: [6, 4],
                        ),
                      ],
                    ),

                    clipData: FlClipData(
                      top: true,
                      bottom: true,
                      left: true,
                      right: true,
                    ),
                    gridData: FlGridData(show: false),
                    lineTouchData: LineTouchData(
                      enabled: true,
                      handleBuiltInTouches: true,
                      mouseCursorResolver: (event, response) => SystemMouseCursors.click,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (touchedSpot) => Colors.black87,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {

                            final index = spot.spotIndex;
                            final item = ammoniaList[index];

                            final usage =
                                double.tryParse(item.avgPcdMax ?? "0") ?? 0;

                            final ammonia =
                                double.tryParse(item.avgPpmAvg ?? "0") ?? 0;

                            final range = getRangeLabel(spot.x);

                            return LineTooltipItem(
                              "$range\nAQI: ${ammonia.toInt()} ppm\nUsage: ${usage.toInt()}",
                              const TextStyle(color: Colors.white, fontSize: 12),
                            );

                          }).toList();
                        },
                      ),
                    ),
                    borderData: FlBorderData(show: false),

                    titlesData:  FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: interval,
                          reservedSize: 25,

                          getTitlesWidget: (value, meta) {

                            if (value > roundedMax) {
                              return const SizedBox();
                            }

                            // hide non-interval values
                            if ((value / interval).round() != (value / interval)) {
                              return const SizedBox();
                            }

                            return Text(
                             "",
                              style: const TextStyle(fontSize: 10),
                            );

                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval:usageInterval * usageScaleFactor,
                          reservedSize: 40,

                          /*getTitlesWidget: (value, meta) {

                            return Text(
                              formatUsage(value),
                              style: const TextStyle(fontSize: 10),
                            );

                          },*/
                          getTitlesWidget: (value, meta) {

                            final originalValue = value / usageScaleFactor;

                            // hide values above rounded usage max
                            if (originalValue > roundedUsageMax) {
                              return const SizedBox();
                            }

                            // hide non-interval values
                            if ((originalValue / usageInterval).round() !=
                                (originalValue / usageInterval)) {
                              return const SizedBox();
                            }

                            return Text(
                              formatUsage(originalValue),
                              style: const TextStyle(fontSize: 10),
                            );
                          },

                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true,
                          interval: 2,
                         reservedSize: 40,
                         /* getTitlesWidget: (value, meta) {

                            int hour = value.toInt();

                            if (hour < 0 || hour > 23) {
                              return const SizedBox();
                            }

                            final displayHour = hour == 0
                                ? 12
                                : hour > 12
                                ? hour - 12
                                : hour;

                            final period = hour < 12 ? "AM" : "PM";

                            return Container(
                              //padding: const EdgeInsets.only(top: 6),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [

                                  /// number
                                  Text(
                                    "",
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),

                                  /// AM / PM
                                  Text(
                                    "",
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey,
                                    ),
                                  ),

                                ],
                              ),
                            );
                          },*/
                          getTitlesWidget: (value, meta) {

                            final parts = getRangeParts(value);

                            if (parts == null) {
                              return const SizedBox();
                            }

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                Text(
                                  "",
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black
                                  ),
                                ),

                                const Text(
                                  "",
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                Text(
                                 "",
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                              ],
                            );

                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),

                    lineBarsData: [

                      LineChartBarData(
                        spots: lineSpots,
                        isCurved: false,
                        preventCurveOverShooting: true,   // ✅ FIX 1 (most important)
                        color: Colors.blue,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                      ),

                    ],

                  ),

                ),), //),

              ],
            ),),),
          ),

          /// RIGHT TITLE
          Semantics(
            label: "usage",
            value: "right_title",
            child:
           RotatedBox(
            key: ValueKey("right_title"),
            quarterTurns: 1,
            child: Text("Usage (total)"),
          ),),

        ],
      ),
            const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// Air Quality
            Semantics(
    label: "bar_chart",
    value: chartMaxY.toString(),
    child: LegendAirQuality(key: ValueKey("legend_air")),),



              const SizedBox(width: 6),

              /// Usage
    Semantics(
    label: "bar_chart",
    value: chartMaxY.toString(),
    child: LegendUsage(key: ValueKey("legend_usage")),),

              const SizedBox(width: 6),

              /// Threshold
    Semantics(
    label: "bar_chart",
    value: chartMaxY.toString(),
    child: LegendThreshold( key: const ValueKey("legend_threshold"), threshold: threshold,),),

              const SizedBox(width: 6),

    Semantics(
    label: "bar_chart",
    value: chartMaxY.toString(),
    child:  Container(
                height: 28,
                width: 28,
                child: GestureDetector(
                onTap: () => openLandscapeDialog(context, ammoniaList: hourlyData, threshold: threshold ,  selectedRange : selectedRange,),
                child: Image.asset(
                  ClientImages.expand_aqi_usage_graph,
                  width: 28,
                  height: 28,
                ),
                ),
              ),),

            ],
          ),
  ]
      ),
    );

  }

  /*String getRangeLabel(double value) {

    for (var item in ammoniaList) {

      if (item.timeRange == null) continue;

      var split = item.timeRange!.split('-');

      int start = int.tryParse(split[0]) ?? 0;
      int end = int.tryParse(split[1]) ?? 0;

      double center = (start + end) / 2;

      if (center == value) {

        final startLabel = formatHour(start);
        final endLabel = formatHour(end);

        return "$startLabel-$endLabel";
      }
    }

    return "";
  }*/

  String getRangeLabel(double value) {

    for (var item in ammoniaList) {

      if (item.timeRange == null) continue;

      var split = item.timeRange!.split('-');

      int start = int.tryParse(split[0]) ?? 0;
      int end = int.tryParse(split[1]) ?? 0;

      /// check if axis value falls inside this range
      if (value >= start && value <= end) {

        final startLabel = formatHour(start);
        final endLabel = formatHour(end);

        return "$startLabel-$endLabel";
      }

    }

    return "";

  }

  Map<String, String>? getRangeParts(double value) {

    for (var item in ammoniaList) {

      if (item.timeRange == null) continue;

      var split = item.timeRange!.split('-');

      int start = int.tryParse(split[0]) ?? 0;
      int end = int.tryParse(split[1]) ?? 0;

      if (value >= start && value <= end) {

        return {
          "start": formatHour(start),
          "end": formatHour(end),
        };

      }

    }

    return null;

  }

  String formatHour(int hour) {

    if (hour == 0) return "12AM";
    if (hour < 12) return "${hour}AM";
    if (hour == 12) return "12PM";
    return "${hour - 12}PM";

  }

}

double getRoundedMax(double maxValue) {
  if (maxValue <= 0) return 10;

  // round UP to nearest 10
  return ((maxValue / 10).ceil() * 10).toDouble();
}

class LegendAirQuality extends StatelessWidget {
  const LegendAirQuality({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

    Semantics(
    label: "legend_air",

      child:
        Container(
          key: ValueKey("legend_air_container"),
          width: 18,
          height: 4,
          color: Colors.yellow,
        ),),

        const SizedBox(width: 3),

        Semantics(
    label: "legend_air",
    child:
    Text(
          key: ValueKey("legend_air_text"),
          "Air Quality",
          style: TextStyle(fontSize: 10),
        ), ),

      ],
    );
  }
}

class LegendUsage extends StatelessWidget {
  const LegendUsage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [


      Semantics(
      label: "legend_usage",
      child:
        Stack(
          key: ValueKey("legend_usage_stack"),
          alignment: Alignment.center,
          children: [

            Container(
              width: 18,
              height: 4,
              color: Colors.lightBlue,
            ),

            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.lightBlue,
                shape: BoxShape.circle,
              ),
            ),

          ],
        ),),

        const SizedBox(width: 3),

        Semantics(
    label: "legend_usage",
    child:
        Text(
          key: ValueKey("legend_usage_text"),
          "Usage",
          style: TextStyle(fontSize: 10),
        ),),

      ],
    );
  }
}

class LegendThreshold extends StatelessWidget {
  final double threshold;
  const LegendThreshold({super.key , required this.threshold});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        CustomPaint(
          size: const Size(18, 4),
          painter: DashedLinePainter(),
        ),

        const SizedBox(width: 3),

    Semantics(
    label: "legend_threshold",
    child:
        Text(
          key: ValueKey("legend_threshold_text"),
          "Threshold (${threshold} AQI)",
          style: const TextStyle(fontSize: 10),
        ),),

      ],
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2;

    const dashWidth = 4;
    const dashSpace = 3;

    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

double getRoundedUsageMax(double value) {
  if (value <= 0) return 100;

  double magnitude = math.pow(10, value.toInt().toString().length - 1).toDouble();

  return (value / magnitude).ceil() * magnitude;
}