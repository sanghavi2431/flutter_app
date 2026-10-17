import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../janitorial_services/model/iotdata_model.dart';
import 'dart:math' as math;


class CombinedChartReverse1 extends StatelessWidget {

  final List<AvgppmTimeRange> ammoniaList;

  const CombinedChartReverse1({
    super.key,
    required this.ammoniaList,
  });

  double get usageScaleFactor {
    if (maxUsage == 0) return 1;
    return maxAmmonia / maxUsage;
  }


  /// Convert timeRange (0-3) into hourly bar data
  /// Convert timeRange into bar data
  /// ✅ ONLY CHANGE: avgPcdMax instead of avgPpmAvg
  List<BarChartGroupData> get barGroups {

    return ammoniaList.map((item) {

      if (item.timeRange == null) {
        return BarChartGroupData(x: 0, barRods: []);
      }

      var split = item.timeRange!.split('-');

      int start = int.tryParse(split[0]) ?? 0;
      int end = int.tryParse(split[1]) ?? 0;

      double center = (start + end) / 2;

      /// 🔥 swapped value ONLY
      double value =
          (double.tryParse(item.avgPcdMax ?? "0") ?? 0)
              * usageScaleFactor;

      return BarChartGroupData(
        x: center.round(),
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

  /// Convert usage list into hourly points evenly
  /// ✅ ONLY CHANGE: avgPpmAvg instead of avgPcdMax
  List<FlSpot> get lineSpots {

    List<FlSpot> spots = [];

    for (var item in ammoniaList) {

      if (item.timeRange == null) continue;

      var split = item.timeRange!.split('-');

      int start = int.tryParse(split[0]) ?? 0;
      int end = int.tryParse(split[1]) ?? 0;

      double center = (start + end) / 2;

      /// 🔥 swapped value ONLY
      double y =
          (double.tryParse(item.avgPpmAvg ?? "0") ?? 0)
              * usageScaleFactor;

      spots.add(
        FlSpot(center, y),
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

    return Container(
      height: 480,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
          )
        ],
      ),


      child: Column(
          children: [
            Row(
              children: [

                /// LEFT TITLE
                const RotatedBox(
                  quarterTurns: -1,
                  child: Text("Odour (AQI)"),
                ),

                Expanded(
                  child:
                  SizedBox(
                    height: 400,
                    child:
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8), // ✅ FIX overflow
                      child:Stack(
                        children: [

                          /// BAR CHART
                          Positioned.fill(   // ✅ FIX
                            child:
                            BarChart(

                              BarChartData(

                                minY: 0,
                                maxY: maxAmmonia,

                                barGroups: barGroups,

                                gridData: FlGridData(show: false),

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
                                      interval: 10,
                                      reservedSize: 25,

                                      getTitlesWidget: (value, meta) {

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
                                      interval: 250 * usageScaleFactor,
                                      reservedSize: 40,

                                      /*getTitlesWidget: (value, meta) {

                            return Text(
                              formatUsage(value),
                              style: const TextStyle(fontSize: 10),
                            );

                          },*/
                                      getTitlesWidget: (value, meta) {

                                        final originalValue = value / usageScaleFactor;

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

                            ),),

                          /// LINE CHART
                          Positioned.fill(   // ✅ FIX
                            child:
                            LineChart(

                              LineChartData(


                                minY: 0,
                                maxY: maxAmmonia,
                                baselineY: 0,
                                extraLinesData: ExtraLinesData(),

                                clipData: FlClipData(
                                  top: true,
                                  bottom: true,
                                  left: true,
                                  right: true,
                                ),
                                gridData: FlGridData(show: false),
                                lineTouchData: LineTouchData(enabled: false),
                                borderData: FlBorderData(show: false),

                                titlesData:  FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 10,
                                      reservedSize: 25,

                                      getTitlesWidget: (value, meta) {

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
                                      interval: 250 * usageScaleFactor,
                                      reservedSize: 40,

                                      /*getTitlesWidget: (value, meta) {

                            return Text(
                              formatUsage(value),
                              style: const TextStyle(fontSize: 10),
                            );

                          },*/
                                      getTitlesWidget: (value, meta) {

                                        final originalValue = value / usageScaleFactor;

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

                            ),),

                        ],
                      ),),),
                ),

                /// RIGHT TITLE
                const RotatedBox(
                  quarterTurns: 1,
                  child: Text("Usage"),
                ),

              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [

                /// Air Quality
                LegendAirQuality(),

                SizedBox(width: 5),

                /// Usage
                LegendUsage(),

                SizedBox(width: 5),

                /// Threshold
                LegendThreshold(),

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

class LegendAirQuality extends StatelessWidget {
  const LegendAirQuality({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Stack(
          alignment: Alignment.center,
          children: [

            Container(
              width: 20,
              height: 4,
              color: Colors.lightBlue,
            ),

            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.lightBlue,
                shape: BoxShape.circle,
              ),
            ),

          ],
        ),

        const SizedBox(width: 6),

        const Text(
          "Air Quality",
          style: TextStyle(fontSize: 12),
        ),

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

        Container(
          width: 20,
          height: 4,
          color: Colors.yellow,
        ),

        const SizedBox(width: 6),

        const Text(
          "Usage",
          style: TextStyle(fontSize: 12),
        ),

      ],
    );
  }
}

class LegendThreshold extends StatelessWidget {
  const LegendThreshold({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        CustomPaint(
          size: const Size(20, 4),
          painter: DashedLinePainter(),
        ),

        const SizedBox(width: 6),

        const Text(
          "Threshold (50 ppm)",
          style: TextStyle(fontSize: 12),
        ),

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