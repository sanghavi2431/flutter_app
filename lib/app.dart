
import 'package:app_links/app_links.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:woloo_smart_hygiene/screens/splash_screen/view/splash.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:context_holder/context_holder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'client_flow/screens/iot/view/iot_onbaord.dart';

import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    configLoading();
    super.initState();
    _initDeepLinks();
  }

   final AppLinks _appLinks = AppLinks();


    void _initDeepLinks() async {
    // Handle app launch from link
    
    // final uri = await _appLinks.getInitialLink();
    // _handleUri(uri);

    // Handle app coming to foreground from background via link
    _appLinks.uriLinkStream.listen((Uri? uri) {
      // _handleUri(uri);
           print('Deep link received: $uri');
    });
  }

  void _handleUri(Uri? uri) {
     print('Deep link received: $uri');
    if (uri != null) {
      print('Deep link received: $uri');
      if (uri.scheme == 'woloo' && uri.host == 'home') {
        // Navigator.pushNamed(context, '/home');

      }
      // Handle other links like woloo://referral?code=XYZ
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return 
        ConnectivityAppWrapper(
          app: 
          GetMaterialApp(
            // builder: FToastBuilder(),
            navigatorKey: ContextHolder.key,
            debugShowCheckedModeBanner: false,
            title: AppName.APP_NAME,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            
            builder: EasyLoading.init(
              builder: (context, child) {
                return ConnectivityWidgetWrapper(
                    disableInteraction: true, child: child!);
              },
            ),
            theme: ThemeData(
              disabledColor: Colors.grey,
              textTheme: GoogleFonts.poppinsTextTheme(),
                scaffoldBackgroundColor: AppColors.white,
                  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,

                textStyle: const TextStyle(fontSize: 18,
     color: AppColors.black,
     fontWeight: FontWeight.bold),
  
        // backgroundColor: Colors.red, // Use this
        // side: const BorderSide(
        //   width: 1.5,
        //   color: Color(0xFFC5C5C5),
        // ),
      ),
    ),
  // ),
                // dropdownMenuTheme: const DropdownMenuThemeData(
                //   menuStyle: MenuStyle(
                //     backgroundColor: Color(0xfffffff)
                //   )
                // ),
                // colorScheme:,
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.white,
                  surfaceTintColor: Colors.transparent
              )
            ),
            home: GestureDetector(
              child: child,
            ),
          ),
        );
      },
      child: const SplashScreen(),
    );
  }

  void configLoading() {
    EasyLoading.instance
      // ..indicatorWidget = CustomLoaderWidget(message: "")
      ..indicatorType = EasyLoadingIndicatorType.fadingFour
      ..loadingStyle = EasyLoadingStyle.light
      ..maskColor = Colors.black26
      ..maskType = EasyLoadingMaskType.custom
      ..indicatorColor = AppColors.buttonColor
      ..indicatorSize = 45.0
      ..backgroundColor = Colors.black26
      ..radius = 10.0
      ..userInteractions = true
      ..dismissOnTap = true;
  }
}
