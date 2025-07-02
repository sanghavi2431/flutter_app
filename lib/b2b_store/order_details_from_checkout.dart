import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:woloo_smart_hygiene/b2b_store/address_change_bottomsheet.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_bloc.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_state.dart';
import 'package:woloo_smart_hygiene/b2b_store/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/ecom.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/order_details.dart';
import 'package:woloo_smart_hygiene/b2b_store/order_details.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/dashboard.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:woloo_smart_hygiene/utils///logger.dart';

class OrderScreenCheckout extends StatefulWidget {
  OrderSet orderSet;
  OrderScreenCheckout({super.key, required this.orderSet});

  @override
  State<OrderScreenCheckout> createState() => _OrderScreenCheckoutState();
}

class _OrderScreenCheckoutState extends State<OrderScreenCheckout> {
  final B2bStoreBloc _b2bStoreBloc = B2bStoreBloc();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final timeLineList = [
      "Order Placed",
      "Order Accepted",
      "Order Shipped",
      "Order Delevered"
    ];
    return BlocConsumer<B2bStoreBloc, B2BStoreState>(
        bloc: _b2bStoreBloc,
        listener: (context, state) {
          if (state is OrderDetailsLoading) {
            EasyLoading.show(status: state.message);
          }
          if (state is OrderDetailsSuccess) {
            EasyLoading.dismiss();
          }
          if (state is OrderDetailsError) {
            EasyLoading.dismiss();
            EasyLoading.showError(state.error);
          }
          if (state is ReviewSuccess) {
            EasyLoading.dismiss();
            EasyLoading.showSuccess(state.message);
          }
        },
        builder: (context, snapshot) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => ClientDashboard(
                          dashIndex: 0,
                        )),
                (route) => false,
              );
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leadingWidth: 100,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ClientDashboard(
                                dashIndex: 0,
                              )),
                      (route) => false,
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.textgreyColor,
                        size: 16,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Back",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textgreyColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8.h,
                  children: [
                    CartHeader(
                        imgPath: AppImages.list,
                        title: "Order Details ",
                        subtitle:
                            "Check or modify the details of your order here"),
                    Text("Order ID: ${widget.orderSet.id}",
                        style: AppTextStyle.font12bold),
                    Expanded(
                      child: ListView.builder(
                          itemCount:
                              widget.orderSet.orders?.first.items?.length,
                          itemBuilder: (c, i) {
                            final order = widget.orderSet.orders?.first;

                            final item = order?.items?[i];
                            final orderShipmentAddress = order
                                ?.paymentCollections
                                ?.first
                                .payments
                                ?.first
                                .data
                                ?.notes
                                ?.customer
                                ?.addresses
                                ?.first;
                            return OrderStatusCard(
                              orderShipmentAddress: orderShipmentAddress,
                              id: item?.id ?? "",
                              timeLineList: timeLineList,
                              url: item?.thumbnail ?? "",
                              productLabel: item?.title ?? "",
                              subTitle: item?.subtitle ?? "",
                              price: (item?.total ?? 0).toStringAsFixed(2),
                              paymentStatus: order?.paymentStatus ?? '',
                              fulfillmentStatus: order?.fulfillmentStatus ?? '',
                            );
                          }),
                    ),
                    if (false) ...[
                      const Text("Other items in the order"),
                      const Divider(),
                      const OtherItemOrder(),
                      LongLabeledButton(
                        onTap: () {},
                        label: "Help & Support",
                        color: AppColors.greyColorFields,
                      ),
                    ]
                  ],
                ),
              ),
            ),
          );
        });
  }
}

