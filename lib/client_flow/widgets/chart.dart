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
  const Charts(
      {super.key,
      this.facilityId,
      this.plan,
      this.status,
      this.tabIndex,
      this.tabController,
      this.facility,
      this.clientDashBoardBloc,
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

    var some = globalStorage.getClientToken();
    clientId = globalStorage.getClientId();
    isOnboard = globalStorage.isOnboard();
    decodedToken = JwtDecoder.decode(some);
     if(widget.facility![widget.tabIndex!].id  == 1 ){
     
     }else{
            dashBoardBloc.add(FacilityByJanitorEvent(
        facilityId: widget.facility![widget.tabIndex!].id!,
        clientId: int.parse(clientId)));
     }
 
  }

  //  @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
    
  //     dashBoardBloc.add(FacilityByJanitorEvent(
  //       facilityId: widget.facility![widget.tabIndex!].id!,
  //       clientId: int.parse(clientId)));

  // }
 
  @override
  void didUpdateWidget(covariant Charts oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
       print("object old widget $oldWidget");
        //   dashBoardBloc.add(FacilityByJanitorEvent(
        // facilityId: widget.facility![widget.tabIndex!].id!,
        // clientId: int.parse(clientId)));
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
            ], color: AppColors.white, borderRadius: BorderRadius.circular(40)),
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
      
                        janitorName = state.taskModel!.results.data;
                        for (var janitor in janitorName) {
                          facilitydropdownNames.add(FacilityDropdownModel(
                            facilityName: janitor.name,
                            id: janitor.id,
                          ));
                        }
      
      
      
      
                        selectItem = facilitydropdownNames.first;
      
                        dashBoardBloc.add(GetDashbaordEvent(
                            type: "today",
                            clientId: clientId,
                            janitorId: facilitydropdownNames.first.id!.toString(),
                            locationId: widget.facilityId!));
                        //  facilitydropdown = dashbaordModel.results.
                        if (widget.plan == "CLASSIC" &&
                            widget.status == "active") {
                          Future.delayed(const Duration(seconds: 3), () {
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) {
                                  return premiumContainer(context);
                                }).then((value) {
                                  Navigator.of(context).pop();
                                },  );
                          });
                        } else if (widget.plan == "PREMIUM" &&
                            widget.status == "inactive") {
                          //PREMIUM
                          Future.delayed(const Duration(seconds: 3), () {
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) {
                                  return premiumContainer(context);
                                }).then((value) {
                                  Navigator.of(context).pop();
                                },  );;
                          });
                        }
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
                     facilitydropdownNames =   facilitydropdownNames.toSet().toList();
                        // setState(() {
                          
                        // });
                       String palnId =     globalStorage.getPlanId();
                        selectItem = facilitydropdownNames.first;
      
                        dashBoardBloc.add(GetDashbaordEvent(
                            type: "today",
                            clientId: clientId,
                            janitorId: facilitydropdownNames.first.id!.toString(),
                            locationId: widget.facilityId!));
      
                        print("objectttttttttt ${widget.isFutureSub}");
      
                        if (widget.plan == "CLASSIC" &&
                            widget.status == "active"  && palnId != "0" && widget.isFutureSub == false ) {
                          Future.delayed(const Duration(seconds: 3), ()async {
                           
                             await  showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (con) {
                                  return premiumContainer(con);
                                });
      
                            
                          });
                        } else if (widget.plan == "PREMIUM" &&
                            widget.status == "inactive"  && palnId != "0" && widget.isFutureSub == false ) {
                          //PREMIUM
                          Future.delayed(const Duration(seconds: 3), () {
                                
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) {
                                  return premiumContainer(context);
                                });
                                // .then((value) {
                                //   Navigator.of(context).pop();
                                // },  );
                                //      if (mounted) {
      
                                //    Navigator.of(context).pop(); // This will now work
                                   
                                //     }
                          });
                        }
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
      
                        print(
                            "sdfkhjslkdfjsd ${dashboardModel!.results!.taskStatusDistribution!.ongoingCount} ");
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
                                child: Text(
                                  DashboardConst.taskAudit,
                                  style: AppTextStyle.font20bold,
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
                                              color: Theme.of(context).hintColor,
                                            ),
                                          )
                                        : Text(
                                            selectItem!.facilityName ?? "",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context).hintColor,
                                            ),
                                          ),
      
                                    items: facilitydropdownNames
                                        .map((FacilityDropdownModel item) {
                                      return DropdownMenuItem<
                                          FacilityDropdownModel>(
                                        value: item,
                                        child: Text(
                                          item.facilityName ?? "",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      );
                                    }).toList(),
                                    value:
                                        selectedValue, // This should be a FacilityDropdownModel?
                                    onChanged: (FacilityDropdownModel? value) {
                                      setState(() {
                                        selectedValue = value;
                                      });
                                      dashBoardBloc.add(GetDashbaordEvent(
                                          type: "today",
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
      
                              // );
                              // )
      
                              // Padding(
                              //   padding: const EdgeInsets.only(right : 20),
                              //   child: Padding(
                              //     padding: const EdgeInsets.symmetric(
                              //         horizontal: 10.0, vertical: 0.0),
                              //     child:
                              //       DropDownDialog(
                              //         width: 150,
                              //         isprop: true,
                              //         hintTextStyle: AppTextStyle.font10,
                              //         padding: const EdgeInsets.symmetric(
                              //           vertical: 10,
                              //           horizontal: 4
                              //         ),
      
                              //         selected: selectItem,
                              //         // "its me",
      
                              //         //  facilitydropdownNames.first.facilityName,
                              //         // selected: clusterNames.first,
                              //         // key: _dropDownKey,
                              //         // widgetKey: _clusterNameKey,
                              //         hint:"Select Task Buddy",
      
                              //         items: facilitydropdownNames,
      
                              //         itemAsString: (FacilityDropdownModel item) =>
                              //         item.facilityName,
                              //         onChanged: (FacilityDropdownModel item) {
                              //           debugPrint("in drop down ${item.locationName}");
                              //           try {
      
                              //             dashBoardBloc.add(GetDashbaordEvent(
                              //                 type: "today",
                              //                 clientId: clientId,
                              //                 janitorId: item.id!,
      
                              //                 locationId: widget.facilityId!   ));
      
                              //             // locationController.text =   item.locationName!;
                              //             // facilityController.text = item.facilityName!;
                              //             setState(() {});
      
                              //             // clusterId = item..id!;
                              //             // reportIssueBloc.add(GetAllFacilityDropdown(
                              //             //     clusterId: item.clusterId ?? 0));
                              //             //
                              //             //   // if(state is GetFacilityDropdownSuccess ){
                              //             //     reportIssueBloc.add(GetAllTasksDropdown(
                              //             //         clusterId: item.clusterId! ?? 0
                              //             //     ));
                              //             //   // }else
                              //             //    // if( state is  GetTasksDropdownSuccess ){
                              //             //      reportIssueBloc.add(GetAllJanitorsDropdown(
                              //             //          clusterId: item.clusterId ?? 0));
                              //             // }
      
                              //           } catch (e) {
                              //             debugPrint("dropppppp$e");
                              //           }
                              //         },
                              //         validator: (value) =>
                              //         value == null
                              //             ?
                              //             "Please select facility"
                              //             : null,
                              //       )
                              //     // DropdownButton<String>(
                              //     //   value: dropdownValue,
                              //     //   icon: const Icon( Icons.keyboard_arrow_down,
                              //     //    size: 30,
                              //     //   ),
                              //     //   elevation: 16,
                              //     //   onChanged: (newValue) {
                              //     //     setState(() {
                              //     //       dropdownValue = newValue;
                              //     //     });
                              //     //   },
                              //     //   hint: Text("Select Task Buddy",
                              //     //    style: AppTextStyle.font10bold,
                              //     //   ),
                              //     //   underline: SizedBox(),
      
                              //     //   items: <String>['City', 'Country', 'State']
                              //     //       .map<DropdownMenuItem<String>>((String value) {
                              //     //     return DropdownMenuItem<String>(
                              //     //       value: value,
                              //     //       child: Text(value),
                              //     //     );
                              //     //   }).toList(),
                              //     // ),
                              //   ),
                              // )
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
                                  : dashboardModel!.results!
                                          .taskStatusDistribution!.pendingCount ??
                                      "0",
                              totalTask: dashboardModel == null
                                  ? "0"
                                  : dashboardModel!.results!
                                          .taskStatusDistribution!.pendingCount ??
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
                                  : dashboardModel!.results!
                                          .taskStatusDistribution!.ongoingCount ??
                                      "0",
                              rejectedTask: "0",
                              rfcTask: "0",
                              complatedPercentage: dashboardModel == null
                                  ? "0%"
                                  : dashboardModel!
                                      .results!
                                      .taskStatusDistribution!
                                      .completedPercentage,
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
      
          // const SizedBox(
          //   height: 20,
          // ),
      
          //
          // BlocConsumer (
          //   bloc: dashBoardBloc,
          //   listener: (context, state) {
          //     if ( state is DashboarLoading  ){
          //
          //       EasyLoading.show(status: state.message);
          //     }
          //
          //     if (state is DashbaordTask  ) {
          //       EasyLoading.dismiss();
          //
          //       dashbaordModel = state.dashbaordModel;
          //
          //       print("$dashbaordModel objectttttttttttt");
          //     }
          //
          //     if(state is DashboarError  ){
          //       EasyLoading.dismiss();
          //       EasyLoading.showError( state.error.message);
          //
          //     }
          //
          //   },
          //   builder: (context, state) {
          //     return DualBarChart(
          //       value1: dashbaordModel == null ?  [] : dashbaordModel!.results!.janitorEfficiency!.totaltask!
          //           .map((e) => double.tryParse(e.toString()) ?? 0.0) // Convert and handle errors
          //           .toList(),
          //       value2: dashbaordModel == null ?  [] : dashbaordModel!.results!.janitorEfficiency!.closedtask!
          //           .map((e) => double.tryParse(e.toString()) ?? 0.0) // Convert and handle errors
          //           .toList(),
          //     );
          //   }
          // )
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
                    offset:
                        const Offset(0, 0), // No offset for shadow on all sides
                  ),
                ],
              ),
              child: Row(
                children: [
                  CustomImageProvider(image: ClientImages.about),
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
                        height: 5,
                      ),
                      Text(
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                        ClientConstant.upgradeToPremiumDescription,
                        style: AppTextStyle.font12.copyWith(fontSize: 12),
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

                    // print(
                    //     "printdataindex ${widget.facility!.indexOf(result)} ");
                  } else {
                   final result = await  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  IotOnbaord(
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

class DualBarChart extends StatelessWidget {
  List<double>? value1;
  List<double>? value2;

  DualBarChart({super.key, this.value1, this.value2});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 400,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2), // Shadow color
          spreadRadius: 1, // How wide the shadow should spread
          blurRadius: 10, // The blur effect of the shadow
          offset: const Offset(0, 0), // No offset for shadow on all sides
        ),
      ], color: AppColors.white, borderRadius: BorderRadius.circular(40)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              DashboardConst.janitorPerformance,
              style: AppTextStyle.font20bold,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 200,
            width: 400,
            child: BarChart(
              BarChartData(
                barGroups: _getBarGroups(value1!, value2!),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  drawHorizontalLine: true,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(color: Colors.grey, strokeWidth: 1);
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      // interval: 5,
                      reservedSize: 30,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final labels = [
                          'Janitor',
                          'Janitor 1',
                          'Janitor 2',
                          'Janitor 3',
                          'Janitor 4'
                        ];
                        if (value.toInt() >= 0 &&
                            value.toInt() < labels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              labels[value.toInt()],
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups(
      List<double> total, List<double> closed) {
    final List<double> values1 = total;
    final List<double> values2 = closed;
    return List.generate(values1.length, (index) {
      return BarChartGroupData(
        x: index,
        barsSpace: 0,
        barRods: [
          BarChartRodData(
            toY: values1[index],
            color:
                Colors.blue, // Replace with AppColors.backgroundColor if needed
            width: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          BarChartRodData(
            toY: values2[index],
            color: const Color(0xff717171),
            width: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }
}
