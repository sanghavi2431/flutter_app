import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/dashboard_task_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/amonia_usage/iot_reviews_response_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/amonia_usage/reviews_section_iot_dashboard.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/amonia_usage/usage_air_quality_header.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/amonia_usage/vice_versa_chart.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/task_monitoring_section.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/janitorial_services/screens/network/iot_services.dart';
import 'package:woloo_smart_hygiene/janitorial_services/screens/pdf/views/dashboard_pdf_builder.dart';
import 'package:woloo_smart_hygiene/janitorial_services/screens/task_monitoring_view.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../client_flow/screens/dashbaord/bloc/dashboard_bloc.dart';
import '../../client_flow/screens/dashbaord/data/model/facility_model.dart';
import '../../client_flow/screens/iot/amonia_usage/alert_section.dart';
import '../../client_flow/screens/iot/amonia_usage/calculate_max_values.dart';
import '../../client_flow/screens/iot/amonia_usage/cards_view.dart';
import '../../client_flow/screens/iot/amonia_usage/iot_dashboard_screen.dart';
import '../../client_flow/screens/iot/amonia_usage/quick_stats_view.dart';
import '../../client_flow/screens/iot/hygiene_score_widget.dart';
import '../../client_flow/screens/iot/summary_popup.dart';
import '../../client_flow/widgets/chart.dart';
import '../../utils/app_images.dart';
import '../model/iotdata_model.dart';
import '../model/get_task_dashboard_data.dart' hide TaskStatusDistribution;
import 'bloc/iot_bloc.dart';
import 'bloc/iot_event.dart';
import 'bloc/iot_state.dart';

class DashboardScreen extends StatefulWidget {
  final int? facilityId;
  final int? janitorId;
  final String? plan;
  final String? status;
  final int? tabIndex;
  final TabController? tabController;
  final List<Facility>? facility;
  final ClientDashBoardBloc? clientDashBoardBloc;
  final bool isFutureSub;
  final Function(VoidCallback)? onExportPdfCallbackSet;
  final Function(Function(String))? onRangeChangeCallbackSet;

