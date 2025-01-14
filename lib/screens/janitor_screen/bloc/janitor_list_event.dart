import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:Woloo_Smart_hygiene/screens/task_list/data/model/create_task_model.dart';

abstract class JanitorsListEvent extends Equatable {
  const JanitorsListEvent();
}

class GetAllJanitors extends JanitorsListEvent {
  final String? cluster_id;
  final String? startDate;
  final String? endDate;

  const GetAllJanitors({this.cluster_id, this.endDate, this.startDate});

  @override
  List<Object?> get props => [cluster_id, Random().nextInt(100)];
}

class ReassignTask extends JanitorsListEvent {
  final List<String> id;
  final String janitor_id;
  final bool? fromReassign;
  final bool? isRejected;

  const ReassignTask({
    required this.id,
    required this.janitor_id,
    required this.fromReassign,
    required this.isRejected
  });

  @override
  List<Object?> get props => [id, janitor_id, Random().nextInt(100), fromReassign];
}
