import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/local/global_storage.dart';
import '../../../../../screens/common_widgets/image_provider.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/app_textstyle.dart';
import '../../../../utils/client_images.dart';
import '../../../../widgets/CustomButton.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../bloc/dashboard_state.dart';
import '../dashboard.dart';

void congratDailog({
  required BuildContext context,
  required ClientDashBoardBloc dashBoardBloc,
  required TextEditingController janNameController,
  required int roleId,
  required bool canPop,
  required dynamic planId,
}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      GlobalStorage globalStorage = GetIt.instance();
      return PopScope(
        canPop: canPop,
        child: AlertDialog(
          backgroundColor: AppColors.white,
          title: Center(
            child: Text(
              DashboardConst.congratulations,
              style: AppTextStyle.font20bold,
            ),
          ),
          content: BlocBuilder(
              bloc: dashBoardBloc,
              builder: (context, state) {
                if (state is DashboarLoading) {
                  EasyLoading.show(status: state.message);
                }
                if (state is Subcription) {
                  EasyLoading.dismiss();

                  planId = state.subscriptionModel!.results!.planId;
                }
                if (state is DashboarError) {
                  EasyLoading.dismiss();
                  EasyLoading.showError(state.error);
                }
                return SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      CustomImageProvider(
                        image: ClientImages.celebration,
                        width: 145,
                        height: 145,
                      ),
                      // Text(DashboardConst.scheduleTask,
                      //   style: AppTextStyle.font14w7,
                      // ),
                      SizedBox(
                        height: 20.h,
                      ),

                      Text(
                        textAlign: TextAlign.center,
                        "You have assigned the Task to ${janNameController.text}",
                        style: AppTextStyle.font14w7,
                      ),

                      SizedBox(
                        height: 20.h,
                      ),

                      // isTimePassed
                      //     ?
                      Text(
                        textAlign: TextAlign.center,
                        "Tasks scheduled before the current time will start tracking from the next day, as today's time may have already passed at the time of assignment"!,
                        style: AppTextStyle.font14bold,
                      ),

                      SizedBox(
                        height: 20.h,
                      ),

                      GestureDetector(
                        onTap: () {
                          globalStorage.saveOnboarding(isOnboard: true);

                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return ClientDashboard(
                                dashIndex: roleId == 16 ? 2 : 0,
                                popUpMsg: "asdad",
                              );
                            },
                          ));
                        },
                        child: Custombutton(
                            height: 30.h,
                            text: DashboardConst.noThanks,
                            width: 320.w),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                );
              }),
        ),
      );
    },
  ).then((v) {});
  ;
}
