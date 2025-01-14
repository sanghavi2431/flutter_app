import 'dart:async';
import 'package:Woloo_Smart_hygiene/utils/app_textstyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:Woloo_Smart_hygiene/core/local/global_storage.dart';
import 'package:Woloo_Smart_hygiene/screens/login/bloc/login_bloc.dart';
import 'package:Woloo_Smart_hygiene/screens/supervisor_dashboard/view/supervisor_dashboard_screen.dart';
import 'package:Woloo_Smart_hygiene/utils/app_color.dart';
import 'package:Woloo_Smart_hygiene/utils/app_constants.dart';
import 'package:Woloo_Smart_hygiene/utils/app_images.dart';
import '../../../core/bloc/core_bloc.dart';
import '../../common_widgets/button_widget.dart';
import '../../common_widgets/image_provider.dart';
import '../../dashboard/view/dashboard_screen.dart';
import '../../dashboard/view/regular_task.dart';
import 'local_widgets/otp_widget.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  final String? type;

  final LoginBloc loginBloc;
  const OTPScreen(
      {Key? key, required this.phoneNumber, required this.loginBloc, this.type})
      : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String _pin = '';
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  String? _currentAddress;
  CoreBloc coreBloc = CoreBloc();

  late StreamSubscription<Position> positionStream;
  GlobalStorage globalStorage = GetIt.instance();
  late int? roleId;
  String? fcmToken;
  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();

      _getAddressFromLatLng(position);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
     
        _currentAddress =
            '${place.name},${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.administrativeArea},${place.postalCode}';
        print("address - $_currentAddress");
        EasyLoading.showToast(
            "${MyLoginConstants.LOCATION_DETECTED_TOAST.tr()} : $_currentAddress");
      
    }).catchError((e) {
      debugPrint(e);
    });
  }


  late Stream<String> _tokenStream;
  String? deviceToken;

  Future updateDeviceToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    //  await Future.delayed(Duration(seconds: 1));
    String? aspn =     await messaging.getAPNSToken();
    print("aspn $aspn");
    //  onNewToken

    print("refresh token ${messaging.onTokenRefresh}");

    deviceToken = await messaging.getToken();
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
//     _tokenStream.listen(setToken);

    print("device token $deviceToken");
    if (deviceToken != null) coreBloc.add(UpdateToken(token: deviceToken!));
   /// coreBloc.add(CheckUserIsLoggedInOrNot());

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Container(
                    // height: 120.h,
                    // width: 120.w,
                    // decoration: BoxDecoration(
                    //     color: AppColors.greyContainer,
                    //     borderRadius: BorderRadius.circular(100)),
                    child: Center(
                      child: CustomImageProvider(
                        image: AppImages.woloologo,
                        // height: 78.h,
                        height: 135.h,
                        width: 135.h,
                        alignment: Alignment.center,
                      ),
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
                            text: "${MyLoginConstants.ENTER_OTP.tr()}",
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
                                    image: AppImages.edit_icon_img,
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
                OTPWidget(
                  onComplete: (pin) => _pin = pin,
                ),
                SizedBox(
                  height: 10.h,
                ),
                BlocListener<LoginBloc, LoginState>(
                  bloc: widget.loginBloc,
                  listener: (context, state) {
                    if (state is LoginLoading) {
                      EasyLoading.show(status: state.message);
                    }

                    if (state is LoginOTPSent) {
                      EasyLoading.dismiss();
                    }
                    if (state is LoginOTPVerified) {
                     
                        roleId = globalStorage.getRoleId();
                        print("screen role id ----- " + roleId.toString());
                        print("fcm token id ----- " + fcmToken.toString());
                        updateDeviceToken();
                      // widget.loginBloc.add(
                      //     UpdateTokenOnVerifyOTP(token: fcmToken.toString()));

                      EasyLoading.dismiss();
                      if (roleId == 1) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Dashboard(),
                          ),
                          (route) => false,
                        );
                      }
                      if (roleId == 2) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SupervisorDashboard(),
                          ),
                          (route) => false,
                        );
                      }
                    }

                    if (state is LoginError) {
                      EasyLoading.dismiss();
                      EasyLoading.showError(state.error.message);
                    }

                    if (state is LoginGetDataSuccess) {
                      EasyLoading.dismiss();
                  
                    }
                  },
                  child: GestureDetector(
                    onTap: () async {
                      if (_pin.isNotEmpty) {
                        widget.loginBloc.add(VerifyOTP(otp: _pin));
                      }
                      if (_pin.isEmpty) {
                        EasyLoading.showToast(
                            MyLoginConstants.ENTER_OTP_TOAST.tr());
                      }

                      print("button pressed");
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 10.w),
                      child: ButtonWidget(
                        color: AppColors.buttonYellowColor,
                        text: MyLoginConstants.VERIFY_OTP_BTN.tr(),
                      ),
                    ),
                  ),
                ),
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
}
