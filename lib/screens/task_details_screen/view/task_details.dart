import 'package:Woloo_Smart_hygiene/core/local/global_storage.dart';
import 'package:Woloo_Smart_hygiene/screens/common_widgets/disabled_checkbox_widget.dart';
import 'package:Woloo_Smart_hygiene/screens/common_widgets/empty_list_widget.dart';
import 'package:Woloo_Smart_hygiene/screens/common_widgets/error_widget.dart';
import 'package:Woloo_Smart_hygiene/screens/supervisor_dashboard/bloc/supervisor_dashboard_bloc.dart';
import 'package:Woloo_Smart_hygiene/screens/task_details_screen/bloc/submitted_task_bloc.dart';
import 'package:Woloo_Smart_hygiene/screens/task_details_screen/bloc/submitted_task_event.dart';
import 'package:Woloo_Smart_hygiene/screens/task_details_screen/bloc/submitted_task_state.dart';
import 'package:Woloo_Smart_hygiene/screens/task_details_screen/data/model/Submitted_tasks_model.dart';
import 'package:Woloo_Smart_hygiene/utils/app_color.dart';
import 'package:Woloo_Smart_hygiene/utils/app_constants.dart';
import 'package:Woloo_Smart_hygiene/utils/app_textstyle.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../supervisor_dashboard/bloc/supervisor_dashboard_event.dart';

class TaskDetailsScreen extends StatefulWidget {
  final bool isFromDashboard;
  final bool isFromFacility;
  final String allocationId;
  final bool isApproved;

  const TaskDetailsScreen({
    Key? key,
    required this.isFromDashboard,
    required this.isFromFacility,
    required this.allocationId,
    this.isApproved = false,
  }) : super(key: key);

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  bool submitButtonTap = true;
  bool skipButtonTap = false;
  bool isChecked = false;
  final int index = 0;
  int allocationId = 0;

  SubmittedTaskModel submittedTaskModel = SubmittedTaskModel();
  SubmittedTaskBloc submittedTaskBloc = SubmittedTaskBloc();
  // CarouselController buttonCarouselController = CarouselController();
  final CarouselSliderController buttonCarouselController = CarouselSliderController();

  GlobalStorage _globalStorage = GetIt.instance();
  late  SupervisorDashboardBloc _supervisorDashboardBloc = SupervisorDashboardBloc();

