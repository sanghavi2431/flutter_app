import 'package:equatable/equatable.dart';
import 'package:Woloo_Smart_hygiene/screens/task_list/data/model/create_task_model.dart';

abstract class IssueListEvent extends Equatable {
  const IssueListEvent();
}

class GetAllIssues extends IssueListEvent {
  final int supervisorId;

  const GetAllIssues({required this.supervisorId});

  @override
  List<Object?> get props => [supervisorId];
}
