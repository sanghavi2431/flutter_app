import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

import '../../../client_flow/screens/dashbaord/bloc/dashboard_bloc.dart';
import '../../../client_flow/screens/dashbaord/bloc/dashboard_event.dart';
import '../../../client_flow/screens/dashbaord/bloc/dashboard_state.dart';
import '../../../client_flow/screens/dashbaord/data/model/dashboard_task_model.dart';
import '../../../client_flow/widgets/pie_chart.dart';
import '../../../core/local/global_storage.dart';
import '../../../utils/app_color.dart';

class JanitorDashboard extends StatefulWidget {
  const JanitorDashboard({super.key});

  @override
  State<JanitorDashboard> createState() => _JanitorDashboardState();
}

class _JanitorDashboardState extends State<JanitorDashboard> {
  List<String> get chipLabels => [
        'today'.tr(),
        'thisWeek'.tr(),
        'thisMonth'.tr(),
      ];
  int? _selectedChipIndex = 0;
  ClientDashBoardBloc dashBoardBloc = ClientDashBoardBloc();
  DashbaordModel? dashboardModel;
  GlobalStorage globalStorage = GetIt.instance();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dashBoardBloc.add(GetDashbaordEvent(
      type: "today",
      clientId: globalStorage.getClientId(),
      janitorId: globalStorage.getId().toString(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          // horizontal: 16
          horizontal: 16,
          vertical: 18),
      child:
          //  Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [

          // Text("Work Summary",
          //  style: AppTextStyle.font24bold,
          //  ),
          //  const SizedBox(height: 10,),

          //  Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     summerayCard(AppImages.tick),

          //     summerayCard(AppImages.clock),

          //     summerayCard("assets/images/coins.jpg"),
          //   ],
          //  ),
          //  const SizedBox(height: 20,),

          Container(
        width: double.infinity,
        // height: 800,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.white, // Background color of the container
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2), // Shadow color
              spreadRadius: 1, // How wide the shadow should spread
              blurRadius: 10, // The blur effect of the shadow
              offset: const Offset(0, 0), // No offset for shadow on all sides
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                "myPerformanceScore".tr(),
                style: AppTextStyle.font24bold,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                // flex: 6,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: chipLabels.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          print("Selected Index: $index");

                          dashBoardBloc.add(GetDashbaordEvent(
                            type: "last_7_days",
                            clientId: globalStorage.getClientId(),
                            janitorId: globalStorage.getId().toString(),
                            // locationId: widget.facilityId!
                          ));

                          // var results = await showCalendarDatePicker2Dialog(
                          //   context: context,
                          //   config: CalendarDatePicker2WithActionButtonsConfig(),
                          //   dialogSize: const Size(325, 400),
                          //   value: _rangeDatePickerValueWithDefaultValue,
                          //   borderRadius: BorderRadius.circular(15),
                          // );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: ChoiceChip(
                            // elevation: 10,
                            // shape: Border.symmetric(),
                            // avatarBorder: Border.alls(),

                            label: Text(
                              chipLabels[index],
                              style: AppTextStyle.font12bold
                                  .copyWith(fontSize: 12),
                            ),
                            showCheckmark: false,
                            selected: _selectedChipIndex == index,
                            selectedColor: const Color(0xffD3D3D3),

                            // color: WidgetStateProperty.resolveWith(
                            //   (states) =>
                            //    states.contains(MaterialState.selected)
                            //   Colors.white
                            //  ),
                            backgroundColor: Colors.white,
                            // disabledColor: AppColors.white,

                            // color:
                            // AppColors.buttonBgColor,
                            onSelected: (bool selected) async {
                              print(index);

                              if (index == 0) {
                                dashBoardBloc.add(GetDashbaordEvent(
                                  type: "today",
                                  clientId: globalStorage.getClientId(),
                                  janitorId: globalStorage.getId().toString(),
                                  // locationId: widget.facilityId!
                                ));
                              } else if (index == 1) {
                                dashBoardBloc.add(GetDashbaordEvent(
                                  type: "last_7_days",
                                  clientId: globalStorage.getClientId(),
                                  janitorId: globalStorage.getId().toString(),
                                  // locationId: widget.facilityId!
                                ));
                              } else if (index == 2) {
                                dashBoardBloc.add(GetDashbaordEvent(
                                  type: "past_month",
                                  clientId: globalStorage.getClientId(),
                                  janitorId: globalStorage.getId().toString(),
                                  // locationId: widget.facilityId!
                                ));
                              }

                              setState(() {
                                _selectedChipIndex = selected ? index : null;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              BlocConsumer(
                  bloc: dashBoardBloc,
                  listener: (context, state) {
                    if (state is DashbaordTask) {
                      EasyLoading.dismiss();

                      dashboardModel = state.dashbaordModel;

                      print(
                          "sdfkhjslkdfjsd ${dashboardModel!.results!.taskStatusDistribution!.ongoingCount} ");
                    }
                    if (state is DashboarLoading) {
                      EasyLoading.dismiss();

                      EasyLoading.show(status: state.message);
                    }

                    if (state is DashboarError) {
                      EasyLoading.dismiss();
                      EasyLoading.showError(state.error);
                    }
                  },
                  builder: (context, state) {
                    return Center(
                      child:
                      ChartPie(
                        complatedTask: dashboardModel == null
                            ? "0"
                            : dashboardModel!.results!.taskStatusDistribution!
                                    .completedCount ??
                                "0",
                        pendingTask: dashboardModel == null
                            ? "0"
                            : dashboardModel!.results!.taskStatusDistribution!
                                    .pendingCount ??
                                "0",
                        totalTask: dashboardModel == null
                            ? "0"
                            : dashboardModel!
                                    .results!.janitorEfficiency!.totaltask
                                    .toString() ??
                                "0",
                        accetedTask: dashboardModel == null
                            ? "0"
                            : dashboardModel!.results!.taskStatusDistribution!
                                    .acceptedCount ??
                                "0",
                        ongoingTask: dashboardModel == null
                            ? "0"
                            : dashboardModel!.results!.taskStatusDistribution!
                                    .ongoingCount ??
                                "0",
                        rejectedTask: dashboardModel == null
                            ? "0"
                            : dashboardModel!.results!.taskStatusDistribution!
                                    .rejectedCount ??
                                "0",

                        rfcTask: dashboardModel == null
                            ? "0"
                            : dashboardModel!
                                .results!.taskStatusDistribution!.closureCount,

                        complatedPercentage: dashboardModel == null
                            ? "0%"
                            : dashboardModel!.results!.taskStatusDistribution!
                                .completedPercentage,
                        acceptedPercentage: dashboardModel == null
                            ? "0%"
                            : dashboardModel!.results!.taskStatusDistribution!
                                .acceptedPercentage,
                        ongoingPercentage: dashboardModel == null
                            ? "0%"
                            : dashboardModel!.results!.taskStatusDistribution!
                                .ongoingPercentage,
                        pendingPercentage: dashboardModel == null
                            ? "0%"
                            : dashboardModel!.results!.taskStatusDistribution!
                                .pendingPercentage,
                        rejectedPercentage: dashboardModel == null
                            ? "0%"
                            : dashboardModel!.results!.taskStatusDistribution!
                                .rejectedPercentage,

                        rfcPercentage: dashboardModel == null
                            ? "0%"
                            : dashboardModel!.results!.taskStatusDistribution!
                                .closurePercentage,

                        //  rejectedPercentage: dashboardModel == null
                        //      ? "0%"
                        //      : dashboardModel!
                        //          .results!
                        //          .taskStatusDistribution!
                        //          .rejectedPercentage,
                        //  rfcPercentage: dashboardModel == null
                        //      ? "0%"
                        //      : dashboardModel!
                        //          .results!
                        //          .taskStatusDistribution!
                        //          .rfcPercentage,
                      ),
                    );
                  }),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                        color: const Color(0xffFFF035),
                        borderRadius: BorderRadius.circular(50)),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CustomImageProvider(
                        image: AppImages.rewardIcon,
                        width: 32,
                        height: 32,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text.rich(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'completeTasksBeforeTimeAndEarn'.tr(),
                            style: TextStyle(
                              fontSize: 11.5,
                              // fontWeight: FontWeight.bold
                            ),
                          ),
                          // ),
                          TextSpan(
                            text: 'tenPoints'.tr(),
                            style: TextStyle(
                                fontSize: 11.5, fontWeight: FontWeight.bold),
                          ),
                          // TextSpan(text: ' world!'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        // ],
        // ),
      ),
    );
  }

  summerayCard(String images) {
    return Container(
      width: 123,
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.white, // Background color of the container
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2), // Shadow color
            spreadRadius: 1, // How wide the shadow should spread
            blurRadius: 10, // The blur effect of the shadow
            offset: const Offset(0, 0), // No offset for shadow on all sides
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageProvider(
                image: images,
                width: 30,
                height: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "6",
                style: AppTextStyle.font20bold,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Completed Today",
            style: AppTextStyle.font13,
          ),
          //    const SizedBox(
          //   height: 10,
          //  ),
        ],
      ),
    );
  }
}
