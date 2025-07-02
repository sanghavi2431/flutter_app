import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/b2b_store/product_details.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';

import '../../b2b_store/models/cart.dart';

class CartItemCard extends StatelessWidget {
  final Item? item;
  final bool isSelected;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;
  final VoidCallback onDelete;

  const CartItemCard(
      {super.key,
      this.item,
      this.isSelected = true,
      this.onAdd,
      this.onRemove,
      required this.onDelete});

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
            child: CachedNetworkImage(
              imageUrl:
                  item?.thumbnail ?? "", // Replace with your product image
              height: 60.h,
              width: 60.w,
              fit: BoxFit.cover,
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
                        item?.productTitle ?? "",
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
                Text(
                  "${item?.variantTitle}" ?? "",
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
                      "\u{20B9}${item?.unitPrice}/-",
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
                        value: item?.quantity ?? 0,
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
