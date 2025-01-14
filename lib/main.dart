import 'dart:io';

import 'package:Woloo_Smart_hygiene/firebase_options.dart';
import 'package:Woloo_Smart_hygiene/injection_container.dart' as di;
import 'package:Woloo_Smart_hygiene/messaging.dart';
import 'package:Woloo_Smart_hygiene/screens/login/bloc/login_bloc.dart';
import 'package:Woloo_Smart_hygiene/screens/my_account/view/bloc/profile_bloc.dart';
import 'package:Woloo_Smart_hygiene/utils/app_color.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_pie_chart/easy_pie_chart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app.dart';
import 'screens/dashboard/bloc/dashboard_bloc.dart';
import 'screens/washroom_image_screen/images_bloc/bloc/capture_bloc.dart';
// import 'messaging.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_driver/driver_extension.dart';


final mediaStorePlugin = MediaStore();
void main() async {
 //  enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  if (Platform.isAndroid) {
    await MediaStore.ensureInitialized();
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
 // await Future.delayed(const Duration(seconds: 1));
  FirebaseMessaging.onBackgroundMessage(backgroundNotificationHandler);
  await GetStorage.init();
  await di.init();

  // Messaging.initFCM();

  if (kReleaseMode) {
    /// Pass all uncaught "fatal" errors from the framework to Crashlytics
    // FlutterError.onError = (errorDetails) {
    //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    // };
    //
    // /// Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    // PlatformDispatcher.instance.onError = (error, stack) {
    //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    //   return true;
    // };
  }

    if ( Platform.isAndroid) {
        List<Permission> permissions = [
    Permission.storage,
  ];

  if ((await mediaStorePlugin.getPlatformSDKInt()) >= 33) {
    permissions.add(Permission.photos);
    permissions.add(Permission.audio);
    permissions.add(Permission.storage);
  }

  await permissions.request();
  // we are not checking the status as it is an example app. You should (must) check it in a production app

  // You have set this otherwise it throws AppFolderNotSetException
  MediaStore.appFolder = "WolooSmartHygine";
    }

  /// change status bar color
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(
      EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('hi', 'IN'),
          Locale('mr', 'IN'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child:
        MultiBlocProvider(
          providers: [
            BlocProvider<LoginBloc>(
              create: (BuildContext context) => LoginBloc(),
            ),
               BlocProvider<CaptureBloc>(
              create: (BuildContext context) => CaptureBloc(),),

              BlocProvider<DashboardBloc>(
              create: (BuildContext context) => DashboardBloc(),
            ),
               BlocProvider<ProfileBloc>(
              create: (BuildContext context) => ProfileBloc(),
            ),
          ],
          child:
             // DeviceP
         // DevicePreview(
         //    enabled: !kReleaseMode,
         //    builder: (context) =>
         //        App(), // Wrap your app
         // ),
          App(),
        ),
      )


      ),
    // ),
  );
}
