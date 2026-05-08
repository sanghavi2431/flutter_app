import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../screens/common_widgets/image_provider.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_textstyle.dart';
import '../../../../utils/client_images.dart';

class AssignTaskGenderCard extends StatefulWidget {
  final String image;
  final String title;
  final int index;
  final int selectedGender;


  const AssignTaskGenderCard({
    Key? key,
    required this.image,
    required this.title,
    required this.index,
    required this.selectedGender,


  }) : super(key: key);

  @override
  State<AssignTaskGenderCard> createState() =>
      _AssignTaskGenderCardState();
}

class _AssignTaskGenderCardState extends State<AssignTaskGenderCard> {
  @override
  Widget build(BuildContext context) {
    String title = widget.title;
    int index = widget.index;
    String image = widget.image;
    int selectedGender = widget.selectedGender;

    return Stack(
      children: [
        Container(
            width: 151,
            height: 151,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    spreadRadius: 1, // Spread effect
                    blurRadius: 10, // Blur effect
                    offset: const Offset(0, 5), // Bottom shadow
                  ),
                ],
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: selectedGender == index
                        ? AppColors.backgroundColor
                        : AppColors.white)),
            child: Column(
              //  mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                CustomImageProvider(
                  image: image,
                  width: 67,
                  height: 67,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  title,
                  style: AppTextStyle.font13.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.greyBorder),
                )
              ],
            )),
        selectedGender == index
            ? Positioned(
            bottom: index == 0 ? 10 : 10,
            right: index == 0 ? 0 : 0,
            // left: 100,
            child: CustomImageProvider(
              image: ClientImages.check,
              width: 29,
              height: 29,
            ))
            : const SizedBox()
      ],
    );
  }
}