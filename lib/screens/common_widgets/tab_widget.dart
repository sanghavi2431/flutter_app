


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_color.dart';

class TabWidget extends StatelessWidget {
final   String? title;
  const TabWidget({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return 
       Container(
            //  width: 100.w,
             height: 27.h,
             alignment:
             Alignment.center,
             decoration:
             BoxDecoration(
               borderRadius:
               BorderRadius
                   .circular(
                   25.r),
               color: AppColors
                   .buttonBgColor,
             ),
             child: Padding(
                 padding: EdgeInsets
                     .symmetric(
                   horizontal:
                   15.w,
                   vertical: 1.h,
                 ),
                 child:
                  Text(title!,
                  
                               )
             ),
           );
          //  ,),
  }
}