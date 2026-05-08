import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/b2b_store/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/ecom.dart';
import 'package:woloo_smart_hygiene/b2b_store/order_details_from_checkout.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/dashboard.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';

class OrderSuccessfulDialog extends StatelessWidget {
  const OrderSuccessfulDialog({
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
                  child: Image.asset(AppImages.verify),
                ),
                Text(
                  "Your Order has been placed Successfully",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                LongLabeledButton(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (c) => ClientDashboard(
                                  dashIndex: 0,
                                )),
                        (route) => false,
                      );
                    },
                    label: "Check Order Details")
              ],
            )),
      ),
    );
  }
}
