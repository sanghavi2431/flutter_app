import 'package:Woloo_Smart_hygiene/screens/common_widgets/leading_button.dart';
import 'package:Woloo_Smart_hygiene/screens/janitor_details_screen/view/janitor_attendance.dart';
import 'package:Woloo_Smart_hygiene/utils/app_color.dart';
import 'package:Woloo_Smart_hygiene/utils/app_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SupJaniAttendanceScreen extends StatelessWidget {
  final int janiId;
  const SupJaniAttendanceScreen({super.key, required this.janiId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
         appBar: AppBar(
          backgroundColor: AppColors.white,
        leadingWidth: 100.w,
        leading: LeadingButton(),
        scrolledUnderElevation: 0,
        elevation: 0,
        // title: 
      ),
      body: JanitorAttendance(janiId: janiId),
    );
  }
}
