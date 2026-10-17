import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/bloc/dashboard_bloc.dart';

import '../../../../../core/local/global_storage.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/app_textstyle.dart';
import '../../../../utils/client_images.dart';
import '../../../../widgets/CustomButton.dart';
import '../../../../widgets/CustomTextField.dart';
import '../../bloc/dashboard_event.dart';
import '../../data/model/facility_dropdown_model.dart';
import '../../data/model/facility_model.dart';
import '../../model/facility_model.dart';
import '../../model/facility_type_model.dart';
import 'assign_task_gender_card.dart';
import 'assign_task_header.dart';
import 'assign_task_supervisor_bottom_sheet.dart';


janitorBottomSheet({
  required BuildContext context,
  required nameController,
  required  TextEditingController mobileController,
  required bool isAdminSelected,
  required bool isSelfAssign,
  required int selectedAdmin,
  required String erroradminMessage,
  required GlobalKey<FormState> addSuperVisorKey,
required TextEditingController janNameController,
required TextEditingController janMobileController,
  required String? janitorGender,
  required bool isGender,
  required GlobalKey<FormState> addJanitorKey,
  required int selectedGender,
  required ClientDashBoardBloc dashBoardBloc,
  required List<FacilityDropdownModel> facilitydropdownNames,
  required List<Facility> facilityList,
  FacilityDropdownModel? selectedFacility,
  int? clusterId,
  required TextEditingController facilityController,
  required List<TypeFacility>? facilityType,
  required int facilityCount,
  required TextEditingController typeController,
  required bool isFirstTimeHost,
  required String? defaultHostLocation,
  required int? roleId,
  required int selectedIndex,
  required String? loc,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      GlobalStorage globalStorage = GetIt.instance();
      return StatefulBuilder(builder: (context, StateSetter setState) {
        return DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.8,
            builder: (context, controller) {
              return Form(
                key: addJanitorKey,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height / 1.38,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView(
                        controller: controller,
                        //  crossAxisAlignment: CrossAxisAlignment.start,
                        //  mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          AssignTaskHeader(title:"Assign", subTitle:  "Task Buddy", image:ClientImages.avatar),

                          const SizedBox(
                            height: 30,
                          ),

                          CustomTextField(
                              padding: const EdgeInsets.all(0),
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (p0) {},
                              controller: janNameController,
                              hintText: DashboardConst.taskBuddyName,
                              keyboardType: TextInputType.text,
                              //  maxLength: 10,

                              validator: validateName
                            //  (value) {
                            //    if (value == null || value.isEmpty || value.length < 10) {
                            //      return "Enter a valid 10-digit number";
                            //    }
                            //    return null;
                            //  },
                            // prefixIcon: Icons.phone,
                          ),
                          const SizedBox(height: 30),

                          CustomTextField(
                            padding: const EdgeInsets.all(0),
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (p0) {},
                            controller: janMobileController,
                            hintText: DashboardConst.number,
                            keyboardType:
                            const TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            maxLength: 10,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 10) {
                                return "Enter a valid 10-digit number";
                              }
                              return null;
                            },
                            // prefixIcon: Icons.phone,
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          Text(
                            DashboardConst.gender,
                            style: AppTextStyle.font14bold
                                .copyWith(color: const Color(0xff8F8F8F)),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            // flex: 2,
                            width: MediaQuery.of(context).size.width,
                            height: 170,
                            child: Center(
                              child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                const SizedBox(width: 45),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20),
                                shrinkWrap: true,
                                itemCount: genderList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedGender = index;
                                        });
                                        janitorGender =
                                            genderList[selectedGender].title;
                                        print("gender $janitorGender");
                                      },
                                      child: AssignTaskGenderCard(image: genderList[index].image!,
                                        title:genderList[index].title!,
                                        index: index ,
                                        selectedGender: selectedGender,));
                                },
                              ),
                            ),
                          ),

                          janitorGender!.isEmpty && isGender
                              ? Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 10),
                            child: Text(
                              "Please select gender",
                              style: AppTextStyle.font12
                                  .copyWith(color: AppColors.red),
                            ),
                          )
                              : const SizedBox(),

                          //  const SizedBox(height: 680/3.8),
                          // const Spacer(),
                          const SizedBox(
                            height: 30,
                          ),

                          GestureDetector(
                              onTap: () {
                                isGender = true;
                                setState(() {});

                                if (addJanitorKey.currentState!.validate() &&
                                    janitorGender!.isNotEmpty &&
                                    isGender) {
                                  // print("task timing id ${taskTimes} ");

                                  String city = globalStorage.getCity();
                                  String address = "";
                                  //
                                  // globalStorage.getAddress();
                                  String pincode = globalStorage.getPincode();
                                  String clientId =
                                  globalStorage.getClientId();
                                  // print("facility $facilitydropdownNames");

                                  if (facilitydropdownNames.isNotEmpty) {
                                    print(
                                        "facility ${mobileController.text}");
                                    print("facility ${nameController.text}");
                                    print("facility $clientId");
                                    print("facility ${selectedFacility!}");

                                    dashBoardBloc.add(AddUserEvent(
                                      mobile: mobileController.text,
                                      name: nameController.text,
                                      roleId: "2",
                                      clientId: clientId,
                                      // gender: janitorGender,
                                      clusterId: [
                                        selectedFacility!.clusterId!
                                      ],
                                      isSelfAssign: isSelfAssign,
                                    ));
                                  } else {
                                    print(
                                        "janitorEstimatedTime ${clusterId}");
                                    clusterId != null
                                        ? dashBoardBloc.add(ClientSetUpEvent(
                                        clientId: clientId,
                                        orgName: facilityController.text,
                                        locality: roleId == 16
                                            ? defaultHostLocation!
                                            : loc!,
                                        pincode: pincode,
                                        address: address,
                                        clusterId: clusterId.toString(),
                                        city: city,
                                        facilityType: facility[selectedIndex]
                                            .title ==
                                            "Others"
                                            ? typeController.text
                                            : facility[selectedIndex]
                                            .title,
                                        mobile: globalStorage
                                            .getClientMobileNo()
                                      //  unitNo: "sd"
                                    ))
                                        : dashBoardBloc.add(ClientSetUpEvent(
                                        clientId: clientId,
                                        orgName: facilityController.text,
                                        locality: roleId == 16
                                            ? defaultHostLocation!
                                            : loc!,
                                        pincode: pincode,
                                        address: address,
                                        city: city,
                                        clusterId: "",
                                        facilityType:
                                        facilityType![selectedIndex]
                                            .typeName ==
                                            "Others"
                                            ? typeController.text
                                            : facilityType![selectedIndex]
                                            .typeName,
                                        mobile: globalStorage.getClientMobileNo()
                                      //  unitNo: "sd"
                                    ));
                                  }


                                }
                              },
                              child: const Custombutton(
                                  text: "Submit", width: double.infinity)),

                          const SizedBox(
                            height: 30,
                          ),
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
      isGender = false;
      janitorGender = "";
    },
  );
}