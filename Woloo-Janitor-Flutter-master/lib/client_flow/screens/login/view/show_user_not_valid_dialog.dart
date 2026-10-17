import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/app_color.dart';
import '../../../../utils/app_textstyle.dart';
import '../../dashbaord/bloc/dashboard_bloc.dart';
import '../../dashbaord/data/model/facility_model.dart';
import '../../subcription/view/subcription.dart';

void showNotValidUserDialog( BuildContext context ) {

  showDialog(
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
              "Facility Manager not allowed to login to task master.",
              textAlign: TextAlign.center,
              style: AppTextStyle.font12bold,
            ),

            SizedBox(height: 24.h),

            Row(
              children: [

                Expanded(
                  child: GestureDetector(
                    onTap: () {

                      Navigator.pop(dialogContext);

                    },
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.lightCyanColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("Try another number",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}