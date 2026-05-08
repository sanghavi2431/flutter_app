import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class SubmittedTaskEvent extends Equatable {
  const SubmittedTaskEvent();
}

class GetAllSubmittedTasks extends SubmittedTaskEvent {
  final String allocationId;

  const GetAllSubmittedTasks({required this.allocationId});

  @override
  List<Object?> get props => [allocationId];
}

class UpdateStatus extends SubmittedTaskEvent {
  final String id;
  final int status;
  const UpdateStatus({required this.id, required this.status});

  @override
  List<Object?> get props => [id, status, Random().nextInt(100)];
}
