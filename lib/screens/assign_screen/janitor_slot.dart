


import 'package:Woloo_Smart_hygiene/screens/common_widgets/leading_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../utils/app_color.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_textstyle.dart';
import '../common_widgets/dialogue_box_issue_report.dart';
import '../common_widgets/error_widget.dart';
import '../dashboard/bloc/dashboard_bloc.dart';
import '../dashboard/data/model/dashboard_model_class.dart';
import '../supervisor_dashboard/bloc/supervisor_dashboard_bloc.dart';
import '../supervisor_dashboard/bloc/supervisor_dashboard_event.dart' as event;
import 'bloc/assign_bloc.dart';
import 'bloc/assign_event.dart';
import 'bloc/assign_state.dart';

class JanitorSlot extends StatefulWidget {
  final  int id;
  final int? templateid;
  final String? taskName;
  final String?  status;
  const JanitorSlot({super.key, required this.id,this.taskName, this.templateid, required this.status });

  @override
  State<JanitorSlot> createState() => _JanitorSlotState();
}

class _JanitorSlotState extends State<JanitorSlot> {

    AssignBloc assignBloc = AssignBloc() ;
    List<DashboardModelClass> janitorTask = [];
    TextEditingController controller = TextEditingController();
    TextEditingController startController = TextEditingController();
    TextEditingController endController = TextEditingController();
    late SupervisorDashboardBloc _supervisorDashboardBloc;
    final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.text = widget.taskName!;
    _supervisorDashboardBloc = GetIt.instance<SupervisorDashboardBloc>();

