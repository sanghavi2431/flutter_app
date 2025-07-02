
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_color.dart';
import '../screens/dashbaord/data/model/facility_dropdown_model.dart';

class CustomDropdown extends StatelessWidget {
 final List<FacilityDropdownModel>? facilityDropdownModel;
 final ValueChanged<FacilityDropdownModel?>? onChanged;
   
 final FacilityDropdownModel? selected;
 final  String? hint;
  const CustomDropdown({super.key , this.facilityDropdownModel, this.onChanged, this.selected, this.hint });

  @override
  Widget build(BuildContext context) {
    return      DropdownButtonHideUnderline(
      child: DropdownButton2<FacilityDropdownModel>(
       dropdownStyleData: DropdownStyleData(
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(7),
           color: AppColors.white
         )
       ),
    
        isExpanded: true,
        hint: 
       //  selectItem == null ? 
        Text(
          hint!,
          style: TextStyle(
              color: Colors.grey,
              fontSize: 16.sp,
          ),
        ),
       //  :
       //  Text(
       //    selectItem!.facilityName!,
       //    style: TextStyle(
       //      fontSize: 14,
       //      color: Theme.of(context).hintColor,
       //    ),
       //  ),
    
        
        items: facilityDropdownModel!.map(( FacilityDropdownModel item) {
          return DropdownMenuItem<FacilityDropdownModel>(
            value: item,
            child: Text(
     item.facilityName!,
     style: const TextStyle(fontSize: 14),
            ),
          );
        }).toList(),
        value: selected, // This should be a FacilityDropdownModel?
        onChanged: (value) => onChanged?.call(value),
       //   (FacilityDropdownModel? value) {
       //    setState(() {
       //      selectedValue = value;
       //    });
       //  },
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 55,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color
              spreadRadius: 1, // Spread effect
              blurRadius: 10, // Blur effect
              offset: const Offset(0, 5), // Bottom shadow
            ),
          
            ],
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(height: 40
         
        ),
      ),
    ) ;
  }
}