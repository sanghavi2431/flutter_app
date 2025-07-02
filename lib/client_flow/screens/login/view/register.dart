


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:woloo_smart_hygiene/client_flow/utils/client_images.dart';

import '../../../../screens/common_widgets/image_provider.dart';
import '../../../../screens/common_widgets/leading_button.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_textstyle.dart';
import '../../../widgets/CustomButton.dart';
import '../../../widgets/CustomTextField.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/signup_event.dart';
import '../bloc/signup_state.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final loginFormKey = GlobalKey<FormState>();
   SignupBloc loginBloc = SignupBloc();
final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController mobileController = TextEditingController();
// final TextEditingController addressController = TextEditingController();
// final TextEditingController cityController = TextEditingController();
final TextEditingController pincodeController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();
 TextEditingController  cityController = TextEditingController();
  TextEditingController  addressController = TextEditingController();
   FocusNode addressFocusNode = FocusNode();
    FocusNode cityFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      backgroundColor: AppColors.backgroundColor,
         appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leadingWidth: 100,
        leading: const LeadingButton(),
      ),
      body:    SingleChildScrollView(
        child: 
        Form(
       key: loginFormKey,
          child: Column(
            children: [
      //          AppBar(
      //   backgroundColor: AppColors.backgroundColor,
      //   leadingWidth: 100,
      //   leading: const LeadingButton(),
      // ),
             
              //  const SizedBox(
              //   height: 10,
              //  ),
              Padding(
               padding: const EdgeInsets.symmetric( horizontal: 16), 
                child: Container(
                  // width: 380.w,
                  // height: 600.h,
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(60),
                  //
                  //   color: AppColors.white
                  // ),
                  child:  Column(
                    children: [
                            const SizedBox(
                            height: 0,
                             ),
                
                        CustomImageProvider(
                         image: ClientImages.woloologo,
                         width: 185,
                         height: 203,
                         fit: BoxFit.cover,
                        ),
                          const SizedBox(
                            height: 10,
                             ),
                
                 CustomTextField(
                  controller: nameController,
                  hintText: SignUpConstant.name,
                  keyboardType: TextInputType.emailAddress,
                  // maxLength: 10,
                  validator: validateName
                  // prefixIcon: Icons.phone,
                ),
                       const SizedBox(
                            height: 10,
                             ),
          
                CustomTextField(
                  controller: emailController,
                  hintText: SignUpConstant.email,
                  keyboardType: TextInputType.text,
                  // maxLength: 10,
                  validator: validateEmail
                
                  // prefixIcon: Icons.phone,
                ), 
          
                     const SizedBox(
                            height: 10,
                             ),
          
                CustomTextField(
                  controller: mobileController,
                  hintText:SignUpConstant.mobileNo,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  validator: validateMobile
                
                  // prefixIcon: Icons.phone,
                ), 
                      const SizedBox(
                            height: 10,
                             ),
                               Padding(
                                 padding:  EdgeInsets.symmetric(horizontal: 16.w ,vertical: 5.h),
                                 child: Container(
                                  // height: 36.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2), // Shadow color
                                      spreadRadius: 1, // Spread effect
                                      blurRadius: 10, // Blur effect
                                      offset: const Offset(0, 5), // Bottom shadow
                                    ),
                                  ],
                                                               ),
                                  child: GooglePlaceAutoCompleteTextField(
                                    placeType: PlaceType.address,
                                    focusNode: addressFocusNode,
                                    textEditingController:addressController,
                                    googleAPIKey:"AIzaSyCkPmUz4UlRdzcKG9gniW9Qfrgzsjhnb_4",
                                    inputDecoration:  InputDecoration(
                                      contentPadding:  const EdgeInsets.symmetric(vertical: 12.0 , horizontal: 5 ),
                                      hintText: SignUpConstant.address,
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700
                                          ),
                                       border: OutlineInputBorder(
                                       borderRadius: BorderRadius.circular(0),
                                       borderSide: BorderSide.none,
                                       ),
                                       fillColor: AppColors.white,
                                       filled: true,
                                      //  enabled: facilitydropdownNames.isNotEmpty ? false :true
                                      // enabledBorder: InputBorder.none,
                                    ),
                                 
                                    validator: 
                                    (value, p1) {
                                 
                                         setState((){});
                                        //  print("val $valu");
                                 
                                          // FocusManager.instance.primaryFocus?.unfocus();
                                        if (value == null || value.isEmpty) {
                                            return "Address is required";
                                          }
                                          if (value.length < 5) {
                                            return "Address must be at least 5 characters";
                                          }
                                    }, 
                                    // debounceTime: 400,
                                    countries: ["in", "fr"],
                                    isLatLngRequired: true,
                                    getPlaceDetailWithLatLng: (Prediction prediction) {
                                 
                                 
                                      print("placeDetails" + prediction.lat.toString());
                                    },
                                 
                                    itemClick: (Prediction prediction) {
                                      //   loc = prediction;
                                 
                                 
                                      addressController.text = prediction.description ?? "";
                                      // locationController.selection = TextSelection.fromPosition(
                                      //     TextPosition(offset: prediction.description?.length ?? 0));
                                    },
                                 
                                    // seperatedBuilder: const Divider(),
                                    containerHorizontalPadding: 10,
                                    // OPTIONAL// If you want to customize list view item builder
                                    itemBuilder: (context, index, Prediction prediction) {
                                 
                                      // prediction.id!.isNotEmpty ?
                                 
                                        //  facilityFocusNode!.unfocus();
                                 
                                 
                                      return Container(
                                        color: AppColors.white,
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.location_on),
                                            const SizedBox(
                                              width: 7,
                                            ),
                                            Expanded(child: Text("${prediction.description ?? ""}"))
                                          ],
                                        ),
                                      );
                                    },
                                 
                                    // isCrossBtnShown: facilitydropdownNames.isNotEmpty ? false : true,
                                 
                                 
                                   formSubmitCallback: () {
                                      print("dgd");
                                   },
                                 
                                    // default 600 ms ,
                                  ),
                                                               ),
                               ),         
          
                // CustomTextField(
                //   controller: addressController,
                //   hintText: SignUpConstant.address,
                //   keyboardType: TextInputType.text,
                //   // maxLength: 10,
                //   validator: 
                //   validateAddress
                //   // prefixIcon: Icons.phone,
                // ), 
                      const SizedBox(
                            height: 10,
                             ),
          
                               Padding(
                                 padding:  EdgeInsets.symmetric(horizontal: 16.w ,vertical: 5.h),
                                 child: Container(
                                  // height: 36.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2), // Shadow color
                                      spreadRadius: 1, // Spread effect
                                      blurRadius: 10, // Blur effect
                                      offset: const Offset(0, 5), // Bottom shadow
                                    ),
                                  ],
                                                               ),
                                  child: GooglePlaceAutoCompleteTextField(
                                    placeType: PlaceType.cities,
                                    focusNode: cityFocusNode,
                                    textEditingController:cityController,
                                    googleAPIKey:"AIzaSyCkPmUz4UlRdzcKG9gniW9Qfrgzsjhnb_4",
                                    inputDecoration:  InputDecoration(
                                      contentPadding:  const EdgeInsets.symmetric(vertical: 12.0 , horizontal: 5 ),
                                      hintText: SignUpConstant.city,
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700
                                          ),
                                       border: OutlineInputBorder(
                                       borderRadius: BorderRadius.circular(0),
                                       borderSide: BorderSide.none,
                                       ),
                                       fillColor: AppColors.white,
                                       filled: true,
                                  
                                    ),
                                 
                                    validator: 
                                    (valu, p1) {
                                 
                                         setState((){});
                                         print("val $valu");
                                 
                                          // FocusManager.instance.primaryFocus?.unfocus();
                                       if (valu == null || valu.isEmpty) {
                                        return "City is required";
                                           }
                                    }, 
                                    // debounceTime: 400,
                                    countries: ["in", "fr"],
                                    isLatLngRequired: true,
                                    getPlaceDetailWithLatLng: (Prediction prediction) {
                                 
                                
                                      print("placeDetails" + prediction.lat.toString());
                                    },
                                 
                                    itemClick: (Prediction prediction) { 
                                      cityController.text = prediction.description ?? "";
                                   
                                    },
                                 
                                    // seperatedBuilder: const Divider(),
                                    containerHorizontalPadding: 10,
                                    // OPTIONAL// If you want to customize list view item builder
                                    itemBuilder: (context, index, Prediction prediction) {
                                      return Container(
                                        color: AppColors.white,
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.location_on),
                                            const SizedBox(
                                              width: 7,
                                            ),
                                            Expanded(child: Text("${prediction.description ?? ""}"))
                                          ],
                                        ),
                                      );
                                    },
                                   formSubmitCallback: () {
                                      print("dgd");
                                   },
               
                                  ),
                          ),
                               ),
                         const SizedBox(
                            height: 10,
                             ),
          
                CustomTextField(
                  controller: pincodeController,
                  hintText: SignUpConstant.pinCode,
                  keyboardType: TextInputType.text,
                  maxLength: 10,
                  validator: 
                      validatePincode
                  // prefixIcon: Icons.phone,
                ),
                          const SizedBox(
                            height: 10,
                             ),
          
                CustomTextField(
                  controller: passwordController,
                  hintText: SignUpConstant.password,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  maxLength: 10,
                  validator: 
                  validatePassword
                  // prefixIcon: Icons.phone,
                ),
                       const SizedBox(
                            height: 10,
                             ),
          
                CustomTextField(
                  controller: confirmPasswordController,
                  hintText: SignUpConstant.confirmPassword,
                  keyboardType: TextInputType.text,
                  maxLength: 10,
                  obscureText: true,
                  validator: 
                 validateConfirmPassword
                  // prefixIcon: Icons.phone,
                ),
                      const SizedBox(
                            height: 5,
                             ),
          
                                BlocConsumer<SignupBloc, SignUpState>(
                    bloc: loginBloc,
                    listener: (context, state) {
                      if (state is SignUpLoading) {
                        EasyLoading.show(status: state.message);
                      }
          
                      if (state is CreateClient) {
                        EasyLoading.dismiss();
                        // loginBloc.add(Signup(
                        //   mobileNumber: mobileController.text,
                        //   email: emailController.text,
                        //   name: nameController.text,
                        //   password: passwordController.text,
                        //   address: addressController.text,
                        //   city: cityController.text,
                        //   clientTypeId: 10,
                        //   pincode: pincodeController.text
                        // ));

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => OTPScreen(
                        //       phoneNumber: controller.text,
                        //       loginBloc: loginBloc,
                        //       type: widget.type,
                        //     ),
                        //   ),
                        // );
                      }
                       if( state is  RegisterUser ){
                         EasyLoading.dismiss();
                          Navigator.of(context).pop();
                        //  Navigator.push(
                        //    context,
                        //    MaterialPageRoute(
                        //      builder: (context) =>
                        //          ChooseService(

                        //      ),
                        //    ),
                        //  );
                       }
          
                      if (state is SignUpError) {

                        EasyLoading.dismiss();
                        EasyLoading.showError(state.error);
                        
                      }
          
                      // if (state is LoginGetDataSuccess) {
                      //   EasyLoading.dismiss();
                      //   setState(() {
                      //     /// Show hint only one time
                      //     /// * Works only on android platform
                      //     if (!_isHintShown && Platform.isAndroid) {
                      //       requestHint();
                      //     }
                      //   });
                      // }
                    },
                    builder: (context, state) {

                      if (state is CreateClient) {
                        // EasyLoading.dismiss();
                        loginBloc.add(Signup(
                          mobileNumber: mobileController.text,
                          email: emailController.text,
                          name: nameController.text,
                          password: passwordController.text,
                          address: addressController.text,
                          city: cityController.text,
                          clientTypeId: 10,
                          pincode: pincodeController.text
                        ));

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => OTPScreen(
                        //       phoneNumber: controller.text,
                        //       loginBloc: loginBloc,
                        //       type: widget.type,
                        //     ),
                        //   ),
                        // );
                      }

                      return GestureDetector(
                        onTap: () async {
                          bool isValid =
                              loginFormKey.currentState?.validate() ?? false;
                          if (!isValid) return;
          
                          // globalStorage.saveMobileNumber(
                          //     accessMobileNumber: controller.text  );
                          if (loginFormKey.currentState?.validate() ?? false) {
                            loginBloc.add(CreateClientEvent( 
                              mobileNumber: mobileController.text,
                              email: emailController.text,
                              name: nameController.text,
                              password: passwordController.text,
                              pincode: pincodeController.text,
                              city: cityController.text,
                              address: addressController.text,
                              ));
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.h,
                            horizontal: 16.w,
                          ),
                          child:
                     const Custombutton(
                      color: AppColors.buttonYellowColor,
                      text: "Register", width: double.infinity ),
                        ),
                      );
                    },
                  ),
                     
             
                               const SizedBox(
                                height: 10
                               ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already a user?",
                               style: AppTextStyle.font14bold,
                              ),
                            const  SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Login Now",
                                  
                                style: AppTextStyle.font14bold.copyWith(
                                                             decoration: TextDecoration.underline,
                                                           ),
                                 ),
                              )
                            ],
                          ),
                               const SizedBox(
                                height: 20,
                               ),
                        
                           
                       
                    ],
                  ),
                ),
              )
          
            ],
          ),
        ),
      ),
    );
  }




String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return "Name is required";
  }
  if (value.length < 3) {
    return "Name must be at least 3 characters";
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return "Email is required";
  }

  // Stricter pattern to validate general email
  final emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$"
  );

  if (!emailRegex.hasMatch(value)) {
    return "Enter a valid email";
  }

  return null;
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

String? validateAddress(String? value) {
  if (value == null || value.isEmpty) {
    return "Address is required";
  }
  if (value.length < 5) {
    return "Address must be at least 5 characters";
  }
  return null;
}

String? validateCity(String? value) {
  if (value == null || value.isEmpty) {
    return "City is required";
  }
  return null;
}

String? validatePincode(String? value) {
  if (value == null || value.isEmpty) {
    return "Pincode is required";
  }
  if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
    return "Enter a valid 6-digit pincode";
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

String? validateConfirmPassword(String? value) {
  if (value == null || value.isEmpty) {
    return "Confirm Password is required";
  }
  if (value != passwordController.text) {
    return "Passwords do not match";
  }
  return null;
}

}