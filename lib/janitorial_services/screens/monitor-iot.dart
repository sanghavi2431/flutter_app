import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/b2b_store/cart.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/dashboard_task_model.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/janitorial_services/screens/facility_performance.dart';
import 'package:woloo_smart_hygiene/janitorial_services/screens/network/iot_services.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:woloo_smart_hygiene/widgets/custom_chart.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../client_flow/screens/dashbaord/bloc/dashboard_bloc.dart';
import '../../client_flow/screens/dashbaord/data/model/facility_model.dart';
import '../../client_flow/widgets/chart.dart';
import '../model/iotdata_model.dart';
import '../widgets/alert_notification.dart';
import 'bloc/iot_bloc.dart';
import 'bloc/iot_event.dart';
import 'bloc/iot_state.dart';

class DashboardScreen extends StatefulWidget {
  final int? facilityId;
  final String? plan;
  final String? status;
  final int? tabIndex;
  final TabController? tabController;
  final List<Facility>? facility;
  final ClientDashBoardBloc? clientDashBoardBloc;
  final bool isFutureSub;

  const DashboardScreen(
      {super.key,
      this.facility,
      this.clientDashBoardBloc,
      this.facilityId,
      this.plan,
      this.status,
      this.tabController,
      this.tabIndex,
      required this.isFutureSub});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  GeneratedAiSummery? _summaryData;
  IotBloc iotBloc = IotBloc();
  final int _selectedIndex = 0;
  DashboardData? _dashboardData;
  // bool _isLoading = false;
  final String _error = '';
  String _timeFilter = 'ALL';

  GlobalStorage globalStorage = GetIt.instance();
  @override
  void initState() {
    super.initState();
    // _fetchDashboardData();
    iotBloc.add(GetIot(
      janitorId: 0, //globalStorage.getJanitorId(),
      clientId: globalStorage.getClientId(),
      facilityId: widget.facilityId ?? 0, // Replace with actual facility ID
      type: 'type',
    )); // Replace with actual device ID and type
  }

  void _setTimeFilter(String filter) {
    if (_timeFilter != filter) {
      setState(() {
        _timeFilter = filter;
      });
      // _fetchDashboardData();
    }
  }