  @override
  void initState() {
   
    print("isApproved --- >" + widget.isApproved.toString());
    submittedTaskBloc
        .add(GetAllSubmittedTasks(allocationId: widget.allocationId));
        _supervisorDashboardBloc = GetIt.instance<SupervisorDashboardBloc>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            ),
            color: AppColors.appBarIconColor,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
              vertical: 10.h,
            ),
            child: Text(
                MyTaskListConstants.APP_BAR.tr(),
                textAlign: TextAlign.start,
                style:AppTextStyle.font24.copyWith(
                  color: AppColors.appBarTitleColor,
                )
              //  TextStyle(
              //   color: AppColors.appBarTitleColor,
              //   fontSize: 24.sp,
              //   fontWeight: FontWeight.w400,
              // ),
            ),
          ),
          backgroundColor: AppColors.white,
          elevation: 0,
        ),
        body: BlocConsumer(
          bloc: submittedTaskBloc,
          listener: (context, state) {
             print(" details  $state");
            if (state is GetSubmittedTasksSuccess) {
              EasyLoading.dismiss();
                print("images ---- ${submittedTaskModel.taskImages}");
                   //_supervisorDashboardBloc.add(GetSupervisorDashboardData());
            }
            if (state is UpdateStatusSuccessful) {
              _supervisorDashboardBloc.add(GetSupervisorDashboardData());
              EasyLoading.dismiss();
             

              Navigator.pop(context);
            
            }
          },
          builder: (context, state) {
          //   print(" details task state  $state");
            if (state is GetSubmittedTasksLoading) {
              EasyLoading.show(
                  status: MydashboardScreenConstants.LOADING_TOAST.tr());
            } else
              if(state is GetSubmittedTasksSuccess){
                submittedTaskModel = state.data;
                 return
                   // Scaffold(
                   //
                   // body:
                   Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       if (submittedTaskModel.taskImages?.isNotEmpty ?? false) ...[
                         SizedBox(
                           height: 180.h,
                           width: ScreenUtil().screenWidth,
                           child: Padding(
                             padding: EdgeInsets.symmetric(
                               horizontal: 20.w,
                               vertical: 10.h,
                             ),
                             child: CarouselSlider(
                               options: CarouselOptions(
                                 enableInfiniteScroll: false,
                                 viewportFraction: 1,
                               ),
                               items: List.generate(
                                 submittedTaskModel.taskImages?.length ?? 0,
                                     (index) => Center(
                                   child: ClipRRect(
                                     borderRadius: BorderRadius.circular(
                                       10.r,
                                     ),
                                     child: Image.network(
                                       submittedTaskModel.taskImages![index],
                                       fit: BoxFit.cover,
                                       width: ScreenUtil().screenWidth,
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                           ),
                         ),
                       ],
                       Padding(
                         padding: EdgeInsets.symmetric(
                           vertical: 5.h,
                           horizontal: 20.w,
                         ),
                         child: Text(
                             MyTaskDetailsScreenConstants.TITLE.tr(),
                             textAlign: TextAlign.start,
                             style:
                             AppTextStyle.font24.copyWith(
                               color: AppColors.titleColor,
                             )
                           //  TextStyle(
                           //   color: AppColors.titleColor,
                           //   fontSize: 24.sp,
                           //   fontWeight: FontWeight.w400,
                           // ),
                         ),
                       ),
                       submittedTaskModel.taskStatus == null
                           ?  EmptyListWidget(
                            filter:  EmptyWidgetConstants.DATA_NOT_FOUND.tr(),
                           )
                           : Expanded(
                         child: Padding(
                           padding: EdgeInsets.symmetric(
                             vertical: 5.h,
                           ),
                           child: ListView.builder(
                             physics: const BouncingScrollPhysics(),
                             scrollDirection: Axis.vertical,
                             itemCount:
                             submittedTaskModel.taskStatus?.length ?? 0,
                             itemBuilder: (
                                 BuildContext context,
                                 int index,
                                 ) {
                               return Padding(
                                 padding: EdgeInsets.symmetric(
                                   vertical: 7.h,
                                 ),
                                 child: DisabledCheckboxListWidget(
                                     key: Key(
                                         "${submittedTaskModel.taskStatus?[index].status}$index"),
                                     name: submittedTaskModel
                                         .taskStatus?[index].taskName,
                                     isChecked: submittedTaskModel
                                         .taskStatus?[index].status ==
                                         "1"),
                               );
                             },
                           ),
                         ),
                       ),
                       if (widget.isFromDashboard &&
                           !widget.isApproved &&
                           submittedTaskModel.taskStatus != null) ...[
                         Padding(
                           padding:
                           EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                               GestureDetector(
                                 onTap: () {
                                   print(widget.allocationId);
                                   submittedTaskBloc.add(UpdateStatus(
                                       id: widget.allocationId, status: 7));
                                 },
                                 child: Container(
                                     decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(10.r),
                                         color: AppColors.greyButtonColor),
                                     child: Padding(
                                       padding: EdgeInsets.symmetric(
                                         horizontal: 25.w,
                                         vertical: 10.h,
                                       ),
                                       child: Center(
                                         child: Text(
                                             MydashboardScreenConstants.REJECT.tr(),
                                             style:
                                             AppTextStyle.font16.copyWith( color: AppColors.titleColor,  )
                                           // TextStyle(
                                           //   color: AppColors.black,
                                           //   fontSize: 16.sp,
                                           //   fontWeight: FontWeight.w400,
                                           // ),
                                         ),
                                       ),
                                     )),
                               ),
                               GestureDetector(
                                 onTap: () {
                                   submittedTaskBloc.add(UpdateStatus(
                                       id: widget.allocationId, status: 4));
                                 },
                                 child: Container(
                                     decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(10.r),
                                         color: AppColors.buttonColor),
                                     child: Padding(
                                       padding: EdgeInsets.symmetric(
                                         horizontal: 25.w,
                                         vertical: 10.h,
                                       ),
                                       child: Center(
                                         child: Text(
                                             MyTaskDetailsScreenConstants.APPROVE_BUTTON
                                                 .tr(),
                                             style:
                                             AppTextStyle.font16w6.copyWith( color: AppColors.titleColor,  )
                                           //  TextStyle(
                                           //   color: AppColors.black,
                                           //   fontSize: 16.sp,
                                           //   fontWeight: FontWeight.w600,
                                           // ),
                                         ),
                                       ),
                                     )),
                               )
                             ],
                           ),
                         )
                       ],
                     ],

                 );
              }  else
            if (state is GetSubmittedTasksError) {
              return CustomErrorWidget(error: state.error.message);
            }
             else
            if (state is UpdateStatusLoading) {
              EasyLoading.show(
                  status: MydashboardScreenConstants.LOADING_TOAST.tr());
            }
            else
            if 
            (state is UpdateStatusSuccessful ){

               _supervisorDashboardBloc.add(GetSupervisorDashboardData());
            }
            if (state is UpdateStatusError) {
              EasyLoading.dismiss();
              return CustomErrorWidget(error: state.error.message);
            }
            return  SizedBox();

          }),
      );
  }
}
