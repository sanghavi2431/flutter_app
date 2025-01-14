import 'package:Woloo_Smart_hygiene/core/network/failure.dart';
import 'package:Woloo_Smart_hygiene/screens/report_issue_screen/data/model/Cluster_dropdown_model.dart';
import 'package:Woloo_Smart_hygiene/screens/report_issue_screen/data/model/Janitor_dropdown_model.dart';
import 'package:equatable/equatable.dart';

import 'package:Woloo_Smart_hygiene/screens/report_issue_screen/data/model/report_issue_model.dart';
import 'package:Woloo_Smart_hygiene/screens/report_issue_screen/data/model/task_names_model.dart';
import 'package:Woloo_Smart_hygiene/screens/report_issue_screen/data/model/facility_dropdown_model.dart';
import 'package:Woloo_Smart_hygiene/screens/task_list/data/model/task_list_model.dart';

abstract class ReportIssueState extends Equatable {
  const ReportIssueState();
}

class ReportIssueInitial extends ReportIssueState {
  @override
  List<Object> get props => [];
}

class GetClustersDropdownLoading extends ReportIssueState {
  @override
  List<Object> get props => [];
}

class GetClustersDropdownSuccess extends ReportIssueState {
  final List<ClusterDropdownModel> data;

  const GetClustersDropdownSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetClustersDropdownError extends ReportIssueState {
  final Failure error;
  const GetClustersDropdownError({required this.error});

  @override
  List<Object> get props => [error];
}

class GetFacilityDropdownLoading extends ReportIssueState {
  @override
  List<Object> get props => [];
}

class GetFacilityDropdownSuccess extends ReportIssueState {
  final List<FacilityDropdownModel> data;

  const GetFacilityDropdownSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetFacilityDropdownError extends ReportIssueState {
  final Failure error;
  const GetFacilityDropdownError({required this.error});

  @override
  List<Object> get props => [error];
}

class GetTasksDropdownLoading extends ReportIssueState {
  @override
  List<Object> get props => [];
}

class GetTasksDropdownSuccess extends ReportIssueState {
  final List<TaskNamesModels> data;

  const GetTasksDropdownSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetTasksDropdownError extends ReportIssueState {
  final Failure error;
  const GetTasksDropdownError({required this.error});

  @override
  List<Object> get props => [error];
}

class GetJanitorsDropdownLoading extends ReportIssueState {
  @override
  List<Object> get props => [];
}

class GetJanitorsDropdownSuccess extends ReportIssueState {
  final List<JanitorDropdownModel> data;

  const GetJanitorsDropdownSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetJanitorsDropdownError extends ReportIssueState {
  final Failure error;
  const GetJanitorsDropdownError({required this.error});

  @override
  List<Object> get props => [error];
}

class GetTasksListInitial extends ReportIssueState {
  @override
  List<Object> get props => [];
}

class GetTasksListLoading extends ReportIssueState {
  @override
  List<Object> get props => [];
}

class GetTasksListSuccess extends ReportIssueState {
  final TaskListModel data;

  const GetTasksListSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetTasksListError extends ReportIssueState {
  final String error;
  const GetTasksListError({required this.error});

  @override
  List<Object> get props => [error];
}

class ReportIssueLoading extends ReportIssueState {
  @override
  List<Object> get props => [];
}

class ReportIssueSuccess extends ReportIssueState {
  ReportIssueModel data;
  ReportIssueSuccess({required this.data});
  @override
  List<Object?> get props => [data];
}

class ReportIssueError extends ReportIssueState {
  final Failure error;
  const ReportIssueError({required this.error});

  @override
  List<Object> get props => [error];
}
