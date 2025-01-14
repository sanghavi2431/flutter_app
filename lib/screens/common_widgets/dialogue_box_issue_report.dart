import 'package:Woloo_Smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:Woloo_Smart_hygiene/utils/app_textstyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Woloo_Smart_hygiene/screens/common_widgets/pop_up_buttons.dart';
import 'package:Woloo_Smart_hygiene/utils/app_color.dart';
import 'package:Woloo_Smart_hygiene/utils/app_constants.dart';
import 'package:Woloo_Smart_hygiene/utils/app_images.dart';

class DialogueWidget extends StatefulWidget {
 final String? title;
  const DialogueWidget({
    Key? key,
    this.title
  }) : super(key: key);

  @override
  State<DialogueWidget> createState() => _DialogueWidgetState();
}

class _DialogueWidgetState extends State<DialogueWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          25.r,
        ),
      ),
      child: SizedBox(
        width: 200.w,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 5.w,
            vertical: 20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                  ),
                  child: Center(
                    child:
                     CustomImageProvider(
                      image: 
                        AppImages.submittedIcon,
                      height: 70.h,
                      width: 70.w,
                     ),                 
                  )),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child:
                  widget.title!.isEmpty?
                  Text(
                    MyReportIssueScreenConstants.POP_UP_TEXT.tr(),
                    textAlign: TextAlign.center,
                    style: 
                    AppTextStyle.font14bold.copyWith(
                      color: AppColors.black,
                    )
                  )
                  : Text(
                      AssignScreenConstants.TASK_ASSIGN.tr(),
                  textAlign: TextAlign.center,
                  style:
                  AppTextStyle.font14bold.copyWith(
                    color: AppColors.black,
                  ))
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                  ),
                  child: PopUpButtonWidget(
                    text: DialogueReportIssueConstants.DONE.tr(),
                    color: AppColors.buttonYellowColor,
                    onTap: () {
                       if( widget.title!.isEmpty){
                         Navigator.pop(context);
                         // Navigator.pop(context);
                       }else{
                         Navigator.pop(context);
                         Navigator.pop(context);
                         Navigator.pop(context);

                       }

                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
