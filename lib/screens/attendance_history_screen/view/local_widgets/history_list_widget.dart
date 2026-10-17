import 'package:woloo_smart_hygiene/screens/attendance_history_screen/bloc/history_list_bloc.dart';
import 'package:woloo_smart_hygiene/screens/attendance_history_screen/bloc/history_list_event.dart';
import 'package:woloo_smart_hygiene/screens/attendance_history_screen/data/model/attendance_history_model.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:bubble/bubble.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/local/global_storage.dart';

class HistoryListWidget extends StatefulWidget {
  final List<AttendanceHistoryModel> data;

  final Function onTapItem;
  const HistoryListWidget({
    super.key,
    required this.data,
    required this.onTapItem,
  });

  @override
  State<HistoryListWidget> createState() => _HistoryListWidgetState();
}

class _HistoryListWidgetState extends State<HistoryListWidget> {
  int selectedCard = -1;
  final HistoryListBloc _historyListBloc = HistoryListBloc();
  GlobalStorage globalStorage = GetIt.instance();
  bool? isChecked;
  DateTime? date;
  @override
  void initState() {
    super.initState();
    //globalStorage.saveCheckIn(isCheckedIn: true);

    isChecked = globalStorage.isCheckedIn();
    date = DateTime.now();
  }

  String _translateAttendance(String attendance) {
    if (attendance.toLowerCase() == "absent") {
      return "absent".tr();
    } else if (attendance.toLowerCase() == "present") {
      return "present".tr();
    }
    return attendance;
  }

  String _translateDayOfWeek(String dayOfWeek) {
    final day = dayOfWeek.toLowerCase();
    if (day == "sun" || day == "sunday") {
      return "Sunday".tr();
    } else if (day == "mon" || day == "monday") {
      return "Monday".tr();
    } else if (day == "tue" || day == "tuesday") {
      return "Tuesday".tr();
    } else if (day == "wed" || day == "wednesday") {
      return "Wednesday".tr();
    } else if (day == "thu" || day == "thursday") {
      return "Thursday".tr();
    } else if (day == "fri" || day == "friday") {
      return "Friday".tr();
    } else if (day == "sat" || day == "saturday") {
      return "Saturday".tr();
    }
    return dayOfWeek;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(
          const Duration(seconds: 1),
          () {
            _historyListBloc
                .add(const GetAllHistory(month: '10', year: '2023'));
          },
        );
      },
      color: AppColors.buttonColor,
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: widget.data.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (
            BuildContext context,
            int index,
          ) {
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
              ),
              child: GestureDetector(
                onTap: () {
                  widget.onTapItem(widget.data[index]);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 5.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          minWidth: 46.w,
                          maxWidth: 60.w,
                          minHeight: 46.h,
                          maxHeight: 66.h,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 11.0,
                                spreadRadius: 0,
                                offset: Offset(1, 1),
                                color: AppColors.greyShadow,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.buttonBgColor),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                widget.data[index].date ?? '',
                                style: AppTextStyle.font16bold.copyWith(
                                  color: AppColors.historyText,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Flexible(
                              child: Text(
                                widget.data[index].dayOfWeek != null
                                    ? _translateDayOfWeek(
                                        widget.data[index].dayOfWeek!)
                                    : '',
                                style: AppTextStyle.font12bold.copyWith(
                                  color: AppColors.historyText,
                                  fontSize: 9.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 4.w),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      Expanded(
                        child: Bubble(
                          radius: const Radius.circular(25.0),
                          elevation: 5,
                          nipWidth: 14,
                          // margin: BubbleEdges.only(top: 10),
                          nip: BubbleNip.leftCenter,
                          color: const Color(0xffFFBBBB),
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          MydashboardScreenConstants.CHECK_IN
                                              .tr(),
                                          style: AppTextStyle.font16.copyWith(
                                            color: AppColors.historyText,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Flexible(
                                        child: Text(
                                          " ${widget.data[index].checkIn ?? '-'}",
                                          style: AppTextStyle.font13.copyWith(
                                            color: AppColors.lightGreyText,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          MydashboardScreenConstants.CHECK_OUT
                                              .tr(),
                                          style: AppTextStyle.font16.copyWith(
                                            color: AppColors.historyText,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Flexible(
                                        child: Text(
                                          widget.data[index].checkOut ?? '-',
                                          style: AppTextStyle.font13.copyWith(
                                            color: AppColors.lightGreyText,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Center(
                                    child: date!.day.toString() ==
                                                widget.data[index].date &&
                                            isChecked! &&
                                            widget.data[index].attendance ==
                                                "Absent"
                                        ? Text(
                                            "clockedIn".tr(),
                                            style: AppTextStyle.font13w7
                                                .copyWith(
                                              color: widget.data[index]
                                                          .attendance ==
                                                      "Present"
                                                  ? AppColors.greenBold
                                                  : AppColors.redBold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          )
                                        : Text(
                                            _translateAttendance(widget
                                                    .data[index].attendance ??
                                                ''),
                                            style: AppTextStyle.font13w7
                                                .copyWith(
                                              color: widget.data[index]
                                                          .attendance ==
                                                      "Present"
                                                  ? AppColors.greenBold
                                                  : AppColors.redBold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
