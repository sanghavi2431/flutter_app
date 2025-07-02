


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/login/bloc/signup_state.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/login/view/choose_service.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/login/view/register.dart';
import 'package:woloo_smart_hygiene/client_flow/utils/client_images.dart';
import 'package:woloo_smart_hygiene/client_flow/widgets/CustomButton.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

import '../../../../screens/common_widgets/leading_button.dart';
import '../../../../utils/app_images.dart';
import '../../../widgets/CustomTextField.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/signup_event.dart';
import 'check_screen.dart';
import 'verify_otp.dart';

class ClientLogin extends StatefulWidget {
  const ClientLogin({super.key});

  @override
  State<ClientLogin> createState() => _ClientLoginState();
}

class _ClientLoginState extends State<ClientLogin> {

      SignupBloc loginBloc = SignupBloc();
      final TextEditingController passwordController = TextEditingController();
      final TextEditingController emailController = TextEditingController();
       final loginFormKey = GlobalKey<FormState>();
       
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leadingWidth: 100,
        leading: LeadingButton(),
      ),
      
      body: 
      SingleChildScrollView(
        child: Form(
          key: loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                SizedBox(
                height: 100.h,
               ),
              Padding(
               padding: const EdgeInsets.symmetric( horizontal: 16),
                child: Column(
                  children: [
                          const SizedBox(
                          height: 10,
                           ),
        
                      CustomImageProvider(
                       image: ClientImages.taskMaster,
                       width: double.infinity,
                       height: 195,

                      //  fit: BoxFit.fitWidth,
                      ),
                        const SizedBox(
                          height: 60,
                           ),
        
                 CustomTextField(
                controller: emailController,
                hintText: "Enter your Mobile No.",
                keyboardType: TextInputType.phone,
                // maxLength: 10,
                validator: validateMobile

                // prefixIcon: Icons.phone,
                                ),
                     const SizedBox(
                          height: 10,
                           ),
        
                //                 CustomTextField(
                // controller: passwordController,
                // hintText: "Enter your Password",
                // obscureText: true,
                // keyboardType: TextInputType.text,
                // // maxLength: 10,
                // validator: validatePassword
                // // prefixIcon: Icons.phone,
                //                 ),
        
                    const SizedBox(
                          height: 15,
                           ),
        
                           BlocConsumer<SignupBloc ,SignUpState>(
                             bloc: loginBloc,
                            listener: (context, state) {
                               print("states $state");
                              if ( state is SignUpLoading){
                                     EasyLoading.show(status: state.message);
                               }
        
                              if (state is LoginUser  ) {
                                   EasyLoading.dismiss();
                                  //  state.
                                   Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                       builder: (context) =>  VerifyOtp(
                                        phoneNumber: emailController.text,
                                        loginBloc: loginBloc,

                                       ),
                                     ),
                                        //  (route) => false,
                                   );
                              }
        
                               if(state is SignUpError  ){
                                 EasyLoading.dismiss();
                                 EasyLoading.showError( state.error);
        
                               }
        
                            },
                            builder: (context, state) {
        
        
                      return   GestureDetector(
                        onTap: () {
        
        
                          //          bool isValid =
                          //     loginFormKey.currentState?.validate() ?? false;
                          // if (!isValid) return;
        
                                   print("object ${loginFormKey.currentState?.validate() }");
        
                          // globalStorage.saveMobileNumber(
                          //     accessMobileNumber: controller.text  );
                          if (loginFormKey.currentState?.validate() ?? false) {
                            print("object");
                            loginBloc.add(Login(
                              mobileNo: emailController.text,
                              // password: passwordController.text,
                              ));
                          }

                          // debugPrint("Data: $data");

// ScaffoldMessenger.of(context).showSnackBar(
//   SnackBar(content: Text('Data: ${MediaQuery.of(context).size}')),
// );

        
        
        
                           },
                     child: Custombutton(
                      color: AppColors.buttonYellowColor,
                      text: "Send OTP", width: 300.w),
                   );
                            },
        
        
        
                            // listener: listener
        
        
                            ),
        
        
                             const SizedBox(
                              height: 25
                             ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Please read our",
                             style: AppTextStyle.font14bold,
                            ),
                             const SizedBox(
                              width: 5,
                             ),
                             GestureDetector(
                              onTap: (){
                                openPolicy();

                              //      Navigator.of(context).push( MaterialPageRoute(builder: (context) {
                              //  return const Register();
                              //     },));
                              },

                               child: Text("Privacy Policy",
                                         style: AppTextStyle.font14bold.copyWith(
                                         decoration: TextDecoration.underline,
                                     ),
                               ),
                             )
                          ],
                        ),
                             const SizedBox(
                              height: 10,
                             ),
                        // Text(LoginConstant.forgotPassword,
        
                        //  style: AppTextStyle.font14bold.copyWith(
                        //    decoration: TextDecoration.underline,
                        //  ),
                        // ),
                             const SizedBox(
                              height: 20,
                             ),
                            //  SizedBox(
                            //   width: MediaQuery.of(context).size.width/1.6,
                            //   child: Divider()),
                            //        const SizedBox(
                            //   height: 20,
                            //  ),
                    // Custombutton(
                    // color: AppColors.buttonYellowColor,
                    // text: LoginConstant.loginAsSupervisor, width: 300.w),
        
                  ],
                ),
              )
        
            ],
          ),
        ),
      ),
    );
  }


  static Future<void> openPolicy() async {

    final Uri googleMapsUrl = Uri.parse(
      'https://woloo.in/privacy-policy/',
    );
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not open privacy policy";
    }
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

 String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return "Email is required";
  }
  final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  if (!emailRegex.hasMatch(value)) {
    return "Enter a valid email";
  }
  return null;
}


  String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return "Password is required";
  }
  if (value.length < 6) {
    return "Password must be at least 6 characters";
  }
  return null;
}
}