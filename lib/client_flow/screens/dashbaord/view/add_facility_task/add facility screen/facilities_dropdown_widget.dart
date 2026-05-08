import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../utils/app_color.dart';
import '../../../../../../utils/app_textstyle.dart';
import 'facility_bottom_sheet.dart';

class FacilityDropdownWidget extends StatelessWidget {
  final List facilitydropdownNames;
  final dynamic selectedFacility;
  final TextEditingController facilityController;
  final bool isFirstTimeHost;
  final bool isOpenDrop;
  final Function(dynamic) onChanged;
  final FocusNode? focusNode;

  const FacilityDropdownWidget({
    super.key,
    required this.facilitydropdownNames,
    required this.selectedFacility,
    required this.facilityController,
    required this.isFirstTimeHost,
    required this.isOpenDrop,
    required this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final activeFacilities = facilitydropdownNames.where((item) {
      final isNotInactive =
          (item.subscriptionStatus ?? "").toLowerCase() != "inactive";

      final isFreeTrial = item.isFreeTrial == true;

      return isNotInactive || isFreeTrial;
    }).toList();


    return facilitydropdownNames.isNotEmpty
        ? DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,

        hint: Text(
          "Facility Name",
          style: AppTextStyle.font14.copyWith(color: Colors.grey),
        ),

        value: selectedFacility,

        items: activeFacilities.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              item.facilityName ?? "",
              style: AppTextStyle.font14,
            ),
          );
        }).toList(),

        onChanged: onChanged,

        iconStyleData: IconStyleData(
          icon: Icon(
            isOpenDrop
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            size: 30,
            color: const Color(0xff8F8F8F),
          ),
        ),

     /*   buttonStyleData: ButtonStyleData(
          height: 55,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),*/

        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: AppColors.white,
          ),
        ),
      ),
    )
        : Container(
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

      child: TextFormField(
        controller: facilityController,
        focusNode: focusNode,
        enabled: !isFirstTimeHost,
        decoration: const InputDecoration(
          hintText: "Facility Name",
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return BSStrings.facilityRequired;
          }
          else if(value.length <= 2  || value.length >= 51)
          {
            return BSStrings.facilityLength;
          }
          return null;
        },
      ),);
  }
}