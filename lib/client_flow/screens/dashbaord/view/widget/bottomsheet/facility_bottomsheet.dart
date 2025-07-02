


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/widget/bottomsheet/task_bottomsheet.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';

import '../../../../../../screens/common_widgets/dropdown_dialogue.dart';
import '../../../../../../screens/common_widgets/image_provider.dart';
import '../../../../../../utils/app_constants.dart';
import '../../../../../../utils/app_textstyle.dart';
import '../../../../../widgets/CustomButton.dart';
import '../../../../../widgets/CustomTextField.dart';
import '../../../bloc/dashboard_bloc.dart';
import '../../../bloc/dashboard_event.dart';
import '../../../model/facility_model.dart';

class FacilityBottomsheet extends StatefulWidget {
  TextEditingController? locationController = TextEditingController();
   TextEditingController? facilityController = TextEditingController();
   TextEditingController typeController = TextEditingController();
   ClientDashBoardBloc dashBoardBloc = ClientDashBoardBloc();
   GlobalKey<FormState> facilityKey = GlobalKey<FormState>();
   
   FacilityBottomsheet({super.key, 
    required this.locationController,
    required this.facilityController,
    required this.typeController,
    required this.dashBoardBloc,
    required this.facilityKey
  });

  @override
  State<FacilityBottomsheet> createState() => _FacilityBottomsheetState();
}

class _FacilityBottomsheetState extends State<FacilityBottomsheet> {
  bool isSelected = false;
  int selectedIndex = 0;
  final GlobalKey<FormState> facilityKey = GlobalKey<FormState>();
  //  ClientDashBoardBloc dashBoardBloc  = ClientDashBoardBloc();

