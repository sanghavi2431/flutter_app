import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../utils/app_color.dart';
import '../../../../../../utils/app_textstyle.dart';
import '../../../model/facility_type_model.dart';
import '../facility_bottom_sheet_card.dart';

class FacilityTypeGrid extends StatelessWidget {
  final List<TypeFacility> facilityType;
  final int selectedIndex;
  final Function(int index) onTap;
  final int otherCount;

  const FacilityTypeGrid({
    super.key,
    required this.facilityType,
    required this.selectedIndex,
    required this.onTap,
    required this.otherCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding
      (
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text("Type of Facility", style: AppTextStyle.font14bold),
          const SizedBox(height: 10),
          GridView.builder(
            itemCount: facilityType.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // ✅ FIXED SCROLL
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final item = facilityType[index];

              return /*GestureDetector(
                onTap: () => onTap(index),
                child: AssignTaskCard(
                  image: item.imageUrl ?? "",
                  title: item.typeName ?? "",
                  index: index,
                  selectedIndex: selectedIndex,
                  typeController: TextEditingController(),
                ),
              );*/
                GestureDetector(
                  onTap: () {
                    if (facilityType.length >= 9 && facilityType[index].typeName == "Others") {
                      // ❌ SHOW DIALOG
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), // ✅ border radius 30
                          ),
                          backgroundColor: Colors.white, // ✅ white background
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                /// TITLE
                                const Text(
                                  "Limit Reached",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12, // ✅ 12 regular
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                /// MESSAGE
                                const Text(
                                  "You can add maximum 5 items only.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12, // ✅ 12 regular
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                /// BUTTON
                            InkWell(
                                borderRadius: BorderRadius.circular(8.r),
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10 ),
                                  margin: EdgeInsets.symmetric(horizontal: 40),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.lightCyanColor, // ✅ button background
                                    borderRadius: BorderRadius.circular(8.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.2),
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    "OK",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              ],
                            ),
                          ),
                        ),
                      );
                      return;
                    }
                    onTap(index);
                  },
                  child: AssignTaskCard(
                    image: item.imageUrl ?? "",
                    title: item.typeName ?? "",
                    index: index,
                    selectedIndex: selectedIndex,
                    typeController: TextEditingController(),
                  ),
                );
            },
          ),
        ],
      ),);
  }
}