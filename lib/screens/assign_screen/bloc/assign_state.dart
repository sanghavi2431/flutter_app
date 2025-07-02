import 'dart:math';

import 'package:woloo_smart_hygiene/screens/assign_screen/data/janitor_list_model.dart';
import 'package:equatable/equatable.dart';

import '../../../core/network/failure.dart';
import '../../dashboard/data/model/dashboard_model_class.dart';
import '../../janitor_screen/data/model/reassign_janitor_model.dart';
// import '../../janitor_screen/data/model/Janitor_list_model.dart';

abstract class AssignState extends Equatable {
  const AssignState();
}



class JanitorTaskInitial extends AssignState {
  @override
  List<Object> get props => [];
}

class JanitorTaskLoading extends AssignState {
  @override
  List<Object> get props => [];
}

class GetJanitorTaskDataSuccess extends AssignState {
  final List<DashboardModelClass> data;

  const GetJanitorTaskDataSuccess({required this.data});

  @override
  List<Object?> get props => [data, Random().nextInt(100)];
}

class GetJanitorTaskError extends AssignState {
  final Failure error;
  const GetJanitorTaskError({required this.error});

  @override
  List<Object> get props => [error];
}



class JanitorListLoading extends AssignState {
  @override
  List<Object> get props => [];
}


class GetJanitorListDataSuccess extends AssignState {
  final List<JanitorListModel> data;

  const GetJanitorListDataSuccess({required this.data});

  @override
  List<Object?> get props => [data, Random().nextInt(100)];
}

class GetJanitorListError extends AssignState {
  final Failure error;
  const GetJanitorListError({required this.error});

  @override
  List<Object> get props => [error];
}


class AssignTaskLoading extends AssignState {
  @override
  List<Object> get props => [];
}

class AssignTaskDataSuccess extends AssignState {
  final ReassignJanitorModel data;
  const AssignTaskDataSuccess({required this.data});

  @override
  List<Object?> get props => [data, Random().nextInt(100)];
}

class AssignTaskError extends AssignState {
  final Failure error;
  const AssignTaskError({required this.error});

  @override
  List<Object> get props => [error];
}



