import 'package:Woloo_Smart_hygiene/utils/app_textstyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Woloo_Smart_hygiene/screens/common_widgets/pop_up_buttons.dart';
import 'package:Woloo_Smart_hygiene/utils/app_color.dart';

import '../../utils/app_constants.dart';

class CustomDialogueWidget extends StatefulWidget {
  final String text;
  final Function onTapSubmit;
  final Function onTapCancel;

  const CustomDialogueWidget({
    Key? key,
    required this.text,
    required this.onTapSubmit,
    required this.onTapCancel,
  }) : super(key: key);

  @override
  State<CustomDialogueWidget> createState() => _CustomDialogueWidgetState();
}

class _CustomDialogueWidgetState extends State<CustomDialogueWidget> {
  bool cancelButtonTap = false;
  bool yesButtonTap = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10.r,
        ),
      ),
      child: SizedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.text,
                textAlign: TextAlign.center,
                style:
                 AppTextStyle.font16.copyWith(
                    color: AppColors.black,
                 )
                //  TextStyle(
                //   fontWeight: FontWeight.w400,
                //   fontSize: 16.sp,
                //   color: AppColors.black,
                // ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PopUpButtonWidget(
                      text: MyFacilityListConstants.POPUP_CANCEL_BUTTON.tr(),
                      color: cancelButtonTap
                          ? AppColors.buttonColor
                          : AppColors.white,
                      onTap: () {
                        widget.onTapCancel();
                        setState(
                          () {
                            cancelButtonTap = true;
                            yesButtonTap = false;
                          },
                        );
                      },
                    ),
                    PopUpButtonWidget(
                      text: MyFacilityListConstants.POPUP_YES_BUTTON.tr(),
                      color: yesButtonTap
                          ? AppColors.buttonColor
                          : AppColors.white,
                      onTap: () {
                        widget.onTapSubmit();
                        setState(() {
                          yesButtonTap = true;
                          cancelButtonTap = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
