import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get_it/get_it.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/bloc/dashboard_bloc.dart';
import '../../../../../core/local/global_storage.dart';
import '../../../../../screens/common_widgets/image_provider.dart';
import '../../../../../screens/report_issue_screen/data/model/facility_dropdown_model.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/app_textstyle.dart';
import '../../../../utils/client_images.dart';
import '../../../../widgets/CustomButton.dart';
import '../../bloc/dashboard_event.dart';
import '../../bloc/dashboard_state.dart';
import '../../controller/dashbaord_controller.dart';
import '../../data/model/task_model.dart';
import '../../data/model/tasklist_model.dart';
import '../../data/model/tasktime_model.dart';
import '../../model/facility_type_model.dart';
import '../widget/add_time_dailog.dart';
import 'assign_task_header.dart';

Future<void> taskExistingBottomSheet({
  required Datum buddy,
  required FacilityDropdownModel? selectedFacility,
  required DashBoardController dashController,
  required TextEditingController janNameController,
  required BuildContext context,
  required ClientDashBoardBloc dashBoardBloc,
  required MultiSelectController<TaskDropdownModel> dropController,
  required bool isNext,
  required bool isTaskSelected,
  required int? deleteIndex,
  required int? estimatedTime,
  required Datum? selectedbuddy,
required TextEditingController facilityController,
required TextEditingController locationController,
required GlobalStorage globalStorage,
  required List<DropdownItem<TaskDropdownModel>> items,
  required GlobalKey<FormState> formKey,
  required List<TaskTimeModel> taskTimeModel,
  required List<TaskTimeModel> taskTimes,
  required int? len,
  required List<String>? taskName,
  required List<int> selectedId,
  required List<int?> taksIds,
  required TimeOfDay? shiftTime,
  required List<TaskDropdownModel> facilityNames,
  required List<TypeFacility>? facilityType,
  required int selectedIndex,

}) async {
  dashController.taskTimeModel.clear();

    dashController.taskTimes.clear();
  String? use12hour = "00:00";
    janNameController.text = buddy.name!;
    for (var item in buddy.taskTimes!) {
      print("start time ${item.startTime}");
      print("end time ${item.endTime}");
      String formattedStartDate =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(item.startTime!);
      String formattedEndDate =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(item.endTime!);

      TimeOfDay startTime = convertToTimeOfDay(formattedStartDate);
      TimeOfDay endTime = convertToTimeOfDay(formattedEndDate);

      print("start time ${startTime}");
      print("end time ${endTime}");

      dashController.taskTimeModel.add(TaskTimeModel(
        taskId: item.taskId!,
        endTime: endTime,
        startTime: startTime,
        facilityName: item.facilityName!,
        facilityType: item.facilityType!,
        taskName: item.taskNames,
        // taskIds: item.taskId
      ));

      print("lenght ${dashController.taskTimeModel.length}");

    }



  Future<void> loadFacilities() async {
    final items = facilityNames
        .map((element) => DropdownItem(
      label: element.facilityName!,
      value: element,
    ))
        .toList();

    dropController.setItems(items);
  }

  Future<void> showMyDialog(bool isFromExiting, {Datum? janitor}) async {
    showDialog(
      context: context,
      builder: (context) {
        return AddTimeDailog(
          estimatedTime: estimatedTime!,
          startTime: shiftTime,
          endTime: use12hour,
          isFromExisting: isFromExiting,
          janitorId: janitor?.id,
          facalityName: facilityController.text,
          facilityType: facilityType![selectedIndex].typeName,
          taskName: taskName,
          taskIds: selectedId,
        );
      },
    );
  }

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return BlocConsumer(
          bloc: dashBoardBloc,
          listener: (context, state) {
            print("deltet testdd $state");

            if (state is DashboarLoading) {
              EasyLoading.show(status: state.message);
            }

            if (state is DeltetTaskTime) {
              EasyLoading.dismiss();
              dashController.taskTimeModel.removeAt(deleteIndex!);
              dashController.taskTimes.removeAt(deleteIndex!);

              print(" task melde ${dashController.taskTimeModel} ");
              print(" task melde ${dashController.taskTimes} ");

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                    backgroundColor: AppColors.white,
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          CustomImageProvider(
                            image: ClientImages.verify,
                            width: 86.w,
                            height: 86.h,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            '${state.deleteModel!.results.message}',
                            style: AppTextStyle.font18bold,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              //  Navigator.of(context).pop();
                            },
                            child: const Custombutton(
                              width: 300,
                              text: "Go Back",
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );

              ;

            }


            if (state is DashboarError) {
              EasyLoading.dismiss();
              EasyLoading.showError(state.error);
            }
          },
          builder: (context, state) {
            return StatefulBuilder(builder: (context, StateSetter setState) {
              return DraggableScrollableSheet(
                  initialChildSize: 0.8,
                  minChildSize: 0.8,
                  maxChildSize: 0.9,
                  builder: (context, scrollController) {
                    return Form(
                      key: formKey,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(80.0),
                            topRight: Radius.circular(80.0),
                          ),
                        ),
                        height: MediaQuery.of(context).size.height / 1.11,
                        child: Center(
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 15),
                            child: ListView(
                              controller: scrollController,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                AssignTaskHeader(title:DashboardConst.assignTasks, subTitle: "Tasks",
                                    image: ClientImages.checklist),
                                // const SizedBox(
                                //   height: 20,
                                // ),
                                // Center(
                                //   child: Text(DashboardConst.assignTasks,
                                //     style: AppTextStyle.font18bold,
                                //   ),
                                // ),
                                const SizedBox(
                                  height: 20,
                                ),
                                selectedbuddy != null
                                    ? Padding(
                                  padding: EdgeInsets.only(left: 8.h),
                                  child: Text(
                                    "Buddy Name : ${selectedbuddy!.name}",
                                    style: AppTextStyle.font14bold,
                                  ),
                                )
                                    : const SizedBox(),

                                selectedbuddy != null
                                    ? const SizedBox(
                                  height: 10,
                                )
                                    : const SizedBox(),

                                Container(
                                  // height: 55,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                            alpha: 0.2), // Shadow color
                                        spreadRadius:
                                        1, // How wide the shadow should spread
                                        blurRadius:
                                        10, // The blur effect of the shadow
                                        offset: const Offset(0,
                                            5), // Shadow offset, with y-offset for bottom shadow
                                      ),
                                    ],
                                    // color: enabled ? color ??  AppColors.backgroundColor : AppColors.disabledButtonColor,
                                    borderRadius: BorderRadius.circular(7),
                                  ),

                                  child: MultiDropdown<TaskDropdownModel>(
                                    items: items,
                                    controller: dropController,
                                    enabled: true,

                                    selectedItemBuilder: (item) {
                                      return Text(
                                        item.label,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff8F8F8F)),
                                      );
                                    },

                                    // searchEnabled: true,
                                    chipDecoration: const ChipDecoration(
                                      backgroundColor: Colors.yellow,
                                      wrap: true,
                                      runSpacing: 2,
                                      spacing: 10,
                                    ),
                                    fieldDecoration: const FieldDecoration(
                                        borderRadius: 7,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        hintText: DashboardConst
                                            .selectCleaningTasks,
                                        hintStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff8F8F8F)),
                                        // prefixIcon: const Icon(CupertinoIcons.flag),
                                        showClearIcon: false,
                                        border: InputBorder.none

                                    ),

                                    dropdownDecoration: DropdownDecoration(
                                      footer: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 16),
                                        child: GestureDetector(
                                            onTap: () {
                                              dropController.closeDropdown();
                                              //  Navigator.of(context).pop();
                                            },
                                            child: const Custombutton(
                                                text: "Done",
                                                width: double.infinity)),
                                      ),
                                      borderRadius: BorderRadius.circular(7),
                                      marginTop: 2,
                                      maxHeight:
                                      MediaQuery.of(context).size.height <
                                          640
                                          ? 250
                                          : MediaQuery.of(context)
                                          .size
                                          .height <
                                          733
                                          ? 350
                                          : 450,


                                    ),


                                    itemBuilder: (item, index, onTap) {
                                      final isSelected = dropController
                                          .selectedItems
                                          .contains(item);

                                      return ListTile(
                                        minTileHeight: 25,
                                        leading: Checkbox(
                                          shape: RoundedRectangleBorder(
                                            // side: const BorderSide(
                                            //     color: Colors.black, // border color
                                            //     width: 0.3,           // 👈 border thickness
                                            //   ),
                                            borderRadius:
                                            BorderRadius.circular(6),
                                          ),
                                          activeColor: Colors.yellow,
                                          checkColor: Colors.black,
                                          value: isSelected,
                                          onChanged: (_) =>
                                              onTap(), // manually toggle
                                        ),
                                        title: Text(
                                          item.label,
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height <
                                                  640
                                                  ? 12
                                                  : 15,
                                              // color: Color(0xff8BDFFB),
                                              color: const Color(0xff8F8F8F),
                                              fontWeight: FontWeight.w700),
                                        ),
                                        trailing: Text(
                                          "+ ${item.value.requiredTime.toString()} min",
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height <
                                                  640
                                                  ? 12
                                                  : 15,
                                              color: const Color(0xff8BDFFB),
                                              fontWeight: FontWeight.w700),
                                        ),
                                      );
                                    },

                                    onSelectionChange: (selectedItems) {
                                      List<int?> listTime = [];

                                      taskName = selectedItems
                                          .map((e) => e.facilityName!)
                                          .toList();

                                      selectedId = selectedItems
                                          .map((e) => e.id!)
                                          .toList();
                                      print(" selected items $selectedId ");

                                      len = selectedItems.length;

                                      listTime = selectedItems
                                          .map((e) => e.requiredTime)
                                          .toList();

                                      print("total time $estimatedTime");
                                      if (selectedItems.isEmpty) {
                                        estimatedTime = null;
                                      } else if (selectedItems.isNotEmpty) {
                                        estimatedTime = listTime
                                            .reduce((a, b) => a! + b!);
                                        taksIds = selectedItems
                                            .map((e) => e.id)
                                            .toList();
                                      } else if (selectedItems.isNotEmpty &&
                                          len! < selectedItems.length) {
                                        listTime = selectedItems
                                            .map((e) => e.requiredTime)
                                            .toList();
                                        estimatedTime = listTime
                                            .reduce((a, b) => a! - b!);
                                      }

                                      print("estimagte $estimatedTime ");

                                      // if(i.isEmpty ){
                                      //    estimatedTime = 0;
                                      // }
                                      setState(() {});

                                      debugPrint(
                                          "OnSelectionChange: $selectedItems");
                                    },
                                  ),
                                ),

                                estimatedTime == null && isTaskSelected
                                    ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    children: [
                                      // const SizedBox(
                                      //   height: 10,
                                      // ),
                                      Text(
                                        "Please select Tasks",
                                        style: AppTextStyle.font12
                                            .copyWith(
                                            color: AppColors.red),
                                      ),
                                    ],
                                  ),
                                )
                                    : const SizedBox(
                                  // height: ,
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                Center(
                                  child: Text(
                                    DashboardConst
                                        .estimatedTaskCompletionTime,
                                    style: AppTextStyle.font20.copyWith(
                                        color: const Color(0xff8F8F8F)),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: estimatedTime == null
                                      ? Text(
                                    '00:00',
                                    style: AppTextStyle.font24bold,
                                  )
                                      : Text(
                                    "$estimatedTime min",
                                    style: AppTextStyle.font24bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 55,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 13),
                                  decoration: BoxDecoration(
                                    // color: const Color(0xffBEBEBE),
                                    border: Border.all(
                                      color: const Color(0xffBEBEBE),
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DashboardConst.scheduleShift,
                                        style: AppTextStyle.font14w7.copyWith(
                                            color: const Color(0xff828282)),
                                      ),
                                      Text(
                                        "24 hours",
                                        style: AppTextStyle.font14w7.copyWith(
                                            color: const Color(0xff464646)),
                                      ),

                                    ],
                                  ),
                                ),



                                const SizedBox(
                                  height: 20,
                                ),

                                Container(
                                  // height:
                                  // 70 ,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                            alpha: 0.2), // Shadow color
                                        spreadRadius:
                                        1, // How wide the shadow should spread
                                        blurRadius:
                                        10, // The blur effect of the shadow
                                        offset: const Offset(0,
                                            0), // No offset for shadow on all sides
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            // const SizedBox(
                                            //   height: 10,
                                            // ),
                                            Text(
                                              DashboardConst.scheduleTask,
                                              style: AppTextStyle.font14w7,
                                            ),
                                            GestureDetector(
                                                onTap: () {
                                                  print(
                                                      "erstimage $estimatedTime");
                                                  print(
                                                      "is slecrete $isTaskSelected");
                                                  isTaskSelected = true;
                                                  setState(() {});
                                                  estimatedTime != null
                                                      ? showMyDialog(true,
                                                      janitor:
                                                      selectedbuddy)
                                                      .then(
                                                        (value) {
                                                      isTaskSelected =
                                                      false;
                                                    },
                                                  )
                                                      : null;

                                                  // janitorBottomSheet()
                                                },
                                                child: Custombutton(
                                                    text: DashboardConst
                                                        .addTimings,
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height <
                                                        640
                                                        ? 120
                                                        : 140))
                                          ],
                                        ),
                                        dashController
                                            .taskStartTime.isEmpty &&
                                            isNext
                                            ? Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Please add Timing for tasks",
                                              style: AppTextStyle.font12
                                                  .copyWith(
                                                  color: AppColors
                                                      .red),
                                            ),
                                          ],
                                        )
                                            : const SizedBox(
                                          // height: ,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Obx(
                                              () => dashController
                                              .taskTimeModel.isEmpty
                                              ? const SizedBox()
                                              : const Divider(
                                            color: Color(0xff828282),
                                            thickness: 1,
                                          ),
                                        ),
                                        Obx(
                                              () => SizedBox(
                                            height: dashController
                                                .taskTimeModel.isEmpty
                                                ? 0
                                                : MediaQuery.of(context)
                                                .size
                                                .height /
                                                5,
                                            child: ListView.builder(
                                              primary: false,
                                              shrinkWrap: true,
                                              physics:
                                              const ClampingScrollPhysics(),
                                              itemCount: dashController
                                                  .taskTimeModel.length,
                                              itemBuilder: (context, index) {

                                                return Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    dividerColor: Colors
                                                        .transparent, // Remove the default divider
                                                  ),
                                                  child: ExpansionTile(
                                                      tilePadding:
                                                      const EdgeInsets
                                                          .all(0),
                                                      childrenPadding:
                                                      const EdgeInsets
                                                          .all(0),
                                                      expandedAlignment:
                                                      Alignment.topLeft,
                                                      expandedCrossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      title: ListTile(
                                                        contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 4,
                                                            horizontal:
                                                            2),
                                                        minLeadingWidth: 0,
                                                        trailing:
                                                        GestureDetector(
                                                          onTap: () {
                                                            deleteIndex =
                                                                index;
                                                            setState(() {});
                                                            print(
                                                                "DELETE DATE");
                                                            showDialog(
                                                              context:
                                                              context,
                                                              builder:
                                                                  (context) =>
                                                                  AlertDialog(
                                                                    contentPadding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        0),
                                                                    shape:
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                      BorderRadius.circular(
                                                                          26),
                                                                    ),
                                                                    backgroundColor:
                                                                    AppColors
                                                                        .white,
                                                                    // title: const Text("Logout"),
                                                                    content:
                                                                    SizedBox(
                                                                      height: 175,
                                                                      child:
                                                                      Column(
                                                                        children: [
                                                                          const SizedBox(
                                                                            height:
                                                                            30,
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets
                                                                                .symmetric(
                                                                                horizontal: 30),
                                                                            child:
                                                                            Center(
                                                                              child:
                                                                              Text(
                                                                                textAlign: TextAlign.center,
                                                                                "Are you sure you want to delete the current time?",
                                                                                style: AppTextStyle.font15.copyWith(fontSize: 15, color: AppColors.black, fontWeight: FontWeight.w700),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                            20,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              GestureDetector(
                                                                                  onTap: () async {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: Custombutton(color: AppColors.white, text: "No", width: 100.w)),
                                                                              GestureDetector(
                                                                                  onTap: () async {
                                                                                    print("DELETE $index ");
                                                                                    // dashController.taskTimeModel.removeAt(index);
                                                                                    //  print("task time  ${dashController.taskTimeModel[index].taskId}");
                                                                                    if (dashController.taskTimeModel[index].taskId != 0) {
                                                                                      dashBoardBloc.add(DeleteEvent(taskId: dashController.taskTimeModel[index].taskId));
                                                                                    } else {
                                                                                      dashController.taskTimeModel.removeAt(index);
                                                                                      dashController.taskTimes.removeAt(index);

                                                                                      //  print("task time model ${dashController.taskTimes}");
                                                                                    }

                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: Custombutton(text: "Yes", width: 100.w))
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                            30,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),

                                                                  ),
                                                            );

                                                          },

                                                          child: CustomImageProvider(
                                                              image:
                                                              ClientImages
                                                                  .delete,
                                                              width: 25,
                                                              height: 25),

                                                        ),
                                                        title: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                    "${dashController.taskTimeModel[index].facilityName}",
                                                                    style: AppTextStyle
                                                                        .font14bold,
                                                                  ),
                                                                ),

                                                                Text(
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                                  dashController
                                                                      .taskTimeModel[
                                                                  index]
                                                                      .facilityType,
                                                                  style: AppTextStyle
                                                                      .font14bold,
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  dashController
                                                                      .taskTimeModel[
                                                                  index]
                                                                      .startTime
                                                                      .format(
                                                                      context),
                                                                  style: AppTextStyle
                                                                      .font14bold,
                                                                ),
                                                                // taskEndTime
                                                                Text(
                                                                  dashController
                                                                      .taskTimeModel[
                                                                  index]
                                                                      .endTime
                                                                      .format(
                                                                      context),
                                                                  style: AppTextStyle
                                                                      .font14bold,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      children: [
                                                        Wrap(
                                                          alignment:
                                                          WrapAlignment
                                                              .start,
                                                          children: [
                                                            ...dashController
                                                                .taskTimeModel[
                                                            index]
                                                                .taskName!
                                                                .map(
                                                                    (name) =>
                                                                    Text(
                                                                      "$name, ",
                                                                      textAlign:
                                                                      TextAlign.start,
                                                                      style:
                                                                      const TextStyle(fontSize: 14),
                                                                    ))
                                                                .toList(),

                                                          ],
                                                        )
                                                      ]
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                // const SizedBox(height: 10),
                                Obx(
                                      () => SizedBox(
                                    height:
                                    dashController.taskTimeModel.isEmpty
                                        ? 80
                                        : 20,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "The shift shall run round the clock for 24 hours.",
                                    style: AppTextStyle.font15.copyWith(
                                        fontSize: 15,
                                        color: const Color(0xff828282),
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                // Text( "The shift shall start at ${shiftTime == null ? '00:00' : shiftTime!.format(context)}")),
                                const SizedBox(height: 5),

                                const SizedBox(height: 10),

                                Obx(
                                      () => SizedBox(
                                    height:
                                    dashController.taskTimeModel.isEmpty
                                        ? 60
                                        : 15,
                                  ),
                                ),

                                GestureDetector(
                                    onTap: () {
                                      isNext = true;
                                      setState(() {});

                                      String city = globalStorage.getCity();
                                      // String address =
                                      //     globalStorage.getAddress();
                                      String pincode =
                                      globalStorage.getPincode();
                                      String clientId =
                                      globalStorage.getClientId();

                                      if (
                                      // shiftTime != null &&
                                      dashController
                                          .taskStartTime.isNotEmpty &&
                                          estimatedTime != null) {

                                        dashBoardBloc.add(AssignTaskEvent(
                                            clientId: int.parse(clientId),
                                            shiftTime: "12:00:00",
                                            taskTimes:
                                                dashController.taskTimes,
                                            janitorId: buddy.id!,
                                            facilityId: selectedFacility!.id
                                                .toString()));

                                      }

                                    },
                                    child: Custombutton(
                                        text: "Submit", width: 328.w)),

                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            });
          });
    },
  ).then(
        (value) {
      loadFacilities();
      isTaskSelected = false;
      isNext = false;
    },
  );
}

TimeOfDay convertToTimeOfDay(String timeString) {
  DateTime dateTime = DateTime.parse(timeString);
  return TimeOfDay.fromDateTime(dateTime);
}