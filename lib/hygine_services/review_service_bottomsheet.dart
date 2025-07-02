import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:woloo_smart_hygiene/b2b_store/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/address.dart';
import 'package:woloo_smart_hygiene/enums/payment_method.dart';
import 'package:woloo_smart_hygiene/hygine_services/bloc/hygiene_service_bloc.dart';
import 'package:woloo_smart_hygiene/hygine_services/bloc/hygiene_service_event.dart';
import 'package:woloo_smart_hygiene/hygine_services/bloc/hygiene_service_state.dart';
import 'package:woloo_smart_hygiene/hygine_services/order_summery_bottomsheet_hygine_service.dart';
import 'package:woloo_smart_hygiene/janitorial_services/screens/host_dashboard_screen.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:woloo_smart_hygiene/utils/logger.dart';
import 'package:woloo_smart_hygiene/b2b_store/address_change_bottomsheet.dart';
import 'package:woloo_smart_hygiene/widgets/service_summery_bottomsheet.dart';

class ReviewServiceBottomsheet extends StatefulWidget {
  const ReviewServiceBottomsheet({
    super.key,
    required this.date,
    required this.time,
    required this.selectedBHKValue,
    required this.productId,
  });
  final String date, time, selectedBHKValue, productId;

  @override
  State<ReviewServiceBottomsheet> createState() =>
      _ReviewServiceBottomsheetState();
}

class _ReviewServiceBottomsheetState extends State<ReviewServiceBottomsheet> {
  Addresses? address;
  final box = GetStorage();
  PaymentMethod? paymentMethod;

  HygieneServiceBloc _hygieneServiceBloc = HygieneServiceBloc();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    address = getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HygieneServiceBloc, HygieneServiceState>(
        bloc: _hygieneServiceBloc,
        listener: (context, state) {
          // print("dssa $state");
          if (state is HygieneCartLoading) {
            EasyLoading.show(status: state.message);
          }
          if (state is ReadyToShip) {
            logger.w(state);

            EasyLoading.dismiss();
            // Navigator.pop(context);
            showModalBottomSheet(
              isScrollControlled: true,
              isDismissible: true, // <-- Allow tap outside to dismiss
              enableDrag: true, // <-- Allow swipe down to dismiss

              backgroundColor: Colors
                  .transparent, // Optional: if you want rounded corners to show correctly

              context: context,
              builder: (_) => HygineServicesOrderSummeryBottomSheet(
                  // date: widget.date,
                  // time: widget.time,
                  // selectedBHKValue: widget.selectedBHKValue,
                  ), //AddressBottomSheet
            );
          }

          if (state is HygieneCartError) {
            EasyLoading.dismiss();
            EasyLoading.showError(state.error);
          }
        },
        builder: (context, snapshot) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(40.r))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                const XBottmSheetTopDecor(),
                const SizedBox(
                  height: 20,
                ),
                CartHeader(
                    imgPath: AppImages.checkout,
                    title: "Checkout",
                    subtitle: "Please choose your address and mode of payment"),
                const Divider(
                  color: Colors.white,
                ),
                Expanded(
                    child: ListView(
                  children: [
                    XDecoratedBox(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        children: [
                          Text(
                            "Address",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14.sp),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "Home",
                            style: AppTextStyle.font14bold,
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.pop(context);
                              showModalBottomSheet(
                                isScrollControlled: true,
                                isDismissible:
                                    true, // <-- Allow tap outside to dismiss
                                enableDrag:
                                    true, // <-- Allow swipe down to dismiss

                                backgroundColor: Colors
                                    .transparent, // Optional: if you want rounded corners to show correctly

                                context: context,
                                builder: (_) =>
                                    const AddressChangeBottomSheet(), //AddressBottomSheet
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  address?.address1 ?? "",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      shape: BoxShape.circle),
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                    XDecoratedBox(
                      child: Column(
                        spacing: 10,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Payment Method",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14.sp),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          XPaymentTile(
                            paymentMethod: "UPI App",
                            imgPath: AppImages.upiIcon,
                            onSelected: paymentMethod == PaymentMethod.upi,
                            onTap: () {
                              setState(() {
                                paymentMethod = PaymentMethod.upi;
                              });
                            },
                          ),
                          XPaymentTile(
                              paymentMethod: "Credit/Debit Card",
                              imgPath: AppImages.creditCard,
                              onSelected: paymentMethod == PaymentMethod.card,
                              onTap: () {
                                setState(() {
                                  paymentMethod = PaymentMethod.card;
                                });
                              }),
                          XPaymentTile(
                              paymentMethod: "Net Banking",
                              imgPath: AppImages.netbanking,
                              onSelected:
                                  paymentMethod == PaymentMethod.netBanking,
                              onTap: () {
                                setState(() {
                                  paymentMethod = PaymentMethod.netBanking;
                                });
                              }),
                        ],
                      ),
                    ),
                  ],
                )),
                const Divider(
                  color: Colors.white,
                ),
                LongLabeledButton(
                  label: "Review Order",
                  onTap: () {
                    _hygieneServiceBloc.add(const ProceedToShip());
                    // _proceedToSheep()
                  },
                )
              ],
            ),
          );
        });
  }

  Addresses? getAddress() {
    address = Addresses.fromJson(jsonDecode(box.read("address")));
    // setState(() {});
    return address;
  }
}
