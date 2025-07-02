import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_bloc.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_event.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_state.dart';
import 'package:woloo_smart_hygiene/b2b_store/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/custom_widget/start_rating.dart';
import 'package:woloo_smart_hygiene/b2b_store/ecom.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/product_collections.dart'
    as product_collections;
import 'package:woloo_smart_hygiene/b2b_store/product_details.dart';
import 'package:woloo_smart_hygiene/b2b_store/search.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

class WishListScreen extends StatefulWidget {
  final List<product_collections.XYProduct> productData;
  const WishListScreen({
    super.key,
    required this.productData,
  });
  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  // Wishlist? wishlistData;
  bool _isDataLoaded = false;
  final B2bStoreBloc _b2bStoreBloc = B2bStoreBloc();
  List<product_collections.XYProduct> _wProductData = [];
  CartModel? _cart;

  GlobalStorage globalStorage = GetIt.instance();
  // final List<product_collections.Product> _wData = [];
  @override
  void initState() {
    // _wData.addAll(getFavProducts());
    // print(_wData.length);
    // TODO: implement initState
    _b2bStoreBloc.add(const WishlistEvent());

    super.initState();
  }

  List<product_collections.XYProduct> getFavProducts() {
    final favid = _b2bStoreBloc.favIds.map((e) => e.entries.first.key).toList();
    return widget.productData
        .where((element) => favid.contains(element.id))
        .toList();
  }

