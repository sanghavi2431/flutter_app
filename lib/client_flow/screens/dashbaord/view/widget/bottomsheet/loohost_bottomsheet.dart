import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../screens/common_widgets/dropdown_dialogue.dart';
import '../../../../../../screens/common_widgets/image_provider.dart';
import '../../../../../../utils/app_color.dart';
import '../../../../../../utils/app_constants.dart';
import '../../../../../../utils/app_textstyle.dart';
import '../../../../../utils/client_constant.dart';
import '../../../../../utils/client_images.dart';
import '../../../../../widgets/CustomButton.dart';
import '../../../../../widgets/CustomTextField.dart';
import '../../../data/model/facility_dropdown_model.dart';
import '../../../data/model/tasklist_model.dart';

class LoohostBottomsheet extends StatefulWidget {
  const LoohostBottomsheet({super.key});

  @override
  State<LoohostBottomsheet> createState() => _LoohostBottomsheetState();
}

class _LoohostBottomsheetState extends State<LoohostBottomsheet> {
    final TextEditingController mobileController = TextEditingController();
        List<TaskDropdownModel>  hostList = [
     TaskDropdownModel(
         id: 1,
         facilityName: "Host 1"
     ),
     TaskDropdownModel(
         id: 1,
         facilityName: "Host 2"
     )
   ];

 
  @override
  Widget build(BuildContext context) {
    return  Container(
           padding: const EdgeInsets.symmetric(horizontal: 16 ),
              height: MediaQuery.of(context).size.height/1.6,
             decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(80.0),
                      topRight: Radius.circular(80.0),
                    ),
                  ),
      child:   Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //  mainAxisAlignment: MainAxisAlignment.start,
        children: [
                          const SizedBox(
                                height: 9,
                               ),
                               Center(
                                 child: CustomImageProvider(
                                  image: ClientImages.line,
                                  width: 70,
                                 ),
                               ),
                                 const SizedBox(
                             height: 20,
                            ),
      
              Center(
                child: Text(ClientConstant.becomeHostTitle,
                style: AppTextStyle.font20bold,
                             ),
              ),

              const SizedBox(
                  height: 20,
                 ),


              Text(
                textAlign: TextAlign.center,
                ClientConstant.addExistingRestaurant,
              style: AppTextStyle.font15,
             ),
               const SizedBox(
                  height: 20,
                 ),


      
                   const SizedBox(
                  height: 10,
                 ),

                     Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 10.h),
                                child: DropDownDialog(
                                  isprop: true,
                                            
                                  // selected: clusterNames.first,
                                  // key: _dropDownKey,
                                  // widgetKey: _clusterNameKey,
                                  hint:ClientConstant.restaurantName,
                                            
                                  items: hostList,
                                            
                                  itemAsString: (FacilityDropdownModel item) =>
                                  item.facilityName,
                                  onChanged: (FacilityDropdownModel item) {
                                    debugPrint("in drop down ${item.locationName}");
                                    try {
                                            
                                      // locationController.text =   item.locationName!;
                                      // facilityController.text = item.facilityName!;
                                      setState(() {});
                                            
                                      // clusterId = item..id!;
                                      // reportIssueBloc.add(GetAllFacilityDropdown(
                                      //     clusterId: item.clusterId ?? 0));
                                      //
                                      //   // if(state is GetFacilityDropdownSuccess ){
                                      //     reportIssueBloc.add(GetAllTasksDropdown(
                                      //         clusterId: item.clusterId! ?? 0
                                      //     ));
                                      //   // }else
                                      //    // if( state is  GetTasksDropdownSuccess ){
                                      //      reportIssueBloc.add(GetAllJanitorsDropdown(
                                      //          clusterId: item.clusterId ?? 0));
                                      // }
                                            
                                            
                                    } catch (e) {
                                      debugPrint("dropppppp$e");
                                    }
                                  },
                                  validator: (value) =>
                                  value == null
                                      ?
                                      "Please select facility"
                                      : null,
                                ),
                              ),

                   const SizedBox(
                  height: 10,
                 ),

                                 CustomTextField(
                                  padding: const EdgeInsets.all(0),


                  controller: mobileController,
                  hintText:ClientConstant.restaurantAddress,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  validator: validateMobile
                
                  // prefixIcon: Icons.phone,
                ), 
                const SizedBox(
                  height: 10,
                 ),

              Text(
                textAlign: TextAlign.center,
                ClientConstant.addHostPhotos,
              style: AppTextStyle.font15,
             ),
              
                   const SizedBox(
                  height: 10,
                 ),

                 Container(
                  width: 100,
                  height: 100,
                 
                  decoration: BoxDecoration(
                     color: const Color(0xffF3F3F3),
                    borderRadius: BorderRadius.circular(17)
                  ),

                  child: CustomImageProvider(
                    image: ClientImages.more,
                     width: 20,
                     height: 20,
                     fit: BoxFit.none,
                  ),
                 ),
               


                  const Spacer(),
                  Padding(
                   padding: const EdgeInsets.symmetric( horizontal: 16),
                   child: GestureDetector(
                     onTap: () {
                      //  showModalBottomSheet(
                      //    backgroundColor: Colors.transparent,
                      //   context: context, builder:  (context) {
                      //    return OtpBottomsheet();
                      //  }, );
                     },
                    child: const Custombutton(text: ClientConstant.next, width:double.infinity)),
                 ),
                     const SizedBox(
                  height: 20,
                 ),
          
        ],
      ),
    ) ;
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
}