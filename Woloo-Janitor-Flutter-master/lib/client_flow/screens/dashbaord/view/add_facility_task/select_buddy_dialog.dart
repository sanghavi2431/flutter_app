import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/add_facility_task/show_task_buddy_dialog.dart';

import '../../../../../core/local/global_storage.dart';
//import '../../../../../screens/report_issue_screen/data/model/facility_dropdown_model.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/app_textstyle.dart';
import '../../../../widgets/CustomButton.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../bloc/dashboard_event.dart';
import '../../bloc/dashboard_state.dart';
import '../../controller/dashbaord_controller.dart';
import '../../data/model/facility_dropdown_model.dart';
import '../../data/model/facility_model.dart';
import '../../data/model/task_model.dart';
import '../widget/select_buddy_dailog.dart';

selectBuddyDailog(Datum? selectedbuddy , String? selectedJanitor ,bool isBuddySelected ,
    BuildContext context , ClientDashBoardBloc dashBoardBloc,
    //List<FacilityDropdownModel>? facilitydropdownNames ,
    List<Facility> facilityList ,
    DashBoardController dashController , int? estimatedTime , TimeOfDay? shiftTime ,


    ) async {
  GlobalStorage globalStorage = GetIt.instance();
  late TaskModel taskModel;
  List<FacilityDropdownModel>? facilitydropdownNames;
  {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: AppColors.white,
          content: BlocConsumer(
            listener: (context, state) {
              // print("dfsdfsd$state");
              if (state is DashboarLoading) {
                EasyLoading.show(status: state.message);
              }
              if (state is GetAllJanitor) {
                EasyLoading.dismiss();

                taskModel = state.taskModel!;
                showTaskBuddyDailog(
                    state.taskModel,  selectedJanitor,
                    isBuddySelected, context, dashBoardBloc);
              }
              if (state is GetAllFacility) {
                final updatedList = state.facilityModel!.results!.facilities!;

                facilitydropdownNames = []; // initialize

                for (var item in updatedList) {
                  if (item.subscriptionStatus == "active" || item.isFreeTrial == true) {
                    facilitydropdownNames!.add(
                      FacilityDropdownModel(
                        id: item.id,
                        facilityName: item.facilityName,
                        locationName: item.locationName,
                        facalityType: item.facilityType,
                        endTime: item.shifts!.isEmpty ? "" : item.shifts!.first.endTime,
                        startTime: item.shifts!.isEmpty ? "" : item.shifts!.first.startTime,
                        clusterId: item.clusterId,
                      ),
                    );
                  }
                }

                /// ✅ Correct condition check
                if (updatedList.every((e) =>
                e.subscriptionStatus == "inactive" && e.isFreeTrial == false)) {
                  Fluttertoast.showToast(
                    msg: "All facilities are inactive.Please activate at least one facility to proceed.",
                    backgroundColor: Colors.red,
                  );
                } else {
                  String clientid = globalStorage.getClientId();
                  dashBoardBloc.add(FacilityTypeEvent(clientId: int.parse(clientid)));
                }

                dashBoardBloc.add(const GetTaskEvent(category: "Home"));
              }

              if (state is DashboarError) {
                EasyLoading.dismiss();
                EasyLoading.showError(state.error);
              }
            },
            bloc: dashBoardBloc,
            builder: (context, state) =>
                SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[

                      SizedBox(
                        height: 20.h,
                      ),

                      Text(
                        textAlign: TextAlign.center,
                        DashboardConst.taskBuddyPrompt,
                        style: AppTextStyle.font14w7,
                      ),

                      SizedBox(
                        height: 20.h,
                      ),

                      GestureDetector(
                        onTap: () {

                          dashController.taskStartTime.clear();
                          dashController.taskEndTime.clear();
                          dashController.taskTimes.clear();
                          selectedbuddy = null;
                          estimatedTime = null;
                          shiftTime = null;

                          String clintId = globalStorage.getClientId();
                          dashBoardBloc.add(
                              GetAllFacilityEvent(clientId: int.parse(
                                  clintId)));
                          // //  facilityBottomSheet();
                        },
                        child: Custombutton(
                            height: 35.h,
                            textColor: AppColors.black,
                            // color: AppColors.greyBgColor,
                            // color: ,
                            text: DashboardConst.assignNewTaskBuddy,
                            width: 320.w),
                      ),

                      SizedBox(
                        height: 20.h,
                      ),

                      GestureDetector(
                        onTap: () {
                          String clientId = globalStorage.getClientId();

                          print("dfgfd $clientId");

                          dashBoardBloc.add(GetAllJanitorEvent(
                            clientId: int.parse(clientId),
                          ));
                        },
                        child: Custombutton(
                            height: 35.h,
                            text: DashboardConst.assignExistingTaskBuddy,
                            width: double.infinity),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ),
          ),
        );
      },
    );
  }
}

