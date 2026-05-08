import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../utils/app_color.dart';
import 'facility_bottom_sheet.dart';

class OthersInputField extends StatelessWidget {
  final TextEditingController controller;

  const OthersInputField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),

        decoration: BoxDecoration(

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Shadow color
                spreadRadius: 1, // Spread effect
                blurRadius: 4, // Blur effect
                offset: const Offset(0, 4), // Bottom shadow
              ),
            ],
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color
                    : AppColors.white)),
        child:
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "If others, mention facility",
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty ||  value.trim().isEmpty) {
              return BSStrings.otherType;
            }
            else if (value.length < 3) {
              return BSStrings.facilityLength;
            }
            return null;
          },
        ),);
  }
}