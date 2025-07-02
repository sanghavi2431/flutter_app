import 'dart:math';

import 'package:woloo_smart_hygiene/screens/janitor_details_screen/network/janitor_attendance_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../attendance_history_screen/data/model/attendance_history_model.dart';
import '../../attendance_history_screen/data/model/month_list_model.dart';

part 'janitor_attendance_state.dart';

class JanitorAttendanceCubit extends Cubit<JanitorAttendanceState> {
  final JanitorAttendanceService _service = JanitorAttendanceService(dio: GetIt.instance());
  final int _janiId;
  JanitorAttendanceCubit(this._janiId) : super(const JanitorAttendanceInitial([], [], null, null));

  void init() async {
    try {
      emit(const JanitorAttendanceLoading([], [], null, null));
      final months = await _service.getAllMonths(_janiId);
      if (months.isEmpty) throw "No attendance found!";

      final attendance = await _service.getAllHistory(month: months.last.month ?? "", year: months.last.year ?? "", janiId: _janiId);
      emit(JanitorAttendanceSuccess(months, attendance, months.last, null));
    } catch (e) {
      Logger().e(e);
    }
  }

  void getMonth(MonthListModel month) async {
    try {
      emit(JanitorAttendanceLoading(state.months, state.attendance, month, null));
      final attendance = await _service.getAllHistory(month: month.month ?? "", year: month.year ?? "", janiId: _janiId);
      emit(JanitorAttendanceSuccess(state.months, attendance, month, null));
    } catch (e) {
      Logger().e(e);
    }
  }

  void sort(String? sortBy) async {
    try {
      emit(JanitorAttendanceLoading(state.months, state.attendance, state.selected, sortBy));
      if (sortBy == null) {
        getMonth(state.selected!);
        return;
      }
      state.attendance.sort((a, b) {
        if (a.attendance == sortBy && b.attendance != sortBy) {
          return -1; // a comes first
        } else if (a.attendance?.toLowerCase() != sortBy && b.attendance?.toLowerCase() == sortBy) {
          return 1; // b comes first
        } else {
          return 0; // maintain original order
        }
      });
      emit(JanitorAttendanceSuccess(state.months, state.attendance, state.selected, sortBy));
    } catch (e) {
      Logger().e(e);
    }
  }
}
