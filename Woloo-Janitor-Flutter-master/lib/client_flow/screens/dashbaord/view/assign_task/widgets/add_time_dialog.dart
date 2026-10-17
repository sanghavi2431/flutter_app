import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/controller/dashbaord_controller.dart';
import 'package:get/get.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/tasktime_model.dart';

class AddTimeDialog extends StatefulWidget {
  final int estimatedTime;
  final TimeOfDay? startTime;
  final String? endTime;
  final bool isFromExisting;
  final List<String>? taskName;
  final List<int> taskIds;
  final String facalityName;
  final String facilityType;
  final int? janitorId;

  const AddTimeDialog({
    super.key,
    required this.estimatedTime,
    required this.startTime,
    required this.endTime,
    required this.isFromExisting,
    this.taskName,
    required this.taskIds,
    required this.facalityName,
    required this.facilityType,
    this.janitorId,
  });

  @override
  State<AddTimeDialog> createState() => _AddTimeDialogState();
}

class _AddTimeDialogState extends State<AddTimeDialog> {
  final DashBoardController dashController = Get.find();
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  void initState() {
    super.initState();
    startTime = widget.startTime ?? TimeOfDay.now();
    endTime = TimeOfDay.now(); // default endTime, adjust as needed
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(context: context, initialTime: startTime!);
    if (picked != null) setState(() => startTime = picked);
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(context: context, initialTime: endTime!);
    if (picked != null) setState(() => endTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Task Timing"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text("Start Time"),
            trailing: Text(startTime!.format(context)),
            onTap: _pickStartTime,
          ),
          ListTile(
            title: const Text("End Time"),
            trailing: Text(endTime!.format(context)),
            onTap: _pickEndTime,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
            onPressed: () {
              // Add task timing to controller
              dashController.taskTimeModel.add(
                TaskTimeModel(
                  taskId: widget.taskIds.first,
                  startTime: startTime!,
                  endTime: endTime!,
                  facilityName: widget.facalityName,
                  facilityType: widget.facilityType,
                  taskName: widget.taskName,
                  taskIds: widget.taskIds,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text("Save")),
      ],
    );
  }
}
