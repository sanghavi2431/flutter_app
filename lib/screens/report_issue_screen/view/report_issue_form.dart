import 'dart:core';
import 'dart:io';

import 'package:woloo_smart_hygiene/screens/common_widgets/button_widget.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/dialogue_box_issue_report.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/dropdown_dialogue.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/error_widget.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/multiselect_dropdown.dart';
import 'package:woloo_smart_hygiene/screens/report_issue_screen/bloc/report_issue_bloc.dart';
import 'package:woloo_smart_hygiene/screens/report_issue_screen/bloc/report_issue_event.dart';
import 'package:woloo_smart_hygiene/screens/report_issue_screen/bloc/report_issue_state.dart';
import 'package:woloo_smart_hygiene/screens/report_issue_screen/data/model/cluster_dropdown_model.dart';
import 'package:woloo_smart_hygiene/screens/report_issue_screen/data/model/facility_dropdown_model.dart';
import 'package:woloo_smart_hygiene/screens/report_issue_screen/data/model/janitor_dropdown_model.dart';
import 'package:woloo_smart_hygiene/screens/report_issue_screen/data/model/task_names_model.dart';
import 'package:woloo_smart_hygiene/screens/report_issue_screen/widget/view_image.dart';
import 'package:woloo_smart_hygiene/screens/task_list/data/model/task_list_model.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:image_picker/image_picker.dart';

import 'package:queen_validators/queen_validators.dart';

import '../../selfie_screen/view/camera.dart';
import '../../washroom_image_screen/images_bloc/bloc/capture_bloc.dart';
import '../../washroom_image_screen/images_bloc/event/capture_event.dart';
import '../../washroom_image_screen/images_bloc/state/capture_state.dart';

enum PickSource {
  camera,
  gallery,
}

class ReportIssueScreen extends StatefulWidget {
  final PageController? pageController;
  const ReportIssueScreen({
    super.key,
    this.pageController
  });

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  File? _file;

  ReportIssueBloc reportIssueBloc = ReportIssueBloc();
  final TextEditingController _controller = TextEditingController();
   // GlobalKey<DropdownSearchState> dropDownKey = GetIt.instance();
  // dropDownKey;
  List<ClusterDropdownModel> clusterNames = [];
  List<FacilityDropdownModel> facilityNames = [];
  List<TaskNamesModels> templateNames = [];
  TaskListModel taskNames = TaskListModel();
  List<Tasks> tasks = [];
  List<String> taskIds = [];
  List<JanitorDropdownModel> janitorList = [];
  // ReportIssueModel _reportIssueModel = ReportIssueModel();
  List<String> selectedIds = [];
  String templateId = "";
  late int janitorId;
  late int clusterId;
  late int facilityId;
  late File taskImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ReportIssueBloc bloc1 = ReportIssueBloc();
  final ReportIssueBloc bloc2 = ReportIssueBloc();
  final ReportIssueBloc bloc3 = ReportIssueBloc();
   final CaptureBloc _captureBloc = CaptureBloc();
  final GlobalKey<DropdownSearchState> _clusterNameKey = GlobalKey<DropdownSearchState>();
  final GlobalKey<DropdownSearchState> _facilityKey = GlobalKey<DropdownSearchState>();
  final GlobalKey<DropdownSearchState> _templateKey = GlobalKey<DropdownSearchState>();
  final GlobalKey<DropdownSearchState> _taskNameKey = GlobalKey<DropdownSearchState>();
  final GlobalKey<DropdownSearchState> _assignKey = GlobalKey<DropdownSearchState>();
  final AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  // final GlobalKey<DropdownSearchState> _dropDownKey = GlobalKey<DropdownSearchState>();
  // final GlobalKey<DropdownSearchState> _dropDownKey = GlobalKey<DropdownSearchState>();
  // final GlobalKey<DropdownSearchState> _dropDownKey = GlobalKey<DropdownSearchState>();

