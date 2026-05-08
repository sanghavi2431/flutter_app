import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/dashboard_task_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/view/iot_onbaord.dart';
import 'package:woloo_smart_hygiene/client_flow/utils/client_constant.dart';
import 'package:woloo_smart_hygiene/client_flow/utils/client_images.dart';
import 'package:woloo_smart_hygiene/client_flow/widgets/CustomButton.dart';
import 'package:woloo_smart_hygiene/client_flow/widgets/pie_chart.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

import '../../core/local/global_storage.dart';
import '../../janitorial_services/screens/monitor-iot.dart';
import '../../screens/common_widgets/dropdown_dialogue.dart';
import '../../screens/common_widgets/image_provider.dart';
import '../../screens/janitor_details_screen/view/chart.dart';
import '../../utils/app_constants.dart';
import '../screens/dashbaord/bloc/dashboard_bloc.dart';
import '../screens/dashbaord/bloc/dashboard_event.dart';
import '../screens/dashbaord/bloc/dashboard_state.dart';
import '../screens/dashbaord/data/model/facility_dropdown_model.dart';
import '../screens/dashbaord/data/model/facility_model.dart';
import '../screens/dashbaord/data/model/janitor_model.dart';
import '../screens/dashbaord/data/model/task_model.dart';
import '../screens/dashbaord/view/widget/bottomsheet/host_bottomsheet.dart';
import '../screens/subcription/view/premium_screeen.dart';

class Charts extends StatefulWidget {
  final int? facilityId;
  final String? plan;
  final String? status;
  final int? tabIndex;
  final TabController? tabController;
  final List<Facility>? facility;
  final ClientDashBoardBloc? clientDashBoardBloc;
  final bool isFutureSub;
  final String? daysType;
  const Charts(
      {super.key,
        this.facilityId,
        this.plan,
        this.status,
        this.tabIndex,
        this.tabController,
        this.facility,
        this.clientDashBoardBloc,
        this.daysType,
        required this.isFutureSub});

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  ClientDashBoardBloc dashBoardBloc = ClientDashBoardBloc();

  DashbaordModel? dashboardModel;
  Map<String, dynamic>? decodedToken;
  GlobalStorage globalStorage = GetIt.instance();
  String? dropdownValue;

  bool isFirstTime = true;

  List<Datum> janitorName = [];
  JanitorModel? janitorModel = JanitorModel();

  List<FacilityDropdownModel> facilitydropdownNames = [];
  FacilityDropdownModel? selectItem;

  String clientId = "";
//   final List<String> items = [
//   'Item1',
//   'Item2',
//   'Item3',
//   'Item4',
// ];
  FacilityDropdownModel? selectedValue;

  bool? isOnboard;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("intit state called");

    print("tab index ${widget.tabIndex}");
    print("facility id ${widget.facility![widget.tabIndex!].id}");

    print("Widget.type -> ${widget.daysType}");

    // print("Dashboard model accepted percentage -> ${dashboardModel!.results!.taskStatusDistribution!.acceptedPercentage}");



