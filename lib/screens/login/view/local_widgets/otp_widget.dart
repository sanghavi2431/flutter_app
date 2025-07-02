import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:pinput/pinput.dart';

import '../../../../client_flow/screens/login/bloc/signup_bloc.dart';
import '../../../../client_flow/screens/login/bloc/signup_event.dart';
import '../../../../client_flow/screens/login/bloc/signup_state.dart';
import '../../bloc/login_bloc.dart';

class OTPWidget extends StatefulWidget {
  final Function onComplete;
  final SignupBloc? loginBloc;
  final String phoneNumber;
  final LoginBloc? janitorBloc;

  const OTPWidget({
    super.key,
    required this.onComplete,
    this.loginBloc,
    this.janitorBloc,
    required this.phoneNumber,
  });

  @override
  State<OTPWidget> createState() => _OTPWidgetState();
}

class _OTPWidgetState extends State<OTPWidget> {
  Timer? countdownTimer;
  Duration myDuration = const Duration(seconds: 30);
  bool _isTapResendEnabled = false;
  final TextEditingController _pinController = TextEditingController();

   SignupBloc  signupBloc = SignupBloc();
  LoginBloc? loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final seconds = strDigits(
      myDuration.inSeconds.remainder(60),
    );

    return 
    BlocConsumer (
      bloc: loginBloc,
      listener: (context, state) {
         if (state is LoginLoading) {
                      EasyLoading.show(status: state.message);
                    }

                 if (state is LoginOTPSent) {
                      // startTimer();
                      EasyLoading.dismiss();
                     
                    }

                    if (state is LoginError) {
                      EasyLoading.dismiss();
                      EasyLoading.showError(state.error);
                    }

        
      },
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Pinput(
               key:const ValueKey("otptextfield"),
                controller: _pinController,
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                defaultPinTheme: PinTheme(
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  height: 51.h,
                  width: 51.w,  
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                        BoxShadow(
                              color: Colors.black.withValues( alpha: 0.2), // Shadow color
                              spreadRadius: 1, // How wide the shadow should spread
                              blurRadius: 10, // The blur effect of the shadow
                              offset: const Offset(0,
                                  5), // Shadow offset, with y-offset for bottom shadow
                            ),
                    ],
                    border:
                     Border.all(
                      color: AppColors.white,
                      width: 0.sp,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ), 
                onCompleted: (pin) {
                  // debugPrint(pin);
                
                },
                inputFormatters: [ FilteringTextInputFormatter.digitsOnly ],
                // keyboardType:,
                onChanged: (pin) {
                    widget.onComplete(pin);
                  
                },
        
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            
            BlocConsumer(
              listener: (context, state) {
                     if ( state is SignUpLoading){
                                     EasyLoading.show(status: state.message);
                               }
        
                              if (state is LoginUser  ) {
                                // startTimer();
                                   EasyLoading.dismiss();
                                  //  state.
                                  //  Navigator.push(
                                  //    context,
                                  //    MaterialPageRoute(
                                  //      builder: (context) =>  VerifyOtp(
                                  //       phoneNumber: emailController.text,
                                  //       loginBloc: loginBloc,

                                  //      ),
                                  //    ),
                                  //       //  (route) => false,
                                  //  );
                              }
        
                               if(state is SignUpError  ){
                                 EasyLoading.dismiss();
                                 EasyLoading.showError( state.error);
        
                               }
                
              },
              bloc: signupBloc,

              builder: (context, state) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_isTapResendEnabled) {
                            resetTimer();
                          }
                        },
                        child: Text(
                          MyLoginConstants.DIDNT_RECIEVED_OTP.tr(),
                          textAlign: TextAlign.center,
                          style:
                          AppTextStyle.font14bold.copyWith(
                              color: AppColors.black,
                          )
                          //  TextStyle(
                          //   fontWeight: FontWeight.w400,
                          //   fontSize: 14.sp,
                          //   color: AppColors.greyMap,
                        //  ),
                        ),
                      ),
                      Text(
                        '$seconds ${MyLoginConstants.SEC.tr()}',
                        textAlign: TextAlign.center,
                        style:
                           AppTextStyle.font14bold.copyWith(
                            color: AppColors.black,
                          )
                        // TextStyle(
                        //   fontWeight: FontWeight.w400,
                        //   color: AppColors.black,
                        //   fontSize: 14.sp,
                        // ),
                      ),
                      seconds == "00" ?
                        
                      InkWell(
                        onTap: () {
                            resetTimer();
                            print("Resend OTP clicked ${widget.phoneNumber} ");
                          widget.loginBloc != null ? signupBloc!.add(Login(
                              mobileNo: widget.phoneNumber,
                              // password: passwordController.text,
                            )) : 
                        
                              loginBloc!.add(SendOTP(mobileNumber: widget.phoneNumber,));
                            
                            //  widget.janitorBloc!.add(JanitorLogin(
                            //   mobileNo: widget.phoneNumber,
                            // ));
                          // if (_isTapResendEnabled) {
                            // resetTimer();
                          // }
                        },
                        child: const Center(child: Text("Resend OTP",
                         style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          // decoration: TextDecorationStyle.solid,
                          color: AppColors.black,),
                        )),
                      )
                      
                      : const SizedBox.shrink(),
                        
                    ],
                  ),
                );
              }
            ),
                
                
        
            /// Show [Send OTP] button if OTP is not sent
          ],
        );
      }
    );
  }

  void startTimer() {
    setState(() {
      _isTapResendEnabled = false;
    });
    countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setCountDown(),
    );
  }

  // Step 4
  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  // Step 5
  void resetTimer() {
    setState(
      () => myDuration = const Duration(seconds: 30),
    );
    startTimer();
  }

  // Step 6
  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(
      () {
        final seconds = myDuration.inSeconds - reduceSecondsBy;
        if (seconds < 0) {
          countdownTimer!.cancel();
          _isTapResendEnabled = true;
        } else {
          myDuration = Duration(
            seconds: seconds,
          );
        }
      },
    );
  }
}
