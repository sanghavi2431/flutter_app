import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/view/show_task_details_dialog.dart';
import '../../../janitorial_services/model/get_task_dashboard_data.dart';
import '../../../utils/app_color.dart';

class TaskCard extends StatelessWidget {
  final TaskMonitoring task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    double progress = 0.0;
    Color progressColor = AppColors.pieDataColor1; // Default: Pending
    IconData statusIcon = Icons.access_time;
    Color statusIconColor = AppColors.pieDataColor1; // Default: Pending
    String statusText = task.status ?? "N/A";
    final DateTime? dateTime = task.startTime?.toLocal();

    final String formattedDate = dateTime != null
        ? DateFormat("d MMM").format(dateTime)
        : "";

    final String formattedTime = dateTime != null
        ? DateFormat("h.mm a").format(dateTime)
        : "";

    // Map status to progress and styling
    switch (task.status?.toLowerCase()) {
      case "completed":
        progress = 1.0;
        progressColor = const Color(0xffC9F1FF);
        statusIcon = Icons.check_circle;
        statusIconColor = const Color(0xffC9F1FF);
        break;
      case "on going":
      case "ongoing":
        progress = 0.6;
        progressColor = const Color(0xff33B8E4);
        statusIcon = Icons.access_time;
        statusIconColor = const Color(0xff33B8E4);
        break;
      case "accepted":
        progress = 0.2;
        progressColor = const Color(0xff8BDFFB);
        statusIcon = Icons.access_time;
        statusIconColor = const Color(0xff8BDFFB);
        break;
      case "pending":
        progress = 0.0;
        progressColor = const Color(0xff19586C);
        statusIcon = Icons.access_time;
        statusIconColor = const Color(0xff19586C);
        break;
      default:
        progress = 0.0;
        progressColor = AppColors.pieDataColor1;
        statusIconColor = AppColors.pieDataColor1;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Task Name and View Tasks button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child:
                Semantics(
                  label: "Task monitoring",
                  value: "task name",
                  child:
                Text(
                  key: ValueKey("$task.taskTemplateName"),
                  task.taskTemplateName ?? "N/A",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.appBarTitleColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                ),
              ),
              TextButton(
                onPressed: () {
                  showTaskDetailsDialog(context, task);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child:
                Semantics(
                  label: "Task monitoring",
                  value: "task view",
                  child:
                  Text(
                  key: ValueKey("view tasks"),
                  "View Tasks",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Assigned To section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Semantics(
                    label: "Task monitoring",
                    value: "task outline",
                    child:
                    Icon(
                    key: ValueKey("outline"),
                    Icons.person_outline,
                    size: 16.sp,
                    color: Colors.grey[600],
                  ),
                  ),
                  const SizedBox(width: 6),
                  Semantics(
                    label: "Task monitoring",
                    value: "task assigned to",
                    child:
                    Text(
                    key: ValueKey("assigned to"),
                    task.janitorName ?? "Unassigned",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                  ),
                ],
              ),
              Flexible(
                child:
                Semantics(
                  label: "Task monitoring",
                  value: "task date",
                  child:
                  Text(
                  key: ValueKey("date"),
                  "$formattedDate | $formattedTime",
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress Bar and Status
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Semantics(
                label: "Task monitoring",
                value: "task icon",
                child:
                Icon(
                key: ValueKey("status"),
                statusIcon,
                size: 18.sp,
                color: statusIconColor,
              ),
              ),
              const SizedBox(width: 6),
              Semantics(
                label: "Task monitoring",
                value: "task status text",
                child:
                Text(
                key: ValueKey("status text"),
                statusText,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}