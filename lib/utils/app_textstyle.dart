import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_color.dart';

class AppTextStyle {
  static TextStyle font24 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w400,
    // color: AppColors.yellowSplashColor,
  );

  static TextStyle font20 = TextStyle(
    overflow: TextOverflow.visible,
    color: AppColors.appBarTitleColor,
    fontSize: 19.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle font18 = TextStyle(
    // color: AppColors.historyText,
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle font16 = TextStyle(
    //  color: AppColors.historyText,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle font15 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 15.sp,
    color: AppColors.imageScreenGreyColor,
  );

  static TextStyle font14 = TextStyle(
    color: AppColors.clusterTitleColor,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle font14w600 = TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.darkGreyText);

  static TextStyle font13 = TextStyle(
    // color: AppColors.lightGreyText,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle font12 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.locationColor,
  );

  static TextStyle font10 = TextStyle(
    color: AppColors.listTitleColor,
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle font8 = TextStyle(
    fontSize: 8.sp, fontWeight: FontWeight.w400,
    //color: AppColors.timeColor
  );

  // 500  weight

  static TextStyle font20w5 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20.sp,
    // color: AppColors.black,
  );

  static TextStyle font16w5 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle font14w5 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
    color: AppColors.greyText,
  );

  static TextStyle font12w5 = TextStyle(
    // color: AppColors.ListTitleColor,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
  );

  // 600 weight

  static TextStyle font10w6 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static TextStyle font12w6 = TextStyle(
    // color: getColorByStatus(_data[index].status ?? ''

    // ),
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle font13w6 = TextStyle(
    color: AppColors.listTitleColor,
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
  );

  static TextStyle font14w6 = TextStyle(
    color: AppColors.redTextColor,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle font16w6 = TextStyle(
    //  color: AppColors.black,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  );

  // 700 weight

  static TextStyle font16w7 = TextStyle(
    color: AppColors.historyText,
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle font14w7 = TextStyle(
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    fontSize: 14.sp,
  );

  static TextStyle font13w7 = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle font12w7 = TextStyle(
      color: AppColors.white, fontSize: 12.sp, fontWeight: FontWeight.w700);

  static TextStyle font10w7 = TextStyle(
    //    color: state.attendance[index].attendance?.toLowerCase().contains("present") == true ? Colors.green : Colors.redAccent,
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle font24bold = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    // color: AppColors.yellowSplashColor,
  );

   static TextStyle font32bold = TextStyle(
    fontSize: 29.sp,
    fontWeight: FontWeight.bold,
    // color: AppColors.yellowSplashColor,
  );

  static TextStyle font16bold = TextStyle(
    // color: AppColors.historyText,
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle font14bold = TextStyle(
    color: AppColors.clusterTitleColor,
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle font12bold = TextStyle(
      color: AppColors.black, fontSize: 12.sp, fontWeight: FontWeight.bold );

  static TextStyle font10bold = TextStyle(
      color: AppColors.black, fontSize: 10.sp, fontWeight: FontWeight.bold );

  static TextStyle font18bold = TextStyle(
    // color: AppColors.historyText,
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle font20bold = TextStyle(
    overflow: TextOverflow.visible,
    color: AppColors.appBarTitleColor,
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
  );
}
