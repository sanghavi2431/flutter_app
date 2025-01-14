import 'package:Woloo_Smart_hygiene/utils/app_textstyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Woloo_Smart_hygiene/screens/choose_facility_screen/view/choose_facility.dart';
import 'package:Woloo_Smart_hygiene/screens/common_widgets/janitor_list.dart';
import 'package:Woloo_Smart_hygiene/screens/janitor_details_screen/view/janitor_details.dart';
import 'package:Woloo_Smart_hygiene/screens/janitor_screen/data/model/Janitor_list_model.dart';
import 'package:Woloo_Smart_hygiene/utils/app_color.dart';
import 'package:Woloo_Smart_hygiene/utils/app_constants.dart';

import '../../common_widgets/leading_button.dart';
import '../bloc/janitor_list_bloc.dart';

class JanitorList extends StatefulWidget {
  final bool isFromCluster;
  final bool isFromDashboard;
  final bool isFromDashboardAssignment;

  final String? clusterId;
  final String? janitorName;
  final bool? rejected;
  List<String>? allocationId;
  JanitorList({Key? key,
      this.janitorName,
    required this.isFromCluster, required this.isFromDashboard, required this.isFromDashboardAssignment, this.allocationId, this.clusterId, required this.rejected}) : super(key: key);

  @override
  State<JanitorList> createState() => _JanitorListState();
}

class _JanitorListState extends State<JanitorList> {
  final TextEditingController _searchController = TextEditingController();
  bool cancelButtonTap = true;
  bool yesButtonTap = false;
  var key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(

        elevation: 0,
        backgroundColor: AppColors.white,
        leadingWidth:
        widget.isFromDashboard ?
         15 :
        100,
        title:
        widget.isFromDashboard ?
        Text(

          MyJanitorsListScreenConstants.TITLE_TEXT.tr(),
          style:
          AppTextStyle.font24bold.copyWith(
             color: AppColors.black,
          )
          // TextStyle(
          //   fontSize: 24.sp,
          //   fontWeight: FontWeight.w400,
          //   color: AppColors.yellowSplashColor,
          // ),
        ) : Container(),
        leading: widget.isFromCluster || widget.isFromDashboardAssignment
            ?

             LeadingButton()
            
            //  IconButton(
            //     color: AppColors.black30,
            //     icon: const Icon(
            //       Icons.arrow_back,
            //       color: Colors.white,
            //       size: 30,
            //     ),
            //     // color: AppColors.black,
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //   )
            : Container(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.h,
          ),
          widget.isFromCluster || widget.isFromDashboardAssignment ?
         Padding(
           padding:  EdgeInsets.symmetric(   horizontal: 20.w,),
           child: Text(
            MyJanitorsListScreenConstants.TITLE_TEXT.tr(),
            style: 
            AppTextStyle.font24bold.copyWith(
               color: AppColors.black,
            )
            // TextStyle(
            //   fontSize: 24.sp,
            //   fontWeight: FontWeight.w400,
            //   color: AppColors.yellowSplashColor,
            // ),
                   ),
         )
          : Container(),
         SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child:
            
             Container(
                 height: 45.h,
                   decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(25.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Shadow color
                        spreadRadius: 1, // How wide the shadow should spread
                        blurRadius: 10, // The blur effect of the shadow
                        offset:
                            Offset(0, 0), // No offset for shadow on all sides
                      ),
                    ],

                  ),
               child: Center(

                 child: TextField(
                    textAlign: TextAlign.start,
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: MyFacilityListConstants.SEARCH.tr(),
                    prefixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        
                      },

                    ),
                   contentPadding:EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 10.0),
                    border: InputBorder.none,
                    ),
                  ),
               ),
                           ),
            //  ),
      // )
          ),
             SizedBox(
            height: 10.h,
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(
          //     horizontal: 20.w,
          //     vertical: 10.h,
          //   ),
          //   child: Text(
          //     MyJanitorsListScreenConstants.SUB_TITLE.tr(),
          //     style:
          //     AppTextStyle.font16.copyWith(
          //        color: AppColors.titleColor,
          //     ),
          //     //  TextStyle(
          //     //   color: AppColors.titleColor,
          //     //   fontSize: 16.sp,
          //     //   fontWeight: FontWeight.w400,
          //    // ),
          //   ),
          // ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 0.h,
              ),
              child: JanitorListWidget(
                isRejected: widget.rejected!,
                key: key,
                controller: _searchController,
                clusterId: widget.clusterId,
                onTapItem: (JanitorListModel data) async {
                  if (widget.isFromCluster && data.isPresent == true) {
                    await

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            BlocProvider<JanitorListBloc>(
                              create: (BuildContext context) => JanitorListBloc(),
                              child: JanitorDetails(
                                id: data.id ?? '',
                                shift: data.shift.toString(),
                                check_in_time: data.startTime.toString(),
                                check_out_time: data.endTime.toString(),
                                complete_task: data.completedTaskCount ?? "" ,
                                pending_task: data.pendingTaskCount.toString(),
                                total_task: data.totalTaskCount.toString(),
                                name: data.name.toString(),
                                mobile: data.mobile.toString(),
                                isPresent: data.isPresent ?? false,
                                baseUrl: data.baseUrl!,
                                profile: data.profileImage!,
                                clusterId: data.clusterId!,
                                rfcTask: data.rfcTaskCount,
                                rejectedTask: data.rejectsTaskCount,
                                ongoingTask: data.onGoingTaskCount,
                                accetedTask: data.acceptedTaskCount,
                              ),
                            ),
                      ),
                    );
                    setState(() => key = GlobalKey());
                  }
                  if (widget.isFromDashboard && context.mounted) {
                    await

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            BlocProvider<JanitorListBloc>(
                              create: (BuildContext context) => JanitorListBloc(),
                              child: JanitorDetails(
                                                        id: data.id ?? '',
                                                        shift: data.shift.toString(),
                                                        check_in_time: data.startTime.toString(),
                                                        check_out_time: data.endTime.toString(),
                                                        complete_task: data.completedTaskCount ?? "" ,
                                                        pending_task: data.pendingTaskCount.toString(),
                                                        total_task: data.totalTaskCount.toString(),
                                                        name: data.name.toString(),
                                                        mobile: data.mobile.toString(),
                                                        isPresent: data.isPresent ?? false,
                                                        baseUrl: data.baseUrl!,
                                                        profile: data.profileImage!,
                                                        clusterId: data.clusterId!,
                                                        rfcTask: data.rfcTaskCount,
                                                        rejectedTask: data.rejectsTaskCount,
                                                        ongoingTask: data.onGoingTaskCount,
                                                       accetedTask: data.acceptedTaskCount,
                                                      ),
                            ),
                      ),
                    );
                    setState(() => key = GlobalKey());
                  }
                },
                isFromCluster: widget.isFromCluster,
                isFromDashboard: widget.isFromDashboard,
                isFromFacility: false,
                allocationId: widget.allocationId ?? [],
                isFromDashboardAssignment: widget.isFromDashboardAssignment,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
