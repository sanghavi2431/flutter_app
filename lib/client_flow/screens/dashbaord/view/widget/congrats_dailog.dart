


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/client_flow/widgets/CustomButton.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:woloo_smart_hygiene/screens/dashboard/view/regular_task.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../utils/client_images.dart';
import '../dashboard.dart';
import 'select_buddy_dailog.dart';

class CongratsDailog extends StatelessWidget {
    String buddyName;
  CongratsDailog({super.key, required this.buddyName});
  // const CongratsDailog({super.key});
  @override
  Widget build(BuildContext context) {
    return  
    
    AlertDialog(
                 backgroundColor: AppColors.white,

                 title:  Center(
                   child: Text(DashboardConst.congratulations,
                    style: AppTextStyle.font20bold,
                   ),
                 ),
                 content:   SingleChildScrollView(
                   child: ListBody(
                     children: <Widget>[
                       
                        CustomImageProvider(
                          image: ClientImages.celebration,
                          width: 145,
                          height: 145,
                        ),
                       // Text(DashboardConst.scheduleTask,
                       //   style: AppTextStyle.font14w7,
                       // ),
                       SizedBox(
                         height: 20.h,
                       ),
                      
                       Text(
                          textAlign: TextAlign.center,
                         "You have assigned the Task to [Task Buddy Name]",
                        style: AppTextStyle.font14w7,
                       ),

                     SizedBox(
                       height: 20.h,
                     ),

                     GestureDetector(
                       onTap: () {
                          showDialog(context: context, builder: (context) =>  const SelectBuddyDailog(), );
                       },
                       child: Custombutton(
                            height: 30.h,
                           text:DashboardConst.addAnotherTask , width: 320.w ),
                     ),
                      
                      SizedBox(
                        height: 20.h,
                      ),
                     

                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push( MaterialPageRoute(builder: (context) {
                               return  ClientDashboard(
                                dashIndex: 1,
                               );
                            }, ) );
                          },
                          child: Custombutton(
                              height: 30.h,
                              text:DashboardConst.noThanks , width: 320.w ),
                        ),
                       SizedBox(
                         height: 10.h,
                       ),
                  

                     ],
                   ),
                 ),
                
               );
    
  }
}