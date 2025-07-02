



import 'package:flutter/material.dart';

import '../../../../../../screens/common_widgets/image_provider.dart';
import '../../../../../../utils/app_color.dart';
import '../../../../../../utils/app_constants.dart';
import '../../../../../../utils/app_textstyle.dart';
import '../../../../../utils/client_constant.dart';
import '../../../../../utils/client_images.dart';
import '../../../../../widgets/CustomButton.dart';
import '../../../../../widgets/CustomTextField.dart';
import 'otp_bottomsheet.dart';

class LoginBottomsheet extends StatefulWidget {
  const LoginBottomsheet({super.key});

  @override
  State<LoginBottomsheet> createState() => _LoginBottomsheetState();
}

class _LoginBottomsheetState extends State<LoginBottomsheet> {
  final TextEditingController mobileController = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    return Container(
          //  padding: const EdgeInsets.symmetric(horizontal: 16 ),
              height: MediaQuery.of(context).size.height/3.8,
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
      
              Text(ClientConstant.login,
              style: AppTextStyle.font20bold,
             ),
      
                 const SizedBox(
                  height: 20,
                 ),

                                 CustomTextField(
                  controller: mobileController,
                  hintText:SignUpConstant.mobileNo,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  validator: validateMobile
                
                  // prefixIcon: Icons.phone,
                ), 
             
                

                  const Spacer(),
                  Padding(
                   padding: const EdgeInsets.symmetric( horizontal: 16),
                   child: GestureDetector(
                     onTap: () {
                       showModalBottomSheet(
                         backgroundColor: Colors.transparent,
                        context: context, builder:  (context) {
                         return OtpBottomsheet();
                       }, );
                     },
                    child: const Custombutton(text: ClientConstant.next, width:double.infinity)),
                 ),
                     const SizedBox(
                  height: 20,
                 ),
          
        ],
      ),
    ) ;
  }

  String? validateMobile(String? value) {
  if (value == null || value.isEmpty) {
    return "Mobile number is required";
  }
  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
    return "Enter a valid 10-digit number";
  }
  return null;
}
}