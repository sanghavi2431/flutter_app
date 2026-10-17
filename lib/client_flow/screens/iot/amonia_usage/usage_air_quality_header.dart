import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/janitorial_services/model/iotdata_model.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';

class UsageAirQualityHeader extends StatelessWidget {

  final RangeOfPpm range;

  const UsageAirQualityHeader({
    super.key,
    required this.range,
  });

  static const String title = "Usage & Air Quality Trends";

  int toInt(String? value) {
    return double.tryParse(value ?? "0")?.toInt() ?? 0;
  }

  @override
  Widget build(BuildContext context) {

    final healthyMin = toInt(range.healthyMin);
    final healthyMax = toInt(range.healthyMax);

    final moderateMin = toInt(range.moderateMin);
    final moderateMax = toInt(range.moderateMax);

    final unhealthyMin = toInt(range.unhealthyMin);
    final unhealthyMax = toInt(range.unhealthyMax);

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

        const SizedBox(height: 12),

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

              Expanded(
                child: _QualityItem(
                  key: const ValueKey("air_quality_usage"),
                  label: "Healthy",
                  value: "$healthyMin-$healthyMax AQI",
                  color: Colors.green,
                ),
              ),

              const _Divider(),

              Expanded(
                child: _QualityItem(
                  key: const ValueKey("air_quality_usage"),
                  label: "Moderate",
                  value: "$moderateMin-$moderateMax AQI",
                  color: Colors.yellow,
                ),
              ),

              const _Divider(),

              Expanded(
                child: _QualityItem(
                  key: const ValueKey("air_quality_usage"),
                  label: "Unhealthy",
                  value: "$unhealthyMin+ AQI",
                  color: AppColors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class _QualityItem extends StatelessWidget {

  final String label;
  final String value;
  final Color color;


  const _QualityItem({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        /// label → size 12, weight 400
    Semantics(
    label: "air_quality_usage$value",
      value: value.toString(),
      child:
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),),

        const SizedBox(height: 4),

        /// value → size 12, bold
        Container(
    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
    decoration: BoxDecoration(
    color: color, // light background
    borderRadius: BorderRadius.circular(3), // 2px radius
    ),
    child:
    Semantics(
    label: "air_quality_usage$value",
    value: value.toString(),
    child:
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 1,
      color: Colors.grey,
    );
  }
}
