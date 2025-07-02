import 'package:equatable/equatable.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/dashboard_task_model.dart';
import 'package:woloo_smart_hygiene/janitorial_services/model/host_dashboard_screen.dart';
import 'package:woloo_smart_hygiene/janitorial_services/screens/bloc/iot_bloc.dart';
import 'package:woloo_smart_hygiene/janitorial_services/screens/network/iot_services.dart';

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
  const IotSuccess(
      {required this.taskStatusDistribution, required this.dashboardData});
  @override
  List<Object> get props => [dashboardData, taskStatusDistribution];
}

class HostDashboardSuccess extends IotState {
  final HostDashboardHome hostDashboardHome;
  const HostDashboardSuccess({required this.hostDashboardHome});
  @override
  List<Object> get props => [hostDashboardHome];
}

class GenerateSummarySuccess extends IotState {
  final GeneratedAiSummery summaryData;
  const GenerateSummarySuccess({required this.summaryData});
  @override
  List<Object> get props => [summaryData];
}
