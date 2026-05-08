

import 'dart:core';

import 'package:flutter/cupertino.dart';

import '../../../../../screens/common_widgets/image_provider.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_textstyle.dart';
import '../../../../utils/client_images.dart';

class AssignTaskHeader extends StatefulWidget {
  final String title;
   final String subTitle;
  final String image;

  const AssignTaskHeader({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.image,
  }) : super(key: key);

  @override
  State<AssignTaskHeader> createState() =>
      _AssignTaskHeaderState();
}

class _AssignTaskHeaderState extends State<AssignTaskHeader> {
  @override
  Widget build(BuildContext context) {
     String title = widget.title;
     String subTitle = widget.subTitle;
     String image = widget.image;
    return Column(
      children: [
        const SizedBox(
          height: 9,
        ),
        Center(
          child: CustomImageProvider(
            image: ClientImages.line,
            width: 70,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageProvider(
              image: image,
              width: 24,
              height: 24,
            ),
            const SizedBox(
              width: 6,
            ),
            Text(
              semanticsLabel: title,
              title,
              style: AppTextStyle.font18bold,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              semanticsLabel: subTitle,
              subTitle,
              style: AppTextStyle.font18bold
                  .copyWith(color: AppColors.backgroundColor),
            ),
          ],
        ),
      ],
    );
  }

}