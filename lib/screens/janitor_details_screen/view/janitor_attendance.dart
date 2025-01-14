import 'package:Woloo_Smart_hygiene/screens/attendance_history_screen/data/model/Month_list_model.dart';
import 'package:Woloo_Smart_hygiene/screens/janitor_details_screen/cubit/janitor_attendance_cubit.dart';
import 'package:Woloo_Smart_hygiene/utils/app_color.dart';
import 'package:Woloo_Smart_hygiene/utils/app_constants.dart';
import 'package:Woloo_Smart_hygiene/utils/app_textstyle.dart';
import 'package:bubble/bubble.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JanitorAttendance extends StatelessWidget {
  final int janiId;
  const JanitorAttendance({super.key, required this.janiId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JanitorAttendanceCubit(janiId)..init(),
      child: _JanitorAttendanceView(key: key),
    );
  }
}

class _JanitorAttendanceView extends StatelessWidget {
  const _JanitorAttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<JanitorAttendanceCubit>();
    final state = cubit.state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

     

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
          MyJanitorProfileScreenConstants.ATTENDANCE_HISTORY.tr(),
          style: AppTextStyle.font24bold,
        ),
           SizedBox(height: 10.h),
              Container(
                height: 50.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                    color: AppColors.white,
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
                  child: DropdownButtonFormField<MonthListModel>(
                    value: state.selected,
                    decoration: InputDecoration(
                          contentPadding:EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 10.0),
                      border: InputBorder.none,
                      //  const OutlineInputBorder(
                      //   borderRadius: BorderRadius.all(
                      //     Radius.circular(10),
                      //   ),
                      // ),
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: MyAttendanceHistoryScreenConstants.SELECT.tr(),
                    ),
                    icon: const Icon(Icons.arrow_drop_down_outlined),
                    items: state.months.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                            "${monthItems[(int.tryParse(item.month.toString()) ?? 1) - 1]} ${item.year}",
                            style: AppTextStyle.font14
                                .copyWith(color: AppColors.darkGreyText)
                            // TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.darkGreyText),
                            ),
                      );
                    }).toList(),

                    onChanged: (item) => cubit.getMonth(item!),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              // Row(
              //   children: [
              //     InkWell(
              //       borderRadius: BorderRadius.circular(20.r),
              //       onTap: () {
              //         if (state.sortBy == "absent") {
              //           cubit.sort(null);
              //           return;
              //         }
              //         cubit.sort("absent");
              //       },
              //       child: Container(
              //         padding:
              //             EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              //         decoration: BoxDecoration(
              //           color: Colors.red.withOpacity(.1),
              //           borderRadius: BorderRadius.circular(20.r),
              //           border: Border.all(
              //             color: state.sortBy == "absent"
              //                 ? Colors.red
              //                 : Colors.transparent,
              //           ),
              //         ),
              //         child: const Text(
              //           "Absent",
              //           style: TextStyle(color: Colors.redAccent),
              //         ),
              //       ),
              //     ),
              //     SizedBox(width: 10.w),
              //     InkWell(
              //       onTap: () {
              //         if (state.sortBy == "present") {
              //           cubit.sort(null);
              //           return;
              //         }
              //         cubit.sort("present");
              //       },
              //       borderRadius: BorderRadius.circular(20.r),
              //       child: Container(
              //         padding:
              //             EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              //         decoration: BoxDecoration(
              //           color: Colors.greenAccent.withOpacity(.1),
              //           borderRadius: BorderRadius.circular(20.r),
              //           border: Border.all(
              //             color: state.sortBy == "present"
              //                 ? Colors.green
              //                 : Colors.transparent,
              //           ),
              //         ),
              //         child: const Text(
              //           "Present",
              //           style: TextStyle(color: Colors.green),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
        SizedBox(height: 15.h),
        Divider(
          height: 0,
          color: Colors.grey.withOpacity(.2),
          thickness: 1.5,
        ),
        Expanded(
          child: state is JanitorAttendanceLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.separated(
                  itemCount: state.attendance.length,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 46.w,
                          height: 46.w,
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          decoration: BoxDecoration(
                             boxShadow: [
                                BoxShadow(
                                  blurRadius: 11.0,
                                  spreadRadius: 0,
                                  offset: Offset(1, 1),
                                  color: AppColors.greyShadow,
                                ),
                              ],
                            borderRadius: BorderRadius.circular(10),
                            color:AppColors.buttonBgColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(state.attendance[index].date ?? '',
                                  maxLines: 1,
                                  style: AppTextStyle.font16bold.copyWith(
                                    color: AppColors.historyText,
                                  )
                                  //  TextStyle(
                                  //   color: AppColors.historyText,
                                  //   fontSize: 14.sp,
                                  //   fontWeight: FontWeight.w400,
                                  // ),
                                  ),
                              Text(
                                state.attendance[index].dayOfWeek ?? '-',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                AppTextStyle.font12bold.copyWith(
                                    color: AppColors.historyText,
                                  )
                                //  TextStyle(
                                //   color: AppColors.historyText,
                                //   fontSize: 14.sp,
                                //   fontWeight: FontWeight.w400,
                                // ),
                              )
                            ],
                          ),
                        ),
                      Bubble(
                         radius:Radius.circular(25.0),
                        elevation: 5,
                        nipWidth: 14,
                        // margin: BubbleEdges.only(top: 10),
                        nip: BubbleNip.leftCenter,
                         color: AppColors.white,
                        alignment: Alignment.topCenter,
                    
                          child: 
                          Container(
                            width: 200.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      MydashboardScreenConstants.CHECK_IN.tr(),
                                      style: 
                                      AppTextStyle.font14.copyWith(
                                      color: AppColors.historyText,
                                          )
                                      
                                      // TextStyle(
                                      //   color: AppColors.historyText,
                                      //   fontSize: 14.sp,
                                      //   fontWeight: FontWeight.w400,
                                      // ),
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      " ${state.attendance[index].checkIn ?? '-'}",
                                      style: 
                                      AppTextStyle.font12.copyWith(
                                         color: AppColors.lightGreyText, 
                                      )
                                      // TextStyle(
                                      //   color: AppColors.lightGreyText,
                                      //   fontSize: 12.sp,
                                      //   fontWeight: FontWeight.w400,
                                      // ),
                                    )
                                  ],
                                ),
                                 Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                MydashboardScreenConstants.CHECK_OUT.tr(),
                                style:AppTextStyle.font14.copyWith(
                                  color: AppColors.historyText,
                                )
                                
                                //  TextStyle(
                                //   color: AppColors.historyText,
                                //   fontSize: 14.sp,
                                //   fontWeight: FontWeight.w400,
                                // ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                state.attendance[index].checkOut ?? '-',
                                style: 
                                AppTextStyle.font12.copyWith(
                                  color: AppColors.lightGreyText,
                                )
                                
                                // TextStyle(
                                //   color: AppColors.lightGreyText,
                                //   fontSize: 12.sp,
                                //   fontWeight: FontWeight.w400,
                                // ),
                              )
                            ],
                                                    ),
                             
                                                    CircleAvatar(
                            radius: 25.r,
                            backgroundColor: state.attendance[index].attendance
                                        ?.toLowerCase()
                                        .contains("present") ==
                                    true
                                ? Colors.green.withOpacity(.1)
                                : Colors.red.withOpacity(.1),
                            child: Text(
                              state.attendance[index].attendance ?? '',
                              style:
                                 AppTextStyle.font10w7.copyWith(
                                 color: state.attendance[index].attendance
                                            ?.toLowerCase()
                                            .contains("present") ==
                                        true
                                    ? Colors.green
                                    : Colors.redAccent,
                                )
                              //  TextStyle(
                              //   color: state.attendance[index].attendance
                              //               ?.toLowerCase()
                              //               .contains("present") ==
                              //           true
                              //       ? Colors.green
                              //       : Colors.redAccent,
                              //   fontSize: 10.sp,
                              //   fontWeight: FontWeight.w700,
                              // ),
                            ),
                                                    ),
                                                
                              ],
                            ),
                          ),
                        ),
                                     
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10.h);
                  },
                ),
        ),
      ],
    );
  }
}

var monthItems = [
  MyAttendanceHistoryScreenConstants.JAN.tr(),
  MyAttendanceHistoryScreenConstants.FEB.tr(),
  MyAttendanceHistoryScreenConstants.MAR.tr(),
  MyAttendanceHistoryScreenConstants.APR.tr(),
  MyAttendanceHistoryScreenConstants.MAY.tr(),
  MyAttendanceHistoryScreenConstants.JUN.tr(),
  MyAttendanceHistoryScreenConstants.JUL.tr(),
  MyAttendanceHistoryScreenConstants.AUG.tr(),
  MyAttendanceHistoryScreenConstants.SEP.tr(),
  MyAttendanceHistoryScreenConstants.OCT.tr(),
  MyAttendanceHistoryScreenConstants.NOV.tr(),
  MyAttendanceHistoryScreenConstants.DEC.tr(),
];
