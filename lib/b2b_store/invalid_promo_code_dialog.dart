import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/b2b_store/cart.dart';

import '../../utils/app_images.dart';
// import '../cart.dart';

class InvalidPromoCodeDialog extends StatelessWidget {
  const InvalidPromoCodeDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        // width: MediaQuery.sizeOf(context).width * 0.5,
        child: XDecoratedBox(
            padding: 20,
            radius: 25,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: Image.asset(AppImages.removeIcons),
                ),
                Text(
                  "Your entered promocode is not valid",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                LongLabeledButton(
                    onTap: () {
                      Navigator.of(context).pop();
                      // Navigator.pushAndRemoveUntil(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (c) => ClientDashboard(
                      //         dashIndex: 0,
                      //       )),
                      //       (route) => false,
                      // );
                    },
                    label: "Go To Cart")
              ],
            )),
      ),
    );
  }
}
