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
import 'package:woloo_smart_hygiene/b2b_store/models/order_details.dart';
import 'package:woloo_smart_hygiene/b2b_store/product_details.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:woloo_smart_hygiene/utils///logger.dart';

class OrderScreen extends StatefulWidget {
  OrderSet orderSet;
  OrderScreen({super.key, required this.orderSet});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final B2bStoreBloc _b2bStoreBloc = B2bStoreBloc();
  // OrderSet? orderDetailsData = widget.orderSet;
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
            // setState(() {
            //   orderDetailsData = state.orderDetailsData;
            //   isLoading = false;
            //   print(state.orderDetailsData.orderSets);
            // });
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
          return Scaffold(
            appBar: const BackAppBar(),
            // bottomNavigationBar: const XBottomBar(),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.h,
                children: [
                  CartHeader(
                      imgPath: AppImages.list,
                      title: "Order Details",
                      subtitle:
                          "Check or modify the details of your order here"),
                  // Text("Order ID: ${widget.orderSet.id}",
                  //     style: AppTextStyle.font12bold),
                  Expanded(
                    child: ListView.builder(
                        itemCount: widget.orderSet.orders?.first.items?.length,
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
                            price: (item?.total ?? 0).toString(),
                            paymentStatus: order?.paymentStatus ?? '',
                            fulfillmentStatus: order?.fulfillmentStatus ?? '',
                          );
                        }),
                  ),
                  // const Spacer()
                  // const Text("Other items in the order"),
                  // const Divider(),
                  // const OtherItemOrder(), // Place Other Item If necessary place a list

                  // LongLabeledButton(
                  //   onTap: () {},
                  //   label: "Help & Support",
                  //   color: AppColors.greyColorFields,
                  // ),
                ],
              ),
            ),
          );
        });
  }
}

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

  /// Shows the review bottom sheet
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
    // Get available height for the bottom sheet
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final availableHeight = MediaQuery.of(context).size.height * 0.45;

    return Container(
      height: availableHeight,
      margin: EdgeInsets.only(bottom: keyboardSpace),
      decoration: const BoxDecoration(
        color: Color(0xFFD3D3D3), // Light gray background color
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag indicator
          const XBottmSheetTopDecor(),

          // Title bar with back button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
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
          // XDecoratedBox(child: StarRa),
          // Review input area
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
                    maxLines: null, // Allows unlimited lines
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

          // Submit button
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
                backgroundColor: const Color(0xFF87CEEB), // Light blue
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

// Example usage:
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
                // Handle the submitted review
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
          child: Image.asset(AppImages.pest), // Replace With Product Image
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Natural Deodrant Roll On", // Replace with real product label
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "default variant", // Replace with real sub title
              style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.greyBorderProfile),
            ),
            Text(
              "\u{20B9} 299/-", // Replace with real price
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

class OrderStatusCard extends StatelessWidget {
  const OrderStatusCard({
    super.key,
    required this.timeLineList,
    required this.url,
    required this.productLabel,
    required this.subTitle,
    required this.price,
    required this.id,
    required this.orderShipmentAddress,
    required this.paymentStatus,
    required this.fulfillmentStatus,
  });
  final Address? orderShipmentAddress;
  final List<String> timeLineList;
  final String id;
  final String url;
  final String productLabel;
  final String subTitle;
  final String price;
  final String paymentStatus;
  final String fulfillmentStatus;

  Color _getDotColor(int index) {
    // Kotlin logic mapping
    final pay = paymentStatus.toLowerCase();
    final fulfill = fulfillmentStatus.toLowerCase();
    if (pay == 'captured' && fulfill == 'not_fulfilled') {
      if (index == 0 || index == 1) return AppColors.greenBold;
      return AppColors.orange;
    } else if (pay == 'captured' && fulfill == 'shipped') {
      if (index == 0 || index == 1 || index == 2) return AppColors.greenBold;
      return AppColors.orange;
    } else if (pay == 'captured' && fulfill == 'delivered') {
      return AppColors.greenBold;
    }
    // Default: only first dot green
    return index == 0 ? AppColors.greenBold : AppColors.orange;
  }

  Color _getConnectorColor(int index) {
    // Kotlin logic mapping
    final pay = paymentStatus.toLowerCase();
    final fulfill = fulfillmentStatus.toLowerCase();
    if (pay == 'captured' && fulfill == 'not_fulfilled') {
      if (index == 0) return AppColors.greenBold;
      return AppColors.lightCyanColor;
    } else if (pay == 'captured' && fulfill == 'shipped') {
      if (index == 0 || index == 1) return AppColors.greenBold;
      return AppColors.lightCyanColor;
    } else if (pay == 'captured' && fulfill == 'delivered') {
      return AppColors.greenBold;
    }
    // Default: only first connector green
    return index == 0 ? AppColors.greenBold : AppColors.lightCyanColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text("Order ID: $id", style: AppTextStyle.font12bold),
          SizedBox(height: 8.h),
          // Product Details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: url.isEmpty
                    ? Image.asset(
                        AppImages.appLogo,
                        height: 60.h,
                        width: 60.w,
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: url, // Replace with your product image
                        height: 60.h,
                        width: 60.w,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(width: 12.w),
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productLabel,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subTitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "\u{20B9} $price",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 80.h,
            child: Timeline.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (c, i) {
                  return TimelineTile(
                    nodePosition: 0,
                    contents: SizedBox(
                      width: 150,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            timeLineList[i],
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    mainAxisExtent: 80,
                    node: TimelineNode(
                      startConnector: i != 0
                          ? SolidLineConnector(
                              color: _getConnectorColor(i),
                            )
                          : null,
                      endConnector: i + 1 < (timeLineList.length)
                          ? SolidLineConnector(
                              color: _getConnectorColor(i),
                            )
                          : null,
                      indicator: DotIndicator(
                        size: 23.h,
                        color: _getDotColor(i),
                        child: _getDotColor(i) == AppColors.greenBold
                            ? const Icon(
                                Icons.check,
                                size: 12,
                              )
                            : null,
                      ),
                    ),
                  );
                },
                itemCount: timeLineList.length),
          ),

          SizedBox(height: 12.h),
          // Cancel Button
          // Center(
          //   child: GestureDetector(
          //     onTap: () {
          //       // Handle cancel action
          //     },
          //     child: Container(
          //         padding:
          //             EdgeInsets.symmetric(horizontal: 50.w, vertical: 8.h),
          //         // decoration: BoxDecoration(
          //         //   color: Colors.grey[300],
          //         //   borderRadius: BorderRadius.circular(8.r),
          //         // ),
          //         child: Text("${orderShipmentAddress?.address1}")
          //         // Text(
          //         //   "Cancel",
          //         //   style: TextStyle(
          //         //     fontSize: 14.sp,
          //         //     fontWeight: FontWeight.bold,
          //         //     color: Colors.black,
          //         //   ),
          //         // ),
          //         ),
          //   ),
          // ),
        ],
      ),
    );
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

// // Example usage:
// class ExampleUsage extends StatelessWidget {
//   const ExampleUsage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: RateExperienceCard(
//             onWriteReviewPressed: () {
//               // Navigate to review form or show review dialog
//               print('Write review pressed');
//               // Example: Navigator.push(context, MaterialPageRoute(builder: (_) => ReviewPage()));
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
