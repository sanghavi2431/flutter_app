import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/screens/attendance_history_screen/view/attendance_history_screen.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/leading_button.dart';
import 'package:woloo_smart_hygiene/screens/login/view/login_screen.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

// import '../../../core/bloc/core_bloc.dart';
import '../../../client_flow/screens/login/view/login.dart';
import '../../../client_flow/screens/login/view/login_as.dart';
import '../../../client_flow/screens/subcription/data/model/coins_model.dart';
import '../../common_widgets/image_provider.dart';
import '../../my_account/data/model/profile_model.dart';
import '../../my_account/view/bloc/profile_bloc.dart';
import '../../my_account/view/bloc/profile_event.dart';
import '../../my_account/view/bloc/profile_state.dart';
import '../upload_profile.dart';

class JanitorProfileScreen extends StatefulWidget {
  const JanitorProfileScreen({
    super.key,
  });

  @override
  State<JanitorProfileScreen> createState() => JanitorProfileScreenState();
}

class JanitorProfileScreenState extends State<JanitorProfileScreen> {
  ProfileBloc? profileBloc = ProfileBloc();

  //ProfileBloc();
  ProfileModel profile = ProfileModel();
  CoinsModel? coinsModel;
  // CoreBloc coreBloc = CoreBloc();

  final List<String> _languages = [
    "English",
    "हिंदी",
    "मराठी",
    "ಕನ್ನಡ",
    "தமிழ்",
    "తెలుగు",
    "മലയാളം"
  ];

  final List<Locale> _locales = const [
    Locale('en', 'US'),
    Locale('hi', 'IN'),
    Locale('mr', 'IN'),
    Locale('kn', 'IN'),
    Locale('ta', 'IN'),
    Locale('te', 'IN'),
    Locale('ml', 'IN')
  ];

  int? _selectedLanguage;

  Map<String, dynamic>? decodedToken;
  @override
  void initState() {
    super.initState();
    // print("sdf");
    // print(" sadas ${loginBloc.profileList}");
    // profileBloc = BlocProvider.of<LoginBloc>(
    //   context,
    // );
    var some = globalStorage.getToken();

    // profileBloc!.add(const UserCoinsEvent());

    decodedToken = JwtDecoder.decode(some);
    updat(decodedToken!["id"]);
    // BlocProvider.of<LoginBloc>(context);

    // print(profileBloc!.profileList);
  }

  updat(id) async {
    profileBloc?.add(UpdateProfile(id: id));
  }

  final globalStorage = GetIt.instance<GlobalStorage>();

  // LoginBloc loginBloc = LoginBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          leadingWidth: 100,
          backgroundColor: AppColors.white,
          leading: const LeadingButton(),

