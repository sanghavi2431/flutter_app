import 'dart:io';

import 'package:woloo_smart_hygiene/screens/common_widgets/custom_dialogue_widget.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/white_button_widget.dart';
import 'package:woloo_smart_hygiene/screens/selfie_screen/view/camera.dart';
import 'package:woloo_smart_hygiene/screens/washroom_image_screen/bloc/images_bloc.dart';
import 'package:woloo_smart_hygiene/screens/washroom_image_screen/bloc/images_event.dart';
import 'package:woloo_smart_hygiene/screens/washroom_image_screen/bloc/images_state.dart';
import 'package:woloo_smart_hygiene/screens/washroom_image_screen/images_bloc/bloc/capture_bloc.dart';
import 'package:woloo_smart_hygiene/screens/washroom_image_screen/images_bloc/event/capture_event.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/app_textstyle.dart';
import '../../common_widgets/leading_button.dart';
import '../../dashboard/bloc/dashboard_bloc.dart';
import '../../dashboard/bloc/dashboard_event.dart';
import '../images_bloc/bloc/capture3_bloc.dart';
import '../images_bloc/bloc/capture_bloc1.dart';
import '../images_bloc/bloc/capture_bloc2.dart';
import '../images_bloc/event/capture_event1.dart';
import '../images_bloc/event/capture_event2.dart';
import '../images_bloc/event/capture_event3.dart';
import '../images_bloc/state/capture_state.dart';
import '../images_bloc/state/capture_state1.dart';
import '../images_bloc/state/capture_state2.dart';
import '../images_bloc/state/capture_state3.dart';

enum PickSource { camera }

class TaskCompletionScreen extends StatefulWidget {
  final String allocationId;

  const TaskCompletionScreen({super.key, required this.allocationId});

  @override
  State<TaskCompletionScreen> createState() => _TaskCompletionScreenState();
}

