import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_color.dart';

class HygieneScoreCard extends StatelessWidget {
  final String imageUrl;

  const HygieneScoreCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
        label: "hygiene score",
        value: "header",
        child:
        Text(
          "Hygiene Score",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.appBarTitleColor,
          ),
        ),
        ),
        const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 16),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2), // Shadow color
            spreadRadius: 1, // How wide the shadow should spread
            blurRadius: 10, // The blur effect of the shadow
            offset: const Offset(0, 0), // No offset for shadow on all sides
          ),
        ], color: AppColors.white, borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
        Semantics(
        label: "hygiene score",
        value: "image",
        child:
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
          Positioned(
            bottom: 90,
            left: 0,
            right: 0,
            child: Center(
              child:
              Semantics(
                label: "hygiene score",
                value: "score 699",
                child:
                const Text(
                "699",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ),
            ),
          )
        ],
      ),
    )]);
  }
}