  const DashboardScreen({
    super.key,
    this.facility,
    this.clientDashBoardBloc,
    this.janitorId,
    this.facilityId,
    this.plan,
    this.status,
    this.tabController,
    this.tabIndex,
    required this.isFutureSub,
    this.onExportPdfCallbackSet,
    this.onRangeChangeCallbackSet,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  IotBloc iotBloc = IotBloc();
  DashboardData? _dashboardData;
  DashbaordModel? _taskDashboardData;
  final String _error = '';
  List<TaskMonitoring>? _taskMonitoring;
  IotReviews? _iotReviews;
  late List<GraphDataReview> graphList ;
  late List<CommentReview> comments;
  late PeakResult peakOdor;
  late PeakResult peakUsage;
  List<AvgppmTimeRange> timeRangeList = [];
  GlobalStorage globalStorage = GetIt.instance();
  bool isOverlayVisible = false;
  String formattedDate = "";
  String formattedTime ="";
  TaskStatusDistribution? _taskStatusDistribution;
  String _selectedRange = 'Today';
  @override
  void initState() {
    super.initState();
    debugPrint("Facility Id -> ${widget.facilityId}");
    debugPrint("Facility Block name -> ${widget.facility![0].blockName}");
    iotBloc.add(GetIot(
      janitorId: "ALL",
      clientId: globalStorage.getClientId(),
      facilityId: widget.facilityId ?? 0,
      type: 'today',
    ));
    // Register the PDF generation callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.onExportPdfCallbackSet != null) {
        widget.onExportPdfCallbackSet!(() {
          _generateAndSharePDF();
        });
      }
      // Register the range change callback
      if (mounted && widget.onRangeChangeCallbackSet != null) {
        widget.onRangeChangeCallbackSet!((String range) {
          _refreshDashboardData(range);
        });
      }
    });
  }







  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer(
          bloc: iotBloc,
          listener: (context, state) {
            if(EasyLoading.isShow)
              {
                EasyLoading.dismiss();
              }
            print("dssa $state");
            if (state is IotLoading) {
              EasyLoading.show(status: state.message);
            }
            if (state is IotSuccess) {
              // _dashboardData = null;
              EasyLoading.dismiss();
              setState(() {
                _dashboardData = state.dashboardData;
                _taskDashboardData = state.taskDashboardData;
                _taskStatusDistribution = state.taskStatusDistribution;
                _taskMonitoring = state.taskMonitoring;
                _iotReviews = state.iotReviews;
                 graphList = _iotReviews?.results?.graphData ?? [];
                isOverlayVisible =
                    _dashboardData?.results?.isDeviceOff ?? false;

                 comments = graphList.isNotEmpty
                    ? graphList.first.comments ?? []
                    : [];
                // _isLoading = false;
                timeRangeList = _dashboardData!.results!.avgppmTimeRange ?? [];
                peakOdor = getPeakOdor(timeRangeList);
                peakUsage = getPeakUsage(timeRangeList);
                final dateTime = DateTime.tryParse(
                    _dashboardData?.results?.gaugeGraphData?.maxPpmTime ?? ""
                );

                formattedDate =
                dateTime != null ? DateFormat("d MMM").format(dateTime) : "";

                formattedTime =
                dateTime != null ? DateFormat("h.mm a").format(dateTime) : "";
                print("task ditrubution ${state.taskStatusDistribution}");
                print(
                    "task monitoring count: ${state.taskMonitoring?.length ?? 0}");
                if (state.taskMonitoring != null &&
                    state.taskMonitoring!.isNotEmpty) {
                  print(
                      "First task: ${state.taskMonitoring![0].taskTemplateName} - ${state.taskMonitoring![0].janitorName}");
                }
                print(
                    "task monitoring count: ${state.taskMonitoring?.length ?? 0}");
                print("task monitoring data: ${state.taskMonitoring}");
              });

            }

            if (state is IotError) {
              EasyLoading.dismiss();
              EasyLoading.showError(state.error);
            }

            if (state is GenerateSummarySuccess) {

              print("Summary generated: ${state.summaryData}");
              EasyLoading.dismiss();
              // Show the summary popup
              showSummaryPopup(context ,state.summaryData);
            }
          },
          builder: (context, state) {


            if (_error.isNotEmpty && _dashboardData == null) {
              return Center(
                child: Text('Error: $_error'),
              );
            }

            final data = _dashboardData;
            if (data == null) {
              return const Center(child: Text('No data available'));
            }

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(10.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      _buildContentChildren(data),
                    ),
                  ),
                ),
              ],
            );

          },
        ),
      ),
    );
  }

  void _refreshDashboardData(String range) {
    // Update the selected range state
    setState(() {
      _selectedRange = range;
    });


    String apiType;
    if (range == 'Today') {
      apiType = 'today';
    } else if (range == '7 days') {
      apiType = 'last_7_days';
    } else if (range == 'Month') {
      apiType = 'past_month';
    } else {
      apiType = 'today'; // Default fallback
    }

    iotBloc.add(GetIot(
      janitorId: "ALL",
      clientId: globalStorage.getClientId(),
      facilityId: widget.facilityId ?? 0,
      type: apiType,
    ));
  }

  Future<void> _generateAndSharePDF() async {
    // Get facility name from selected facility
    String? selectedFacilityName;
    if (widget.facility != null && widget.facilityId != null) {
      final selectedFacility = widget.facility!.firstWhere(
        (facility) => facility.id == widget.facilityId,
        orElse: () => widget.facility!.first,
      );
      selectedFacilityName = selectedFacility.facilityName;
    }

    await DashboardPdfBuilder.generateAndShare(
      dashboardData: _dashboardData,
      taskStatusDistribution: _taskStatusDistribution,
      taskMonitoring: _taskMonitoring,
      facilityName: selectedFacilityName,
      selectedRange: _selectedRange,
    );
  }

  List<Widget> _buildContentChildren(DashboardData? data) {
    if (data == null) return [];

    return [

      if (data.results?.isIotDeviceConfigured == false)
        Center(
          child: Text(
            "IOT Device is not yet configured, once done data will start flowing",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textgreyColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

      const SizedBox(height: 10),

      if (isOverlayVisible &&
          _dashboardData?.results?.isIotDeviceConfigured == true)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
          child: Column(
            children: [
              Image.asset(
                AppImages.iconAlertsIotOff,
                width: 25,
                height: 25,
              ),
              const SizedBox(height: 8),
              const Text(
                "IOT Device Is Off",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Please check your iOT device to view the data.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),

      const SizedBox(height: 20),

      AirQualityStatsWidget(
        gaugeGraphData: _dashboardData!.results!.gaugeGraphData!,
        alertsNotification: _dashboardData!.results!.alertsNotification ?? [],
        avgppmPeriodComparison:
        _dashboardData!.results!.avgppmPeriodComparison!,
        todayVsYesterdayAlertTrend:
        _dashboardData!.results!.todayVsYesterdayAlertTrend!,
        daysType: _selectedRange,
        threshold: double.tryParse(
            _dashboardData?.results?.rangeOfPpm?.unhealthyMin?.toString() ??
                "0") ??
            0.0,
      ),

      const SizedBox(height: 20),

      UsageAirQualityHeader(
        range: _dashboardData!.results!.rangeOfPpm!,
      ),

      const SizedBox(height: 20),

      Container(
        //height: 570,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
        child: Column(
          children: [
          Container(
          height: 480,
            child: CombinedChartReverse(
              ammoniaList: _dashboardData?.results?.avgppmTimeRange ?? [],
              threshold: double.tryParse(
                  _dashboardData
                      ?.results?.rangeOfPpm?.unhealthyMin
                      ?.toString() ??
                      "0") ??
                  0.0, hourlyData: _dashboardData?.results?.hourlydata ?? [],
              selectedRange : _selectedRange,
            ),
          ),
          //  const SizedBox(height: 12),

            InkWell(
              onTap: () {
                iotBloc.add(
                  GenerateSummary(
                    data: data?.results?.avgppmTimeRange ?? [],
                    type: "alerts_notification",
                  ),
                );
              },
              child: Container(
                key: ValueKey("request_ai_summary_container"),
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  key: ValueKey("request_ai_summary"),
                  "Request AI Summary",
                  style: AppTextStyle.font14bold,
                ),
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 20),

      CardsRowView(
        peakOderValue:
        _dashboardData?.results?.gaugeGraphData?.maxPpmValue.toString() ??
            "0",
        peakOderTime: [
          formattedDate,
          formattedTime,
        ].where((e) => e.isNotEmpty).join(" | "),
        peakUsageValue: peakUsage.value,
        peakUsageTime: formatTimeRange(peakUsage.time),
      ),

      const SizedBox(height: 20),

      AlertsSection(
        apiAlerts: _dashboardData!.results!.alertsNotification!,
      ),

      const SizedBox(height: 20),

      QuickStatsView(
        statPunctualityValuevalue: _taskDashboardData
            ?.results?.attendanceMonitoring?.attendancePercentage,
        taskClosurePendingValue:
        _taskDashboardData?.results!.taskClosurePending.toString(),
      ),

      const SizedBox(height: 20),

      Charts(
        facilityId: widget.facilityId,
        plan: widget.plan,
        status: widget.plan,
        tabIndex: widget.tabIndex,
        facility: widget.facility,
        clientDashBoardBloc: widget.clientDashBoardBloc,
        isFutureSub: widget.isFutureSub,
        daysType: _selectedRange == 'Today'
            ? 'today'
            : _selectedRange == '7 days'
            ? 'last_7_days'
            : 'past_month',
      ),

      const SizedBox(height: 20),

      TaskMonitoringSection(
        tasks: _taskMonitoring,
        taskStatusDistribution: _taskStatusDistribution,
        taskDashboardData: _taskDashboardData,
      ),

      const SizedBox(height: 20),


      HygieneScoreCard(
        imageUrl: _taskDashboardData!.results!.wahScoreUrl!,
      ),

      const SizedBox(height: 20),

      ReviewList(
        review: comments,
      ),

      const SizedBox(height: 40),
    ];
  }


  
}