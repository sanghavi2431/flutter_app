import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_bloc.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_event.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_state.dart';
import 'package:woloo_smart_hygiene/b2b_store/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/order_details.dart';
import 'package:woloo_smart_hygiene/b2b_store/order_details.dart';
import 'package:woloo_smart_hygiene/b2b_store/product_details.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

import '../utils/logger.dart';

class AllOrderScreen extends StatefulWidget {
  const AllOrderScreen({super.key});

  @override
  State<AllOrderScreen> createState() => _AllOrderScreenState();
}

class _AllOrderScreenState extends State<AllOrderScreen> {
  final B2bStoreBloc _b2bStoreBloc = B2bStoreBloc();
  OrderDetails? orderDetailsData;
  bool isLoading = true;
  @override
  void initState() {
    _b2bStoreBloc.add(const OrderDetailsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B2bStoreBloc, B2BStoreState>(
        bloc: _b2bStoreBloc,
        listener: (context, state) {
          if (state is OrderDetailsLoading) {
            EasyLoading.show(status: state.message);
          }
          if (state is OrderDetailsSuccess) {
            EasyLoading.dismiss();
            setState(() {
              orderDetailsData = state.orderDetailsData;
              isLoading = false;
              // print(state.orderDetailsData.orderSets.first);
            });
          }
          if (state is OrderDetailsError) {
            EasyLoading.dismiss();
            EasyLoading.showError(state.error);
          }
        },
        builder: (context, snapshot) {
          return !isLoading
              ? Scaffold(
                  appBar: const BackAppBar(),
                  body: Column(
                    children: [
                      CartHeader(
                          imgPath: AppImages.bag,
                          title: "Order",
                          subtitle: "check your recent order here"),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: orderDetailsData!.orderSets.isEmpty
                            ? Center(
                                child: Text(
                                "No orders found. Start shopping now!",
                                style: AppTextStyle.font14bold,
                              ))
                            : ListView.separated(
                                itemCount:
                                    orderDetailsData?.orderSets.length ?? 0,
                                itemBuilder: (c, i) {
                                  // final orderSet =
                                  //     orderDetailsData!.orderSets[i];
                                  // final orders = orderSet.orders;
                                  // final hasOrders =
                                  //     orders != null && orders.isNotEmpty;
                                  // final items =
                                  //     hasOrders && orders[i].items != null
                                  //         ? orders[0].items!
                                  //         : <Item>[];
                                  return XDecoratedBox(
                                    child: Column(
                                      spacing: 20,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
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
                                                  OrderSummaryBottomSheet(
                                                b2bStoreBloc: _b2bStoreBloc,
                                                orderSet: orderDetailsData!
                                                    .orderSets[i],
                                                orderId: orderDetailsData
                                                        ?.orderSets[i].id ??
                                                    "",
                                                customerName:
                                                    "${orderDetailsData?.orderSets[i].cart?.shippingAddress?.firstName ?? ""} " +
                                                        "${orderDetailsData?.orderSets[i].cart?.shippingAddress?.lastName ?? ""}",
                                                // "${orderDetailsData?.orderSets[i].orders?.first.fulfillments?.first.deliveryAddress?.firstName ?? ""} ${orderDetailsData?.orderSets[i].orders?.first.fulfillments?.first.deliveryAddress?.lastName ?? ""}",
                                                address:
                                                    "${orderDetailsData?.orderSets[i].cart?.shippingAddress?.address1}",
                                                orderDate: orderDetailsData
                                                        ?.orderSets[i]
                                                        .createdAt ??
                                                    DateTime.now(),
                                                deliveryDate: orderDetailsData
                                                        ?.orderSets[i]
                                                        .createdAt ??
                                                    DateTime.now(),
                                                status:
                                                    "${orderDetailsData?.orderSets[i].fulfillmentStatus}",
                                                productPrice:
                                                    "${orderDetailsData?.orderSets[i].itemTotal}",
                                                shippingCost:
                                                    "${orderDetailsData?.orderSets[i].shippingTotal}",
                                                grandTotal:
                                                    "${orderDetailsData?.orderSets[i].total}",
                                                discount:
                                                    "${orderDetailsData?.orderSets[i].discountTotal}",
                                              ), //AddressBottomSheet
                                            );
                                          },
                                          child: Text(
                                              orderDetailsData?.orderSets[i].id
                                                      ?.toString() ??
                                                  '',
                                              style: AppTextStyle.font14bold),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          spacing: 10,
                                          children: List.generate(
                                            orderDetailsData?.orderSets[i]
                                                    .orders?.length ??
                                                0,
                                            (j) {
                                              if (orderDetailsData
                                                          ?.orderSets[i] ==
                                                      null ||
                                                  orderDetailsData?.orderSets[i]
                                                          .orders ==
                                                      null ||
                                                  orderDetailsData!.orderSets[i]
                                                      .orders!.isEmpty) {
                                                return Container();
                                              }
                                              return OrderItemWithReview(
                                                orderSet: orderDetailsData!
                                                    .orderSets[i],
                                                orderDetails: orderDetailsData!
                                                                .orderSets[i]
                                                                .orders![j]
                                                                .items !=
                                                            null &&
                                                        orderDetailsData!
                                                            .orderSets[i]
                                                            .orders![j]
                                                            .items!
                                                            .isNotEmpty
                                                    ? orderDetailsData!
                                                        .orderSets[i]
                                                        .orders![j]
                                                        .items!
                                                        .first
                                                    : Item(),
                                                onChanged: (value) {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    builder: (c) {
                                                      return ReviewBottomSheet(
                                                        onSubmit:
                                                            (reviewGiven) {
                                                          _b2bStoreBloc
                                                              .add(ReviewEvent(
                                                            product_id: orderDetailsData!
                                                                    .orderSets[
                                                                        i]
                                                                    .orders![j]
                                                                    .items!
                                                                    .first
                                                                    .productId ??
                                                                "",
                                                            rating:
                                                                value.toInt(),
                                                            comment:
                                                                reviewGiven,
                                                            line_item_id:
                                                                orderDetailsData!
                                                                        .orderSets[
                                                                            i]
                                                                        .orders![
                                                                            j]
                                                                        .items!
                                                                        .first
                                                                        .detail
                                                                        ?.itemId
                                                                        ?.toString() ??
                                                                    '',
                                                          ));
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (c, i) => const SizedBox(
                                  height: 10,
                                ),
                              ),
                      ),
                    ],
                  ),
                )
              : Container();
        });
  }
}

class OrderItemWithReview extends StatelessWidget {
  final Item orderDetails;
  final Function(double) onChanged;
  final OrderSet orderSet;
  const OrderItemWithReview({
    super.key,
    required this.orderDetails,
    required this.onChanged,
    required this.orderSet,
  });

  @override
  Widget build(BuildContext context) {
    return XDecoratedBox(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 20,
          children: [
            Flexible(
              flex: 2,
              child: SizedBox(
                height: 60,
                width: 60,
                child: orderDetails.thumbnail == null ||
                        orderDetails.thumbnail!.isEmpty
                    ? Image.asset(AppImages.appLogo)
                    : CachedNetworkImage(imageUrl: orderDetails.thumbnail!),
              ),
            ),
            Flexible(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderDetails.subtitle ?? '',
                    style: AppTextStyle.font14bold,
                  ),
                  Text(
                    orderDetails.title ?? '',
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        orderDetails.unitPrice != null
                            ? "\u{20B9} ${orderDetails.unitPrice!.floorToDouble()}"
                            : "\u{20B9} N/A",
                        style: AppTextStyle.font14bold,
                      ),
                      // const Spacer(),
                      Column(
                        children: [
                          // Text("data"),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => OrderScreen(
                                            orderSet: orderSet,
                                          )));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: AppColors.backgroundColor,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Row(
                                children: [
                                  Text(
                                    "Check Status",
                                    style: AppTextStyle.font12bold,
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
        AnimatedRatingStars(
          initialRating: 3.5,
          minRating: 0.0,
          maxRating: 5.0,
          filledColor: Colors.amber,
          emptyColor: Colors.grey,
          filledIcon: Icons.star,
          halfFilledIcon: Icons.star_half,
          emptyIcon: Icons.star_border,
          onChanged: onChanged,
          displayRatingValue: true,
          interactiveTooltips: true,
          customFilledIcon: Icons.star,
          customHalfFilledIcon: Icons.star_half,
          customEmptyIcon: Icons.star_border,
          starSize: 30.0,
          animationDuration: const Duration(milliseconds: 300),
          animationCurve: Curves.easeInOut,
          readOnly: false,
        ),
        Text(
          "Rate this product now",
          style: AppTextStyle.font12bold,
        ),
      ],
    ));
  }
}

class OrderSummaryBottomSheet extends StatelessWidget {
  final OrderSet orderSet;
  final String orderId;
  final String customerName;
  final String address;
  final DateTime orderDate;
  final DateTime deliveryDate;
  final String status;
  final String productPrice;
  final String discount;
  final String shippingCost;
  final String grandTotal;
  final B2bStoreBloc b2bStoreBloc;

  const OrderSummaryBottomSheet({
    super.key,
    required this.orderId,
    required this.customerName,
    required this.address,
    required this.orderDate,
    required this.deliveryDate,
    required this.status,
    required this.productPrice,
    required this.discount,
    required this.shippingCost,
    required this.grandTotal,
    required this.orderSet,
    required this.b2bStoreBloc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 32,
                  color: Colors.grey[800],
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      'Check the summary of your order here',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Order ID
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      orderId,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  // Delivery Address Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Address',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          customerName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[900],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          address,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Order Details Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        _buildOrderRow(
                            'Order Place', _formatDateTime(orderDate)),
                        const SizedBox(height: 16),
                        _buildOrderRow(
                            'Order Delivered', _formatDateTime(deliveryDate)),
                        const SizedBox(height: 16),
                        _buildOrderRow('Status', status, isStatus: true),
                      ],
                    ),
                  ),

                  // Price Details Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        _buildPriceRow('Product Price', productPrice),
                        const SizedBox(height: 16),
                        _buildPriceRow('Discount', discount),
                        const SizedBox(height: 16),
                        _buildPriceRow('Shipping Total', shippingCost),
                        const SizedBox(height: 20),
                        Container(
                          height: 1,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 20),
                        _buildPriceRow('Grand Total', grandTotal,
                            isTotal: true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10,
                    children: List.generate(
                      orderSet.orders?.length ?? 0,
                      (j) {
                        if (orderSet == null ||
                            orderSet.orders == null ||
                            orderSet.orders!.isEmpty) {
                          return Container();
                        }
                        return OrderItemWithReview(
                          orderSet: orderSet,
                          orderDetails: orderSet.orders![j].items != null &&
                                  orderSet.orders![j].items!.isNotEmpty
                              ? orderSet.orders![j].items!.first
                              : Item(),
                          onChanged: (value) {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (c) {
                                return ReviewBottomSheet(
                                  onSubmit: (reviewGiven) {
                                    b2bStoreBloc.add(ReviewEvent(
                                      product_id: orderSet.orders![j].items!
                                              .first.productId ??
                                          "",
                                      rating: value.toInt(),
                                      comment: reviewGiven,
                                      line_item_id: orderSet.orders![j].items!
                                              .first.detail?.itemId
                                              ?.toString() ??
                                          '',
                                    ));
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderRow(String label, String value, {bool isStatus = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isStatus ? Colors.orange[700] : Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        Text(
          '₹ ${amount}/-',
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final localDateTime = dateTime.toLocal();
    return '${localDateTime.day.toString().padLeft(2, '0')}-${localDateTime.month.toString().padLeft(2, '0')}-${localDateTime.year} ${localDateTime.hour.toString().padLeft(2, '0')}:${localDateTime.minute.toString().padLeft(2, '0')}';
  }
}
