import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:woloo_smart_hygiene/b2b_store/address_change_bottomsheet.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_bloc.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_event.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_state.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/product_details.dart';
import 'package:woloo_smart_hygiene/b2b_store/widgets/smart_widgets.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:woloo_smart_hygiene/utils/logger.dart';
import 'package:woloo_smart_hygiene/widgets/boxes/cart_item.dart';
import 'package:woloo_smart_hygiene/widgets/order_summery_bottomsheet.dart';

import '../hygine_services/view/address_notifier.dart';
import 'widgets/radio_labeled_tile.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // final

  final box = GetStorage();
  Razorpay razorpay = Razorpay();
  final B2bStoreBloc _b2bStoreBloc = B2bStoreBloc();
  bool _isDataLoaded = false;
  CartModel? cartModel;
  bool isExpressBooking = false;
  int wolooPoints = 0;
  bool isWolooPointsApplied = false;
  bool isWolooPointsLoading = false;
  String? wolooPointsError;

  @override
  void initState() {
    _promoController.text = box.read(
          box.read('cart_id') + "promoCode",
        ) ??
        "";
    isWolooPointsApplied = box.read(
          box.read('cart_id') + "wolooPoints",
        ) ??
        false;
    _b2bStoreBloc.add(const GetCartData());
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Place any code here that should run after the first build is complete.
      if (selectedAddress.value.id == null) {
        showModalBottomSheet(
          isScrollControlled: true,
          isDismissible: false, // <-- Allow tap outside to dismiss
          enableDrag: true, // <-- Allow swipe down to dismiss
          backgroundColor: Colors
              .transparent, // Optional: if you want rounded corners to show correctly
          context: context,
          builder: (_) => const AddressChangeBottomSheet(), //AddressBottomSheet
        );
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: _b2bStoreBloc,
        listener: (context, state) {
          if (state is CartLoading) {
            if (state.message.contains("Woloo points")) {
              setState(() {
                isWolooPointsLoading = true;
                wolooPointsError = null;
              });
            } else {
              EasyLoading.show(status: state.message);
            }
          }
          if (state is CartSuccess) {
            setState(() {
              cartModel = state.cartData;
              if (state.wolooPoints > 0) {
                wolooPoints = state.wolooPoints;
              }

              isWolooPointsLoading = false;
              wolooPointsError = null;
              _isDataLoaded = true;
            });
            logger.d(cartModel?.cart.shippingTotal);
            // Show success message if provided
            // if (state.message != null) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(
            //       content: Text(state.message!),
            //       backgroundColor: Colors.green,
            //     ),
            //   );
            // }

            EasyLoading.dismiss();
          }
          if (state is CartError) {
            EasyLoading.showError(state.error);
            setState(() {
              isWolooPointsLoading = false;
              // wolooPointsError = state.error;
            });
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(state.error),
            //     backgroundColor: Colors.red,
            //   ),
            // );
          }
          if (state is ReadyToShip) {
            EasyLoading.dismiss();
            showCartBottomSheet(context);
          }
          if (state is CartLoadingForPromo) {
            setState(() {
              isLoading = true;
              errorMessage = null;
            });
          }
          if (state is PromoCodeSuccess) {
            setState(() {
              isLoading = false;
              errorMessage = null;
              cartModel = state.cartData;
              if (state.message?.contains("removed") ?? false) {
                // isApplied = false;
                // appliedPromoCode = "";
                _promoController.clear();
              } else {
                // isApplied = true;
                _promoController.text.trim();
              }
            });
          }
          if (state is PromoApplyError) {
            setState(() {
              isLoading = false;
              errorMessage = state.error;
              _promoController.text = "";
            });
          }
        },
        builder: (context, snapshot) {
          return Scaffold(
              bottomSheet: cartModel?.cart.items?.isEmpty ?? true
                  ? const SizedBox.shrink()
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: LongLabeledButton(
                        onTap: () {
                          if (selectedAddress.value.id == null) {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              isDismissible:
                                  false, // <-- Allow tap outside to dismiss
                              enableDrag:
                                  true, // <-- Allow swipe down to dismiss
                              backgroundColor: Colors
                                  .transparent, // Optional: if you want rounded corners to show correctly
                              context: context,
                              builder: (_) =>
                                  const AddressChangeBottomSheet(), //AddressBottomSheet
                            );
                            return;
                          } else {
                            _b2bStoreBloc.add(const ProceedToShip());
                          }
                        },
                        label: "Checkout",
                      ),
                    ),
              appBar: const BackAppBar(),
              body: !_isDataLoaded
                  ? Container()
                  : SmartSingleChildScrollView(
                      isEnabled: !(cartModel?.cart.items?.isEmpty ?? true),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 20.h),
                      child: Column(
                        spacing: 16.h,
                        children: [
                          CartHeader(
                            imgPath: AppImages.cart,
                            title: "Cart",
                            subtitle: 'Checkout you purchases from here',
                          ),
                          const Divider(),
                          if (cartModel?.cart.items?.isEmpty ?? true) ...[
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Looks like your cart is empty. Start ordering now!",
                                  style: AppTextStyle.font14bold,
                                ),
                              ),
                            ),
                          ] else ...[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Total Items: ${cartModel?.cart.items?.length} Unit",
                                style: AppTextStyle.font14bold,
                              ),
                            ),
                            if (false)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  XRadioTile(
                                    onTap: () {
                                      isExpressBooking = !isExpressBooking;
                                      setState(() {});
                                    },
                                    isSelected: !isExpressBooking,
                                    title: "Normal Shipping",
                                    subTitle: "7-10 Days",
                                  ),
                                  XRadioTile(
                                    onTap: () {
                                      isExpressBooking = !isExpressBooking;
                                      setState(() {});
                                    },
                                    isSelected: isExpressBooking,
                                    title: "Express Shipping+ \u{20B9}75",
                                    subTitle: "2-3 Days",
                                  ),
                                ],
                              ),
                            ListView.builder(
                              shrinkWrap:
                                  true, // Ensures ListView takes only the required space
                              physics:
                                  const NeverScrollableScrollPhysics(), // Prevents nested scrolling
                              itemCount: cartModel?.cart.items
                                  ?.length, // Replace with your cart item count
                              itemBuilder: (context, index) {
                                final item = cartModel?.cart.items?[index];
                                int count = item?.quantity ?? 0;

                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  child: CartItemCard(
                                    onDelete: () {
                                      _b2bStoreBloc.add(DeleteItemReq(
                                          itemId: item?.id ?? ""));
                                    },
                                    item: item,
                                    onAdd: () {
                                      count++;
                                      _b2bStoreBloc.add(AddRemoveItemReq(
                                          count: count,
                                          itemId: item?.id ?? ""));
                                    },
                                    onRemove: () {
                                      count--;
                                      // //logger.w("Count: $count");
                                      if (count > 0) {
                                        _b2bStoreBloc.add(AddRemoveItemReq(
                                            count: count,
                                            itemId: item?.id ?? ""));
                                      } else {
                                        //logger.w("$count delete");
                                        _b2bStoreBloc.add(DeleteItemReq(
                                            itemId: item?.id ?? ""));
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                            const Divider(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColors.textgreyColor,
                                      blurRadius: 4,
                                      offset: Offset(0, 1),
                                    ),
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: Image.asset(AppImages.appLogo),
                                      ),
                                      Text(
                                        "Redeem your Woloo Points",
                                        style: AppTextStyle.font13w7,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "You have $wolooPoints Woloo Points to Redeem",
                                    style: AppTextStyle.font13w7
                                        .copyWith(color: AppColors.greyBorder),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (isWolooPointsLoading)
                                        const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      else ...[
                                        Expanded(
                                          child: Text(
                                            // wolooPoints > 0
                                            // ?
                                            "Redeem ${wolooPoints < 10 ? wolooPoints : 10} woloo points for \u{20B9} ${wolooPoints < 10 ? wolooPoints : 10}",
                                            // : "No points available to redeem",
                                            style: AppTextStyle.font10bold
                                                .copyWith(
                                                    color: wolooPointsError !=
                                                            null
                                                        ? Colors.red
                                                        : AppColors.greyBorder),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        InkWell(
                                          onTap: (!isWolooPointsLoading &&
                                                  wolooPoints >= 0)
                                              ? () {
                                                  if (isWolooPointsApplied) {
                                                    setState(() {
                                                      box.remove(
                                                          box.read('cart_id') +
                                                              "wolooPoints");
                                                      isWolooPointsApplied =
                                                          false;
                                                    });
                                                    _b2bStoreBloc.add(
                                                        const RemoveWolooPointsEvent());
                                                  } else {
                                                    setState(() {
                                                      isWolooPointsApplied =
                                                          true;
                                                      box.write(
                                                          box.read('cart_id') +
                                                              "wolooPoints",
                                                          isWolooPointsApplied);
                                                    });
                                                    _b2bStoreBloc.add(
                                                        const ApplyWolooPointsEvent());
                                                  }
                                                }
                                              : null,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: wolooPoints > 0
                                                  ? (isWolooPointsApplied
                                                      ? Colors.red
                                                          .withOpacity(0.2)
                                                      : AppColors
                                                          .lightCyanColor)
                                                  : AppColors.lightCyanColor
                                                      .withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              wolooPointsError != null
                                                  ? "Retry"
                                                  : ((isWolooPointsApplied
                                                      ? "Remove"
                                                      : "Apply")),
                                              style: AppTextStyle.font14bold
                                                  .copyWith(
                                                color: wolooPointsError != null
                                                    ? Colors.red
                                                    : ((isWolooPointsApplied
                                                        ? Colors.red
                                                        : Colors.black)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      if (wolooPointsError != null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text(
                                            wolooPointsError!,
                                            style: AppTextStyle.font10bold
                                                .copyWith(color: Colors.red),
                                          ),
                                        )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(12.w),
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
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Image.asset(
                                            AppImages.salePercentage),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Apply Promo Code",
                                        style: AppTextStyle.font14bold,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _promoController,
                                          enabled: !isLoading,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            isCollapsed: true,
                                            border:
                                                const UnderlineInputBorder(),
                                            focusedBorder:
                                                const UnderlineInputBorder(),
                                            hintText: "Enter Promocode",
                                            errorText: errorMessage,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      _promoController.text != ""
                                          ? CyanTextButton(
                                              onTap: () {
                                                if (isLoading) {
                                                  null;
                                                } else {
                                                  _removePromoCode();
                                                }
                                              },
                                              label:
                                                  //  isLoading
                                                  // ? "Removing..."
                                                  // :
                                                  "Remove",
                                              color: AppColors.lightCyanColor,
                                            )
                                          : CyanTextButton(
                                              onTap: () {
                                                isLoading
                                                    ? null
                                                    : _applyPromoCode();
                                              },
                                              label:
                                                  //  isLoading
                                                  //     ? "Applying..."
                                                  //     :
                                                  "Apply",
                                              color: AppColors.lightCyanColor,
                                            ),
                                    ],
                                  ),
                                  if (_promoController.text != "") ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 16.sp,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Promo code '${_promoController.text}' applied",
                                          style:
                                              AppTextStyle.font12bold.copyWith(
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            // Container(
                            //   padding: EdgeInsets.all(12.w),
                            //   decoration: BoxDecoration(
                            //     color: Colors.white,
                            //     borderRadius: BorderRadius.circular(16.r),
                            //     boxShadow: [
                            //       BoxShadow(
                            //         color: Colors.grey.withOpacity(0.1),
                            //         blurRadius: 5,
                            //         spreadRadius: 1,
                            //         offset: const Offset(0, 3),
                            //       ),
                            //     ],
                            //   ),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: [
                            //       Row(
                            //         children: [
                            //           SizedBox(
                            //             height: 24,
                            //             width: 24,
                            //             child: Image.asset(
                            //                 AppImages.salePercentage),
                            //           ),
                            //           const SizedBox(width: 8),
                            //           Text(
                            //             "Apply Promo Code",
                            //             style: AppTextStyle.font14bold,
                            //           ),
                            //         ],
                            //       ),
                            //       const SizedBox(height: 10),
                            //       Row(
                            //         children: [
                            //           Expanded(
                            //             child: TextField(
                            //               controller: _promoController,
                            //               enabled: !isLoading,
                            //               decoration: InputDecoration(
                            //                 isDense: true,
                            //                 isCollapsed: true,
                            //                 border:
                            //                     const UnderlineInputBorder(),
                            //                 focusedBorder:
                            //                     const UnderlineInputBorder(),
                            //                 hintText: "Enter Promocode",
                            //                 errorText: errorMessage,
                            //               ),
                            //             ),
                            //           ),
                            //           const SizedBox(width: 10),
                            //           _promoController.text != ""
                            //               ? CyanTextButton(
                            //                   onTap: () {
                            //                     if (isLoading) {
                            //                       null;
                            //                     } else {
                            //                       _removePromoCode();
                            //                     }
                            //                   },
                            //                   label: isLoading
                            //                       ? "Removing..."
                            //                       : "Remove",
                            //                   color:
                            //                       Colors.red.withOpacity(0.2),
                            //                 )
                            //               : CyanTextButton(
                            //                   onTap: () {
                            //                     isLoading
                            //                         ? null
                            //                         : _applyPromoCode();
                            //                   },
                            //                   label: isLoading
                            //                       ? "Applying..."
                            //                       : "Apply",
                            //                   color: AppColors.lightCyanColor,
                            //                 ),
                            //         ],
                            //       ),
                            //       if (_promoController.text != "") ...[
                            //         const SizedBox(height: 8),
                            //         Row(
                            //           children: [
                            //             Icon(
                            //               Icons.check_circle,
                            //               color: Colors.green,
                            //               size: 16.sp,
                            //             ),
                            //             const SizedBox(width: 8),
                            //             Text(
                            //               "Promo code '${_promoController.text}' applied",
                            //               style:
                            //                   AppTextStyle.font12bold.copyWith(
                            //                 color: Colors.green,
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     ],
                            //   ),
                            // ),

                            const Divider(),
                            PricingCalculate(
                              itemTotal:
                                  cartModel?.cart.originalItemTotal.toString(),
                              discount: cartModel?.cart.discountTotal
                                  ?.toStringAsFixed(2),
                              total: cartModel?.cart.total.toString(),
                              subTotal: cartModel?.cart.subtotal.toString(),
                              shipping:
                                  cartModel?.cart.shippingTotal.toString(),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ]
                        ],
                      ),
                    ));
        });
  }

  final TextEditingController _promoController = TextEditingController();
  bool isLoading = false;
  bool isApplied = false;
  String? errorMessage;
  String appliedPromoCode = '';

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromoCode() {
    if (_promoController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please enter a promo code';
      });
      return;
    }
    // Store promo code in box
    box.write(box.read('cart_id') + "promoCode", _promoController.text.trim());
    // context.read<B2bStoreBloc>().add(
    //       ApplyPromoEvent(
    //         promoCode: _promoController.text.trim(),
    //       ),
    //     );
    _b2bStoreBloc.add(
      ApplyPromoEvent(
        promoCode: _promoController.text.trim(),
      ),
    );
  }

  void _removePromoCode() {
    if (_promoController.text == "") {
      return;
    }
    // Remove promo code from box
    box.remove(box.read('cart_id') + "promoCode");
    // context.read<B2bStoreBloc>().add(
    //       RemovePromoCodeEvent(
    //         promoCode: appliedPromoCode,
    //       ),
    //     );
    _b2bStoreBloc.add(
      RemovePromoCodeEvent(
        promoCode: _promoController.text,
      ),
    );
  }

  Future<dynamic> showCartBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true, // <-- Allow tap outside to dismiss
      enableDrag: true, // <-- Allow swipe down to dismiss

      backgroundColor: Colors
          .transparent, // Optional: if you want rounded corners to show correctly

      context: context,
      builder: (_) => const OrderSummeryBottomSheet(), //AddressBottomSheet
    );
  }
}

