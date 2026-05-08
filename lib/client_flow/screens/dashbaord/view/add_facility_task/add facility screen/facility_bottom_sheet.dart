import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/bloc/dashboard_bloc.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/add_facility_task/add%20facility%20screen/select_facility_type_grid.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/add_facility_task/supervisor_bottom_sheet.dart';
import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import '../../../../../../utils/app_color.dart';
import '../../../../../../utils/app_constants.dart';
import '../../../../../../utils/app_textstyle.dart';
import '../../../../../utils/client_images.dart';
import '../../../../../widgets/CustomButton.dart';
import '../../../../../widgets/CustomTextField.dart';
import '../../../bloc/dashboard_event.dart';
import '../../../data/model/facility_dropdown_model.dart';
import '../../../data/model/facility_model.dart';
import '../../../data/model/task_model.dart';
import '../../../data/model/tasklist_model.dart';
import '../../../model/facility_model.dart';
import '../../../model/facility_type_model.dart';
import '../../assign_task/view/assign_tasks_screen.dart';
import '../../assign_task/widgets/assign_supervisor_card.dart';
import '../../widget/searchTextfield.dart';
import '../select_supervisor_screen/assign_task_admin_bottom_sheet.dart';
import '../assign_task_header.dart';
import '../facility_bottom_sheet_card.dart';
import 'add_others_type_facility_input_field.dart';
import 'facilities_dropdown_widget.dart';
import 'location_text_field.dart';
import 'next_button_widget.dart';

