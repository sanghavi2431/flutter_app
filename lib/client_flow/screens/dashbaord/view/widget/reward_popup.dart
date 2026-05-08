import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';

import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_images.dart';
import '../../../../widgets/CustomButton.dart';

class RewarPopup extends StatefulWidget {
  const RewarPopup({super.key});

  @override
  State<RewarPopup> createState() => _RewarPopupState();
}

class _RewarPopupState extends State<RewarPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(10),
      alignment: Alignment.bottomCenter,
      backgroundColor: Colors.white,
      // contentPadding: EdgeInsets.all(),
      // height: 200,
      // child:
      content: Container(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                CustomImageProvider(
                  image: AppImages.rewardIcon,
                  width: 70,
                  height: 70,
                ),
                const SizedBox(
                  width: 10,
                ),
                //  const Expanded(
                //    child: Text(
                //      overflow: TextOverflow.visible,
                //      maxLines: 3,
                //       "Great job! All tasks done. You’ve earned 100 Woloo Points!"
                //      ),
                //  )
                const Expanded(
                  child: Text.rich(
                    maxLines: 3,
                    overflow: TextOverflow.visible,
                    TextSpan(
                      children: [
                        TextSpan(
                            text: 'Great job! All tasks done. You’ve earned '),
                        TextSpan(
                          text: '100 Woloo Points',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // TextSpan(text: ' world!'),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Custombutton(
                color: AppColors.backgroundColor,
                text: "Go Back",
                width: 200.h),
          ],
        ),
      ),
    );
  }
}
