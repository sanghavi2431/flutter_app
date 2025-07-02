import 'dart:io';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/white_button_widget.dart';
import 'package:woloo_smart_hygiene/screens/my_account/view/bloc/profile_bloc.dart';
import 'package:woloo_smart_hygiene/screens/selfie_screen/bloc/selfie_bloc.dart';
import 'package:woloo_smart_hygiene/screens/selfie_screen/bloc/selfie_event.dart';
import 'package:woloo_smart_hygiene/screens/selfie_screen/bloc/selfie_state.dart';
import 'package:woloo_smart_hygiene/screens/selfie_screen/view/camera.dart';
import 'package:woloo_smart_hygiene/screens/washroom_image_screen/images_bloc/event/capture_event.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../utils/app_images.dart';
// import '../../common_widgets/image_provider.dart';
// import '../../washroom_image_screen/images_bloc/bloc/capture_bloc.dart';
// import '../../washroom_image_screen/images_bloc/state/capture_state.dart';
import '../common_widgets/image_provider.dart';
import '../washroom_image_screen/images_bloc/bloc/capture_bloc.dart';
import '../washroom_image_screen/images_bloc/state/capture_state.dart';


enum PickSource { camera }

class UplopadProfile extends StatefulWidget {
  final  Function?  capture;
  // final bool isFromChooseFacility;
  // final bool isFromTask;
  // final int? templateId;
  // final String allocationId;

  const UplopadProfile({
    super.key,
    this.capture

    // this.isFromChooseFacility = false,
    // this.isFromTask = false,
    // required this.templateId,
    // required this.allocationId,
  });

  @override
  State<UplopadProfile> createState() => _UplopadProfileState();
}

class _UplopadProfileState extends State<UplopadProfile> {
  File? _file;
  SelfieBloc selfieBloc = SelfieBloc();
  final CaptureBloc _captureBloc = CaptureBloc();
  ProfileBloc profileBloc = ProfileBloc();
    GlobalStorage globalStorage = GetIt.instance();
     Map<String, dynamic>? decodedToken;


  @override
  void initState() {
    super.initState();


        var some =   globalStorage.getToken();


     decodedToken = JwtDecoder.decode(some);

    debugPrint(" toeknm ${decodedToken!["id"]}");
  }