          // actions: [
          //   InkWell(
          //     onTap: () {
          //       settingModalBottomSheet(context);
          //     },
          //     child: Container(
          //       width: 37.w,
          //       height: 33.h,
          //       decoration: BoxDecoration(
          //           color: AppColors.white, // Background color of the container
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.black.withOpacity(0.2), // Shadow color
          //               spreadRadius: 1, // How wide the shadow should spread
          //               blurRadius: 10, // The blur effect of the shadow
          //               offset: const Offset(
          //                   0, 0), // No offset for shadow on all sides
          //             ),
          //           ],
          //           borderRadius: BorderRadius.circular(8.r)),
          //       // color: Colors.red,

          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: CustomImageProvider(
          //           image: AppImages.languageIcons,
          //           width: 35.w,
          //           height: 35.h,
          //           fit: BoxFit.cover,
          //         ),
          //       ),
          //     ),
          //   ),
          //   SizedBox(
          //     width: 15.w,
          //   )
          // ],

          // IconButton(
          //   icon: const Icon(
          //     Icons.arrow_back,
          //     color: Colors.white,
          //     size: 25,
          //   ),
          //   color: AppColors.appBarIconColor,
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
          //  title:

          //  elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                  vertical: 10.h,
                ),
                child: Text(MyJanitorProfileScreenConstants.MY_PROFILE.tr(),
                    textAlign: TextAlign.start,
                    style: AppTextStyle.font24bold.copyWith(
                      color: AppColors.black,
                    )
                    // TextStyle(
                    //   color: AppColors.yellowSplashColor,
                    //   fontSize: 20.sp,
                    //   fontWeight: FontWeight.w400,
                    // ),
                    ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20.h,
                  ),
                  BlocBuilder<ProfileBloc, ProfileState>(
                    bloc: profileBloc,
                    builder: (context, state) {
                      debugPrint("state $state ");
                      if (state is ProfleLoading) {
                        EasyLoading.show(status: "");
                      }
                      if (state is ProfleSuccess) {
                        EasyLoading.dismiss();

                        profile = state.data;
                        // profileBloc!.add(const UserCoinsEvent());
                      }

                      if (state is ProfleError) {
                        EasyLoading.show(status: state.error);
                      }



                      return profile.results == null ||
                              profile.results!.profileImage == null
                          ? Center(
                              child: CustomImageProvider(
                                image: AppImages.profileImg,
                                height: 70.h,
                                width: 70.w,
                                alignment: Alignment.center,
                              ),
                            )
                          : Center(
                              child: CircleAvatar(
                                backgroundColor: AppColors.darkGreyColor,
                                radius: 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CustomImageProvider(
                                    image:
                                        // AppImages.appLogo,
                                        "${profile.results!.baseUrl}/${profile.results!.profileImage!.replaceAll("[", "").replaceAll("]", "").replaceAll('"', '')}",
                                    //   "https://woloo-taskmanagement-s3bucket.s3.ap-south-1.amazonaws.com/${profile!.results!.profileImage!.replaceAll("[", "").replaceAll("]", "").replaceAll('"', '')}",
                                    height: 70.h,
                                    width: 70.w,
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return UplopadProfile(
                            capture: (v) {
                              if (v) {
                                profileBloc?.add(
                                    UpdateProfile(id: decodedToken!["id"]));
                              }
                            },
                          );
                        },
                      ));
                    },
                    child: CustomImageProvider(
                      image: AppImages.editIcon,
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              BlocBuilder<ProfileBloc, ProfileState>(
                  bloc: profileBloc,
                  builder: (context, state) {
                    debugPrint("state $state ");
                    if (state is ProfleLoading) {
                      EasyLoading.show(status: "");
                    }
                    if (state is ProfleSuccess) {
                      EasyLoading.dismiss();

                      profile = state.data;

                      profileBloc!.add(UserCoinsEvent(
                          userId: decodedToken!["id"].toString()));
                    }
                    if (state is GetUserCoins) {
                      EasyLoading.dismiss();

                      coinsModel = state.coinsModel;
                    }

                    if (state is ProfleError) {
                      EasyLoading.show(status: state.error);
                    }
                    return Column(
                      children: [
                        Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            profile.results == null
                                ? Container()
                                : Text(
                                    "${profile.results?.firstName ?? ""} ${profile.results?.lastName ?? ""}",
                                    style: AppTextStyle.font24bold.copyWith(
                                      color: AppColors.black,
                                    ))
                          ],
                        )),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              "mob".tr(),
                              style: AppTextStyle.font16.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                            profile.results == null ||
                                    profile.results!.mobile == null
                                ? Container()
                                : Text(
                                    textAlign: TextAlign.center,
                                    " +91${profile.results!.mobile!}",
                                    style: AppTextStyle.font16.copyWith(
                                      color: AppColors.black,
                                    )
                                    //  TextStyle(
                                    //   fontWeight: FontWeight.w400,
                                    //   fontSize: 16.sp,
                                    //   color: AppColors.black,
                                    // ),
                                    ),
                          ],
                        ),
                        Text(
                          "${coinsModel == null ? "00" : coinsModel!.results!} ${"wolooPoints".tr()}",
                          style: AppTextStyle.font16bold,
                        ),
                      ],
                    );
                  }),
              SizedBox(
                height: 40.h,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AttendanceHistoryScreen()),
                    // (route) => false,
                  );
                },
                child: Container(
                  height: 60.h,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          width: 1.0.w, color: AppColors.greyBorderColor),
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Row(
                      children: [
                        CustomImageProvider(
                          image: AppImages.historyImg,
                          height: 25.h,
                          width: 25.w,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Text(
                                textAlign: TextAlign.start,
                                MyJanitorProfileScreenConstants
                                    .ATTENDANCE_HISTORY
                                    .tr(),
                                style: AppTextStyle.font16.copyWith(
                                  color: AppColors.black,
                                )
                                // TextStyle(
                                //   fontWeight: FontWeight.w400,
                                //   fontSize: 16.sp,
                                //   color: AppColors.black,
                                // ),
                                ),
                          ),
                        ),
                        // SizedBox(
                        //   width: 40.w,
                        // ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  EasyLoading.show(
                      status: MyJanitorProfileScreenConstants.LOGGING_OUT_TOAST
                          .tr());
                  var storage = GetIt.instance<GlobalStorage>();
                  storage.removeProfile();
                  storage.removeToken();
                  storage.removeLocation();
                  storage.removeTime();
                  storage.removeDate();
                  storage.removeOutTime();
                  storage.removeOutDate();
                  storage.removeFacilityRef();
                  storage.removePlanId();
                  storage.removePaymentId();
                  // Clear language codes (login screen will set default locale)
                  storage.removeLanguageCodes();
                  await Future.delayed(const Duration(seconds: 3));
                  EasyLoading.dismiss();
                  EasyLoading.showToast(MyJanitorProfileScreenConstants
                      .LOG_OUT_SUCCESS_TOAST
                      .tr());
                  if (!context.mounted) return;
                  // Navigate to login screen (it will set default locale on load)
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ClientLogin()),
                    (route) => false,
                  );
                },
                child: Container(
                  height: 60.h,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          width: 1.0.w, color: AppColors.greyBorderColor),
                      bottom: BorderSide(
                          width: 1.0.w, color: AppColors.greyBorderColor),
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Row(
                      children: [
                        CustomImageProvider(
                          image: AppImages.logoutImg,
                          height: 25.h,
                          width: 25.w,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Text(
                                textAlign: TextAlign.start,
                                MyJanitorProfileScreenConstants.LOG_OUT.tr(),
                                style: AppTextStyle.font16.copyWith(
                                  color: AppColors.black,
                                )
                                //  TextStyle(
                                //   fontWeight: FontWeight.w400,
                                //   fontSize: 16.sp,
                                //   color: AppColors.black,
                                // ),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  settingModalBottomSheet(BuildContext context) async {
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
                        setState(() {
                          _selectedLanguage = index;
                        });
                        context.setLocale(_locales[_selectedLanguage ?? 0]);
                        Get.updateLocale(_locales[_selectedLanguage ?? 0]);

                        // Map locale index to language code and save to storage
                        final List<String> languageCodeMap = [
                          'en',
                          'hi',
                          'mr',
                          'kn',
                          'ta',
                          'te',
                          'ml'
                        ];
                        final String selectedLanguageCode =
                            languageCodeMap[_selectedLanguage ?? 0];
                        debugPrint(
                            "JanitorProfileScreen - Selected language index: $index");
                        debugPrint(
                            "JanitorProfileScreen - Saving language code: $selectedLanguageCode");

                        // Save language codes
                        globalStorage.saveLanguageCodes(
                            languageCodes: [selectedLanguageCode]);

                        // Verify it was saved correctly
                        final savedCodes = globalStorage.getLanguageCodes();
                        debugPrint(
                            "JanitorProfileScreen - Language codes after save: $savedCodes");
                        debugPrint(
                            "JanitorProfileScreen - First language code: ${savedCodes.isNotEmpty ? savedCodes.first : 'empty'}");

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
