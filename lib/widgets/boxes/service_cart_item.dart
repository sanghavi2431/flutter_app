import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/b2b_store/product_details.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';

class ServiceItemCard extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;
  final VoidCallback onDelete;
  final String date, time, selectedBHKValue;
  const ServiceItemCard(
      {super.key,
      this.isSelected = true,
      this.onAdd,
      this.onRemove,
      required this.onDelete,
      required this.date,
      required this.time,
      required this.selectedBHKValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            // child: CachedNetworkImage(
            //   imageUrl:
            //       item?.thumbnail ?? "", // Replace with your product image
            //   height: 60.h,
            //   width: 60.w,
            //   fit: BoxFit.cover,
            // ),
            child: Image.asset(
              AppImages.pest,
              height: 60.h,
              width: 60.w,
            ),
          ),
          SizedBox(width: 12.w),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "Pest Control",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSelected)
                      GestureDetector(
                        onTap: onDelete,
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset(AppImages.deleteLogo),
                        ),
                      ),
                  ],
                ),
                // SizedBox(height: 4.h),
                Row(
                  spacing: 10,
                  children: [
                    Text(
                      "Date :$date",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "Time :$time",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 8.h),
                Text(
                  "Home Area : $selectedBHKValue",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Rs. 900",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    if (isSelected)
                      CartAddRemove(
                        onAdd: onAdd,
                        onRemove: onRemove,
                        value: 2,
                      )
                  ],
                ),
              ],
            ),
          ),
          // Quantity and Delete Button
        ],
      ),
    );
  }
}
