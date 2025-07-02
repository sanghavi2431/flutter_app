



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/client_flow/utils/client_constant.dart';
import 'package:woloo_smart_hygiene/client_flow/utils/client_images.dart';
import 'package:woloo_smart_hygiene/client_flow/widgets/CustomButton.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

import '../../../../../../utils/app_color.dart';
import 'login_bottomsheet.dart';

class HostBottomsheet extends StatefulWidget {
  const HostBottomsheet({super.key});

  @override
  State<HostBottomsheet> createState() => _HostBottomsheetState();
}

class _HostBottomsheetState extends State<HostBottomsheet> {
  @override
  Widget build(BuildContext context) {
    return   Container(
             padding: const EdgeInsets.symmetric(horizontal: 16 ),
              height: MediaQuery.of(context).size.height/1.3,
             decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(80.0),
                      topRight: Radius.circular(80.0),
                    ),
                  ),
      child: Column(
        children: [
           const SizedBox(
                                height: 9,
                               ),
                               Center(
                                 child: CustomImageProvider(
                                  image: ClientImages.line,
                                  width: 70,
                                 ),
                               ),
           const SizedBox(
            height: 90,
           ),
      
           CustomImageProvider(
            image: ClientImages.msg,
           ),
      
             const SizedBox(
              height: 20,
             ),
      
              Text(ClientConstant.dearWolooHost,
              style: AppTextStyle.font20bold,
             ),
      
                 const SizedBox(
                  height: 20,
                 ),
      
      
               Text(
                 textAlign: TextAlign.center,
                ClientConstant.wolooOpportunityDescription,
                   style: AppTextStyle.font20bold,
              
              ),
      
               const Spacer(),
                 GestureDetector(
                   onTap: () {

                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context, builder: (context) {
                       return  LoginBottomsheet();
                    }, );
                     
                   },
                  child: const Custombutton(text: ClientConstant.iAmInterested, width:double.infinity)),
                     const SizedBox(
                  height: 20,
                 ),
      
        ],
      ),
    );
  }
}