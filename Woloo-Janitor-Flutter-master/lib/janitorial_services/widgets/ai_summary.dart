import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';

class AiSummaryCard extends StatelessWidget {
  final String summary;

  const AiSummaryCard({
    super.key,
    required this.summary,
    this.fontSize = 20,
  });
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'AI Summary ',
                style: TextStyle(
                  fontSize: fontSize.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              SizedBox(
                height: 24,
                width: 24,
                child: Image.asset(AppImages.twinkleLogo),
              ),
            ],
          ),
          const SizedBox(height: 12),
          summary.isEmpty
              ? const Text('[Summary here]',
                  style: TextStyle(color: Colors.grey))
              : Text(
                  summary,
                  style: const TextStyle(fontSize: 14),
                ),
        ],
      ),
    );
  }
}

class CustomBarChart extends StatelessWidget {
  const CustomBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final List<double> values = [6, 10, 8, 7, 10, 8, 7, 6, 10, 8, 7, 10, 8, 7];
    final List<String> labels = [
      'M',
      'T',
      'W',
      'T',
      'F',
      'S',
      'S',
      'M',
      'T',
      'W',
      'T',
      'F',
      'S',
      'S'
    ];
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 12,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  int idx = value.toInt();
                  if (idx < labels.length) {
                    return Text(labels[idx],
                        style: const TextStyle(fontSize: 12));
                  }
                  return Container();
                },
                reservedSize: 24,
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(values.length, (i) {
            final isHighlighted =
                i == 4 || i == 11 || i == 12; // Example: highlight F, F, S
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  color:
                      isHighlighted ? Colors.lightBlueAccent : Colors.grey[700],
                  width: 16,
                  borderRadius: BorderRadius.circular(20),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
