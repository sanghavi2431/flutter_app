import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class XNavBarItems extends StatelessWidget {
  const XNavBarItems({
    super.key,
    required this.imageUrl,
    required this.title,
    this.onTap,
  });
  final String imageUrl;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 23.h,
            width: 23.h,
            child: Image.asset(
              imageUrl,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 10.5.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
