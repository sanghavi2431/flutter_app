import 'package:Woloo_Smart_hygiene/screens/common_widgets/checkbox_list_widget.dart';
import 'package:Woloo_Smart_hygiene/screens/common_widgets/empty_list_widget.dart';
import 'package:Woloo_Smart_hygiene/screens/common_widgets/error_widget.dart';
import 'package:Woloo_Smart_hygiene/screens/common_widgets/white_button_widget.dart';
import 'package:Woloo_Smart_hygiene/screens/task_list/bloc/tasklist_bloc.dart';
import 'package:Woloo_Smart_hygiene/screens/task_list/bloc/tasklist_event.dart';
import 'package:Woloo_Smart_hygiene/screens/task_list/bloc/tasklist_state.dart';
import 'package:Woloo_Smart_hygiene/screens/task_list/data/model/create_task_model.dart';
import 'package:Woloo_Smart_hygiene/screens/task_list/data/model/submit_task_model.dart';
import 'package:Woloo_Smart_hygiene/screens/task_list/data/model/task_list_model.dart';
import 'package:Woloo_Smart_hygiene/utils/app_color.dart';
import 'package:Woloo_Smart_hygiene/utils/app_constants.dart';
import 'package:Woloo_Smart_hygiene/utils/app_textstyle.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common_widgets/leading_button.dart';

class TaskList extends StatefulWidget {
  final int? templateId;
  final String allocationId;

  const TaskList({
    Key? key,
    required this.templateId,
    required this.allocationId,
  }) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  bool submitButtonTap = true;
  bool skipButtonTap = false;
  TaskListBloc taskListBloc = TaskListBloc();
  TaskListModel data = TaskListModel();
  SubmitTaskModel submitData = SubmitTaskModel();
  CreateTaskModel createTaskModel = CreateTaskModel();

  @override
  void initState() {
    createTaskModel.data = [];
    print("allocationIddddd " + widget.templateId.toString());
    createTaskModel.allocationId = widget.allocationId;
    taskListBloc.add(GetAllTask(id: widget.templateId ?? 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: taskListBloc,
        listener: (context, state) {
          if (state is GetTasksSuccess) {
            EasyLoading.dismiss();
          }

          if (state is SubmitTasksSuccess) {
            EasyLoading.dismiss();
            EasyLoading.showToast(
                MyTaskListConstants.TASK_SUBMISSION_TOAST.tr());
            Navigator.pop(context);
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is GetTasksLoading) {
            EasyLoading.show(
                status: MydashboardScreenConstants.LOADING_TOAST.tr());
          }
          else
          if (state is GetTasksError) {
            return CustomErrorWidget(error: state.error);
          }
           else
          if (state is GetTasksSuccess  ) {
            EasyLoading.dismiss();
             data = state.data;
            return
             Scaffold(
            backgroundColor: AppColors.white,

            appBar: AppBar(
              backgroundColor: AppColors.white,
              leadingWidth: 100.w,
              leading:
              LeadingButton(),

              // IconButton(
              //   icon:
              //   const Icon(
              //     Icons.arrow_back,
              //     color: Colors.white,
              //     size: 30,
              //   ),
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              // ),
              // title: Padding(
              //   padding: EdgeInsets.symmetric(
              //     horizontal: 15.w,
              //     vertical: 10.h,
              //   ),
              //   child: Text(
              //     MyTaskListConstants.APP_BAR.tr(),
              //     textAlign: TextAlign.start,
              //     style:
              //     AppTextStyle.font24.copyWith(
              //       color: AppColors.yellowSplashColor,
              //     )
              //     //  TextStyle(
              //     //   color: AppColors.yellowSplashColor,
              //     //   fontSize: 24.sp,
              //     //   fontWeight: FontWeight.w400,
              //     // ),
              //   ),
              // ),

              elevation: 0,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 15.h,
                    horizontal: 20.w,
                  ),
                  child:
                  Text(
                      MyTaskListConstants.APP_BAR.tr(),
                      textAlign: TextAlign.start,
                      style:
                      AppTextStyle.font24bold.copyWith(
                     //   color: AppColors.yellowSplashColor,
                      )
                    //  TextStyle(
                    //   color: AppColors.titleColor,
                    //   fontSize: 24.sp,
                    //   fontWeight: FontWeight.w400,
                    // ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                    ),
                    child: RefreshIndicator(
                      onRefresh: () {
                        return Future.delayed(
                          Duration(seconds: 1),
                          () {
                            taskListBloc
                                .add(GetAllTask(id: widget.templateId ?? 0));
                          },
                        );
                      },
                      color: AppColors.buttonColor,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: data.tasks?.length ?? 0,
                        scrollDirection: Axis.vertical,
                        // shrinkWrap: true,
                        itemBuilder: (
                          BuildContext context,
                          int index,
                        ) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 7.h,
                            ),
                            child: CheckboxListWidget(
                              name: data.tasks?[index].taskName,
                              isChecked: createTaskModel.data!.firstWhereOrNull(
                                      (element) =>
                                          element.taskId ==
                                          data.tasks?[index].taskId) !=
                                  null,
                              onChecked: (bool selected, String s) {
                                if (selected) {
                                  createTaskModel.data!.add(
                                    InternalData(
                                      taskId: data.tasks?[index].taskId ?? '',
                                      taskName:
                                          data.tasks![index].taskName ?? '',
                                      status: 1,
                                    ),
                                  );
                                  print(createTaskModel.toJson());
                                } else {
                                  //_selectedProductIds.removeWhere((element) => element == data.tasks?[index].taskId);
                                  createTaskModel.data!.removeWhere(
                                    (element) =>
                                        element.taskId ==
                                        data.tasks?[index].taskId,
                                  );
                                  print(createTaskModel.toJson());
                                }
                                setState(() {});
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                createTaskModel.data!.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20.h,
                          horizontal: 30.w,
                        ),
                        child: WhiteButtonWidget(
                          text: MyTaskListConstants.SUBMIT_BTN.tr(),
                          color: submitButtonTap
                              ? AppColors.buttonColor
                              : AppColors.white,
                          onTap: () {
                            if (createTaskModel.data!.isNotEmpty) {
                              taskListBloc.add(SubmitTasks(
                                  createTaskModel: createTaskModel));
                              print(state);
                            }

                            print(createTaskModel.toJson());
                          },
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20.h,
                          horizontal: 30.w,
                        ),
                        child: WhiteButtonWidget(
                          text: MyTaskListConstants.SUBMIT_BTN.tr(),
                          color: AppColors.disabledCamButtonColor,
                          onTap: () {},
                        ),
                      ),
              ],
            ),
          );
            
            // const EmptyListWidget();
          }
           else
          if (state is SubmitTasksLoading) {
            EasyLoading.show(
                status: MydashboardScreenConstants.LOADING_TOAST.tr());
          }
           else
          if (state is SubmitTasksError) {
            print(state);

            return CustomErrorWidget(error: state.error.message);
          }
           else

          if (state is SubmitTasksSuccess && (state.data.isEmpty)) {
            EasyLoading.dismiss();

            return  EmptyListWidget(
              filter:  EmptyWidgetConstants.DATA_NOT_FOUND.tr(),
            );
          }

          return SizedBox();
          
        });
  }
}
