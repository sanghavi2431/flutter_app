
import 'package:flutter/material.dart';

import '../../screens/common_widgets/image_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_textstyle.dart';
import '../utils/client_images.dart';

class ExploreCard extends StatelessWidget {
  String? title;
  String? subTitle;
  String? description;
  String? description1;
   String? img;
 final GestureTapCallback? onTap;

   ExploreCard({super.key, this.title, this.subTitle, this.description, this.description1, this.onTap, this.img});

  @override
  Widget build(BuildContext context) {
    return  Container(
                     padding: const EdgeInsets.symmetric(vertical: 25 , horizontal: 22),
                    // height: 165.h,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues( alpha: 0.2), // Shadow color
            spreadRadius: 1, // How wide the shadow should spread
            blurRadius: 10, // The blur effect of the shadow
            offset: const Offset(0, 5), // Shadow offset, with y-offset for bottom shadow
          ),
              ],
                      
                      borderRadius:  BorderRadius.circular(30)
            
                    ),
          
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
          
                      children: [
            
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                       
                            Row(
                              children: [
                                Text(title!,
                                  
                                  //"TASQ",
                                style: AppTextStyle.font20bold.copyWith(
                                  fontWeight: FontWeight.bold
                                ),
                                ),
                               Text(subTitle!,
                                
                                //"MASTER",
                                style: AppTextStyle.font20,
                                ),
                              ],
                            ),
                             const SizedBox(
                               height: 10,
                             ),
          
                            Text(
                              description!,
                              // textAlign: TextAlign.center,
                            //  "Monitor your hygiene with Woloo’s",
                              style: AppTextStyle.font12bold.copyWith(
                                color: AppColors.greyBorder,
                                 fontSize: 12,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                             const SizedBox(
                              height: 5,
                            ),
                               Text(
                                description1!,
                              // textAlign: TextAlign.center,
                              // "Smart Hygiene Technology Service.",
                              style: AppTextStyle.font12bold.copyWith(
                                color: AppColors.greyBorder,
                                fontSize: 12,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
          
          
                            GestureDetector(
                              onTap: onTap!,
                            
                              child: Container(
                                width: 178,
                                height: 38,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues( alpha: 0.2), // Shadow color
                                      spreadRadius: 1, // How wide the shadow should spread
                                      blurRadius: 10, // The blur effect of the shadow
                                      offset: const Offset(0, 5), // Shadow offset, with y-offset for bottom shadow
                                    ),
                                  ],
                                  color: const Color(0xffFFEB00),
                                  borderRadius: BorderRadius.circular(6)
                                  
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                              
                                                       Text("Explore",
                                                             style: AppTextStyle.font16bold.copyWith(
                                                               color: AppColors.black
                                                             ),
                                                            ) ,
                              
                                  CustomImageProvider(
                                    image: ClientImages.arrow,
                                    width: 34,
                                   ),
                              
                                  ],
                                ),
                              ),
                            )
                            
                           
                          ],
                        ),
                        CustomImageProvider(
                          image:img,
                          // AppImages.dashboard,
                         height: 89,
                         width: 80,
                   //     height: 119,
                 //         width: 55,
                        )
            
                      ],
                    ),
                   ); 
  }
}