

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/bloc/dashboard_bloc.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/bloc/dashboard_state.dart';
import 'package:woloo_smart_hygiene/screens/dashboard/bloc/dashboard_state.dart';

import '../../../../../../screens/common_widgets/multiselect_dropdown.dart';
import '../../../../../../utils/app_color.dart';
import '../../../../../../utils/app_constants.dart';
import '../../../../../../utils/app_textstyle.dart';
import '../../../../../widgets/CustomButton.dart';
import '../../../controller/dashbaord_controller.dart';
import '../../../data/model/task_model.dart';
import '../../../data/model/tasklist_model.dart';
import '../add_time_dailog.dart';

class TaskBottomsheet extends StatefulWidget {
   const TaskBottomsheet({super.key, 
   
  });

  @override
  State<TaskBottomsheet> createState() => _TaskBottomsheetState();
}

class _TaskBottomsheetState extends State<TaskBottomsheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey widgetKey = GlobalKey();
  final GlobalKey _facilityKey = GlobalKey();
  DashBoardController dashController = Get.put(DashBoardController());
  bool isNext = false;
     List<TaskDropdownModel>? facilityNames = [] ; 
   int? estimatedTime;
   int? len;
   TimeOfDay? shiftTime;
   List<int>? taksIds = [];
   String? use12hour;
   ClientDashBoardBloc dashBoardBloc  = ClientDashBoardBloc();

  // final GlobalKey _taskKey = GlobalKey();
  // final GlobalKey _taskStartKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return  
    BlocConsumer(
      bloc: dashBoardBloc,
      listener: (context, state) {

          print("bottm sheet $state");
        if (state is DashboardLoading ) {
          EasyLoading.dismiss();
      
        }
           if ( state is GetTask ) {
             facilityNames = state.tasklist;
            // facilityNames!.addAll(state.taskListModel!.data!);
            print("task in the  $facilityNames");
          }
        if (state is DashboardError  ) {
          EasyLoading.dismiss();
          EasyLoading.showError(state.error.message);
        }
      },
      builder: (context, state) {
            if ( state is GetTask ) {
             facilityNames = state.tasklist;
            // facilityNames!.addAll(state.taskListModel!.data!);
            print("task in the  $facilityNames");
          }
        return StatefulBuilder(
                 builder: (context, StateSetter setState) {
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
                       height: 780,
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
                                 child: Text(DashboardConst.assignTasks,
                                   style: AppTextStyle.font18bold,
                                 ),
                               ),
                               const SizedBox(
                                 height: 20,
                               ),
        
        
                               Padding(
                                 padding: EdgeInsets.symmetric(
                                   horizontal: 20.w,
                                   vertical: 10.h,
                                 ),
                                 child: Container(
                                   decoration: BoxDecoration(
                                     color: Colors.white,
        
                                     borderRadius: BorderRadius.circular(25.r),
                                     boxShadow: [
                                       BoxShadow(
                                         color: Colors.black.withValues(alpha: 0.2), // Shadow color
                                         spreadRadius: 1, // How wide the shadow should spread
                                         blurRadius: 10, // The blur effect of the shadow
                                         offset: const Offset(0,
                                             5), // Shadow offset, with y-offset for bottom shadow
                                       ),
                                     ],
                                   ),
                                   child: MultiselectDropDownDialog(
                                     widgetKey: _facilityKey,
                                     hint: DashboardConst.selectCleaningTasks,
                                     // key: Key(
                                     //     '${_editProductModel.paymentMethodId?.firstOrNull?.label}T5'),
                                     // selected: _editProductModel.paymentMethodId,
                                     items: facilityNames!,
                                     itemAsString: (TaskDropdownModel item) {
                                       return
                                         "${item.facilityName}   ${item.requiredTime} min" ;  },
                                     validator: (value) {
                                        print("slecrte $value");
                                       value == []
                                         ? "Please select tasks"
        
                                         : null;
                                     },
        
                                     onSaved: (List<TaskDropdownModel> i) {
                                       // selectedIds.add(i[1].taskId!);
                                       // selectedIds =
                                       //     i.map((e) => e.taskId.toString()).toList();
                                     },
                                     onChanged: (List<TaskDropdownModel> i) {
                                        // print(" car $i ");
                                       List<int?> listTime = [];
        
                                    len =  i.length;
        
                                       listTime =  i.map( (e) =>  e.requiredTime).toList();
        
                                        print("total time $estimatedTime");
                                         if(i.isEmpty){
                                           estimatedTime = null;
                                         }else
                                          if( i.isNotEmpty){
                                           estimatedTime = listTime.reduce((a, b) => a! + b!);
                                             taksIds =  i.map( (e) => e.id! ).toList();
                                          }
                                         else
                                       if( i.isNotEmpty && len! < i.length    ){
                                         listTime =  i.map( (e) =>  e.requiredTime).toList();
                                         estimatedTime = listTime.reduce((a, b) => a! - b!);
                                       }
        
                                        print("estimagte $estimatedTime ");
        
                                       // if(i.isEmpty ){
                                       //    estimatedTime = 0;
                                       // }
                                        setState( (){});
        
        
                                       // selectedIds =
                                       //     i.map((e) => e.taskId.toString()).toList();
                                       // debugPrint(selectedIds.toString());
                                     },
                                     // label: 'Template Name',
                                   ),
                                 ),
                               ),
        
        
                               const SizedBox(
                                 height: 10,
                               ),
        
                                Text( DashboardConst.estimatedTaskCompletionTime,
                                 style: AppTextStyle.font20bold.copyWith(
                                   color: const Color(0xff8F8F8F)
                                 ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child:
                                 estimatedTime == null ?
                                  Text('00:00',
                                    style: AppTextStyle.font24bold,
                                  )
                                      : Text("$estimatedTime min",
                                    style: AppTextStyle.font24bold,
                                  )
        
                                  ,
                                ),
                               const SizedBox(
                                 height: 10,
                               ),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Text(DashboardConst.scheduleShift,
                                     style: AppTextStyle.font14w7,
                                   ),
        
                                   InkWell(
                                     onTap: ()async{
        
                                        // if(  estimatedTime ==  null ) return;
        
        
                                       shiftTime = await    showTimePicker(
                                         context: context,
                                         initialTime: TimeOfDay.now(),
                                         // builder: (BuildContext context, Widget? child) {
                                         //   // return Directionality(
                                         //   //   // textDirection: TextDirection.rtl,
                                         //   //   child: child!,
                                         //   // );
                                         // },
                                       );
                                       DateTime date = DateTime.now();
                                       // date.add( Duration( hours: shiftTime!.hour, minutes: shiftTime!.minute  ) );
                                        // print("duration ${}");
        
                                       DateTime dateTime = DateTime(date.year, date.month, date.day,shiftTime!.hour,shiftTime!.minute);
                                       DateTime newDateTime = dateTime.add(const Duration(hours: 12));
                                       TimeOfDay newShiftTime = TimeOfDay.fromDateTime(newDateTime);
                                       final localizations = MaterialLocalizations.of(context);
                                          use12hour =   localizations.formatTimeOfDay(newShiftTime, alwaysUse24HourFormat: false);
                                        // DateTime  hour =   date.add( Duration(hours: 12, minutes: 0 ));
                                       print("timen $newDateTime ");
                                         print("hour $use12hour ");
                                       setState((){});
                                     },
                                     child: Container(
                                       width: 110,
                                       height: 40,
                                       decoration: BoxDecoration(
                                         color: AppColors.white,
                                         borderRadius: BorderRadius.circular(8),
                                         boxShadow: [
        
                                           BoxShadow(
                                             color: Colors.black
                                                 .withValues(alpha:0.2), // Shadow color
                                             spreadRadius:
                                             1, // How wide the shadow should spread
                                             blurRadius:
                                             10, // The blur effect of the shadow
                                             offset: const Offset(0,
                                                 0), // No offset for shadow on all sides
                                           ),
                                         ],
                                       // ),
                                       ),
                                       child: Center(child:
                                      shiftTime != null ?
        
                                         Text(shiftTime!.format(context),
                                           style: AppTextStyle.font14w7,
                                         ) :
        
                                       Text("Start Time *",
                                        style: AppTextStyle.font14w7,
                                       )),
        
                                     ),
                                   )
        
                                 ],
                               ),
        
                              shiftTime == null && isNext ?
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text("Please select shift Timing",
                                         style: AppTextStyle.font12.copyWith(color: AppColors.red ),
                                        ),
                                      ],
                                    )
                                : const SizedBox(
                                 // height: ,
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
                                           .withValues(alpha:0.2), // Shadow color
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
                                   padding: const EdgeInsets.symmetric( horizontal: 15),
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       const SizedBox(
                                         height: 15,
                                       ),
                                       Row(
                                         crossAxisAlignment: CrossAxisAlignment.center,
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                           Text(DashboardConst.scheduleTask,
                                             style: AppTextStyle.font14w7,
                                           ),
                                           GestureDetector(
                                               onTap:(){
                                                  Datum? buddy;
        
                                                 _showMyDialog(false,  );
        
                                                 // janitorBottomSheet()
                                               } ,
                                               child: Custombutton(text: DashboardConst.addTimings, width: 164.w))
        
                                         ],
                                       ),
        
                                       dashController.taskStartTime.isEmpty && isNext ?
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         mainAxisAlignment: MainAxisAlignment.start,
                                         children: [
                                           const SizedBox(
                                             height: 10,
                                           ),
                                           Text("Please add Timing for tasks",
                                             style: AppTextStyle.font12.copyWith(color: AppColors.red ),
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
        
        
                                          ()=>
                                            SizedBox(
                                              height:dashController.taskStartTime.isEmpty ? 0:200,
                                              child:                    ListView.builder(
                                                                                   shrinkWrap: true,
                                                                                   itemCount: dashController.taskStartTime.length ,
                                                                                   itemBuilder: (context, index) {
                                                                                     return ListTile(
                                                trailing: IconButton(
                                                   onPressed: () {
                                                     dashController.taskStartTime.removeAt(index);
                                                     dashController.taskEndTime.removeAt(index);
                                                      dashController.taskTimes.removeAt(index);
                                                    //  setState((){});
                                                   } ,
        
                                                  icon:  const Icon(  Icons.delete,),
                                                 color: AppColors.red,
                                                ),
                                               title:  Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   Text( dashController.taskStartTime[index].format(context) ,
                                                    style: AppTextStyle.font14bold,
                                                   ),
                                                   // taskEndTime
                                                   Text( dashController.taskEndTime[index].format(context) ,
                                                     style: AppTextStyle.font14bold,
                                                   ),
                                                 ],
                                               ),
                                                                                     );
                                                                                 }, ),
                                            ),
                                       )
                                     ],
                                   ),
                                 ),
                               ),
        
        
        
                               const SizedBox(height: 10),
                                 Center(child: Text("The shift shall start at ${ shiftTime == null ? '00:00' : shiftTime!.format(context)}")),
                               const SizedBox(height: 5),
                                Center(child: Text(
                                   textAlign: TextAlign.center,
                                   "Shift shall complete at $use12hour" )),
        
                               const SizedBox(height: 10),
                               // GestureDetector(
                               //   onTap: (){},
                               //   child: Center(child: Text(
                               //       style: AppTextStyle.font18bold.copyWith(
                               //         color: AppColors.backgroundColor
                               //       ),
                               //       DashboardConst.addAnotherFacility,
                               //
                               //   )
                               //   ),
                               // ),
        
                               const SizedBox(height: 10),
        
        
                               GestureDetector(
                                   onTap:(){
                                     isNext = true;
                                     setState((){});
                                      print("curtne ${_formKey.currentState!.validate()}");
                                      if( shiftTime != null && dashController.taskStartTime.isNotEmpty && estimatedTime != null ){
                                     // && shiftTime != null && taskStartTime.isNotEmpty && estimatedTime != null
                                    //  adminBottomSheet();
        
                                      }
        
        
                                     // janitorBottomSheet()
} ,
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
    );
    
  }


      Future<void> _showMyDialog(bool isFromExiting, {Datum? janitor}) async {

        // print("shift $shiftTime ");
        // print("shift $use12hour ");
        // print("estima $estimatedTime ");

         showDialog<Map<String, List<TimeOfDay>>>(
         context: context,
         barrierDismissible: true, // user must tap button!
         builder: (BuildContext context) {
           return  AddTimeDailog(
              estimatedTime: estimatedTime!,
              startTime:shiftTime,
              endTime: use12hour,
              isFromExisting: isFromExiting,
              janitorId: janitor == null ? null : janitor.id,
              facalityName: "",
              facilityType: "",

              // taskStartTime: taskStartTime,
              // taskEndTime: taskEndTime,
              // taskTimes: taskTimes,

           );


         },
       );
             // .then((value) {
       //      // taskStartTime = value!["taskStartTime"]! ;
       //      //  taskEndTime = value["taskEndTime"]! ;
       //      // setState(() {
       //
       //
       //      // });
       //       print(" valeiu $taskTimes");
       //   // return;
       //    return  value;
       // }, );

     }
}