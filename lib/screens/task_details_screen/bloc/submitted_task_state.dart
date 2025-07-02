import 'dart:math';

import 'package:woloo_smart_hygiene/core/network/failure.dart';
import 'package:woloo_smart_hygiene/screens/task_details_screen/data/model/submitted_tasks_model.dart';
import 'package:equatable/equatable.dart';

abstract class SubmittedTaskState extends Equatable {
  const SubmittedTaskState();
}

class GetSubmittedTasksInitial extends SubmittedTaskState {
  @override
  List<Object> get props => [];
}

class GetSubmittedTasksLoading extends SubmittedTaskState {
  @override
  List<Object> get props => [];
}

class GetSubmittedTasksSuccess extends SubmittedTaskState {
 final  SubmittedTaskModel data;

 const GetSubmittedTasksSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetSubmittedTasksError extends SubmittedTaskState {
  final Failure error;
  const GetSubmittedTasksError({required this.error});

  @override
  List<Object> get props => [error];
}

class UpdateStatusLoading extends SubmittedTaskState {
  final String message;
  const UpdateStatusLoading({required this.message});

  @override
  List<Object> get props => [Random().nextInt(100)];
}

class UpdateStatusSuccessful extends SubmittedTaskState {
  dynamic data;
  UpdateStatusSuccessful({this.data});
  @override
  List<Object> get props => [data!];
}

class UpdateStatusError extends SubmittedTaskState {
  final Failure error;
  const UpdateStatusError({required this.error});

  @override
  List<Object> get props => [error];
}
