import 'package:Woloo_Smart_hygiene/screens/common_widgets/leading_button.dart';
import 'package:Woloo_Smart_hygiene/screens/janitor_details_screen/view/sup_jani_attendance_screen.dart';
import 'package:Woloo_Smart_hygiene/utils/app_textstyle.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Woloo_Smart_hygiene/utils/app_color.dart';
import 'package:Woloo_Smart_hygiene/utils/app_constants.dart';
import 'package:Woloo_Smart_hygiene/utils/app_images.dart';

import '../../common_widgets/error_widget.dart';
import '../../common_widgets/image_provider.dart';
import '../../janitor_screen/bloc/janitor_list_bloc.dart';
import '../../janitor_screen/bloc/janitor_list_event.dart';
import '../../janitor_screen/bloc/janitor_list_state.dart';
import '../../janitor_screen/data/model/Janitor_list_model.dart';
import 'chart.dart';

class JanitorDetails extends StatefulWidget {
  final String id;
  final String shift;
  final String name;
  final String mobile;
  final String check_in_time;
  final String check_out_time;
  final String complete_task;
  final String pending_task;
  final String total_task;
  final String profile;
  final String baseUrl;
  final String clusterId;
  final bool isPresent;
  final String? accetedTask;
  final String? rejectedTask;
  final String? rfcTask;
  final String? ongoingTask;

  const JanitorDetails({
    super.key,
    required this.id,
    required this.shift,
    required this.name,
    required this.mobile,
    required this.check_in_time,
    required this.check_out_time,
    required this.complete_task,
    required this.pending_task,
    required this.total_task,
    required this.isPresent,
    required this.profile,
    required this.clusterId,
    required this.baseUrl,
    required this.rfcTask,
    required this.rejectedTask,
    required this.ongoingTask,
    required this.accetedTask
  });

  @override
  State<JanitorDetails> createState() => _JanitorDetailsState();
}

class _JanitorDetailsState extends State<JanitorDetails> {
   List chipLabels = ['Today', '7 days', 'Custom'];
   JanitorListBloc _janitorListBloc = JanitorListBloc();
    int? _selectedChipIndex;
   List<JanitorListModel> janitorData = [];


