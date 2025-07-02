import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_bloc.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/login/view/check_screen.dart';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as en;
import 'package:convert/convert.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
// import 'package:crypto/crypto.dart';
import '../../../../b2b_store/bloc/b2b_store_event.dart';
import '../../../../screens/common_widgets/image_provider.dart';
// import '../../../../screens/login/bloc/login_bloc.dart';
import '../../../../screens/login/view/local_widgets/otp_widget.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_textstyle.dart';
import '../../../utils/client_images.dart';
import '../../../widgets/CustomButton.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/signup_event.dart';
import '../bloc/signup_state.dart';
import '../data/model/verify_otp_model.dart';

class VerifyOtp extends StatefulWidget {
  final String phoneNumber;
  final String? type;

  final SignupBloc loginBloc;
  const VerifyOtp(
      {super.key,
      required this.phoneNumber,
      required this.loginBloc,
      this.type});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  SignupBloc loginBloc = SignupBloc();
  B2bStoreBloc b2bStoreBloc = B2bStoreBloc();
  String _pin = '';
  bool servicestatus = false;
  bool haspermission = false;
  // late LocationPermission permission;
  // late Position position;
  String long = "", lat = "";
  String? _currentAddress;
  VerfiyOtpModel? verfiyOtpModel;
  // CoreBloc coreBloc = CoreBloc();

  // late StreamSubscription<Position> positionStream;
  // GlobalStorage globalStorage = GetIt.instance();
  // late int? roleId;
  // String? fcmToken;
  // checkGps() async {
  //   servicestatus = await Geolocator.isLocationServiceEnabled();
  //   if (servicestatus) {
  //     permission = await Geolocator.checkPermission();

  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         debugPrint('Location permissions are denied');
  //       } else if (permission == LocationPermission.deniedForever) {
  //         debugPrint("'Location permissions are permanently denied");
  //       } else {
  //         haspermission = true;
  //       }
  //     } else {
  //       haspermission = true;
  //     }

  //     if (haspermission) {
  //       getLocation();
  //     }
  //   } else {
  //     debugPrint("GPS Service is not enabled, turn on GPS location");
  //   }
  // }

  // getLocation() async {
  //   position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);

  //     debugPrint(position.longitude.toString());
  //     debugPrint(position.latitude.toString()); //Output: 29.6593457
  //   //Output: 80.24599079

  //   long = position.longitude.toString();
  //   lat = position.latitude.toString();

  //   LocationSettings locationSettings = const LocationSettings(
  //     accuracy: LocationAccuracy.high, //accuracy of the location data
  //     distanceFilter: 100, //minimum distance (measured in meters) a
  //     //device must move horizontally before an update event is generated;
  //   );

  //   // StreamSubscription<Position> positionStream =
  //       Geolocator.getPositionStream(locationSettings: locationSettings)
  //           .listen((Position position) {
  //         debugPrint(position.longitude.toString()); //Output: 80.24599079
  //         debugPrint(position.latitude.toString()); //Output: 29.6593457

  //     long = position.longitude.toString();
  //     lat = position.latitude.toString();

  //     _getAddressFromLatLng(position);
  //   });
  // }

  // Future<void> _getAddressFromLatLng(Position position) async {
  //   await placemarkFromCoordinates(position.latitude, position.longitude)
  //       .then((List<Placemark> placemarks) {
  //     Placemark place = placemarks[0];

  //       _currentAddress =
  //           '${place.name},${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.administrativeArea},${place.postalCode}';
  //     debugPrint("address - $_currentAddress");
  //       EasyLoading.showToast(
  //           "${MyLoginConstants.LOCATION_DETECTED_TOAST.tr()} : $_currentAddress");

  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }

  // late Stream<String> _tokenStream;
  String? deviceToken;

//   Future updateDeviceToken() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//     //  await Future.delayed(Duration(seconds: 1));
//     String? aspn =     await messaging.getAPNSToken();
//     debugPrint("aspn $aspn");
//     //  onNewToken

//     debugPrint("refresh token ${messaging.onTokenRefresh}");

//     deviceToken = await messaging.getToken();
//     // _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
// //     _tokenStream.listen(setToken);

//     debugPrint("device token $deviceToken");
//     if (deviceToken != null) coreBloc.add(UpdateToken(token: deviceToken!));
//    /// coreBloc.add(CheckUserIsLoggedInOrNot());

