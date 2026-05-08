import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../client_flow/screens/dashbaord/view/widget/review_expanded_section.dart';
import 'get_hosts_all_revies.dart';
import '../utils/app_color.dart';
import '../utils/app_textstyle.dart';

class WahScore extends StatelessWidget {
  final String imgUrl;
  final String score;
  final List<ReviewAllHost> reviewsHost;
  const WahScore({
    required this.imgUrl,
    required this.score,
    required this.reviewsHost,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
              color: AppColors.textgreyColor,
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ]),
      child: Column(
        children: [
          //TODO:add score on image
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                "Wah score and reviews",
                style: AppTextStyle.font14bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                imgUrl,
                height: 220.h,
                width: 220.h,
              ),
              Positioned(
                bottom: 55.h,
                child: Text( " ${score.split("-").last}",
                    style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.boldTextColor)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.yellowSplashColor),
          const SizedBox(height: 16),
          ReviewsExpandableSection(
              reviews: reviewsHost
          ),


        ],
      ),
    );
  }
}