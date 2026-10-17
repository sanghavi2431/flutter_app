import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

import '../../../../../b2b_store/models/user_prolfie.dart';
import '../../../../../host/host_details.dart';

final Map<String, Map<String, String>> amenityMap = {
  "is_clean_and_hygiene": {
    "label": "Clean & Hygienic Toilets",
    "icon": AppImages.cleanHygiene
  },
  "segregated": {
    "label": "Gender Specific",
    "icon": AppImages.segregated
  },
  "is_coffee_available": {
    "label": "Coffee",
    "icon": AppImages.coffee
  },
  "is_safe_space": {
    "label": "Safe Space",
    "icon": AppImages.safeSpace
  },
  "is_wheelchair_accessible": {
    "label": "Wheelchair",
    "icon": AppImages.wheelChair
  },
  "restaurant": {
    "label": "Restaurant",
    "icon": AppImages.restaurant
  },
  "is_sanitary_pads_available": {
    "label": "Sanitary Pads",
    "icon": AppImages.sanitaryPad
  },
  "is_makeup_room_available": {
    "label": "Makeup",
    "icon": AppImages.makeUp
  },
  "is_sanitizer_available": {
    "label": "Hand Sanitizer",
    "icon": AppImages.handSanitizer
  },
  "is_feeding_room": {
    "label": "Feeding Room",
    "icon": AppImages.breastFeeding
  },
  "is_washroom": {
    "label": "Western Washroom",
    "icon": AppImages.westernWashroom
  },
  "is_premium": {
    "label": "Premium",
    "icon": AppImages.premium
  },
  "is_franchise": {
    "label": "Franchise",
    "icon": AppImages.franchise
  },
  "is_covid_free": {
    "label": "Covid Free",
    "icon": AppImages.covidFree
  }
};

List<Widget> buildAmenityChips(ResultsHostDetails data) {
  List<Widget> chips = [];

  amenityMap.forEach((key, value) {
    final amenity = data.toJson()[key];
    if (amenity != null && amenity is Map && amenity['value'] == 1) {
      chips.add(AmenityChip(title:value["label"]!, iconPath:value["icon"]!));
    }
  });

  return chips;
}


class AmenityChip extends StatelessWidget {
  final String title;
  final String iconPath;

  const AmenityChip({
    super.key,
    required this.title,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.chipGrayColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 18,
            width: 18,
            child: Image.asset(iconPath, fit: BoxFit.contain),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: AppTextStyle.font10boldWhite,
          ),
        ],
      ),
    );
  }
}
