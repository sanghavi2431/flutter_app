import 'package:Woloo_Smart_hygiene/core/local/global_storage.dart';
import 'package:Woloo_Smart_hygiene/screens/common_widgets/button_widget.dart';
import 'package:Woloo_Smart_hygiene/screens/login/view/login_screen.dart';
import 'package:Woloo_Smart_hygiene/screens/my_account/data/model/profile_model.dart';
import 'package:Woloo_Smart_hygiene/utils/app_color.dart';
import 'package:Woloo_Smart_hygiene/utils/app_constants.dart';
import 'package:Woloo_Smart_hygiene/utils/app_images.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:get/get.dart' hide Trans;
import '../../../utils/app_textstyle.dart';
import '../../common_widgets/image_provider.dart';
import '../../janitor_profile_screen/upload_profile.dart';
import '../../login/bloc/login_bloc.dart';
import '../../login/data/model/Update_token_model.dart';
import 'bloc/profile_bloc.dart';
import 'bloc/profile_event.dart';
import 'bloc/profile_state.dart';

class SupervisorAccountScreen extends StatefulWidget {
  final String supervisorName;
  final String mobile_number;

  const SupervisorAccountScreen({
    Key? key,
    required this.supervisorName,
    required this.mobile_number,
  }) : super(key: key);

  @override
  State<SupervisorAccountScreen> createState() =>
      SupervisorAccountScreenState();
}

class SupervisorAccountScreenState extends State<SupervisorAccountScreen> {
  ProfileBloc? profileBloc = ProfileBloc() ;
  ProfileModel? profile = ProfileModel() ;
   GlobalStorage globalStorage = GetIt.instance();
     Map<String, dynamic>? decodedToken;
  int? _selectedLanguage;
  final List<String> _languages = ["English", "हिंदी", "मराठी"];
  final List<Locale> _locales = const [
    Locale('en', 'US'),
    Locale('hi', 'IN'),
    Locale('mr', 'IN')
  ];


     updat( id)async{
       print("idddd $id");
          // var firebase = FirebaseMessaging.instance;
          //                 var token = await firebase.getToken();
    profileBloc?.add(UpdateProfile(
      id: id
    ));
   }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

       var some =   globalStorage.getToken();


     decodedToken = JwtDecoder.decode(some);

