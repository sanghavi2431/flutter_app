import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:dio_log/dio_log.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/core/bloc/core_bloc.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/messaging.dart';
import 'package:woloo_smart_hygiene/screens/supervisor_dashboard/view/supervisor_dashboard_screen.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import '../../../client_flow/screens/dashbaord/view/dashboard.dart';
import '../../../client_flow/screens/dashbaord/view/home.dart';
import '../../../client_flow/screens/login/bloc/signup_bloc.dart';
import '../../../client_flow/screens/login/view/check_screen.dart';
import '../../../client_flow/screens/login/view/login_as.dart';
import '../../common_widgets/image_provider.dart';
import '../../dashboard/view/regular_task.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver  {
  CoreBloc coreBloc = CoreBloc();
  GlobalStorage globalStorage = GetIt.instance();
  SignupBloc loginBloc = SignupBloc();
  Map<String, dynamic>? decodedToken;
    final AppLinks _appLinks = AppLinks();
  // final ClientDashBoardBloc dashBoardBloc = ClientDashBoardBloc();

  // ClientDashBoardBloc dashBoardBloc  = ClientDashBoardBloc();

  @override
  void initState() {
    super.initState();

    loadApp();
    showDebugBtn(context);
 
  }


      @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('Current in splash screen state = $state');
        
        //  if (state  ==  AppLifecycleState.resumed ) {
        //       dashBoardBloc.add( ClientEvent(
        //         id: decodedToken!["id"]
        //         ) );
           
        //  }
     
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




  // apiCall() {}

  // void setToken(String? token) {
  //   print('FCM Token: $token');
  //
  //     deviceToken = token;
  //
  // }

  // late Stream<String> _tokenStream;
  String? deviceToken;
  bool isLoggedIn = false;

  Future updateDeviceToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    //  await Future.delayed(Duration(seconds: 1));
    String? aspn = await messaging.getAPNSToken();
    debugPrint("aspn $aspn");
    //  onNewToken

    debugPrint("refresh token ${messaging.onTokenRefresh}");

    deviceToken = await messaging.getToken();
    // _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
//     _tokenStream.listen(setToken);

    debugPrint("device token $deviceToken");
    if (deviceToken != null) coreBloc.add(UpdateToken(token: deviceToken!));
    coreBloc.add(CheckUserIsLoggedInOrNot());
  }

  Future<void> requestTracking() async {
    try {
      final TrackingStatus status =
          await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        await showCustomTrackingDialog(context.mounted ? context : context);
        await Future.delayed(const Duration(milliseconds: 200));
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<void>(
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
    // debugPrint("device width ${MediaQuery.of(context).size.width}");
    // debugPrint("device height ${MediaQuery.of(context).size.height}");
    return BlocListener<CoreBloc, CoreState>(
      bloc: coreBloc,
      listener: (context, state) {
        print("asdas$state");
        if (state is CoreSuccess) {
          isLoggedIn = state.isLoggedIn;

          print("is logg ing$isLoggedIn");
          // setState(() {

          // })

          // try {
          //   if (!isLoggedIn) throw "Not logged in";

          //   var some = globalStorage.getClientToken();

          //   decodedToken = JwtDecoder.decode(some);

          //   coreBloc.add(ClientEvent(id: decodedToken!["id"]));
          // } catch (e) {
          //   Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const HostDashboard(),
          //     ),
          //     (route) => false,
          //   );
          // }

          //  print("object $isLoggedIn");

          //    if (state.isLoggedIn) {
          //     var some =   globalStorage.getToken();

          //    decodedToken = JwtDecoder.decode(some);
          //     // updateDeviceToken();

          //    //  coreBloc.add(GetClientEvent(
          // }

          try {
            if (!state.isLoggedIn) throw "Not logged in";

            int roleId = globalStorage.getRoleId();
            String clientId = globalStorage.getClientId();
            print(roleId);

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => clientId.isNotEmpty
                    ?  CheckScreen(
                      // dashIndex: 0,
                    )
                    : roleId == 1
                        ? const Dashboard()
                        : const SupervisorDashboard(
                            isFromSupervisor: false,
                          ),
              ),
              (route) => false,
            );

           

          } catch (e) {

            print("sddsd$e");

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginAs(),
              ),
              (route) => false,
            );
          }
        }

        if (state is ClientSuccess) {
          bool isComplete = state.model.results!.isOnboardComplete!;

          // state.

          int roleId = globalStorage.getRoleId();
          String clientId = globalStorage.getClientId();
          print("roleId $roleId");
          print("roleId $clientId");

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => clientId.isNotEmpty
                  ? isComplete
                      ?  ClientDashboard(
                        dashIndex: 0,
                      )
                      : const Home(
                          isFromDashboard: false,
                        )
                  : roleId == 1
                      ? const Dashboard()
                      : const SupervisorDashboard(
                          isFromSupervisor: false,
                        ),
            ),
            (route) => false,
          );
        }

        //  if (state is  ClientSuccess ) {

        //     try {
        //       //   print("objectttt $isLoggedIn");
        //       //  if (!isLoggedIn ) throw "Not logged in";

        //           int roleId = globalStorage.getRoleId();

        //      String clientId = globalStorage.getClientId();

        //     //        Navigator.pushAndRemoveUntil(
        //     //   context,
        //     //   MaterialPageRoute(
        //     //     builder: (context) =>

        //     //     clientId.isNotEmpty ?
        //     //       const ClientDashboard() :
        //     //     roleId == 1 ? const Dashboard() : const
        //     //     SupervisorDashboard(),
        //     //   ),
        //     //   (route) => false,
        //     // );

        //     Navigator.pushAndRemoveUntil(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) =>
        //         clientId.isNotEmpty ?
        //            state.model.results!.isOnboardComplete! ?
        //          const ClientDashboard()
        //           :  Home()
        //            :  roleId == 1 ? const Dashboard() : const
        //         SupervisorDashboard() ,
        //       ),
        //       (route) => false,
        //     );

        //     } catch (e) {

        //      Navigator.pushAndRemoveUntil(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => const LoginAs(),
        //       ),
        //       (route) => false,
        //     );

        //     }

        //  }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                color: AppColors.buttonColor,
                backgroundColor: AppColors.white.withValues(alpha: 0.1),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomImageProvider(
                      scale: 3,
                      image: AppImages.splashLogo,
                      width: 300,
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
