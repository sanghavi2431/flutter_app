import 'dart:io';

import 'package:Woloo_Smart_hygiene/core/bloc/core_bloc.dart';
import 'package:Woloo_Smart_hygiene/core/local/global_storage.dart';
import 'package:Woloo_Smart_hygiene/messaging.dart';
import 'package:Woloo_Smart_hygiene/screens/login/view/login_screen.dart';
import 'package:Woloo_Smart_hygiene/screens/supervisor_dashboard/view/supervisor_dashboard_screen.dart';
import 'package:Woloo_Smart_hygiene/utils/app_color.dart';
import 'package:Woloo_Smart_hygiene/utils/app_constants.dart';
import 'package:Woloo_Smart_hygiene/utils/app_images.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:dio_log/dio_log.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../common_widgets/image_provider.dart';
import '../../dashboard/view/dashboard_screen.dart';
import '../../dashboard/view/regular_task.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  CoreBloc coreBloc = CoreBloc();
  GlobalStorage globalStorage = GetIt.instance();


  @override
  void initState() {
    super.initState();
    loadApp();
    showDebugBtn(context);
  }





  loadApp() async {
    if (Platform.isIOS) {
      await requestTracking();
  }
    Messaging messaging = Messaging();
    await messaging.initialize();
   // updateDeviceToken();
    coreBloc.add(CheckUserIsLoggedInOrNot());
  }

   apiCall(){


   }

  // void setToken(String? token) {
  //   print('FCM Token: $token');
  //   
  //     deviceToken = token;
  //  
  // }

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
         coreBloc.add(CheckUserIsLoggedInOrNot());

       }

  Future<void> requestTracking() async {
    try {
      final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        if (context.mounted) await showCustomTrackingDialog(context);
        await Future.delayed(const Duration(milliseconds: 200));
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> showCustomTrackingDialog(BuildContext context) async => await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(MySplashScreenConstants.DEAR_USER.tr()),
          content: Text("${MySplashScreenConstants.PRIVACY.tr()}"
              "${MySplashScreenConstants.PERMISSION.tr()}"
              "${MySplashScreenConstants.ADS.tr()}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(MySplashScreenConstants.CONTINUE.tr()),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoreBloc, CoreState>(
      bloc: coreBloc,
      listener: (context, state) {
        if (state is CoreSuccess) {
          try {
            if (!state.isLoggedIn) throw "Not logged in";

            int roleId = globalStorage.getRoleId();

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => 
                
                roleId == 1 ? const Dashboard() : const
                SupervisorDashboard(),
              ),
              (route) => false,
            );
          } catch (e) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
              (route) => false,
            );
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                color: AppColors.buttonColor,
                backgroundColor: AppColors.white.withOpacity(0.1),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                CustomImageProvider(
                  scale: 5,
                 image: 
                  AppImages.splash_logo,
                ),  
                    // Image.asset(
                    //   AppImages.splash_logo,
                    //   scale: 5,
                    // ),
                  ],
                ),
              ),
              Text(MySplashScreenConstants.LOADING.tr()),
            ],
          ),
        ),
      ),
    );
  }
}
