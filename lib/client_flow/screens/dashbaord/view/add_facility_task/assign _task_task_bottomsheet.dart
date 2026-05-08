import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import '../../../../../screens/common_widgets/image_provider.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/app_textstyle.dart';
import '../../../../utils/client_images.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../controller/dashbaord_controller.dart';
import '../../data/model/facility_dropdown_model.dart';
import '../../data/model/facility_model.dart';
import '../../data/model/task_model.dart';
import '../../data/model/tasklist_model.dart';
import '../../model/facility_type_model.dart';
import '../widget/add_time_dailog.dart';
import 'select_supervisor_screen/assign_task_admin_bottom_sheet.dart';
import 'assign_task_header.dart';
import 'assign_task_janitor_bottom_sheet.dart';
import 'package:woloo_smart_hygiene/client_flow/widgets/CustomButton.dart';

class AssignTaskTaskBottomSheet extends StatefulWidget {
  final BuildContext context;
  final DashBoardController dashController;
  final List<DropdownItem<TaskDropdownModel>> items;
  final MultiSelectController<TaskDropdownModel> dropController;
  final List<TaskDropdownModel> gender;
  final List<TaskDropdownModel> selectedItems;
  final int? estimatedTime;
  final bool isTaskSelected;
  final bool isNext;
  final nameController;
  final  TextEditingController mobileController;
  final bool isAdminSelected;
  final bool isSelfAssign;
  final int selectedAdmin;
  final String erroradminMessage;
  final GlobalKey<FormState> addSuperVisorKey;
  final TextEditingController janNameController;
  final TextEditingController janMobileController;
  final String? janitorGender;
  final bool isGender;
  final GlobalKey<FormState> addJanitorKey;
  final int selectedGender;
  final ClientDashBoardBloc dashBoardBloc;
  final List<FacilityDropdownModel> facilitydropdownNames;
  final List<Facility> facilityList;
  final FacilityDropdownModel? selectedFacility;
  final int? clusterId;
  final TextEditingController facilityController;
  final List<TypeFacility>? facilityType;
  final int facilityCount;
  final TextEditingController typeController;
  final bool isFirstTimeHost;
  final String? defaultHostLocation;
  final int? roleId;
  final int selectedIndex;
  final String? loc;
  final  List<String>? taskName ;
  final List<int>? selectedId;
  final bool isClientSupervisor;
  final List<int?> taksIds;
  final TimeOfDay? shiftTime;
  final List<TaskDropdownModel> facilityNames ;

const AssignTaskTaskBottomSheet({
  Key? key,
  required this.context,
  required this.dashController,
  required this.items,
  required this.dropController,
  required this.gender,
  required this.selectedItems,
  required this.estimatedTime,
  required this.isTaskSelected,
  required this.isNext,
  required this.nameController,
  required this.mobileController,
  required this.isAdminSelected,
  required this.isSelfAssign,
  required this.selectedAdmin,
  required this.erroradminMessage,
  required this.addSuperVisorKey,
  required this.janNameController,
  required this.janMobileController,
  required this.janitorGender,
  required this.isGender,
  required this.addJanitorKey,
  required this.selectedGender,
  required this.dashBoardBloc,
  required this.facilitydropdownNames,
  required this.facilityList,
  required this.facilityController,
  required this.facilityType,
  required this.facilityCount,
  required this.typeController,
  required this.isFirstTimeHost,
  required  this.defaultHostLocation,
  required this.roleId,
  required this.selectedIndex,
  required  this.loc,
  required this.taskName,
  required this.selectedId,
  required this.isClientSupervisor,
  required this.taksIds,
  required this.shiftTime,
  required this.facilityNames,
  required this.selectedFacility,
  required this.clusterId ,
}) : super(key: key);

@override
State<AssignTaskTaskBottomSheet> createState() =>
_AssignTaskTaskBottomSheetState();
}

class _AssignTaskTaskBottomSheetState extends State<AssignTaskTaskBottomSheet> {