  @override
  Widget build(BuildContext context) {
    return 
         StatefulBuilder(

            builder: (context, StateSetter setState) {

              return Form(
                key: facilityKey,

                child: Container(

                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(80.0),
                      topRight: Radius.circular(80.0),
                    ),
                  ),
                  height: 650,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric( horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                           const SizedBox(
                             height: 20,
                           ),
                          Center(
                            child: Text(DashboardConst.listYourFacility,
                             style: AppTextStyle.font18bold,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // facilitydropdownNames.isNotEmpty ?

                          // Padding(
                          //   padding: EdgeInsets.symmetric(
                          //       horizontal: 20.w, vertical: 10.h),
                          //   child: DropDownDialog(
                          //     isprop: true,

                          //     // selected: clusterNames.first,
                          //     // key: _dropDownKey,
                          //     widgetKey: _clusterNameKey,
                          //     hint:DashboardConst.organizationName,

                          //     items: facilitydropdownNames,

                          //     itemAsString: (FacilityDropdownModel item) =>
                          //     item.facilityName,
                          //     onChanged: (FacilityDropdownModel item) {
                          //       debugPrint("in drop down ${item.locationName}");
                          //       try {

                          //         locationController.text =   item.locationName!;
                          //         facilityController.text = item.facilityName!;
                          //         setState(() {});

                          //         // clusterId = item..id!;
                          //         // reportIssueBloc.add(GetAllFacilityDropdown(
                          //         //     clusterId: item.clusterId ?? 0));
                          //         //
                          //         //   // if(state is GetFacilityDropdownSuccess ){
                          //         //     reportIssueBloc.add(GetAllTasksDropdown(
                          //         //         clusterId: item.clusterId! ?? 0
                          //         //     ));
                          //         //   // }else
                          //         //    // if( state is  GetTasksDropdownSuccess ){
                          //         //      reportIssueBloc.add(GetAllJanitorsDropdown(
                          //         //          clusterId: item.clusterId ?? 0));
                          //         // }


                          //       } catch (e) {
                          //         debugPrint("dropppppp$e");
                          //       }
                          //     },
                          //     validator: (value) =>
                          //     value == null
                          //         ?
                          //         "Please select facility"
                          //         : null,
                          //   ),
                          // )
                          // :

                           CustomTextField(
                            hintText:DashboardConst.organizationName,
                            controller: widget.facilityController,

                             validator: (valu) {
                               if (valu == null || valu.isEmpty) {
                                 return "Facility Name is required";
                               }
                               return null;
                             },
                           ),
                         
                           const SizedBox(
                            height: 10,
                           ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                            child: Container(
                              height: 36.h,
                              decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2), // Shadow color
                                  spreadRadius: 1, // Spread effect
                                  blurRadius: 10, // Blur effect
                                  offset: const Offset(0, 5), // Bottom shadow
                                ),
                              ],
                            ),
                              child: GooglePlaceAutoCompleteTextField(
                                textEditingController: widget.locationController!,
                                googleAPIKey:"AIzaSyCkPmUz4UlRdzcKG9gniW9Qfrgzsjhnb_4",
                                inputDecoration:  InputDecoration(
                                  hintText: DashboardConst.location,
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.sp,
                                      ),
                                   border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(12),
                                   borderSide: BorderSide.none,
                                   ),
                                   fillColor: AppColors.white,
                                   filled: true
                                  // enabledBorder: InputBorder.none,
                                ),
                                validator: (valu, p1) {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                  if (valu == null || valu.isEmpty) {
                                    return "Location is required";
                                  }
                                  return null;
                                },

                                // debounceTime: 400,
                                countries: const ["in", "fr"],
                                isLatLngRequired: true,
                                getPlaceDetailWithLatLng: (Prediction prediction) {
                                  print("placeDetails${prediction.lat}");
                                },

                                itemClick: (Prediction prediction) {
                              
                                  // facilityController.dispose();
                                  widget.locationController!.text = prediction.description ?? "";
                                   widget.locationController!.selection = TextSelection.fromPosition(
                                      TextPosition(offset: prediction.description?.length ?? 0));
                                },

                                seperatedBuilder: const Divider(),
                                containerHorizontalPadding: 10,
                                // OPTIONAL// If you want to customize list view item builder
                                itemBuilder: (context, index, Prediction prediction) {
                                  return Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.location_on),
                                        const SizedBox(
                                          width: 7,
                                        ),
                                        Expanded(child: Text(prediction.description ?? ""))
                                      ],
                                    ),
                                  );
                                },

                                isCrossBtnShown: true,

                                // default 600 ms ,
                              ),
                            ),
                          ),
                           //  CustomTextField(
                           //  hintText:DashboardConst.location,
                           //  controller:  locationController,
                           // ),
                           const SizedBox(
                            height: 10,
                           ),
                          Text(DashboardConst.typeOfFacility,
                           style: AppTextStyle.font14bold,
                          ),
                          const SizedBox(
                            height: 10,
                           ),

                                                  SizedBox(
                                                      width: MediaQuery.of(context).size.width,
                                                      // height: 120,
                                                      child:
                                                      Wrap(
                                                        spacing: 1.0, // Adjust spacing between items
                                                        children: List.generate(facility.length, (index) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                selectedIndex = index;
                                                                print("title ${facility[selectedIndex].title!}");

                                                              });
                                                              facility[selectedIndex].title == "Other"   ? isSelected = true

                                                                  : isSelected = false;
                                                                 print("is slec $isSelected");
                                                              widget.dashBoardBloc.add( GetTaskEvent(
                                                                  category:  facility[selectedIndex].title!
                                                              ) );
                                                              setState((){});

                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: card(facility[index].image!, facility[index].title!, index),
                                                            ),
                                                          );
                                                        }),
                                                    ),),
                          const SizedBox(
                            height: 10,
                          ),
                          isSelected ?
                          CustomTextField(
                            hintText:DashboardConst.ifOthersMentionFacility,
                            controller: widget.typeController,
                            validator: (valu) {
                              if (valu == null || valu.isEmpty) {
                                return "Please mention other type";
                              }
                              return null;
                            },
                          )
                           : const SizedBox()
                          ,

                          const SizedBox(
                            height: 10,
                          ),

                           GestureDetector(
                             onTap: () {

                                if(facilityKey.currentState!.validate()){


                                       showModalBottomSheet(context: context,
                                       isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(80.0),
                                            topRight: Radius.circular(80.0),
                                          )),
                                        builder: 
                                        (context) {
                                           return TaskBottomsheet(

                                           );
                                        },
                                       );

                                //   facilitydropdownNames.isNotEmpty ?

                                //   selectedbuddy == null ?
                                //   taskBottomSheet() :

                                //   taskExistingBottomSheet(selectedbuddy!)
                                //   : taskBottomSheet()
                                //   ;

                                }


                             },
                            child: Custombutton(text: "Next", width: 328.w))

                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          );
    
  }




  Widget card( String image, String title, int index){
    return   Container(
                   width: 110,
                  height: 96,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 1, // Spread effect
                          blurRadius: 10, // Blur effect
                          offset: const Offset(0, 5), // Bottom shadow
                        ),
                      ],
                    color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),

                  border:  Border.all(
                    color: selectedIndex == index ?  AppColors.backgroundColor : AppColors.white
                  )
               ),
            child:  Column(
              children: [
                   const SizedBox(
                     height: 10,
                   ),
                  CustomImageProvider(
                    image: image ,
                    width: 46,
                    height: 46,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(title,
                  style:  AppTextStyle.font13.copyWith(color:  AppColors.greyBorder ),
                  )

              ],
            )                                      
       );

  }
}