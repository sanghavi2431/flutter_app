import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/screens/attendance_history_screen/bloc/history_list_event.dart';
import 'package:woloo_smart_hygiene/screens/attendance_history_screen/bloc/history_list_state.dart';
import 'package:woloo_smart_hygiene/screens/attendance_history_screen/data/network/attendance_history_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../core/network/error_handler.dart';
import '../../../core/network/failure.dart';

class HistoryListBloc extends Bloc<HistoryListEvent, HistoryListState> {
  final AttendanceHistoryService attendanceHistoryService =
      AttendanceHistoryService(dio: GetIt.instance());

  HistoryListBloc() : super(HistoryListInitial()) {
    on<HistoryListEvent>((event, emit) {});
    on<GetAllHistory>(_mapGetAllHistoryToState);
    on<GetAllMonths>(_mapGetAllMonthsToState);
  }

  FutureOr<void> _mapGetAllHistoryToState(
      GetAllHistory event, Emitter<HistoryListState> emit) async {
    try {
      emit(HistoryListLoading());
      var data = await attendanceHistoryService.getAllHistory(
        month: event.month,
        year: event.year,
      );

      emit(HistoryListSuccess(data: data));
    } catch (e) {
      emit(HistoryListError(error: ErrorHandler.handle(e).failure));
    }
  }

  // FutureOr<void> _mapGetAllMonthsToState(
  //     GetAllMonths event, Emitter<HistoryListState> emit) async {
  //   try {
  //     emit(MonthListLoading());
  //     var data = await attendanceHistoryService.getAllMonths();
  //     emit(MonthListSuccess(data: data));
  //   }
  //   catch (e) {
  //     emit(MonthListError(error: ErrorHandler.handle(e).failure));
  //   }
  // }

  FutureOr<void> _mapGetAllMonthsToState(
    GetAllMonths event,
    Emitter<HistoryListState> emit,
  ) async {
    try {
      emit(MonthListLoading());

      final data = await attendanceHistoryService.getAllMonths();

      ///  If results list empty/null
      if ((data as List).isEmpty) {
        emit(
          MonthListEmpty(
            error: Failure(200, "noHistoryFound".tr()),
          ),
        );
        return;
      }

      /// Success only if list has data
      emit(MonthListSuccess(data: data));
    } catch (e) {
      debugPrint("Coming to catch of month list");
      emit(MonthListError(error: ErrorHandler.handle(e).failure));
    }
  }
}