class ApplyPromo extends StatefulWidget {
  const ApplyPromo({super.key});

  @override
  State<ApplyPromo> createState() => _ApplyPromoState();
}

class _ApplyPromoState extends State<ApplyPromo> {
  final TextEditingController _promoController = TextEditingController();
  bool isLoading = false;
  // bool isApplied = false;
  String? errorMessage;
  // String appliedPromoCode = '';
  final box = GetStorage();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _promoController.text = box.read(
          box.read('cart_id') + "promoCode",
        ) ??
        "";
    super.initState();
  }

  void _applyPromoCode() {
    if (_promoController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please enter a promo code';
      });
      return;
    }
    // Store promo code in box
    box.write(box.read('cart_id') + "promoCode", _promoController.text.trim());
    context.read<B2bStoreBloc>().add(
          ApplyPromoEvent(
            promoCode: _promoController.text.trim(),
          ),
        );
  }

  void _removePromoCode() {
    if (_promoController.text == "") {
      return;
    }
    // Remove promo code from box
    box.remove(box.read('cart_id') + "promoCode");
    context.read<B2bStoreBloc>().add(
          RemovePromoCodeEvent(
            promoCode: _promoController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<B2bStoreBloc, B2BStoreState>(
      listener: (context, state) {
        if (state is CartLoadingForPromo) {
          setState(() {
            isLoading = true;
            errorMessage = null;
          });
        }
        if (state is PromoCodeSuccess) {
          setState(() {
            isLoading = false;
            errorMessage = null;
            if (state.message?.contains("removed") ?? false) {
              // isApplied = false;
              // appliedPromoCode = "";
              _promoController.clear();
            } else {
              // isApplied = true;
              _promoController.text.trim();
            }
          });
        }
        if (state is PromoApplyError) {
          setState(() {
            isLoading = false;
            errorMessage = state.error;
            _promoController.text = "";
          });
        }
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Image.asset(AppImages.salePercentage),
                ),
                const SizedBox(width: 8),
                Text(
                  "Apply Promo Code",
                  style: AppTextStyle.font14bold,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoController,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      isDense: true,
                      isCollapsed: true,
                      border: const UnderlineInputBorder(),
                      focusedBorder: const UnderlineInputBorder(),
                      hintText: "Enter Promocode",
                      errorText: errorMessage,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _promoController.text != ""
                    ? CyanTextButton(
                        onTap: () {
                          if (isLoading) {
                            null;
                          } else {
                            _removePromoCode();
                          }
                        },
                        label: isLoading ? "Removing..." : "Remove",
                        color: AppColors.lightCyanColor,
                      )
                    : CyanTextButton(
                        onTap: () {
                          isLoading ? null : _applyPromoCode();
                        },
                        label: isLoading ? "Applying..." : "Apply",
                        color: AppColors.lightCyanColor,
                      ),
              ],
            ),
            if (_promoController.text != "") ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 16.sp,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Promo code '${_promoController.text}' applied",
                    style: AppTextStyle.font12bold.copyWith(
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class LongLabeledButton extends StatelessWidget {
  const LongLabeledButton({
    super.key,
    required this.onTap,
    required this.label,
    this.color = AppColors.lightCyanColor,
    this.height = 30,
  });
  final VoidCallback onTap;
  final String label;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: color,
        ),
        child: Center(
            child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
        )),
      ),
    );
  }
}

