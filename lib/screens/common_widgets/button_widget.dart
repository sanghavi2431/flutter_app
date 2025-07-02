import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final Color? color;
  final bool enabled;

  const ButtonWidget({
    super.key,
    required this.text,
    this.enabled = true,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
      boxShadow: [
      BoxShadow(
        color: Colors.black.withValues( alpha: 0.2), // Shadow color
        spreadRadius: 1, // How wide the shadow should spread
        blurRadius: 10, // The blur effect of the shadow
        offset: const Offset(0, 5), // Shadow offset, with y-offset for bottom shadow
      ),
    ],
        color: enabled ? color ??  AppColors.buttonColor : AppColors.disabledButtonColor,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: 
          AppTextStyle.font16w7.copyWith(
            color: AppColors.black, 
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
