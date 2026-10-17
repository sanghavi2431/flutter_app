import 'dart:async';
import 'dart:convert';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/core/model/app_launch_model.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/custom_dialogue_widget.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:woloo_smart_hygiene/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:woloo_smart_hygiene/screens/dashboard/bloc/dashboard_event.dart';
import 'package:woloo_smart_hygiene/screens/dashboard/bloc/dashboard_state.dart';
import 'package:woloo_smart_hygiene/screens/dashboard/controller/dash_controller.dart';
import 'package:woloo_smart_hygiene/screens/dashboard/view/dashboard_screen.dart';
import 'package:woloo_smart_hygiene/screens/dashboard/view/janitor_dashboard.dart';
import 'package:woloo_smart_hygiene/screens/janitor_profile_screen/view/janitor_profile_screen.dart';
import 'package:woloo_smart_hygiene/screens/my_account/view/bloc/profile_event.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/profile_image_url.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

import '../../common_widgets/error_widget.dart';
import '../../my_account/data/model/profile_model.dart';
import '../../my_account/view/bloc/profile_bloc.dart';
import '../../my_account/view/bloc/profile_state.dart';
import '../data/model/dashboard_model_class.dart';
import 'iot_task.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int selectedCard = -1;
  GlobalStorage globalStorage = GetIt.instance();
  bool serviceStatus = false;
  bool haspermission = false;
  bool showList = false;
  bool onTapCheckIn = false;
  String profileName = "";
  String profileImage = "";
  String profileshift = "";
  String checkInTime = "";
  String checkOutTime = "";
  String inTime = "";
  String inTimeDate = "";
  String outTime = "";
  String outTimeDate = "";
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  String? _currentAddress;
  DateTime currentTime = DateTime.now();
  late StreamSubscription<Position> positionStream;
  String? location;
  DashboardBloc dashboardBloc = DashboardBloc();
  AppLaunchModel _appLaunchModel = AppLaunchModel();
  String? type;
  final List<DashboardModelClass> _data = [];
  List<DashboardModelClass> filter = [];
  bool isInt = false;
  DashController dashController = Get.put(DashController());
  final AppinioSwiperController pendingCtrl = AppinioSwiperController();
  final AppinioSwiperController acceptCtrl = AppinioSwiperController();
  final AppinioSwiperController rfcCtrl = AppinioSwiperController();
  final AppinioSwiperController ongoingCtrl = AppinioSwiperController();
  final AppinioSwiperController completeCtrl = AppinioSwiperController();
  String dropdownvalue = 'All';
  int _selectedIndex = 0;
  //  static const TextStyle optionStyle =
  // TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int? _selectedLanguage;
  final List<String> _languages = ["English", "हिंदी", "मराठी"];
  final List<Locale> _locales = const [
    Locale('en', 'US'),
    Locale('hi', 'IN'),
    Locale('mr', 'IN')
  ];
  ProfileModel profile = ProfileModel();
  ProfileBloc? profileBloc = GetIt.instance<ProfileBloc>();

  // List of items in our dropdown menu
  var items = [
    'All',
    'Ongoing',
    'Pending',
    'Accepted',
    'Completed',
    'Request for closure'
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    // One getUserByID on dashboard load for header (name/image/shift).
    // Cached in ProfileBloc so profile screen / return won't re-hit the API.
    final token = globalStorage.getToken();
    if (token.isNotEmpty) {
      final decodedToken = JwtDecoder.decode(token);
      profileBloc?.add(UpdateProfile(id: decodedToken["id"]));
    }

    dashboardBloc.add(CheckAttendance());
    isInt = true;

    setState(() {
      // Optimistic local state until onAppLoad response arrives.
      onTapCheckIn = globalStorage.isCheckedIn();
      showList = onTapCheckIn;
      inTime = globalStorage.getTime();
      inTimeDate = globalStorage.getDate();

      profileName = globalStorage.getProfileName().isNotEmpty
          ? globalStorage.getProfileName()
          : globalStorage.getSupervisorName();
      profileImage = globalStorage.getProfileImage();
      profileshift = globalStorage.getShift();
    });
    // Single task list fetch for this session open.
    dashboardBloc.add(const GetTaskTamplates());

    super.initState();
  }

  bool _localeSet = false; // Flag to ensure locale is set only once

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Set locale from stored language codes when Dashboard loads (only once)
    // Use addPostFrameCallback to avoid calling setState during build
    if (!_localeSet && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_localeSet && mounted) {
          List<String> languageCodes = globalStorage.getLanguageCodes();
          debugPrint(
              "Dashboard - didChangeDependencies (post-frame), language codes: $languageCodes");
          debugPrint(
              "Dashboard - Current context locale: ${context.locale.languageCode}");

          if (languageCodes.isNotEmpty) {
            String langCode = languageCodes.first;
            Locale? locale;
            switch (langCode.toLowerCase()) {
              case 'en':
                locale = const Locale('en', 'US');
                break;
              case 'hi':
                locale = const Locale('hi', 'IN');
                break;
              case 'mr':
                locale = const Locale('mr', 'IN');
                break;
              case 'kn':
                locale = const Locale('kn', 'IN');
                break;
              case 'ta':
                locale = const Locale('ta', 'IN');
                break;
              case 'te':
                locale = const Locale('te', 'IN');
                break;
              case 'ml':
                locale = const Locale('ml', 'IN');
                break;
              default:
                locale = const Locale('en', 'US');
            }

            debugPrint(
                "Dashboard - Target locale: ${locale.languageCode}, Current: ${context.locale.languageCode}");

            // Only set if different from current locale
            if (context.locale != locale) {
              debugPrint(
                  "Dashboard - Setting locale from storage: ${locale.languageCode}");
              context.setLocale(locale);
              Get.updateLocale(locale);
              _localeSet = true;

              // Force rebuild to apply locale change
              if (mounted) {
                setState(() {});
                debugPrint(
                    "Dashboard - Rebuilt with locale: ${context.locale.languageCode}");
              }
            } else {
              debugPrint(
                  "Dashboard - Locale already set to: ${locale.languageCode}");
              _localeSet = true;
            }
          } else {
            debugPrint("Dashboard - No language codes found in storage");
            _localeSet = true;
          }
        }
      });
    }
  }

  //   updat()async{
  //
  //     //   var firebase = FirebaseMessaging.instance;
  //     //   var token = await firebase.getToken();
  //  // profileBloc?.add( UpdateTokenOnVerifyOTP(
  //  //     token:token!
  //  // ));
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Re-sync attendance when returning from background.
    if (state == AppLifecycleState.resumed && mounted) {
      dashboardBloc.add(CheckAttendance());
    }
  }

  void _applyAttendanceFromAppLaunch(AppLaunchModel data) {
    final status = (data.lastAttendance ?? '').trim().toLowerCase();
    _appLaunchModel = data;
    type = data.lastAttendance;

    if (status == 'check_in') {
      checkGps();
      onTapCheckIn = true;
      showList = true;
      globalStorage.saveCheckIn(isCheckedIn: true);
    } else {
      // check_out / empty / unknown → treat as clocked out
      onTapCheckIn = false;
      showList = false;
      globalStorage.saveCheckIn(isCheckedIn: false);
      outTime = globalStorage.getOutTime();
      outTimeDate = globalStorage.getOutDate();
    }

    location = globalStorage.getLocation();
    inTime = globalStorage.getTime();
    inTimeDate = globalStorage.getDate();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
        bloc: profileBloc,
        listener: (context, state) {
          if (state is ProfleSuccess) {
            profile = state.data;
            final name = [
              profile.results?.firstName ?? '',
              profile.results?.lastName ?? '',
            ].where((s) => s.trim().isNotEmpty).join(' ').trim();
            if (mounted) {
              setState(() {
                if (name.isNotEmpty) {
                  globalStorage.saveProfile(profileName: name);
                  profileName = name;
                }
                if ((profile.results?.profileImage ?? '').isNotEmpty) {
                  profileImage = profile.results!.profileImage!;
                }
                if (profile.results?.startTime != null) {
                  profileshift =
                      '${profile.results!.startTime!.hour.toString().padLeft(2, '0')}:${profile.results!.startTime!.minute.toString().padLeft(2, '0')}';
                }
              });
            }
          }
        },
        builder: (context, state) {
          if (state is ProfleError) {
            EasyLoading.show(status: state.error);
          }

          return BlocConsumer(
            bloc: dashboardBloc,
            listener: (context, state) async {
              if (state is AppLaunchLoading) {
                EasyLoading.show(status: state.message);
              }

              if (state is AppLaunchError) {
                EasyLoading.dismiss();
              }

              if (state is AppLaunchSuccess) {
                EasyLoading.dismiss();
                debugPrint(
                    "appLaunchResponse---->${state.data.toJson()}");
                if (!mounted) return;
                setState(() {
                  _applyAttendanceFromAppLaunch(state.data);
                });
              }

              if (state is ClockInSuccessful) {
                EasyLoading.dismiss();
                if (dashController.data.isEmpty) {
                  dashboardBloc.add(const GetTaskTamplates());
                }

                String formattedDate =
                    DateFormat('hh:mm:ss  a').format(currentTime);
                DateTime parsedTime = DateTime.parse(state
                    .attendanceModel.results!.attendance!.lastAttendance!.time!
                    .toString());
                DateTime local = parsedTime.toLocal();
                String timeOnly =
                    "${local.hour}:${local.minute}:${local.second}";
                String dateOnly = "${local.day}-${local.month}-${local.year}";
                globalStorage.saveTime(accessTime: timeOnly);
                globalStorage.saveDate(accessTime: dateOnly);
                globalStorage.saveCheckIn(isCheckedIn: true);

                if (!mounted) return;
                setState(() {
                  onTapCheckIn = true;
                  showList = true;
                  checkInTime = formattedDate;
                  inTime = globalStorage.getTime();
                  inTimeDate = globalStorage.getDate();
                });
              }

              if (state is ClockInLoading) {
                EasyLoading.show(status: state.message);
              }

              if (state is ClockInError) {
                EasyLoading.dismiss();
                EasyLoading.showError(state.error.message);
                // Keep previous attendance UI; do not force checked-in on error.
              }

              if (state is ClockOutSuccessful) {
                EasyLoading.dismiss();
                globalStorage.saveCheckIn(isCheckedIn: false);

                String formattedDate =
                    DateFormat('hh:mm:ss  a').format(currentTime);
                DateTime parsedTime = DateTime.parse(state
                    .attendanceModel.results!.attendance!.lastAttendance!.time!
                    .toString());
                DateTime local = parsedTime.toLocal();
                String timeOnly =
                    "${local.hour}:${local.minute}:${local.second}";
                String dateOnly = "${local.day}-${local.month}-${local.year}";
                globalStorage.saveOutTime(accessTime: timeOnly);
                globalStorage.saveOutDate(accessTime: dateOnly);

                if (!mounted) return;
                setState(() {
                  onTapCheckIn = false;
                  showList = false;
                  checkOutTime = formattedDate;
                  outTime = globalStorage.getOutTime();
                  outTimeDate = globalStorage.getOutDate();
                });
              }
              if (state is ClockOutLoading) {
                EasyLoading.show(status: state.message);
              }
              if (state is ClockOutError) {
                EasyLoading.dismiss();
                EasyLoading.showError(state.error.message);
                // Keep previous attendance UI; do not force checked-out on error.
              }
            },
            builder: (context, state) {
              _widgetOptions = [
                JanitorDashboard(),
                Obx(
                  () => RegularTask(
                      dashboardBloc: dashboardBloc,
                      filter: dashController.filterData.value
                          .where((e) => e.requestType == "Regular")
                          .toList(),
                      //dashController.filterData.value,
                      lat: lat,
                      long: long),
                ),
                Obx(
                  () => IotTask(
                    dashboardBloc: dashboardBloc,
                    filter: dashController.filterData.value
                        .where((e) => e.requestType == "IOT")
                        .toList(),
                    lat: lat,
                    long: long,
                  ),
                )
              ];
              return Scaffold(
                backgroundColor: AppColors.white,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: AppColors.white,
                  title: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            MydashboardScreenConstants.TITLE_TEXT.tr(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.font24.copyWith(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const JanitorProfileScreen()),
                        );
                      },
                      child: Container(
                        width: 42.w,
                        height: 42.h,
                        decoration: BoxDecoration(
                            color: AppColors
                                .bottomNavigationColor, // Background color of the container
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: 0.2), // Shadow color
                                spreadRadius:
                                    1, // How wide the shadow should spread
                                blurRadius: 10, // The blur effect of the shadow
                                offset: const Offset(
                                    0, 0), // No offset for shadow on all sides
                              ),
                            ],
                            borderRadius: BorderRadius.circular(12.r)),
                        // color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: CustomImageProvider(
                            image: AppImages.profile,
                            width: 25.w,
                            height: 25.h,
                            fit: BoxFit.cover,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                // floatingActionButton: FloatingActionButton(onPressed: () async {
                //    await checkGps();
                // }, ),
                body: RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () {
                        dashboardBloc
                            .add(const GetTaskTamplates(forceRefresh: true));
                      },
                    );
                  },
                  child: SingleChildScrollView(
                    // physics: NeverScrollableScrollPhysics(),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10.h,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors
                                  .white, // Background color of the container
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withValues(alpha: 0.2), // Shadow color
                                  spreadRadius:
                                      1, // How wide the shadow should spread
                                  blurRadius:
                                      10, // The blur effect of the shadow
                                  offset: const Offset(0,
                                      0), // No offset for shadow on all sides
                                ),
                              ],
                              // border:
                              // Border.all(
                              //   color: AppColors.containerBorder,
                              //   width: 0.w,
                              // ),
                              borderRadius: BorderRadius.circular(25.r)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 10.h,
                            ),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                profile.results == null
                                    ? Container()
                                    : Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Builder(
                                            builder: (context) {
                                              final imageUrl =
                                                  ProfileImageUrl.resolve(
                                                baseUrl:
                                                    profile.results?.baseUrl,
                                                profileImage: profile
                                                    .results?.profileImage,
                                              );
                                              if (imageUrl == null) {
                                                return Center(
                                                  child: CircleAvatar(
                                                    maxRadius: 30,
                                                    backgroundColor:
                                                        AppColors.greyBorder,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: Image.asset(
                                                        AppImages.profileImg,
                                                        height: 60.h,
                                                        width: 60.w,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                              return CircleAvatar(
                                                radius: 30,
                                                backgroundColor:
                                                    AppColors.greyBorder,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: Image.network(
                                                    imageUrl,
                                                    height: 60.h,
                                                    width: 60.w,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Image.asset(
                                                      AppImages.profileImg,
                                                      height: 60.h,
                                                      width: 60.w,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(
                                            width: 12.w,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  width: 220.w,
                                                  child: Row(
                                                    children: [
                                                      profile.results == null
                                                          ? const Text("")
                                                          : Text(
                                                              "${profile.results?.firstName ?? ""} ${profile.results?.lastName ?? ""}",
                                                              style:
                                                                  AppTextStyle
                                                                      .font14w7,
                                                            ),
                                                    ],
                                                  )
                                                  // },
                                                  // ),

                                                  ),
                                              const Divider(),
                                              if (location != null &&
                                                  location != "") ...[
                                                SizedBox(
                                                  width: 220.w,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .black
                                                                          .withValues(
                                                                              alpha: 0.2), // Shadow color
                                                                      spreadRadius:
                                                                          1, // How wide the shadow should spread
                                                                      blurRadius:
                                                                          10, // The blur effect of the shadow
                                                                      offset: const Offset(
                                                                          0,
                                                                          0), // No offset for shadow on all sides
                                                                    ),
                                                                  ],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(25
                                                                              .r),
                                                                  color: AppColors
                                                                      .white),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4.w),
                                                              child: location ==
                                                                      null
                                                                  ? const Text(
                                                                      "")
                                                                  : Text(
                                                                      "$location",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          1,
                                                                      softWrap:
                                                                          false,
                                                                      style: AppTextStyle
                                                                          .font14bold
                                                                          .copyWith(
                                                                        color: AppColors
                                                                            .locationColor,
                                                                      )
                                                                      // TextStyle(
                                                                      //   fontSize: 12.sp,
                                                                      //   fontWeight: FontWeight.w400,
                                                                      //   color: AppColors.locationColor,
                                                                      // ),
                                                                      ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // SizedBox(
                                                //   height: 5.h,
                                                // ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),

                                const Divider(),

                                // SizedBox(
                                //   height: 12.h,
                                // ),

                                Center(
                                  child: Container(
                                    width: 108.w,
                                    height: 28.w,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                                alpha: 0.2), // Shadow color
                                            spreadRadius:
                                                1, // How wide the shadow should spread
                                            blurRadius:
                                                10, // The blur effect of the shadow
                                            offset: const Offset(0,
                                                0), // No offset for shadow on all sides
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(25.r),
                                        color: AppColors.bottomNavigationColor),
                                    child: Center(
                                      child: Text(
                                        MyJanitorsListScreenConstants
                                            .JANITOR_PRESENT
                                            .tr(),
                                        // MydashboardScreenConstants.,
                                        style: AppTextStyle.font14bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          onTapCheckIn
                                              ? GestureDetector(
                                                  onTap: () async {},
                                                  child: Container(
                                                    height: 70.h,
                                                    width: 70.w,
                                                    decoration: const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppColors
                                                            .yellowSplashColor),
                                                    child: Center(
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      4.0),
                                                          child: Text(
                                                            MydashboardScreenConstants
                                                                .IN
                                                                .tr(),
                                                            style: AppTextStyle
                                                                .font24bold
                                                                .copyWith(
                                                              color: AppColors
                                                                  .black,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: () async {
                                                    final ready =
                                                        await ensureLocationForClock();
                                                    if (!ready) return;

                                                    var latitude =
                                                        double.tryParse(lat) ??
                                                            0;
                                                    var longitude =
                                                        double.tryParse(long) ??
                                                            0;

                                                    debugPrint(
                                                        "lattttt  $latitude");
                                                    debugPrint(
                                                        "longggg   $longitude");

                                                    dashboardBloc.add(
                                                        MarkAttendance(
                                                            type: 'check_in',
                                                            locations: [
                                                          latitude,
                                                          longitude
                                                        ]));
                                                  },
                                                  child: Container(
                                                    height: 70.h,
                                                    width: 70.w,
                                                    decoration: const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppColors
                                                            .bottomNavigationColor),
                                                    child: Center(
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      4.0),
                                                          child: Text(
                                                            MydashboardScreenConstants
                                                                .IN
                                                                .tr(),
                                                            style: AppTextStyle
                                                                .font24bold
                                                                .copyWith(
                                                              color: AppColors
                                                                  .white,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          onTapCheckIn
                                              ? Column(
                                                  children: [
                                                    Text(
                                                      inTime,
                                                      style: AppTextStyle
                                                          .font10bold,
                                                    ),
                                                    Text(
                                                      inTimeDate,
                                                      style: AppTextStyle
                                                          .font10bold,
                                                    )
                                                  ],
                                                )
                                              : SizedBox(
                                                  height: 20.h,
                                                )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5.w,
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                                height: 1.0,
                                                width: 90.w,
                                                color: AppColors.greyLineColor),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Text(
                                              MydashboardScreenConstants
                                                  .PULL_TO_REFRESH
                                                  .tr(),
                                              style: AppTextStyle.font12bold,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          !onTapCheckIn
                                              ? GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                    height: 70.h,
                                                    width: 70.w,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: AppColors
                                                          .greyCircleColor,
                                                    ),
                                                    child: Center(
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      4.0),
                                                          child: Text(
                                                            MydashboardScreenConstants
                                                                .OUT
                                                                .tr(),
                                                            style: AppTextStyle
                                                                .font20bold
                                                                .copyWith(
                                                              color: AppColors
                                                                  .white,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    openDialog();
                                                  },
                                                  child: Container(
                                                    height: 70.h,
                                                    width: 70.w,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: AppColors
                                                          .checkOutColor,
                                                    ),
                                                    child: Center(
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      4.0),
                                                          child: Text(
                                                            MydashboardScreenConstants
                                                                .OUT
                                                                .tr(),
                                                            style: AppTextStyle
                                                                .font20bold
                                                                .copyWith(
                                                              color: AppColors
                                                                  .white,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          outTime.isNotEmpty
                                              ? Column(
                                                  children: [
                                                    Text(
                                                      outTime,
                                                      style: AppTextStyle
                                                          .font10bold,
                                                    ),
                                                    Text(
                                                      outTimeDate,
                                                      style: AppTextStyle
                                                          .font10bold,
                                                    )
                                                  ],
                                                )
                                              : SizedBox(
                                                  height: 20.h,
                                                )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                          color: const Color(0xffFFF035),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: CustomImageProvider(
                                          image: AppImages.rewardIcon,
                                          width: 32,
                                          height: 32,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Text.rich(
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'earn'.tr(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                // fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            // ),
                                            TextSpan(
                                              text: '${'tenPoints'.tr()} ',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: '${'everyDayLogin'.tr()}! ',
                                              style: TextStyle(
                                                fontSize: 12,
                                                // fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            // TextSpan(text: ' world!'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Padding(
                                //   padding: EdgeInsets.symmetric(
                                //     horizontal: 10.w,
                                //   ),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       Column(
                                //         children: [
                                //           Text(
                                //               MydashboardScreenConstants.CHECK_IN
                                //                   .tr(),
                                //               style: AppTextStyle.font12
                                //                   .copyWith(color: Colors.black)
                                //               // TextStyle(
                                //               //     fontSize: 12.sp,
                                //               //     fontWeight: FontWeight.w400,
                                //               //     color: Colors.black),
                                //               ),
                                //           onTapCheckIn
                                //               ? Text(inTime,
                                //                   style: AppTextStyle.font8
                                //                       .copyWith(color: Colors.black)
                                //                   //  TextStyle(
                                //                   //     fontSize: 8.sp,
                                //                   //     fontWeight: FontWeight.w400,
                                //                   //     color: AppColors.timeColor),
                                //                   )
                                //               : Container(),
                                //         ],
                                //       ),
                                //       Column(
                                //         children: [
                                //           Text(
                                //               MydashboardScreenConstants.CHECK_OUT
                                //                   .tr(),
                                //               style: AppTextStyle.font12
                                //                   .copyWith(color: Colors.black)
                                //               // TextStyle(
                                //               //     fontSize: 12.sp,
                                //               //     fontWeight: FontWeight.w400,
                                //               //     color: Colors.black),
                                //               ),
                                //           !onTapCheckIn
                                //               ? Text(outTime,
                                //                   style: AppTextStyle.font8.copyWith(
                                //                       color: AppColors.timeColor)
                                //                   //  TextStyle(
                                //                   //     fontSize: 8.sp,
                                //                   //     fontWeight: FontWeight.w400,
                                //                   //     color: AppColors.timeColor),
                                //                   )
                                //               : Container(),
                                //         ],
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // Center(
                                //   child: Padding(
                                //     padding: EdgeInsets.symmetric(
                                //         horizontal: 25.h, vertical: 10.h),
                                //     child: SizedBox(
                                //       width: 210,
                                //       height: 60,
                                //       // height: 70,
                                //       child: DropdownButtonFormField(
                                //         decoration: const InputDecoration(
                                //           border: OutlineInputBorder(
                                //             borderRadius: BorderRadius.all(
                                //               Radius.circular(30.0),
                                //             ),
                                //           ),
                                //         ),
                                //         elevation: 0,
                                //         // Initial Value
                                //         value: dropdownvalue,
                                //         // Down Arrow Icon
                                //         icon: const Icon(Icons.keyboard_arrow_down),

                                //         // Array list of items
                                //         items: items.map((String items) {
                                //           return DropdownMenuItem(
                                //             value: items,
                                //             child: Text(items.tr()),
                                //           );
                                //         }).toList(),
                                //         dropdownColor: Colors.white,

                                //         onChanged: (String? newValue) {
                                //           setState(() {
                                //             dropdownvalue = newValue!;
                                //           });

                                //
                                //           if (newValue == "All") {
                                //             dashController.filterData.value =
                                //                 dashController.data.value;
                                //           } else {
                                //             dashController.filterData.value =
                                //                 dashController.data.value
                                //                     .where(
                                //                         (e) => e.status == newValue)
                                //                     .toList();
                                //           }

                                //
                                //         },
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      showList
                          ? BlocConsumer(
                              bloc: dashboardBloc,
                              listener: (context, state) {
                                if (state is GetDashboardDataSuccess) {
                                  EasyLoading.dismiss();
                                  location = globalStorage.getLocation();
                                  print(" locccc in bloc $location");
                                }

                                if (state is UpdateStatusSuccessful) {
                                  EasyLoading.dismiss();
                                }
                              },
                              builder: (context, state) {
                                if (state is DashboardLoading &&
                                    _data.isEmpty) {
                                  EasyLoading.show(
                                      status: MydashboardScreenConstants
                                          .LOADING_TOAST
                                          .tr());
                                }

                                if (state is DashboardError) {
                                  return CustomErrorWidget(
                                      error: state.error.message);
                                }

                                if (state is UpdateStatusError) {
                                  return CustomErrorWidget(
                                      error: state.error.message);
                                }
                                if (state is UpdateStatusLoading) {
                                  EasyLoading.show(
                                      status: MydashboardScreenConstants
                                          .LOADING_TOAST
                                          .tr());
                                }

                                if (state is GetDashboardDataSuccess) {
                                  EasyLoading.dismiss();

                                  // filter =  dashController.data.value!;

                                  //    if(dropdownvalue == "All"){
                                  //
                                  //                filter.value = dashController.data.value;
                                  //    //   filter = _data;
                                  //    }else {
                                  //      filter.value =
                                  //      //  dashController.data.value.where()
                                  //     dashController.data.value.where( (e)=> e.status == dropdownvalue ).toList();
                                  //    }
                                }

                                return _selectedIndex == 0
                                    ? _widgetOptions.elementAt(_selectedIndex)
                                    : SizedBox(
                                        height: 425.h,
                                        child: _widgetOptions
                                            .elementAt(_selectedIndex));
                              })
                          : Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 10.h,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 100.h,
                                    ),
                                    CustomImageProvider(
                                      image: AppImages.blankListImg,
                                      height: 100.h,
                                      width: 100.w,
                                    ),
                                    Text(
                                        MydashboardScreenConstants
                                            .BLANK_LIST_TEXT
                                            .tr(),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: AppTextStyle.font24.copyWith(
                                          color: AppColors.black,
                                        )
                                        //  TextStyle(
                                        //   color: AppColors.black,
                                        //   fontSize: 24.sp,
                                        //   fontWeight: FontWeight.w400,
                                        // ),
                                        )
                                  ],
                                ),
                              ),
                            )
                    ]),
                  ),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  backgroundColor: AppColors.white,
                  elevation: 15,
                  unselectedItemColor: AppColors.black,
                  type: BottomNavigationBarType.fixed,
                  selectedLabelStyle: TextStyle(
                    fontSize:
                        MediaQuery.of(context).size.width < 370 ? 9.sp : 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize:
                        MediaQuery.of(context).size.width < 370 ? 9.sp : 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: CustomImageProvider(
                          image: _selectedIndex == 0
                              ? AppImages.dashboarIcon
                              : AppImages.dashIcon,
                          width: 28,
                          height: 28,
                          color: _selectedIndex == 0
                              ? AppColors.buttonBgColor
                              : null),
                      label: 'dashboard'.tr(),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.task_outlined,
                        size: 30,
                      ),
                      label: 'regularTask'.tr(),
                    ),
                    BottomNavigationBarItem(
                      icon: CustomImageProvider(
                        image: AppImages.iotIcons,
                        width: 30,
                        height: 30,
                        color: _selectedIndex == 2
                            ? AppColors.buttonBgColor
                            : null,
                      ),
                      label: 'iotTask'.tr(),
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: AppColors.buttonBgColor,
                  onTap: _onItemTapped,
                ),
              );
            },

            //  child:
          );
        });
    //
    // );
  }

  TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  /// Ensures GPS is on, permission granted, and coordinates are available.
  /// Shows a notify popup (Open Settings / Cancel) instead of a silent no-op.
  Future<bool> ensureLocationForClock() async {
    haspermission = false;

    EasyLoading.show(
      status: MydashboardScreenConstants.LOCATION_FETCHING_TOAST.tr(),
    );

    try {
      serviceStatus = await Geolocator.isLocationServiceEnabled();
      if (!serviceStatus) {
        EasyLoading.dismiss();
        await _showLocationHelpDialog(
          message: MydashboardScreenConstants.GPS_DISABLED_TOAST.tr(),
          openLocationSettings: true,
        );
        return false;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        EasyLoading.dismiss();
        await _showLocationHelpDialog(
          message: MydashboardScreenConstants.LOCATION_PERMISSION_TEXT.tr(),
          openAppSettingsPage: true,
        );
        return false;
      }

      if (permission == LocationPermission.deniedForever) {
        EasyLoading.dismiss();
        await _showLocationHelpDialog(
          message: MydashboardScreenConstants.LOCATION_PERMISSION_TEXT.tr(),
          openAppSettingsPage: true,
        );
        return false;
      }

      haspermission = true;
      final gotLocation = await getLocation();
      EasyLoading.dismiss();

      if (!gotLocation) {
        await _showLocationHelpDialog(
          message: MydashboardScreenConstants.LOCATION_FETCH_FAILED_TEXT.tr(),
          openLocationSettings: true,
        );
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('ensureLocationForClock failed: $e');
      EasyLoading.dismiss();
      await _showLocationHelpDialog(
        message: MydashboardScreenConstants.LOCATION_FETCH_FAILED_TEXT.tr(),
        openLocationSettings: true,
      );
      return false;
    }
  }

  Future<void> _showLocationHelpDialog({
    required String message,
    bool openLocationSettings = false,
    bool openAppSettingsPage = false,
  }) async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyle.font16.copyWith(color: AppColors.black),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(MydashboardScreenConstants.CLOSE.tr()),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                if (openAppSettingsPage) {
                  await openAppSettings();
                } else if (openLocationSettings) {
                  await Geolocator.openLocationSettings();
                }
              },
              child: Text(MydashboardScreenConstants.OPEN_SETTINGS.tr()),
            ),
          ],
        );
      },
    );
  }

  /// Quiet GPS refresh used after app-launch check-in (address UI only).
  /// Does not show notify dialogs — clock-in/out use [ensureLocationForClock].
  Future<void> checkGps() async {
    try {
      serviceStatus = await Geolocator.isLocationServiceEnabled();
      if (!serviceStatus) return;

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      haspermission = true;
      await getLocation();
    } catch (e) {
      debugPrint('checkGps (background) failed: $e');
    }
  }

  Future<bool> getLocation() async {
    try {
      // Prefer a timed fix. Legacy LocationManager often helps older Android
      // devices but can hang without timeLimit.
      try {
        position = await Geolocator.getCurrentPosition(
          forceAndroidLocationManager: true,
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 15),
        );
      } catch (e) {
        debugPrint('LocationManager high accuracy failed: $e');
        // Fallback: fused provider + medium accuracy (common on older devices).
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 10),
        );
      }

      if (kDebugMode) {
        print(" lattttt  ${position.latitude}");
        print(" longgggg  ${position.longitude}");
      }

      long = position.longitude.toString();
      lat = position.latitude.toString();
      globalStorage.saveLattitude(accessLatitude: lat);
      globalStorage.saveLongitude(accessLongitude: long);

      // Address is UI-only; do not block clock-in/out on geocode.
      _getAddressFromLatLng(position);
      return true;
    } catch (e) {
      debugPrint('getCurrentPosition failed: $e');
      try {
        final last = await Geolocator.getLastKnownPosition();
        if (last != null) {
          position = last;
          long = position.longitude.toString();
          lat = position.latitude.toString();
          globalStorage.saveLattitude(accessLatitude: lat);
          globalStorage.saveLongitude(accessLongitude: long);
          _getAddressFromLatLng(position);
          return true;
        }
      } catch (e2) {
        debugPrint('getLastKnownPosition failed: $e2');
      }

      // Cached coords from a previous successful fix on this device/session.
      final cachedLat = globalStorage.getLatitude();
      final cachedLong = globalStorage.getLongitude();
      if (cachedLat.isNotEmpty && cachedLong.isNotEmpty) {
        lat = cachedLat;
        long = cachedLong;
        return true;
      }

      return false;
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      // Get current locale for geocoding
      final locale = context.locale;
      final languageCode = locale.languageCode; // 'en', 'hi', 'mr', etc.
      final googleApiKey = MapUtilsConstants.GOOGLE_MAP_KEY;

      // Use Google Geocoding API directly with language parameter to get localized addresses
      final geocodingUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&language=$languageCode&key=$googleApiKey',
      );

      final response = await http.get(geocodingUrl);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final result = data['results'][0];
          final addressComponents = result['address_components'] as List;

          // Extract address components
          String? streetNumber;
          String? route;
          String? sublocality;
          String? locality;
          String? administrativeArea;
          String? postalCode;

          for (var component in addressComponents) {
            final types = component['types'] as List;
            if (types.contains('street_number')) {
              streetNumber = component['long_name'];
            } else if (types.contains('route')) {
              route = component['long_name'];
            } else if (types.contains('sublocality') ||
                types.contains('sublocality_level_1')) {
              sublocality = component['long_name'];
            } else if (types.contains('locality')) {
              locality = component['long_name'];
            } else if (types.contains('administrative_area_level_1')) {
              administrativeArea = component['long_name'];
            } else if (types.contains('postal_code')) {
              postalCode = component['long_name'];
            }
          }

          // Build address string
          final addressParts = <String>[];
          if (streetNumber != null) addressParts.add(streetNumber);
          if (route != null) addressParts.add(route);
          if (sublocality != null) addressParts.add(sublocality);
          if (locality != null) addressParts.add(locality);
          if (administrativeArea != null) addressParts.add(administrativeArea);
          if (postalCode != null) addressParts.add(postalCode);

          _currentAddress = addressParts.join(',');

          setState(() {
            debugPrint(
                "address in var - $_currentAddress (language: $languageCode)");

            globalStorage.saveLocation(accessLocation: _currentAddress ?? '');
            location = _currentAddress;
            debugPrint("address in var  - $location");
            debugPrint("locccccc --- > ${globalStorage.getLocation()}");
          });
        } else {
          // Fallback to geocoding package if API fails
          _fallbackGeocoding(position);
        }
      } else {
        // Fallback to geocoding package if API fails
        _fallbackGeocoding(position);
      }
    } catch (e) {
      debugPrint("Error getting address from Google API: $e");
      // Fallback to geocoding package
      _fallbackGeocoding(position);
    }
  }

  Future<void> _fallbackGeocoding(Position position) async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress =
              '${place.name},${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.administrativeArea},${place.postalCode}';
          globalStorage.saveLocation(accessLocation: _currentAddress ?? '');
          location = _currentAddress;
        });
      }
    } catch (fallbackError) {
      debugPrint("Fallback geocoding also failed: $fallbackError");
    }
  }

  openDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogueWidget(
          text: MydashboardScreenConstants.POPUP_TITLE.tr(),
          onTapSubmit: () async {
            Navigator.pop(context);
            final ready = await ensureLocationForClock();
            if (!ready) return;

            double latitude = double.tryParse(lat) ?? 0;
            double longitude = double.tryParse(long) ?? 0;

            dashboardBloc.add(MarkAttendance(
                type: 'check_out', locations: [latitude, longitude]));
          },
          onTapCancel: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void settingModalBottomSheet(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!context.mounted) return;
    await showModalBottomSheet(
      context: context,
      isDismissible: true,
      builder: (BuildContext cont) {
        return Container(
          height: 200.h,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: AppColors.yellowIcon,
              width: 2,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Text(
                "Select Language",
                style: TextStyle(fontSize: 18.sp),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: ListView.separated(
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_languages[index]),
                      titleAlignment: ListTileTitleAlignment.center,
                      onTap: () {
                        _selectedLanguage = index;
                        context.setLocale(_locales[_selectedLanguage ?? 0]);
                        Get.updateLocale(_locales[_selectedLanguage ?? 0]);
                        Navigator.pop(context);
                      },
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const Divider(height: 0),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (!context.mounted) return;
    context.setLocale(_locales[_selectedLanguage ?? 0]);
  }
}
