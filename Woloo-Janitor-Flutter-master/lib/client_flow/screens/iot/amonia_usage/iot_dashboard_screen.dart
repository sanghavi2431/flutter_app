import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/amonia_usage/air_quality_card.dart';

import '../../../../janitorial_services/model/iotdata_model.dart';
import '../../../../utils/app_color.dart';
import 'calculate_max_values.dart';
import 'air_quality_model_from_api.dart';

class AirQualityStatsWidget extends StatelessWidget {

  final GaugeGraphData gaugeGraphData;
  final List<AlertsNotification> alertsNotification;
  final AvgppmPeriodComparison avgppmPeriodComparison;
  final TodayVsYesterdayAlertTrend todayVsYesterdayAlertTrend;
  final String daysType;
  final double threshold;

  const AirQualityStatsWidget({
    super.key,
    required this.gaugeGraphData,
    required this.alertsNotification,
    required this.avgppmPeriodComparison,
    required this.todayVsYesterdayAlertTrend,
    required this.daysType,
    required this.threshold,
  });

  static const String title = "Air Quality Stats";

  double parseValue(String? value) {
    return double.tryParse(value ?? "0") ?? 0;
  }

  @override
  Widget build(BuildContext context) {

    final avgAmonia = parseValue(gaugeGraphData.avgAmonia);
    final pcdMax = parseValue(gaugeGraphData.pcdMax);
    final maxAlertValue = getMaxAlertValue(alertsNotification);

    final isUnhealthy =
        gaugeGraphData.condition?.toLowerCase() == "unhealthy";

    final condition = gaugeGraphData.condition?.toLowerCase();

    final progressColor =
    condition == "unhealthy"
        ? Colors.red
        : condition == "moderate"
        ? Colors.yellow
        : AppColors.lightCyanColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Container(
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

          child: Row(
            children: [

              /// Card 1 → Avg Ammonia
              Expanded(
                child: AirQualityCard(
                  key: const ValueKey("avg_aqi_card"),
                  title: "Average AQI",
                  value: avgAmonia,
                  progressColor: progressColor,
                  comparisonValue:
                  avgppmPeriodComparison.ppmAvgDiffPct.toString(),
                  cardType: AirQualityCardType.averageAQI,
                  daysType: daysType,
                  threshold: threshold,
                ),
              ),

              const SizedBox(width: 5),

              /// Card 2 → Usage (always blue)
              Expanded(
                child: AirQualityCard(
                  key: const ValueKey("total_usage_card"),
                  title: "Total Usage",
                  value: pcdMax,
                  progressColor: AppColors.lightCyanColor,
                  comparisonValue: avgppmPeriodComparison.pcdMaxDiffPct.toString(),
                  cardType: AirQualityCardType.totalUsage,
                  daysType: daysType,
                  threshold: threshold,
                ),
              ),

              const SizedBox(width: 5),

              /// Card 3 → dummy for now
              Expanded(
                child: AirQualityCard(
                  key: const ValueKey("alerts_received_card"),
                  title: "Alerts Received",
                  value: alertsNotification.length.toDouble(),
                  progressColor: AppColors.lightCyanColor,
                  comparisonValue: todayVsYesterdayAlertTrend.percentageDifference.toString(),
                  cardType: AirQualityCardType.alertsReceived,
                  daysType: daysType,
                  threshold: threshold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum AirQualityCardType {
  averageAQI,
  totalUsage,
  alertsReceived,
}