  _refresh() {
    _b2bStoreBloc.add(const WishlistEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: _b2bStoreBloc,
        listener: (context, state) {
          // print("dssa $state");
          if (state is WishlistLoading) {
            EasyLoading.show(status: state.message);
          }
          if (state is WishlistSuccess) {
            setState(() {
              _cart = state.cartModel;
              _wProductData = getFavProducts();
              _isDataLoaded = true;
              // state.
            });
            EasyLoading.dismiss();
            // setState(() {
            // wishlistData = state.wishlistData;
            // _dashboardData = state.dashboardData;
            // });
          }

          if (state is WishlistError) {
            EasyLoading.dismiss();
            EasyLoading.showError(state.error);
          }
        },
        builder: (context, snapshot) {
          return !_isDataLoaded
              ? Container()
              : Scaffold(
                  // bottomNavigationBar: const XBottomBar(),
                  appBar: EComAppbar(
                      onCartTap: () async {
                        final value = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => const CartScreen()));
                        if (value != null && value == 'refresh') {
                          _refresh();
                        } else {
                          _refresh();
                        }
                      },
                      cartValue: _isDataLoaded ? _cart?.cart.items?.length : 0,
                      onTap: () async {
                        final value = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => SearchScreen(
                                      suggestions: _wProductData
                                              .map((e) => e.title ?? "")
                                              .toList() ??
                                          [],
                                    )));
                        if (value != null && value == 'refresh') {
                          _refresh();
                        }
                      }),
                  body: SingleChildScrollView(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.themeBackground,
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 16.h, horizontal: 20.w),
                      child: Column(
                        spacing: 10.h,
                        children: [
                          Row(
                            children: [
                              Text("All Products",
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold)),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      size: 10,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Back",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.greyCircleColor,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 8,
                              childAspectRatio: 0.5,
                            ),
                            itemCount: _wProductData.length,
                            itemBuilder: (context, index) {
                              final product = _wProductData[index];

                              int productCount = 0;
                              _cart?.cart.items?.forEach((i) {
                                if (i.variantId == product.variants[0].id) {
                                  productCount = i.quantity ?? 0;
                                }
                              });
                              return GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailsScreen(
                                        productData: product,
                                        isSelected: _b2bStoreBloc.favIds.any(
                                            (e) => e.containsKey(product.id)),
                                        productIdforWishList:
                                            _b2bStoreBloc.favIds.any((e) =>
                                                    e.containsKey(product.id))
                                                ? _b2bStoreBloc.favIds
                                                    .firstWhere((e) =>
                                                        e.entries.first.key ==
                                                        product.id)
                                                    .entries
                                                    .first
                                                    .value
                                                : "",
                                      ),
                                    ),
                                  );
                                  if (result != null && result == 'refresh') {
                                    _b2bStoreBloc.add(const WishlistEvent());
                                    print(
                                        'Returned from Page B with refresh signal (or physical back).');
                                    // _initializeData(); // Re-initialize or refresh data
                                  } else {
                                    _b2bStoreBloc.add(const WishlistEvent());
                                    print(
                                        'Returned from Page B without refresh signal or cancelled.');
                                  }
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      // padding: EdgeInsets.symmetric(horizontal: 10.w),
                                      child: Stack(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                height: 80.h,
                                                width: 80.h,
                                                decoration: BoxDecoration(
                                                    color: AppColors
                                                        .themeBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.r),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: AppColors
                                                            .greyShadowColor,
                                                        blurRadius: 5.0,
                                                        spreadRadius: 0.5,
                                                        offset: Offset(0, 2),
                                                      ),
                                                      BoxShadow(
                                                        color: AppColors
                                                            .greyShadowColor,
                                                        blurRadius: 5.0,
                                                        spreadRadius: 0.5,
                                                        offset: Offset(0, -1),
                                                      ),
                                                    ]),
                                                child: Image.network(
                                                  product.thumbnail ?? '',
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.w,
                                                    vertical: 2.h),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.r),
                                                  color:
                                                      AppColors.lightCyanColor,
                                                ),
                                                child: Text(
                                                  product.variants.first.options
                                                          ?.first.value ??
                                                      "",
                                                  style:
                                                      AppTextStyle.font10bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Text(
                                                product.title ?? "",
                                                style: TextStyle(
                                                    fontSize: 8.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              // Text(
                                              //   products.subtitle ?? "",
                                              //   style: TextStyle(
                                              //     fontSize: 8.sp,
                                              //     color: AppColors.textgreyColor,
                                              //     fontWeight: FontWeight.bold,
                                              //   ),
                                              // ),
                                              Row(
                                                children: [
                                                  AnimatedRatingStars(
                                                    initialRating:
                                                        product.averageRating ??
                                                            0,
                                                    minRating: 0.0,
                                                    maxRating: 5.0,
                                                    filledColor: Colors.amber,
                                                    emptyColor: Colors.grey,
                                                    filledIcon: Icons.star,
                                                    halfFilledIcon:
                                                        Icons.star_half,
                                                    emptyIcon:
                                                        Icons.star_border,
                                                    onChanged: (a) {},
                                                    displayRatingValue: true,
                                                    interactiveTooltips: true,
                                                    customFilledIcon:
                                                        Icons.star,
                                                    customHalfFilledIcon:
                                                        Icons.star_half,
                                                    customEmptyIcon:
                                                        Icons.star_border,
                                                    starSize: 10,
                                                    animationDuration:
                                                        const Duration(
                                                            milliseconds: 300),
                                                    animationCurve:
                                                        Curves.easeInOut,
                                                    readOnly: false,
                                                  ),
                                                  // if (product.reviewCount !=
                                                  //         null &&
                                                  //     product.reviewCount != 0)
                                                  Text(
                                                    "(${product.reviewCount ?? 0})",
                                                    style:
                                                        AppTextStyle.font10bold,
                                                  )
                                                ],
                                              ),

                                              Row(
                                                spacing: 5.w,
                                                children: [
                                                  Text(
                                                    "\u{20B9}${product.variants.first.calculatedPrice!.calculatedAmount.toString()}",
                                                    style: TextStyle(
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  //TODO: Check Price Logic -- Abar asibo fire
                                                  Text(
                                                    "MRP ${product.variants.first.calculatedPrice!.originalAmount.toString()}",
                                                    style: TextStyle(
                                                        decoration:
                                                            product.discountable ??
                                                                    false
                                                                ? TextDecoration
                                                                    .lineThrough
                                                                : null,
                                                        fontSize: 10.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors
                                                            .textgreyColor),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          if (product.variants.first
                                                  .inventoryQuantity ==
                                              0)
                                            Positioned.fill(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                      sigmaX: 0.3, sigmaY: 0.3),
                                                  child: Container(
                                                    color: Colors.white
                                                        .withOpacity(0.4),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          Positioned(
                                              right: 0,
                                              top: 80,
                                              child: InkWell(
                                                onTap: () async {
                                                  if (product.variants.first
                                                          .inventoryQuantity ==
                                                      0) return;

                                                  _b2bStoreBloc.add(AddToCart(
                                                      quantity: 1,
                                                      variant_id: product
                                                          .variants[0].id));
                                                  // if (widget.isSelected) {
                                                  //   widget.onRemove?.call();
                                                  // } else {
                                                  //   widget.onAdd?.call();
                                                  // }
                                                  // setState(() {
                                                  //   mode = AddButtonMode.add;
                                                  // });
                                                  await Future.delayed(
                                                      const Duration(
                                                          milliseconds: 500),
                                                      () {
                                                    // setState(() {
                                                    //   mode =
                                                    //       AddButtonMode.count;
                                                    // });
                                                  });

                                                  // if (widget.onTap != null) {
                                                  //   widget.onTap!();
                                                  // }
                                                  //Add to cart 1st time
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(3.r),
                                                child: AnimatedContainer(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5.w,
                                                      vertical: 2.h),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: AppColors
                                                              .buttonColor,
                                                          width: 1.5),
                                                      color: productCount == 0
                                                          ? AppColors
                                                              .themeBackground
                                                          : AppColors
                                                              .buttonYellowColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3.r)),
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  child: Center(
                                                    child: product
                                                                .variants
                                                                .first
                                                                .inventoryQuantity ==
                                                            0
                                                        ? InkWell(
                                                            onTap: () {
                                                              _b2bStoreBloc.add(
                                                                RestockSubscriptionsEvent(
                                                                  phoneNumber:
                                                                      globalStorage
                                                                          .getClientMobileNo(),
                                                                  variantId: product
                                                                      .variants[
                                                                          0]
                                                                      .id!,
                                                                ),
                                                              );
                                                            },
                                                            child: Text(
                                                              "Notify",
                                                              style: AppTextStyle
                                                                  .font10bold,
                                                            ),
                                                          )
                                                        : productCount == 0
                                                            // AddButtonMode.remove
                                                            ? Text(
                                                                "Add",
                                                                style: AppTextStyle
                                                                    .font10bold,
                                                              )
                                                            // :
                                                            //  mode ==
                                                            //         AddButtonMode
                                                            //             .add
                                                            //     ? Text(
                                                            //         "Added",
                                                            //         style: AppTextStyle
                                                            //             .font10bold,
                                                            //       )
                                                            : Row(
                                                                spacing: 10,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      if (productCount ==
                                                                          0)
                                                                        return;

                                                                      // productCount -=
                                                                      //     1;
                                                                      // if (productCount ==
                                                                      //     0) {
                                                                      //   productCount =
                                                                      //       1;
                                                                      //   // mode = AddButtonMode
                                                                      //   //     .remove;
                                                                      //   // if (widget.onRemove != null) {
                                                                      //   //   widget.onRemove!();
                                                                      //   // }
                                                                      // }

                                                                      // setState(
                                                                      //     () {});
                                                                      productCount ==
                                                                              0
                                                                          ? EasyLoading.showError(
                                                                              "Product count cannot be less than 0")
                                                                          : null;
                                                                      _cart
                                                                          ?.cart
                                                                          .items
                                                                          ?.forEach(
                                                                              (i) {
                                                                        if (i.variantId ==
                                                                            product.variants[0].id) {
                                                                          productCount -=
                                                                              1;
                                                                          _b2bStoreBloc.add(AddRemoveItemReq(
                                                                              count: productCount,
                                                                              itemId: i.id ?? ""));
                                                                        }
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              4),
                                                                          border: Border.all(
                                                                              width: 1,
                                                                              color: AppColors.black)),
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                              2,
                                                                          horizontal:
                                                                              2),
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .remove,
                                                                        size: 8,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    productCount
                                                                        .toString(),
                                                                    style: AppTextStyle
                                                                        .font10,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      // productCount += 1;
                                                                      // setState(() {});
                                                                      // if (widget.onAdd != null) {
                                                                      //   widget.onAdd!();
                                                                      // }
                                                                      //  productCount == 0
                                                                      //   ? addToCart(context)
                                                                      //   :
                                                                      // To add value
                                                                      _cart
                                                                          ?.cart
                                                                          .items
                                                                          ?.forEach(
                                                                              (i) {
                                                                        if (i.variantId ==
                                                                            product.variants[0].id) {
                                                                          productCount +=
                                                                              1;
                                                                          _b2bStoreBloc.add(AddRemoveItemReq(
                                                                              count: productCount,
                                                                              itemId: i.id ?? ""));
                                                                        }
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              4),
                                                                          border: Border.all(
                                                                              width: 1,
                                                                              color: AppColors.black)),
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                              2,
                                                                          horizontal:
                                                                              2),
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .add,
                                                                        size:
                                                                            10,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                  ),
                                                ),
                                              )),

                                          product.variants.first
                                                      .inventoryQuantity ==
                                                  0
                                              ? Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.w,
                                                            vertical: 2.h),
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .lightCyanColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    child: Text(
                                                      "Out of Stock",
                                                      style: TextStyle(
                                                          fontSize: 6.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              AppColors.black),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                          // Positioned(
                                          //   // left: 8,
                                          //   // right: 8,
                                          //   child: Container(
                                          //     padding: EdgeInsets.symmetric(
                                          //         horizontal: 5.w,
                                          //         vertical: 2.h),
                                          //     decoration: BoxDecoration(
                                          //         color:
                                          //             AppColors.lightCyanColor,
                                          //         borderRadius:
                                          //             BorderRadius.circular(4)),
                                          //     child: Text(
                                          //       "Out of Stock",
                                          //       style: AppTextStyle.font10bold,
                                          //     ),
                                          //   ),
                                          // )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 6,
                                      right: 16,
                                      child: InkWell(
                                          onTap: () {
                                            //logger.w(_wProductData);
                                            _b2bStoreBloc.add(RemoveWishList(
                                                itemId: _b2bStoreBloc.favIds
                                                    .firstWhere((e) =>
                                                        e.entries.first.key ==
                                                        product.id)
                                                    .entries
                                                    .first
                                                    .value));
                                          },
                                          child: const Icon(
                                            // isSelected
                                            //     ?
                                            Icons.favorite_rounded,
                                            // : Icons.favorite_border_rounded,
                                            color: Colors.pink,
                                          )),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 60.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        });
  }
}
