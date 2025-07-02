import 'dart:io';
import 'package:device_preview/device_preview.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/login/bloc/signup_bloc.dart';
import 'package:woloo_smart_hygiene/firebase_options.dart';
import 'package:woloo_smart_hygiene/injection_container.dart' as di;
import 'package:woloo_smart_hygiene/messaging.dart';
import 'package:woloo_smart_hygiene/screens/login/bloc/login_bloc.dart';
import 'package:woloo_smart_hygiene/screens/my_account/view/bloc/profile_bloc.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'app.dart';
import 'b2b_store/bloc/b2b_store_bloc.dart';
import 'client_flow/screens/dashbaord/bloc/dashboard_bloc.dart';
import 'screens/dashboard/bloc/dashboard_bloc.dart';
import 'screens/washroom_image_screen/images_bloc/bloc/capture_bloc.dart';
// import 'messaging.dart';

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

  if (Platform.isAndroid) {
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
    (value) => runApp(EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('hi', 'IN'),
        Locale('mr', 'IN'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SignupBloc>(
            create: (BuildContext context) => SignupBloc(),
          ),
          BlocProvider<LoginBloc>(
            create: (BuildContext context) => LoginBloc(),
          ),
          BlocProvider<CaptureBloc>(
            create: (BuildContext context) => CaptureBloc(),
          ),
          BlocProvider<DashboardBloc>(
            create: (BuildContext context) => DashboardBloc(),
          ),
          BlocProvider<ClientDashBoardBloc>(
            create: (BuildContext context) => ClientDashBoardBloc(),
          ),
          BlocProvider<ProfileBloc>(
            create: (BuildContext context) => ProfileBloc(),
          ),
            BlocProvider<B2bStoreBloc>(
            create: (BuildContext context) => B2bStoreBloc(),
          ),
        ],
        child:
            // DeviceP
            //  DevicePreview(
            //     enabled: !kReleaseMode,
            //     builder: (context) =>
            //         App(), // Wrap your app
            //  ),
            const App(),
      ),
    )),
    // ),
  );
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// // import 'package:go_router/go_router.dart';
// import 'package:multi_dropdown/multi_dropdown.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),

//       title: 'Multiselect dropdown demo',
//       debugShowCheckedModeBanner: false,
//       themeMode: ThemeMode.dark,
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//       ),
      
//       // routerConfig: 
//       // GoRouter(routes: [
//       //   GoRoute(
//       //     path: '/',
//       //     builder: (context, state) {
//       //       return const MyHomePage();
//       //     },
//       //   ),
//       // ]),
//       // builder: (context, child) {
//       //   return MyHomePage();
//       // },
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class User {
//   final String name;
//   final int id;

//   User({required this.name, required this.id});

//   @override
//   String toString() {
//     return 'User(name: $name, id: $id)';
//   }
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final _formKey = GlobalKey<FormState>();

//   final controller = MultiSelectController<User>();

//   @override
//   Widget build(BuildContext context) {
//     var items = [
//       DropdownItem(label: 'Nepal', value: User(name: 'Nepal', id: 1)),
//       DropdownItem(label: 'Australia', value: User(name: 'Australia', id: 6)),
//       DropdownItem(label: 'India', value: User(name: 'India', id: 2)),
//       DropdownItem(label: 'China', value: User(name: 'China', id: 3)),
//       DropdownItem(label: 'USA', value: User(name: 'USA', id: 4)),
//       DropdownItem(label: 'UK', value: User(name: 'UK', id: 5)),
//       DropdownItem(label: 'Germany', value: User(name: 'Germany', id: 7)),
//       DropdownItem(label: 'France', value: User(name: 'France', id: 8)),
//     ];
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: SingleChildScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: MediaQuery.of(context).size.height,
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       const SizedBox(
//                         height: 4,
//                       ),
//                       MultiDropdown<User>(
//                         items: items,
//                         controller: controller,
//                         enabled: true,

//                          selectedItemBuilder: (item) {
//                            return Text(item.label);
//                          },
//                         // searchEnabled: true,
//                         chipDecoration: const ChipDecoration(
//                           backgroundColor: Colors.yellow,
//                           wrap: true,
//                           runSpacing: 2,
//                           spacing: 10,
//                         ),
//                         fieldDecoration: FieldDecoration(

//                           hintText: 'Countries',
//                           hintStyle: const TextStyle(color: Colors.black87),
//                           // prefixIcon: const Icon(CupertinoIcons.flag),
//                           showClearIcon: false,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: const BorderSide(color: Colors.grey),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: const BorderSide(
//                               color: Colors.black87,
//                             ),
//                           ),
//                         ),
                        
//                         dropdownDecoration: const DropdownDecoration(
//                           marginTop: 2,
//                           maxHeight: 300,
//                           // header: Padding(
//                           //   padding: EdgeInsets.all(8),
//                           //   child: Text(
//                           //     'Select countries from the list',
//                           //     textAlign: TextAlign.start,
//                           //     style: TextStyle(
//                           //       fontSize: 16,
//                           //       fontWeight: FontWeight.bold,
//                           //     ),
//                           //   ),
//                           // ),
//                         ),
//                         dropdownItemDecoration: DropdownItemDecoration(

//                           selectedIcon:
//                               const Icon(Icons.check_box, color: Colors.green),
//                           disabledIcon:
//                               Icon(Icons.lock, color: Colors.grey.shade300),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please select a country';
//                           }
//                           return null;
//                         },
//                          itemBuilder: (item, index, onTap) {
//                     final isSelected = controller.selectedItems.contains(item) ;

//   return InkWell(
//     onTap: () {
//       onTap(); // this toggles selection
//     },
//     child: ListTile(
//       leading: Checkbox(
//         value: isSelected,
//         onChanged: (_) => onTap(), // manually toggle
//       ),
//       title: Text(item.label),
//     ),
//   );

//                          },

//                         onSelectionChange: (selectedItems) {
//                           debugPrint("OnSelectionChange: $selectedItems");
//                         },
//                       ),
//                       const SizedBox(height: 12),
//                       Wrap(
//                         spacing: 8,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               if (_formKey.currentState?.validate() ?? false) {
//                                 final selectedItems = controller.selectedItems;

//                                 debugPrint(selectedItems.toString());
//                               }
//                             },
//                             child: const Text('Submit'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               controller.selectAll();
//                             },
//                             child: const Text('Select All'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               controller.clearAll();
//                             },
//                             child: const Text('Unselect All'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               controller.addItems([
//                                 DropdownItem(
//                                     label: 'France',
//                                     value: User(name: 'France', id: 8)),
//                               ]);
//                             },
//                             child: const Text('Add Items'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               controller.selectWhere((element) =>
//                                   element.value.id == 1 ||
//                                   element.value.id == 2 ||
//                                   element.value.id == 3);
//                             },
//                             child: const Text('Select Where'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               controller.selectAtIndex(0);
//                             },
//                             child: const Text('Select At Index'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               controller.openDropdown();
//                             },
//                             child: const Text('Open/Close dropdown'),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ));
//   }
// }