// class OrderStatusCard extends StatelessWidget {
//   const OrderStatusCard(
//       {super.key,
//       required this.timeLineList,
//       required this.url,
//       required this.productLabel,
//       required this.subTitle,
//       required this.price,
//       required this.id,
//       required this.orderShipmentAddress});
//   final Address? orderShipmentAddress;
//   final List<String> timeLineList;
//   final String id;
//   final String url;
//   final String productLabel;
//   final String subTitle;
//   final String price;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(12.w),
//       margin: EdgeInsets.symmetric(vertical: 8.h),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 5,
//             spreadRadius: 1,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Order ID: $id", style: AppTextStyle.font12bold),
//           SizedBox(height: 8.h),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12.r),
//                 child: url.isEmpty
//                     ? Image.asset(
//                         AppImages.appLogo,
//                         height: 60.h,
//                         width: 60.w,
//                         fit: BoxFit.cover,
//                       )
//                     : CachedNetworkImage(
//                         imageUrl: url,
//                         height: 60.h,
//                         width: 60.w,
//                         fit: BoxFit.cover,
//                       ),
//               ),
//               SizedBox(width: 12.w),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       productLabel,
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 4.h),
//                     Text(
//                       subTitle,
//                       style: TextStyle(
//                         fontSize: 12.sp,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     SizedBox(height: 8.h),
//                     Text(
//                       "\u{20B9} $price",
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 12.h),
//           SizedBox(
//             height: 80.h,
//             child: Timeline.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemBuilder: (c, i) {
//                   return TimelineTile(
//                     nodePosition: 0,
//                     contents: SizedBox(
//                       width: 150,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             timeLineList[i],
//                             textAlign: TextAlign.center,
//                           ),
//                           const Text("~time ")
//                         ],
//                       ),
//                     ),
//                     mainAxisExtent: 80,
//                     node: TimelineNode(
//                       startConnector: i != 0
//                           ? const SolidLineConnector(
//                               color: AppColors.lightCyanColor,
//                             )
//                           : null,
//                       endConnector: i + 1 < (timeLineList.length)
//                           ? const SolidLineConnector(
//                               color: AppColors.lightCyanColor,
//                             )
//                           : null,
//                       indicator: DotIndicator(
//                         size: 23.h,
//                         color: i == 0 ? AppColors.greenBold : AppColors.orange,
//                         child: i == 0
//                             ? const Icon(
//                                 Icons.check,
//                                 size: 12,
//                               )
//                             : null,
//                       ),
//                     ),
//                   );
//                 },
//                 itemCount: timeLineList.length),
//           ),
//           SizedBox(height: 12.h),
//           Container(
//               padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
//               child: Text(
//                   "User: ${orderShipmentAddress?.firstName ?? ''} ${orderShipmentAddress?.lastName ?? ''}")),
//           Container(
//               padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
//               child:
//                   Text("Address Type: ${orderShipmentAddress?.addressName}")),
//           Container(
//               padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
//               child: Text("Address: ${orderShipmentAddress?.address1}")),
//         ],
//       ),
//     );
//   }
// }

class ReviewBottomSheet extends StatefulWidget {
  final Function(String) onSubmit;
  final String title;
  final String hintText;
  final String submitButtonText;

  const ReviewBottomSheet({
    super.key,
    required this.onSubmit,
    this.title = 'Write a Review',
    this.hintText = 'Type Your Review Here!',
    this.submitButtonText = 'Submit',
  });

  @override
  State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();

  static Future<String?> show(
    BuildContext context, {
    required Function(String) onSubmit,
    String title = 'Write a Review',
    String hintText = 'Type Your Review Here!',
    String submitButtonText = 'Submit',
  }) {
    //logger.w("Executing***");
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReviewBottomSheet(
        onSubmit: onSubmit,
        title: title,
        hintText: hintText,
        submitButtonText: submitButtonText,
      ),
    );
  }
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final availableHeight = MediaQuery.of(context).size.height * 0.45;

    return Container(
      height: availableHeight,
      margin: EdgeInsets.only(bottom: keyboardSpace),
      decoration: const BoxDecoration(
        color: Color(0xFFD3D3D3),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const XBottmSheetTopDecor(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const EcomScreen()),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _reviewController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                if (_reviewController.text.isNotEmpty) {
                  widget.onSubmit(_reviewController.text);
                  Navigator.pop(context, _reviewController.text);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF87CEEB),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                widget.submitButtonText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewExample extends StatelessWidget {
  const ReviewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ReviewBottomSheet.show(
              context,
              onSubmit: (review) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Review submitted: $review')),
                );
              },
            );
          },
          child: const Text('Write A Review'),
        ),
      ),
    );
  }
}

class OtherItemOrder extends StatelessWidget {
  const OtherItemOrder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return XDecoratedBox(
        child: Row(
      spacing: 10,
      children: [
        SizedBox(
          height: 60,
          width: 64,
          child: Image.asset(AppImages.pest),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Natural Deodrant Roll On",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "default variant",
              style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.greyBorderProfile),
            ),
            Text(
              "\u{20B9} 299/-",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      ],
    ));
  }
}

class RateExperienceCard extends StatelessWidget {
  final VoidCallback onWriteReviewPressed;
  final String title;
  final String subtitle;
  final String buttonText;
  final Color backgroundColor;
  final Color textColor;
  final Color buttonBackgroundColor;
  final Color buttonTextColor;

  const RateExperienceCard({
    super.key,
    required this.onWriteReviewPressed,
    this.title = 'Rate Your Experience',
    this.subtitle = 'Your rating help us improve our service',
    this.buttonText = 'Write A Review',
    this.backgroundColor = const Color(0xFF87CEEB),
    this.textColor = Colors.white,
    this.buttonBackgroundColor = Colors.white,
    this.buttonTextColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16.0),
          ElevatedButton(
            onPressed: onWriteReviewPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonBackgroundColor,
              foregroundColor: buttonTextColor,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
                color: buttonTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