  String? use12hour = "00:00";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      openBottomSheet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }

  void openBottomSheet() {

    Future<void> loadFacilities() async {
      final items = widget.facilityNames
          .map((element) => DropdownItem(
        label: element.facilityName!,
        value: element,
      ))
          .toList();

      widget.dropController.setItems(items);
    }

    Future<void> showMyDialog(bool isFromExiting, {Datum? janitor}) async {
      showDialog(
        context: context,
        builder: (context) {
          return AddTimeDailog(
            estimatedTime: widget.estimatedTime!,
            startTime: widget.shiftTime,
            endTime: use12hour,
            isFromExisting: isFromExiting,
            janitorId: janitor?.id,
            facalityName: widget.facilityController.text,
            facilityType: widget.facilityType![widget.selectedIndex].typeName,
            taskName: widget.taskName,
            taskIds: widget.selectedId!,
          );
        },
      );
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {

        GlobalKey<FormState> _formKey = GlobalKey<FormState>();

        return StatefulBuilder(
          builder: (context, setState) {

            int? estimatedTime = widget.estimatedTime;
            bool isTaskSelected = widget.isTaskSelected;
            bool isNext = widget.isNext;
            List<String>? taskName = widget.taskName;
            List<int>? selectedId = widget.selectedId;
            List<int?> taksIds = widget.taksIds;

            return DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.8,
              maxChildSize: 0.9,
              builder: (context, scrollController) {

                return Form(
                  key: _formKey,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(80),
                        topRight: Radius.circular(80),
                      ),
                    ),
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(15),
                      children: [

                        AssignTaskHeader(
                          title: DashboardConst.assignTasks,
                          subTitle: "Tasks",
                          image: ClientImages.checklist,
                        ),

                        const SizedBox(height: 30),

                        /// ✅ MULTI DROPDOWN
                        MultiDropdown<TaskDropdownModel>(
                          items: widget.items,
                          controller: widget.dropController,

                          onSelectionChange: (selectedItems) {

                            List<int?> listTime = [];

                            taskName = selectedItems
                                .map((e) => e.facilityName!)
                                .toList();

                            selectedId = selectedItems
                                .map((e) => e.id!)
                                .toList();

                            listTime = selectedItems
                                .map((e) => e.requiredTime)
                                .toList();

                            if (selectedItems.isEmpty) {
                              estimatedTime = null;
                            } else {
                              estimatedTime =
                                  listTime.reduce((a, b) => a! + b!);

                              taksIds =
                                  selectedItems.map((e) => e.id).toList();
                            }

                            setState(() {});
                          },
                        ),

                        const SizedBox(height: 20),

                        /// ✅ ESTIMATED TIME
                        Center(
                          child: Text(
                            estimatedTime == null
                                ? "00:00"
                                : "$estimatedTime min",
                            style: AppTextStyle.font24bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// ✅ ADD TIMING
                    GestureDetector(
                      onTap: () {
                        isTaskSelected = true;

                        if (estimatedTime != null) {
                          showMyDialog(false);
                        }

                        setState(() {});

                      },
                      child:
                        Custombutton(
                          text: "Add Timings",
                          width: double.infinity,
                        ),
                    ),

                        const SizedBox(height: 20),

                        /// ✅ NEXT BUTTON
                    GestureDetector(
                      onTap: () {

                        isNext = true;
                        setState(() {});

                        if (widget.dashController.taskTimeModel.isNotEmpty &&
                            estimatedTime != null) {

                          if (widget.isClientSupervisor) {
                            janitorBottomSheet(
                              context: context,
                              nameController: widget.nameController,
                              mobileController: widget.mobileController,
                              isAdminSelected: widget.isAdminSelected,
                              isSelfAssign: widget.isSelfAssign,
                              selectedAdmin: widget.selectedAdmin,
                              erroradminMessage: widget.erroradminMessage,
                              addSuperVisorKey: widget.addSuperVisorKey,
                              janNameController: widget.janNameController,
                              janMobileController: widget.janMobileController,
                              janitorGender: widget.janitorGender,
                              isGender: widget.isGender,
                              addJanitorKey: widget.addJanitorKey,
                              selectedGender: widget.selectedGender,
                              dashBoardBloc: widget.dashBoardBloc,
                              facilitydropdownNames: widget.facilitydropdownNames,
                              facilityList: widget.facilityList,
                              facilityController: widget.facilityController,
                              facilityType: widget.facilityType,
                              facilityCount: widget.facilityCount,
                              typeController: widget.typeController,
                              isFirstTimeHost: widget.isFirstTimeHost,
                              defaultHostLocation: widget.defaultHostLocation,
                              roleId: widget.roleId,
                              selectedIndex: widget.selectedIndex,
                              loc: widget.loc,
                            );
                          } else {
                            adminBottomSheetNew(
                              context: context,
                              nameController: widget.nameController,
                              mobileController: widget.mobileController,
                              isAdminSelected: widget.isAdminSelected,
                              isSelfAssign: widget.isSelfAssign,
                              selectedAdmin: widget.selectedAdmin,
                              erroradminMessage: widget.erroradminMessage,
                              addSuperVisorKey: widget.addSuperVisorKey,
                              janNameController: widget.janNameController,
                              janMobileController: widget.janMobileController,
                              janitorGender: widget.janitorGender,
                              isGender: widget.isGender,
                              addJanitorKey: widget.addJanitorKey,
                              selectedGender: widget.selectedGender,
                              dashBoardBloc: widget.dashBoardBloc,
                              facilitydropdownNames: widget.facilitydropdownNames,
                              facilityList: widget.facilityList,
                              facilityController: widget.facilityController,
                              facilityType: widget.facilityType,
                              facilityCount: widget.facilityCount,
                              typeController: widget.typeController,
                              isFirstTimeHost: widget.isFirstTimeHost,
                              defaultHostLocation: widget.defaultHostLocation,
                              roleId: widget.roleId,
                              selectedIndex: widget.selectedIndex,
                              loc: widget.loc,
                            );
                          }
                        }
                      },
                      child:
                        Custombutton(
                          text: "Next",
                          width: double.infinity,
                        ),
                    ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    ).then((_) {
      widget.dashController.taskStartTime.clear();
      widget.dashController.taskEndTime.clear();
      widget.dashController.taskTimes.clear();
      loadFacilities();
      use12hour = "00:00";
      setState(() {});
    });
  }
}

/*class _AssignTaskTaskBottomSheetState extends State<AssignTaskTaskBottomSheet> {

  String? use12hour = "00:00";


  DashBoardController dashController = widget.dashController;
  List<DropdownItem<TaskDropdownModel>> items = widget.items;
  MultiSelectController<TaskDropdownModel> dropController = widget
      .dropController;

  List<TaskDropdownModel> gender = widget.gender;
  List<TaskDropdownModel> selectedItems = widget.selectedItems;

  int? estimatedTime = widget.estimatedTime;
  bool isTaskSelected = widget.isTaskSelected;
  bool isNext = widget.isNext;
  TextEditingController nameController = widget.nameController;
  TextEditingController mobileController = widget.mobileController;
  bool isAdminSelected = widget.isAdminSelected;
  bool isSelfAssign = widget.isSelfAssign;
  int selectedAdmin = widget.selectedAdmin;

  @override
  Widget build(BuildContext context) {
    String erroradminMessage = widget.erroradminMessage;
    GlobalKey<FormState> addSuperVisorKey = widget.addSuperVisorKey;
    TextEditingController janNameController = widget.janNameController;
    TextEditingController janMobileController = widget.janMobileController;
    String? janitorGender = widget.janitorGender;
    bool isGender = widget.isGender;
    GlobalKey<FormState> addJanitorKey = widget.addJanitorKey;
    int selectedGender = widget.selectedGender;
    ClientDashBoardBloc dashBoardBloc = widget.dashBoardBloc;
    List<FacilityDropdownModel> facilitydropdownNames = widget
        .facilitydropdownNames;
    List<Facility> facilityList = widget.facilityList;
    FacilityDropdownModel? selectedFacility = widget.selectedFacility;
    int? clusterId = widget.clusterId;
    TextEditingController facilityController = widget.facilityController;
    List<TypeFacility>? facilityType = widget.facilityType;
    int facilityCount = widget.facilityCount;
    TextEditingController typeController = widget.typeController;
    bool isFirstTimeHost = widget.isFirstTimeHost;
    String? defaultHostLocation = widget.defaultHostLocation;
    int? roleId = widget.roleId;
    int selectedIndex = widget.selectedIndex;
    String? loc = widget.loc;
    List<String>? taskName = widget.taskName;
    List<int>? selectedId = widget.selectedId;
    bool isClientSupervisor = widget.isClientSupervisor;
    List<int?> taksIds = widget.taksIds;
    TimeOfDay? shiftTime = widget.shiftTime;
    List<TaskDropdownModel> facilityNames = widget.facilityNames;


    dashController.taskTimeModel.clear();

    return const SizedBox.shrink();
  }

  void openBottomSheet() {
    Future<void> loadFacilities() async {
      print("Fetching facilities...");


      final items = facilityNames
          .map((element) =>
          DropdownItem(
            label: element.facilityName!,
            value: element,
          ))
          .toList();

      dropController.setItems(items);
    }
    Future<void> showMyDialog(bool isFromExiting, {Datum? janitor}) async {
      showDialog<Map<String, List<TimeOfDay>>>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AddTimeDailog(
            estimatedTime: estimatedTime!,
            startTime: shiftTime,
            endTime: use12hour,
            isFromExisting: isFromExiting,
            janitorId: janitor == null ? null : janitor.id,
            facalityName: facilityController.text,
            facilityType: facilityType![selectedIndex].typeName,
            taskName: taskName,
            taskIds: selectedId!,

          );
        },
      );
    }
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        GlobalKey<FormState> _formKey = GlobalKey<FormState>();
        int? len;
        Color getColor(Set<WidgetState> states) {
          const Set<WidgetState> interactiveStates = <WidgetState>{
            WidgetState.pressed,
            WidgetState.hovered,
            WidgetState.focused,
          };
          if (states.any(interactiveStates.contains)) {
            return Colors.blue;
          }
          return Colors.yellow;
        }

        return StatefulBuilder(builder: (context, StateSetter setState) {
          return DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.8,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return Form(
                  key: _formKey,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(80.0),
                        topRight: Radius.circular(80.0),
                      ),
                    ),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 1.15,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ListView(
                          controller: scrollController,

                          children: <Widget>[
                            AssignTaskHeader(title: DashboardConst.assignTasks,
                                subTitle: "Tasks",
                                image: ClientImages.checklist),


                            const SizedBox(
                              height: 40,
                            ),

                            Container(
// height: 55,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withValues(alpha: 0.2), // Shadow color
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
// key: UniqueKey(),
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
// suffixIcon: Ic,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),

                                  hintText: DashboardConst.selectCleaningTasks,
                                  hintStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff8F8F8F)),
//  ),
// prefixIcon: const Icon(CupertinoIcons.flag),
                                  showClearIcon: false,
                                  border: InputBorder.none,
                                  suffixIcon: Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: Color(0xff8F8F8F),
                                    size: 38,
                                  ),

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
                                  maxHeight: MediaQuery
                                      .of(context)
                                      .size
                                      .height <
                                      640
                                      ? 250
                                      : MediaQuery
                                      .of(context)
                                      .size
                                      .height < 733
                                      ? 350
                                      : 450,


                                ),


                                itemBuilder: (item, index, onTap) {
                                  final isSelected = dropController
                                      .selectedItems
                                      .contains(item);

                                  return ListTile(
                                    contentPadding:
                                    const EdgeInsets.only(right: 10),
// minVerticalPadding: 0,
                                    minLeadingWidth: 0,
                                    horizontalTitleGap: 10,
                                    minTileHeight: 25,
                                    leading: Checkbox(
                                      shape: RoundedRectangleBorder(

                                        borderRadius: BorderRadius.circular(6),
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
                                          fontSize: MediaQuery
                                              .of(context)
                                              .size
                                              .height <
                                              640
                                              ? 12
                                              : 15,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xff8F8F8F)),
                                    ),
                                    trailing: Text(
                                      "+ ${item.value.requiredTime
                                          .toString()} min",
                                      style: TextStyle(
                                          fontSize: MediaQuery
                                              .of(context)
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
                                  print(" selected items $selectedItems ");
                                  List<int?> listTime = [];

                                  taskName = selectedItems
                                      .map((e) => e.facilityName!)
                                      .toList();

                                  selectedId =
                                      selectedItems.map((e) => e.id!).toList();
                                  print(" selected items $selectedId ");

                                  len = selectedItems.length;

                                  listTime = selectedItems
                                      .map((e) => e.requiredTime)
                                      .toList();

                                  print("total time $estimatedTime");
                                  if (selectedItems.isEmpty) {
                                    estimatedTime = null;
                                  } else if (selectedItems.isNotEmpty) {
                                    estimatedTime =
                                        listTime.reduce((a, b) => a! + b!);
                                    taksIds =
                                        selectedItems.map((e) => e.id).toList();
                                  } else if (selectedItems.isNotEmpty &&
                                      len! < selectedItems.length) {
                                    listTime = selectedItems
                                        .map((e) => e.requiredTime)
                                        .toList();
                                    estimatedTime =
                                        listTime.reduce((a, b) => a! - b!);
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

                            const SizedBox(
                              height: 13,
                            ),


                            estimatedTime == null && isTaskSelected
                                ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0),
                              child: Column(
                                children: [
// const SizedBox(
//   height: 10,
// ),
                                  Text(
                                    "Please select Tasks",
                                    style: AppTextStyle.font12
                                        .copyWith(color: AppColors.red),
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
                                DashboardConst.estimatedTaskCompletionTime,
                                style: AppTextStyle.font20
                                    .copyWith(color: const Color(0xff8F8F8F)),
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
                              padding:
                              const EdgeInsets.symmetric(horizontal: 13),
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
                                    color: Colors.black
                                        .withValues(alpha: 0.2), // Shadow color
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
                                padding:
                                const EdgeInsets.symmetric(horizontal: 13),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
// const SizedBox(
//   height: 10,
// ),
                                        Text(
                                          DashboardConst.scheduleTask,
                                          style: AppTextStyle.font14w7.copyWith(
                                              fontSize: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .height <
                                                  640
                                                  ? 12
                                                  : 15),
                                        ),

                                        GestureDetector(
                                            onTap: () {
                                              Datum? buddy;
                                              print("is$isTaskSelected");
                                              print("ese $estimatedTime");
                                              isTaskSelected = true;
// isNext = true;
                                              setState(() {});
//  if(  _formKey.currentState!.validate()   ){
                                              estimatedTime != null
// &&
//         shiftTime != null
                                                  ? showMyDialog(
                                                false,
                                              ).then(
                                                    (value) {
                                                  isTaskSelected = false;
                                                },
                                              )
                                                  : null;
                                            },
                                            child: Custombutton(
                                                text: DashboardConst.addTimings,
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .height <
                                                    640
                                                    ? 120
                                                    : 140))

//  :
                                      ],
                                    ),
                                    dashController.taskTimeModel.isEmpty &&
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
                                              color: AppColors.red),
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
                                          () =>
                                      dashController.taskTimeModel.isEmpty
                                          ? const SizedBox()
                                          : const Divider(
                                        color: Color(0xff828282),
                                        thickness: 1,
                                      ),
                                    ),
                                    Obx(
                                          () =>
                                          SizedBox(
                                            height:
                                            dashController.taskTimeModel.isEmpty
                                                ? 0
                                                : MediaQuery
                                                .of(context)
                                                .size
                                                .height /
                                                5,
                                            child: ListView.builder(
                                              physics:
                                              const ClampingScrollPhysics(),
//  physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: dashController
                                                  .taskTimeModel.length,
                                              itemBuilder: (context, index) {
                                                return Theme(
                                                  data: Theme
                                                      .of(context)
                                                      .copyWith(
                                                    dividerColor: Colors
                                                        .transparent, // Remove the default divider
                                                  ),
                                                  child: ExpansionTile(
                                                      expandedAlignment:
                                                      Alignment.topLeft,
                                                      expandedCrossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      title: ListTile(
                                                        contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 0,
                                                            horizontal: 2),
                                                        minLeadingWidth: 0,
                                                        trailing: GestureDetector(
                                                          onTap: () {
// showDeleteDialog(context);
// void showDeleteDialog(BuildContext context) {
                                                            showDialog(
                                                              context: context,
                                                              builder: (
                                                                  context) =>
                                                                  AlertDialog(
                                                                    contentPadding:
                                                                    const EdgeInsets
                                                                        .all(0),
                                                                    shape:
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                          26),
                                                                    ),
                                                                    backgroundColor:
                                                                    AppColors
                                                                        .white,
// title: const Text("Logout"),
                                                                    content: SizedBox(
                                                                      height: 175,
                                                                      child: Column(
                                                                        children: [
                                                                          const SizedBox(
                                                                            height: 30,
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets
                                                                                .symmetric(
                                                                                horizontal:
                                                                                30),
                                                                            child:
                                                                            Center(
                                                                              child:
                                                                              Text(
                                                                                textAlign:
                                                                                TextAlign
                                                                                    .center,
                                                                                "Are you sure you want to delete the current time?",
                                                                                style: AppTextStyle
                                                                                    .font15
                                                                                    .copyWith(
                                                                                    fontSize:
                                                                                    15,
                                                                                    color:
                                                                                    AppColors
                                                                                        .black,
                                                                                    fontWeight: FontWeight
                                                                                        .w700),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height: 20,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .spaceEvenly,
                                                                            children: [
                                                                              GestureDetector(
                                                                                  onTap:
                                                                                      () async {
                                                                                    Navigator
                                                                                        .of(
                                                                                        context)
                                                                                        .pop();
                                                                                  },
                                                                                  child: Custombutton(
                                                                                      color: AppColors
                                                                                          .white,
                                                                                      text: "No",
                                                                                      width: 100
                                                                                          .w)),
                                                                              GestureDetector(
                                                                                  onTap:
                                                                                      () async {
                                                                                    dashController
                                                                                        .taskTimeModel
                                                                                        .removeAt(
                                                                                        index);
                                                                                    dashController
                                                                                        .taskTimes
                                                                                        .removeAt(
                                                                                        index);

//  print("task time model ${dashController.taskTimes}");

                                                                                    Navigator
                                                                                        .of(
                                                                                        context)
                                                                                        .pop();
                                                                                  },
                                                                                  child: Custombutton(
                                                                                      text: "Yes",
                                                                                      width: 100
                                                                                          .w))
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height: 30,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),

                                                                  ),
                                                            );
                                                          },

                                                          child:
                                                          CustomImageProvider(
                                                              image:
                                                              ClientImages
                                                                  .delete,
                                                              width: 25,
                                                              height: 25),
//  const Icon(  Icons.delete,),
//  color: AppColors.red,
                                                        ),
                                                        title: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            const Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
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
                                                      tilePadding:
                                                      const EdgeInsets.all(0),
                                                      childrenPadding:
                                                      const EdgeInsets.all(0),
                                                      children: [
                                                        Wrap(
                                                          alignment:
                                                          WrapAlignment.start,
                                                          children: [
                                                            ...dashController
                                                                .taskTimeModel[
                                                            index]
                                                                .taskName!
                                                                .map((name) =>
                                                                Text(
                                                                  "$name, ",
                                                                  textAlign:
                                                                  TextAlign
                                                                      .start,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                      14),
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

                            Obx(
                                  () =>
                                  SizedBox(
                                    height: dashController.taskTimeModel.isEmpty
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
                            const SizedBox(height: 5),
                            Obx(
                                  () =>
                                  SizedBox(
                                    height: dashController.taskTimeModel.isEmpty
                                        ? 60
                                        : 15,
                                  ),
                            ),
// const Spa

                            GestureDetector(
                                onTap: () {
                                  isNext = true;
                                  setState(() {});
                                  print(
                                      "curtne ${_formKey.currentState!
                                          .validate()}");
                                  if (
// shiftTime != null &&
                                  dashController.taskTimeModel.isNotEmpty &&
                                      estimatedTime != null) {
// && shiftTime != null && taskStartTime.isNotEmpty && estimatedTime != null
                                    if (isClientSupervisor) {
                                      janitorBottomSheet(
                                        context: context,
                                        nameController: nameController,
                                        mobileController: mobileController,
                                        isAdminSelected: isAdminSelected,
                                        isSelfAssign: isSelfAssign,
                                        selectedAdmin: selectedAdmin,
                                        erroradminMessage: erroradminMessage,
                                        addSuperVisorKey: addSuperVisorKey,
                                        janNameController: janNameController,
                                        janMobileController: janMobileController,
                                        janitorGender: janitorGender,
                                        isGender: isGender,
                                        addJanitorKey: addJanitorKey,
                                        selectedGender: selectedGender,
                                        dashBoardBloc: dashBoardBloc,
                                        facilitydropdownNames: facilitydropdownNames,
                                        facilityList: facilityList,
                                        facilityController: facilityController,
                                        facilityType: facilityType,
                                        facilityCount: facilityCount,
                                        typeController: typeController,
                                        isFirstTimeHost: isFirstTimeHost,
                                        defaultHostLocation: defaultHostLocation,
                                        roleId: roleId,
                                        selectedIndex: selectedIndex,
                                        loc: loc,
                                      );
                                    } else {
                                      adminBottomSheet(context: context,
                                        nameController: nameController,
                                        mobileController: mobileController,
                                        isAdminSelected: isAdminSelected,
                                        isSelfAssign: isSelfAssign,
                                        selectedAdmin: selectedAdmin,
                                        erroradminMessage: erroradminMessage,
                                        addSuperVisorKey: addSuperVisorKey,
                                        janNameController: janNameController,
                                        janMobileController: janMobileController,
                                        janitorGender: janitorGender,
                                        isGender: isGender,
                                        addJanitorKey: addJanitorKey,
                                        selectedGender: selectedGender,
                                        dashBoardBloc: dashBoardBloc,
                                        facilitydropdownNames: facilitydropdownNames,
                                        facilityList: facilityList,
                                        facilityController: facilityController,
                                        facilityType: facilityType,
                                        facilityCount: facilityCount,
                                        typeController: typeController,
                                        isFirstTimeHost: isFirstTimeHost,
                                        defaultHostLocation: defaultHostLocation,
                                        roleId: roleId,
                                        selectedIndex: selectedIndex,
                                        loc: loc,);
                                    }
                                  }

// janitorBottomSheet()
                                      ;
                                },
                                child:
                                Custombutton(text: "Next", width: 328.w)),

                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
      },
    ).then(
          (value) {
        isTaskSelected = false;
        dashController.taskStartTime.clear();
        dashController.taskEndTime.clear();
        dashController.taskTimes.clear();
        items = [];
        loadFacilities();
        use12hour = "00:00";
        shiftTime = null;
        isNext = false;
        setState(() {});
      },
    );
  }
}*/