class PricingCalculate extends StatefulWidget {
  const PricingCalculate({
    super.key,
    this.total,
    this.subTotal,
    this.discount,
    this.itemTotal,
    this.shipping,
    this.isHeader = false,
  });
  final String? total;
  final String? subTotal;
  final String? discount;
  final String? itemTotal;
  final String? shipping;

  final bool isHeader;

  @override
  State<PricingCalculate> createState() => _PricingCalculateState();
}

class _PricingCalculateState extends State<PricingCalculate> {
  @override
  Widget build(BuildContext context) {
    return XDecoratedBox(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isHeader) ...[
          Text(
            "Order Summary",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
        ItemNamePrice(
          item: "Item Total",
          price: "\u{20B9} ${widget.itemTotal}/-",
        ),
        ItemNamePrice(
          item: "Discount",
          price: "\u{20B9} ${widget.discount}/-",
        ),
        widget.shipping == "" && widget.shipping == "0"
            ? ItemNamePrice(
                item: "Shipping",
                price: "\u{20B9} ${widget.shipping}/-",
              )
            : const ItemNamePrice(
                item: "Shipping",
                price: "\u{20B9} 0/-",
              ),
        // ItemNamePrice(
        //   item: "Item Total",
        //   price: "\u{20B9} $subTotal",
        // ),
        const Divider(),
        ItemNamePrice(
          item: "Grand Total",
          price: "\u{20B9} ${widget.total}/-",
          itemStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      ],
    ));
  }
}