class _TaskCompletionScreenState extends State<TaskCompletionScreen> {
  File? _file1;
  File? _file2;
  File? _file3;
  //  File? _file4;
  final ImagesBloc _imagesBloc = ImagesBloc();
  final CaptureBloc _captureBloc = CaptureBloc();
  final CaptureBloc1 _captureBloc1 = CaptureBloc1();
     final CaptureBloc2 _captureBloc2 = CaptureBloc2();
     final CaptureBloc3 _captureBloc3 = CaptureBloc3();
  List<File> fileList = [];
  final TextEditingController _controller = TextEditingController();
  DashboardBloc dashboardBloc = DashboardBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ImagesBloc, ImagesState>(
        bloc: _imagesBloc,
        listener: (context, state) async {
          if (state is UploadImagesLoading) {
            EasyLoading.show(status: state.message);
          }

          if (state is UploadImagesSuccessful) {
           // dashboardBloc.add(CheckAttendance());
            Navigator.of(context).pop();
             Navigator.of(context).pop();
              dashboardBloc.add(const GetTaskTamplates());
            EasyLoading.dismiss();
          //  Navigator.of(context).pop();
        //  Navigator.pop(context);
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const Dashboard(),
            //   ),
            //   (route) => false,
            // );
          }

          if (state is UploadImagesError) {
            EasyLoading.dismiss();
            EasyLoading.showError(state.error.message);
          }
        },
        builder: (context, state) {
           if ( state is UploadImagesSuccessful) {
              dashboardBloc.add(const GetTaskTamplates());
             
           }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.white,
               leadingWidth: 100.w,
              leading: const LeadingButton(),
            ),
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20.h,
                        horizontal: 20.w,
                      ),
                      child: Text(
                        TaskCompletionScreenConstants.TITLE_TEXT.tr(),
                        style: AppTextStyle.font24.copyWith(
                        color: AppColors.titleColor,
                  )
                        //  TextStyle(
                        //   fontSize: 24.sp,
                        //   fontWeight: FontWeight.w400,
                        //   color: AppColors.black,
                        // ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 10.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                               BlocBuilder(
                                 bloc:_captureBloc ,
                                builder:  (context, state) {
                                   
                                  
                                    
                                     if (  state is AddImagesInitial ) {
                                          return 
                                          GestureDetector(
                                      onTap: () async {
                                          Navigator.of(context).push( MaterialPageRoute(builder: (context) =>  CameraPage(
                                            sensorPosition: SensorPosition.back,
                                             captureImage: (val){
                                                _file1 = val;
                                                fileList.add(_file1!);
                                                 _captureBloc.add(AddImages(file:_file1));
                                               // fileList.add(_file1!);
                                              
                                             },
                                          ),  ) );


                                          debugPrint("fileeeee1$_file1");

                                      },
                                      child: DottedBorder(
                                        color: AppColors.dottedBorderColor,
                                        borderType: BorderType.RRect,
                                        radius: Radius.circular(10.r),
                                        strokeWidth: 0.8.w,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 30.w,
                                            vertical: 40.h,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.camera_alt_outlined,
                                                size: 40,
                                                color:
                                                    AppColors.dottedBorderColor,
                                              ),
                                              Text(
                                                TaskCompletionScreenConstants
                                                    .ADD_PHOTO
                                                    .tr(),
                                                style:
                                                AppTextStyle.font15.copyWith(
                                                  color: AppColors
                                                      .imageScreenGreyColor,
                                                )
                                                //  TextStyle(
                                                //   fontWeight: FontWeight.w400,
                                                //   fontSize: 15.sp,
                                                //   color: AppColors
                                                //       .imageScreenGreyColor,
                                                // ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ); 
                                     }
                                      else if( state  is AddImagesSuccessful   ){
                                  return  Stack(
                                children: [
                                  SizedBox(
                                          height: 135.h,
                                          width: 150.w,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                10.0), //add border radius
                                            child: Image.file(
                                              state.image!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                  
                                      Positioned(
                                       right: 5,
                                       top: 5,
                                       child: GestureDetector(
                                         onTap: (){
                                             _captureBloc.add(  RemoveImages(file: _file1 ));
                                         },
                                         child: const CircleAvatar(
                                           backgroundColor: AppColors.black,
                                           child: Center(
                                             child: Icon(
                                                  color: AppColors.red,
                                                 Icons.delete  ),
                                           ),
                                         ),
                                       ),
                                     )
                                ],
                              );
                                      }
                                      else{

                                        return const SizedBox();
                                      }

                                    
                                },  ),

                        

                                 BlocBuilder(
                                  
                                  bloc:  _captureBloc1,
                                  builder: (context, state) {
                                    debugPrint(" object  $state ");
                                     if ( state is AddImagesInitial1) {
                                        
                                         return 
                                            GestureDetector(
                                      onTap: () async {

                                        Navigator.of(context).push( MaterialPageRoute(builder: (context) =>  CameraPage(
                                          sensorPosition: SensorPosition.back,
                                          captureImage: (val){
                                            _file2 = val;
                                            fileList.add(_file2!);     
                                           _captureBloc1.add(AddImages1(file:_file2));
                                          },
                                        ),  ) );
                                        // _file2 = await pickFile(
                                        //     null, PickSource.CAMERA);


                                        debugPrint("fileeeee2$_file2");


                                      },
                                      child: DottedBorder(
                                        color: AppColors.dottedBorderColor,
                                        borderType: BorderType.RRect,
                                        radius: Radius.circular(10.r),
                                        strokeWidth: 0.8.w,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 30.w,
                                            vertical: 40.h,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.camera_alt_outlined,
                                                size: 40,
                                                color:
                                                    AppColors.dottedBorderColor,
                                              ),
                                              Text(
                                                TaskCompletionScreenConstants
                                                    .ADD_PHOTO
                                                    .tr(),
                                                style:
                                                AppTextStyle.font15.copyWith(
                                                  color: AppColors
                                                      .imageScreenGreyColor,
                                                )
                                                //  TextStyle(
                                                //   fontWeight: FontWeight.w400,
                                                //   fontSize: 15.sp,
                                                //   color: AppColors
                                                //       .imageScreenGreyColor,
                                                // ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );



                                          
                                     } 
                                     else  if(  state  is AddImagesSuccessful1 ){
                                    
                                     return
                                        Stack(
                                children: [
                                  SizedBox(
                                          height: 135.h,
                                          width: 150.w,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                10.0), //add border radius
                                            child: Image.file(
                                              state.image!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                  Positioned(
                                    right: 5,
                                    top: 5,

                                    child: GestureDetector(
                                      onTap: (){
                                           _captureBloc1.add(RemoveImages1(file:_file2));

                                      },
                                      child: const CircleAvatar(
                                        backgroundColor: AppColors.black,
                                        child: Center(
                                          child: Icon(
                                              color: AppColors.red,
                                              Icons.delete  ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                                      
                                     } 
                                      else {    
                                         return const SizedBox();
                                      }

                                 }, ),
                         
                           //   _file2 != null
                               //   ?
                          
                              //    :
                                 
                            ],
                          ),
                        ),



                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 10.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                             BlocBuilder(
                              bloc: _captureBloc2,
                              builder:  (context, state) {

                                debugPrint("bloc 2 $state ");
                                     if ( state is  AddImagesInitial2 ) {
                                     return   GestureDetector(
                                      onTap: () async {

                                        Navigator.of(context).push( MaterialPageRoute(builder: (context) =>  CameraPage(
                                          sensorPosition: SensorPosition.back,
                                          captureImage: (val){
                                            _file3 = val;
                                            fileList.add(_file3!);
                                           _captureBloc2.add(AddImages2(file:_file3) );
                                          
                                          },
                                        ),  ) );

                                        // _file3 = await pickFile(
                                        //     null, PickSource.CAMERA);


                                        debugPrint("fileeeee3$_file3");


                                      },
                                      child: DottedBorder(
                                        color: AppColors.dottedBorderColor,
                                        borderType: BorderType.RRect,
                                        radius: Radius.circular(10.r),
                                        strokeWidth: 0.8.w,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 30.w,
                                            vertical: 40.h,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.camera_alt_outlined,
                                                size: 40,
                                                color:
                                                    AppColors.dottedBorderColor,
                                              ),
                                              Text(
                                                TaskCompletionScreenConstants
                                                    .ADD_PHOTO
                                                    .tr(),
                                                style:
                                                  AppTextStyle.font15.copyWith(
                                                  color: AppColors
                                                      .imageScreenGreyColor,
                                                )
                                                //  TextStyle(
                                                //   fontWeight: FontWeight.w400,
                                                //   fontSize: 15.sp,
                                                //   color: AppColors
                                                //       .imageScreenGreyColor,
                                                // ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                     }
                                     else if ( state is AddImagesSuccessful2 ) {
                                   return Stack(
                                children: [
                                  SizedBox(
                                          height: 135.h,
                                          width: 150.w,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                10.0), //add border radius
                                            child: Image.file(
                                              _file3!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                  Positioned(
                                    right: 5,
                                    top: 5,

                                    child: GestureDetector(
                                      onTap: (){
                                     
                                           _captureBloc2.add(RemoveImages2(file:_file3));
                                    

                                      },
                                      child: const CircleAvatar(
                                        backgroundColor: AppColors.black,
                                        child: Center(
                                          child: Icon(
                                              color: AppColors.red,
                                              Icons.delete  ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                                     }
                                      else {
                                         return const SizedBox();
                                      }
                                  
                              }, ),

                              // _file3 != null
                              //     ?
                    
                               //   :
                                  
                                         BlocBuilder(
                              bloc: _captureBloc3,
                              builder:  (context, state) {

                                     if ( state is  AddImagesInitial3 ) {
                                     return   GestureDetector(
                                      onTap: () async {

                                        Navigator.of(context).push( MaterialPageRoute(builder: (context) =>  CameraPage(
                                          sensorPosition: SensorPosition.back,
                                          captureImage: (val){
                                            _file3 = val;
                                            fileList.add(_file3!);
                                           _captureBloc3.add(AddImages3(file:_file3) );
                                          
                                          },
                                        ),  ) );

                                        // _file3 = await pickFile(
                                        //     null, PickSource.CAMERA);


                                        if (kDebugMode) {
                                          debugPrint("fileeeee3$_file3");
                                        }


                                      },
                                      child: DottedBorder(
                                        color: AppColors.dottedBorderColor,
                                        borderType: BorderType.RRect,
                                        radius: Radius.circular(10.r),
                                        strokeWidth: 0.8.w,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 30.w,
                                            vertical: 40.h,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.camera_alt_outlined,
                                                size: 40,
                                                color:
                                                    AppColors.dottedBorderColor,
                                              ),
                                              Text(
                                                TaskCompletionScreenConstants
                                                    .ADD_PHOTO
                                                    .tr(),
                                                style:
                                                  AppTextStyle.font15.copyWith(
                                                  color: AppColors
                                                      .imageScreenGreyColor,
                                                )
                                                //  TextStyle(
                                                //   fontWeight: FontWeight.w400,
                                                //   fontSize: 15.sp,
                                                //   color: AppColors
                                                //       .imageScreenGreyColor,
                                                // ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                     }
                                     else if ( state is AddImagesSuccessful3 ) {
                                   return Stack(
                                children: [
                                  SizedBox(
                                          height: 135.h,
                                          width: 150.w,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                10.0), //add border radius
                                            child: Image.file(
                                              _file3!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                  Positioned(
                                    right: 5,
                                    top: 5,

                                    child: GestureDetector(
                                      onTap: (){
                                           _captureBloc3.add(RemoveImages3(file:_file3));
                                      },
                                      child: const CircleAvatar(
                                        backgroundColor: AppColors.black,
                                        child: Center(
                                          child: Icon(
                                              color: AppColors.red,
                                              Icons.delete  ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                                     }
                                      else {
                                         return const SizedBox();
                                      }
                                  
                              }, )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25.w,
                        vertical: 10.h,
                      ),
                      child: Text(
                        TaskCompletionScreenConstants.REMARKS.tr(),
                        style: 
                         AppTextStyle.font16.copyWith(
                              color: AppColors.black, )
                        // TextStyle(
                        //   fontSize: 16.sp,
                        //   fontWeight: FontWeight.w400,
                        //   color: AppColors.black,
                        // ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25.w,
                        vertical: 10.h,
                      ),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        color: AppColors.dashedBorderColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 10.h,
                        ),
                        radius: Radius.circular(
                          10.r,
                        ),
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 15.h,
                        horizontal: 30.w,
                      ),
                      child: WhiteButtonWidget(
                        text: MyTaskListConstants.SUBMIT_BTN.tr(),
                        color: AppColors.buttonColor,
                        onTap: () {
                         
                        openDialog();
                          // if (widget.isFromChooseFacility) {
                          //   Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => TaskList(),
                          //     ),
                          //   );
                          // }
                          // if (widget.isFromTask) {
                          //   Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => Dashboard(
                          //         isFromJanitor: true,
                          //         isFromSupervisor: false,
                          //       ),
                          //     ),
                          //   );
                          // }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  openDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogueWidget(
          text: MyTaskListConstants.POPUP_TITLE.tr(),
          onTapSubmit: () {
            _imagesBloc.add(UploadImages(
              type: TaskCompletionScreenConstants.IMAGE_TYPE_TASK,
              image: fileList,
              id: widget.allocationId,
              remarks: _controller.text,
              allocationId: widget.allocationId,
            ));
          },
          onTapCancel: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<File?> pickFile(File? old, PickSource source) async {
    try {
      File? file;

      if (source == PickSource.camera) {
        final ImagePicker picker = ImagePicker();
        final XFile? photo = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
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
