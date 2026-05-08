import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';

import 'custom_circular_chart.dart';
import 'iot_dashboard_screen.dart';

class AirQualityCard extends StatelessWidget {

  final String title;
  final double value;
  final Color progressColor;
  final String comparisonValue;
  final AirQualityCardType cardType;
  final String daysType;
  final double threshold;

  const AirQualityCard({
    super.key,
    required this.title,
    required this.value,
    required this.progressColor,
    required this.comparisonValue,
    required this.cardType,
    required this.daysType,
    required this.threshold,
  });

  @override
  Widget build(BuildContext context) {

    final String normalizedValue =
    (comparisonValue ?? "").trim().toLowerCase();

    final bool isNoData =
        normalizedValue.replaceAll(" ", "") == "nodata";


    final bool showComparison =
        comparisonValue != null &&
            comparisonValue!.isNotEmpty &&
            !isNoData;

    final bool isPositive =
        showComparison && comparisonValue!.startsWith("+");

    final bool isNegative =
        showComparison && comparisonValue!.startsWith("-");

    final Color arrowColor =
    isNegative ? Colors.red : Colors.green;

    final IconData arrowIcon =
    isNegative
        ? Icons.arrow_drop_down   // DOWN for negative
        : Icons.arrow_drop_up;

    final double rotationAngle =
    isNegative ? 0 : math.pi;

    /*dynamic displayValue;
    if (cardType == AirQualityCardType.averageAQI) {
      displayValue = value; // double
    } else {
      displayValue = value.toInt(); // int
    }
*/
    /// ✅ max value logic
    double maxValue;
    if (cardType == AirQualityCardType.totalUsage) {
      maxValue = 5000;
    }
    else if(cardType == AirQualityCardType.averageAQI)
      {
        maxValue = threshold;
      }
        else
   {
      maxValue = 100;
    }

    /// ✅ usage logic
    double usage;
    if (cardType == AirQualityCardType.totalUsage) {
      usage = maxValue * 0.60; // hardcoded 60%
    } else {
      usage = value;
    }

    return Semantics(
        label: "air_quality_card_$title",
        value: value.toString(),
        child:
      Column(
      children: [

        SizedBox(
          width: double.infinity,
          child: Semantics(
            label: "air_quality_card_$title",
            value: value.toString(),
            child:
          Text(
            key: const ValueKey("header"),
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),)
        ),

        const SizedBox(height: 20),

        SizedBox(
          height: 130,
          child: Semantics(
            label: "air_quality_card_$title",
            value: value.toString(),
            child:
          CustomCircularChart(
            key: const ValueKey("chart"),
            value: value,
            maxValue: maxValue,
            usage: usage,
            progressColor: progressColor,
            cardType: cardType,
            isNoData: isNoData,
          ),),
        ),

            if (showComparison)
    SizedBox(
    width: double.infinity,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [

    /// Arrow + percentage
    Row(
    mainAxisAlignment: MainAxisAlignment.center, // ✅ CENTER
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    Transform.rotate(
    angle: rotationAngle,
    child: Semantics(
      label: "air_quality_card_$title",
      value: value.toString(),
      child:
    Image.asset(
      key: const ValueKey("image"),
    AppImages.arrowRadialGraph,
    width: 16,
    height: 16,
    color: arrowColor,
    ),),
    ),

    const SizedBox(width: 4),
      Semantics(
        label: "air_quality_card_$title",
        value: value.toString(),
        child:
    Text(
      key: const ValueKey("value"),
    "${comparisonValue!.replaceAll("+", "").replaceAll("-", "")}%",
    style: const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    ),
    ),),
    ],
    ),

    const SizedBox(height: 2),

    /// Yesterday text centered
      Semantics(
        label: "air_quality_card_$title",
        value: value.toString(),
        child:
    Text(
      key: const ValueKey("text"),
      getComparisonText(daysType),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ),
    ),),
    ],
    ),
    )
    else
    SizedBox(
    width: double.infinity,
    child: Semantics(
    label: "air_quality_card_$title",
    value: value.toString(),
    child:
    const Text(
      key: const ValueKey("no text"),
    "No Comparison\nData",
    textAlign: TextAlign.center,
    style: TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    ),
    ),
    ),
    ),
      ],
    ), );
  }
}

String getComparisonText(String selectedRange) {
  switch (selectedRange) {
    case 'Today':
      return 'yesterday';

    case '7 days':
      return 'last 7 days';

    case 'Month':
      return 'last month';

    default:
      return '';
  }
}