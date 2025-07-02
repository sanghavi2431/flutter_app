import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/b2b_store/all_orders.dart';
import 'package:woloo_smart_hygiene/b2b_store/order_details.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/widgets/nav_items.dart';

class XBottomBar extends StatelessWidget {
  const XBottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.themeBackground,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: AppColors.greyShadowColor,
            blurRadius: 5.0,
            spreadRadius: 0.5,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          XNavBarItems(
            imageUrl: AppImages.homeIcon,
            title: "Home",
          ),
          XNavBarItems(
            imageUrl: AppImages.products,
            title: "Products",
          ),
          XNavBarItems(
            imageUrl: AppImages.monitoring,
            title: "Monitoring",
          ),
          XNavBarItems(
            imageUrl: AppImages.services,
            title: "Services",
          ),
          XNavBarItems(
            onTap: () {
            
            },
            imageUrl: AppImages.profileIcon,
            title: "Profile",
          ),
        ],
      ),
    );
  }
}
