import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/dashboard_task_model.dart';

class IotLogs extends StatelessWidget {
  final TaskStatusDistribution? taskStatusDistribution;

  const IotLogs({
    super.key,
    this.taskStatusDistribution,
  });

  double _parsePercent(String? value) {
    if (value == null || value.isEmpty) return 0;
    return double.tryParse(value.replaceAll('%', '')) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final data = taskStatusDistribution;

    /// RFC & Rejected % included in facility performance chart

    final accepted = _parsePercent(data?.acceptedPercentage);
    final ongoing = _parsePercent(data?.ongoingPercentage);
    final completed = _parsePercent(data?.completedPercentage);
    final pending = _parsePercent(data?.pendingPercentage);
    final requestForClosure = _parsePercent((data?.closurePercentage));
    final rejected = _parsePercent((data?.rejectedPercentage));

    final bool isAllZero = accepted == 0 && ongoing == 0 &&
        completed == 0 && pending == 0 && rejected == 0 && requestForClosure == 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Facility Performance",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: PieChart(
              key: ValueKey(taskStatusDistribution?.hashCode),
              PieChartData(
                sections: isAllZero
                    ? [_emptySection()]
                    : _buildSections(
                  accepted: accepted,
                  ongoing: ongoing,
                  completed: completed,
                  pending: pending,
                  requestForClosure: requestForClosure,
                  rejected: rejected,
                  data: data,
                ),
                centerSpaceRadius: 30,
                sectionsSpace: 0,
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PieChartSectionData _emptySection() {
    return PieChartSectionData(
      value: 100,
      color: Colors.cyan[200],
      radius: 32,
      showTitle: false,
    );
  }

  List<PieChartSectionData> _buildSections({
    required double accepted,
    required double ongoing,
    required double completed,
    required double pending,
    required double requestForClosure,
    required double rejected,
    required TaskStatusDistribution? data,
  }) {
    final sections = <PieChartSectionData>[];

    void addSection(double value, Color color, String? label) {
      if (value > 0) {               // skip zeros
        sections.add(
          _section(
            value: value,
            color: color,
            label: label,
          ),
        );
      }
    }

    addSection(accepted, const Color(0xff8BDFFB), data?.acceptedPercentage);
    addSection(ongoing, const Color(0xff33B8E4), data?.ongoingPercentage);
    addSection(completed, const Color(0xffC9F1FF), data?.completedPercentage);
    addSection(pending, const Color(0xff19586C), data?.pendingPercentage);
    addSection(requestForClosure, const Color(0xff208AAC), data?.closurePercentage);
    addSection(rejected, const Color(0xff03171E), data?.rejectedPercentage);

    return sections;
  }

  PieChartSectionData _section({
    required double value,
    required Color color,
    required String? label,
  }) {
    return PieChartSectionData(
      value: value == 0 ? 0.01 : value, // keeps slice invisible but chart stable
      color: color,
      radius: 32,
      showTitle: false,
      badgePositionPercentageOffset: 1.0,
      badgeWidget: value == 0 ? null : _badge(label ?? "0%"),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}































/*import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/dashboard_task_model.dart';
import 'package:woloo_smart_hygiene/injection_container.dart';
import 'package:woloo_smart_hygiene/utils/logger.dart';

class IotLogs extends StatefulWidget {
  final TaskStatusDistribution? taskStatusDistribution;
  // final String avgppmTimeRangeInsights;
  const IotLogs(
      {super.key,
      // required this.avgppmTimeRangeInsights,
      this.taskStatusDistribution});

  @override
  State<IotLogs> createState() => _IotLogsState();

  static Widget _circleLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Helper for task dashboard rows
  static Widget _taskRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Helper for IOT Product Card
  static Widget _iotProductCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF6B6B6B),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Regular badge
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  "Regular",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "IOT Product",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Facility:\nWomen's Powder Room",
            style: TextStyle(color: Colors.white, fontSize: 8.sp),
          ),
          const SizedBox(height: 4),
          Text(
            "Tasks:\nCleaning is required",
            style: TextStyle(color: Colors.white, fontSize: 8.sp),
          ),
          const SizedBox(height: 4),
          Text(
            "Date & Time:\n11 Jul 2024 | 12:55:41 PM",
            style: TextStyle(color: Colors.white, fontSize: 8.sp),
          ),
          const Divider(color: Colors.lightBlueAccent, thickness: 2),
          const SizedBox(height: 4),
          Text(
            "Assign To:\nSakshi Sakshi",
            style: TextStyle(color: Colors.white, fontSize: 8.sp),
          ),
          const SizedBox(
            height: 60,
          ),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  "Regular",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "IOT Product",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Facility:\nWomen's Powder Room",
            style: TextStyle(color: Colors.white, fontSize: 8.sp),
          ),
          const SizedBox(height: 4),
          Text(
            "Tasks:\nCleaning is required",
            style: TextStyle(color: Colors.white, fontSize: 8.sp),
          ),
          const SizedBox(height: 4),
          Text(
            "Date & Time:\n11 Jul 2024 | 12:55:41 PM",
            style: TextStyle(color: Colors.white, fontSize: 8.sp),
          ),
          const Divider(color: Colors.lightBlueAccent, thickness: 2),
          const SizedBox(height: 4),
          Text(
            "Assign To:\nSakshi Sakshi",
            style: TextStyle(color: Colors.white, fontSize: 8.sp),
          ),
        ],
      ),
    );
  }
}

class _IotLogsState extends State<IotLogs> {
  TaskStatusDistribution? data;

  @override
  void initState() {
    super.initState();
    // iotBloc.add(const GetHostDashboardData(woloo_id: "woloo_id"));
    // _fetchDashboardData();
    print("task didsd ${widget.taskStatusDistribution}");
    update();
  }

  update() {
    data = widget.taskStatusDistribution;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow:  [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2), // Shadow color
              spreadRadius: 1, // How wide the shadow should spread
              blurRadius: 10, // The blur effect of the shadow
              offset: const Offset(0, 0), // No offset for shadow on all sides
            ),
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Facility Performance",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: (double.parse((data?.acceptedPercentage ?? "10")
                            .replaceAll("%", "")) ==
                        0 &&
                    double.parse((data?.ongoingPercentage ?? "10")
                            .replaceAll("%", "")) ==
                        0 &&
                    double.parse((data?.completedPercentage ?? "10")
                            .replaceAll("%", "")) ==
                        0 &&
                    double.parse((data?.pendingPercentage ?? "10")
                            .replaceAll("%", "")) ==
                        0)
                ? PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: double.parse(100.toString()
                              // (data?.acceptedPercentage ?? "0")
                              //     .replaceAll("%", ""),
                              ),
                          color: Colors.cyan[200],
                          radius: 32,
                          showTitle: false,
                          // title: data?.acceptedPercentage ?? "0",
                          badgePositionPercentageOffset: 1.0,
                          badgeWidget: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              // borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              data?.acceptedPercentage ?? "0",
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                      centerSpaceRadius: 30,
                      sectionsSpace: 0,
                      borderData: FlBorderData(show: false),
                    ),
                  )
                : PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: double.parse(
                            (data?.acceptedPercentage ?? "0").replaceAll("%", ""),
                          ),
                          color: Colors.cyan[200],
                          radius: 32,
                          showTitle: false,
                          // title: data?.acceptedPercentage ?? "0",
                          badgePositionPercentageOffset: 1.0,
                          badgeWidget: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              // borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              data?.acceptedPercentage ?? "0",
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        PieChartSectionData(
                          value: double.parse(
                            (data?.ongoingPercentage ?? "0")
                                .replaceAll("%", ""),
                          ),
                          color: Colors.lightBlueAccent,
                          radius: 32,
                          showTitle: false,
                          badgePositionPercentageOffset: 1.0,
                          badgeWidget: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              // borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              data?.ongoingPercentage ?? "0",
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        PieChartSectionData(
                          value: double.parse(
                            (data?.completedPercentage ?? "0")
                                .replaceAll("%", ""),
                          ),
                          color: Colors.cyan[800],
                          radius: 32,
                          badgePositionPercentageOffset: 1.0,
                          showTitle: false,
                          badgeWidget: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              // borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              data?.completedPercentage ?? "0",
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        PieChartSectionData(
                          value: double.parse(
                            (data?.pendingPercentage ?? "0").replaceAll("%", ""),
                          ),
                          color: Colors.cyan[400],
                          radius: 32,
                          showTitle: false,
                          badgePositionPercentageOffset: 1.0,
                          badgeWidget: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              // borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              data?.pendingPercentage ?? "0",
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        if (false)
                          PieChartSectionData(
                            value: 20,
                            color: Colors.cyan[100],
                            radius: 32,
                            showTitle: false,
                          ),
                      ],
                      centerSpaceRadius: 30,
                      sectionsSpace: 0,
                      borderData: FlBorderData(show: false),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}*/
