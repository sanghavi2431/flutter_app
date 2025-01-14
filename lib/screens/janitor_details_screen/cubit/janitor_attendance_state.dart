part of 'janitor_attendance_cubit.dart';

class JanitorAttendanceState extends Equatable {
  final List<MonthListModel> months;
  final List<AttendanceHistoryModel> attendance;
  final MonthListModel? selected;
  final String? sortBy;
  const JanitorAttendanceState(this.months, this.attendance, this.selected, this.sortBy);

  @override
  List<Object> get props => [Random()];
}

class JanitorAttendanceInitial extends JanitorAttendanceState {
  const JanitorAttendanceInitial(super.months, super.attendance, super.selected, super.sortBy);
}

class JanitorAttendanceLoading extends JanitorAttendanceState {
  const JanitorAttendanceLoading(super.months, super.attendance, super.selected, super.sortBy);
}

class JanitorAttendanceSuccess extends JanitorAttendanceState {
  const JanitorAttendanceSuccess(super.months, super.attendance, super.selected, super.sortBy);
}