//   }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("login ka bloc ${widget.loginBloc}");
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100.h,
                ),
                Center(
                  child: Center(
                    child: CustomImageProvider(
                      image: ClientImages.taskMaster,
                      // height: 78.h,
                      height: 130.h,
                      width: 250.h,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                // Center(
                //   child: Text(MyLoginConstants.OTP_VERIFICATION.tr(),
                //       style: AppTextStyle.font24.copyWith(
                //         color: AppColors.black,
                //       )
                //       // TextStyle(
                //       //   fontWeight: FontWeight.w400,
                //       //   fontSize: 24.sp,
                //       //   color: AppColors.black,
                //       // ),
                //       ),
                // ),
                SizedBox(
                  height: 10.h,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: RichText(
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          text: TextSpan(
                            text: MyLoginConstants.ENTER_OTP.tr(),
                            style: AppTextStyle.font14bold.copyWith(
                              color: AppColors.boldTextColor,
                            ),
                            // TextStyle(
                            //   fontWeight: FontWeight.w500,
                            //   fontSize: 14.sp,
                            //   color: AppColors.greyText,
                            // ),
                            children: [
                              TextSpan(
                                text: "91${widget.phoneNumber}",
                                style: AppTextStyle.font14bold.copyWith(
                                  color: AppColors.boldTextColor,
                                ),
                                //  TextStyle(
                                //   fontWeight: FontWeight.w500,
                                //   fontSize: 14.sp,
                                //   color: AppColors.boldTextColor,
                                // ),
                              ),
                              WidgetSpan(
                                child: SizedBox(
                                  width: 5.w,
                                ),
                              ),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: CustomImageProvider(
                                    image: AppImages.editIconImg,
                                    height: 12.h,
                                    width: 11.h,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                // BlocBuilder(
                //   bloc:b2bStoreBloc,
                //   builder: (context,state ) {

                //  print("b2v store $state");

                // return
                OTPWidget(
                  phoneNumber: widget.phoneNumber,
                  loginBloc: widget.loginBloc,
                  onComplete: (pin) {
                  print("dataaa $pin");
                  _pin = pin;
                }),

                // InkWell(
                //   onTap: () {

                //           loginBloc.add(Login(
                //               mobileNo: widget.phoneNumber,
                //               // password: passwordController.text,
                //               ));
                //   },
                //   child: const Center(child: Text("Resend OTP",
                //    style: TextStyle(
                //     fontWeight: FontWeight.w700,
                //     fontSize: 15,
                //     // decoration: TextDecorationStyle.solid,
                //     color: AppColors.black,),
                //   )),
                // ),
                // }
                // ),
                SizedBox(
                  height: 10.h,
                ),
                BlocConsumer(
                    bloc: widget.loginBloc,
                    listener: (context, state) {
                      print("verifty otp state $state");
                      if (state is SignUpLoading) {
                        EasyLoading.show(status: state.message);
                      }

                      // if (state is LoginOTPSent) {
                      //   EasyLoading.dismiss();
                      // }
                      if (state is VerifyOTP) {
                        EasyLoading.dismiss();

                        verfiyOtpModel = state.verfiyOtpModel;

                        // roleId = globalStorage.getRoleId();
                        // debugPrint("screen role id ----- $roleId");
                        // debugPrint("fcm token id ----- $fcmToken");
                        // updateDeviceToken();
                        // widget.loginBloc.add(
                        //     UpdateTokenOnVerifyOTP(token: fcmToken.toString()));

                        widget.loginBloc.add(Signup(
                            clientTypeId: 10,
                            userId: state!.verfiyOtpModel!.results!.userId!,
                            mobileNumber: widget.phoneNumber
                            // pincode: pincodeController.text
                            ));

                        // if (roleId == 1) {
                        //   Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => const Dashboard(),
                        //     ),
                        //     (route) => false,
                        //   );
                        // }
                        // if (roleId == 2) {
                        //   Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => const SupervisorDashboard(
                        //          isFromSupervisor: false,
                        //       ),
                        //     ),
                        //     (route) => false,
                        //   );
                        // }
                      }

                      if (state is RegisterUser) {
                        GlobalStorage globalStorage = GetIt.instance();
                        String password =
                            decryptAES(verfiyOtpModel!.results!.shopPassword!);

                        globalStorage.saveEmail(
                            email:
                                "${verfiyOtpModel!.results!.mobile!}@gmail.com");
                        globalStorage.savePassword(password: password);
                        if (verfiyOtpModel!.results!.isRegister == 0) {
                          print("is regsds");

                          b2bStoreBloc.add(StoreCustomersReq(
                            email:
                                "${verfiyOtpModel!.results!.mobile!}@gmail.com",
                            pass: password!,
                          ));
                        } else {
                          BlocProvider.of<B2bStoreBloc>(context).add(
                              StoreCustomerLoginReq(
                                  email:
                                      "${verfiyOtpModel!.results!.mobile!}@gmail.com",
                                  pass: password!,
                                  isfromlogin: true));
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CheckScreen(
                                // phoneNumber: emailController.text,
                                // loginBloc: loginBloc,

                                ),
                          ),
                          //  (route) => false,
                        );
                      }

                      if (state is SignUpError) {
                        EasyLoading.dismiss();
                        EasyLoading.showError(state.error);
                      }

                      // if (state is LoginGetDataSuccess) {
                      //   EasyLoading.dismiss();

                      // }
                    },
                    builder: (context, state) {
                      print("srtate in bulder $state");

                      // },
                      return GestureDetector(
                        onTap: () async {
                          print("object $_pin ");
                          if (_pin.isNotEmpty) {
                            // b2bStoreBloc.add(
                            //     StoreCustomerLoginReq(
                            //            email:"",
                            //           pass:"e1afd303f4254d519d692c791abd479e:0a72a300cae7a19de4207c3b293d0b03",
                            //       )
                            // );

                            widget.loginBloc.add(VerifyOtpEvent(otp: _pin));
                          }
                          if (_pin.isEmpty) {
                            // EasyLoading.showToast(
                            //     MyLoginConstants.ENTER_OTP_TOAST.tr());
                          }

                          debugPrint("button pressed");
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 10.w),
                          child: Custombutton(
                              color: AppColors.buttonYellowColor,
                              text: MyLoginConstants.VERIFY_OTP_BTN.tr(),
                              width: 320.w),
                          // ButtonWidget(
                          //   color: AppColors.buttonYellowColor,
                          //   text: MyLoginConstants.VERIFY_OTP_BTN.tr(),
                          // ),
                        ),
                      );
                    }),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//   String decrypt(String encryptedText, String key) {
//   // Split into IV and encrypted data
//   final parts = encryptedText.split(':');
//   if (parts.length != 2) throw Exception('Invalid encrypted format');

//   final ivBytes = hex.decode(parts[0]);
//   final encryptedBytes = hex.decode(parts[1]);

//   // Convert key to 32-byte Key
//   final keyBytes = Key.fromUtf8(key); // Must be 32 characters

//   final iv = IV(ivBytes);
//   final encrypter = Encrypter(AES(keyBytes, mode: AESMode.cbc));

//   final decrypted = encrypter.decrypt(Encrypted(encryptedBytes), iv: iv);
//   return decrypted;
// }

// import 'package:encrypt/encrypt.dart' as en;
// import 'package:convert/convert.dart';
// import 'dart:typed_data'; // Required for Uint8List

  decryptAES(String encryptedString) {
    // const encryptedString = "e1afd303f4254d519d692c791abd479e:0a72a300cae7a19de4207c3b293d0b03";
    final parts = encryptedString.split(':');

    // Decode hex to bytes and convert to Uint8List
    final ivBytes =
        Uint8List.fromList(hex.decode(parts[0])); // Convert to Uint8List
    final cipherTextBytes =
        Uint8List.fromList(hex.decode(parts[1])); // Convert to Uint8List

    // Create IV and Encrypted objects
    final iv = en.IV(ivBytes);
    final cipherText = en.Encrypted(cipherTextBytes);

    // Key must be 32 bytes for AES-256
    final key = en.Key.fromUtf8('12345678901234567890123456789012');

    // Initialize AES-CBC decrypter
    final encrypter = en.Encrypter(en.AES(key, mode: en.AESMode.cbc));
    String decrypted = "";
    // Decrypt
    try {
      decrypted = encrypter.decrypt(cipherText, iv: iv);

      print("decrypt $decrypted");

      return decrypted;
    } catch (e) {
      print('Decryption failed: $e');
    }
  }

// bool verifyPassword(String inputPassword, String storedHashWithSalt) {
//   final parts = storedHashWithSalt.split(':');
//   if (parts.length != 2) return false;

//   final storedHash = parts[0];
//   final salt = parts[1];

//   // Convert salt from hex to bytes
//   final saltBytes = hexToBytes(salt);

//   // Combine password and salt
//   final passwordBytes = utf8.encode(inputPassword);
//   final combined = <int>[];
//   combined.addAll(passwordBytes);
//   combined.addAll(saltBytes);

//   // Hash the combined bytes
//   final digest = md5.convert(combined); // Use md5 or your actual hashing algorithm

//   return digest.toString() == storedHash;
// }

// List<int> hexToBytes(String hex) {
//   final result = <int>[];
//   for (var i = 0; i < hex.length; i += 2) {
//     final byte = hex.substring(i, i + 2);
//     result.add(int.parse(byte, radix: 16));
//   }
//   return result;
// }
}
