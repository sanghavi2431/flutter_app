import 'dart:async';

import 'package:Woloo_Smart_hygiene/screens/task_list/bloc/tasklist_event.dart';
import 'package:Woloo_Smart_hygiene/screens/task_list/bloc/tasklist_state.dart';
import 'package:Woloo_Smart_hygiene/screens/task_list/data/network/task_list_service.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/network/error_handler.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final TaskListService taskListService =
      TaskListService(dio: GetIt.instance());

  TaskListBloc() : super(GetTasksInitial()) {
    on<TaskListEvent>((event, emit) {});
    on<GetAllTask>(_mapGetAllTasksToState);
    on<SubmitTasks>(_mapSubmitTasksToState);
  }

  FutureOr<void> _mapGetAllTasksToState(
      GetAllTask event, Emitter<TaskListState> emit) async {
    try {
      emit(GetTasksLoading());
      var data = await taskListService.getAllTasks(id: event.id);

      emit(GetTasksSuccess(data: data));
    } catch (e) {
      rethrow;
    }
  }

  FutureOr<void> _mapSubmitTasksToState(
      SubmitTasks event, Emitter<TaskListState> emit) async {
    try {
      emit(SubmitTasksLoading());
      var data = await taskListService.submitTask(
          createTaskModel: event.createTaskModel);
      await taskListService.updateStatus(
          id: event.createTaskModel.allocationId ?? '', status: "3");

      emit(SubmitTasksSuccess(data: data));
    } catch (e) {
      emit(SubmitTasksError(error: ErrorHandler.handle(e).failure    ));
    }
  }
}
