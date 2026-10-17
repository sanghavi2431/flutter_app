 import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/model/facility_type_model.dart';

import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../utils/client_images.dart';
import '../../../../widgets/CustomButton.dart';
import '../../../../widgets/CustomTextField.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../data/model/facility_dropdown_model.dart';
import '../../data/model/facility_model.dart';
import 'assign_task_header.dart';
import 'assign_task_janitor_bottom_sheet.dart';

 class _SupervisorSheetConstants {
   static const double borderRadius = 80.0;
   static const double horizontalPadding = 20.0;

   static const double spacingLarge = 70;
   static const double spacingMedium = 40;

   static const double initialChildSize = 0.7;
   static const double minChildSize = 0.7;
   static const double maxChildSize = 0.8;

   static const String next = "Next";
 }

 void superVisorBottomSheet({
   required BuildContext context,
   required TextEditingController nameController,
   required TextEditingController mobileController,
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
     backgroundColor: Colors.transparent,
     isScrollControlled: true,
     builder: (_) => _SupervisorSheetContent(
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
     ),
   ).then((_) {
     mobileController.clear();
     nameController.clear();
   });
 }

 /// =====================
 /// CONTENT WIDGET
 /// =====================
 class _SupervisorSheetContent extends StatelessWidget {
   final TextEditingController nameController;
   final TextEditingController mobileController;
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
   final TextEditingController facilityController;
   final List<TypeFacility>? facilityType;
   final int facilityCount;
   final TextEditingController typeController;
   final bool isFirstTimeHost;
   final String? defaultHostLocation;
   final int? roleId;
   final int selectedIndex;
   final String? loc;

   const _SupervisorSheetContent({
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
     required this.defaultHostLocation,
     required this.roleId,
     required this.selectedIndex,
     required this.loc,
   });

   @override
   Widget build(BuildContext context) {
     return StatefulBuilder(
       builder: (context, setState) {
         return DraggableScrollableSheet(
           initialChildSize: _SupervisorSheetConstants.initialChildSize,
           minChildSize: _SupervisorSheetConstants.minChildSize,
           maxChildSize: _SupervisorSheetConstants.maxChildSize,
           builder: (_, scrollController) {
             return Container(
               height: MediaQuery.of(context).size.height / 1.4,
               decoration: const BoxDecoration(
                 color: AppColors.white,
                 borderRadius: BorderRadius.only(
                   topLeft: Radius.circular(_SupervisorSheetConstants.borderRadius),
                   topRight: Radius.circular(_SupervisorSheetConstants.borderRadius),
                 ),
               ),
               child: Form(
                 key: addSuperVisorKey,
                 child: Padding(
                   padding: const EdgeInsets.symmetric(
                       horizontal: _SupervisorSheetConstants.horizontalPadding),
                   child: ListView(
                     controller: scrollController,
                     children: [
                       /// HEADER
                       AssignTaskHeader(
                         title: "Assign",
                         subTitle: DashboardConst.assignsupervisor,
                         image: ClientImages.avatar,
                       ),

                       const SizedBox(
                           height: _SupervisorSheetConstants.spacingLarge),

                       /// NAME FIELD
                       CustomTextField(
                         padding: EdgeInsets.zero,
                         controller: nameController,
                         hintText: DashboardConst.fullName,
                         keyboardType: TextInputType.text,
                         validator: validateName,
                       ),

                       const SizedBox(
                           height: _SupervisorSheetConstants.spacingMedium),

                       /// MOBILE FIELD
                       CustomTextField(
                         padding: EdgeInsets.zero,
                         readOnly: isAdminSelected,
                         controller: mobileController,
                         hintText: DashboardConst.number,
                         keyboardType: const TextInputType.numberWithOptions(
                           signed: true,
                           decimal: true,
                         ),
                         maxLength: 10,
                         validator: validateMobile,
                       ),

                       SizedBox(
                         height: MediaQuery.of(context).size.height / 3.5,
                       ),

                       /// NEXT BUTTON
                       GestureDetector(
                         onTap: () {
                           if (addSuperVisorKey.currentState!.validate()) {
                             _openJanitorSheet(context);
                           }
                         },
                         child: const Custombutton(
                           text: _SupervisorSheetConstants.next,
                           width: double.infinity,
                         ),
                       ),

                       const SizedBox(
                           height: _SupervisorSheetConstants.spacingMedium),
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

   /// =====================
   /// NAVIGATION
   /// =====================
   void _openJanitorSheet(BuildContext context) {
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
   }
 }

 String? validateMobile(String? value) {
   if (value == null || value.isEmpty) {
     return "Mobile number is required";
   }
   if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
     return "Enter a valid 10-digit number";
   }
   return null;
 }

 String? validateName(String? value) {
   if (value == null || value.isEmpty) {
     return "Name is required";
   }
   if (value.length < 3) {
     return "Name must be at least 3 characters";
   }
   return null;
 }


 /*
void superVisorBottomSheet({
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
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.7,
              maxChildSize: 0.8,
              // stream: null,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(80.0),
                      topRight: Radius.circular(80.0),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height / 1.4,
                  child: Form(
                    key: addSuperVisorKey,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView(
                          controller: scrollController,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            AssignTaskHeader(title:"Assign", subTitle:DashboardConst.assignsupervisor,
                                image:ClientImages.avatar),
                            //  Center(
                            //    child: Text(DashboardConst.assignsupervisor,
                            //      style: AppTextStyle.font18bold,
                            //    ),
                            //  ),
                            // Text(estimatedTime.toString(),
                            //   style: AppTextStyle.font18bold,
                            // ),
                            const SizedBox(
                              height: 70,
                            ),
                            CustomTextField(
                                padding: const EdgeInsets.all(0),
                                // readOnly: isAdminSelected,
                                controller: nameController,
                                hintText: DashboardConst.fullName,
                                keyboardType: TextInputType.text,
                                //  maxLength: 10,

                                validator: validateName
                              // prefixIcon: Icons.phone,
                            ),
                            const SizedBox(height: 40),

                            CustomTextField(
                                padding: const EdgeInsets.all(0),
                                readOnly: isAdminSelected,
                                controller: mobileController,
                                hintText: DashboardConst.number,
                                keyboardType:
                                const TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                                maxLength: 10,
                                validator: validateMobile
                              // prefixIcon: Icons.phone,
                            ),

                            // const Spacer(),

                            SizedBox(
                                height:
                                MediaQuery.of(context).size.height / 3.5),

                            GestureDetector(
                                onTap: () {
                                  if (addSuperVisorKey.currentState!
                                      .validate()) {
                                    janitorBottomSheet(
                                      context : context,
                                      nameController: nameController,
                                      mobileController: mobileController,
                                      isAdminSelected:  isAdminSelected,
                                      isSelfAssign: isSelfAssign,
                                      selectedAdmin: selectedAdmin,
                                      erroradminMessage: erroradminMessage,
                                      addSuperVisorKey: addSuperVisorKey,
                                      janNameController: janNameController,
                                      janMobileController: janMobileController,
                                      janitorGender: janitorGender, isGender: isGender,
                                      addJanitorKey: addJanitorKey,
                                      selectedGender: selectedGender, dashBoardBloc: dashBoardBloc,
                                      facilitydropdownNames: facilitydropdownNames,
                                      facilityList: facilityList, facilityController: facilityController, facilityType: facilityType,
                                      facilityCount: facilityCount,
                                      typeController: typeController,
                                      isFirstTimeHost: isFirstTimeHost, defaultHostLocation: defaultHostLocation,
                                      roleId: roleId, selectedIndex: selectedIndex, loc: loc,
                                    );
                                  }
                                },
                                child: const Custombutton(
                                    text: "Next", width: double.infinity)),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
      },
    ).then((v) {
      mobileController.clear();
      nameController.clear();
    });
  }
*/
/*
 String? validateMobile(String? value) {
   if (value == null || value.isEmpty) {
     return "Mobile number is required";
   }
   if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
     return "Enter a valid 10-digit number";
   }
   return null;
 }

 String? validateName(String? value) {
   if (value == null || value.isEmpty) {
     return "Name is required";
   }
   if (value.length < 3) {
     return "Name must be at least 3 characters";
   }
   return null;
 }*/
