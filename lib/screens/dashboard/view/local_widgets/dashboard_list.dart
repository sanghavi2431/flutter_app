import 'dart:async';

import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/empty_list_widget.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/map_utils.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/swipe_button.dart';
import 'package:woloo_smart_hygiene/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:woloo_smart_hygiene/screens/dashboard/bloc/dashboard_event.dart';
import 'package:woloo_smart_hygiene/screens/dashboard/data/model/dashboard_model_class.dart';
import 'package:woloo_smart_hygiene/screens/selfie_screen/view/selfie_screen.dart';
import 'package:woloo_smart_hygiene/screens/washroom_image_screen/view/task_completion_screen.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
// import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../utils/app_images.dart';

class DashboardListWidget extends StatefulWidget {
 final TabController? tabController;
  final Function onTapItem;
  final String? currentLattitude;
  final String? currentLongitude;
  final List<DashboardModelClass> filter;
  final DashboardBloc dashboardBloc;
  final String? dataforEmyptyList;
  const DashboardListWidget(
      {super.key,
      required  this.tabController,
      required this.onTapItem,
      required this.currentLattitude,
      required this.currentLongitude,
      required this.filter,
      required this.dashboardBloc,
       required this.dataforEmyptyList
      });

  @override
  State<DashboardListWidget> createState() => _DashboardListWidgetState();
}

class _DashboardListWidgetState extends State<DashboardListWidget> with SingleTickerProviderStateMixin{
  int selectedCard = -1;
  // late DashboardBloc _dashboardBloc;
  List<DashboardModelClass> filter = [];
  // List<DashboardModelClass> _data = [];
  late double? facilityLattitude;
  late double? facilityLongitude;
  bool servicestatus = false;
  bool haspermission = false;
  // late Uri _url;
  GlobalStorage globalStorage = GetIt.instance();
  bool isSelected = false;
  late int janitorId;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  String latitude = "";
  String longitude = "";
  final CardSwiperController controller = CardSwiperController();
   //  AppinioSwiperController controller = AppinioSwiperController(
   //
   // );
  String? _currentAddress;
  String dropdownvalue = 'All';


  // List of items in our dropdown menu
  var items = [
    'All',
    'Ongoing',
    'Pending',
    'Accepted',
    'Completed',
    'Request for closure'
  ];

