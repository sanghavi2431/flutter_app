import 'dart:convert';
import 'dart:io';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/screens/issue_list_screen/bloc/issue_list_bloc.dart';
import 'package:woloo_smart_hygiene/screens/issue_list_screen/bloc/issue_list_event.dart';
import 'package:woloo_smart_hygiene/screens/supervisor_dashboard/bloc/supervisor_dashboard_bloc.dart';
import 'package:woloo_smart_hygiene/screens/supervisor_dashboard/bloc/supervisor_dashboard_event.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'screens/dashboard/bloc/dashboard_bloc.dart';
import 'screens/dashboard/bloc/dashboard_event.dart';
import 'screens/dashboard/controller/dash_controller.dart';

class Messaging {
  DashboardBloc dashboardBloc = DashboardBloc();
  DashController dashController = Get.put(DashController());
  Future initialize() async {
    var flNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isAndroid) await createNotificationChannel();

    await FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
    //   dashboardBloc.add(GetTaskTamplates());
  //   GetIt.instance<DashboardBloc>().add(const GetTaskTamplates());

      flNotificationsPlugin.show(
        message.hashCode,
        message.notification?.title,
        message.notification?.body,
        notificationDetails(),
        payload: jsonEncode(message.data),
      );
      
 
      try {
        int role = GetIt.instance<GlobalStorage>().getRoleId();
        // print(" role $role");
        if (role == 2) {
          GetIt.instance<SupervisorDashboardBloc>().add(const GetSupervisorDashboardData());
          int supervisorId = GetIt.instance<GlobalStorage>().getId();
          GetIt.instance<IssueListBloc>().add(GetAllIssues(supervisorId: supervisorId));
        }
        else
        if(role == 1){

               // dashController.mapGetDashboardToState();

          dashboardBloc.add( const GetTaskTamplates());
      //  GetIt.instance<DashboardBloc>().add(GetTaskTamplates());

           
        }
      //
      } catch (e) {
         debugPrint(e.toString());
      }

    });

    var notificationSettings = InitializationSettings(
      android: androidNotificationSettings(),
      iOS: iosNotificationSettings(),
    );

    await flNotificationsPlugin.initialize(
      notificationSettings,

      onDidReceiveNotificationResponse: (details) {

      },
    );
  }

  AndroidInitializationSettings androidNotificationSettings() {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',

    );
    return androidSettings;
  }

  DarwinInitializationSettings iosNotificationSettings() {
    DarwinInitializationSettings iosSettings = const DarwinInitializationSettings();
    return iosSettings;
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(

      android: AndroidNotificationDetails(

        "10000012",
        "smart_hygiene_channel",
        sound: RawResourceAndroidNotificationSound('notification'),
        enableLights: true,
        color: AppColors.buttonColor,
        ledColor: Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500,
        importance: Importance.max,
        playSound: true,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(sound: 'notification.caf'),
    );
  }

  Future<void> createNotificationChannel() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var androidNotificationChannel = const AndroidNotificationChannel(
      "10000012",
      "smart_hygiene_channel",
      sound: RawResourceAndroidNotificationSound('notification'),
      enableLights: true,
      ledColor: Color.fromARGB(255, 255, 0, 0),
      importance: Importance.max,
      playSound: true,



    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>() //
        ?.createNotificationChannel(androidNotificationChannel);
  }
}

@pragma("vm:entry-point")
Future<void> backgroundNotificationHandler(RemoteMessage message) async {
  Messaging messaging = Messaging();
 

  var flNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var notificationSettings = InitializationSettings(
    android: messaging.androidNotificationSettings(),
    iOS: messaging.iosNotificationSettings(),
  );
  await flNotificationsPlugin.initialize(
    notificationSettings,
    onDidReceiveBackgroundNotificationResponse: (details) {},
  );

  flNotificationsPlugin.show(
    message.hashCode,
    message.notification?.title,
    message.notification?.body,
    messaging.notificationDetails(),
  );
}