  @override
  Widget build(BuildContext context) {
    return
     BlocBuilder<CaptureBloc, CaptureState> (
       bloc: _captureBloc,
      builder:  (context, state) {
        debugPrint(" statesssss $state ");
           if ( state is AddImagesInitial  ) {
             return Scaffold(
        backgroundColor: AppColors.white,
        appBar: null,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          
               Column(
              children: [
                  SizedBox(
                       height:180.h,),
                Container(
                  height: 180.h,
                  width: 180.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.checkboxGreyBorder,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.camColor,
                      size: 100,
                    ),
                    onPressed: () async {

                      Navigator.of(context).push( MaterialPageRoute(builder: (context) =>  CameraPage(
                        sensorPosition: SensorPosition.front,
                        captureImage: (value){

                          _file = value;
                           
                         _captureBloc.add( AddImages(file: _file)); 

                        },

                      ),  ) );
                      //  _file = await pickFile(null, PickSource.CAMERA);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 15.h,
                  ),
                  child: Text(
                    MySelfieScreenConstants.UPLOAD_TITLE_TEXT.tr(),
                    style:
                    AppTextStyle.font20bold.copyWith(
                      color: AppColors.black,
                    )
                    //  TextStyle(
                    //   color: AppColors.black,
                    //   fontSize: 24.sp,
                    //   fontWeight: FontWeight.w400,
                    // ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 15.h, horizontal: 20.w),
                    child: Text(
                      MySelfieScreenConstants.TITLE_SUBTEXT.tr(),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style:
                      AppTextStyle.font12.copyWith(
                         color: AppColors.black,
                      )
                      //  TextStyle(
                      //   color: AppColors.black,
                      //   fontSize: 15.sp,
                      //   fontWeight: FontWeight.w400,
                      // ),
                    ),
                  ),
                ),


              ],
            ),
           
             

            // _file !=  null  ?
          
 // :
      


            Expanded(child: Container()),
            _file != null
                ? BlocConsumer<SelfieBloc, SelfieState>(
                bloc: selfieBloc,
                listener: (context, state) async {
                  if (state is UploadSelfieLoading) {
                    EasyLoading.show(status: state.message);
                  }

                  if (state is UploadSelfieSuccessful) {
                    EasyLoading.dismiss();
                    // Navigator.pop(context);
                      // var firebase = FirebaseMessaging.instance;
                          // var token = await firebase.getToken();
                     
                  //  loginBloc.add(UpdateTokenOnVerifyOTP(token: token!));
                  //   updat( id)async{
                   //   print("idddd $id");
                     // // var firebase = FirebaseMessaging.instance;
                      //                 var token = await firebase.getToken();
                      // profileBloc?.add(
                      //     UpdateProfile(
                      //     id: decodedToken!["id"]
                      // )

                      // );
                         widget.capture!(true);
                    // }
                         Navigator.of(context).pop();

                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => TaskList(
                    //         allocationId: widget.allocationId,
                    //         templateId: widget.templateId,
                    //       ),
                    //     ));
                  }

                  if (state is UploadSelfieError) {
                      widget.capture!(false);
                    EasyLoading.dismiss();
                    EasyLoading.showError(state.error.message);
                  }
                },
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 15.h,
                      horizontal: 30.w,
                    ),
                    child: WhiteButtonWidget(
                      text: MyTaskListConstants.SUBMIT_BTN.tr(),
                      color: AppColors.buttonColor,
                      onTap: () {
                        debugPrint("image#######${_file!.path}");

                        selfieBloc.add(UploadSelfie(
                          type: MySelfieScreenConstants.IMAGE_TYPE_UPLOAD,
                          image: _file!,
                          id: decodedToken!["id"],
                          remarks: MySelfieScreenConstants.REMARKS,
                        ));

                      },
                    ),
                  );
                })
                : Padding(
              padding: EdgeInsets.symmetric(
                vertical: 15.h,
                horizontal: 30.w,
              ),
              child: WhiteButtonWidget(
                text: MyTaskListConstants.SUBMIT_BTN.tr(),
                color: AppColors.disabledCamButtonColor.withValues( alpha: 0.6),
                onTap: () {},
              ),
            ),
          ],
        ),
      );
           } else if (
             state is AddImagesSuccessful
           ){

             debugPrint(" omf ${state.image} ");

              File? image = state.image;
            return 
            
             Scaffold(
        backgroundColor: AppColors.white,
        appBar:
        AppBar(
          toolbarHeight: 75,
          leadingWidth: 0,
          leading: const SizedBox(),
          backgroundColor: AppColors.appbarBgColor,
          title: 
             Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: ()async{

                  Navigator.of(context).push( MaterialPageRoute(builder: (context) =>  CameraPage(
                    sensorPosition: SensorPosition.front,
                     captureImage: (value){
                       _file = value;

                          _captureBloc.add(AddImages(file: _file ));                       

                   
                     },

                  ),  ) );
               
               
                },
                child: 
                  CustomImageProvider(
                 image: 
                 AppImages.repeatIcon,
                  //"assets/images/irepeat.png",
                  width: 40.h,
                  alignment: Alignment.center,
                ),   
                
              ),

              GestureDetector(
                onTap: ()async{


                
                  _captureBloc.add(RemoveImages(file: _file ));
                },
                child:
                     CustomImageProvider(
                 image: 
                AppImages.deleteIcon,
                  //"assets/images/irepeat.png",
                  width: 40.h,
                ),   
                
              ),
       
            ],
          ),
        ),
      
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
        


                     Padding(

                       padding: const EdgeInsets.symmetric( horizontal: 16 ),
                       child: Column(
                                       children: [
                                         SizedBox(height:20.h),
                                         Container(
                                         height: 440.h,
                                         decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(10.r),
                                         ),
                                         child: ClipRRect(
                                           borderRadius: BorderRadius.circular(
                        15.r,
                                           ),
                                           child: Image.file(
                        state.image!,
                        fit: BoxFit.cover,
                                           ),
                                         ),
                                ),
                                       ],
                                     ),
                     ),
            Expanded(child: Container()),
            _file != null
                ? BlocConsumer<SelfieBloc, SelfieState>(
                bloc: selfieBloc,
                listener: (context, selfiestate) async {
                  debugPrint(" selfe $selfiestate");
                  if (selfiestate is UploadSelfieLoading) {
                    EasyLoading.show(status: selfiestate.message);
                  }

                  if (selfiestate is UploadSelfieSuccessful) {
                    EasyLoading.dismiss();
                    // Navigator.pop(context);
                         //var firebase = FirebaseMessaging.instance;
                       //   var token = await firebase.getToken();
                    widget.capture!(true);

                    // profileBloc.add(
                    //     UpdateProfile(
                    //       id: decodedToken!["id"]
                    //     )
                    //
                    // );
                         Navigator.of(context).pop();


                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => TaskList(
                    //         allocationId: widget.allocationId,
                    //         templateId: widget.templateId,
                    //       ),

                    //     ));
                  }


                  if (selfiestate is UploadSelfieError) {
                    EasyLoading.dismiss();
                    EasyLoading.showError(selfiestate.error.message);
                  }
                },
                builder: (context, state) {




                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 15.h,
                      horizontal: 30.w,
                    ),
                    child: WhiteButtonWidget(
                      text: MyTaskListConstants.SUBMIT_BTN.tr(),
                      color: AppColors.buttonColor,
                      onTap: () {
                        debugPrint("image#######${_file!.path}");

                        selfieBloc.add(UploadSelfie(
                          type: MySelfieScreenConstants.IMAGE_TYPE_UPLOAD,
                          image: image!,
                          id: decodedToken!["id"].toString(),
                          remarks: MySelfieScreenConstants.REMARKS,
                        ));

                      },
                    ),
                  );
                })
                : Padding(
              padding: EdgeInsets.symmetric(
                vertical: 15.h,
                horizontal: 30.w,
              ),
              child: WhiteButtonWidget(
                text: MyTaskListConstants.SUBMIT_BTN.tr(),
                color: AppColors.disabledCamButtonColor.withValues( alpha: 0.3),
                onTap: () {},
              ),
            ),
          ],
        ),
      );

           }
          else {
              return const SizedBox();
          }
     }, );

  

  }

  Future<File?> pickFile(File? old, PickSource source) async {
    try {
      File? file;

      if (source == PickSource.camera) {
        final ImagePicker picker = ImagePicker();


        final XFile? photo = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          preferredCameraDevice: CameraDevice.front
        );
        if (photo != null) {
          file = File(photo.path);
        }
      }

      if (file != null) {
        return file;
      }

      if (old != null) {
        return old;
      }

      if (old == null) {
        throw MyReportIssueScreenConstants.FILE_NOT_SELECTED.tr();
      }
    } catch (e) {
      EasyLoading.showToast(e.toString());
    }
    return null;
  }
}
