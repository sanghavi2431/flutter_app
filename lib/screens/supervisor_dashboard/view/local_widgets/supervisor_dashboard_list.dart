import 'package:Woloo_Smart_hygiene/core/local/global_storage.dart';
import 'package:Woloo_Smart_hygiene/screens/common_widgets/empty_list_widget.dart';
import 'package:Woloo_Smart_hygiene/screens/common_widgets/error_widget.dart';
import 'package:Woloo_Smart_hygiene/screens/janitor_screen/view/janitor_screen.dart';
import 'package:Woloo_Smart_hygiene/screens/supervisor_dashboard/bloc/supervisor_dashboard_bloc.dart';
import 'package:Woloo_Smart_hygiene/screens/supervisor_dashboard/bloc/supervisor_dashboard_event.dart';
import 'package:Woloo_Smart_hygiene/screens/supervisor_dashboard/bloc/supervisor_dashboard_state.dart';
import 'package:Woloo_Smart_hygiene/screens/supervisor_dashboard/model/Supervisor_model_dashboard.dart';
import 'package:Woloo_Smart_hygiene/utils/app_color.dart';
import 'package:Woloo_Smart_hygiene/utils/app_constants.dart';
import 'package:Woloo_Smart_hygiene/utils/app_textstyle.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../assign_screen/assign_screen.dart';
import '../../../common_widgets/swipe_button.dart';

class SupervisorDashboardListWidget extends StatefulWidget {
  final Function onTapItem;
  final String? status;
   final String? reqType;
   final  String? errorData;

  const SupervisorDashboardListWidget({
    
    super.key,
    required this.onTapItem,
    this.status,
    this.reqType,
   required this.errorData
  });

  @override
  State<SupervisorDashboardListWidget> createState() => _SupervisorDashboardListWidgetState();
}

class _SupervisorDashboardListWidgetState extends State<SupervisorDashboardListWidget> {
  // int selectedCard = -1;
  late SupervisorDashboardBloc _supervisorDashboardBloc;
  List<SupervisorModelDashboard> _data = [];
  GlobalStorage globalStorage = GetIt.instance();
  
  bool isApproved = false;
  bool isSelected = false;
  late int supervisorId;
   final CardSwiperController controller = CardSwiperController();
  //  final AppinioSwiperController controller = AppinioSwiperController();

