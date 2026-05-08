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
import '../widgets/rating_widget.dart';

class AllOrderScreen extends StatefulWidget {
  const AllOrderScreen({super.key});

  @override
  State<AllOrderScreen> createState() => _AllOrderScreenState();
}

class _AllOrderScreenState extends State<AllOrderScreen> {
  final B2bStoreBloc _b2bStoreBloc = B2bStoreBloc();
  OrderDetails? orderDetailsData;
  bool isLoading = true;
  List<Item>? orderItems = [];
  List<OrderSet>? orderSets = [];
  int selectedorder = 0;
  bool isOnClick = false;
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
              orderSets = orderDetailsData?.orderSets.reversed.toList();

              // orderSets = orderDetailsData.orderSets[selectedorder];

              isOnClick
                  ? showModalBottomSheet(
                      isScrollControlled: true,
                      isDismissible: true, // <-- Allow tap outside to dismiss
                      enableDrag: true, // <-- Allow swipe down to dismiss

                      backgroundColor: Colors
                          .transparent, // Optional: if you want rounded corners to show correctly

                      context: context,
                      builder: (_) => OrderSummaryBottomSheet(
                        offers: orderSets![selectedorder]
                                .orders
                                ?.first
                                .items
                                ?.first
                                .adjustments
                                ?.map((e) => e.code)
                                .join(", ") ??
                            "",

                        //  orderSets[i]
                        //         .orders
                        //         ?.first
                        //         .items
                        //         ?.first
                        //         .adjustments
                        //         ?.first
                        //         .code ??
                        //     "",
                        b2bStoreBloc: _b2bStoreBloc,
                        orderSet: orderSets![selectedorder],
                        orderId: orderSets![selectedorder].id ?? "",
                        customerName:
                            "${orderSets![selectedorder].cart?.shippingAddress?.firstName ?? ""} ",
                        address:
                            "${orderSets![selectedorder].cart?.shippingAddress?.address1}",
                        orderDate: orderSets![selectedorder].createdAt ??
                            DateTime.now(),
                        deliveryDate: orderSets![selectedorder].delivaryDate,

                        status: orderSets![selectedorder].delivaryDate == null
                            ? "${orderSets![selectedorder].status}"
                            : "${orderSets![selectedorder].fulfillmentStatus}",
                        productPrice: (double.tryParse(
                                    orderSets![selectedorder].itemSubtotal ??
                                        "0.00")
                                ?.toStringAsFixed(2) ??
                            "0.00"),
                        shippingCost: (double.tryParse(
                                    orderSets![selectedorder].shippingTotal ??
                                        "0.00")
                                ?.toStringAsFixed(2) ??
                            "0.00"),
                        grandTotal: (double.tryParse(
                                    orderSets![selectedorder].total ?? "0.00")
                                ?.toStringAsFixed(2) ??
                            "0.00"),
                        discount: "${orderSets![selectedorder].discountTotal}",
                      ), //AddressBottomSheet
                    )
                  : null;
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
                        child: orderSets == null || orderSets!.isEmpty
                            ? Center(
                                child: Text(
                                "No orders found. Start shopping now!",
                                style: AppTextStyle.font14bold,
                              ))
                            : ListView.separated(
                                // reverse: true,
                                itemCount: orderSets!.length,
                                itemBuilder: (c, i) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 10),
                                    child: Column(
                                      spacing: 20,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _b2bStoreBloc
                                                .add(const OrderDetailsEvent());
                                            //  selectedOrderSets =
                                            // orderSets[i];
                                            selectedorder = i;
                                            isOnClick = true;
                                            setState(() {});
                                          },
                                          child: Text(
                                            orderSets![i].id?.toString() ?? '',
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AppColors.lightCyanColor),
                                          ),
                                        ),
                                        Column(
                                            mainAxisSize: MainAxisSize.min,
                                            spacing: 10,
                                            children: orderSets![i].orders!.map(
                                              (e) {
                                                return ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: e.items!.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child:
                                                          OrderItemWithReview(
                                                        onChanged: (value) {
                                                          showModalBottomSheet(
                                                            context: context,
                                                            isScrollControlled:
                                                                true,
                                                            builder: (c) {
                                                              return ReviewBottomSheet(
                                                                onSubmit:
                                                                    (reviewGiven) {
                                                                  _b2bStoreBloc.add(
                                                                      ReviewEvent(
                                                                    product_id: e
                                                                            //  orderSets[
                                                                            //             i]
                                                                            //         .orders![j]
                                                                            .items!
                                                                            .first
                                                                            .productId ??
                                                                        "",
                                                                    rating: value
                                                                        .toInt(),
                                                                    comment:
                                                                        reviewGiven,
                                                                    line_item_id: e
                                                                            // orderSets[
                                                                            //             i]
                                                                            //         .orders![j]
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
                                                        orderDetails:
                                                            e.items![index],
                                                        orderSet: orderSets![i],
                                                      ),
                                                    );
                                                  },
                                                );
                                                //     List.generate(
                                                //   e.items?.length ?? 0,
                                                //   (j) {
                                                //     if (orderSets[i].orders ==
                                                //             null ||
                                                //         orderSets[i]
                                                //             .orders!
                                                //             .isEmpty) {
                                                //       return Container();
                                                //     }
                                                //     return OrderItemWithReview(
                                                //       orderSet: orderSets[i],
                                                //       orderDetails: orderSets[i]
                                                //                       .orders![j]
                                                //                       .items !=
                                                //                   null &&
                                                //               orderSets[i]
                                                //                   .orders![j]
                                                //                   .items!
                                                //                   .isNotEmpty
                                                //           ? orderSets[i]
                                                //               .orders![j]
                                                //               .items!
                                                //               .first
                                                //           : Item(),
                                                //       onChanged: (value) {
                                                //         showModalBottomSheet(
                                                //           context: context,
                                                //           isScrollControlled: true,
                                                //           builder: (c) {
                                                //             return ReviewBottomSheet(
                                                //               onSubmit:
                                                //                   (reviewGiven) {
                                                //                 _b2bStoreBloc
                                                //                     .add(ReviewEvent(
                                                //                   product_id: orderSets[
                                                //                               i]
                                                //                           .orders![j]
                                                //                           .items!
                                                //                           .first
                                                //                           .productId ??
                                                //                       "",
                                                //                   rating:
                                                //                       value.toInt(),
                                                //                   comment:
                                                //                       reviewGiven,
                                                //                   line_item_id: orderSets[
                                                //                               i]
                                                //                           .orders![j]
                                                //                           .items!
                                                //                           .first
                                                //                           .detail
                                                //                           ?.itemId
                                                //                           ?.toString() ??
                                                //                       '',
                                                //                 ));
                                                //               },
                                                //             );
                                                //           },
                                                //         );
                                                //       },
                                                //     );
                                                //   },
                                                // ),
                                              },
                                            ).toList()),
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
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowGrey,
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 20,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: CachedNetworkImage(
                    imageUrl: orderDetails?.thumbnail ??
                        "", // Replace with your product image
                    height: 76.h,
                    width: 76.w,
                    fit: BoxFit.cover,
                  ),
                ),
                Flexible(
                  flex: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderDetails.subtitle ?? '',
                        style: AppTextStyle.font14bold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
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
                                ? "\u{20B9} ${orderDetails.unitPrice!.floorToDouble()}/-"
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
                                        size: 18,
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
            SizedBox(
              height: 10.h,
            ),
            // IgnorePointer(
            //   ignoring: true,
            //   child:
            RatingWidget(
              ratingValue: 5,
              starSize: 16,
              starSpacing: 6,
              onValueChanged: onChanged,
            ),
            // ),
            // AnimatedRatingStars(
            //   initialRating: 3.5,
            //   minRating: 0.0,
            //   maxRating: 5.0,
            //   filledColor: Colors.amber,
            //   emptyColor: Colors.grey,
            //   filledIcon: Icons.star,
            //  // halfFilledIcon: Icons.em,
            //   emptyIcon: Icons.star_border,
            //   onChanged: onChanged,
            //   displayRatingValue: true,
            //   interactiveTooltips: true,
            //   customFilledIcon: Icons.star,
            //   customHalfFilledIcon: Icons.star_half,
            //   customEmptyIcon: Icons.star_border,
            //   starSize: 30.0,
            //   animationDuration: const Duration(milliseconds: 300),
            //   animationCurve: Curves.easeInOut,
            //   readOnly: false,
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 5), // margin left
              child: Text(
                "Rate this product now",
                style: AppTextStyle.font10bold.copyWith(
                  color: Colors.grey, // your desired color
                ),
              ),
            )
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
  final DateTime? deliveryDate;
  final String status;
  final String productPrice;
  final String discount;
  final String shippingCost;
  final String grandTotal;
  final B2bStoreBloc b2bStoreBloc;

  final String offers;

  const OrderSummaryBottomSheet({
    super.key,
    required this.orderId,
    required this.customerName,
    required this.address,
    required this.orderDate,
    this.deliveryDate,
    required this.status,
    required this.productPrice,
    required this.discount,
    required this.shippingCost,
    required this.grandTotal,
    required this.orderSet,
    required this.b2bStoreBloc,
    required this.offers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
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
                  size: 40,
                  color: Colors.grey[800],
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Text(
                      orderId,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[800],
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  // Delivery Address Card
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadowGrey,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Address',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          customerName,
                          style: TextStyle(
                            fontSize: 16,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadowGrey,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildOrderRow(
                            'Order Place', _formatDateTime(orderDate)),
                        const SizedBox(height: 16),
                        _buildOrderRow(
                            'Order Delivered',
                            deliveryDate == null
                                ? ''
                                : _formatDateTime(deliveryDate!)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1, // weight = 1
                              child: Text(
                                "Offers Applied",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1, // weight = 1
                              child: Text(
                                offers,
                                maxLines: 3,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildOrderRow('Status', status, isStatus: true),
                      ],
                    ),
                  ),

                  // Price Details Card
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadowGrey,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
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
                        const SizedBox(height: 10),
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
                        if (orderSet.orders == null ||
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
        Expanded(
          flex: 1, // weight = 1
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey[800],
            ),
          ),
        ),
        Expanded(
          flex: 1, // weight = 1
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isStatus ? Colors.orange[700] : Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2, // weight = 1
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
              color: Colors.grey[800],
            ),
          ),
        ),
        Expanded(
          flex: 1, // weight = 1
          child: Text(
            '₹ $amount/-',
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
              color: Colors.grey[800],
            ),
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