    assignBloc.add( GetJanitorTask(
        id: widget.id
    ));
     //  assignBloc = BlocProvider.of<AssignBloc>(context)..add(const GetJanitorTask());


  }


 

  @override
  Widget build(BuildContext context) {

    return 
    
    Scaffold(
       // resizeToAvoidBottomInset: false,

      backgroundColor: AppColors.white,
       appBar: AppBar(
         leadingWidth: 100,
         backgroundColor: AppColors.white,
        leading: const LeadingButton(),
       ),
     body:  SingleChildScrollView(
       child: Padding(
         padding:  EdgeInsets.symmetric(horizontal: 20.w ),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                Text(
                AssignScreenConstants.JANITOR_SCHEDULE.tr(),
                style:
                AppTextStyle.font24bold.copyWith(
                color: AppColors.black,
                ),),
                SizedBox(
                  height: 10.h,
                ),
                 Text(
                AssignScreenConstants.AVAILABLE_TIME_SLOT.tr(),
                style:
                AppTextStyle.font16w7.copyWith(
                color: AppColors.black,
                ),),
                 SizedBox(
                  height: 10.h,
                ),
       
                BlocConsumer(
                  listener: (context, state) {

                    if(state is AssignTaskDataSuccess){
                      EasyLoading.dismiss();
                      openDialog();
                      assignBloc.add( GetJanitorTask(
                          id: widget.id
                      ));
                     // Navigator.of(context).pop();
                    //  Navigator.of(context).pop();
                     _supervisorDashboardBloc.add(event.GetSupervisorDashboardData());
                    }

                  },
                  bloc: assignBloc,
                  builder: (context, state) {
                      if (state is  JanitorTaskLoading  ) {
              EasyLoading.show(
                  status: MydashboardScreenConstants.LOADING_TOAST.tr());
            }
             else
            if (state is GetJanitorTaskError) {
              return CustomErrorWidget(error: state.error.message);
            }
            else
            if (state is GetJanitorTaskDataSuccess  ) {
       
                EasyLoading.dismiss();
               janitorTask = state.data;
           //   return const EmptyListWidget();
            }
            if( state is AssignTaskLoading  ){
              EasyLoading.show(
                  status: MydashboardScreenConstants.LOADING_TOAST.tr());

            }

             if(state is AssignTaskDataSuccess){
               EasyLoading.dismiss();
              //  Navigator.of(context).pop();
              // Navigator.of(context).pop();
             }
             if (state is AssignTaskError) {
                        return CustomErrorWidget(error: state.error.message);
             }
       
       
       
       
                    return
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height:260,
                            // flex:2,

                            child: ListView.builder(

                              itemCount: janitorTask.length,
                              itemBuilder:
                            (context, index) {
                               return Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(25.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withOpacity(0.2), // Shadow color
                                          spreadRadius:
                                          1, // How wide the shadow should spread
                                          blurRadius:
                                          10, // The blur effect of the shadow
                                          offset: const Offset(0,
                                              0), // No offset for shadow on all sides
                                        ),
                                      ],
                                    ),
                                  child:  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      title: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 10
                                        ),
                                        child: Text("${janitorTask[index].description!}",
                                          style: AppTextStyle.font14bold,
                                        ),
                                      ),

                                      subtitle:Row(
                                        children: [
                                          Text(janitorTask[index].startTime!,
                                          style: AppTextStyle.font14,
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Text(janitorTask[index].endTime!,
                                            style: AppTextStyle.font14,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                 ),
                               );
                            }, ),


                          ),

                        ],
                      );
                  }
                ),


       
          ],
         ),
       ),
     ),
      bottomNavigationBar:
      Form(
        key:formKey,
        child: Container(
          height: 450,
          child: Center(
            child: Padding(
              padding:  EdgeInsets.symmetric( horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(AssignScreenConstants.UPDATE_TASK.tr(),
                    style: AppTextStyle.font16.copyWith(
                        fontWeight: FontWeight.w700
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(AssignScreenConstants.TASK_NAME.tr(),
                    style: AppTextStyle.font13w6,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 1, // How wide the shadow should spread
                          blurRadius: 10, // The blur effect of the shadow
                          offset: const Offset(0,
                              5), // Shadow offset, with y-offset for bottom shadow
                        ),
                      ],
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textAlign: TextAlign.start,
                      enabled: false,
                      controller: controller,
                      validator: (value) {
                        // if (value == null || value.isEmpty) {
                        //   return AssignScreenConstants.START_TIME_VALIDATION.tr();
                        // }
                        // return null;
                      },
                      maxLength: 10,
                      decoration: InputDecoration(
                          isDense: true,
                          counterText: "",
                          fillColor: AppColors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.r),
                              borderSide: BorderSide.none
                            //  const BorderSide(color: AppColors.greyBoxBorder),
                          ),
                          hintText: AssignScreenConstants.TASK_NAME.tr(),
                          hintStyle: AppTextStyle.font16.copyWith(
                            color: AppColors.greyColorFields,

                          )
                        //  TextStyle(
                        //   color: AppColors.greyColorFields,
                        //   fontSize: 16.sp,
                        //   fontWeight: FontWeight.w400,
                        // ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(AssignScreenConstants.START_TIME.tr(),
                    style: AppTextStyle.font13w6,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 1, // How wide the shadow should spread
                          blurRadius: 10, // The blur effect of the shadow
                          offset: const Offset(0,
                              5), // Shadow offset, with y-offset for bottom shadow
                        ),
                      ],
                    ),
                    child: TextFormField(
                      onTap: ()async{
                        TimeOfDay? pickedTime =  await showTime();
                         print(' someeeee $pickedTime');
                         startController.text = _formatTime(pickedTime!);
                         //" ${pickedTime!.hour}:${pickedTime.minute}";
                      },
                      keyboardType: TextInputType.none,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textAlign: TextAlign.start,
                      controller: startController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return  AssignScreenConstants.START_TIME_VALIDATION.tr();;
                        }

                        return null;
                      },
                      maxLength: 10,
                      decoration: InputDecoration(
                          isDense: true,
                          counterText: "",
                          fillColor: AppColors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.r),
                              borderSide: BorderSide.none
                            //  const BorderSide(color: AppColors.greyBoxBorder),
                          ),
                          hintText: AssignScreenConstants.TIME.tr(),

                          hintStyle: AppTextStyle.font16.copyWith(
                            color: AppColors.greyColorFields,

                          )
                        //  TextStyle(
                        //   color: AppColors.greyColorFields,
                        //   fontSize: 16.sp,
                        //   fontWeight: FontWeight.w400,
                        // ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(AssignScreenConstants.END_TIME.tr(),
                    style: AppTextStyle.font13w6,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 1, // How wide the shadow should spread
                          blurRadius: 10, // The blur effect of the shadow
                          offset: const Offset(0,
                              5), // Shadow offset, with y-offset for bottom shadow
                        ),
                      ],
                    ),
                    child: TextFormField(
                      onTap: ()async{
                        // showTime();
                        TimeOfDay? pickedTime =  await showTime();
                        print(' someeeee $pickedTime');
                        endController.text = _formatTime(pickedTime!);

                        //" ${pickedTime!.hour}:${pickedTime.minute}";
                      },
                      keyboardType:TextInputType.none,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textAlign: TextAlign.start,
                      controller: endController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AssignScreenConstants.END_TIME_VALIDATION.tr();
                        }
                        return null;
                      },
                      maxLength: 10,
                      decoration: InputDecoration(
                          isDense: true,
                          counterText: "",
                          fillColor: AppColors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.r),
                              borderSide: BorderSide.none
                            //  const BorderSide(color: AppColors.greyBoxBorder),
                          ),
                          hintText: AssignScreenConstants.TIME.tr(),

                          hintStyle: AppTextStyle.font16.copyWith(
                            color: AppColors.greyColorFields,

                          )
                        //  TextStyle(
                        //   color: AppColors.greyColorFields,
                        //   fontSize: 16.sp,
                        //   fontWeight: FontWeight.w400,
                        // ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),

                  InkWell(
                    onTap: (){
                       // Navigator.of(context).pop();
                       // Navigator.of(context).pop();
                           print(startController.text);
                           print(endController.text);
                            if(formKey.currentState!.validate()){
                              assignBloc.add(AssignTask(
                                  isAssing: true,
                                  facilityId: [widget.templateid!.toString()],
                                  janitorId: widget.id,
                                  startTime: startController.text,
                                  endTime: endController.text,
                                  status:  widget.status!

                              ));
                            }

                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color:  AppColors.buttonColor,
                        borderRadius: BorderRadius.circular(25.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.2), // Shadow color
                            spreadRadius:
                            1, // How wide the shadow should spread
                            blurRadius:
                            10, // The blur effect of the shadow
                            offset: const Offset(0,
                                0), // No offset for shadow on all sides
                          ),
                        ],
                      ),

                      child: Center(
                        child: Text(AssignScreenConstants.UPDATE_TASK.tr(),
                         style: AppTextStyle.font20bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
      //

    )
    ;



  }


    openDialog() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return  DialogueWidget(
            title: AssignScreenConstants.TASK_ASSIGN.tr(),
          );
        },
      );
    }


    String _formatTime(TimeOfDay time) {
      final now = DateTime.now();
      final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(
        DateTime(now.year, now.month, now.day, time.hour, time.minute),
      );
       print("format$formattedTime");
      return formattedTime;
    }

   showTime()async{
     TimeOfDay initialTime = TimeOfDay.now();
     return   await showTimePicker(
       context: context,
       initialTime: initialTime,
       // builder: (BuildContext context, Widget child) {
       //   return Directionality(
       //     // textDirection: TextDirection.LTR,
       //     child: child,
       //   );
       // },
     );
   }

}
