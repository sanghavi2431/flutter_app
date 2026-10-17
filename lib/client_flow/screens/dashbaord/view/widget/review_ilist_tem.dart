import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../host/get_hosts_all_revies.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_images.dart';
import '../../../../../utils/app_textstyle.dart';

class ReviewItem extends StatelessWidget {
  final ReviewAllHost reviewText;

  const ReviewItem({super.key, required this.reviewText});

  @override
  Widget build(BuildContext context) {
    final String description =
        reviewText.reviewDescription?.trim() ?? '';
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: AppColors.textgreyColor,
              blurRadius: 4,
              offset: Offset(0, 0),
            ),
          ]
      ),
      child: Column(
        children: [
          Row(
            children: [
      ClipOval(
      child: Image.network(
        "${reviewText.userDetails.baseUrl}${reviewText.userDetails.avatar}"!,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _defaultAvatar(); // URL invalid / image fail
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _defaultAvatar(); // show default while loading
        },
      ),
      ),
              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text( reviewText.userDetails.name ?? "Anonymous",
                        style: AppTextStyle.font14bold),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        height: 1,
                        color: AppColors.dividerColor),
                     Text( reviewText.userDetails.wolooSince != null
                         ? "Member since ${DateFormat('dd MMM yyyy')
                         .format(DateTime.parse(reviewText.userDetails.wolooSince.toString()))
                         .toUpperCase()}"
                         : "",
                       style: AppTextStyle.font8,),
                  ],
                ),
              ),

              Row(
                children: [
                  Image.asset(AppImages.hostReviewStar,
                      width: 20,
                      height: 20,
                      ),
                  const SizedBox(width: 3),
                  Text(reviewText.rating.toString(),
                      style: AppTextStyle.font14bold),
                ],
              )
            ],
          ),

          const SizedBox(height: 8),
          Divider(
            color: AppColors.dividerColor,
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 8),
    Align(
    alignment: Alignment.centerLeft,
    child:
    Text(
      description.isEmpty ? "No statement added" : description,
      style: AppTextStyle.font10bold,
    )
      ,
    ),
        ],
      ),
    );
  }


  Widget _defaultAvatar() {
    return ClipOval(
      child: Container(
        width: 40,
        height: 40,
        color: Colors.grey[300],
        child: const Icon(Icons.person, size: 18),
      ),
    );
  }
}