class ItemNamePrice extends StatelessWidget {
  const ItemNamePrice({
    super.key,
    required this.item,
    required this.price,
    this.itemStyle,
  });
  final String item;
  final String price;
  final TextStyle? itemStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          item,
          style: itemStyle ??
              TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Text(
          price,
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textgreyColor),
        ),
      ],
    );
  }
}

class XDecoratedBox extends StatelessWidget {
  const XDecoratedBox({
    super.key,
    required this.child,
    this.padding = 12,
    this.radius = 16,
  });
  final Widget child;
  final double padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            spreadRadius: 1, // Spread effect
            blurRadius: 10, // Blur effect
            offset: const Offset(0, 5), // Bottom shadow
          ),
        ],
      ),
      child: child,
    );
  }
}

class XDesignedTextField extends StatelessWidget {
  const XDesignedTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        fillColor: AppColors.themeBackground,
        filled: true,
        hintText: hintText,
        isDense: true,
        hintStyle: AppTextStyle.font12,
        border: InputBorder.none,
      ),
    );
  }
}

class CyanTextButton extends StatelessWidget {
  const CyanTextButton({
    super.key,
    this.onTap,
    required this.label,
    this.color,
  });

  final VoidCallback? onTap;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: isDisabled
              ? (color ?? AppColors.lightCyanColor).withOpacity(0.5)
              : (color ?? AppColors.lightCyanColor),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              color: isDisabled ? Colors.black38 : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class CartHeader extends StatelessWidget {
  const CartHeader({
    super.key,
    required this.imgPath,
    required this.title,
    required this.subtitle,
  });
  final String imgPath;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: Image.asset(imgPath),
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 10.sp),
              ),
            ],
          ),
        )
      ],
    );
  }
}