  @override
  void initState() {

    _supervisorDashboardBloc = GetIt.instance<SupervisorDashboardBloc>();
    supervisorId = globalStorage.getId();
    _supervisorDashboardBloc.add(GetSupervisorDashboardData());
    // controller.setCardIndex(5);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     print(" khdjkfh ${MediaQuery.of(context).size}");
    return BlocConsumer(
      bloc: _supervisorDashboardBloc,
      listener: (context, state) {
        if (state is GetSupervisorDashboardDataSuccess) {
          EasyLoading.dismiss();
     
         
            print("GetSupervisorDashboardDataSuccess--->" + _data.toString());
         
        }
        if (state is SupervisorUpdateStatusSuccessful) {
          EasyLoading.dismiss();
          
          //  isApproved = true;
         
          print("SupervisorUpdateStatusSuccessful " + isApproved.toString());
        }

        // if (state is AssignTaskSuccessful) {
        //   EasyLoading.dismiss();
        //
        //   Navigator.pop(context);
        //   Navigator.pop(context);
        // }
      },
      builder: (context, state) {

           debugPrint("suepr visor list $state ");
        if (state is SupervisorDashboardLoading) {
          EasyLoading.show(status: MydashboardScreenConstants.LOADING_TOAST.tr());
        } else

        if (state is SupervisorDashboardError) {
          EasyLoading.dismiss();
          print("SupervisorDashboardError--->" + _data.toString());

          return CustomErrorWidget(error: state.error.message);
        } 
        else

        if (state is GetSupervisorDashboardDataSuccess  ) {

          EasyLoading.dismiss();
             _data = state.data.where( (e) { return e.status == widget.status && e.requestType == widget.reqType ; } ).toList();
         // print("GetSupervisorDashboardDataSuccess--->" + _data.toString());
         //     if(_data.length == 1){
         //       _data.add( SupervisorModelDashboard(
         //          blockName: "cz"
         //       ) );

             // }

          return
           _data.isEmpty ?
            EmptyListWidget(
            filter: widget.errorData,
           )
               : 
           RefreshIndicator(
          onRefresh: () {
            return Future.delayed(
              Duration(seconds: 1),
              () {
                _supervisorDashboardBloc.add(GetSupervisorDashboardData());
              },
            );
          },
          color: AppColors.buttonColor,
          child:
           Column(
             children: [
               Container(
                 // flex: 4,
                 // flex: 2,
                  height:

                  //201.h,
                  MediaQuery.of(context).size.height < 800 ?

                  MediaQuery.of(context).size.height /3.1
                 :


                  MediaQuery.of(context).size.height /3.3
                 ,
                 child: CardSwiper(
                   isLoop: false,
                   duration: const Duration(
                      milliseconds: 0
                   ),
                   numberOfCardsDisplayed:
                   _data.length == 1 ?
                   1 : 2
                   ,

                   // _data.length,
                   controller: controller,
                    cardsCount:
                    _data.length,
                   allowedSwipeDirection: const AllowedSwipeDirection.symmetric(
                     horizontal:true,
                   ),
// backgroundCardCount: _data.length,

                  // physics: AlwaysScrollableScrollPhysics(),
                  // itemCount: _data.length,
                  // scrollDirection: Axis.vertical,
                  // shrinkWrap: true,
                  cardBuilder: (
                    BuildContext context,
                    int index,
                    horizontalThresholdPercentage,
                    verticalThresholdPercentage,
                  ) {
                   // controller.setCardIndex(_data.length);
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 7.h,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          widget.onTapItem(_data[index], isApproved);

                          //  selectedCard = index;

                        },
                        child: _data[index].status == "Completed"
                            ? Container(
                                // height: 240.h,
                                padding: EdgeInsets.symmetric(
                                  vertical: 5.h,
                                  horizontal: 10.w,
                                ),
                                margin: const EdgeInsets.symmetric(
                                  // horizontal: 20.w,
                                ),
                                decoration: BoxDecoration(
                                   color: AppColors.completedBgColor,

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
                                  // color: AppColors.disabledContainerColor,
                                  borderRadius: BorderRadius.circular(25.r),
                                  // border: Border.all(
                                  //   color: AppColors.containerBorder,
                                  //   width: 1.w,
                                  // ),
                                  // boxShadow: const [
                                  //   BoxShadow(
                                  //     blurRadius: 5,
                                  //     spreadRadius: 1,
                                  //     offset: Offset(0, 1),
                                  //   ),
                                  // ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,


                                            children: [
                                              // Expanded(
                                              //   child: Padding(
                                              //     padding: EdgeInsets.symmetric(
                                              //       horizontal: 5.w,
                                              //       vertical: 1.h,
                                              //     ),
                                              //     child: Text(
                                              //         "${_data[index].blockName}",
                                              //         overflow:
                                              //         TextOverflow.visible,
                                              //         style: AppTextStyle
                                              //             .font12bold
                                              //             .copyWith(
                                              //           color: AppColors.black,
                                              //         )
                                              //       // TextStyle(
                                              //       //   color: AppColors.timeSlotColor,
                                              //       //   fontSize: 12.sp,
                                              //       //   fontWeight: FontWeight.w400,
                                              //       // ),
                                              //     ),
                                              //   ),
                                              // ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    // horizontal: 5.w,
                                                    vertical: 1.h,
                                                  ),
                                                  child: Text(
                                                      "${_data[index].facilityName}",
                                                      textAlign: TextAlign.left,
                                                      overflow:
                                                      TextOverflow.visible,
                                                      style: AppTextStyle
                                                          .font12bold
                                                          .copyWith(
                                                        color: AppColors.containerBorder,
                                                      )
                                                    // TextStyle(
                                                    //   color: AppColors.timeSlotColor,
                                                    //   fontSize: 12.sp,
                                                    //   fontWeight: FontWeight.w400,
                                                    // ),
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                                Expanded(
                                                child:
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 5.w,
                                                    vertical: 5.h,
                                                  ),
                                                  child:
                                                  Text(
                                                    _data[index].templateName ?? '',
                                                    maxLines: 1,
                                                    softWrap: false,
                                                    overflow: TextOverflow.ellipsis,
                                                    style:
                                                    AppTextStyle.font13w6.copyWith(
                                                      color: AppColors.containerBorder,
                                                    )
                                                    // TextStyle(
                                                    //   color: AppColors.containerBorder,
                                                    //   fontSize: 13.sp,
                                                    //   fontWeight: FontWeight.w600,
                                                    //   letterSpacing: 0.8,
                                                    // ),
                                                  ),
                                                ),
                                              ),


                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    // horizontal: 5.w,
                                                    vertical: 1.h,
                                                  ),
                                                  child: Text(
                                                      "${
                                                          _data[index]
                                                              .date!} \n${_data[index].startTime}-${_data[index].endTime}"
                                                     ,
                                                      overflow:
                                                      TextOverflow.visible,
                                                      textAlign: TextAlign.center,
                                                      style: AppTextStyle
                                                          .font10bold
                                                          .copyWith(
                                                        color:AppColors.containerBorder
                                                      )
                                                    // TextStyle(
                                                    //   color: AppColors.timeSlotColor,
                                                    //   fontSize: 12.sp,
                                                    //   fontWeight: FontWeight.w400,
                                                    // ),
                                                  ),
                                                ),
                                              ),

                                              // Padding(
                                              //   padding: EdgeInsets.symmetric(
                                              //     // horizontal: 5.w,
                                              //     vertical: 1.h,
                                              //   ),
                                              //   child: Text(
                                              //     _data[index].date ?? '',
                                              //     style:
                                              //     AppTextStyle.font10bold.copyWith(
                                              //       color: AppColors.containerBorder,
                                              //     )
                                              //     // TextStyle(
                                              //     //   color: AppColors.containerBorder,
                                              //     //   fontSize: 12.sp,
                                              //     //   fontWeight: FontWeight.w400,
                                              //     // ),
                                              //   ),
                                              // ),
                                              //
                                              // Padding(
                                              //   padding: EdgeInsets.symmetric(
                                              //     horizontal: 5.w,
                                              //     vertical: 1.h,
                                              //   ),
                                              //   child: Text(
                                              //     "${_data[index].startTime} - ${_data[index].endTime}" ?? '',
                                              //     style:
                                              //       AppTextStyle.font10bold.copyWith(
                                              //       color: AppColors.containerBorder,
                                              //     )
                                              //     // TextStyle(
                                              //     //   color: AppColors.containerBorder,
                                              //     //   fontSize: 12.sp,
                                              //     //   fontWeight: FontWeight.w400,
                                              //     // ),
                                              //   ),
                                             // ),
                                            ],
                                          ),


                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 5.w,
                                              vertical: 1.h,
                                            ),
                                            child: Text(
                                              "${MydashboardScreenConstants.DESCRIPTION.tr()} : ${_data[index].description ?? ''}",
                                              maxLines: 2,
                                              style:
                                                 AppTextStyle.font13w6.copyWith(
                                                      color: AppColors.containerBorder,
                                                    )
                                              //  TextStyle(
                                              //   color: AppColors.containerBorder,
                                              //   fontSize: 12.sp,
                                              //   fontWeight: FontWeight.w500,
                                              // ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 5.w,
                                              vertical: 2.h,
                                            ),
                                            child: Text(
                                              "${MydashboardScreenConstants.DESCRIPTION.tr()} : ${_data[index].location ?? ''}",
                                              style:
                                                  AppTextStyle.font13w6.copyWith(
                                                      color: AppColors.containerBorder,
                                                    )
                                              // TextStyle(
                                              //   color: AppColors.containerBorder,
                                              //   fontSize: 12.sp,
                                              //   fontWeight: FontWeight.w400,
                                              // ),
                                            ),
                                          ),

                                          SizedBox(
                                            height: 10.h,
                                          ),



                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.person, color: AppColors.black, size: 15.sp, weight: 0.5),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 5.w,
                                                      vertical: 2.h,
                                                    ),
                                                    child: Text(
                                                      _data[index].janitorName ?? '',
                                                      style:
                                                         AppTextStyle.font12.copyWith(
                                                      color: AppColors.containerBorder,
                                                    )
                                                      //  TextStyle(
                                                      //   color: AppColors.containerBorder,
                                                      //   fontSize: 12.sp,
                                                      //   fontWeight: FontWeight.w400,
                                                      // ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ))
                            : Container(
                                // height: 240.h,
                                padding: EdgeInsets.symmetric(
                                  vertical: 5.h,
                                  horizontal: 10.w,
                                ),
                                margin: const EdgeInsets.symmetric(
                                  // horizontal: 20.w,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                    _data[index].status ==
                                                      "Pending"
                                                  ?
                                                  //
                                                  AppColors.pendingCardBgColor
                                                  :_data[index].status == "Ongoing"
                                                      ? Color.fromARGB(255, 232, 239, 132)
                                                      :_data[index].status ==
                                                              "Accepted"
                                                          ? AppColors.acceptedBgColor
                                        //.withOpacity(0.7)
                                                             /// .withOpacity(0.8)
                                                          :_data[index].status ==
                                                                  "Request for closure"
                                                              ? AppColors.rfcCardBgColor
                                      //  .withOpacity(0.7)
                                                              : AppColors
                                                                  .checkOutColor,
                                                                  // .withOpacity(0.3),

                                  // AppColors.white,
                                  borderRadius: BorderRadius.circular(25.r),
                                   boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.15), // Shadow color
                                                  spreadRadius:
                                                      1, // How wide the shadow should spread
                                                  blurRadius:
                                                      10, // The blur effect of the shadow
                                                  offset: const Offset(0,
                                                      0), // No offset for shadow on all sides
                                                ),
                                              ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                // mainAxisAlignment:  MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,


                                            children: [
                                              // Expanded(
                                              //   child: Padding(
                                              //     padding: EdgeInsets.symmetric(
                                              //       horizontal: 5.w,
                                              //       vertical: 1.h,
                                              //     ),
                                              //     child: Text(
                                              //         "${_data[index].blockName}",
                                              //         overflow:
                                              //         TextOverflow.visible,
                                              //         style: AppTextStyle
                                              //             .font12bold
                                              //             .copyWith(
                                              //           color: AppColors.black,
                                              //         )
                                              //       // TextStyle(
                                              //       //   color: AppColors.timeSlotColor,
                                              //       //   fontSize: 12.sp,
                                              //       //   fontWeight: FontWeight.w400,
                                              //       // ),
                                              //     ),
                                              //   ),
                                              // ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    // horizontal: 5.w,
                                                    vertical: 1.h,
                                                  ),
                                                  child: Text(
                                                      "${_data[index].facilityName}",
                                                      textAlign: TextAlign.left,
                                                      overflow:
                                                      TextOverflow.visible,
                                                      style: AppTextStyle
                                                          .font12bold
                                                          .copyWith(
                                                        color:
                                                         _data[index].status == "Rejected" ?
                                                        AppColors.white :
                                                        AppColors.ListTitleColor,

                                                      )
                                                    // TextStyle(
                                                    //   color: AppColors.timeSlotColor,
                                                    //   fontSize: 12.sp,
                                                    //   fontWeight: FontWeight.w400,
                                                    // ),
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                                 Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 5.w,
                                                    vertical: 0.h,
                                                  ),
                                                  child:
                                                  Text(
                                                    "${_data[index].templateName}" ?? '',
                                                    // maxLines: 1,
                                                    // softWrap: false,
                                                    overflow: TextOverflow.visible,
                                                    style: AppTextStyle.font12bold.copyWith(
                                                      color:
                                                      _data[index].status == "Rejected" ?
                                                      AppColors.white :
                                                      AppColors.ListTitleColor,


                                                    )
                                                    // TextStyle(
                                                    //   color: AppColors.ListTitleColor,
                                                    //   fontSize: 13.sp,
                                                    //   fontWeight: FontWeight.w600,
                                                    //   letterSpacing: 0.8,
                                                    // ),
                                                  ),
                                                ),
                                              ),

                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    // horizontal: 5.w,
                                                    vertical: 1.h,
                                                  ),
                                                  child: Text(
                                                      "${
                                                          _data[index]
                                                              .date!} \n${_data[index].startTime}-${_data[index].endTime}"
                                                      ,
                                                      overflow:
                                                      TextOverflow.visible,
                                                      textAlign: TextAlign.center,
                                                      style: AppTextStyle
                                                          .font10bold
                                                          .copyWith(
                                                       color:  _data[index].status == "Rejected" ?
                                                          AppColors.white :
                                                          AppColors.ListTitleColor,
                                                      )
                                                    // TextStyle(
                                                    //   color: AppColors.timeSlotColor,
                                                    //   fontSize: 12.sp,
                                                    //   fontWeight: FontWeight.w400,
                                                    // ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                            const Divider(
                                                  color: AppColors.deviderColor,
                                                ),

                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 5.w,
                                              vertical: 1.h,
                                            ),
                                            child: Text(
                                              "${MydashboardScreenConstants.DESCRIPTION.tr()} : ${_data[index].description ?? ''}",
                                              maxLines: 2,
                                              style:
                                                AppTextStyle.font13w6.copyWith(
                                                      color:
                                                      _data[index].status == "Rejected" ?
                                                      AppColors.white :
                                                      AppColors.ListTitleColor,
                                                    )
                                              // TextStyle(
                                              //   color: AppColors.ListTitleColor,
                                              //   fontSize: 12.sp,
                                              //   fontWeight: FontWeight.w500,
                                              // ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 5.w,
                                              vertical: 2.h,
                                            ),
                                            child: Text(
                                              "${MydashboardScreenConstants.LOCATION.tr()} : ${_data[index].location ?? ''}",
                                              style:
                                              AppTextStyle.font13w6.copyWith(
                                                color:
                                                _data[index].status == "Rejected" ?
                                                AppColors.white :

                                                AppColors.ListTitleColor,
                                              )
                                              // TextStyle(
                                              //   color: AppColors.ListTitleColor,
                                              //   fontSize: 12.sp,
                                              //   fontWeight: FontWeight.w400,
                                              // ),
                                            ),
                                          ),
                                          // Padding(
                                          //   padding: EdgeInsets.symmetric(
                                          //     horizontal: 5.w,
                                          //     vertical: 2.h,
                                          //   ),
                                          //   child: Text(
                                          //     "${MydashboardScreenConstants.BOOTHS.tr()}  :${_data[index].booths ?? ''}",
                                          //     style:
                                          //      AppTextStyle.font12.copyWith(
                                          //       color: AppColors.ListTitleColor,
                                          //     )
                                          //     // TextStyle(
                                          //     //   color: AppColors.ListTitleColor,
                                          //     //   fontSize: 12.sp,
                                          //     //   fontWeight: FontWeight.w400,
                                          //     // ),
                                          //   ),
                                          // ),
                                          // Padding(
                                          //   padding: EdgeInsets.symmetric(
                                          //     horizontal: 5.w,
                                          //     vertical: 2.h,
                                          //   ),
                                          //   child: Text(
                                          //       "${MydashboardScreenConstants.FACILITY.tr()} : ${_data[index].facilityName ?? ''}",
                                          //       style:
                                          //       AppTextStyle.font12.copyWith(
                                          //         color: AppColors.ListTitleColor,
                                          //       )
                                          //     // TextStyle(
                                          //     //   color: AppColors.ListTitleColor,
                                          //     //   fontSize: 12.sp,
                                          //     //   fontWeight: FontWeight.w400,
                                          //     // ),
                                          //   ),
                                          // ),
                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.start,
                                          //   crossAxisAlignment: CrossAxisAlignment.center,
                                          //   children: [
                                          //     Padding(
                                          //       padding: EdgeInsets.symmetric(
                                          //         horizontal: 5.w,
                                          //         vertical: 2.h,
                                          //       ),
                                          //       child: Text(
                                          //         "${MydashboardScreenConstants.TOTAL_TASK.tr()}  : ${_data[index].totalTasks ?? ''}",
                                          //         style:
                                          //         AppTextStyle.font14w6.copyWith(
                                          //           color: AppColors.greenTextColor,
                                          //         )
                                          //         // TextStyle(
                                          //         //   color: AppColors.greenTextColor,
                                          //         //   fontSize: 14.sp,
                                          //         //   fontWeight: FontWeight.w600,
                                          //         // ),
                                          //       ),
                                          //     ),
                                          //     Padding(
                                          //       padding: EdgeInsets.symmetric(
                                          //         horizontal: 5.w,
                                          //         vertical: 2.h,
                                          //       ),
                                          //       child: Text(
                                          //         "${MydashboardScreenConstants.PENDING_TASK.tr()}  : ${_data[index].pendingTasks ?? ''}",
                                          //         style:
                                          //          AppTextStyle.font14w6.copyWith(
                                          //          color: AppColors.redTextColor,
                                          //         )
                                          //         // TextStyle(
                                          //         //   color: AppColors.redTextColor,
                                          //         //   fontSize: 14.sp,
                                          //         //   fontWeight: FontWeight.w600,
                                          //         // ),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.person, color:
                                                  _data[index].status == "Rejected" ?
                                                  AppColors.white :
                                                  AppColors.black, size: 15.sp, weight: 0.5),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 5.w,
                                                      vertical: 0.h,
                                                    ),
                                                    child: Text(
                                                      _data[index].janitorName ?? '',
                                                      style:
                                                        AppTextStyle.font12bold.copyWith(
                                                      color:
                                                      _data[index].status == "Rejected" ?
                                                         AppColors.white

                                                          :
                                                      AppColors.janitorNameColor,)
                                                      // TextStyle(
                                                      //   color: AppColors.janitorNameColor,
                                                      //   fontSize: 12.sp,
                                                      //   fontWeight: FontWeight.w400,
                                                      // ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (_data[index].status == "Request for closure")
                                                InkWell(
                                                  onTap: () {
                                                    _supervisorDashboardBloc.add(SupervisorUpdateStatus(id: _data[index].taskAllocationId.toString() ?? '', status: 4));
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(8.r),
                                                        color: AppColors.buttonColor,
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: 10.w,
                                                          vertical: 6.h,
                                                        ),
                                                        child: Text(
                                                          MyTaskDetailsScreenConstants.APPROVE_BUTTON.tr(),
                                                          textAlign: TextAlign.center,
                                                          style:AppTextStyle.font10w6.copyWith(
                                                                color: AppColors.black,)
                                                          //  TextStyle(
                                                          //   fontSize: 10.sp,
                                                          //   fontWeight: FontWeight.w600,
                                                          //   color: AppColors.black,
                                                          // ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                  if ( _data[index].status == "Pending" && _data[index].requestType == "Regular" )
                                                InkWell(
                                                  onTap: () async {
                                                    await Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>  AssignScreen(
                                                          id: _data[index].taskAllocationId,
                                                          taskName: _data[index].templateName,
                                                          status: _data[index].status,
                                                          // isFromCluster: false,
                                                          // isFromDashboard: false,
                                                          // allocationId: [_data[index].taskAllocationId.toString()],
                                                          // isFromDashboardAssignment: true,
                                                        ),
                                                      ),
                                                    );
                                                   // _supervisorDashboardBloc.add(const GetSupervisorDashboardData());
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(8.r),
                                                        color: AppColors.buttonColor,
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: 10.w,
                                                          vertical: 6.h,
                                                        ),
                                                        child: Text(
                                                          MyFacilityListConstants.ASSIGN.tr(),
                                                          textAlign: TextAlign.center,
                                                          style: AppTextStyle.font10w6.copyWith(
                                                                color: AppColors.black, )
                                                          // TextStyle(
                                                          //   fontSize: 10.sp,
                                                          //   fontWeight: FontWeight.w600,
                                                          //   color: AppColors.black,
                                                          // ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              if ( _data[index].status == "Rejected" ||   _data[index].status == "Pending" && _data[index].requestType == "IOT" && _data[index].janitorId == null || _data[index].status == "Pending" && _data[index].requestType == "Regular" && _data[index].janitorId == null)
                                                InkWell(
                                                  onTap: () async {
                                                    await Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>  AssignScreen(
                                                          id: _data[index].taskAllocationId,
                                                          taskName: _data[index].templateName,
                                                          status: _data[index].status,
                                                          // isFromCluster: false,
                                                          // isFromDashboard: false,
                                                          // allocationId: [_data[index].taskAllocationId.toString()],
                                                          // isFromDashboardAssignment: true,
                                                        ),
                                                      ),
                                                    );
                                                    // await Navigator.of(context).push(
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) => JanitorList(
                                                    //       rejected: _data[index].status == "Rejected" ? true : false ,
                                                    //       isFromCluster: false,
                                                    //       isFromDashboard: false,
                                                    //       allocationId: [_data[index].taskAllocationId.toString()],
                                                    //       isFromDashboardAssignment: true,
                                                    //     ),
                                                    //   ),
                                                    // );
                                                    _supervisorDashboardBloc.add(const GetSupervisorDashboardData());
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(8.r),
                                                        color: AppColors.buttonColor,
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: 10.w,
                                                          vertical: 6.h,
                                                        ),
                                                        child: Text(
                                                          MyFacilityListConstants.ASSIGN.tr(),
                                                          textAlign: TextAlign.center,
                                                          style: AppTextStyle.font10w6.copyWith(
                                                                color: AppColors.black, )
                                                          // TextStyle(
                                                          //   fontSize: 10.sp,
                                                          //   fontWeight: FontWeight.w600,
                                                          //   color: AppColors.black,
                                                          // ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                            ],
                                          ),


                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    );
                  },
                           ),
               ),
                 SizedBox(height: 30.h, ),
                 Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(right: 16 ),
                        child: swipeRightButton(controller,_data.length),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16 ),
                        child: swipeLeftButton(controller,_data.length),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16 ),
                        child: unswipeButton(controller),
                      ),
                    ],
                  ),
             ],
           ),
        );
          //const EmptyListWidget();
        }
        else
        if (state is SupervisorUpdateStatusLoading) {
          EasyLoading.show(status: MydashboardScreenConstants.LOADING_TOAST.tr());
        }
        else
           if (state is SupervisorUpdateStatusSuccessful) {
          EasyLoading.dismiss();
       
            isApproved = true;
        
          print("SupervisorUpdateStatusSuccessful " + isApproved.toString());
        }
        else
        if (state is SupervisorUpdateStatusError) {
          EasyLoading.dismiss();

          return CustomErrorWidget(error: state.error.message);
        }
        // if (state is AssignTaskLoading) {
        //   EasyLoading.show(status: __MydashboardScreenConstants.LOADING_TOAST.tr());
        // }
        //
        // if (state is AssignTaskError) {
        //   EasyLoading.dismiss();
        //   return CustomErrorWidget(error: state.error);
        // }

        return SizedBox();
        
      },
    );
  }

  Color getColorByStatus(String status) {
    switch (status) {
      case "Request for closure":
        return AppColors.yellowTextColor;
      case "Completed":
        return AppColors.greenTextColor;
      case "Pending":
        return AppColors.pendingStatusColor;
      default:
        return Colors.black;
    }
  }

  Color getColorByRequestType(String requestType) {
    switch (requestType) {
      case "IOT":
        return AppColors.iotBackgroundColor;
      case "Regular":
        return AppColors.regularButtonColor;
      case "Issue":
        return AppColors.issueButtonColor;
      case "Customer Request":
        return AppColors.acceptButtonColor;
      default:
        return AppColors.white;
    }
  }
}
