import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class JanitorsListEvent extends Equatable {
  const JanitorsListEvent();
}

class GetAllJanitors extends JanitorsListEvent {
  final String? clusterId;
  final String? startDate;
  final String? endDate;

  const GetAllJanitors({this.clusterId, this.endDate, this.startDate});

  @override
  List<Object?> get props => [clusterId, Random().nextInt(100)];
}

class ReassignTask extends JanitorsListEvent {
  final List<String> id;
  final String janitorId;
  final bool? fromReassign;
  final bool? isRejected;

  const ReassignTask({
    required this.id,
    required this.janitorId,
    required this.fromReassign,
    required this.isRejected
  });

  @override
  List<Object?> get props => [id, janitorId, Random().nextInt(100), fromReassign];
}