  // GlobalKey<DropdownSearchState> dropDownKey = GlobalKey<DropdownSearchState>();
  @override
  void initState() {
    reportIssueBloc.add(const GetAllClustersDropdown());
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return 
    BlocConsumer(
        bloc: reportIssueBloc,
        listener: (context, state) {
        
          if (state is ReportIssueSuccess) {
            EasyLoading.dismiss();
          //  _reportIssueModel = state.data;
            openDialog();
            // clusterNames = [];
            // facilityNames = [];
            // templateNames = [];
            // taskNames = TaskListModel();
            // tasks.clear();
            // taskIds.clear();
            _controller.clear();
            _facilityKey.currentState?.clear();
            _clusterNameKey.currentState!.clear();
            _templateKey.currentState?.clear();
               _taskNameKey.currentState?.clear();
               _assignKey.currentState?.clear();
            _captureBloc.add(  RemoveImages(file: _file ));

           // _autoValidate = AutovalidateMode.always;
           // _formKey.currentState!.dispose();
            // EasyLoading.showToast(_repor btIssueModel.message.toString());
          }
        },
        builder: (context, state) {

             debugPrint("report issue  $state");
          if (state is GetClustersDropdownLoading) {
            EasyLoading.show(
                status: MydashboardScreenConstants.LOADING_TOAST.tr());
          }
          else
          if (state is GetClustersDropdownError) {
            return CustomErrorWidget(error: state.error.message);
          }
          else
          if (state is GetClustersDropdownSuccess  ) {

            EasyLoading.dismiss();
               clusterNames = state.data;
          //  return const EmptyListWidget();
          }
          else
          if (state is GetFacilityDropdownLoading) {
            EasyLoading.show(
                status: MydashboardScreenConstants.LOADING_TOAST.tr());
          }
           else
          if (state is GetFacilityDropdownError) {
            return CustomErrorWidget(error: state.error.message);
          }
          else
          if (state is GetFacilityDropdownSuccess  ) {

            EasyLoading.dismiss();
             facilityNames = state.data;
            reportIssueBloc.add(GetAllTasksDropdown(
                      clusterId: clusterId 
                  ));
         //   return const EmptyListWidget();
          }
          else
          if (state is GetTasksDropdownLoading) {
            EasyLoading.show(
                status: MydashboardScreenConstants.LOADING_TOAST.tr());
          }
          else
          if (state is GetTasksDropdownError) {
            return CustomErrorWidget(error: state.error.message);
          }
           else
            if (state is GetTasksDropdownSuccess) {
            EasyLoading.dismiss();
              templateNames = state.data;
            reportIssueBloc.add(GetAllJanitorsDropdown(
                       clusterId: clusterId  ));
           
          }
           else
          if (state is GetJanitorsDropdownLoading) {
            EasyLoading.show(
                status: MydashboardScreenConstants.LOADING_TOAST.tr());
          }
          else
          if (state is GetJanitorsDropdownError) {
            return CustomErrorWidget(error: state.error.message);
          }
           else
              if (state is GetJanitorsDropdownSuccess) {
            EasyLoading.dismiss();

            
              janitorList = state.data;
            
          }
          else
          if (state is GetTasksListLoading) {
            EasyLoading.show(
                status: MydashboardScreenConstants.LOADING_TOAST.tr());
          }
          else
          if (state is GetTasksListError) {
            return CustomErrorWidget(error: state.error);
          }
          else
           if (state is GetTasksListSuccess) {
            EasyLoading.dismiss();

            
              taskNames = state.data;
              tasks = taskNames.tasks!;
           
          }
          else
          if (state is ReportIssueLoading) {
            EasyLoading.show(
                status: MydashboardScreenConstants.LOADING_TOAST.tr());
          }
           else
          if (state is ReportIssueError) {
            return CustomErrorWidget(error: state.error.message);
          }
          else
           if (state is ReportIssueSuccess) {
          //  EasyLoading.dismiss();
          //  _reportIssueModel = state.data;
             // if(mounted){
         //  return
            // openDialog();
             // }

            // EasyLoading.showToast(_reportIssueModel.message.toString());
          }
       

          return GestureDetector(
            onTap: () {
           if (Platform.isAndroid) hideKeyboard(context);
            if (Platform.isIOS) hideKeyboard(context);
            },
            child: Scaffold(
              backgroundColor: AppColors.white,

              appBar:
               AppBar(
             //    leadingWidth: 100.w,
              //  leading:LeadingButton(),
                backgroundColor: AppColors.white,
                elevation: 0,
                 title:          Padding(
                   padding: EdgeInsets.symmetric(
                     horizontal: 15.w,
                     vertical: 10.h,
                   ),
                   child: Text(
                       MydashboardScreenConstants.REPORT_ISSUE.tr(),
                       textAlign: TextAlign.start,
                       style:
                       AppTextStyle.font24bold.copyWith(
                         color: AppColors.black,
                       )
                     //  TextStyle(
                     //   color: AppColors.yellowSplashColor,
                     //   fontSize: 24.sp,
                     //   fontWeight: FontWeight.w400,
                     // ),
                   ),
                 ),
              ),
              body: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autoValidate,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
                        child: DropDownDialog(
                          // selected: clusterNames.first,
                          // key: _dropDownKey,
                          widgetKey: _clusterNameKey,

                          hint: MyReportIssueScreenConstants.CLUSTER_NAME.tr(),



                          items: clusterNames,

                          itemAsString: (ClusterDropdownModel item) =>
                              item.clusterName,
                          onChanged: (ClusterDropdownModel item) {
                            debugPrint("in drop down $state");
                            try {
                              clusterId = item.clusterId!;
                              reportIssueBloc.add(GetAllFacilityDropdown(
                                  clusterId: item.clusterId ?? 0));
                              //
                              //   // if(state is GetFacilityDropdownSuccess ){
                              //     reportIssueBloc.add(GetAllTasksDropdown(
                              //         clusterId: item.clusterId! ?? 0
                              //     ));
                              //   // }else
                              //    // if( state is  GetTasksDropdownSuccess ){
                              //      reportIssueBloc.add(GetAllJanitorsDropdown(
                              //          clusterId: item.clusterId ?? 0));
                                 // }


                            } catch (e) {
                              debugPrint("dropppppp$e");
                            }
                          },
                          validator: (value) => value == null
                              ? MyReportIssueScreenConstants
                                  .CLUSTER_NAME_VALIDATION
                                  .tr()
                              : null,
                        ),
                      ),

                      // ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        child: DropDownDialog(
                          // key: dropDownKey,
                          selected: null,
                          widgetKey: _facilityKey,
                          hint:  MyReportIssueScreenConstants.FACILITY.tr(),
                          // key: Key('${_editMarketModel.city?.label}T4'),
                          // selected: cities.firstWhereOrNull((element) => element.value == _editMarketModel.city?.value),
                          // widgetKey: _keys[2],xx
                          items: facilityNames,
                          itemAsString: (FacilityDropdownModel item) =>
                              item.facilityName,

                          onChanged: (FacilityDropdownModel item) {

                              facilityId = item.id!;
                              debugPrint("facilityId --->$facilityId");

                          },

                          validator: (value) => value == null
                              ? MyReportIssueScreenConstants.FACILITY_VALIDATION
                                  .tr()
                              : null,
                        ),
                      ),


                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        child: DropDownDialog(
                          widgetKey: _templateKey,
                          hint:    MyReportIssueScreenConstants.TEMPLATE_NAME.tr(),
                          // key: Key('${_editMarketModel.city?.label}T4'),
                          // selected: cities.firstWhereOrNull((element) => element.value == _editMarketModel.city?.value),
                          // widgetKey: _keys[2],
                          items: templateNames,
                          itemAsString: (TaskNamesModels item) =>
                              item.templateName,
                          validator: (value) => value == null
                              ? MyReportIssueScreenConstants
                                  .TEMPLATE_NAME_VALIDATION
                                  .tr()
                              : null,
                          onChanged: (TaskNamesModels item) {
                            reportIssueBloc
                                .add(GetAllTaskList(id: item.id ?? '0'));

                              templateId = item.id!;
                            debugPrint("templateId --->$templateId");

                          },
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(
                      //     horizontal: 20.h,
                      //   ),
                      //   child: Text(
                      //     MyReportIssueScreenConstants.TASK_NAME.tr(),
                      //     style:
                      //        AppTextStyle.font16.copyWith(
                      //         color: AppColors.clusterTitleColor,
                      //        ),
                      //     // TextStyle(
                      //     //   color: AppColors.clusterTitleColor,
                      //     //   fontSize: 16.sp,
                      //     //   fontWeight: FontWeight.w400,
                      //     // ),
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        child: Container(
                             decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2), // Shadow color
                          spreadRadius: 1, // How wide the shadow should spread
                          blurRadius: 10, // The blur effect of the shadow
                          offset: const Offset(0,
                              5), // Shadow offset, with y-offset for bottom shadow
                        ),
                      ],
      ),
                          child: MultiselectDropDownDialog(
                            widgetKey: _taskNameKey,
                            hint: MyReportIssueScreenConstants.TASK_NAME.tr(),
                            // key: Key(
                            //     '${_editProductModel.paymentMethodId?.firstOrNull?.label}T5'),
                            // selected: _editProductModel.paymentMethodId,
                            items: tasks,
                            itemAsString: (Tasks item) => item.taskName,
                            validator: (value) => value == null
                                ? MyReportIssueScreenConstants
                                    .TASK_NAME_VALIDATION
                                    .tr()
                                : null,
                            onSaved: (List<Tasks> i) {
                              // selectedIds.add(i[1].taskId!);
                              selectedIds =
                                  i.map((e) => e.taskId.toString()).toList();
                            },
                            onChanged: (List<Tasks> i) {
                              selectedIds =
                                  i.map((e) => e.taskId.toString()).toList();
                              debugPrint(selectedIds.toString());
                            },
                            // label: 'Template Name',
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        child: Container(
                             decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues( alpha: 0.2), // Shadow color
                          spreadRadius: 1, // How wide the shadow should spread
                          blurRadius: 10, // The blur effect of the shadow
                          offset: const Offset(0,
                              5), // Shadow offset, with y-offset for bottom shadow
                        ),
                      ],
      ),
                          child: TextFormField(
                              autovalidateMode: AutovalidateMode.disabled,
                             decoration: InputDecoration(
                               hintText:  MyReportIssueScreenConstants.DESCRIPTION.tr(),
                               contentPadding: const EdgeInsets.only( left: 12 ),
                               border: InputBorder.none

                             ),


                            // hint:  MyReportIssueScreenConstants.DESCRIPTION.tr(),

                            controller: _controller,
                            validator: qValidator([
                              IsRequired(
                                MyReportIssueScreenConstants
                                    .DESCRIPTION_VALIDATION
                                    .tr(),
                              ),
                            ]),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(
                      //     horizontal: 20.h,
                      //   ),
                      //   child: Text(
                      //     MyReportIssueScreenConstants.ASSIGN_TO.tr(),
                      //     style:
                      //       AppTextStyle.font16.copyWith(
                      //      color: AppColors.clusterTitleColor,
                      //        )
                      //     //  TextStyle(
                      //     //   color: AppColors.clusterTitleColor,
                      //     //   fontSize: 16.sp,
                      //     //   fontWeight: FontWeight.w400,
                      //     // ),
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        child: DropDownDialog(
                          widgetKey: _assignKey,
                          hint:      MyReportIssueScreenConstants.ASSIGN_TO.tr(),
                          items: janitorList,
                          itemAsString: (JanitorDropdownModel item) =>
                              item.name,
                          validator: (value) => value == null
                              ? MyReportIssueScreenConstants.ASSIGN_VALIDATION
                                  .tr()
                              : null,
                          onChanged: (JanitorDropdownModel item) {

                             FocusScope.of(context).requestFocus(FocusNode());
                              janitorId = item.id!;
                              debugPrint("selectedTasks---->$selectedIds");

                             debugPrint("janitorId --->$janitorId");

                          },
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                   
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                        ),
                        child: DottedBorder(
                          dashPattern: const [4, 4, 4, 4],
                          color: Colors.black,
                          borderType: BorderType.RRect,
                          radius: Radius.circular(25.r),
                          
                          strokeWidth: 0.5.w,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 20.h,
                            ),
                            child:

                             BlocBuilder(
                               bloc: _captureBloc,
                              builder: (context, state) {
                                   debugPrint("  reposrt issue $state");
                                 if ( state  is AddImagesInitial ) {

                                      return       GestureDetector(
                              onTap: () async {
                                 
                                       Navigator.of(context).push( MaterialPageRoute(builder: (context) =>  CameraPage(
                                            sensorPosition: SensorPosition.back,
                                             captureImage: (val){
                                                _file = val;
                                                _captureBloc.add(AddImages(file:_file));
                                         
                                              
                                             },
                                          ),  ) );
                                  

                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                        Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.h,
                          vertical: 10.h,
                        ),
                        child: Text(
                          MyReportIssueScreenConstants.UPLOAD_PHOTO.tr(),
                          style:
                             AppTextStyle.font16bold.copyWith(
                           color: AppColors.disabledButtonTextColor,
                             )

                        ),
                      ),
                      SizedBox(
                        height: 80.h,
                        child: const VerticalDivider(
                          color: AppColors.black,
                        ),
                      ),
                                  Center(
                                          child: Container(
                                            height: 70.h,
                                            width: 140.w,
                                            decoration: BoxDecoration(
                                              color: AppColors.lightGray1,
                                              borderRadius: BorderRadius.circular(
                                                25.r,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                            
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 5.w,
                                                  ),
                                                  child: Text(
                                                    MyReportIssueScreenConstants
                                                        .CHOOSE_PHOTO
                                                        .tr(),
                                                    style:
                                                       AppTextStyle.font14bold.copyWith(
                                                    color: AppColors
                                                        .clusterTitleColor,
                                                  )
                                                    //  TextStyle(
                                                    //   fontSize: 14.sp,
                                                    //   fontWeight: FontWeight.w400,
                                                    //   color: AppColors
                                                    //       .clusterTitleColor,
                                                    // ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5.h,
                                                ),

                                                    Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 5.w,
                                                  ),
                                                  child: const Icon(
                                                    Icons.file_open_outlined,
                                                    size: 23,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            );
                                 }
                                 else if (
                                  state  is AddImagesSuccessful 
                                 ){
                              return 
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    GestureDetector(
                                      onTap: (){
                                         Navigator.of(context).push( MaterialPageRoute(builder:  (context) {
                                             return  ViewImage(
                                              file: _file,
                                             );
                                         }, ) );
                                      },
                                      child: Center(
                                        child: Container(
                                          height: 40.h,
                                          width: 130.w,
                                          decoration: BoxDecoration(
                                            color: AppColors.lightGray1,
                                            borderRadius: BorderRadius.circular(
                                              10.r,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              MyReportIssueScreenConstants
                                                  .VIEW_PHOTO
                                                  .tr(),
                                              style:
                                                 AppTextStyle.font14.copyWith(
                                             color: AppColors.clusterTitleColor,)
                                              //  TextStyle(
                                              //   fontSize: 14.sp,
                                              //   fontWeight: FontWeight.w400,
                                              //   color: AppColors
                                              //       .clusterTitleColor,
                                              // ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                           
                                    GestureDetector(
                                      onTap: (){
                                         _captureBloc.add(  RemoveImages(file: _file ));
                                       
                                      },
                                      child: Center(
                                        child: Container(
                                          height: 40.h,
                                          width: 130.w,
                                          decoration: BoxDecoration(
                                            color: AppColors.lightGray1,
                                            borderRadius: BorderRadius.circular(
                                              10.r,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              MyReportIssueScreenConstants
                                                  .DELETE_PHOTO
                                                  .tr(),
                                              style:
                                              AppTextStyle.font14.copyWith(
                                                color: AppColors
                                                    .clusterTitleColor,
                                              )
                                              // TextStyle(
                                              //   fontSize: 14.sp,
                                              //   fontWeight: FontWeight.w400,
                                              //   color: AppColors
                                              //       .clusterTitleColor,
                                              // ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );

                                 }
                                 else {
                                   return const SizedBox();
                                 }
                             },)
                               
                               
                            //  _file != null
                            //     ?

                            // Center(
                            //         child: Container(
                            //           decoration: BoxDecoration(
                            //             borderRadius:
                            //                 BorderRadius.circular(10.r),
                            //           ),
                            //           child: ClipRRect(
                            //             borderRadius: BorderRadius.circular(
                            //               10.r,
                            //             ),
                            //             child: Image.file(
                            //               _file!,
                            //               width: ScreenUtil().screenWidth,
                            //               height: 80.h,
                            //               fit: BoxFit.cover,
                            //             ),
                            //           ),
                            //         ),
                            //       )
                            //    :
                          
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      GestureDetector(
                        onTap: () {


                          bool isValid =
                              _formKey.currentState?.validate() ?? false;
                          if (!isValid) {
                            return;
                          }



                          if (_file != null) {

                            reportIssueBloc.add(ReportIssue(
                                templateId: templateId,
                                facilityId: facilityId,
                                janitorId: janitorId,
                                description: _controller.text,
                                taskImages: _file!,
                                taskList: selectedIds
                            )
                            );
                          } else {
                            EasyLoading.showToast(MyReportIssueScreenConstants
                                .UPLOAD_IMG_TOAST
                                .tr());
                          }

                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.w, vertical: 20.h),
                          child: ButtonWidget(
                              color: AppColors.buttonYellowColor,
                              text: MySelfieScreenConstants.SUBMIT_BTN.tr()),
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      )
                    ],
                  ),
                ),
              ),


            ),
          );
        });

  }

  Future<File?> pickFile(File? old, PickSource source) async {
    try {
      File? file;
      const List<String> allowedFileTypes = ['jpg', 'png', 'jpeg'];

      if (source == PickSource.gallery) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: allowedFileTypes,
        );
        if (result != null) {
          file = File(result.files.first.path ?? '');
        }
      }

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
        String path = file.path;

        /// Check extension
        String extension = path.split('/').last.split(".").last;
        if (!allowedFileTypes.contains(extension)) {
          throw '.$extension ${MyReportIssueScreenConstants.FILE_NOT_ALLOWED.tr()}';
        }

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

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  openDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const DialogueWidget(

          title: "",
        );
      },
    ).whenComplete( () {
      widget.pageController!.animateToPage(
        5,
        duration: const Duration(
          milliseconds: 200,
        ),
        curve: Curves.bounceOut,
      );

    },);

    //     .then( (value) {

    //
    // },);
  }
}
