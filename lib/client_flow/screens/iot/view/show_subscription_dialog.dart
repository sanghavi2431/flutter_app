import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/local/global_storage.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_textstyle.dart';
import '../../dashbaord/bloc/dashboard_bloc.dart';
import '../../dashbaord/bloc/dashboard_event.dart';
import '../../dashbaord/data/model/facility_model.dart';
import '../../subcription/view/subcription.dart';

void showSubscriptionDialog(int remainingDays, bool isExpired , BuildContext context , ClientDashBoardBloc dashBoardBloc , List<Facility> facility) {

  /*showDialog(
    barrierDismissible: !isExpired,
    context: context,
    builder: (dialogContext) {

      return AlertDialog(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Text(
              isExpired
                  ? "Your TASKMASTER Trial Period has expired. Kindly pay to Continue"
                  : "Your Free Subscription shall end in $remainingDays Days.",
              textAlign: TextAlign.center,
              style: AppTextStyle.font18bold,
            ),

            SizedBox(height: 24.h),

            Row(
              children: [

                if (!isExpired)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(dialogContext);
                      },
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        child: Text("Skip"),
                      ),
                    ),
                  ),

                Expanded(
                  child: GestureDetector(
                    onTap: () {

                      Navigator.pop(dialogContext);

                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {

                          return SubcriptionScreen(
                            dashBoardBloc: dashBoardBloc,
                            isfromFacility: true,
                            facilityId: facility[1].id,
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Text("Renew It Now"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );*/
  GlobalStorage globalStorage = GetIt.instance();

  showDialog(
    barrierDismissible: !isExpired,
    context: context,
    builder: (dialogContext) {
      print("aarati facility length ${facility.length}");

      return PopScope(
        canPop: !isExpired,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: AppColors.white,
          contentPadding: EdgeInsets.zero,
          insetPadding:
          EdgeInsets.symmetric(horizontal: 16.w),
          content: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isExpired
                      ? "Your TASKMASTER Trial Period has expired. Kindly pay to Continue"
                      : "Your Free Subscription shall end in $remainingDays Days.",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.font18bold,
                ),
                SizedBox(
                  height: 24.h,
                ),
                Row(
                  children: [
                    if (!isExpired)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(
                                dialogContext)
                                .pop();
                          },
                          child: Container(
                            height: 40.h,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(
                                  12),
                              color: const Color(
                                  0xFFEDE8E8), // Skip button color
                            ),
                            alignment: Alignment
                                .center,
                            child: Text(
                              "Skip",
                              style: AppTextStyle
                                  .font18bold
                                  .copyWith(
                                  color: AppColors
                                      .black),
                            ),
                          ),
                        ),
                      ),
                    if (!isExpired)
                      SizedBox(
                        width: 8.w,
                      ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(
                              dialogContext)
                              .pop();
                          showModalBottomSheet(
                            backgroundColor:
                            Colors.transparent,
                            context: context,
                            builder: (context) {
                              return SubcriptionScreen(
                                dashBoardBloc:
                                dashBoardBloc,
                                isfromFacility: true,
                                facilityId:
                                facility[1].id,
                              );
                            },
                          ).then((value) {
                            final String currentPlanId =
                            globalStorage
                                .getPlanId();
                            if (currentPlanId ==
                                "0") {
                              dashBoardBloc.add(
                                  SubcriptionEvent(
                                      id: int.parse(
                                          globalStorage
                                              .getClientId())));
                            }
                          });
                        },
                        child: Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(
                                12),
                            color: const Color(
                                0xFF83E0FF), // Renew button color
                          ),
                          alignment: Alignment
                              .center,
                          child: Text(
                            "Renew It Now",
                            style: AppTextStyle
                                .font18bold
                                .copyWith(
                                color:
                                AppColors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  ).then(
        (value) {
// No-op on dialog close
    },
  );

}




