
import 'package:Woloo_Smart_hygiene/screens/splash_screen/view/splash.dart';
import 'package:Woloo_Smart_hygiene/utils/app_color.dart';
import 'package:Woloo_Smart_hygiene/utils/app_constants.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:context_holder/context_holder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


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
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return 
        ConnectivityAppWrapper(
          app: 
          
          GetMaterialApp(
            navigatorKey: ContextHolder.key,
            debugShowCheckedModeBanner: false,
            title: AppName.APP_NAME,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            builder: EasyLoading.init(
              builder: (context, child) {
                return 
                ConnectivityWidgetWrapper(
                  disableInteraction: true,
                  child:
                   child!
                );
              },
            ),
            theme: ThemeData(
              disabledColor: Colors.grey,
              textTheme: GoogleFonts.poppinsTextTheme(),
              appBarTheme: AppBarTheme(
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
