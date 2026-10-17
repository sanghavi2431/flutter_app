import 'package:woloo_smart_hygiene/core/network/failure.dart';
import 'package:woloo_smart_hygiene/screens/task_list/data/model/task_list_model.dart';
import 'package:equatable/equatable.dart';

abstract class TaskListState extends Equatable {
  const TaskListState();
}

class GetTasksInitial extends TaskListState {
  @override
  List<Object> get props => [];
}

class GetTasksLoading extends TaskListState {
  @override
  List<Object> get props => [];
}

class GetTasksSuccess extends TaskListState {
  final TaskListModel data;

  const GetTasksSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetTasksError extends TaskListState {
  final String error;
  const GetTasksError({required this.error});

  @override
  List<Object> get props => [error];
}

class SubmitTasksInitial extends TaskListState {
  @override
  List<Object> get props => [];
}

class SubmitTasksLoading extends TaskListState {
  @override
  List<Object> get props => [];
}

class SubmitTasksSuccess extends TaskListState {
  final String data;

  const SubmitTasksSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class SubmitTasksError extends TaskListState {
  final Failure error;
  const SubmitTasksError({required this.error});

  @override
  List<Object> get props => [error];
}
