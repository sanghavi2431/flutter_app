
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../janitorial_services/model/host_dashboard_screen.dart';
import '../utils/app_color.dart';

class WalkIn extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final List<WalkInsLast1Hr> walk_ins_last_1Hr_list;
  // final WalkInsLast1Hr walk_ins_last_1Hr, walk_ins_last_3Hr, walk_ins_last_6Hr;
  const WalkIn({
    required this.walk_ins_last_1Hr_list,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
              color: AppColors.textgreyColor,
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ]),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                "Total No. of Walk-in's",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (false)
                Container(
                  width: 84.w,
                  padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(25)),
                  child: const Center(child: Text("Check")),
                )
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
                  (index) => Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.dialogueBackground,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    index == 0
                        ? const Text(
                      "last 1 hr",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        : Text(
                      "last ${index * 3} hrs",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(children: [
                      Text(
                        walk_ins_last_1Hr_list[index].currentCount.toString(),
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        walk_ins_last_1Hr_list[index].percentageChange! >= 0
                            ? "↑ ${walk_ins_last_1Hr_list[index].percentageChange}%"
                            : "↓ ${walk_ins_last_1Hr_list[index].percentageChange}%",
                        style: TextStyle(
                            fontSize: 10.sp,
                            color: walk_ins_last_1Hr_list[index]
                                .percentageChange! >=
                                0
                                ? AppColors.greenTextColor
                                : Colors.red),
                      )
                    ])
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}