   //  print(" toeknm ${decodedToken!["id"]}");
       // profileBloc = BlocProvider.of<ProfileBloc>(context);
      updat(decodedToken!["id"]);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(

          elevation: 0,
          backgroundColor: AppColors.white,
          title: Text(
            MyAccountScreenConstants.MY_ACCOUNT.tr(),
            style:
              AppTextStyle.font24bold.copyWith(
                  color: AppColors.black,
                  )
            //  TextStyle(
            //   fontSize: 24.sp,
            //   fontWeight: FontWeight.w400,
            //   color: AppColors.yellowSplashColor,
            // ),
          ),
          actions: [
            // InkWell(
            //   onTap: () {
            //    settingModalBottomSheet(context);
            //
            //   },
            //   child: Container(
            //     width: 37.w,
            //     height: 33.h,
            //     decoration: BoxDecoration(
            //         color: AppColors
            //             .white, // Background color of the container
            //         boxShadow: [
            //           BoxShadow(
            //             color:
            //             Colors.black.withOpacity(0.2), // Shadow color
            //             spreadRadius:
            //             1, // How wide the shadow should spread
            //             blurRadius: 10, // The blur effect of the shadow
            //             offset: const Offset(
            //                 0, 0), // No offset for shadow on all sides
            //           ),
            //         ],
            //         // border:
            //         // Border.all(
            //         //   color: AppColors.containerBorder,
            //         //   width: 0.w,
            //         // ),
            //         borderRadius: BorderRadius.circular(8.r)),
            //     // color: Colors.red,
            //
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: CustomImageProvider(
            //         image: AppImages.languageIcons,
            //         width: 35.w,
            //         height: 35.h,
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              width: 15.w,
            )
          ],
          // leading: IconButton(
          //   color: AppColors.black30,
          //   icon: const Icon(
          //     Icons.arrow_back,
          //     color: Colors.black,
          //     size: 30,
          //   ),
          //   // color: AppColors.black,
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [


              // SizedBox(
              //   height: 70.h,
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 20.w),
              //   child: Text(
              //     MyAccountScreenConstants.MY_ACCOUNT.tr(),
              //     style: TextStyle(
              //       fontWeight: FontWeight.w400,
              //       fontSize: 24.sp,
              //       color: AppColors.black,
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 50.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric( horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.15), // Shadow color
                        spreadRadius:
                        1, // How wide the shadow should spread
                        blurRadius:
                        10, // The blur effect of the shadow
                        offset: const Offset(0,
                            0), // No offset for shadow on all sides
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                          Center(
                            child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,

                                            children: [
                                                SizedBox(  width: 20.w, ),

                                               BlocBuilder<ProfileBloc, ProfileState>(
                                                 bloc: profileBloc,
                                                builder:
                                                (context, state) {
                                                     print("state $state ");
                                                   if (state is  ProfleLoading ) {
                                                     EasyLoading.show(status: "");
                                       
                                                   }
                                                    if (state is ProfleSuccess ){
                                                   EasyLoading.dismiss();
                                       
                                                     profile =  state.data;
                                                   }
                                                    if(state is ProfleError ){
                                                    EasyLoading.show(status: state.error);
                                       
                                                   }
                                                   // print(" profileeee ${profile!.results!.profileImage}");
                                       return
                                                     profile!.results == null
                                                         || profile!.results!.profileImage == null
                                                  ?

                                               Center(
                                                 child:
                                                 CircleAvatar(
                                                   maxRadius: 40,
                                                   // backgroundColor:  AppColors.darkGreyColor
                                                   // ,
                                                   // radius: 40,

                                                   // borderRadius: BorderRadius.circular(100),
                                                   child: ClipRRect(
                                                       borderRadius: BorderRadius.circular(100),
                                                       child : const Icon( Icons.person,
                                                         color: AppColors.black,
                                                         size: 60,
                                                       )

                                                   ),
                                                 ),
                                               )

                                               :

                                         Center(
                                                child: 
                                                 CircleAvatar(
                                                   backgroundColor:  AppColors.darkGreyColor,
                                                   maxRadius: 40,
                                                   // radius: 40,
                                                   // borderRadius: BorderRadius.circular(100),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(100),
                                                    child: CustomImageProvider(

                                                      image:
                                                    // AppImages.appLogo,
                                                    "${profile!.results!.baseUrl}/${profile!.results!.profileImage!.replaceAll("[", "").replaceAll("]", "").replaceAll('"', '')}",
                                                    
                                                                                                 //   "https://woloo-taskmanagement-s3bucket.s3.ap-south-1.amazonaws.com/${profile!.results!.profileImage!.replaceAll("[", "").replaceAll("]", "").replaceAll('"', '')}",
                                                      height:
                                                      70.h,
                                                      width: 70.w,
                                                      alignment: Alignment.center,
                                                    ),
                                                  ),
                                                ),
                                              );
                                               //
                                                },
                                               ),


                                              InkWell(
                                                 onTap: () {
                            Navigator.of(context).push(  MaterialPageRoute(builder: (context) {
                                return   UplopadProfile(
                                     capture: (v){
                                       print("vvvvvvv $v");
                                   if (v) {

                                       profileBloc?.add(UpdateProfile(
      id: decodedToken!["id"]
    ));
                                     
                                   } 


                                },

                                );
                            },  )  );
                                                 },
                                                child: CustomImageProvider(
                                                  image: AppImages.edit_icon,
                                                  width: 30,
                                                  height: 30,
                                                ),
                                              ),
                                            ],
                                          ),
                          ),
                      // Center(
                      //   child:
                      //   CustomImageProvider(
                      //     image: AppImages.profile_img,
                      //     height: 98.h,
                      //     width: 97.w,
                      //     alignment: Alignment.center,
                      //   ),

                      // ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
                          child: Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                  textAlign: TextAlign.center,
                                  widget.supervisorName,
                                  style:
                                  AppTextStyle.font24bold.copyWith(
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
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                        child: Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    textAlign: TextAlign.center,
                                    "Mob :",
                                    style:
                                    AppTextStyle.font16.copyWith(
                                      color: AppColors.black,
                                    ),),
                                Text(
                                    textAlign: TextAlign.center,
                                    " +91${widget.mobile_number}",
                                    style:
                                    AppTextStyle.font16.copyWith(
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
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      )
                    ],
                  ) ,
                ),
              ),

              SizedBox(
                height: 70.h,
              ),
              GestureDetector(
                onTap: () async {
                  EasyLoading.show(
                      status: MyJanitorProfileScreenConstants.LOGGING_OUT_TOAST
                          .tr());
                  var storage = GetIt.instance<GlobalStorage>();
                  storage.removeToken();
                  storage.removeLocation();
                  storage.removeTime();
                  await Future.delayed(const Duration(seconds: 3));
                  EasyLoading.dismiss();
                  EasyLoading.showToast(MyJanitorProfileScreenConstants
                      .LOG_OUT_SUCCESS_TOAST
                      .tr());
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 30.w,
                  ),
                  child: ButtonWidget(
                    text: MydashboardScreenConstants.LOG_OUT.tr(),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ));
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