    var some = globalStorage.getClientToken();
    clientId = globalStorage.getClientId();
    isOnboard = globalStorage.isOnboard();
    decodedToken = JwtDecoder.decode(some);
    if (widget.facility![widget.tabIndex!].id == 1) {
    } else {
      dashBoardBloc.add(FacilityByJanitorEvent(
          facilityId: widget.facility![widget.tabIndex!].id!,
          clientId: int.parse(clientId)));
    }
  }

  @override
  void didUpdateWidget(covariant Charts oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// Detect change
    if (oldWidget.daysType != widget.daysType && selectItem?.id != null ) {

      print("daysType changed -> calling API");

      dashBoardBloc.add(
        GetDashbaordEvent(
          type: widget.daysType ?? "today",
          clientId: clientId,
          janitorId: selectItem?.id?.toString() ?? "",
          locationId: widget.facilityId!,
        ),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    //  dashBoardBloc.add(FacilityByJanitorEvent(
    //     facilityId: widget.facility![widget.tabIndex!].id!,
    //     clientId: int.parse(clientId)));
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),

          // SizedBox(height: 300.h, child: DashboardScreen()),

          // premiumContainer(context),
          // const SizedBox(
          //   height: 20,
          // ),
          //  hostContainer(),
          const SizedBox(
            height: 10,
          ),

          Container(
            // height: 580.h,
            width: MediaQuery.of(context).size.width / 1.1,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2), // Shadow color
                spreadRadius: 1, // How wide the shadow should spread
                blurRadius: 10, // The blur effect of the shadow
                offset: const Offset(0, 0), // No offset for shadow on all sides
              ),
            ], color: AppColors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                //  SizedBox(
                //   height: 1500,
                //   //  child: const  DashboardScreen(),
                //  ),

                BlocConsumer(
                    bloc: dashBoardBloc,
                    listener: (context, state) {
                      print("statesss  $state ");
                      if (state is DashboarLoading) {
                        EasyLoading.show(status: state.message);
                      }

                      if (state is DashbaordTask) {
                        EasyLoading.dismiss();

                        // dashbaordModel = state.dashbaordModel;
                        // setState(() {

                        // });
                        // ;

                        // print("$dashbaordModel objectttttttttttt");
                        // print("rasd ${ dashbaordModel!.results!.taskStatusDistribution!
                        //     .completedCount}");
                      }

                      if (state is GetAllJanitor) {
                        EasyLoading.dismiss();

                        janitorName = state.taskModel!.results!.data!;
                        for (var janitor in janitorName) {
                          facilitydropdownNames.add(FacilityDropdownModel(
                            facilityName: janitor.name,
                            id: janitor.id,
                          ));
                        }

                        selectItem = facilitydropdownNames.first;

                        dashBoardBloc.add(GetDashbaordEvent(
                            type: widget.daysType ?? "today",
                            clientId: clientId,
                            janitorId: facilitydropdownNames.first.id!.toString(),
                            locationId: widget.facilityId!));
                      }

                      if (state is FacilityByJanitor) {
                        //     showModalBottomSheet(
                        //   backgroundColor: Colors.transparent,
                        //   context: context, builder: (context) {
                        //     return premiumContainer(context);
                        // }).then((value) {
                        //   Navigator.of(context).pop();
                        // }, )
                        // ;
                        print("dsdasdasd ${state.janitorModel!.results!.length} ");
                        // print("objectttttttttt ${state.janitorModel.results!.first

                        EasyLoading.dismiss();

                        //  print("plan id in task master ${globalStorage.getPlanId()}");

                        janitorModel = state.janitorModel;

                        for (var janitor in janitorModel!.results!) {
                          facilitydropdownNames.add(FacilityDropdownModel(
                            facilityName: janitor.janitorName,
                            id: janitor.janitorId,
                          ));
                        }
                        facilitydropdownNames = facilitydropdownNames.toSet().toList();
                        // setState(() {

                        // });
                        String palnId = globalStorage.getPlanId();
                        selectItem = facilitydropdownNames.first;

                        dashBoardBloc.add(GetDashbaordEvent(
                            type: widget.daysType ?? "today",
                            clientId: clientId,
                            janitorId:
                            facilitydropdownNames.first.id!.toString(),
                            locationId: widget.facilityId!));

                        print("objectttttttttt ${widget.isFutureSub}");

                        // if (widget.plan == "CLASSIC" &&
                        //     widget.status == "active"  && palnId != "0" && widget.isFutureSub == false ) {
                        //   Future.delayed(const Duration(seconds: 3), ()async {

                        //          if (!mounted) return;
                        //      await  showModalBottomSheet(
                        //            useRootNavigator: false,
                        //         backgroundColor: Colors.transparent,
                        //         context: context,
                        //         builder: (BuildContext dialogContext) {
                        //           return premiumContainer(dialogContext);
                        //         });

                        //   });
                        // } else if (widget.plan == "PREMIUM" &&
                        //     widget.status == "inactive"  && palnId != "0" && widget.isFutureSub == false ) {
                        //   //PREMIUM
                        //   Future.delayed(const Duration(seconds: 3), () async {
                        //     if (!mounted) return;
                        //         // if(mounted) {
                        //       await   showModalBottomSheet(
                        //         useRootNavigator: false,
                        //         backgroundColor: Colors.transparent,
                        //         context: context,
                        //         builder: (BuildContext dialogContext) {
                        //           return premiumContainer(dialogContext);
                        //         });

                        //         // }

                        //         // .then((value) {
                        //         //   Navigator.of(context).pop();
                        //         // },  );
                        //         //      if (mounted) {

                        //         //    Navigator.of(context).pop(); // This will now work

                        //         //     }
                        //   });
                        // }
                      }

                      if (state is DashboarError) {
                        EasyLoading.dismiss();
                        //  if(state.error == "Does Not Exist"){

                        //   }else{

                        EasyLoading.showError(state.error);

                        // }
                        // EasyLoading.showError(state.error);
                      }
                    },
                    builder: (context, state) {
                      if (state is DashbaordTask) {
                        dashboardModel = state.dashbaordModel;

                        print("sdfkhjslkdfjsd ${dashboardModel!.results!.taskStatusDistribution!.pendingCount} ");
                      }
                      // print("statesss  $state ");
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child:
                      Semantics(
                      label: "Task Audit",
                      value: "header",
                      child:
                                Text(
                                  DashboardConst.taskAudit,
                                  style: AppTextStyle.font20bold,
                                ),
                              ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<FacilityDropdownModel>(
                                    dropdownStyleData: DropdownStyleData(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(5),
                                            color: AppColors.white)),

                                    isExpanded: true,
                                    hint: selectItem == null
                                        ? Text(
                                      "Select buddy",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color:
                                        Theme.of(context).hintColor,
                                      ),
                                    )
                                        : Text(
                                      selectItem!.facilityName ?? "",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color:
                                        Theme.of(context).hintColor,
                                      ),
                                    ),

                                    items: facilitydropdownNames
                                        .map((FacilityDropdownModel item) {
                                      return
                                        DropdownMenuItem<
                                          FacilityDropdownModel>(
                                        value: item,
                                        child:
                                        Semantics(
                                          label: "Task Audit",
                                          value: "facility name",
                                          child:
                                        Text(
                                          item.facilityName ?? "",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        ),
                                      );
                                    }).toList(),
                                    value: selectedValue, // This should be a FacilityDropdownModel?
                                    onChanged: (FacilityDropdownModel? value) {
                                      setState(() {
                                        selectedValue = value;
                                      });
                                      dashBoardBloc.add(GetDashbaordEvent(
                                          type: widget.daysType ?? "today",
                                          clientId: clientId,
                                          janitorId: selectedValue!.id!.toString(),
                                          locationId: widget.facilityId!));
                                    },

                                    buttonStyleData: ButtonStyleData(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      height: 40,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withAlpha(50), // ✅ Corrected
                                            spreadRadius: 1,
                                            blurRadius: 10,
                                            offset: const Offset(0, 0),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    menuItemStyleData:
                                    const MenuItemStyleData(height: 40),
                                  ),
                                ),
                              ),

                            ],
                          ),
                          Center(
                            child: ChartPie(
                              complatedTask: dashboardModel == null
                                  ? "0"
                                  : dashboardModel!
                                  .results!
                                  .taskStatusDistribution!
                                  .completedCount ??
                                  "0",
                              pendingTask: dashboardModel == null
                                  ? "0"
                                  : dashboardModel!
                                  .results!
                                  .taskStatusDistribution!
                                  .pendingCount ??
                                  "0",
                              totalTask: dashboardModel == null
                                  ? "0"
                                  : dashboardModel!
                                  .results!
                                  .janitorEfficiency!
                                  .totaltask.toString() ??
                                  "0",
                              accetedTask: dashboardModel == null
                                  ? "0"
                                  : dashboardModel!
                                  .results!
                                  .taskStatusDistribution!
                                  .acceptedCount ??
                                  "0",
                              ongoingTask: dashboardModel == null
                                  ? "0"
                                  : dashboardModel!
                                  .results!
                                  .taskStatusDistribution!
                                  .ongoingCount ??
                                  "0",
                              rejectedTask: dashboardModel == null
                                  ? "0"
                                  : dashboardModel!
                                  .results!
                                  .taskStatusDistribution!
                                  .rejectedCount ??
                                  "0",
                              rfcTask: dashboardModel == null
                                  ? "0"
                                  : dashboardModel!
                                  .results!
                                  .taskStatusDistribution!
                                  .closureCount ??
                                  "0",
                              complatedPercentage: dashboardModel == null
                                  ? "0%"
                                  : dashboardModel!
                                  .results!
                                  .taskStatusDistribution!
                                  .completedPercentage,
                              acceptedPercentage: dashboardModel == null
                                  ? "0%"
                                  : dashboardModel!
                                  .results!
                                  .taskStatusDistribution!
                                  .acceptedPercentage,
                              ongoingPercentage: dashboardModel == null
                                  ? "0%"
                                  : dashboardModel!
                                  .results!
                                  .taskStatusDistribution!
                                  .ongoingPercentage,
                              pendingPercentage: dashboardModel == null
                                  ? "0%"
                                  : dashboardModel!
                                  .results!
                                  .taskStatusDistribution!
                                  .pendingPercentage,
                              //  rejectedPercentage: ,
                              rejectedPercentage: dashboardModel == null
                                  ? "0%"
                                  : dashboardModel!
                                  .results!
                                  .taskStatusDistribution!
                                  .rejectedPercentage,
                              rfcPercentage: dashboardModel == null
                                  ? "0%"
                                  : dashboardModel!
                                  .results!
                                  .taskStatusDistribution!
                                  .closurePercentage,
                            ),
                          ),
                        ],
                      );
                    }),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget hostContainer() {
    return Container(
      // width: double.infinity,
      height: 200,

      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2), // Shadow color
            spreadRadius: 1, // How wide the shadow should spread
            blurRadius: 10, // The blur effect of the shadow
            offset: const Offset(0, 0), // No offset for shadow on all sides
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ClientConstant.becomeWolooHostTitle,
                style:
                AppTextStyle.font20.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                ClientConstant.becomeWolooHostDescription,
                style: AppTextStyle.font12,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonYellowColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                  iconAlignment: IconAlignment.end,
                  icon: CustomImageProvider(
                    image: ClientImages.arrow,
                    width: 34,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return const HostBottomsheet();
                      },
                    );
                  },
                  label: Text(
                    "Explore",
                    style: AppTextStyle.font16bold
                        .copyWith(color: AppColors.black),
                  ))
            ],
          ),
          CustomImageProvider(image: ClientImages.about)
        ],
      ),
    );
  }

  Widget premiumContainer(BuildContext context) {
    return Container(
      height: 280,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(80.0),
          topRight: Radius.circular(80.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: CustomImageProvider(
                image: ClientImages.line,
                width: 70,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              // width: double.infinity,
              height: 103,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2), // Shadow color
                    spreadRadius: 1, // How wide the shadow should spread
                    blurRadius: 10, // The blur effect of the shadow
                    offset:
                    const Offset(0, 0), // No offset for shadow on all sides
                  ),
                ],
              ),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomImageProvider(image: ClientImages.about, width: 80),
                  // Spacer(),
                  SizedBox(
                    width: 4.w,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ClientConstant.upgradeToPremiumTitle,
                        style: AppTextStyle.font20.copyWith(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.9,
                        height: 50,
                        child: Text(
                          overflow: TextOverflow.visible,
                          maxLines: 3,
                          ClientConstant.upgradeToPremiumDescription,
                          style: AppTextStyle.font12.copyWith(fontSize: 12),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
                onTap: () async {
                  //  print("isOnboard $isOnboard"),
                  // GlobalStorage globalStorage.setIsPremium(true),

                  if (isOnboard!) {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PremiumScreeen(
                          indexTab: widget.tabIndex,
                          tabController: widget.tabController,
                          clientDashBoardBloc: widget.clientDashBoardBloc,
                          fromTabbar: false,
                        ),
                      ),
                    );
                    print("premiumn by subcription $result");
                    print("printdataindex ${widget.facility!} ");
                    if (result != null) {
                      Navigator.of(context).pop();
                    }

                    print(
                        "printdataindex ${widget.facility!.indexOf(result)} ");
                  } else {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IotOnbaord(
                          clientDashBoardBloc: widget.clientDashBoardBloc,
                        ),
                      ),
                    );

                    print("premiumn by onbaord subcription $result");

                    if (result != null) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: const Custombutton(
                    text: "Let's go", width: double.infinity))
          ],
        ),
      ),
    );
  }
}