/*
facilityBottomSheet( BuildContext context ,
    GlobalKey<FormState> facilityKey,
    TextEditingController facilityController,
    List<TypeFacility>? facilityType,
    List<Facility> facilityList,
    int facilityCount,
    TextEditingController typeController,
    bool isFirstTimeHost,
    String? defaultHostLocation,
    String errorMessage,
    String? loc,
    int selectedIndex,
    bool? isOpenDrop,
    FacilityDropdownModel? selectedFacility,
    List<ChooseFacilityModel> facility,
    List<DropdownItem<TaskDropdownModel>> items,
    List<TaskDropdownModel> facilityNames,
    bool isClientSupervisor,
    Datum? selectedbuddy,
    int? clusterId,
    bool isSelected,
    List<FacilityDropdownModel> facilitydropdownNames,
    int roleId,
    ClientDashBoardBloc dashBoardBloc,
FocusNode? facilityFocusNode,

    ) {
  var height = MediaQuery.of(context).size.height;

  showModalBottomSheet<void>(
    backgroundColor: Colors.transparent,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, StateSetter setState) {
        return DraggableScrollableSheet(
            initialChildSize: 0.8,
            minChildSize: 0.8,
            maxChildSize: 0.96,
            // expand: false,
            // snap: false,
            builder: (context, controller) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: facilityKey,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(80.0),
                        topRight: Radius.circular(80.0),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height / 1.23,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ListView(
                          controller: controller,

                          children: <Widget>[
                            AssignTaskHeader(title: DashboardConst.listYourFacility, subTitle: "Facility", image: ClientImages.building,),

                            const SizedBox(
                              height: 20,
                            ),

                            facilitydropdownNames.isNotEmpty
                                ? DropdownButtonHideUnderline(
                              child: DropdownButton2<
                                  FacilityDropdownModel>(
                                dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(7),
                                        color: AppColors.white)),

                                isExpanded: true,

                                hint:
                                //  selectItem == null ?
                                Text(
                                  DashboardConst.organizationName,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                onMenuStateChange: (isOpen) {
                                  print("is oner $isOpen");
                                  isOpenDrop = isOpen;
                                  setState(() {});
                                },

                                iconStyleData: IconStyleData(
                                    icon: isOpenDrop!
                                        ? const Icon(
                                        Icons
                                            .keyboard_arrow_up_rounded,
                                        size: 38,
                                        color: Color(0xff8F8F8F))
                                        : const Icon(
                                        Icons
                                            .keyboard_arrow_down_rounded,
                                        size: 38,
                                        color: Color(0xff8F8F8F))),
                                items: facilitydropdownNames!
                                    .map((FacilityDropdownModel item) {
                                  return DropdownMenuItem<
                                      FacilityDropdownModel>(
                                    value: item,
                                    child: Text(
                                      item.facilityName!,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        // color: Colors.grey,
                                        // fontWeight: FontWeight.w700
                                      ),
                                    ),
                                  );
                                }).toList(),
                                value: selectedFacility ??
                                    selectedFacility, // This should be a FacilityDropdownModel?
                                onChanged:
                                    (FacilityDropdownModel? value) {
                                  // print(
                                  //     "isfromtaskbuddy $isFromTaskbuddy");
                                  setState(() {
                                    selectedFacility = value;
                                    loc = value!.locationName!;
                                    facilityController.text =
                                    value.facilityName!;
                                    if (facilitydropdownNames
                                        .isNotEmpty) {


                                      int indexx = facilityType!
                                          .indexWhere((e) =>
                                      e.typeName ==
                                          value.facalityType);

                                      // typeController.text =  value.facalityType!;
                                      selectedIndex = indexx;
                                      dashBoardBloc.add(GetTaskEvent(
                                          category:
                                          facility[selectedIndex]
                                              .title!));


                                    }

                                    // }

                                    //  }
                                  });
                                },
                                buttonStyleData: ButtonStyleData(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  height: 55,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                            0.2), // Shadow color
                                        spreadRadius:
                                        1, // Spread effect
                                        blurRadius: 10, // Blur effect
                                        offset: const Offset(
                                            0, 5), // Bottom shadow
                                      ),
                                    ],
                                    borderRadius:
                                    BorderRadius.circular(8),
                                  ),
                                ),

                                menuItemStyleData:
                                const MenuItemStyleData(height: 40),
                              ),
                            )
                                : CustomTextField(
                              padding: const EdgeInsets.all(0),
                              focusNode: facilityFocusNode,
                              hintText: DashboardConst.organizationName,
                              controller: facilityController,
                              enabled: !isFirstTimeHost,
                              validator: (valu) {
                                if (valu == null || valu.isEmpty) {
                                  return "Facility Name is required";
                                }
                              },
                            ),

                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              // height: 36.h,

                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.2), // Shadow color
                                      spreadRadius: 1, // Spread effect
                                      blurRadius: 10, // Blur effect
                                      offset:
                                      const Offset(0, 5), // Bottom shadow
                                    ),
                                  ],
                                ),
                                child: GooglePlacesSearchField(
                                  isEnable: !!isFirstTimeHost
                                      ? false
                                      : facilitydropdownNames.isNotEmpty
                                      ? false
                                      : true,
                                  locationName:
                                  roleId == 16 && facilityCount == 0
                                      ? defaultHostLocation
                                      : loc,
                                  apiKey:
                                  "AIzaSyCkPmUz4UlRdzcKG9gniW9Qfrgzsjhnb_4",
                                  onPlaceSelected: (place) {
                                    loc = place;
                                    if (!isFirstTimeHost) {
                                      defaultHostLocation = loc;
                                    }
                                    print("Selected place: ${loc!.isEmpty}");
                                  },
                                )


                            ),

                            const SizedBox(
                              height: 35,
                            ),
                            Text(
                              DashboardConst.typeOfFacility,
                              style: AppTextStyle.font14bold,
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 270,
                              child: GridView.builder(
                                itemCount: facilityType!.length,
                                shrinkWrap: true,
                                // physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio:
                                    MediaQuery.of(context)
                                        .size
                                        .height <
                                        640
                                        ? 0.7
                                        : 0.9,
                                    //  mainAxisExtent: 120,
                                    crossAxisSpacing: 35,
                                    mainAxisSpacing: 30),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      typeController.text = "";
                                      errorMessage = '';
                                      // print("printr $isFromTaskbuddy");
                                      if (facilitydropdownNames.isNotEmpty) {
                                      } else {
                                        setState(() {
                                          selectedIndex = index;
                                          print(
                                              "aarati title ${facilityType![selectedIndex].typeName!}");
                                        });

                                        // facilityNames = [];
                                        // items = [];
                                        //  dropController.clearAll();
                                        // dropController.clearAll();
                                        facilityType![selectedIndex]
                                            .typeName ==
                                            "Others"
                                            ? isSelected = true
                                            : isSelected = false;
                                        print("is slec $isSelected");
                                        dashBoardBloc.add(GetTaskEvent(
                                            category: facility[selectedIndex]
                                                .title!));
                                      }

                                      // setState((){});
                                    },
                                    child: AssignTaskCard(
                                        image:facilityType![index].imageUrl ??
                                            ClientImages.menu,
                                        title:facilityType![index].typeName!,
                                        index:index ,
                                        selectedIndex: selectedIndex,
                                        typeController: typeController),
                                  );
                                },
                              ),

                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            errorMessage.isNotEmpty
                                ? Padding(
                              padding:
                              const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                errorMessage,
                                style:
                                const TextStyle(color: Colors.red),
                              ),
                            )
                                : const SizedBox(),
                            const SizedBox(
                              height: 15,
                            ),
                            isSelected
                                ? CustomTextField(
                              padding: const EdgeInsets.all(0),
                              hintText: DashboardConst
                                  .ifOthersMentionFacility,
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700),
                              controller: typeController,
                              validator: (valu) {
                                if (valu == null || valu.isEmpty) {
                                  return "Please mention other type";
                                }
                              },
                            )
                                : const SizedBox(),

                            // const Spacer(),
                            const SizedBox(
                              height: 20,
                            ),

                            GestureDetector(
                                onTap: () {
                                  print("selected $selectedIndex ");
                                  if (selectedIndex == -1) {
                                    setState(() {
                                      errorMessage =
                                      'Please select a facility';
                                    });
                                  } else {
                                    setState(() {
                                      errorMessage = '';
                                    });
                                    // Proceed with the next steps
                                    print(
                                        "Selected: ${facilityType![selectedIndex].typeName!}");
                                  }
                                  if (facilityType!.length >= 9 &&
                                      typeController.text.isNotEmpty) {
                                    setState(() {
                                      errorMessage =
                                      'More than 5 facility cannot add ';
                                    });
                                  }

                                  print(
                                      "prediction ${facilityType!.length} ");
                                  print("buddy $selectedbuddy");
                                  print("buddy $selectedFacility");
                                  print(
                                      "Aarati , ${facilityKey.currentState!.validate()} , ${facilitydropdownNames.isNotEmpty} , $selectedIndex , ${facilityType!.length}");
                                  if (facilityKey.currentState!.validate() &&
                                      facilitydropdownNames.isNotEmpty &&
                                      selectedIndex != -1 &&
                                      facilityType!.length >= 9) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AssignTasksScreen(
                                              isClientSupervisor:
                                              isClientSupervisor,
                                              facilityNames: facilityNames,
                                              selectedFacility: selectedFacility,
                                              facilityName:
                                              facilityController.text,
                                              locality: roleId == 16
                                                  ? defaultHostLocation
                                                  : loc,
                                              clusterId: clusterId,
                                              selectedIndex: selectedIndex,
                                              facilitydropdownNames:
                                              facilitydropdownNames,
                                              existingBuddy: selectedbuddy,
                                              faciltyType: facilityType![
                                              selectedIndex]
                                                  .typeName ==
                                                  "Others"
                                                  ? typeController.text
                                                  : facilityType![selectedIndex]
                                                  .typeName,
                                            ),
                                      ),
                                    );
                                  } else if (facilityKey.currentState!
                                      .validate() &&
                                      ((loc?.isNotEmpty ?? false) ||
                                          (defaultHostLocation?.isNotEmpty ??
                                              false)) &&
                                      selectedIndex != -1) {
                                    print(
                                        "this is innner ${facilityType!.length >= 9 && typeController.text.isNotEmpty}");
                                    facilityType!.length >= 9 &&
                                        typeController.text.isNotEmpty
                                        ? null
                                        : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AssignTasksScreen(
                                              isClientSupervisor:
                                              isClientSupervisor,
                                              facilityNames: facilityNames,
                                              selectedFacility:
                                              selectedFacility,
                                              facilityName:
                                              facilityController.text,
                                              locality: roleId == 16
                                                  ? defaultHostLocation
                                                  : loc,
                                              clusterId: clusterId,
                                              selectedIndex: selectedIndex,
                                              facilitydropdownNames:
                                              facilitydropdownNames,
                                              existingBuddy: selectedbuddy,
                                              faciltyType: facilityType![
                                              selectedIndex]
                                                  .typeName ==
                                                  "Others"
                                                  ? typeController.text
                                                  : facilityType![
                                              selectedIndex]
                                                  .typeName,
                                            ),
                                      ),
                                    );
                                  }
                                },
                                child: const Custombutton(
                                    text: "Next", width: double.infinity)),

                            const SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            });
      });
    },
  ).then((v) {
    facilitydropdownNames.clear();
    typeController.clear();
    errorMessage = "";
    loc = null;
  });
}*/

