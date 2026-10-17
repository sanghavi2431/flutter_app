import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../screens/common_widgets/image_provider.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_textstyle.dart';
import '../../../../utils/client_images.dart';

class AssignTaskAdminCard extends StatefulWidget {
  final String image;
  final String title;
  final int index;
  final int selectedAdmin;

  const AssignTaskAdminCard({
    Key? key,
    required this.image,
    required this.title,
    required this.index,
    required this.selectedAdmin,

  }) : super(key: key);

  @override
  State<AssignTaskAdminCard> createState() =>
      _AssignTaskAdminCardState();
}

class _AssignTaskAdminCardState extends State<AssignTaskAdminCard> {
  @override
  Widget build(BuildContext context) {
    String title = widget.title;
    int index = widget.index;
    String image = widget.image;
    int selectedAdmin = widget.selectedAdmin;

    return Padding(
      padding: const EdgeInsets.only(bottom: 38),
      child: Stack(
        children: [
          Container(
            //  width: 120,
            //  height: 151,
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Shadow color
                      spreadRadius: 1, // Spread effect
                      blurRadius: 10, // Blur effect
                      offset: const Offset(0, 5), // Bottom shadow
                    ),
                  ],
                  border: Border.all(
                      color: selectedAdmin == index
                          ? AppColors.backgroundColor
                          : AppColors.white)),
              child: Row(
                //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  CustomImageProvider(
                    image: image,
                    width: 106,
                    height: 106,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    title,
                    style: AppTextStyle.font32bold
                        .copyWith(fontSize: 30, color: AppColors.greyBorder),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              )),
          selectedAdmin == index
              ? Positioned(
              bottom: 0,
              right: 0,
              // left: 100,
              child: CustomImageProvider(
                image: ClientImages.check,
                width: 29,
                height: 29,
              ))
              : const SizedBox()
        ],
      ),
    );
  }
  }