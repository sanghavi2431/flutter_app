import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../b2b_store/cart.dart';
import '../client_flow/screens/dashbaord/view/dashboard.dart';
import '../utils/app_images.dart';

Dialog buildOrderSuccessDialog(BuildContext context) {
  return Dialog(
    backgroundColor: Colors.transparent, // transparent outside rounded box
    insetPadding: const EdgeInsets.all(16),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(40), // rounded corners for dialog
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Foreground content
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white, // semi-transparent overlay
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.asset(AppImages.check_icon),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Your Order has been \nplaced Successfully",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                LongLabeledButton(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (c) => ClientDashboard(dashIndex: 0),
                      ),
                      (route) => false,
                    );
                  },
                  label: "Check Order Details",
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
