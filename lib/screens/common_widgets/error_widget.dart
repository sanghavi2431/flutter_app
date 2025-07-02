import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class CustomErrorWidget extends StatelessWidget {
  final String error;

  const CustomErrorWidget({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: LottieBuilder.network(
              "https://lottie.host/446f25e2-23c0-4d1c-af48-b16f3e362f06/Z9RcyzQf5S.json",
              width: 200.w,
              repeat: false,
            ),
          ),
          Center(
            child: Text(
              ErrorWidgetConstants.ERROR.tr(),
              style: 
              AppTextStyle.font20.copyWith(
                 color: Colors.redAccent,
                fontWeight: FontWeight.bold,)
              // TextStyle(
              //   color: Colors.redAccent,
              //   fontSize: 20.sp,
              //   fontWeight: FontWeight.bold,
              //   letterSpacing: 1,
              // ),
            ),
          ),
          Center(
            child: Text(
              error,
              style: const TextStyle(
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
