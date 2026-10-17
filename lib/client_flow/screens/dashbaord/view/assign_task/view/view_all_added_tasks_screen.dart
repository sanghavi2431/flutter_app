import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/bloc/dashboard_bloc.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/bloc/dashboard_event.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/bloc/dashboard_state.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/controller/dashbaord_controller.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/task_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/tasklist_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/tasktime_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/assign_task/widgets/added_tasks_from_api_card.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';

/// Filters to unsaved [taskId] == 0 rows for [AssignTasksScreen] / [ViewAllAddedTasksScreen].
///
/// Two session rows are only treated as duplicates when **time, task ids, days, and
/// janitor** all match. Same clock range with **different days** (or different buddy)
/// must stay separate — the old logic only compared time + task ids, so two adds with
/// the same slot but different days disappeared from Added Tasks.
List<TaskTimeModel> uniqueSessionTasksFromController(
  DashBoardController dash,
) {
  bool sameDays(TaskTimeModel a, TaskTimeModel b) {
    final da = a.days;
    final db = b.days;
    if (da == null && db == null) return true;
    if (da == null || db == null) return false;
    if (da.length != db.length) return false;
    final sa = da.map((d) => d.toLowerCase()).toSet();
    final sb = db.map((d) => d.toLowerCase()).toSet();
    return sa.length == sb.length && sa.every((d) => sb.contains(d));
  }

  bool sameTaskIds(TaskTimeModel a, TaskTimeModel b) {
    if (a.taskIds == null && b.taskIds == null) return true;
    if (a.taskIds == null || b.taskIds == null) return false;
    if (a.taskIds!.length != b.taskIds!.length) return false;
    return a.taskIds!.every((id) => b.taskIds!.contains(id)) &&
        b.taskIds!.every((id) => a.taskIds!.contains(id));
  }

  final List<TaskTimeModel> uniqueTasks = [];
  for (final task in dash.taskTimeModel) {
    if (task.taskId != 0) continue;
    final isDuplicate = uniqueTasks.any((existing) {
      if (existing.janitorId != task.janitorId) return false;
      final timeMatches =
          existing.startTime.hour == task.startTime.hour &&
              existing.startTime.minute == task.startTime.minute &&
              existing.endTime.hour == task.endTime.hour &&
              existing.endTime.minute == task.endTime.minute;
      if (!timeMatches) return false;
      if (!sameDays(existing, task)) return false;
      if (!sameTaskIds(existing, task)) return false;
      return true;
    });
    if (!isDuplicate) {
      uniqueTasks.add(task);
    }
  }
  return uniqueTasks;
}

/// Full-screen list: session (unsaved) tasks + getAllUser / [GetAllJanitorEvent].
class ViewAllAddedTasksScreen extends StatefulWidget {
  final TaskModel? initialModel;
  final bool isLoading;
  final List<TaskDropdownModel> facilityNames;
  final ValueChanged<int> onDeleteTask;

  /// Same session tiles as [AssignTasksScreen]; merged under each janitor in [AddedTasksFromApiCard].
  final Widget Function(TaskTimeModel task) sessionTaskBuilder;

  /// Headers for session-only janitors (pending buddies).
  final Widget Function(int? janitorId) sessionBuddyHeader;

  const ViewAllAddedTasksScreen({
    super.key,
    required this.initialModel,
    required this.isLoading,
    required this.facilityNames,
    required this.onDeleteTask,
    required this.sessionTaskBuilder,
    required this.sessionBuddyHeader,
  });

  @override
  State<ViewAllAddedTasksScreen> createState() =>
      _ViewAllAddedTasksScreenState();
}

class _ViewAllAddedTasksScreenState extends State<ViewAllAddedTasksScreen> {
  final GlobalStorage _globalStorage = GetIt.instance();
  late TaskModel? _model;
  late bool _loading;

  @override
  void initState() {
    super.initState();
    _model = widget.initialModel;
    _loading = widget.isLoading;
  }

  Future<void> _onRefresh() async {
    final idStr = _globalStorage.getClientId();
    if (idStr.isEmpty) return;
    final clientId = int.tryParse(idStr);
    if (clientId == null) return;
    setState(() => _loading = true);
    context.read<ClientDashBoardBloc>().add(
          GetAllJanitorEvent(clientId: clientId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClientDashBoardBloc, DashboardState>(
      listener: (context, state) {
        if (state is GetAllJanitor) {
          setState(() {
            _model = state.taskModel;
            _loading = false;
          });
        } else if (state is DashboarError) {
          setState(() => _loading = false);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('All Tasks'),
          backgroundColor: AppColors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: Obx(() {
            final dash = Get.find<DashBoardController>();
            final tasks = uniqueSessionTasksFromController(dash);
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: AddedTasksFromApiCard(
                model: _model,
                isLoading: _loading,
                facilityNames: widget.facilityNames,
                onDeleteTask: widget.onDeleteTask,
                onViewAllTasks: () {},
                showInlineHeader: false,
                showViewAllLink: false,
                suppressEmptyPlaceholder: tasks.isNotEmpty,
                sessionTasks: tasks,
                sessionTaskBuilder: widget.sessionTaskBuilder,
                sessionBuddyHeader: widget.sessionBuddyHeader,
              ),
            );
          }),
        ),
      ),
    );
  }
}
