

import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../screens/common_widgets/image_provider.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_textstyle.dart';
import '../../../../utils/client_images.dart';

class AssignTaskCard extends StatefulWidget {
  final String image;
  final String title;
  final int index;
  final int selectedIndex;
  final TextEditingController typeController;


  const AssignTaskCard({
    Key? key,
    required this.image,
    required this.title,
    required this.index,
    required this.selectedIndex,
    required this.typeController,
  }) : super(key: key);

  @override
  State<AssignTaskCard> createState() =>
      _AssignTaskCardState();
}

class _AssignTaskCardState extends State<AssignTaskCard> {
  @override
  Widget build(BuildContext context) {
    String title = widget.title;
    int index = widget.index;
    String image = widget.image;
    int selectedIndex = widget.selectedIndex;
    TextEditingController typeController = widget.typeController;

    return Stack(
        alignment: Alignment.bottomRight,
        children: [
        AspectRatio(
        aspectRatio: 1,
        child: Container(
              width: double.infinity,
              decoration: BoxDecoration(

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4), // Shadow color
                      spreadRadius: 1, // Spread effect
                      blurRadius: 4, // Blur effect
                      offset: const Offset(0, 4), // Bottom shadow
                    ),
                  ],
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: selectedIndex == index
                          ? AppColors.backgroundColor
                          : AppColors.white)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  CustomImageProvider(
                    image: image,
                    width: double.infinity / 2,
                    height: 43,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      title,
                      style: AppTextStyle.font13.copyWith(
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.greyBorder),
                    ),
                  ),
                  title == "Others"
                      ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      typeController.text,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.font10
                          .copyWith(fontSize: 11)
                          .copyWith(color: AppColors.greyBorder),
                    ),
                  )
                      : SizedBox()
                ],
              )),),
          selectedIndex == index
              ? CustomImageProvider(
            image: ClientImages.check,
            width: 25,
            height: 25,
          )
              : const SizedBox()
        ],
    );
  }
}