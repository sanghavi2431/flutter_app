import 'dart:io';

import 'package:woloo_smart_hygiene/client_flow/utils/client_images.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/screens/login/bloc/login_bloc.dart';
import 'package:woloo_smart_hygiene/screens/login/view/otp_screen.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_it/get_it.dart';
import 'package:pinput/pinput.dart';

import '../../../client_flow/widgets/CustomButton.dart';
import '../../common_widgets/image_provider.dart';

class LoginScreen extends StatefulWidget {
  final String? type;

  const LoginScreen({
    super.key,
    this.type,
  });

  @override
  State<LoginScreen> createState() => LoginPageState();
}

class LoginPageState extends State<LoginScreen> {
  final loginFormKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool _isHintShown = false;

  LoginBloc loginBloc = LoginBloc();
  GlobalStorage globalStorage = GetIt.instance();
  int? _selectedLanguage;
  final List<String> _languages = ["English", "हिंदी", "मराठी"];
  final List<Locale> _locales = const [
    Locale('en', 'US'),
    Locale('hi', 'IN'),
    Locale('mr', 'IN')
  ];

  @override
  void initState() {
    super.initState();
    settingModalBottomSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Platform.isAndroid) hideKeyboard(context);
        if (Platform.isIOS) hideKeyboard(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          leading: widget.type == null ? BackButton() : SizedBox(),
               backgroundColor: AppColors.backgroundColor,
        ),
        body: SingleChildScrollView(
          child:
          Form(
            key: loginFormKey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 170.h,
                ),
                Center(
                  child: CustomImageProvider(
                    image: ClientImages.taskMaster,
                    height: 130.h,
                    width: 250.h,
                    alignment: Alignment.center,
                  ),
                ),
                // Center(
                //   child: Text(
                //     textAlign: TextAlign.center,
                //     MyLoginConstants.WELCOME_TEXT.tr(),
                //     style:
                //     AppTextStyle.font24bold.copyWith(
                //     color: AppColors.black,
                //     )
                //     //  TextStyle(
                //     //   fontWeight: FontWeight.w400,
                //     //   fontSize: 24.sp,
                //     //   color: AppColors.black,
                //     // ),
                //   ),
                // ),
                SizedBox(
                  height: 40.h,
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.black.withOpacity(0.2), // Shadow color
                //           spreadRadius: 1, // How wide the shadow should spread
                //           blurRadius: 10, // The blur effect of the shadow
                //           offset: const Offset(0,
                //               5), // Shadow offset, with y-offset for bottom shadow
                //         ),
                //       ],
                //     ),
                //     child: TextFormField(
                //       keyboardType: TextInputType.name,
                //       autovalidateMode: AutovalidateMode.onUserInteraction,
                //       textAlign: TextAlign.center,
                //       controller: nameController,
                //       validator: (value) {
                //         if (value == null || value.isEmpty) {
                //           return " Please enter your name";

                //             //MyLoginConstants.MOBILE_VALIDATION.tr();
                //         }
                //         return null;
                //       },
                //       maxLength: 10,
                //       decoration: InputDecoration(
                //           isDense: true,
                //           counterText: "",
                //           fillColor: AppColors.white,
                //           filled: true,
                //           border: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(25.r),
                //               borderSide: BorderSide.none
                //             //  const BorderSide(color: AppColors.greyBoxBorder),
                //           ),
                //           hintText: "Enter Name No",
                //           //MyLoginConstants.MOBILE_NO.tr(),
                //           hintStyle: AppTextStyle.font16.copyWith(
                //             color: AppColors.greyColorFields,

                //           )
                //         //  TextStyle(
                //         //   color: AppColors.greyColorFields,
                //         //   fontSize: 16.sp,
                //         //   fontWeight: FontWeight.w400,
                //         // ),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 10.h,
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 5.h),
                  child: Container(
                                decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues( alpha: 0.2), // Shadow color
                          spreadRadius: 1, // How wide the shadow should spread
                          blurRadius: 10, // The blur effect of the shadow
                          offset: const Offset(0,
                              5), // Shadow offset, with y-offset for bottom shadow
                        ),
                      ],
                    ),
                    child:
                    TextFormField(
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textAlign: TextAlign.center,
                      controller: controller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return MyLoginConstants.MOBILE_VALIDATION.tr();
                        }
                        return null;
                      },
                      maxLength: 10,
                      decoration: InputDecoration(
                          isDense: true,
                          counterText: "",
                          fillColor: AppColors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide.none
                              //  const BorderSide(color: AppColors.greyBoxBorder),
                              ),
                          hintText: MyLoginConstants.MOBILE_NO.tr(),
                          hintStyle: AppTextStyle.font16.copyWith(
                            color: AppColors.greyColorFields,

                          )
                          //  TextStyle(
                          //   color: AppColors.greyColorFields,
                          //   fontSize: 16.sp,
                          //   fontWeight: FontWeight.w400,
                          // ),
                          ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                BlocConsumer<LoginBloc, LoginState>(
                  bloc: loginBloc,
                  listener: (context, state) {
                    if (state is LoginLoading) {
                      EasyLoading.show(status: state.message);
                    }

                    if (state is LoginOTPSent) {
                      EasyLoading.dismiss();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OTPScreen(
                            phoneNumber: controller.text,
                            loginBloc: loginBloc,
                            type: widget.type,
                          ),
                        ),
                      );
                    }

                    if (state is LoginError) {
                      EasyLoading.dismiss();
                      EasyLoading.showError(state.error);
                    }

                    if (state is LoginGetDataSuccess) {
                      EasyLoading.dismiss();
                      setState(() {
                        /// Show hint only one time
                        /// * Works only on android platform
                        if (!_isHintShown && Platform.isAndroid) {
                          requestHint();
                        }
                      });
                    }
                  },
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () async {
                        bool isValid =
                            loginFormKey.currentState?.validate() ?? false;
                        if (!isValid) return;

                        globalStorage.saveMobileNumber(
                            accessMobileNumber: controller.text  );
                        if (loginFormKey.currentState?.validate() ?? false) {
                          loginBloc.add(SendOTP(mobileNumber: controller.text));
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 20.w,
                        ),
                        child:
                        Custombutton(
                            color: AppColors.buttonYellowColor,
                            text:  MyLoginConstants.LOGIN_WITH_OTP.tr(), width: 320.w),
                        // ButtonWidget(
                        //   color:AppColors.buttonYellowColor,
                        //   text: MyLoginConstants.LOGIN_WITH_OTP.tr(),
                        // ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void settingModalBottomSheet(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!context.mounted) return;
    await showModalBottomSheet(
      context: context,
      isDismissible: true,
      builder: (BuildContext cont) {
        return Container(
          height: 200.h,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: AppColors.yellowIcon,
              width: 2,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Text(
                "Select Language",
                style: TextStyle(fontSize: 18.sp),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: ListView.separated(
                  
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        key: ValueKey(_languages[index]),
                        
                         
                        
                        _languages[index]),
                      titleAlignment: ListTileTitleAlignment.center,
                      onTap: () {
                        _selectedLanguage = index;
                        context.setLocale(_locales[_selectedLanguage ?? 0]);
                        Get.updateLocale(_locales[_selectedLanguage ?? 0]);
                        Navigator.pop(context);
                      },
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const Divider(height: 0),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (!context.mounted) return;
    context.setLocale(_locales[_selectedLanguage ?? 0]);
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  void requestHint() async {
    final res = await SmartAuth().requestHint(
      isPhoneNumberIdentifierSupported: true,
      isEmailAddressIdentifierSupported: false,
      showCancelButton: true,
    );
    _isHintShown = true;
    controller.text = (res?.id ?? '');
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }
}