  @override
  void initState() {
    // _dashboardBloc = DashboardBloc();
    janitorId = globalStorage.getId();
   // controller =  AppinioSwiperController();
   //   controller.setCardIndex(1) ;
    // _dashboardBloc.add(GetTaskTamplates());
    // controller.;
    latitude = globalStorage.getLatitude();
    longitude = globalStorage.getLongitude();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        // BlocConsumer(

        // bloc: _dashboardBloc,
        // listener: (context, state) {
        //   if (state is GetDashboardDataSuccess) {
        //     EasyLoading.dismiss();
        //     setState(() {
        //       _data = state.data;
        //        filter =  _data  ;
        //     });
        //   }
        //
        //   if (state is UpdateStatusSuccessful) {
        //     EasyLoading.dismiss();
        //     print("status updated");
        //   }
        // },
        // builder: (context, state) {
        //   if (state is DashboardLoading && _data.isEmpty) {
        //     EasyLoading.show(status: MydashboardScreenConstants.LOADING_TOAST.tr());
        //   }
        //
        //   if (state is DashboardError) {
        //     return CustomErrorWidget(error: state.error);
        //   }
        //
        //   if (state is UpdateStatusError) {
        //     return CustomErrorWidget(error: state.error);
        //   }
        //   if (state is UpdateStatusLoading) {
        //     EasyLoading.show(status: MydashboardScreenConstants.LOADING_TOAST.tr());
        //   }
        //
        //   if (state is GetDashboardDataSuccess && _data.isEmpty) {
        //     EasyLoading.dismiss();
        //     return EmptyListWidget();
        //   }

        //  return

      Scaffold(
        backgroundColor: AppColors.white,

        body: Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 10),
          child: widget.filter.isEmpty
              ?  SizedBox(
            height: 300.h,
                child: EmptyListWidget(
                            filter: widget.dataforEmyptyList,

                          ),
              )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height:
                    MediaQuery.of(context).size.height < 800 ?

                    MediaQuery.of(context).size.height /3.1 :
                    MediaQuery.of(context).size.height / 3.3,
                    child: CardSwiper(
                       isLoop: false,
                        allowedSwipeDirection: const AllowedSwipeDirection.symmetric(
                          horizontal:true,
                        ),



                        // physics: BouncingScrollPhysics(),
                        controller: controller,
                        numberOfCardsDisplayed:  widget.filter.length == 1 ?
                        1
                            : 2,
                        cardsCount: widget.filter.length,
                        // allowUnlimitedUnSwipe: false,



                                                // onCardPositionChanged: (AppinioSwiperDirection direction) {
                                                //   print(direction.toString());
                                                // },
                      //  scrollDirection: Axis.vertical,
                     //   shrinkWrap: true,
                        cardBuilder: (
                          BuildContext context,
                          int index,
                           horizontalThresholdPercentage,
                          verticalThresholdPercentage,

                        ) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 7.h,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                widget.onTapItem();
                                setState(() {
                                  selectedCard = index;
                                });
                              },
                              child: widget.filter[index].status == "Completed"
                                  ? Container(
                                      height: 140.h,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5.h,
                                        horizontal: 10.w,
                                      ),
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 15.w,
                                      ),
                                      decoration: BoxDecoration(
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
                                          color: AppColors.completedBgColor
                                              ,
                                          borderRadius: BorderRadius.circular(26),
                                          // border: const Border(
                                          //   left: BorderSide(
                                          //     color: AppColors.completedBorderBgColor,
                                          //     width: 18.0,
                                          //   ),
                                         // )
                                          ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    // Padding(
                                                    //   padding: EdgeInsets.symmetric(
                                                    //     horizontal: 5.w,
                                                    //     vertical: 1.h,
                                                    //   ),
                                                    //   child: Text(
                                                    //       "${widget.filter[index].blockName}",
                                                    //       overflow:
                                                    //       TextOverflow.ellipsis,
                                                    //       style: AppTextStyle
                                                    //           .font12bold
                                                    //           .copyWith(
                                                    //         color: AppColors.greyButtonColor,
                                                    //       )
                                                    //     // TextStyle(
                                                    //     //   color: AppColors.timeSlotColor,
                                                    //     //   fontSize: 12.sp,
                                                    //     //   fontWeight: FontWeight.w400,
                                                    //     // ),
                                                    //   ),
                                                    // ),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(
                                                        horizontal: 5.w,
                                                        vertical: 1.h,
                                                      ),
                                                      child: Text(
                                                          "${widget.filter[index].facilityName}",
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                          style: AppTextStyle
                                                              .font12bold
                                                              .copyWith(
                                                            color: AppColors.greyButtonColor,
                                                          )
                                                        // TextStyle(
                                                        //   color: AppColors.timeSlotColor,
                                                        //   fontSize: 12.sp,
                                                        //   fontWeight: FontWeight.w400,
                                                        // ),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                // Row(
                                                //   mainAxisAlignment: MainAxisAlignment.end,
                                                //   crossAxisAlignment: CrossAxisAlignment.center,
                                                //   children: [
                                                //     Icon(
                                                //       Icons.calendar_month_outlined,
                                                //       size: 15.sp,
                                                //       color: AppColors.containerBorder,
                                                //     ),
                                                //     Padding(
                                                //       padding: EdgeInsets.symmetric(
                                                //         horizontal: 5.w,
                                                //         vertical: 1.h,
                                                //       ),
                                                //       child: Text(
                                                //          widget.filter[index].date ?? '',
                                                //         overflow: TextOverflow.ellipsis,
                                                //         style: TextStyle(
                                                //           color: AppColors.containerBorder,
                                                //           fontSize: 12.sp,
                                                //           fontWeight: FontWeight.w400,
                                                //         ),
                                                //       ),
                                                //     ),
                                                //     Icon(
                                                //       Icons.access_time,
                                                //       size: 15.sp,
                                                //       color: AppColors.containerBorder,
                                                //     ),
                                                //     Padding(
                                                //       padding: EdgeInsets.symmetric(
                                                //         horizontal: 5.w,
                                                //         vertical: 1.h,
                                                //       ),
                                                //       child: Text(
                                                //         "${ widget.filter[index].startTime}-${ widget.filter[index].endTime}",
                                                //         overflow: TextOverflow.ellipsis,
                                                //         style: TextStyle(
                                                //           color: AppColors.containerBorder,
                                                //           fontSize: 12.sp,
                                                //           fontWeight: FontWeight.w400,
                                                //         ),
                                                //       ),
                                                //     ),
                                                //   ],
                                                // ),
                                                   Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(
                                                        horizontal: 5.w,
                                                        vertical: 1.h,
                                                      ),
                                                      child: Text(
                                                          "${widget.filter[index].templateName}",
                                                          overflow:
                                                              TextOverflow.ellipsis,
                                                          style: AppTextStyle
                                                              .font12bold
                                                              .copyWith(
                                                            color: AppColors.greyButtonColor,
                                                          )
                                                          // TextStyle(
                                                          //   color: AppColors.timeSlotColor,
                                                          //   fontSize: 12.sp,
                                                          //   fontWeight: FontWeight.w400,
                                                          // ),
                                                          ),
                                                    ),
                                                   // const Spacer(),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(
                                                          // horizontal: 5.w,
                                                          vertical: 1.h,
                                                        ),
                                                        child: Text(
                                                            "${
                                                                widget.filter[index]
                                                                    .date!} \n${widget.filter[index].startTime}-${widget.filter[index].endTime}"


                                                            ,
                                                            overflow:
                                                            TextOverflow.visible,
                                                            textAlign: TextAlign.center,
                                                            style: AppTextStyle
                                                                .font10bold
                                                                .copyWith(
                                                              color: AppColors.greyButtonColor,
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
                                                    //     horizontal: 5.w,
                                                    //     vertical: 5.h,
                                                    //   ),
                                                    //   child: Container(
                                                    //     width: 42,
                                                    //     height: 42,
                                                    //     decoration: BoxDecoration(
                                                    //
                                                    //       color: getColorByRequestType( widget.filter[index].requestType ?? ''),
                                                    //       borderRadius: BorderRadius.circular(40.r),
                                                    //     ),
                                                    //     child: Center(
                                                    //       child: Text(
                                                    //         ( widget.filter[index].requestType![0] ?? '').tr(),
                                                    //         overflow: TextOverflow.ellipsis,
                                                    //         style: AppTextStyle.font14w6.copyWith(
                                                    //            color: AppColors.black,
                                                    //           letterSpacing: 0.8,
                                                    //         )
                                                    //         // TextStyle(
                                                    //         //   color: AppColors.black,
                                                    //         //   fontSize: 14.sp,
                                                    //         //   fontWeight: FontWeight.w600,
                                                    //         //   letterSpacing: 0.8,
                                                    //         // ),
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: AppColors.deviderColor.withValues(alpha: 0.4),
                                                ),




                                                Row(
                                                  // mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                            widget.filter[index]
                                                                    .description ??
                                                                '',
                                                            maxLines: 1,
                                                            softWrap: false,
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                            style: AppTextStyle
                                                                .font13w6
                                                                .copyWith(
                                                              color: AppColors
                                                                  .greyButtonColor,
                                                              letterSpacing: 0.8,
                                                            )),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                        SizedBox(
                                                          width: 180.w,
                                                          child: Text(
                                                              "${widget.filter[index].location}" 
                                                                  ,
                                                              maxLines: 2,
                                                              softWrap: true,
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                              style: AppTextStyle
                                                                  .font13w6
                                                                  .copyWith(
                                                                color: AppColors
                                                                    .greyButtonColor,
                                                                letterSpacing: 0.8,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    // Column(
                                                    //   children: [

                                                    // ],
                                                    // )

                                                    // Expanded(
                                                    //   child: Padding(
                                                    //     padding: EdgeInsets.symmetric(
                                                    //       horizontal: 5.w,
                                                    //       vertical: 5.h,
                                                    //     ),
                                                    //     child:
                                                    //     Text(
                                                    //        widget.filter[index].facilityName ?? '',
                                                    //       maxLines: 1,
                                                    //       softWrap: false,
                                                    //       overflow: TextOverflow.ellipsis,
                                                    //       style: TextStyle(
                                                    //         color: AppColors.ListTitleColor,
                                                    //         fontSize: 13.sp,
                                                    //         fontWeight: FontWeight.w600,
                                                    //         letterSpacing: 0.8,
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    // Row(
                                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                                    //   crossAxisAlignment: CrossAxisAlignment.center,
                                                    //   children: [
                                                    //
                                                    //
                                                    //   ],
                                                    // ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5.h,
                                                ),


                                                if ((widget
                                                        .filter[index].requestType ==
                                                    "Issue")) ...[
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 5.w,
                                                        vertical: 2.h),
                                                    child: Text(
                                                        "${(widget.filter[index].requestType ?? '').tr()} : ${widget.filter[index].issueDescription ?? '-'}",
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        style: AppTextStyle.font12
                                                            .copyWith(
                                                          color: AppColors
                                                              .listTitleColor,
                                                        )
                                                        //  TextStyle(
                                                        //   color: AppColors.ListTitleColor,
                                                        //   fontSize: 12.sp,
                                                        //   fontWeight: FontWeight.w400,
                                                        // ),
                                                        ),
                                                  ),
                                                ],


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
                                                //         "${MydashboardScreenConstants.TOTAL_TASK.tr()}: ${ widget.filter[index].totalTasks.toString() ?? ''}",
                                                //         overflow: TextOverflow.ellipsis,
                                                //         style: TextStyle(
                                                //           color: AppColors.disabledGreenColor,
                                                //           fontSize: 14.sp,
                                                //           fontWeight: FontWeight.w600,
                                                //         ),
                                                //       ),
                                                //     ),
                                                //     Padding(
                                                //       padding: EdgeInsets.symmetric(
                                                //         horizontal: 5.w,
                                                //         vertical: 2.h,
                                                //       ),
                                                //       child: Text(
                                                //         "${MydashboardScreenConstants.COMPLETE_TASK.tr()}: ${ widget.filter[index].pendingTasks.toString()}",
                                                //         overflow: TextOverflow.ellipsis,
                                                //         style: TextStyle(
                                                //           color: AppColors.disabledRedColor,
                                                //           fontSize: 14.sp,
                                                //           fontWeight: FontWeight.w600,
                                                //         ),
                                                //       ),
                                                //     ),
                                                //   ],
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      // height: 240.h,

                                      padding: EdgeInsets.symmetric(
                                        vertical: 5.h,
                                        horizontal: 10.w,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        // horizontal: 15.w,
                                      ),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.15), // Shadow color
                                            spreadRadius:
                                                1, // How wide the shadow should spread
                                            blurRadius:
                                                10, // The blur effect of the shadow
                                            offset: const Offset(0,
                                                0), // No offset for shadow on all sides
                                          ),
                                        ],
                                        color:
                                        // widget.filter[index].status ==
                                        //         "Pending"
                                        //     ?
                                            //
                                            AppColors.pendingCardBgColor,
                                            // : widget.filter[index].status == "Ongoing"
                                            //     ? const Color.fromARGB(255, 232, 239, 132)
                                            //     : widget.filter[index].status ==
                                            //             "Accepted"
                                            //         ? AppColors.acceptedBgColor
                                            // //.withOpacity(0.7)
                                            //             // .withOpacity(0.8)
                                            //         : widget.filter[index].status ==
                                            //                 "Request for closure"
                                            //             ? AppColors.rfcCardBgColor
                                            // //.withOpacity(0.7)
                                            //             : AppColors
                                            //                 .checkOutColor,
                                                          //  .withOpacity(0.3),

                                        borderRadius: BorderRadius.circular(25.r),
                                        // border:
                                        // Border(
                                        //   left: BorderSide( //                   <--- right side
                                        //     color:
                                        //
                                        //     widget.filter[index].status == "Pending" ?
                                        //     //
                                        //         AppColors.pendingBorderBgColor :
                                        //        widget.filter[index].status == "Ongoing" ?
                                        //       AppColors.onGoingBorderBgColor :
                                        //        widget.filter[index].status == "Accepted" ?
                                        //       AppColors.acceptedBgColor :
                                        //        widget.filter[index].status == "Request for closure" ?
                                        //       AppColors.rfcBorderBgColor
                                        //     //
                                        //         :   AppColors.disabledContainerBorder,
                                        //
                                        //
                                        //     // AppColors.pendingBorderBgColor,
                                        //     width: 18.0,
                                        //   ),
                                        // )
                                      ),
                                      child: Column(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              //         "${widget.filter[index].blockName}",
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
                                                      "${widget.filter[index].facilityName}",
                                                      overflow:
                                                      TextOverflow.visible,
                                                      style: AppTextStyle
                                                          .font12bold
                                                          .copyWith(
                                                        color:
                                                        // widget.filter[index].status ==
                                                        //     "Rejected" ?
                                                        //      AppColors.white
                                                        //     :
                                                        AppColors.black,
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

                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 5.w,
                                                    vertical: 1.h,
                                                  ),
                                                  child: Text(
                                                      "${widget.filter[index].templateName}",
                                                      overflow:
                                                          TextOverflow.visible,
                                                      style: AppTextStyle
                                                          .font12bold
                                                          .copyWith(
                                                        color:
                                                        // widget.filter[index].status ==
                                                        //     "Rejected" ?
                                                        // AppColors.white
                                                        //     :
                                                        AppColors.black,
                                                      )
                                                      // TextStyle(
                                                      //   color: AppColors.timeSlotColor,
                                                      //   fontSize: 12.sp,
                                                      //   fontWeight: FontWeight.w400,
                                                      // ),
                                                      ),
                                                ),
                                              ),
                                            // const Spacer(),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    // horizontal: 5.w,
                                                    vertical: 1.h,
                                                  ),
                                                  child: Text(
                                                      "${
                                                        widget.filter[index]
                                                            .date!} \n${widget.filter[index].startTime}-${widget.filter[index].endTime}"
                                                      ,
                                                      overflow:
                                                      TextOverflow.visible,
                                                      textAlign: TextAlign.center,
                                                      style: AppTextStyle
                                                          .font10bold
                                                          .copyWith(
                                                        color: 
                                                     
                                                             AppColors.black
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
                                              //     horizontal: 5.w,
                                              //     vertical: 5.h,
                                              //   ),
                                              //   child: Container(
                                              //     width: 42,
                                              //     height: 42,
                                              //     decoration: BoxDecoration(
                                              //
                                              //       color: getColorByRequestType( widget.filter[index].requestType ?? ''),
                                              //       borderRadius: BorderRadius.circular(40.r),
                                              //     ),
                                              //     child: Center(
                                              //       child: Text(
                                              //         ( widget.filter[index].requestType![0] ?? '').tr(),
                                              //         overflow: TextOverflow.ellipsis,
                                              //         style: AppTextStyle.font14w6.copyWith(
                                              //            color: AppColors.black,
                                              //           letterSpacing: 0.8,
                                              //         )
                                              //         // TextStyle(
                                              //         //   color: AppColors.black,
                                              //         //   fontSize: 14.sp,
                                              //         //   fontWeight: FontWeight.w600,
                                              //         //   letterSpacing: 0.8,
                                              //         // ),
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                          const Divider(
                                            color: AppColors.deviderColor,
                                          ),
                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //   crossAxisAlignment: CrossAxisAlignment.center,
                                          //   children: [
                                          //
                                          //     Padding(
                                          //       padding: EdgeInsets.symmetric(
                                          //         horizontal: 5.w,
                                          //         vertical: 1.h,
                                          //       ),
                                          //       child: Text(
                                          //         ( widget.filter[index].status ?? '').tr(),
                                          //         overflow: TextOverflow.ellipsis,
                                          //         style: TextStyle(
                                          //           color: getColorByStatus( widget.filter[index].status ?? ''),
                                          //           fontSize: 12.sp,
                                          //           fontWeight: FontWeight.w600,
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),

                                          Row(
                                            // mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        widget.filter[index]
                                                                .description ??
                                                            '',
                                                        maxLines: 1,
                                                        softWrap: false,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        style: AppTextStyle
                                                            .font13w6
                                                            .copyWith(
                                                          color:
                                                          // widget.filter[index].status ==
                                                          //     "Rejected" ?
                                                          // AppColors.white
                                                          //     :
                                                          AppColors
                                                              .listTitleColor,
                                                          letterSpacing: 0.8,
                                                        )),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    Text(
                                                        "${widget.filter[index].location}" 
                                                            ,
                                                        maxLines: 2,
                                                        softWrap: true,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: AppTextStyle
                                                            .font13w6
                                                            .copyWith(
                                                          color:
                                                          // widget.filter[index].status ==
                                                          //     "Rejected" ?
                                                          // AppColors.white
                                                          //     :
                                                          AppColors
                                                              .listTitleColor,
                                                          letterSpacing: 0.8,
                                                        )),


                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              // Column(
                                              //   children: [
                                              if (widget.filter[index].status ==
                                                  "Pending") ...[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    // Expanded(
                                                    //   child:

                                                    // ),

                                                    // Expanded(
                                                    //   child:
                                                    InkWell(
                                                      onTap: () {
                                                        // Navigator.of(context).push(
                                                        //   MaterialPageRoute(
                                                        //     builder: (context) => const JanitorList(),
                                                        //   ),
                                                        // );
                                                        widget.dashboardBloc
                                                            .add(UpdateStatus(
                                                                id: widget
                                                                        .filter[
                                                                            index]
                                                                        .taskAllocationId ??
                                                                    '',
                                                                status: "2"));
                                                     widget.tabController!.animateTo(1);

                                                      },
                                                      child: Container(
                                                        width: 60.w,
                                                        height: 60.h,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            const BoxDecoration(
                                                              shape: BoxShape.circle,
                                                          // borderRadius:
                                                          //     BorderRadius
                                                          //         .circular(
                                                          //             100.r),
                                                          color:
                                                          AppColors.bottomNavigationColor
                                                        ),
                                                        child: Center(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                            children: [

                                                              CustomImageProvider(
                                                                image: AppImages.checkIcons,
                                                                width: 19.w,
                                                                height: 19.h,
                                                              ),
                                                              SizedBox(
                                                                width :50.w,
                                                                child: Text(
                                                                  MydashboardScreenConstants.ACCEPT.tr(),
                                                                  textAlign: TextAlign.center,

                                                                  style:  AppTextStyle.font10.copyWith(

                                                                   fontSize: 10,
                                                                   overflow: TextOverflow.visible,
                                                                   fontWeight: FontWeight.bold,



                                                                 ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 6.w,
                                                    ),
                                                    // )
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {});

                                                        widget.dashboardBloc
                                                            .add(UpdateStatus(
                                                                id: widget
                                                                    .filter[
                                                                        index]
                                                                    .taskAllocationId!,
                                                                status: "7"));
                                                                  widget.tabController!.animateTo(5);
                                                      },
                                                      child: Container(
                                                        width: 60.w,
                                                        height: 60.h,
                                                        alignment: Alignment
                                                            .centerRight,
                                                        decoration:
                                                            const BoxDecoration(
                                                              shape: BoxShape.circle,
                                                          // borderRadius:
                                                          //     BorderRadius
                                                          //         .circular(
                                                          //             70.r),
                                                          color: AppColors
                                                              .checkOutColor,
                                                        ),
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.center,

                                                            children: [
                                                               CustomImageProvider(
                                                                image: AppImages.removeIcons,
                                                                 width: 19.w,
                                                                 height: 19.h,
                                                               ),
                                                              // const Icon(
                                                              //   Icons.close,
                                                              //   color:
                                                              //   AppColors
                                                              //       .white,
                                                              //   size: 19,
                                                              // ),
                                                              Text(MydashboardScreenConstants.REJECT.tr(),
                                                                style:  AppTextStyle.font10.copyWith(
                                                                  color: AppColors.white,
                                                                    fontSize: 10,
                                                                    fontWeight: FontWeight.bold
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                              if (widget.filter[index].status ==
                                                  "Accepted") ...[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        checkGps();
                                                        setState(() {

                                                          facilityLattitude =
                                                              widget
                                                                  .filter[index]
                                                                  .lat;
                                                          facilityLongitude =
                                                              widget
                                                                  .filter[index]
                                                                  .lng;
                                                        });
                                                        // await MapUtils.openMap(
                                                        //     widget.filter[index]
                                                        //             .lat ??
                                                        //         0.0,
                                                        //     widget.filter[index]
                                                        //             .lng ??
                                                        //         0.0);
                                                        // _url = Uri.parse(
                                                        //     'https://www.google.com/maps/dir/${latitude},${longitude}/${ widget.filter[index].lat},${filter[index].lng}');
                                                        // await _launchUrl();
                                                      },
                                                      child: Container(
                                                        width: 60.w,
                                                        height: 60.h,
                                                        // width: 75.w,
                                                        alignment: Alignment
                                                            .centerRight,
                                                        decoration:
                                                            const BoxDecoration(
                                                         shape: BoxShape.circle,
                                                          color: AppColors
                                                              .buttonBgColor,
                                                        ),
                                                        child:  Center(
                                                            child:
                                                          Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                            children: [
                                                               CustomImageProvider(
                                                                image: AppImages.directionIcons,
                                                                 width: 19.w,
                                                                 height: 19.h,
                                                               ),

                                                                    Text(MydashboardScreenConstants.DIRECTION.tr(),
                                                                        style:  AppTextStyle.font10.copyWith(
                                                                          color: AppColors.black,
                                                                            fontSize: 10,
                                                                            fontWeight: FontWeight.bold
                                                                        ),
                                                                      )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 7.w,
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        await Navigator.of(
                                                                context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                SelfieScreen(
                                                              templateId: widget
                                                                      .filter[
                                                                          index]
                                                                      .templateId ??
                                                                  0,
                                                              allocationId: widget
                                                                      .filter[
                                                                          index]
                                                                      .taskAllocationId ??
                                                                  '',
                                                            ),
                                                          ),
                                                        );
                                                        debugPrint("afasdfasfsadf${widget.filter[index]
                                                                .taskAllocationId}");
                                                        widget.dashboardBloc.add(
                                                            const GetTaskTamplates());
                                                            widget.tabController!.animateTo(2);
                                                      },
                                                      child: Container(
                                                        // width: 75.w,
                                                        width: 60.w,
                                                        height: 60.h,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            const BoxDecoration(
                                                         shape: BoxShape.circle,
                                                          color: AppColors
                                                              .buttonBgColor,
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                          children: [
                                                            Center(
                                                                child: CustomImageProvider(image:AppImages.startIcons,
                                                                  width: 19.w,
                                                                  height: 19.h,
                                                                  fit: BoxFit.fill,
                                                                )
                                                            ),
                                                                       Text(MydashboardScreenConstants.START.tr(),
                                                                        style:  AppTextStyle.font10.copyWith(
                                                                          color: AppColors.black,
                                                                            fontSize: 10,
                                                                            fontWeight: FontWeight.bold
                                                                        ),
                                                                      )

                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                              if (widget.filter[index].status ==
                                                  "Ongoing") ...[
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    // Expanded(
                                                    //   child: Container(),
                                                    // ),
                                                    InkWell(
                                                      onTap: () {
                                                        // Navigator.of(context).push(
                                                        //   MaterialPageRoute(
                                                        //     builder: (context) => const TaskCompletionScreen(),
                                                        //   ),
                                                        // );
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                TaskCompletionScreen(
                                                              allocationId: widget
                                                                      .filter[
                                                                          index]
                                                                      .taskAllocationId ??
                                                                  '',
                                                            ),
                                                          ),
                                                        );
                                                       widget.tabController!.animateTo(3);
                                                      },
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    10.w,
                                                                vertical: 8.h),
                                                        child: Container(
                                                          width: 120.w,
                                                          height: 40.h,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25.r),
                                                                  color: AppColors
                                                                      .buttonBgColor
                                                          ),
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.center,
                                                              children: [
                                                                Center(
                                                                    child:
                                                                 CustomImageProvider(
                                                                   image: AppImages.rfcIcons,
                                                                   width: 19.w,
                                                                   height: 19.h,
                                                                 ),
                                                                ),
                                                                SizedBox(
                                                                   width: 80.w,
                                                                  child: Text(

                                                                      MydashboardScreenConstants.Rquest_TASK.tr(),
                                                                      maxLines: 2,
                                                                      softWrap: true,
                                                                      textAlign: TextAlign.center,
                                                                      overflow: TextOverflow
                                                                          .visible,
                                                                      style: AppTextStyle
                                                                          .font10w6
                                                                          .copyWith(
                                                                        fontSize: 11,
                                                                        color: AppColors
                                                                            .listTitleColor,
                                                                        letterSpacing: 0.8,
                                                                      )),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                              ],
                                              // ],
                                              // )

                                              // Expanded(
                                              //   child: Padding(
                                              //     padding: EdgeInsets.symmetric(
                                              //       horizontal: 5.w,
                                              //       vertical: 5.h,
                                              //     ),
                                              //     child:
                                              //     Text(
                                              //        widget.filter[index].facilityName ?? '',
                                              //       maxLines: 1,
                                              //       softWrap: false,
                                              //       overflow: TextOverflow.ellipsis,
                                              //       style: TextStyle(
                                              //         color: AppColors.ListTitleColor,
                                              //         fontSize: 13.sp,
                                              //         fontWeight: FontWeight.w600,
                                              //         letterSpacing: 0.8,
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                              // Row(
                                              //   mainAxisAlignment: MainAxisAlignment.center,
                                              //   crossAxisAlignment: CrossAxisAlignment.center,
                                              //   children: [
                                              //
                                              //
                                              //   ],
                                              // ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),

                                          // if ((widget
                                          //         .filter[index].requestType ==
                                          //     "Issue")) ...[
                                          //   Padding(
                                          //     padding: EdgeInsets.symmetric(
                                          //         horizontal: 5.w,
                                          //         vertical: 2.h),
                                          //     child: Text(
                                          //         "${(widget.filter[index].requestType ?? '').tr()} : ${widget.filter[index].issueDescription ?? '-'}",
                                          //         overflow:
                                          //             TextOverflow.ellipsis,
                                          //         style: AppTextStyle.font12
                                          //             .copyWith(
                                          //           color: AppColors
                                          //               .ListTitleColor,
                                          //         )

                                          //         // TextStyle(
                                          //         //   color: AppColors.ListTitleColor,
                                          //         //   fontSize: 12.sp,
                                          //         //   fontWeight: FontWeight.w400,
                                          //         // ),
                                          //         ),
                                          //   ),
                                          // ],

                                          if (widget.filter[index ].status ==
                                              "Re-open") ...[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    checkGps();
                                                    await MapUtils.openMap(
                                                        widget.filter[index]
                                                                .lat ??
                                                            0.0,
                                                        widget.filter[index]
                                                                .lng ??
                                                            0.0);
                                                    // _url = Uri.parse(
                                                    //     'https://www.google.com/maps/dir/${latitude},${longitude}/${ widget.filter[index].lat},${filter[index].lng}');
                                                    // await _launchUrl();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.w,
                                                            vertical: 8.h),
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.r),
                                                        color: AppColors
                                                            .buttonColor,
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 15.w,
                                                          vertical: 6.h,
                                                        ),
                                                        child: Text(
                                                            MydashboardScreenConstants
                                                                .DIRECTION
                                                                .tr(),
                                                            textAlign: TextAlign
                                                                .center,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: AppTextStyle
                                                                .font10w6
                                                                .copyWith(
                                                              color: AppColors
                                                                  .black,
                                                            )
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
                                                InkWell(
                                                  onTap: () async {
                                                    await Navigator.of(context)
                                                        .push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SelfieScreen(
                                                          templateId: widget
                                                              .filter[index]
                                                              .templateId!,
                                                          allocationId: widget
                                                                  .filter[index]
                                                                  .taskAllocationId ??
                                                              '',
                                                        ),
                                                      ),
                                                    );
                                                    debugPrint("afasdfasfsadf${widget.filter[index]
                                                            .taskAllocationId}");
                                                    widget.dashboardBloc.add(
                                                        const GetTaskTamplates());
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.w,
                                                            vertical: 8.h),
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.r),
                                                        color: AppColors
                                                            .acceptButtonColor,
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 15.w,
                                                          vertical: 6.h,
                                                        ),
                                                        child: Text(
                                                            MydashboardScreenConstants
                                                                .START
                                                                .tr(),
                                                            textAlign: TextAlign
                                                                .center,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: AppTextStyle
                                                                .font10w6
                                                                .copyWith(
                                                              color: AppColors
                                                                  .white,
                                                            )
                                                            //  TextStyle(
                                                            //   fontSize: 10.sp,
                                                            //   fontWeight: FontWeight.w600,
                                                            //   color: AppColors.white,
                                                            // ),
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),

                                          ],

                                          // SizedBox(
                                          //   height: 10.h,
                                          // )
                                        ],
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                  ),
                   SizedBox(
                     height: 10.h,
                   ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(right: 16 ),
                        child: swipeRightButton(controller,widget.filter.length),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16 ),
                        child: swipeLeftButton(controller,widget.filter.length),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16 ),
                        child: unswipeButton(controller),
                      ),
                    ],
                  ),

                    SizedBox(
                      height: 15.h,
                    ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70 ),
                      child: Container(
                        // width: 198.w,
                          decoration: BoxDecoration(
                            color: AppColors
                                .white, // Background color of the container
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Colors.black.withValues( alpha:0.2), // Shadow color
                                spreadRadius:
                                    1, // How wide the shadow should spread
                                blurRadius: 10, // The blur effect of the shadow
                                offset: const Offset(
                                    0, 0), // No offset for shadow on all sides
                              ),
                            ],

                            borderRadius: BorderRadius.circular(25.r)),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Center(
                            child: Text("${widget.filter.first.status }Task : ${widget.filter.length}",
                              textAlign: TextAlign.center,
                              style:    AppTextStyle
                                  .font14bold
                                  .copyWith(

                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
        ),
      );
    // },
    // );
  }

  // Future<void> _launchUrl() async {
  //   if (!await launchUrl(_url)) {
  //     throw Exception("${MydashboardScreenConstants.URL_ERR_TOAST.tr()} $_url");
  //   }
  // }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          debugPrint("Location permissions are permanently denied");
          openAppSettings();
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        await getLocation();
      }

      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      EasyLoading.showToast(MydashboardScreenConstants.GPS_DISABLED_TOAST.tr());
    }
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint(position.longitude.toString()); //Output: 80.24599079
    debugPrint(position.latitude.toString()); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    // StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
       //Output: 80.24599079
       //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();

      _getAddressFromLatLng(position);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.name},${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.administrativeArea},${place.postalCode}';
        debugPrint("address $_currentAddress");
        // EasyLoading.showToast("Current Location Detected : $_currentAddress");
      });
    }).catchError((e) {
      debugPrint(e);
    });
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

  Color getColorByStatus(String status) {
    switch (status) {
      case "Ongoing":
        return AppColors.inProgressStatusColor;
      case "Pending":
        return AppColors.pendingStatusColor;
      case "Accepted":
        return AppColors.greenTextColor;
      case "Re-open":
        return AppColors.reOpenStatusColor;
      case "Completed":
        return AppColors.greenTextColor;
      case "Request for closure":
        return AppColors.issueButtonColor;
      case "Rejected":
        return AppColors.redText;
      default:
        return AppColors.black;
    }
  }
}
