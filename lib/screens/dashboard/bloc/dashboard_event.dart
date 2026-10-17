import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class MarkAttendance extends DashboardEvent {
  final String type;
  final List<double> locations;
  const MarkAttendance({required this.type, required this.locations});

  @override
  List<Object?> get props => [type, locations];
}

class GetTaskTamplates extends DashboardEvent {
  /// When false, reuse [DashController] in-memory tasks if already loaded.
  final bool forceRefresh;

  const GetTaskTamplates({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class DashboardLoadingEvent extends DashboardEvent {
  const DashboardLoadingEvent();

  @override
  List<Object?> get props => [];
}

class DashboardErrorEvent extends DashboardEvent {
  const DashboardErrorEvent();

  @override
  List<Object?> get props => [];
}

class UpdateStatus extends DashboardEvent {
  final String id;
  final String status;
  const UpdateStatus({required this.id, required this.status});

  @override
  List<Object?> get props => [id, status];
}

class CheckAttendance extends DashboardEvent {
  @override
  List<Object?> get props => [];
}
