import 'package:flutter/material.dart';
import 'circlular_chart_painter.dart';
import 'iot_dashboard_screen.dart';

class CustomCircularChart extends StatelessWidget {
  final double value;
  final double maxValue;
  final double usage;
  final Color progressColor;
  final double strokeWidth;
  final double size;
  final AirQualityCardType cardType;
  final bool isNoData;

  const CustomCircularChart({
    super.key,
    required this.value,
    required this.maxValue,
    required this.usage,
    required this.progressColor,
    this.strokeWidth = 12,
    this.size = 100,
    required this.cardType,
    required this.isNoData,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// Circular chart
          SizedBox(
            width: size - 10,
            height: size - 10,
            child:
        CustomPaint(
              painter: CircularChartPainter(
                value: value,
                maxValue: maxValue,
                progressColor: progressColor,
                strokeWidth: strokeWidth,
              ),
              child: Center(
                child:/* isNoData
                    ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "-",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                   // SizedBox(height: 2),
                    Text(
                      "No Data",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "found",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
                    :*/ Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Semantics(
                label: "air_quality_card_$value",
                  value: value.toString(),
                  child:
                    Text(
                      cardType == AirQualityCardType.averageAQI
                          ? value.toString()
                          : value.toInt().toString(),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),)
                  ],
                ),
              ),
            /*  child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cardType == AirQualityCardType.averageAQI
                          ? value.toString()        // show double
                          : value.toInt().toString(),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    

                  ],
                ),
              ),*/
            ),
          ), // ✅ FIXED bracket here

        ],
      ),
    );
  }
}
