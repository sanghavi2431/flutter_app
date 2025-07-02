


import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_textstyle.dart';

class AssignSuccefully extends StatefulWidget {
  final  List<String>  assignTask;
  final  String  janitorName;
  const AssignSuccefully({super.key, required this.assignTask, required this.janitorName});

  @override
  State<AssignSuccefully> createState() => _AssignSuccefullyState();
}

class _AssignSuccefullyState extends State<AssignSuccefully> {
  @override
  Widget build(BuildContext context) {
    return  
      Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding:  const EdgeInsets.all(16.0),
        child: Column(
           children: [
               SizedBox(
                 height: 100.h,
               ),
               CustomImageProvider(
                image: AppImages.submittedIcon,
                   color: AppColors.greenText,
               ),
              SizedBox(
                height: 20.h,
              ),

             Text("Successfully assign ${widget.assignTask.length} tasks to ${widget.janitorName}",
             textAlign: TextAlign.center, style:
              AppTextStyle.font16.copyWith(
               color:AppColors.black, 
              )
        
             ),

             SizedBox(
               height: 20.h,
             ),

             GestureDetector(
               onTap: ()  {

                  Navigator.of(context).pop();
                  Navigator.of(context).pop();


               },
               child: Container(
                 height: 32.h,
                 padding: EdgeInsets.symmetric(horizontal: 15.w),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(8.r),
                   color: AppColors.buttonColor,
                 ),
                 child: Center(
                   child: Text(
                     MyFacilityListConstants.GOBACK.tr(),
                     textAlign: TextAlign.center,
                     style:
                       AppTextStyle.font16w7.copyWith(
                       color:AppColors.black, )
                   ),
                 ),
               ),
             )

           ],
        ),
      ),
     );
  }
}