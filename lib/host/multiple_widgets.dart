import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauge_chart/gauge_chart.dart';

import '../b2b_store/add_new_address_bottomsheet.dart';
import '../client_flow/screens/dashbaord/view/dashboard.dart';
import '../utils/app_color.dart';
import '../utils/app_images.dart';
import '../utils/app_textstyle.dart';

class XPaymentTile extends StatelessWidget {
  const XPaymentTile({
    super.key,
    required this.imgPath,
    required this.paymentMethod,
    this.onTap,
    this.onSelected = false,
  });
  final String imgPath;
  final String paymentMethod;
  final VoidCallback? onTap;
  final bool onSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(height: 40, width: 40, child: Image.asset(imgPath)),
          SizedBox(
            width: 10.w,
          ),
          Text(
            paymentMethod,
            style: AppTextStyle.font14bold,
          ),
          const Spacer(),
          XDesignedRadioButton(
            onSelected: onSelected,
          )
        ],
      ),
    );
  }
}

// class XDesignedTextField extends StatelessWidget {
//   const XDesignedTextField({
//     super.key,
//     required this.hintText,
//     this.controller,
//   });
//   final String hintText;
//   final TextEditingController? controller;

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         fillColor: AppColors.themeBackground,
//         filled: true,
//         hintText: hintText,
//         hintStyle: AppTextStyle.font12,
//         border: InputBorder.none,
//         focusedBorder: InputBorder.none,
//         enabledBorder: InputBorder.none,
//         errorBorder: InputBorder.none,
//         disabledBorder: InputBorder.none,
//       ),
//     );
//   }
// }

class TasksStatusTab extends StatelessWidget {
  const TasksStatusTab({
    super.key,
    required this.color,
    required this.label,
  });
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 5,
        ),
        SizedBox(
          width: 8.w,
        ),
        Text(
          label,
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textgreyColor),
        ),
      ],
    );
  }
}

class TaskAudit extends StatelessWidget {
  const TaskAudit({
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Task Audit",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              const SizedBox(
                width: 12,
              ),
              GaugeChart(
                children: [
                  PieData(
                    value: 2,
                    color: AppColors.pieDataColor1,
                    description: "Pending",
                  ),
                  PieData(
                    value: 2,
                    color: AppColors.pieDataColor2,
                    description: "Accepted",
                  ),
                  PieData(
                    value: 3,
                    color: AppColors.pieDataColor3,
                    description: "On Going",
                  ),
                  PieData(
                    value: 6,
                    color: AppColors.pieDataColor4,
                    description: "Completed",
                  ),
                ],
                gap: 0.6,
                animateDuration: const Duration(seconds: 1),
                start: -150,
                shouldAnimate: true,
                animateFromEnd: false,
                size: 100,
                showValue: false,
                borderWidth: 12,
              ),
              const SizedBox(
                width: 20,
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  XGuageChartDescription(
                    color: AppColors.pieDataColor1,
                    taskName: "Pending Tasks",
                    taskSize: 2,
                  ),
                  XGuageChartDescription(
                    color: AppColors.pieDataColor2,
                    taskName: "Accepted Tasks",
                    taskSize: 2,
                  ),
                  XGuageChartDescription(
                    color: AppColors.pieDataColor3,
                    taskName: "On Going",
                    taskSize: 3,
                  ),
                  XGuageChartDescription(
                    color: AppColors.pieDataColor4,
                    taskName: "Completed Tasks",
                    taskSize: 6,
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class XGuageChartDescription extends StatelessWidget {
  const XGuageChartDescription({
    super.key,
    required this.color,
    required this.taskName,
    required this.taskSize,
  });
  final Color color;
  final String taskName;
  final int taskSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 5,
        ),
        SizedBox(
          width: 8.w,
        ),
        Text(
          "$taskName : $taskSize",
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textgreyColor),
        )
      ],
    );
  }
}

class FacilityButton extends StatelessWidget {
  const FacilityButton({
    super.key,
    required this.label,
  });
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.buttonYellowColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10.h, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class DashboardOverview extends StatelessWidget {
  const DashboardOverview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Dashboard Overview",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.boldTextColor,
          ),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
              color: AppColors.themeBackground,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.textgreyColor,
                  blurRadius: 4,
                  offset: Offset(0, 1),
                )
              ]),
          width: 39.h,
          height: 39.h,
          child: Center(
            child: ImageIcon(
              AssetImage(AppImages.changeArrow),
              size: 22.h,
              color: AppColors.boldTextColor,
            ),
          ),
        )
      ],
    );
  }
}

class RedeemPoints extends StatelessWidget {
  const RedeemPoints({
    super.key,
    required this.points,
  });
  final String points;

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
              SizedBox(
                height: 40,
                width: 40,
                child: Image.asset(AppImages.money),
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$points Woloo Points",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.boldTextColor,
                    ),
                  ),
                  Text(
                    "You have Woloo Points that are ready to be redeemed",
                    style: TextStyle(
                      fontSize: 8.sp,
                      // fontWeight: FontWeight.bold,
                      color: AppColors.boldTextColor,
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              // const LabeledButton(
              //   label: "How to Redeem?",
              // ),
              SizedBox(width: 8.w),
              InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (c) => ClientDashboard(
                          dashIndex: 0,
                        )),
                        (route) => false,
                  );
                },
                child: LabeledButton(
                  label: "Redeem Now",
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class LabeledButton extends StatelessWidget {
  const LabeledButton({
    super.key,
    required this.label,
  });
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(25)),
      child: Center(
          child: Text(
            label,
            style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w600),
          )),
    );
  }
}

class ShopWidget extends StatelessWidget {
  const ShopWidget({
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Shop",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.boldTextColor),
              ),
              Container(
                width: 84.w,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(25)),
                child: const Center(child: Text("Go")),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
              height: 99.h,
              child: ListView.separated(
                  itemCount: 20,
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 10,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 99.h,
                      width: 99.h,
                      padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: AppColors.dialogueBackground,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    );
                  })),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}