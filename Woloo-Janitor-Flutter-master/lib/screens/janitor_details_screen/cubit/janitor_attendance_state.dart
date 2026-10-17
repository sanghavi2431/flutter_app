part of 'janitor_attendance_cubit.dart';

class JanitorAttendanceState extends Equatable {
  final List<MonthListModel> months;
  final List<AttendanceHistoryModel> attendance;
  final MonthListModel? selected;
  final String? sortBy;
  final String? error;
  const JanitorAttendanceState(
      this.months, this.attendance, this.selected, this.sortBy, this.error);

  @override
  List<Object> get props => [Random()];
}

class JanitorAttendanceInitial extends JanitorAttendanceState {
  const JanitorAttendanceInitial(super.months, super.attendance, super.selected,
      super.sortBy, super.error);
}

class JanitorAttendanceLoading extends JanitorAttendanceState {
  const JanitorAttendanceLoading(super.months, super.attendance, super.selected,
      super.sortBy, super.error);
}

class JanitorAttendanceSuccess extends JanitorAttendanceState {
  const JanitorAttendanceSuccess(super.months, super.attendance, super.selected,
      super.sortBy, super.error);
}

class JanitorAttendanceError extends JanitorAttendanceState {
  const JanitorAttendanceError(super.months, super.attendance, super.selected,
      super.sortBy, super.error);
}
