
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../janitorial_services/screens/host_dashboard_screen.dart';
import '../utils/app_color.dart';
import 'multiple_widgets.dart';

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