class BSSizes {
  static const double horizontalPadding = 15;
  static const double borderRadius = 30;
  static const double spacingSmall = 10;
  static const double spacingMedium = 20;
  static const double spacingLarge = 30;

  static const double buttonHeight = 55;
  static const double gridSpacing = 30;
}

class BSStrings {
  static const String facilityRequired = "Facility Name is required";
  static const String facilityLength =
      "Facility Name should be between 3 and 50 characters";
  static const String selectFacility = "Please select a facility";
  static const String otherType = "Please mention other type";
  static const String other3Type =
      "Facility type is not less than 2 characters";
  static const String maxFacility = "More than 5 facility cannot add";
}

void facilityBottomSheet(
    BuildContext context,
    GlobalKey<FormState> facilityKey,
    TextEditingController facilityController,
    List<TypeFacility>? facilityType,
    List<Facility> facilityList,
    int facilityCount,
    TextEditingController typeController,
    bool isFirstTimeHost,
    String? defaultHostLocation,
    String errorMessage,
    String? loc,
    int selectedIndex,
    bool? isOpenDrop,
    FacilityDropdownModel? selectedFacility,
    List<ChooseFacilityModel> facility,
    List<DropdownItem<TaskDropdownModel>> items,
    List<TaskDropdownModel> facilityNames,
    bool isClientSupervisor,
    Datum? selectedbuddy,
    int? clusterId,
    bool isSelected,
    List<FacilityDropdownModel> facilitydropdownNames,
    int roleId,
    ClientDashBoardBloc dashBoardBloc,
    FocusNode? facilityFocusNode,
    bool isFromAddTask,
    ) {
  final height = MediaQuery.of(context).size.height;
  final locationKey = GlobalKey<LocationFieldWidgetState>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            //height: height * 0.7, // ✅ FIXED
            constraints: BoxConstraints(
              maxHeight: height * 0.65,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(BSSizes.borderRadius),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: BSSizes.horizontalPadding,
                right: BSSizes.horizontalPadding,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Form(
                key: facilityKey,
                child: Column(
                  children: [
                    /// ✅ SCROLLABLE CONTENT
                    Expanded(
                      child: SingleChildScrollView(
                        keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: BSSizes.spacingMedium),

                            /// HEADER
                            AssignTaskHeader(
                              title: DashboardConst.listYourFacility,
                              subTitle: "Facility",
                              image: ClientImages.building,
                            ),

                            SizedBox(height: BSSizes.spacingMedium),

                            /// DROPDOWN / TEXTFIELD
                            facilitydropdownNames.isNotEmpty &&
                                isFromAddTask == true
                                ? Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 4,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                  Border.all(color: AppColors.white),
                                ),
                                child: FacilityDropdownWidget(
                                  facilitydropdownNames:
                                  facilitydropdownNames,
                                  selectedFacility: selectedFacility,
                                  facilityController: facilityController,
                                  isFirstTimeHost: isFirstTimeHost,
                                  isOpenDrop: isOpenDrop!,
                                  /* onChanged: (value) {
                          setState(() {
                            selectedFacility = value;
                            loc = value!.locationName!;
                            facilityController.text = value.facilityName!;
                          });
                        },*/
                                  onChanged: (value) {
                                    setState(() {
                                      selectedFacility = value;

                                      /// Name
                                      facilityController.text =
                                          value.facilityName ?? "";

                                      /// 🔥 Get full data from facilityList
                                      final selectedFacilityData =
                                      facilityList.firstWhere(
                                            (e) => e.id == value.id,
                                        orElse: () => Facility(),
                                      );

                                      loc = selectedFacilityData
                                          .locationName ??
                                          "";
                                      defaultHostLocation = loc;

                                      /// 🔥 Match type → index
                                      selectedIndex = facilityType!
                                          .indexWhere((e) =>
                                      (e.typeName ?? "")
                                          .toLowerCase()
                                          .trim() ==
                                          (selectedFacilityData
                                              .facilityType ??
                                              "")
                                              .toLowerCase()
                                              .trim());

                                      print(
                                          "Mapped type: ${selectedFacilityData.facilityType}");
                                      print(
                                          "Selected index: $selectedIndex ${value.locationName}");

                                      /// 🔥 SAFE CATEGORY MAPPING
                                      if (selectedIndex != -1) {
                                        final selectedTypeName =
                                            facilityType![selectedIndex]
                                                .typeName;

                                        final matchedFacility =
                                        facility.firstWhere(
                                              (e) =>
                                          (e.title ?? "")
                                              .toLowerCase()
                                              .trim() ==
                                              (selectedTypeName ?? "")
                                                  .toLowerCase()
                                                  .trim(),
                                          orElse: () =>
                                              ChooseFacilityModel(),
                                        );

                                        if (matchedFacility.title != null) {
                                          dashBoardBloc.add(
                                            GetTaskEvent(
                                                category:
                                                matchedFacility.title!),
                                          );
                                        }
                                      }
                                    });
                                  },
                                  focusNode: facilityFocusNode,
                                ))
                                : Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 4,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                  Border.all(color: AppColors.white),
                                ),
                                child: TextFormField(
                                  focusNode: facilityFocusNode,
                                  controller: facilityController,
                                  enabled: !isFirstTimeHost,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return "Field cannot be empty or spaces only";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText:
                                    DashboardConst.organizationName,
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )),

                            SizedBox(height: BSSizes.spacingMedium),

                            /// LOCATION FIELD (WITH CLEAR BUTTON)
                            LocationFieldWidget(
                              key: ValueKey(loc),
                              isFirstTimeHost: isFirstTimeHost,
                              facilitydropdownNames: facilitydropdownNames,
                              roleId: roleId,
                              facilityCount: facilityCount,
                              defaultHostLocation: defaultHostLocation,
                              loc: loc,
                              onPlaceSelected: (value) {
                                setState(() => loc = value);
                                if (!isFirstTimeHost) {
                                  defaultHostLocation = loc;
                                }
                              },
                              onClear: () {
                                setState(() => loc = "");
                              },
                              isFromAddTask: isFromAddTask,
                            ),

                            SizedBox(height: BSSizes.spacingLarge),

                            /// GRID
                            FacilityTypeGrid(
                              key: ValueKey(selectedIndex),
                              facilityType: facilityType!,
                              selectedIndex: selectedIndex,
                              onTap: (index) {
                                if (facilitydropdownNames.isNotEmpty &&
                                    isFromAddTask == true) return;
                                setState(() {
                                  selectedIndex = index;

                                  /// ✅ HANDLE "Others"
                                  isSelected =
                                      facilityType[index].typeName == "Others";
                                });
                              },
                              otherCount: facilityType.length,
                            ),

                            /// ERROR
                            if (errorMessage.isNotEmpty)
                              Text(errorMessage,
                                  style: const TextStyle(color: Colors.red)),

                            SizedBox(height: BSSizes.spacingMedium),

                            /// OTHERS FIELD
                            if (isSelected)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: OthersInputField(
                                    controller: typeController),
                              ),

                            SizedBox(height: BSSizes.spacingMedium),
                          ],
                        ),
                      ),
                    ),

                    /// NEXT BUTTON
                    NextButtonWidget(
                      onTap: () {
                        bool isValid = true;

                        /// ✅ 1. Facility Name (FORM VALIDATION)
                        if (!facilityKey.currentState!.validate()) {
                          isValid = false;
                        }

                        /// ✅ 2. Location Validation
                        /// ✅ 2. Location Validation (SAFE)
                        bool isLocationValid = loc != null && loc!.isNotEmpty;

                        if (!isLocationValid) {
                          isValid = false;
                        }

                        /// ✅ 3. Facility Type Validation
                        if (selectedIndex == -1) {
                          setState(() {
                            errorMessage = BSStrings.selectFacility;
                          });
                          isValid = false;
                          return;
                        } else {
                          setState(() {
                            errorMessage = "";
                          });
                        }

                        /*if (isSelected) {
                            final othersText = typeController.text.trim();

                            if (othersText.isEmpty) {
                              isValid = false;
                            } else if (othersText.length < 3) {
                              isValid = false;
                            }
                          }

                          print("aarati isvalid $isValid islocation $isLocationValid dropdown length ${facilitydropdownNames.length}");
                          /// ❌ STOP if any invalid
                          if(roleId !=16) {
                            if (!isValid) return;
                          }
*/
                        if (isSelected) {
                          final othersText = typeController.text.trim();

                          if (othersText.isEmpty || othersText.length < 3) {
                            facilityKey.currentState!.validate(); // show error
                            return;
                          }
                        }

                        if (!isValid && roleId != 16) {
                          facilityKey.currentState!.validate();
                          return;
                        }

                        print("aarati afrer return}");
                        if (isFromAddTask == true && facilitydropdownNames.isNotEmpty) {
                          print("aarati in if}");
                          final nav = Navigator.of(context);
                          final assignRoute = MaterialPageRoute<void>(
                            builder: (_) => AssignTasksScreen(
                              isClientSupervisor: isClientSupervisor,
                              facilityNames: facilityNames,
                              selectedFacility: selectedFacility,
                              facilityName: facilityController.text,
                              locality:
                              roleId == 16 ? defaultHostLocation : loc,
                              clusterId: clusterId,
                              selectedIndex: selectedIndex,
                              facilitydropdownNames: facilitydropdownNames,
                              existingBuddy: selectedbuddy,
                              faciltyType:
                              facilityType![selectedIndex].typeName ==
                                  "Others"
                                  ? typeController.text
                                  : facilityType![selectedIndex].typeName,
                            ),
                          );
                          nav.pop();
                          nav.push(assignRoute);
                        } else {
                          print("aarati in else}");
                          if (isSelected) {
                            final othersText = typeController.text.trim();

                            if (othersText.isEmpty) {
                              isValid = false;
                            } else if (othersText.length < 3) {
                              isValid = false;
                            }
                          }

                          showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (sheetContext) {
                                final selectedTypeName =
                                    facilityType![selectedIndex].typeName;

                                final matchedFacility = facility.firstWhere(
                                      (e) =>
                                  (e.title ?? "").toLowerCase().trim() ==
                                      (selectedTypeName ?? "")
                                          .toLowerCase()
                                          .trim(),
                                  orElse: () => ChooseFacilityModel(),
                                );
                                return AdminBottomSheetNew(
                                  isClientSupervisor: isClientSupervisor,
                                  facilityNames: facilityNames,
                                  category: matchedFacility.title ?? "",
                                  selectedFacility: selectedFacility,
                                  facilityName: facilityController.text,
                                  locality:
                                  roleId == 16 ? defaultHostLocation : loc,
                                  clusterId: clusterId,
                                  selectedIndex: selectedIndex,
                                  facilitydropdownNames: facilitydropdownNames,
                                  existingBuddy: selectedbuddy,
                                  faciltyType: facilityType![selectedIndex]
                                      .typeName ==
                                      "Others"
                                      ? typeController.text
                                      : facilityType![selectedIndex].typeName,
                                  facilityController: facilityController,
                                  roleId: roleId,
                                  loc: loc,
                                  defaultHostLocation: defaultHostLocation,
                                  dashBoardBloc: dashBoardBloc,
                                );
                              });
                        }
                      },
                    ),

                    SizedBox(height: BSSizes.spacingLarge),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
