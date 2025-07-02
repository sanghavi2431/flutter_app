


import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';

class Custombutton extends StatelessWidget {
  final String text;
  final Color? color;
  final bool enabled;
  final double? width;
  final double? height;
  final Color? textColor;
  final Key? buttonkey;

  const Custombutton({
    super.key,
    required this.text,
    this.enabled = true,
    this.color,
    this.buttonkey,
   required this.width,
    this.height, this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: buttonkey,
      height: height ?? 35.h,
      width: width,
      // padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
      boxShadow: [
      BoxShadow(
        color: Colors.black.withValues( alpha: 0.2), // Shadow color
        spreadRadius: 1, // How wide the shadow should spread
        blurRadius: 10, // The blur effect of the shadow
        offset: const Offset(0, 5), // Shadow offset, with y-offset for bottom shadow
      ),
    ],
        color: enabled ? color ??  AppColors.backgroundColor : AppColors.disabledButtonColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: 
          AppTextStyle.font14w7.copyWith(
            fontSize: 
             MediaQuery.of(context).size.height < 640  ? 14  : 16,
            fontWeight: FontWeight.w700,
            color: textColor ?? AppColors.black, 
          )
          // TextStyle(
          //   fontWeight: FontWeight.w700,

          //   color: AppColors.black,
          //   fontSize: 16.sp,
          // ),
        ),
      ),
    );
  }
}
