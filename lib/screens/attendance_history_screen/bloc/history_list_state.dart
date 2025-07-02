import 'package:woloo_smart_hygiene/core/network/failure.dart';
import 'package:woloo_smart_hygiene/screens/attendance_history_screen/data/model/attendance_history_model.dart';
import 'package:woloo_smart_hygiene/screens/attendance_history_screen/data/model/month_list_model.dart';
import 'package:equatable/equatable.dart';

abstract class HistoryListState extends Equatable {
  const HistoryListState();
}

class HistoryListInitial extends HistoryListState {
  @override
  List<Object> get props => [];
}

class HistoryListLoading extends HistoryListState {
  @override
  List<Object> get props => [];
}

class HistoryListSuccess extends HistoryListState {
  final List<AttendanceHistoryModel> data;

  const HistoryListSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class HistoryListError extends HistoryListState {
  final Failure error;
  const HistoryListError({required this.error});

  @override
  List<Object> get props => [error];
}

class MonthListLoading extends HistoryListState {
  @override
  List<Object> get props => [];
}

class MonthListSuccess extends HistoryListState {
  final List<MonthListModel> data;

  const MonthListSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class MonthListError extends HistoryListState {
  final Failure error;
  const MonthListError({required this.error});

  @override
  List<Object> get props => [error];
}
