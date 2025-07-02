


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/login/view/login.dart';
import 'package:woloo_smart_hygiene/client_flow/widgets/CustomButton.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

import '../../../../utils/app_constants.dart';
import '../../../../utils/app_images.dart';

class TermScreen extends StatefulWidget {
  const TermScreen({super.key});

  @override
  State<TermScreen> createState() => _TermScreenState();
}

class _TermScreenState extends State<TermScreen> {
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(

        child: Column(
          children: [
            ListTile(
             leading:  CustomImageProvider(
              image: AppImages.termIcons,
             ),
             title:   Text(TermsOfUse.title,
             style: AppTextStyle.font18bold,
             ),  
             subtitle:  Text(TermsOfUse.subTitle,
             style: AppTextStyle.font12,
             ) ,
            ),
           const SizedBox(
            height: 10,
              ),
            Padding(
             padding: const EdgeInsets.symmetric( horizontal: 15),
             child: Text(TermsOfUse.content,
              style: AppTextStyle.font14,
             ),
           ),
          ],
        ),

        
      ),
      floatingActionButton:     Padding(
        padding:  EdgeInsets.only(left: 24.sp ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Custombutton(
              width: 151.w,
              text: TermsOfUse.deny,
               color: AppColors.white,
               ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push( MaterialPageRoute(builder:(context) {
                     return const ClientLogin();
                  }, ));
                },
                child: Custombutton(
                
                    width: 151.w,
                  text: TermsOfUse.accept ),
              )
          ],
        ),
      ) , 
      
        // bottomNavigationBar:
      
      // persistentFooterAlignment: AlignmentDirectional.bottomEnd,
    );
  }
}