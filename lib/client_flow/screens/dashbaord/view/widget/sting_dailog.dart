

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

import '../../../../../screens/common_widgets/image_provider.dart';
import '../../../../../utils/app_color.dart';
import '../../../../widgets/CustomButton.dart';

class StingDailog extends StatelessWidget {
   final String? image;
  final  String? title;
   final   String? subTitle;
   final String? button1text;
   final String? button2text;
   final VoidCallback? onButton1Tap;
  final VoidCallback? onButton2Tap;

  const StingDailog({super.key, this.image, this.subTitle, this.title, this.button1text, this.button2text, this.onButton1Tap, this.onButton2Tap});

  @override
  Widget build(BuildContext context) {
    return       AlertDialog(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(60),
       ),                 
                                  backgroundColor: AppColors.white,
                                  content:
                                  SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                         CustomImageProvider(
                                          image: image ,
                                          width: 86.w,
                                          height: 86.h,
                                         ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          title!,
                                         style: AppTextStyle.font18bold,
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                            GestureDetector(
                                          onTap:onButton1Tap, 
                                          child:  Custombutton(
                                            width: 300,
                                            text: button2text!,
                                          ),
                                        ),
                                       SizedBox(
                                          height: 20.h,
                                        ),

                                        GestureDetector(
                                          onTap:onButton2Tap,     
                                          child:  Custombutton(
                                            width: 300,
                                            text: button1text!,
                                          ),
                                        ),
                                            SizedBox(
                                          height: 20.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
  }
}