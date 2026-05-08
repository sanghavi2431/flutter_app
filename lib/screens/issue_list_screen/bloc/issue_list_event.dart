import 'package:equatable/equatable.dart';

abstract class IssueListEvent extends Equatable {
  const IssueListEvent();
}

class GetAllIssues extends IssueListEvent {
  final int supervisorId;

  const GetAllIssues({required this.supervisorId});

  @override
  List<Object?> get props => [supervisorId];
}
