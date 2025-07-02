import 'dart:async';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/screens/login/bloc/login_bloc.dart';
import 'package:woloo_smart_hygiene/screens/supervisor_dashboard/view/supervisor_dashboard_screen.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import '../../../client_flow/utils/client_images.dart';
import '../../../client_flow/widgets/CustomButton.dart';
import '../../../core/bloc/core_bloc.dart';
import '../../common_widgets/image_provider.dart';
import '../../dashboard/view/regular_task.dart';
import 'local_widgets/otp_widget.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  final String? type;

  final LoginBloc loginBloc;
  const OTPScreen(
      {super.key, required this.phoneNumber, required this.loginBloc, this.type});

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
          debugPrint('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          debugPrint("'Location permissions are permanently denied");
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
      debugPrint("GPS Service is not enabled, turn on GPS location");
    }
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

      debugPrint(position.longitude.toString());
      debugPrint(position.latitude.toString()); //Output: 29.6593457
    //Output: 80.24599079



    long = position.longitude.toString();
    lat = position.latitude.toString();

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    // StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
          debugPrint(position.longitude.toString()); //Output: 80.24599079
          debugPrint(position.latitude.toString()); //Output: 29.6593457

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
      debugPrint("address - $_currentAddress");
        EasyLoading.showToast(
            "${MyLoginConstants.LOCATION_DETECTED_TOAST.tr()} : $_currentAddress");
      
    }).catchError((e) {
      debugPrint(e);
    });
  }


  // late Stream<String> _tokenStream;
  String? deviceToken;

  Future updateDeviceToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    //  await Future.delayed(Duration(seconds: 1));
    String? aspn =     await messaging.getAPNSToken();
    debugPrint("aspn $aspn");
    //  onNewToken

    debugPrint("refresh token ${messaging.onTokenRefresh}");

    deviceToken = await messaging.getToken();
    // _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
//     _tokenStream.listen(setToken);

    debugPrint("device token $deviceToken");
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
                OTPWidget(
                  janitorBloc: widget.loginBloc,
                phoneNumber: widget.phoneNumber,
                  onComplete: (pin){
                      print("dataaa $pin");
                    _pin = pin;
                  },
                  // loginBloc: widget.loginBloc, 
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
                        debugPrint("screen role id ----- $roleId");
                        debugPrint("fcm token id ----- $fcmToken");
                        updateDeviceToken();
                      // widget.loginBloc.add(
                      //     UpdateTokenOnVerifyOTP(token: fcmToken.toString()));

                      EasyLoading.dismiss();
                      if (roleId == 1) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Dashboard(),
                          ),
                          (route) => false,
                        );
                      }
                      if (roleId == 2) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SupervisorDashboard(
                               isFromSupervisor: false,
                            ),
                          ),
                          (route) => false,
                        );
                      }
                    }

                    if (state is LoginError) {
                      EasyLoading.dismiss();
                      EasyLoading.showError(state.error);
                    }

                    if (state is LoginGetDataSuccess) {
                      EasyLoading.dismiss();
                  
                    }
                  },
                  child: GestureDetector(
                    onTap: () async {
                       print("object $_pin ");
                      if (_pin.isNotEmpty) {
                        widget.loginBloc.add(VerifyOTP(otp: _pin));
                      }
                      if (_pin.isEmpty) {
                        EasyLoading.showToast(
                            MyLoginConstants.ENTER_OTP_TOAST.tr());
                      }

                      debugPrint("button pressed");
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 10.w),
                      child:
                      Custombutton(
                          color: AppColors.buttonYellowColor,
                          text:  MyLoginConstants.VERIFY_OTP_BTN.tr(), width: 320.w),
                      // ButtonWidget(
                      //   color: AppColors.buttonYellowColor,
                      //   text: MyLoginConstants.VERIFY_OTP_BTN.tr(),
                      // ),
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
