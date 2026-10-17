import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/task_monitoring_card.dart';

import '../../../janitorial_services/model/get_task_dashboard_data.dart' hide TaskStatusDistribution;
import '../../../janitorial_services/screens/task_monitoring_view.dart';
import '../../../utils/app_color.dart';
import '../dashbaord/data/model/dashboard_task_model.dart';

class TaskMonitoringSection extends StatelessWidget {

  final List<TaskMonitoring>? tasks;
  final TaskStatusDistribution? taskStatusDistribution;
  final DashbaordModel? taskDashboardData;


  const TaskMonitoringSection({super.key,
    required this.tasks,
    this.taskStatusDistribution,
    this.taskDashboardData

  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with Title and View All button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Semantics(
              label: "task monitoring",
              value: "header",
              child:
            Text(
              key: ValueKey("task monitoring header"),
              "Task Monitoring",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.appBarTitleColor,
              ),
            ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TaskMonitoringScreen(
                          taskMonitoring: tasks,
                          taskStatusDistribution: taskStatusDistribution,
                          taskDashboardData: taskDashboardData,
                        ),
                  ),
                );
              },
              child:
              Semantics(
                label: "task monitoring",
                value: "view all",
                child:
              Text(
                key: ValueKey("view all"),
                "View All",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Show only first 3 task cards (non-scrollable)
        if (tasks == null || tasks!.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child:
    Semantics(
    label: "Task monitoring",
    value: "No tasks",
    child:
              Text(
                key: ValueKey("No task"),
                "No tasks available",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
    ),
            ),
          )
        else
          Column(
            children: [
              ...(tasks!.take(2).map((task) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TaskCard( task: task,),
                );
              }).toList()),
            ],
          ),
      ],
    );
  }
}