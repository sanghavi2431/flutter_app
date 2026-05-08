import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';

import '../model/iotdata_model.dart';

class GraphData {
  final double airQuality;
  final double usage;
  final String timeRange;

  GraphData({
    required this.airQuality,
    required this.usage,
    required this.timeRange,
  });
}

class AirQualityChart extends StatelessWidget {
  final List<GraphData> airQualityData;
  final bool isLoading;
  final String timeFilter;
  final Function(String) onFilterChanged;

  const AirQualityChart({
    super.key,
    required this.airQualityData,
    required this.isLoading,
    required this.timeFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final chartHeight = screenSize.height * 0.3; // 30% of screen height

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Air Quality vs Usage',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterButton('ALL', timeFilter),
                      _buildFilterButton('1M', timeFilter),
                      _buildFilterButton('6M', timeFilter),
                      Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: AppColors.yellowIcon,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 8,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: chartHeight,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : LineChart(
                    _buildLineChartData(screenSize),
                  ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Air Quality', Colors.blue),
                const SizedBox(width: 24),
                _buildLegendItem('Usage', Colors.amber),
                const SizedBox(width: 24),
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 2,
                      color: Colors.red,
                      margin: const EdgeInsets.only(right: 8),
                    ),
                    const Text(
                      'Threshold (50 ppm)',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String filter, String currentFilter) {
    final isSelected = filter == currentFilter;

    return GestureDetector(
      onTap: () => onFilterChanged(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
            color: isSelected ? Colors.grey[300] : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey.shade300)),
        child: Text(
          filter,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  LineChartData _buildLineChartData(Size screenSize) {
    // Create spots for the two lines
    final List<FlSpot> airQualitySpots = [];
    final List<FlSpot> usageSpots = [];

    for (int i = 0; i < airQualityData.length; i++) {
      airQualitySpots.add(FlSpot(i.toDouble(), airQualityData[i].airQuality));
      // Scale down usage to fit on the same chart
      usageSpots.add(FlSpot(i.toDouble(), airQualityData[i].usage));
    }

    final isSmallScreen = screenSize.width < 360;
    final fontSize = isSmallScreen ? 6.0 : 8.0;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 100,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey[300],
            strokeWidth: 0.5,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey[400],
            strokeWidth: 1,
            dashArray: [5, 5],
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 1.0, // Changed to double
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= airQualityData.length) {
                return const Text('');
              }

              final timeRange = airQualityData[value.toInt()].timeRange;
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: RotatedBox(
                  quarterTurns: isSmallScreen ? 1 : 0,
                  child: Text(
                    timeRange,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: fontSize,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 100.0, // Changed to double
            getTitlesWidget: (value, meta) {
              return Text(
                value.toString(),
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize,
                ),
                textAlign: TextAlign.left,
              );
            },
            reservedSize: 40,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      minX: 0,
      maxX: (airQualityData.length - 1).toDouble(),
      minY: 0,
      maxY: 600,
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipRoundedRadius: 8,
          tooltipPadding: const EdgeInsets.all(8),
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              final isAirQuality = spot.barIndex == 0;
              final value = isAirQuality ? spot.y : (spot.y * 20);

              return LineTooltipItem(
                '${isAirQuality ? "Air Quality" : "Usage"}\n${value.toStringAsFixed(1)} ${isAirQuality ? "ppm" : "units"}',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              );
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
        touchSpotThreshold: 20,
      ),
      lineBarsData: [
        LineChartBarData(
          spots: airQualitySpots,
          isCurved: true,
          color: Colors.blue,
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 2,
                color: Colors.blue.shade600,
                strokeWidth: 0,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.blue.withOpacity(0.2),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.withOpacity(0.2),
                Colors.blue.withOpacity(0.0),
              ],
            ),
          ),
        ),
        LineChartBarData(
          spots: usageSpots,
          isCurved: true,
          color: Colors.amber,
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 2,
                color: Colors.amber,
                strokeWidth: 0,
                strokeColor: Colors.amber,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.amber.withOpacity(0.2),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.amber.withOpacity(0.5),
                Colors.amber.withOpacity(0.0),
              ],
            ),
          ),
        ),
        LineChartBarData(
          spots: [
            const FlSpot(0, 500),
            FlSpot((airQualityData.length - 1).toDouble(), 500),
          ],
          isCurved: false,
          color: Colors.red.shade400,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          dashArray: [5, 5],
        ),
      ],
    );
  }
}