  void _showSummaryPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.white,
              // constraints: BoxConstraints(
              //   maxHeight: MediaQuery.of(context).size.height * 0.7,
              //   maxWidth: MediaQuery.of(context).size.width * 0.9,
              // ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'AI Generated Summary',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.appBarTitleColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  SizedBox(
                    child: SingleChildScrollView(
                      child: _summaryData != null &&
                              _summaryData!.results != null &&
                              _summaryData!.results!.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_summaryData!.success == true)
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.green.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 16.sp,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Summary generated successfully',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                const SizedBox(height: 15),
                                if (_summaryData!.results != null &&
                                    _summaryData!.results!.isNotEmpty)
                                  if (_summaryData!.results is String)
                                    Container(
                                      height: 200.h,
                                      width: 300.w,
                                      // margin: const EdgeInsets.only(bottom: 15),
                                      // padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: AppColors.lightCyanColor
                                              .withOpacity(0.3),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: SingleChildScrollView(
                                          child: Html(
                                              data: _summaryData!.results)),
                                    )
                                  else
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.backgroundColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        _summaryData!.results.toString(),
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: AppColors.textgreyColor,
                                        ),
                                      ),
                                    )
                                // })
                              ],
                            )
                          : const Center(
                              child: Text('No summary data available'),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        // margin: EdgeInsets.only(bottom: 10.h),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          "Close",
                          style: AppTextStyle.font12bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  TaskStatusDistribution? _taskStatusDistribution;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer(
          bloc: iotBloc,
          listener: (context, state) {
            print("dssa $state");
            if (state is IotLoading) {
              EasyLoading.show(status: state.message);
            }
            if (state is IotSuccess) {
              EasyLoading.dismiss();
              setState(() {
                _dashboardData = state.dashboardData;
                _taskStatusDistribution = state.taskStatusDistribution;
                // _isLoading = false;
              });
            }

            if (state is IotError) {
              EasyLoading.dismiss();
              EasyLoading.showError(state.error);
            }

            if (state is GenerateSummarySuccess) {
              setState(() {
                _summaryData = state.summaryData;
              });
              EasyLoading.dismiss();
              // Handle the summary data here
              print("Summary generated: ${state.summaryData}");
              // Show the summary popup
              _showSummaryPopup();
            }
          },
          builder: (context, state) {
            // if (_isLoading && _dashboardData == null) {
            //   return const Center(child: CircularProgressIndicator());
            // }

            if (_error.isNotEmpty && _dashboardData == null) {
              return Center(
                child: Text('Error: $_error'),
              );
            }

            final data = _dashboardData;
            if (data == null) {
              return const Center(child: Text('No data available'));
            }

            return SingleChildScrollView(
              // physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(14.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _dashboardData!.results!.isIotDeviceConfigured == false
                      ? Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            "IOT Device is not yet configured,once done data will start flowing",
                            style: TextStyle(
                              color: AppColors.textgreyColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      : const SizedBox(),
                  // RichText(
                  //   text: const TextSpan(
                  //     style: TextStyle(
                  //         color: AppColors.textgreyColor,
                  //         fontSize: 14,
                  //         fontWeight: FontWeight.w700),
                  //     children: [
                  //       TextSpan(
                  //         text: 'Your Trial shall end in ',
                  //       ),
                  //       TextSpan(
                  //         text: '3 Days. ',
                  //         style: TextStyle(fontWeight: FontWeight.bold),
                  //       ),
                  //       TextSpan(
                  //         text: 'Renew it Now',
                  //         style: TextStyle(
                  //           color: AppColors.textgreyColor,
                  //           fontWeight: FontWeight.bold,
                  //           decoration: TextDecoration.underline,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 16),

                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Dark background matching the image
                      borderRadius: BorderRadius.circular(
                          20), // Rounded corners for the container
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(0, 5), // Shadow for depth
                        ),
                      ],
                    ),
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    //   borderRadius: BorderRadius.circular(47),
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.grey.withOpacity(0.1),
                    //       spreadRadius: 1,
                    //       blurRadius: 5,
                    //       offset: const Offset(0, 3),
                    //     ),
                    //   ],
                    // ),
                    child: Column(
                      children: [
                        CustomChartWidget(
                          data: data.results?.avgppmTimeRange ?? [],
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () {
                            iotBloc.add(GenerateSummary(
                              data: data.results?.avgppmTimeRange ?? [],
                              type: "alerts_notification",
                            ));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                                color: AppColors.backgroundColor,
                                borderRadius: BorderRadius.circular(6)),
                            child: Text(
                              "Check Status",
                              style: AppTextStyle.font12bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // AirQualityChart(
                  //   airQualityData: data.avgppmTimeRange.map((e) {
                  //     // var d = (e.avgPcdMax.runtimeType);

                  //     return GraphData(
                  //       airQuality: double.parse(e.avgPpmAvg),
                  //       usage: double.parse(e.avgPcdMax),
                  //       timeRange: e.timeRange,
                  //     );
                  //   }).toList(),
                  //   isLoading: false,
                  //   timeFilter: _timeFilter,
                  //   onFilterChanged: _setTimeFilter,
                  // ),
                  const SizedBox(height: 16),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 20),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withValues(alpha: 0.2), // Shadow color
                              spreadRadius:
                                  1, // How wide the shadow should spread
                              blurRadius: 10, // The blur effect of the shadow
                              offset: const Offset(
                                  0, 0), // No offset for shadow on all sides
                            ),
                          ],
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(40)),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Usage Report",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          CustomBarChart(
                              data: data.results?.usageReportQuery ?? []),
                          // const Divider(),
                          // Row(
                          //   spacing: 20,
                          //   children: [
                          //     CircleAvatar(
                          //       radius: 12,
                          //       backgroundColor: AppColors.appBarTitleColor,
                          //       child:
                          //           Image.asset("assets/images/bxs_smile.png"),
                          //     ),
                          //     Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Text(
                          //           "You are doing good!",
                          //           style: TextStyle(
                          //             color: AppColors.alertTitleColor,
                          //             fontSize: 12.sp,
                          //             fontWeight: FontWeight.bold,
                          //           ),
                          //         ),
                          //         Text(
                          //           "You almost reached your goal",
                          //           style: TextStyle(
                          //             color: AppColors.alertTitleColor,
                          //             fontSize: 10.sp,
                          //           ),
                          //         )
                          //       ],
                          //     )
                          //   ],
                          // )
                        ],
                      )),
                  // AiSummaryCard(summary: data.results.summary.avgppmTimeRangeInsights),
                  const SizedBox(height: 16),
                  Charts(
                    facilityId: widget.facilityId,
                    plan: widget.plan,
                    status: widget.plan,
                    tabIndex: widget.tabIndex,
                    facility: widget.facility,
                    clientDashBoardBloc: widget.clientDashBoardBloc,
                    isFutureSub: widget.isFutureSub,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const SizedBox(height: 16),

                  // const SizedBox(height: 16),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 16,
                          child: IotLogs(
                            taskStatusDistribution: _taskStatusDistribution,
                            // taskStatusDistribution: ,
                            // taskStatusDistribution:,
                          ),
                        ),
                        const Spacer(),
                        Expanded(flex: 16, child: AirQuality(data: data))
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Facilities(
                    amoniaTableDatum: _dashboardData?.results?.amoniaTableData,
                  ),
                  const SizedBox(height: 16),
                  // AiSummaryCard(summary: data.results.summary.avgppmTimeRangeInsights),
                  // const SizedBox(height: 60),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(47),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AlertAndNotificationWidget(data: data),
                          InkWell(
                            onTap: () {
                              iotBloc.add(GenerateSummary(
                                data: data,
                                type: "alerts_notification",
                              ));
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10.h),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: AppColors.backgroundColor,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Text(
                                "Check Status",
                                style: AppTextStyle.font12bold,
                              ),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(height: 500.h),
                ],
              ),
            );
          },
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _selectedIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _selectedIndex = index;
      //     });
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      // ),
    );
  }
}

