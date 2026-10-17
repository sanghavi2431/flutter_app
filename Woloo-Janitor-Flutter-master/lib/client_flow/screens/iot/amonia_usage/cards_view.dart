

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';

  class CardsRowView extends StatefulWidget {
    final String peakOderValue ;
    final String peakOderTime;
    final String peakUsageValue ;
    final String peakUsageTime;
  const CardsRowView({super.key ,
    required this.peakOderValue,
    required this.peakOderTime,
    required this.peakUsageValue,
    required this.peakUsageTime,

  });

  @override
  State<CardsRowView> createState() => _CardsRowViewState();
  }

  class _CardsRowViewState extends State<CardsRowView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Row(
        children: [

          Expanded(
            child: topCard(
              icon: AppImages.peakOdorIndex,
              title: "Peak Odour Index",
              value: widget.peakOderValue,
              unit: "AQI",
              time: widget.peakOderTime,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: topCard(
              icon: AppImages.peakUsage,
              title: "Peak Usage",
              value: widget.peakUsageValue,
              unit: "",
              time: widget.peakUsageTime,
            ),
          ),
        ],
      ),
    );
  }
}

Widget topCard({
  required String icon,
  required String title,
  required String value,
  required String unit,
  required String time,
}) {

  String formatValue(String value) {
    final number = double.tryParse(value);

    if (number == null) {
      // not a number → return as it is
      return value;
    }

    // if decimal → convert to int
    return number.toInt().toString();
  }

  return  Container(
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

    child:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// Icon + Title
      Semantics(
      label: "card view",
      value: "header row",
      child:
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.lightBgBlueColor,
                borderRadius: BorderRadius.circular(8),
              ),
     child: Semantics(
          label: "bar_chart",
          value: icon,

              child: Image.asset(
                key: ValueKey("image"),
                icon,
                height: 18,
                width: 18,
              ),
            ),
  ),

            const SizedBox(width: 8),

            Expanded(
              child:
              SizedBox(
              height: 34.h,
  child:
  Semantics(
    label: "bar_chart",
    value: title,
    child:
  Text(
    key: ValueKey("$title"),
                title,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
  ),
              ),
            ),
          ],
        ),),

        const SizedBox(height: 14),

        /// Value
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Semantics(
                label: "bar_chart",
                value: "$title $value",
                child:
            Text(
              key: ValueKey("$title $value"),
              formatValue(value),
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            ),

            if (unit.isNotEmpty)
              Semantics(
                label: "bar_chart",
                value: "$title $unit",
                child:
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 6),
                child: Text(
                  key: ValueKey("$title $unit"),
                  unit,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),),
          ],
        ),

        const SizedBox(height: 6),

        /// Time
    Semantics(
      label: "bar_chart",
      value: "$title $time",
      child:
        Text(
          key: ValueKey("$title $time"),
          time,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
    ),
      ],
    ),
  );
}
