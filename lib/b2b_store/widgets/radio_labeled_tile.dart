import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

class XRadioTile extends StatelessWidget {
  const XRadioTile({
    super.key,
    required this.isSelected,
    this.onTap,
    required this.title,
    required this.subTitle,
  });
  final bool isSelected;
  final VoidCallback? onTap;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        spacing: 10,
        children: [
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              shape: BoxShape.circle,
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      height: 14,
                      width: 14,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          shape: BoxShape.circle,
                          color: isSelected ? Colors.green : null),
                    ),
                  )
                : null,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTextStyle.font10bold,
              ),
              Text(
                subTitle,
                style: AppTextStyle.font10
                    .copyWith(fontSize: 8.sp, color: AppColors.greyBorder),
              )
            ],
          )
        ],
      ),
    );
  }
}
