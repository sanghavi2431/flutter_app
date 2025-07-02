import 'dart:math';

import 'package:woloo_smart_hygiene/core/model/app_launch_model.dart';
import 'package:woloo_smart_hygiene/core/network/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:woloo_smart_hygiene/screens/dashboard/data/model/attendance_model.dart';
import 'package:woloo_smart_hygiene/screens/dashboard/data/model/dashboard_model_class.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
}

class ClockInInitial extends DashboardState {
  @override
  List<Object> get props => [];
}

class ClockInLoading extends DashboardState {
  final String message;
  const ClockInLoading({required this.message});

  @override
  List<Object> get props => [Random().nextInt(100)];
}

class ClockOutLoading extends DashboardState {
  final String message;
  const ClockOutLoading({required this.message});

  @override
  List<Object> get props => [Random().nextInt(100)];
}

class ClockInSuccessful extends DashboardState {
  final AttendanceModel attendanceModel;
  const ClockInSuccessful({
    required this.attendanceModel,
  });
  @override
  List<Object> get props => [attendanceModel];
}

class ClockOutSuccessful extends DashboardState {
  final AttendanceModel attendanceModel;
  const ClockOutSuccessful({
    required this.attendanceModel,
  });

  @override
  List<Object> get props => [attendanceModel];
}

class ClockInError extends DashboardState {
  final Failure error;
  final String? message;

  const ClockInError({required this.error, this.message});

  @override
  List<Object> get props => [error];
}

class ClockOutError extends DashboardState {
  final Failure error;
  final String? message;

  const ClockOutError({required this.error, this.message});

  @override
  List<Object> get props => [error];
}

class DashboardInitial extends DashboardState {
  @override
  List<Object> get props => [];
}

class DashboardLoading extends DashboardState {
  @override
  List<Object> get props => [];
}

class GetDashboardDataSuccess extends DashboardState {
  final List<DashboardModelClass> data;

  const GetDashboardDataSuccess({required this.data});

  @override
  List<Object?> get props => [data, Random().nextInt(100)];
}

class DashboardError extends DashboardState {
  final Failure error;
  const DashboardError({required this.error});

  @override
  List<Object> get props => [error];
}

class UpdateStatusInitial extends DashboardState {
  @override
  List<Object> get props => [];
}

class UpdateStatusLoading extends DashboardState {
  final String message;
  const UpdateStatusLoading({required this.message});

  @override
  List<Object> get props => [Random().nextInt(100)];
}

class UpdateStatusSuccessful extends DashboardState {
  @override
  List<Object> get props => [];
}

class UpdateStatusError extends DashboardState {
  final Failure error;
  const UpdateStatusError({required this.error});

  @override
  List<Object> get props => [error];
}

class AppLaunchLoading extends DashboardState {
  final String message;
  const AppLaunchLoading({required this.message});
  @override
  List<Object?> get props => [message];
}

class AppLaunchSuccess extends DashboardState {
  final AppLaunchModel data;
  const AppLaunchSuccess({required this.data});
  @override
  List<Object?> get props => [data];
}

class AppLaunchError extends DashboardState {
  final Failure error;
  const AppLaunchError({required this.error});

  @override
  List<Object?> get props => [error];
}
