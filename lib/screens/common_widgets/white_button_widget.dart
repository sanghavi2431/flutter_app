import 'package:Woloo_Smart_hygiene/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Woloo_Smart_hygiene/utils/app_color.dart';

class WhiteButtonWidget extends StatefulWidget {
  final String text;
  final Color color;
  final Function onTap;

  const WhiteButtonWidget({
    Key? key,
    required this.text,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  State<WhiteButtonWidget> createState() => _WhiteButtonWidgetState();
}

class _WhiteButtonWidgetState extends State<WhiteButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        height: 36.h,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow:   [  BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            spreadRadius: 1, // How wide the shadow should spread
            blurRadius: 10, // The blur effect of the shadow
            offset: Offset(0, 5), // Shadow offset, with y-offset for bottom shadow
          ),
          ],
        ),
        child: Center(
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style:
            AppTextStyle.font16bold.copyWith(
               color: AppColors.black,
            )
            //  TextStyle(
            //   fontWeight: FontWeight.w700,
            //   color: AppColors.black,
            //   fontSize: 16.sp,
            // ),
          ),
        ),
      ),
    );
  }
}
