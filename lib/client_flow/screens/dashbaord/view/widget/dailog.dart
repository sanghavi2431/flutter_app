




import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/client_flow/utils/client_images.dart';

import '../../../../../screens/common_widgets/image_provider.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_textstyle.dart';
import '../../../../widgets/CustomButton.dart';

class Dailog extends StatelessWidget {
   final String? image;
  final  String? title;
   final   String? subTitle;
  const Dailog({super.key, this.title, this.subTitle, this.image});

  @override
  Widget build(BuildContext context) {
    return  
        AlertDialog(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(60),
       ),                 
                                  backgroundColor: AppColors.white,
                                   content:
                                  SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,

// mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                             SizedBox(
                                          height: 10,
                                        ),
                                        image!.isEmpty ? 
                                         SizedBox():
                                         CustomImageProvider(
                                          image: image ?? ClientImages.warning,
                                          width: 86.w,
                                          height: 86.h,
                                         ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          title!,
                                         style: AppTextStyle.font18bold.copyWith(
                                          fontSize: 18
                                         ),
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            // showModalBottomSheet(context: context, builder:
                                            //  (context) {
                                            //     return SubcriptionScreen();
                                            //  },
                                            // );
                                          },
                                          child:  Custombutton(
                                            width: 300,
                                            text: subTitle! ?? "Go Back",
                                          ),
                                        ),
                                            SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
  }
}