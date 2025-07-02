import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';

class PopUpButtonWidget extends StatefulWidget {
  final String text;
  final Color color;
  final Function onTap;

  const PopUpButtonWidget(
      {super.key, required this.text, required this.color, required this.onTap});

  @override
  State<PopUpButtonWidget> createState() => _PopUpButtonWidgetState();
}

class _PopUpButtonWidgetState extends State<PopUpButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        height: 40.h,
        width: 100.w,

        padding: EdgeInsets.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
               boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2), // Shadow color
                          spreadRadius: 1, // How wide the shadow should spread
                          blurRadius: 10, // The blur effect of the shadow
                          offset: const Offset(0,
                              5), // Shadow offset, with y-offset for bottom shadow
                        ),
                      ],

            borderRadius: BorderRadius.circular(25.r), color: widget.color),
        child: Center(
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: 
            AppTextStyle.font14w7.copyWith(
               color: AppColors.black,
            )
            // TextStyle(
            //   fontWeight: FontWeight.w700,
            //   color: AppColors.black,
            //   fontSize: 14.sp,
            // ),
          ),
        ),
      ),
    );
  }
}
