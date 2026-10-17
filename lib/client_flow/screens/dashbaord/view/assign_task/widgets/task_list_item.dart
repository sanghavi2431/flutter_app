import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/controller/dashbaord_controller.dart';


class TaskListItem extends StatelessWidget {
  final int index;
  final DashBoardController dashController;

  const TaskListItem({super.key, required this.index, required this.dashController});

  @override
  Widget build(BuildContext context) {
    final task = dashController.taskTimeModel[index];
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(task.startTime.format(context)),
          Text(task.endTime.format(context)),
          GestureDetector(
            onTap: () {
              dashController.taskTimeModel.removeAt(index);
            },
            child: const Icon(Icons.delete, color: Colors.red),
          )
        ],
      ),
      children: [
        Wrap(
          children: task.taskName!
              .map((name) => Text("$name, ", style: const TextStyle(fontSize: 14)))
              .toList(),
        ),
      ],
    );
  }
}
