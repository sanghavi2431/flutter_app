import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/b2b_store/product_details.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';

import '../../b2b_store/models/cart.dart';
import '../../utils/app_color.dart';

class CartItemCard extends StatelessWidget {
  final Item? item;
  final bool isSelected;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;
  final VoidCallback onDelete;
  final bool isFromCartSummery;

  const CartItemCard(
      {super.key,
      this.item,
      this.isSelected = true,
      this.onAdd,
      this.onRemove,
      required this.onDelete,
      required this.isFromCartSummery});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowGrey,
            blurRadius: 4,
            offset: Offset(0, 1),
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
              height: 76.h,
              width: 76.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 8.w),
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
                          fontFamily: 'CenturyGothic',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSelected)
                      Visibility(
                        visible: false, // Set to false to hide it
                        child: GestureDetector(
                          onTap: onDelete,
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset(AppImages.deleteLogo),
                          ),
                        ),
                      ),
                  ],
                ),
                // SizedBox(height: 4.h),
                  Row(
              children: [
                Text(
                  "${item?.variantTitle}" ?? "",
                  style: TextStyle(
                    fontFamily: 'CenturyGothic',
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
              Text(
                "${item?.quantity}" ?? "",
                style: TextStyle(
                  fontFamily: 'CenturyGothic',
                  fontSize: 12.sp,
                  color: Colors.black,
                ),
              ),
            ]
            ),
                SizedBox(height: 8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "\u{20B9}${item?.unitPrice}/-",
                      style: TextStyle(
                        fontFamily: 'CenturyGothic',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    if (item?.compareAtUnitPrice != null)
                      Text(
                        "${item!.compareAtUnitPrice}/-",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'CenturyGothic',
                          fontWeight: FontWeight.bold,
                          fontSize: 9.sp,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.grey,
                          decorationThickness: 2,
                        ),
                      ),
                    Spacer(),
                    if (isSelected)
                      if (!isFromCartSummery)
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
