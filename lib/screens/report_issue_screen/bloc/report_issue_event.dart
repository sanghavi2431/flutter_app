import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ReportIssueEvent extends Equatable {
  const ReportIssueEvent();
}

class GetAllClustersDropdown extends ReportIssueEvent {
  const GetAllClustersDropdown();

  @override
  List<Object?> get props => [];
}

class GetAllFacilityDropdown extends ReportIssueEvent {
  final int clusterId;

  const GetAllFacilityDropdown({required this.clusterId});

@override
  List<Object?> get props => [];
}

class GetAllTasksDropdown extends ReportIssueEvent {
    final int clusterId;
  const GetAllTasksDropdown( {required this.clusterId});

  @override
  List<Object?> get props => [];
}

class GetAllJanitorsDropdown extends ReportIssueEvent {
  final int clusterId;

  const GetAllJanitorsDropdown({required this.clusterId});

  @override
  List<Object?> get props => [];
}

class GetAllTaskList extends ReportIssueEvent {
  final String id;

  const GetAllTaskList({required this.id});

  @override
  List<Object?> get props => [id];
}

class ReportIssue extends ReportIssueEvent {
  final String template_id;
  final File task_images;
  final int facility_id;
  final int janitor_id;
  final String description;
  final List<String> taskList;

  const ReportIssue(
      {required this.template_id,
      required this.facility_id,
      required this.janitor_id,
      required this.description,
      required this.task_images,
      required this.taskList});

  @override
  List<Object?> get props => [
        template_id,
        facility_id,
        janitor_id,
        description,
        task_images,
        taskList
      ];
}
