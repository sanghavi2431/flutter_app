import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';

class Category {
  String name;
  String imageUrl;
  Color color;
  Category({this.name = "", required this.imageUrl, this.color = Colors.red});
}

final categories = [
  Category(
      name: 'General',
      imageUrl: AppImages.general,
      color: const Color(0xffFDEBD2)),
  Category(
      name: 'Cleaning',
      imageUrl: AppImages.cleaning,
      color: const Color(0xffFBDDDD)),
  Category(
      name: 'Toilet Gadgets',
      imageUrl: AppImages.toileries,
      color: const Color(0xffC7E3F9)),
  Category(
      name: 'Dusting',
      imageUrl: AppImages.dusting,
      color: const Color(0xffD5FFED)),
  Category(
      name: 'Kitchen',
      imageUrl: AppImages.kitchen,
      color: const Color(0xffFEF9BD)),
  Category(
      name: 'Uniforms',
      imageUrl: AppImages.uniforms,
      color: const Color(0xffFBDDDD)),
];

final topBrands = [
  Category(imageUrl: AppImages.fenyl1),
  Category(imageUrl: AppImages.fenyl2),
  Category(imageUrl: AppImages.fenyl3),
  Category(imageUrl: AppImages.fenyl4),
  Category(imageUrl: AppImages.fenyl5),
  Category(imageUrl: AppImages.fenyl6),
];

final services = [
  Category(imageUrl: AppImages.pest, name: "Pest Control"),
  Category(imageUrl: AppImages.deepCleaning, name: "Deep Cleaning"),
  Category(imageUrl: AppImages.chimney, name: "Chimney Cleaning"),
  Category(imageUrl: AppImages.sofa, name: "Sofa Cleaning"),
  Category(imageUrl: AppImages.acService, name: "AC Servicing"),
  Category(imageUrl: AppImages.houseKeeping, name: "HouseKeeping Staff"),
  Category(imageUrl: AppImages.bathroom, name: "Bathroom Cleaning"),
  Category(imageUrl: AppImages.electric, name: "Electrical Audit"),
  Category(imageUrl: AppImages.chefLogo, name: "Food handler Medical Audit"),
];

final banners = [
  Category(imageUrl: AppImages.banner1),
  Category(imageUrl: AppImages.banner2),
  Category(imageUrl: AppImages.banner3),
];

final bhkValues=["1 RK","1 BHK","2 BHK","3 BHK"];