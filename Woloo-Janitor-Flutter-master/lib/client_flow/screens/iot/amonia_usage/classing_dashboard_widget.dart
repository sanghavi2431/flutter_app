import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/facility_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/task_monitoring_section.dart';
import '../../../../core/local/global_storage.dart';
import '../../../../janitorial_services/model/get_task_dashboard_data.dart'
    hide TaskStatusDistribution;
import '../../../../janitorial_services/screens/task_monitoring_view.dart';
import '../../../../screens/dashboard/bloc/dashboard_state.dart'
    hide DashboardState;
import '../../../../utils/app_color.dart';
import '../../dashbaord/bloc/dashboard_bloc.dart';
import '../../dashbaord/bloc/dashboard_event.dart';
import '../../dashbaord/bloc/dashboard_state.dart';
import '../../dashbaord/data/model/dashboard_task_model.dart';
import '../../iot/amonia_usage/quick_stats_view.dart';
import '../../../widgets/chart.dart';
import '../task_monitoring_card.dart';
import '../view/show_task_details_dialog.dart';

class TaskDashboardScreen extends StatefulWidget {
  final int? facilityId;
  final String? clientId;
  final String? planName;
  final String? subscriptionStatus;
  final bool? isFutureSub;
  final ClientDashBoardBloc? clientDashBoardBloc;
  final List<Facility>? facility;
  final int? tabIndex;

  const TaskDashboardScreen({
    super.key,
    this.facilityId,
    this.clientId,
    this.planName,
    this.subscriptionStatus,
    this.clientDashBoardBloc,
    this.facility,
    this.tabIndex,
    this.isFutureSub,
  });

  @override
  State<TaskDashboardScreen> createState() => _TaskDashboardScreenState();
}

class _TaskDashboardScreenState extends State<TaskDashboardScreen> {
  DashbaordModel? _taskDashboardData;
  ClientDashBoardBloc dashBoardBloc = ClientDashBoardBloc();
  Map<String, dynamic>? decodedToken;
  GlobalStorage globalStorage = GetIt.instance();
  String clientId = "";
  List<TaskMonitoring>? _taskMonitoring;
  TaskStatusDistribution? _taskStatusDistribution;
  String? _lastDashboardRequestKey;

  String _dashboardRequestKey({
    required int facilityId,
    required String type,
    required String janitorId,
  }) {
    return "$facilityId|$type|$janitorId|$clientId";
  }

  void _requestTaskDashboard({
    required int facilityId,
    required String type,
    required String janitorId,
  }) {
    // Prevent duplicate requests caused by unrelated rebuild/lifecycle updates.
    final requestKey = _dashboardRequestKey(
      facilityId: facilityId,
      type: type,
      janitorId: janitorId,
    );
    if (_lastDashboardRequestKey == requestKey) {
      return;
    }
    _lastDashboardRequestKey = requestKey;
    dashBoardBloc.add(
      GetDashbaordEvent(
        type: type,
        clientId: clientId,
        janitorId: janitorId,
        locationId: facilityId,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("intit state called");

    print("tab index ${widget.tabIndex}");
    print("facility id ${widget.facility![widget.tabIndex!].id}");

    clientId = globalStorage.getClientId();
    if (widget.facilityId != null) {
      _requestTaskDashboard(
        facilityId: widget.facilityId!,
        type: "today",
        janitorId: "all",
      );
    }
  }

  @override
  void didUpdateWidget(covariant TaskDashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    final int? newFacilityId = widget.facilityId;
    final int? oldFacilityId = oldWidget.facilityId;
    final bool facilityChanged = newFacilityId != oldFacilityId;
    final bool tabChanged = widget.tabIndex != oldWidget.tabIndex;
    final bool contextChanged =
        widget.planName != oldWidget.planName ||
            widget.subscriptionStatus != oldWidget.subscriptionStatus ||
            widget.isFutureSub != oldWidget.isFutureSub;

    if (newFacilityId != null && (facilityChanged || tabChanged || contextChanged)) {
      _requestTaskDashboard(
        facilityId: newFacilityId,
        type: "today",
        janitorId: "all",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("widget facilityId: ${widget.facilityId}");
    return BlocConsumer(
      bloc: dashBoardBloc,
      listener: (context, state) {
        if (state is DashboarLoading) {
          EasyLoading.show(status: state.message);
        }

        if (state is DashbaordTask) {
          EasyLoading.dismiss();

          _taskDashboardData = state.dashbaordModel;
          _taskMonitoring = state.dashbaordModel!.results!.taskMonitoring!;
          final results = state.dashbaordModel?.results;
          if (results?.taskStatusDistribution != null) {
            _taskStatusDistribution = results!.taskStatusDistribution;
          }
          setState(() {});
        }

        if (state is DashboarError) {
          EasyLoading.dismiss();
          //   EasyLoading.showError(state.error);
        }
      },
      builder: (context, state) {
        if (state is DashboarLoading && _taskDashboardData == null) {
          return const Center(child: CircularProgressIndicator());
        }
/*
        if (_taskDashboardData == null) {
          return const Center(child: Text("No Data"));
        }*/

        /*  if ((widget.subscriptionStatus ?? "") == "inactive") {
          return const Center(child: Text("Subscription Expired"));
        }*/

        final wahScoreUrl = _taskDashboardData?.results?.wahScoreUrl;

        if (wahScoreUrl == null || wahScoreUrl.isEmpty) {
          return const SizedBox(); // or show placeholder
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              QuickStatsView(
                statPunctualityValuevalue: _taskDashboardData
                        ?.results?.attendanceMonitoring?.attendancePercentage
                        ?.toString() ??
                    "0",
                taskClosurePendingValue: _taskDashboardData
                        ?.results?.taskClosurePending
                        ?.toString() ??
                    "0",
              ),

              Charts(
                facilityId: widget.facilityId,
                plan: widget.planName,
                status: widget.subscriptionStatus,
                tabIndex: widget.tabIndex,
                facility: widget.facility,
                clientDashBoardBloc: widget.clientDashBoardBloc,
                isFutureSub: widget.isFutureSub ?? false,
              ),
              const SizedBox(height: 20),
              TaskMonitoringSection(
                tasks: _taskMonitoring,
                taskStatusDistribution: _taskStatusDistribution,
                taskDashboardData: _taskDashboardData,
              ),
              const SizedBox(height: 20),
              const SizedBox(
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hygiene Score",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Image.network(
                          wahScoreUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const SizedBox(
                              height: 180,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image_not_supported);
                          },
                        ),
                        // Score text positioned 30px from bottom
                        Positioned(
                          bottom: 90,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              "699",
                              // Placeholder text, will be replaced with actual value later
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(0, 1),
                                    blurRadius: 3,
                                    color: Colors.black.withValues(alpha: 0.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 20,),
            ],
          ),
        );
      },
    );
  }
}
