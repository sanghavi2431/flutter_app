import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';

import 'cards_view.dart';

class QuickStatsView extends StatelessWidget {
  final String? statPunctualityValuevalue;
  final String? taskClosurePendingValue;




  const QuickStatsView({super.key , required this.statPunctualityValuevalue , required this.taskClosurePendingValue});

  @override
  Widget build(BuildContext context) {
     const String title = "Quick Stats";

    return
      Container(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            key: ValueKey("$title"),
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10,),

      Row(
        children: [


          Expanded(
            child: topCard(
              icon: AppImages.staffPunctuality,
              title: "Staff Punctuality",
              value: statPunctualityValuevalue!,
              unit: "%",
              time: "",
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: topCard(
              icon: AppImages.taskClosurePending,
              title: "Task Closure Pending",
              value: taskClosurePendingValue!,
              unit: "",
              time: "",
            ),
          ),
        ],
      ),
        ],
      ),
    );
  }
}