     @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedChipIndex = 0;
    if( _selectedChipIndex ==0 ){
      var startdate =    DateTime.now();
      var endDate =  DateTime.now();

      var startdayformat =    DateFormat('yyyy-MM-dd').format(startdate);
      var enddayformat =    DateFormat('yyyy-MM-dd').format(endDate);
      _janitorListBloc.add(GetAllJanitors(
        endDate: enddayformat,
        startDate: startdayformat,
        cluster_id: widget.clusterId ?? "0",
      ));

    }
    // _janitorListBloc = BlocProvider.of<JanitorListBloc>(
    //       context,
    //     );
  }

  @override
  Widget build(BuildContext context) {
    // widget.
    return Scaffold(
      backgroundColor: AppColors.white,
      
      appBar: AppBar(
        leadingWidth: 100,
        leading:LeadingButton(),
        
        //  IconButton(
        //   icon: const Icon(
        //     Icons.arrow_back,
        //     color: Colors.white,
        //     size: 30,
        //   ),
        //   color: AppColors.appBarIconColor,
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        // title: Padding(
        //   padding: EdgeInsets.symmetric(
        //     horizontal: 15.w,
        //     vertical: 10.h,
        //   ),
        //   child: Text(
        //     MyJanitorsDetailsScreenConstants.APP_BAR.tr(),
        //     textAlign: TextAlign.start,
        //     style:
        //     AppTextStyle.font24.copyWith(
        //       color: AppColors.yellowSplashColor, 
        //     )
        //     // TextStyle(
        //     //   color: AppColors.yellowSplashColor,
        //     //   fontSize: 24.sp,
        //     //   fontWeight: FontWeight.w400,
        //     // ),
        //   ),
        // ),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric( horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Padding(
                             padding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                  vertical: 10.h,
                             ),
                             child: Text(
                  MyJanitorsDetailsScreenConstants.APP_BAR.tr(),
                  textAlign: TextAlign.start,
                  style:
                  AppTextStyle.font24bold.copyWith(
                    color: AppColors.black,
                  )

                  
                  // TextStyle(
                  //   color: AppColors.yellowSplashColor,
                  //   fontSize: 24.sp,
                  //   fontWeight: FontWeight.w400,
                  // ),
                             ),
                           ),
                InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SupJaniAttendanceScreen(
                                  janiId: int.parse(widget.id)),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.history),
                            Text(
                              MyJanitorProfileScreenConstants.HISTORY.tr(),
                              style:
                              AppTextStyle.font12.copyWith(
                                    // color: AppColors.redText,
                                  )
                              // TextStyle(
                              //   fontSize: 12.sp,
                              //   fontWeight: FontWeight.w400,
                              // ),
                            )
                          ],
                        ),
                      ),


               ],
             ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 15.h,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.darkGreyColor,
                        // height: 40.h,
                        // width: 40.w,
                        // decoration: const BoxDecoration(
                        //     shape: BoxShape.circle,
                        //     color: AppColors.darkGreyColor),
                        child:
                        widget.profile.isNotEmpty ?
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CustomImageProvider(
                            image:"${widget.baseUrl}/${widget.profile!.replaceAll("[", "").replaceAll("]", "").replaceAll('"', '')}",
                          ),
                        )
                            :
                        const Icon(
                          Icons.person_2_outlined,
                          size: 50,

                          color: AppColors.buttonColor,
                        ),
                      ),
                      // Container(
                      //   height: 100.h,
                      //   width: 100.w,
                      //   decoration: const BoxDecoration(
                      //       shape: BoxShape.circle, color: AppColors.darkGreyColor),
                      //   child: const Icon(
                      //     Icons.person_2_outlined,
                      //     color: AppColors.buttonColor,
                      //     size: 60,
                      //   ),
                      // ),
                   //   SizedBox(width: 10.w),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                            AppTextStyle.font24bold.copyWith(
                                color: AppColors.black,
                            )
                            //  TextStyle(
                            //   color: AppColors.black,
                            //   fontSize: 18.sp,
                            //   fontWeight: FontWeight.w400,
                            // ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            "Mob :" +
                            widget.mobile,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                            AppTextStyle.font16.copyWith(
                              color: Colors.black,
                            )
                            //  TextStyle(
                            //   color: Colors.grey,
                            //   fontSize: 14.sp,
                            //   fontWeight: FontWeight.w400,
                            // ),
                          ),
                        ],
                      ),
                      // widget.isPresent == true
                      //     ? Column(
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: [
                      //           CustomImageProvider(
                      //             image: AppImages.janitor_present,
                      //             height: 20.h,
                      //             width: 20.w,
                      //           ),
                      //           Text(
                      //             MyJanitorsListScreenConstants.JANITOR_PRESENT,
                      //             style:
                      //             AppTextStyle.font12.copyWith(
                      //               color: AppColors.greenText,
                      //             )
                      //             //  TextStyle(
                      //             //     color: AppColors.greenText,
                      //             //     fontSize: 12.sp,
                      //             //     fontWeight: FontWeight.w400),
                      //           )
                      //         ],
                      //       )
                      //     : Column(
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: [
                      //           CustomImageProvider(
                      //             image: AppImages.janitor_absent,
                      //             height: 20.h,
                      //             width: 20.w,
                      //           ),
                      //           Text(
                      //             MyJanitorsListScreenConstants.JANITOR_ABSENT.tr(),
                      //             style:AppTextStyle.font12.copyWith(
                      //               color: AppColors.redText,
                      //             )
                      //             // TextStyle(
                      //             //     color: AppColors.redText,
                      //             //     fontSize: 12.sp,
                      //             //     fontWeight: FontWeight.w400),
                      //           )
                      //         ],
                      //       ),
                    //  SizedBox(width: 20.w),
                 
                    ],
                  ),
                ),
              ),
              Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Center(
              child: Container(
              height: 1.h,
              width: 260.w,
              color: AppColors.dividerColor,
              ),
              ),
              ),
              SizedBox(
                height: 10.h,
              ),

              Container(
                height: 90.h,
                decoration: BoxDecoration(
                  color: Color(0xff7AE9F9),
                  borderRadius: BorderRadius.circular(25.r)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    CustomImageProvider( image: "assets/sunny 1.png",
                    width: 70,
                    height: 70,
                    ),
                   SizedBox(
                    width: 10.w,
                   ),
                    Text(
                        widget.shift,
                        style:
                        AppTextStyle.font24bold.copyWith(
                          color: AppColors.black,
                        )
                      // TextStyle(
                      //   color: AppColors.black,
                      //   fontSize: 20.sp,
                      //   fontWeight: FontWeight.w400,
                      // ),
                    ),
                     SizedBox(
                       width: 10.w,
                     ),

                    Text(
                        MyJanitorsDetailsScreenConstants.SHIFT.tr(),
                        style:
                        AppTextStyle.font24bold.copyWith(
                          color: AppColors.black,
                        )
                      //  TextStyle(
                      //   color: AppColors.greyTextColor,
                      //   fontSize: 18.sp,
                      //   fontWeight: FontWeight.w400,
                      // ),
                    ),


                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Flexible(
                    flex: 4,
                    child: Container(
                      // width: MediaQuery.of(context).size.width/1.8,
                      decoration: BoxDecoration(
                        color: Color(0xff76E16D),
                        borderRadius: BorderRadius.circular(25.r)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric( horizontal: 18 ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 8.h,
                            ),

                            Text(
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.visible,
                                "${MyJanitorsDetailsScreenConstants.CHECK_IN.tr()}",
                                style:
                                AppTextStyle.font20bold.copyWith(
                                  color: AppColors.black,
                                )
                              //  TextStyle(
                              //   color: AppColors.greyTextColor,
                              //   fontSize: 18.sp,
                              //   fontWeight: FontWeight.w400,
                              // ),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            widget.check_in_time == "Invalid date" ?
                            Center(
                              child: Text(
                                  "_",
                                  style:
                                  AppTextStyle.font20bold.copyWith(
                                    color: AppColors.black,
                                  )),
                            )
                                :
                            Text(
                                widget.check_in_time.split(",").last,
                                style:
                                AppTextStyle.font20bold.copyWith(
                                  color: AppColors.black,
                                )
                              // TextStyle(
                              //   color: AppColors.black,
                              //   fontSize: 20.sp,
                              //   fontWeight: FontWeight.w400,
                              // ),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                   // Spacer(),
                  // Flexible(
                  //   flex: 1,
                  //   child:
                  //  Spacer(),
                    // width: 19.w,
                  // ),


                  Flexible(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffE9AAAA),
                          borderRadius: BorderRadius.circular(25.r)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric( horizontal: 10 ),
                        child: Column(
                    
                          children: [
                            SizedBox(
                              height: 8.h,
                            ),
                            Text(
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.center,
                                "${MyJanitorsDetailsScreenConstants.CHECK_OUT.tr()}",
                                style:
                                AppTextStyle.font20bold.copyWith(
                                  color: AppColors.black,
                                )
                              //  TextStyle(
                              //   color: AppColors.greyTextColor,
                              //   fontSize: 18.sp,
                              //   fontWeight: FontWeight.w400,
                              // ),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            widget.check_in_time == "Invalid date" ?
                            Center(
                              child: Text(
                                  "_",
                                  style:
                                  AppTextStyle.font20bold.copyWith(
                                    color: AppColors.black,
                                  )),
                            )
                                :
                            Text(
                                widget.check_out_time.split(",").last,
                              textAlign: TextAlign.center,
                                style:
                                AppTextStyle.font20bold.copyWith(
                                  color: AppColors.black,
                                )
                              //  TextStyle(
                              //   color: AppColors.black,
                              //   fontSize: 20.sp,
                              //   fontWeight: FontWeight.w400,
                              // ),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )

                ],
              ),
             SizedBox(
               height: 12.h,
             ),
             //_buildSingleDatePickerWithValue(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                // flex: 6,
                child: Align(
                  alignment: Alignment.center,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: chipLabels.length,
                    itemBuilder: (BuildContext context, int index) {
                      return
                        InkWell(
                          onTap: ()async{

                              print("ddd");
                              // var results = await showCalendarDatePicker2Dialog(
                              //   context: context,
                              //   config: CalendarDatePicker2WithActionButtonsConfig(),
                              //   dialogSize: const Size(325, 400),
                              //   value: _rangeDatePickerValueWithDefaultValue,
                              //   borderRadius: BorderRadius.circular(15),
                              // );
                          },
                          child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10 ),
                          child: ChoiceChip(
                            elevation: 10,
                            // shape: Border.symmetric(),
                            // avatarBorder: Border.alls(),

                            label: Text(chipLabels[index],
                             style: AppTextStyle.font12bold,
                            ),
                            selected: _selectedChipIndex == index,
                            selectedColor: AppColors.buttonBgColor,
                            // color: AppColors.buttonBgColor,
                            onSelected: (bool selected) async {







                             //  print("janitr$format");
                              setState(()   {

                                _selectedChipIndex = selected ? index : null;








                              });


                              if( _selectedChipIndex ==0 ){
                                var startdate =    DateTime.now();
                                var endDate =  DateTime.now();

                                var startdayformat =    DateFormat('yyyy-MM-dd').format(startdate);
                                var enddayformat =    DateFormat('yyyy-MM-dd').format(endDate);
                                _janitorListBloc.add(GetAllJanitors(
                                  endDate: enddayformat,
                                  startDate: startdayformat,
                                  cluster_id: widget.clusterId ?? "0",
                                ));

                              }else

                              if(_selectedChipIndex == 1){
                                var startdate =    DateTime.now().subtract( Duration( days: 7) );
                                var endDate =  DateTime.now();

                                var startdayformat =    DateFormat('yyyy-MM-dd').format(startdate);
                                var enddayformat =    DateFormat('yyyy-MM-dd').format(endDate);
                                _janitorListBloc.add(GetAllJanitors(
                                  endDate: enddayformat,
                                  startDate: startdayformat,
                                  cluster_id: widget.clusterId ?? "0",
                                ));
                              }
                             else

                               if(_selectedChipIndex == 2){

                                 var results = await showCalendarDatePicker2Dialog(
                                   context: context,

                                   config: CalendarDatePicker2WithActionButtonsConfig(
                                       calendarType: CalendarDatePicker2Type.range,
                                       lastDate: DateTime.now(),
                                       disabledDayTextStyle:


                                       TextStyle(
                                           color: AppColors.greyBorder
                                       )


                                   ),
                                   dialogSize: const Size(325, 400),
                                   // builder: (context, child) {
                                   //    return child;
                                   // },
                                   value: _singleDatePickerValueWithDefaultValue,
                                   borderRadius: BorderRadius.circular(15),

                                 // )

                                 ) ;

                                  print(" resuel ${results![1]}");
                                 var startdayformat =    DateFormat('yyyy-MM-dd').format(results!.first!);
                                 var enddayformat =    DateFormat('yyyy-MM-dd').format(results[1]!);
                                 _janitorListBloc.add(GetAllJanitors(
                                   endDate: enddayformat,
                                   startDate: startdayformat,
                                   cluster_id: widget.clusterId ?? "0",
                                 ));
                               }

                            },
                          ),
                                                ),
                        );
                    },
                  ),
                ),
              ),
             

             //  Container(
             //    decoration: BoxDecoration(
             //
             //    ),
             //    child: Row(
             //      mainAxisAlignment: MainAxisAlignment.spaceBetween,
             //      children: [
             //
             //         Text("Today"),
             //         Text("7 Days"),
             //        Text("Custom"),
             //      ],
             //    ),
             //  ),
            //  _buildRangeDatePickerWithValue(),
              BlocBuilder(
                bloc: _janitorListBloc,
                builder: (context, state ) {
    if (state is JanitorListLoading) {
    EasyLoading.show(
    status: MydashboardScreenConstants.LOADING_TOAST.tr());
    return const SizedBox();
    } else if (state is JanitorListError) {
      return CustomErrorWidget(error: state.error.message);
    }
     else if ( state is JanitorListSuccess ){
        EasyLoading.dismiss();
      janitorData  =   state.data;
        print("date ${widget.id}");

     var   temp = janitorData.where((e) =>  e.id == widget.id).toList();

        janitorData = temp;

        // print("janitors data $janitorData");

            //  widget.id
    }
    EasyLoading.dismiss();
                  return
                   janitorData.isNotEmpty ?
                    Chart(
                      complatedTask: janitorData.first.completedTaskCount,
                      pendingTask:  janitorData.first.pendingTaskCount,
                      totalTask:  janitorData.first.totalTaskCount,
                      accetedTask: janitorData.first.acceptedTaskCount,
                      ongoingTask: janitorData.first.onGoingTaskCount,
                      rejectedTask: janitorData.first.rejectsTaskCount,
                      rfcTask: janitorData.first.rfcTaskCount,
                    )
                        :

                    Chart(
                    complatedTask: widget.complete_task,
                    pendingTask: widget.pending_task,
                    totalTask: widget.total_task,
                      accetedTask: widget.accetedTask,
                      ongoingTask:widget.ongoingTask,
                      rejectedTask:widget.rejectedTask,
                      rfcTask: widget.rfcTask,
                  );
                }
              ),

            ],
          ),
        ),
      ),
    );
  }

 List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now()
  ];



}


// import 'package:fl_chart_app/presentation/resources/app_resources.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:fl_chart_app/presentation/widgets/indicator.dart';
// import 'package:flutter/material.dart';
