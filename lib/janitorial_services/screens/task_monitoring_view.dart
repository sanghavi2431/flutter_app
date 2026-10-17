import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/dashboard_task_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/task_monitoring_card.dart';
import 'package:woloo_smart_hygiene/janitorial_services/model/get_task_dashboard_data.dart'
    hide TaskStatusDistribution;
import 'package:woloo_smart_hygiene/utils/app_color.dart';

class TaskMonitoringScreen extends StatefulWidget {
  final List<TaskMonitoring>? taskMonitoring;
  final TaskStatusDistribution? taskStatusDistribution;
  final DashbaordModel? taskDashboardData;

  const TaskMonitoringScreen({
    super.key,
    required this.taskMonitoring,
    this.taskStatusDistribution,
    this.taskDashboardData,
  });

  @override
  State<TaskMonitoringScreen> createState() => _TaskMonitoringScreenState();
}

class _TaskMonitoringScreenState extends State<TaskMonitoringScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios_new,
                color: Colors.grey[700],
              ),
              const SizedBox(width: 4),
              Text(
                "Back",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
        leadingWidth: 70,
      ),

      body:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

      /// Header (fixed)
      Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        "Task Monitoring",
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.appBarTitleColor,
        ),
      ),
    ),

    const SizedBox(height: 10),

    /// Scrollable list
    Expanded(
      child: widget.taskMonitoring == null || widget.taskMonitoring!.isEmpty
          ? const Center(
        child: Text(
          "No tasks available",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: widget.taskMonitoring!.length,
        separatorBuilder: (context, index) =>
        const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final task = widget.taskMonitoring![index];
          return TaskCard(task: task);
        },
      ),
    ),
    ]
    ),
    );
  }
}

/*
void _showTaskDetailsDialog(BuildContext context, TaskMonitoring task) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.white,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Task Details',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.appBarTitleColor,
                  ),
                ),
                const SizedBox(height: 16),
                // Task Name
                Text(
                  task.taskTemplateName ?? "N/A",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.appBarTitleColor,
                  ),
                ),
                const SizedBox(height: 16),
                // Scrollable Task List
                if (task.taskNames != null && task.taskNames!.isNotEmpty)
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: task.taskNames!.length,
                      separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin:
                              const EdgeInsets.only(top: 6, right: 12),
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                task.taskNames![index],
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.appBarTitleColor,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "No task items available",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                // Okay Button
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightCyanColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Okay",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}*/
