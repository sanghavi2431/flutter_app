import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauge_chart/gauge_chart.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/dashboard.dart';
import 'package:woloo_smart_hygiene/janitorial_services/model/host_dashboard_screen.dart';
import 'package:woloo_smart_hygiene/janitorial_services/model/referral_coins.dart';
import 'package:woloo_smart_hygiene/janitorial_services/screens/bloc/iot_bloc.dart';
import 'package:woloo_smart_hygiene/janitorial_services/screens/bloc/iot_event.dart';
import 'package:woloo_smart_hygiene/janitorial_services/screens/bloc/iot_state.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:woloo_smart_hygiene/b2b_store/address_change_bottomsheet.dart';

import '../../utils/app_images.dart';

class HostDashboard extends StatefulWidget {
  const HostDashboard({super.key});

  @override
  State<HostDashboard> createState() => _HostDashboardState();
}

class _HostDashboardState extends State<HostDashboard> {
  IotBloc iotBloc = IotBloc();
  HostDashboardData? _hostDashboardData;
  ReferralCoins? coins;
  // bool _isLoading = false;
  final String _error = '';
  final String _timeFilter = 'ALL';

  var i = 0;

  @override
  void initState() {
    super.initState();
    iotBloc.add(const GetHostDashboardData(woloo_id: "woloo_id"));
    // _fetchDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomSheet: OrderSummeryBottomSheet(),
      appBar: AppBar(
        leading: CustomImageProvider(
          image: AppImages.dashlogo,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Hello clientName",
              style: AppTextStyle.font14bold,
            ),
            Text(
              DashboardConst.currentDateTime,
              style: AppTextStyle.font12,
            )
          ],
        ),
      ),
      body: SafeArea(
        child: BlocConsumer(
          bloc: iotBloc,
          listener: (context, state) {
            print("dssa $state");
            if (state is IotLoading) {
              EasyLoading.show(status: state.message);
            }
            if (state is HostDashboardSuccess) {
              EasyLoading.dismiss();
              setState(() {
                _hostDashboardData = state.hostDashboardHome.dashboardData;
                coins = state.hostDashboardHome.coins;
              });
            }

            if (state is IotError) {
              EasyLoading.dismiss();
              EasyLoading.showError(state.error);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 23.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // HeaderSection(
                  //   username: data.username,
                  //   userRole: data.userRole,
                  //   lastUpdated: data.lastUpdated,
                  //   trialDaysLeft: data.trialDaysLeft,
                  // ),
                  const SizedBox(height: 16),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          color: AppColors.textgreyColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                      children: [
                        TextSpan(
                          text: 'Your Trial shall end in ',
                        ),
                        TextSpan(
                          text: '3 Days. ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'Renew it Now',
                          style: TextStyle(
                            color: AppColors.textgreyColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  WahScore(
                      score: _hostDashboardData?.results?.wahScore ?? "",
                      imgUrl: _hostDashboardData?.results?.wahScoreImage ??
                          'https://woloo-prod.s3.ap-south-1.amazonaws.com/Cibil_Images/excellent.png'),
                  SizedBox(height: 16.h),
                  // if (_hostDashboardData?.results != null)
                  WalkIn(
                    walk_ins_last_1Hr_list: [
                      WalkInsLast1Hr(
                        currentCount: _hostDashboardData
                                ?.results?.walkInsLast1Hr?.currentCount ??
                            0,
                        previousCount: _hostDashboardData
                                ?.results?.walkInsLast1Hr?.previousCount ??
                            0,
                        percentageChange: _hostDashboardData
                                ?.results?.walkInsLast1Hr?.percentageChange ??
                            0,
                      ),
                      WalkInsLast1Hr(
                        currentCount: _hostDashboardData
                                ?.results?.walkInsLast3Hr?.currentCount ??
                            0,
                        previousCount: _hostDashboardData
                                ?.results?.walkInsLast3Hr?.previousCount ??
                            0,
                        percentageChange: _hostDashboardData
                                ?.results?.walkInsLast3Hr?.percentageChange ??
                            0,
                      ),
                      WalkInsLast1Hr(
                        currentCount: _hostDashboardData
                                ?.results?.walkInsLast6Hr?.currentCount ??
                            0,
                        previousCount: _hostDashboardData
                                ?.results?.walkInsLast6Hr?.previousCount ??
                            0,
                        percentageChange: _hostDashboardData
                                ?.results?.walkInsLast6Hr?.percentageChange ??
                            0,
                      )
                    ],
                  ),
                  SizedBox(height: 16.h),
                  // const ShopWidget(),
                  SizedBox(height: 16.h),
                  RedeemPoints(
                    points: coins?.results?.totalCoins.toString() ?? "",
                  ),
                  SizedBox(height: 70.h),
                  // SizedBox(height: 16.h),
                  // const DashboardOverview(),
                  // SizedBox(height: 16.h),
                  // SizedBox(
                  //   height: 27.h,
                  //   child: ListView(
                  //     scrollDirection: Axis.horizontal,
                  //     children: [
                  //       ...List.generate(4, (index) {
                  //         return FacilityButton(label: "Facility ${index + 1}");
                  //       }),
                  //       const FacilityButton(label: "Request"),
                  //       const FacilityButton(label: "Completed"),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 16.h),
                  // const TaskAudit(),
                  // SizedBox(height: 16.h),
                  // JanitorPerformance(i: i),
                  // SizedBox(height: 16.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class EditHeader extends StatelessWidget {
  const EditHeader({
    super.key,
    required this.label,
  });
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        const Spacer(),
        const EditButton(),
      ],
    );
  }
}

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

class JanitorPerformance extends StatelessWidget {
  const JanitorPerformance({
    super.key,
    required this.i,
  });

  final int i;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Janitor Performance",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            height: 200.h,
            child: BarChart(
              BarChartData(
                  borderData: FlBorderData(show: false),
                  maxY: 5,
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        interval: 3.0,
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt() == 0
                                ? "10"
                                : (value.toInt() * 10).toString(),
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.textgreyColor,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        interval: 3.0,
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt() == 0
                                ? "30"
                                : value.toInt() == 3
                                    ? "60"
                                    : "90",
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.textgreyColor,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          // i++;
                          // meta.axis.title.text = "Janitor ${value.toInt() + 1}";
                          return Text(
                            "Janitor $i",
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.textgreyColor,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(
                        toY: 4,
                        color: AppColors.pieDataColor1,
                        width: 5.w,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      BarChartRodData(
                        toY: 3,
                        color: AppColors.pieDataColor2,
                        width: 5.w,
                        borderRadius: BorderRadius.circular(5),
                      )
                    ]),
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(
                        toY: 3,
                        color: AppColors.pieDataColor1,
                        width: 5.w,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      BarChartRodData(
                        toY: 5,
                        color: AppColors.pieDataColor2,
                        width: 5.w,
                        borderRadius: BorderRadius.circular(5),
                      )
                    ]),
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(
                        toY: 2,
                        color: AppColors.pieDataColor1,
                        width: 5.w,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      BarChartRodData(
                        toY: 3,
                        color: AppColors.pieDataColor2,
                        width: 5.w,
                        borderRadius: BorderRadius.circular(5),
                      )
                    ]),
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(
                        toY: 5,
                        color: AppColors.pieDataColor1,
                        width: 5.w,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      BarChartRodData(
                        toY: 2,
                        color: AppColors.pieDataColor2,
                        width: 5.w,
                        borderRadius: BorderRadius.circular(5),
                      )
                    ])
                  ]),
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TasksStatusTab(
                color: AppColors.pieDataColor3,
                label: "All Tasks",
              ),
              TasksStatusTab(
                  color: AppColors.pieDataColor2, label: "Tasks Completed")
            ],
          )
        ],
      ),
    );
  }
}

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

class WahScore extends StatelessWidget {
  final String imgUrl;
  final String score;
  const WahScore({
    required this.imgUrl,
    required this.score,
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
          //TODO:add score on image
          Stack(
            children: [
              Image.network(
                imgUrl,
                height: 220.h,
                width: 220.h,
              ),
              Positioned(
                bottom: 55.h,
                left: 95.h,
                child: Text(score,
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.boldTextColor)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.textgreyColor),
          const SizedBox(height: 16),
          if (false)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.textgreyColor1,
                  radius: 12,
                  child: Image.asset(AppImages.greenSmily),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  flex: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "You are doing very good!",
                        style: TextStyle(
                            color: AppColors.textgreyColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "Your score is amongst the top hosts in your area!",
                        style: TextStyle(
                            color: AppColors.textgreyColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(25)),
                  child: const Text("Inspect"),
                )
              ],
            )
        ],
      ),
    );
  }
}
