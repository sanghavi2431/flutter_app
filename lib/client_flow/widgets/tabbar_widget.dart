import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/client_model.dart';
import 'package:woloo_smart_hygiene/client_flow/utils/client_images.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';

import '../../utils/app_color.dart';

class TabbarWidget extends StatelessWidget {
  final   int? id;
  final  String? title;
  const TabbarWidget({super.key, this.title, this.id});

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
                   5.r),
               color: AppColors
                   .buttonYellowColor,
             ),
             child: Padding(
                 padding: EdgeInsets
                     .symmetric(
                   horizontal:
                   15.w,
                   vertical: 1.h,
                 ),
                 child:
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      
                       Text(title!,),

                          id == 0 ?
                       const SizedBox(
                        width: 20,
                       )
                        : const SizedBox()
                       ,

                        id == 0 ?

                       CustomImageProvider(
                        image: ClientImages.more,
                        width: 16,
                        height: 16,
                       )

                       : const SizedBox()
                      //  Icon(Icons.add),

                    ],
                  )
             ),
           );
  }
}