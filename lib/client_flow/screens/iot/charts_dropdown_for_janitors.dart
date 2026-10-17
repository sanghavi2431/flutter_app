import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../dashbaord/data/model/facility_dropdown_model.dart';
import '../../widgets/chart.dart';


class ChartsDropdown extends StatelessWidget {

  final List<FacilityDropdownModel> facilitydropdownNames;
  final FacilityDropdownModel? selectedValue;
  final FacilityDropdownModel? selectItem;
  final Function(FacilityDropdownModel?) onChanged;

  const ChartsDropdown({
    super.key,
    required this.facilitydropdownNames,
    required this.selectedValue,
    required this.selectItem,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "Task Audit",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<FacilityDropdownModel>(

              hint: selectItem == null
                  ? const Text(ChartsConstants.selectBuddy)
                  : Text(selectItem!.facilityName ?? ""),

              items: facilitydropdownNames.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item.facilityName ?? ""),
                );
              }).toList(),

              value: selectedValue,
              onChanged: onChanged,

              buttonStyleData: ButtonStyleData(
                height: ChartsConstants.dropdownHeight,
                width: ChartsConstants.dropdownWidth,
              ),
            ),
          ),
        )
      ],
    );
  }
}


class ChartsConstants {

  static const double containerRadius = 20;
  static const double dropdownHeight = 40;
  static const double dropdownWidth = 140;

  static const double spacing10 = 10;
  static const double spacing20 = 20;
  static const double spacing40 = 40;

  static const String selectBuddy = "Select buddy";
  static const String explore = "Explore";
  static const String letsGo = "Let's go";
}