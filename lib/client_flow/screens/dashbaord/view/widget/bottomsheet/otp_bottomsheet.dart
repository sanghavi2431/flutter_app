import 'package:flutter/material.dart';

import '../../../../../../screens/common_widgets/image_provider.dart';
import '../../../../../../screens/login/view/local_widgets/otp_widget.dart';
import '../../../../../../utils/app_color.dart';
import '../../../../../../utils/app_textstyle.dart';
import '../../../../../utils/client_constant.dart';
import '../../../../../utils/client_images.dart';
import '../../../../../widgets/CustomButton.dart';
import 'loohost_bottomsheet.dart';

class OtpBottomsheet extends StatefulWidget {
  const OtpBottomsheet({super.key});

  @override
  State<OtpBottomsheet> createState() => _OtpBottomsheetState();
}

class _OtpBottomsheetState extends State<OtpBottomsheet> {
   String _pin = '';
 
  @override
  Widget build(BuildContext context) {
    return Container(
          //  padding: const EdgeInsets.symmetric(horizontal: 16 ),
              height: MediaQuery.of(context).size.height/3.1,
             decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(80.0),
                      topRight: Radius.circular(80.0),
                    ),
                  ),
      child:   Column(
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
                             height: 20,
                            ),
      
              Text(ClientConstant.pleaseEnterOtp,
              style: AppTextStyle.font20bold,
             ),
      
                 const SizedBox(
                  height: 20,
                 ),
                     OTPWidget(
                      phoneNumber: "",
                      onComplete: (pin) => _pin = pin,
                      ),      

                  const Spacer(),

                  Padding(
                   padding: const EdgeInsets.symmetric( horizontal: 16),
                   child: 
                   GestureDetector(
                     onTap: () {
                     showModalBottomSheet(
                           isScrollControlled: true,
                         backgroundColor: Colors.transparent,
                         context: context,
                         builder: (context) {
                           return LoohostBottomsheet();
                         },
                       );
                     },
                     child: Custombutton(text: ClientConstant.submit, width: double.infinity),
                   ),
                 ),
                 const SizedBox(
                   height: 20,
                 ),
          
        ],
      ),
    ) ;
  }
}