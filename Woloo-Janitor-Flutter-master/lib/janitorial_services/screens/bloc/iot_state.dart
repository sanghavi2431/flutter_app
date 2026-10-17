import 'package:equatable/equatable.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/dashboard_task_model.dart';
import 'package:woloo_smart_hygiene/janitorial_services/model/host_dashboard_screen.dart';
import 'package:woloo_smart_hygiene/janitorial_services/screens/bloc/iot_bloc.dart';
import 'package:woloo_smart_hygiene/janitorial_services/screens/network/iot_services.dart';
import 'package:woloo_smart_hygiene/janitorial_services/model/get_task_dashboard_data.dart' hide TaskStatusDistribution;

import '../../../client_flow/screens/iot/amonia_usage/iot_reviews_response_model.dart';
import '../../../host/host_details.dart';
import '../../../host/get_hosts_all_revies.dart';
import '../../model/iotdata_model.dart';

abstract class IotState extends Equatable {
  const IotState();
}

class IotInitial extends IotState {
  @override
  List<Object> get props => [];
}

class IotLoading extends IotState {
  final String message;
  const IotLoading({required this.message});

  @override
  List<Object> get props => [message];
}

class IotError extends IotState {
  final String error;
  const IotError({required this.error});

  @override
  List<Object> get props => [error];
}

class IotSuccess extends IotState {
  final DashboardData dashboardData;
  final TaskStatusDistribution taskStatusDistribution;
  final List<TaskMonitoring>? taskMonitoring;

  /// Full task dashboard response (getTaskDashboard API) for passing to widgets
  final DashbaordModel? taskDashboardData;
  final IotReviews? iotReviews;
  const IotSuccess({
    required this.taskStatusDistribution,
    required this.dashboardData,
    this.taskMonitoring,
    this.taskDashboardData,
    this.iotReviews,
  });
  @override
  List<Object?> get props => [dashboardData, taskStatusDistribution, taskMonitoring, taskDashboardData , iotReviews];
}


class IotUpdateSuccess extends IotState {
  final String message;
  const IotUpdateSuccess(
      { required this.message});
  @override
  List<Object> get props => [message];
}

class HostDashboardSuccess extends IotState {
  final HostDashboardHome hostDashboardHome;
  const HostDashboardSuccess({required this.hostDashboardHome});
  @override
  List<Object> get props => [hostDashboardHome];
}

class HostDetailsSuccess extends IotState {
  final HostDetails hostDetailsHome;
  const HostDetailsSuccess({required this.hostDetailsHome});
  @override
  List<Object> get props => [];
}

class HostUpdated extends IotState {
  final dynamic response;
  HostUpdated(this.response);

  @override
  List<Object?> get props => throw UnimplementedError();
}

class HostError extends IotState {
  final String message;
  HostError(this.message);

  @override
  List<Object?> get props => throw UnimplementedError();
}

class GenerateSummarySuccess extends IotState {
  final GeneratedAiSummery summaryData;
  const GenerateSummarySuccess({required this.summaryData});
  @override
  List<Object> get props => [summaryData];
}


class GetReviewListLoading extends IotState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class GetReviewListSuccess extends IotState {
  final GetAllReviewsHost data;

  const GetReviewListSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class GetReviewListError extends IotState {
  final String error;

  const GetReviewListError(this.error);

  @override
  List<Object?> get props => [error];
}
