
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/amonia_usage/vice_versa_chart.dart';

import '../../../../janitorial_services/model/iotdata_model.dart';
import '../../../utils/client_images.dart';

class CombinedChartLandscape extends StatelessWidget {

  final List<HourlyData> ammoniaList;
  final double threshold;
  final String selectedRange;


  const CombinedChartLandscape({
    super.key,
    required this.ammoniaList,
    required this.threshold,
    required this.selectedRange,
  });


  double get maxPpm {
    if (ammoniaList.isEmpty) return 10;

    return ammoniaList
        .map((e) => double.tryParse(e.aqi ?? "0") ?? 0)
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
        .map((e) => double.tryParse(e.usage ?? "0") ?? 0)
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
  /*List<BarChartGroupData> get barGroups {
    return ammoniaList.map((item) {
      if (item.timeRange == null) {
        return BarChartGroupData(x: 0, barRods: []);
      }

    //  var split = item.timeRange!.split('-');

      int start = int.tryParse(item.timeRange!) ?? 0;
   //   int end = int.tryParse(split[1]) ?? 0;

     // int start =  parseHour(item.timeRange ?? "");
      print("Start of bar $start");

      /// center position between range
      double center = start.toDouble();

      double value =
          double.tryParse(item.aqi ?? "0") ?? 0;
      print("Start of value bar $value");

      return BarChartGroupData(
        x: start,

        /// place in middle
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
  }*/



  List<BarChartGroupData> get barGroups {
    List<BarChartGroupData> groups = [];

    for (int i = 0; i < 24; i++) {
      final item = ammoniaList.firstWhere(
            (e) => parseHour(e.timeRange ?? "") == i,
        orElse: () => HourlyData(),
      );

      double y = double.tryParse(item.aqi ?? "0") ?? 0;

      groups.add(
        BarChartGroupData(
          x: i, // ✅ INDEX BASED (not actual hour meaning)
          barRods: y == 0
              ? []
              : [
            BarChartRodData(
              toY: y,
              width: 14,
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    return groups;
  }


  List<FlSpot> get lineSpots {
    List<FlSpot> spots = [];

    // ✅ Create full 24-hour map
    Map<int, HourlyData> dataMap = {
      for (var item in ammoniaList)
        parseHour(item.timeRange ?? ""): item
    };



    for (int hour = 0; hour < 24; hour++) {
      final item = dataMap[hour];

      double y = 0;

      if (item != null && item.usage != null && item.usage!.isNotEmpty) {
        double parsed = double.tryParse(item.usage ?? "0") ?? 0;
        y = parsed * usageScaleFactor;
      }

      int hour1 = parseHour(item?.timeRange ?? "");

      print("Start of line ${hour.toDouble()}  $y");

      spots.add(FlSpot(hour.toDouble(), y)); // ✅ FIXED
    }

    return spots;
  }


  List<LineChartBarData> get barSpots {
    List<LineChartBarData> bars = [];
    double offset = 0.0;

    for (int hour = 0; hour < 24; hour++) {
      final item = ammoniaList.firstWhere(
            (e) => parseHour(e.timeRange ?? "") == hour,
        orElse: () => HourlyData(),
      );

      double y = double.tryParse(item.aqi ?? "0") ?? 0;
      offset += 0.05;
      double x = hour.toDouble() + offset;

      if (y == 0) continue;

      bars.add(
        LineChartBarData(
          spots: [
            FlSpot(x, 0), // 👈 avoid below-axis rendering
            FlSpot(x, y),
          ],
          isCurved: false,
          color: Colors.yellow,
          barWidth: 12,

          // ❌ REMOVE circle completely
          dotData: FlDotData(show: false),
        ),
      );
    }

    return bars;
  }

/*  List<FlSpot> get lineSpots {
    List<FlSpot> spots = [];
    for (var item in ammoniaList) {
      if (item.timeRange == null) continue;

   //   var split = item.timeRange!.split('-');

     // int start = int.tryParse(split[0]) ?? 0;
     // int end = int.tryParse(split[1]) ?? 0;
      int start =  parseHour(item.timeRange ?? "");

      double center = (start.toDouble());

    *//*  double y =
          (double.tryParse(item.usage ?? "0") ?? 0) * usageScaleFactor;*//*

      final rawUsage = item.usage;
      final isNull = rawUsage == null || rawUsage.isEmpty;

      double parsed = double.tryParse(rawUsage ?? "") ?? 0;

      double y = (parsed) * usageScaleFactor;

    int hour = parseHour(item.timeRange ?? "");

      spots.add(
        FlSpot(hour.toDouble(), y), // ✅ FIX — SAME center as bars
      );
    }

    return spots;
  }*/


  double get maxAmmonia {
    return ammoniaList
        .map((e) => double.tryParse(e.aqi ?? "0") ?? 0.0)
        .fold<double>(0.0, (double a, double b) => math.max(a, b).toDouble())
        + 10.0;
  }


  double get maxUsage {
    return ammoniaList
        .map((e) => double.tryParse(e.usage ?? "0") ?? 0.0)
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
      height: MediaQuery.of(context).size.height - 90,


      child: Column(
          key: const ValueKey("main_column"),
          children: [
            Row(
              key: const ValueKey("chart_row"),
              children: [

                /// LEFT TITLE
                RotatedBox(
                  key: const ValueKey("left_title"),
                  quarterTurns: -1,
                  child: Text("Odour ($status)"),
                ),

                Expanded(
                  key: const ValueKey("chart_expanded"),
                  child:
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 115,
                    child:
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      // ✅ FIX overflow
                      child: Stack(
                        key: const ValueKey("chart_stack"),
                        children: [

                          /// BAR CHART

                        /*  Positioned.fill( // ✅ FIX
                            child:

                            BarChart(
                              key: const ValueKey("bar_chart"),
                              BarChartData(

                                minY: 0,
                                maxY: chartMaxY,

                                barGroups: barGroups,

                                gridData: FlGridData(show: false),
                                alignment: BarChartAlignment.center,
                                baselineY: 0,
                                barTouchData: BarTouchData(
                                  enabled: true,
                                  handleBuiltInTouches: true,
                                  mouseCursorResolver: (event,
                                      response) => SystemMouseCursors.click,
                                  touchTooltipData: BarTouchTooltipData(
                                    getTooltipColor: (group) => Colors.black87,
                                    getTooltipItem: (group, groupIndex, rod,
                                        rodIndex) {
                                      if (groupIndex < 0 || groupIndex >= ammoniaList.length) {
                                        return null;
                                      }

                                      //  final item = ammoniaList[groupIndex];

                                      final hour = (group.x).round();

                                      final item = ammoniaList.firstWhere(
                                            (e) => parseHour(e.timeRange ?? "") == hour,
                                        orElse: () => HourlyData(),
                                      );


                                      final rawUsage = item.usage;
                                      final isNull = rawUsage == null || rawUsage.isEmpty;

                                      final usage = double.tryParse(rawUsage ?? "0") ?? 0;

                                      *//* final ammonia =
                                          double.tryParse(
                                              item.aqi ?? "0") ?? 0;*//*

                                      final rawAqi = item.aqi;
                                      final isAqiNull = rawAqi == null || rawAqi.isEmpty;

                                      final ammonia = double.tryParse(rawAqi ?? "0") ?? 0;

                                      final range = getRangeLabel(
                                          group.x.toDouble());

                                      return BarTooltipItem(
                                        "$range\nAQI: ${isAqiNull ? "No Data" : "${ammonia.toDouble()} ppm"}\nUsage: ${isNull ? "No Data" : usage.toDouble()}",
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
                                      interval: 1,
                                      reservedSize: 40,

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
                                      interval: interval,
                                      reservedSize: 40,

                                      getTitlesWidget: (value, meta) {
                                        if (value > roundedMax) {
                                          return const SizedBox();
                                        }

                                        // hide non-interval values
                                        if ((value / interval).round() !=
                                            (value / interval)) {
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
                                      interval: usageInterval *
                                          usageScaleFactor,
                                      reservedSize: 40,


                                      getTitlesWidget: (value, meta) {
                                        final originalValue = value /
                                            usageScaleFactor;

                                        // hide values above rounded usage max
                                        if (originalValue > roundedUsageMax) {
                                          return const SizedBox();
                                        }

                                        // hide non-interval values
                                        if ((originalValue / usageInterval)
                                            .round() !=
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

                            ),
                          ),
*/

                          Positioned.fill(
                            child: LineChart(
                              LineChartData(
                                minX: -1,
                                maxX: 25,

                                minY: 0,
                                maxY: chartMaxY,
                                baselineY: 0,

                                gridData: FlGridData(show: false),

                                /// ❌ disable line touch (so it behaves like bar chart)
                                lineTouchData: LineTouchData(
                                  enabled: true,
                                  handleBuiltInTouches: true,
                                  mouseCursorResolver: (event, response) =>
                                  SystemMouseCursors.click,
                                  touchTooltipData: LineTouchTooltipData(
                                    getTooltipColor: (touchedSpot) => Colors.black87,
                                    getTooltipItems: (touchedSpots) {
                                      return touchedSpots.map((spot) {
                                        final hour = spot.x.round();

                                        final item = ammoniaList.firstWhere(
                                              (e) => parseHour(e.timeRange ?? "") == hour,
                                          orElse: () => HourlyData(),
                                        );

                                        final rawUsage = item.usage;
                                        final isNull =
                                            rawUsage == null || rawUsage.isEmpty;

                                        final usage =
                                            double.tryParse(rawUsage ?? "0") ?? 0;

                                        final rawAqi = item.aqi;
                                        final isAqiNull =
                                            rawAqi == null || rawAqi.isEmpty;

                                        final ammonia =
                                            double.tryParse(rawAqi ?? "0") ?? 0;

                                        final range = getRangeLabel(spot.x);

                                        return LineTooltipItem(
                                          "$range\nAQI: ${isAqiNull ? "No Data" : "${ammonia.toDouble()} ppm"}\nUsage: ${isNull ? "No Data" : usage.toDouble()}",
                                          const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        );
                                      }).toList();
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
                                      interval: 1,
                                      reservedSize: 40,
                                      getTitlesWidget: (value, meta) {
                                        final parts = getRangeParts(value);
                                        if (parts == null) return const SizedBox();

                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Text(
                                              "",
                                              style: TextStyle(
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
                                      interval: interval,
                                      reservedSize: 40,
                                      getTitlesWidget: (value, meta) {
                                        if (value > roundedMax) return const SizedBox();

                                        if ((value / interval).round() !=
                                            (value / interval)) {
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
                                      getTitlesWidget: (value, meta) {
                                        final originalValue =
                                            value / usageScaleFactor;

                                        if (originalValue > roundedUsageMax) {
                                          return const SizedBox();
                                        }

                                        if ((originalValue / usageInterval)
                                            .round() !=
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

                                /// 🔥 THIS IS YOUR BAR REPLACEMENT
                                lineBarsData: barSpots,
                              ),
                            ),
                          ),

                          /// LINE CHART
                          Positioned.fill( // ✅ FIX
                            child:
                            LineChart(
                              key: const ValueKey("line_chart"),
                              LineChartData(

                                minX: -1,
                                maxX: 25,

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
                                  mouseCursorResolver: (event,
                                      response) => SystemMouseCursors.click,
                                  touchTooltipData: LineTouchTooltipData(
                                    getTooltipColor: (touchedSpot) =>
                                    Colors.black87,
                                    getTooltipItems: (touchedSpots) {
                                      return touchedSpots.map((spot) {
                                        final hour = spot.x.round();

                                        final item = ammoniaList.firstWhere(
                                              (e) => parseHour(e.timeRange ?? "") == hour,
                                          orElse: () => HourlyData(),
                                        );

                                        /* final usage =
                                            double.tryParse(
                                                item.usage ?? "0") ?? 0;*/

                                        final isNull = item.usage == null || item.usage!.isEmpty;

                                        final usage =
                                            double.tryParse(item.usage ?? "0") ?? 0;

                                        /*   final ammonia =
                                            double.tryParse(
                                                item.aqi ?? "0") ?? 0;
*/
                                        final rawAqi = item.aqi;
                                        final isAqiNull = rawAqi == null || rawAqi.isEmpty;

                                        final ammonia = double.tryParse(rawAqi ?? "0") ?? 0;

                                        final range = getRangeLabel(spot.x);

                                        /*  return LineTooltipItem(
                                          "$range\nAQI: ${ammonia
                                              .toInt()} ppm\nUsage: ${usage
                                              .toInt()}",
                                          const TextStyle(color: Colors.white,
                                              fontSize: 12),
                                        );*/
                                        return LineTooltipItem(
                                          "$range\nAQI: ${isAqiNull ? "No Data" : "${ammonia.toDouble()} ppm"}\nUsage: ${isNull ? "No Data" : usage.toDouble()}",
                                          const TextStyle(color: Colors.white, fontSize: 12),
                                        );
                                      }).toList();
                                    },
                                  ),
                                ),
                                borderData: FlBorderData(show: false),

                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: interval,
                                      reservedSize: 40,

                                      getTitlesWidget: (value, meta) {
                                        if (value > roundedMax) {
                                          return const SizedBox();
                                        }

                                        // hide non-interval values
                                        if ((value / interval).round() !=
                                            (value / interval)) {
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
                                      showTitles: false,
                                      interval: usageInterval *
                                          usageScaleFactor,
                                      reservedSize: 40,


                                      getTitlesWidget: (value, meta) {
                                        final originalValue = value /
                                            usageScaleFactor;

                                        // hide values above rounded usage max
                                        if (originalValue > roundedUsageMax) {
                                          return const SizedBox();
                                        }

                                        // hide non-interval values
                                        if ((originalValue / usageInterval)
                                            .round() !=
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
                                      interval: 1,
                                      reservedSize: 40,

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
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black
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
                                    preventCurveOverShooting: true,
                                    // ✅ FIX 1 (most important)
                                    color: Colors.blue,
                                    barWidth: 2,
                                    //dotData: FlDotData(show: true),
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter: (spot, percent, barData, index) {

                                        if (index < 0 || index >= ammoniaList.length) {
                                          return FlDotCirclePainter(radius: 0);
                                        }

                                        final item = ammoniaList[index];

                                        // ✅ check null vs real value
                                        final isNull = item.usage == null || item.usage!.isEmpty;

                                        return FlDotCirclePainter(
                                          radius: 5,
                                          color: isNull ? Colors.grey : Colors.blue,
                                          strokeWidth: 0,
                                        );
                                      },
                                    ),
                                  ),

                                ],

                              ),

                            ),

                          ),

                        ],
                      ),
                    ),
                  ),
                ),

                /// RIGHT TITLE
                const RotatedBox(
                  key: ValueKey("right_title"),
                  quarterTurns: 1,
                  child: Text("Usage (Total)"),
                ),

              ],
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// Air Quality
                const LegendAirQuality(key: ValueKey("legend_air")),


                const SizedBox(width: 6),

                /// Usage
                const LegendUsage(key: ValueKey("legend_usage")),

                const SizedBox(width: 6),

                /// Threshold
                LegendThreshold(key: const ValueKey("legend_threshold"),
                  threshold: threshold,),

                const SizedBox(width: 6),

                Container(
                  height: 22,
                  width: 22,
                  child: GestureDetector(
                    onTap: () =>  Navigator.pop(context),
                    child: Image.asset(
                      ClientImages.minimise_aqi_usage_graph,
                      width: 22,
                      height: 22,
                    ),
                  ),
                ),

              ],
            ),
          ]
      ),
    );
  }


  String getRangeLabel(double value) {
    int hour = (value + 0.0001).round();

    // Ensure valid range (0–23)
    if (hour < 0 || hour > 23) return "";

    return formatHour(hour);
  }

  Map<String, String>? getRangeParts(double value) {
    for (var item in ammoniaList) {
      final time = item.timeRange;

      if (time == null || time.isEmpty) continue;

      // ✅ HANDLE "12 AM", "1 PM" FORMAT
      int hour = parseHour(time);

      if ((value + 0.0001).round() == hour) {
        return {
          "start": formatHour(hour),
          "end": "", // no range in hourly data
        };
      }
    }

    return null;
  }

  String formatHour(int hour) {

    if (hour == 0) return "12\nAM";
    if (hour < 12) return "${hour}\nAM";
    if (hour == 12) return "12\nPM";
    return "${hour - 12}\nPM";

  }

  int parseHour(String time) {
    time = time.trim().toUpperCase();

    if (time.contains("AM")) {
      int h = int.tryParse(time.replaceAll("AM", "").trim()) ?? 0;
      return h == 12 ? 0 : h;
    } else if (time.contains("PM")) {
      int h = int.tryParse(time.replaceAll("PM", "").trim()) ?? 0;
      return h == 12 ? 12 : h + 12;
    }

    return 0;
  }

}
