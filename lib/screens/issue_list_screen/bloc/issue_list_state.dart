import 'package:Woloo_Smart_hygiene/core/network/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:Woloo_Smart_hygiene/screens/issue_list_screen/data/model/Issue_list_model.dart';
import 'package:Woloo_Smart_hygiene/screens/task_list/data/model/task_list_model.dart';

abstract class IssueListState extends Equatable {
  const IssueListState();
}

class IssueListInitial extends IssueListState {
  @override
  List<Object> get props => [];
}

class IssueListLoading extends IssueListState {
  @override
  List<Object> get props => [];
}

class IssueListSuccess extends IssueListState {
  final List<IssueListModel> data;

  const IssueListSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class IssueListError extends IssueListState {
  final Failure error;
  const IssueListError({required this.error});

  @override
  List<Object> get props => [error];
}