class AirQuality extends StatelessWidget {
  const AirQuality({
    super.key,
    required this.data,
  });

  final DashboardData? data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(color: Colors.grey, spreadRadius: 2, blurRadius: 10),
          ]),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Air Quality Level",
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Overall performance",
            style: TextStyle(color: AppColors.pieDataColor3, fontSize: 10.sp),
          ),
          SizedBox(
              height: 120,
              width: 120,
              child: ComplexCircularBar(
                  percentageValue: (double.parse(
                              data?.results?.gaugeGraphData?.avgAmonia ?? "0") /
                          1000) *
                      100,
                  performance: double.parse(
                      data?.results?.gaugeGraphData?.avgAmonia ?? "0"))),
          Text(
            "Average AQL across all facilities",
            style: TextStyle(fontSize: 8.sp),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class Facilities extends StatelessWidget {
  const Facilities({
    super.key,
    required this.amoniaTableDatum,
    // You might pass the list of values here, or fetch it from a state management solution
  });
  final List<AmoniaTableDatum>? amoniaTableDatum;
  // final List<double> chartValues;

  @override
  Widget build(BuildContext context) {
    // Calculate min/max for chart Y-axis based on your data for better scaling
    // double minY = chartValues.reduce((a, b) => a < b ? a : b);
    // double maxY = chartValues.reduce((a, b) => a > b ? a : b);

    // // Add some padding to min/max Y for better visual
    // minY = (minY * 0.9).floorToDouble(); // 10% less than min
    // maxY = (maxY * 1.1).ceilToDouble(); // 10% more than max

    // Generate FlSpot data
    // List<FlSpot> spots = chartValues.asMap().entries.map((entry) {
    //   // Use index as X-value, value as Y-value
    //   // We convert index to double for FlSpot
    //   return FlSpot(entry.key.toDouble(), entry.value);
    // }).toList();

    return XDecoratedBox(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Facilities",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              // const ForwardButton(),
            ],
          ),
          // Your existing Row with Icons and Text
          const Row(
            spacing: 15,
            children: [
              Spacer(),
              if (false)
                Column(
                  children: [
                    Icon(
                      Icons.home,
                      color: AppColors.lightCyanColor,
                      size: 35,
                    ),
                    Text(
                      "Home",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              Column(
                children: [
                  Text(
                    "Watchlist",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Daily Average"),
                ],
              ),
              if (false)
                Column(
                  children: [
                    Icon(
                      Icons.person,
                      color: AppColors.lightCyanColor,
                      size: 35,
                    ),
                    Text(
                      "Profile",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              Spacer(),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            // Use a specific height for the chart section, e.g., 200.h
            // Adjust based on your screen size and layout needs.
            height: 160.h,
            child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: amoniaTableDatum?.length ??
                    0, // If you only have one chart, this is fine
                itemBuilder: (c, i) {
                  // Check if the value list exists and is not empty before using reduce
                  List<double>? values = amoniaTableDatum?[i].value;
                  double? minY;
                  double? maxY;

                  if (values != null && values.isNotEmpty) {
                    minY = values.reduce((a, b) => a < b ? a : b);
                    maxY = values.reduce((a, b) => a > b ? a : b);

                    // Add some padding to min/max Y for better visual
                    minY = (minY * 0.9).floorToDouble(); // 10% less than min
                    maxY = (maxY * 1.1).ceilToDouble(); // 10% more than max
                  } else {
                    // Default values if list is empty or null
                    minY = 0.0;
                    maxY = 100.0;
                  }

                  List<FlSpot> spots = values?.asMap().entries.map((entry) {
                        // Use index as X-value, value as Y-value
                        // We convert index to double for FlSpot
                        return FlSpot(entry.key.toDouble(), entry.value);
                      }).toList() ??
                      [];

                  // If no spots, create a default line with two points
                  if (spots.isEmpty) {
                    spots = [
                      const FlSpot(0, 50),
                      const FlSpot(1, 50),
                    ];
                    minY = 0.0;
                    maxY = 100.0;
                  }

                  return Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10
                            .w), // Added horizontal padding for the row content
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // Align text to start
                          children: [
                            Text(
                              "Facility ${i + 1}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              "Know More",
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            )
                          ],
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            height: 60, // Specific height for the chart
                            child: LineChart(
                              LineChartData(
                                // Set min/max X and Y values
                                minX: 0,
                                maxX: (spots.length - 1)
                                    .toDouble(), // Max X is the last index
                                minY: minY,
                                maxY: maxY,

                                gridData: const FlGridData(
                                  show: false, // You want no grid lines
                                ),
                                titlesData: const FlTitlesData(
                                  show:
                                      false, // If you want no titles/labels at all
                                  leftTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  bottomTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                ),
                                borderData: FlBorderData(
                                  show: false, // You want no border
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    isCurved: true, // Often looks better
                                    spots:
                                        spots, // Use the dynamically generated spots
                                    color: amoniaTableDatum?[i].ppmDiff >= 0
                                        ? AppColors.lightCyanColor
                                        : AppColors.red, // Line color
                                    barWidth:
                                        2, // Add some width to make it visible
                                    // barLineCap: BarLineCap.round, // Make ends round
                                    dotData: const FlDotData(
                                        show: false), // Hide dots
                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient:
                                          amoniaTableDatum?[i].ppmDiff >= 0
                                              ? LinearGradient(
                                                  colors: [
                                                    AppColors.lightCyanColor
                                                        .withOpacity(
                                                            0.5), // Start color with opacity
                                                    AppColors.lightCyanColor
                                                        .withOpacity(
                                                            0.0), // End color transparent
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                )
                                              : LinearGradient(
                                                  colors: [
                                                    AppColors.red.withOpacity(
                                                        0.5), // Start color with opacity
                                                    AppColors.red.withOpacity(
                                                        0.0), // End color transparent
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ),
                                    ),
                                  ),
                                ],
                                // Add a touch input
                                lineTouchData: const LineTouchData(
                                    enabled:
                                        false), // Disable touch feedback if not needed
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                            "${amoniaTableDatum![i].ppmDiff.abs().toStringAsFixed(2)}"), // This value seems static, verify its meaning
                        const Spacer(
                          flex: 1,
                        ),
                        amoniaTableDatum![i].ppmDiff! >= 0
                            ? const Icon(Icons.arrow_upward_rounded)
                            : const Icon(Icons.arrow_downward_rounded)
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}

// class ForwardButton extends StatelessWidget {
//   const ForwardButton({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//           color: AppColors.buttonYellowColor,
//           borderRadius: BorderRadius.circular(8)),
//       child: const Icon(
//         Icons.arrow_forward_ios_rounded,
//         size: 12,
//       ),
//     );
//   }
// }

class ComplexCircularBar extends StatefulWidget {
  const ComplexCircularBar(
      {super.key, required this.percentageValue, required this.performance});
  final double percentageValue;
  final double performance;
  @override
  State<ComplexCircularBar> createState() => _ComplexCircularBarState();
}

class _ComplexCircularBarState extends State<ComplexCircularBar> {
  final ValueNotifier<double> _valueNotifier = ValueNotifier<double>(37.0);
  @override
  void initState() {
    super.initState();
    _valueNotifier.value = widget.percentageValue;
  } // Initial progress value

  @override
  Widget build(BuildContext context) {
    return DashedCircularProgressBar.aspectRatio(
      aspectRatio: 1, // width ÷ height
      valueNotifier: _valueNotifier,
      progress: _valueNotifier.value,
      startAngle: 225,
      sweepAngle: 270,
      foregroundColor: AppColors.pieDataColor3,
      backgroundColor: AppColors.lightCyanColor,
      foregroundStrokeWidth: 16,
      backgroundStrokeWidth: 8,
      animation: true,
      seekSize: 6,
      seekColor: Colors.transparent,
      child: Center(
        child: ValueListenableBuilder(
          valueListenable: _valueNotifier,
          builder: (_, double value, __) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 10.r,
                child: const Icon(
                  Icons.person,
                  size: 15,
                  color: AppColors.pieDataColor3,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.performance.toStringAsFixed(1),
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomLineChart extends StatelessWidget {
  const CustomLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150, // Adjust height as needed
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false), // Hide grid lines
          titlesData: const FlTitlesData(show: false), // Hide axis titles
          borderData: FlBorderData(show: false), // Hide borders
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 1),
                const FlSpot(1, 1.5),
                const FlSpot(2, 1.2),
                const FlSpot(3, 1.8),
                const FlSpot(4, 1.5),
                const FlSpot(5, 2),
              ], // Data points for the graph
              isCurved: true, // Smooth curve
              // colors: [Colors.lightBlue], // Line color
              barWidth: 3, // Line thickness
              isStrokeCapRound: true, // Rounded line ends
              belowBarData: BarAreaData(
                show: true,
              ),
            ),
          ],
          minX: 0,
          maxX: 5,
          minY: 0,
          maxY: 2.5,
        ),
      ),
    );
  }
}

class CustomBarChart extends StatelessWidget {
  final List<UsageReportQuery> data;
  const CustomBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final List<double> values =
        data.map((e) => double.parse((e.avgPcdMax) ?? '0') / 35).toList();
    final List<String> labels = data.map((e) => e.dayInitial ?? '').toList();
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 12,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  int idx = value.toInt();
                  if (idx < labels.length) {
                    return Text(labels[idx],
                        style: const TextStyle(fontSize: 12));
                  }
                  return Container();
                },
                reservedSize: 24,
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(values.length, (i) {
            final isHighlighted =
                i == 4 || i == 11 || i == 12; // Example: highlight F, F, S
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  color: AppColors.backgroundColor,
                  // isHighlighted ? Colors.lightBlueAccent : Colors.grey[700],
                  width: 16,
                  borderRadius: BorderRadius.circular(20),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
