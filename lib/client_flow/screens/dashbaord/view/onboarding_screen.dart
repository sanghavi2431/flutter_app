


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/login/view/login.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_textstyle.dart';
import '../../../widgets/CustomButton.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
       body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, 
        children: [
           Text(
            textAlign: TextAlign.center, 
            "Monitor, Manage & Monetize your Toilets!",
            style: AppTextStyle.font32bold,
           ),

                         GestureDetector(
                          onTap: (){
                            Navigator.of(context).push( MaterialPageRoute(builder: (context) {
                               return const ClientLogin();
                            }, ) );
                          },
                           child: Custombutton(
                            width: 328.w,
                            color:AppColors.white,
                            text: MyLoginConstants.NEXT.tr(),
                       ),
                         ),
        ],
       ),
    );
  }
}