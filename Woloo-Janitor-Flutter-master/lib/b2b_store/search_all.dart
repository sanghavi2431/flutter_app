import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/b2b_store/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/product_details.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/leading_button.dart';

import '../core/local/global_storage.dart';
import '../hygine_services/view/address_notifier.dart';
import '../utils/app_color.dart';
import '../utils/app_constants.dart';
import '../utils/app_textstyle.dart';
import '../widgets/rating_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'bloc/b2b_store_bloc.dart';
import 'bloc/b2b_store_event.dart';
import 'bloc/b2b_store_state.dart';
import 'ecom.dart';
import 'models/cart.dart';
import 'models/product_collections.dart';

class SearchAll extends StatefulWidget {
  final List<XYProduct> products;
  const SearchAll({super.key, required this.products});

  @override
  State<SearchAll> createState() => _SearchAllState();
}

class _SearchAllState extends State<SearchAll> {
  final B2bStoreBloc _b2bStoreBloc = B2bStoreBloc();
  CartModel? cartData;
  GlobalStorage globalStorage = GetIt.instance();
  _refresh() {
    _b2bStoreBloc.add(const GetCartData());
  }

  _refresh2() {
    _b2bStoreBloc.add(const Refresh(slug: "collection_id"));
    // focus.unfocus();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EComAppbar(
          isSearchField: true,
          // controller: searchTEC,
          onCartTap: () async {
            final value = await Navigator.push(
                context, MaterialPageRoute(builder: (c) => const CartScreen()));
            if (value != null && value == 'refresh') {
              _refresh();
            } else {
              _refresh();
            }
          },
          onChanged: (value) {},
          cartValue: cartData?.cart.items?.length ?? 0,
          onTap: () async {
            //   final value = await Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (c) => SearchScreen(
            //                 suggestions: widget.b2bStoreHomePage
            //                         ?.productCollections.products
            //                         .map((e) => e.title ?? "")
            //                         .toList() ??
            //                     [],
            //               )));
            //   if (value != null && value == 'refresh') {
            //     _refresh();
            //   }
          }),
      body: BlocConsumer(
          bloc: _b2bStoreBloc,
          listener: (context, state) {
            if (state is RestockSubscriptionsLoading) {}
            if (state is RestockSubscriptionsSuccess) {
              EasyLoading.dismiss();
              EasyLoading.showSuccess("Notification set successfully");
              _refresh2();
            }
            if (state is RestockSubscriptionsError) {
              EasyLoading.dismiss();
              EasyLoading.showError(state.error);
            }
            if (state is B2BStoreLoading) {}
            if (state is CartLoading) {
              EasyLoading.show(status: 'Loading...');
            }
            if (state is CartSuccess) {
              EasyLoading.dismiss();
              cartData = state.cartData;
              setState(() {});
            }
            if (state is B2BStoreError) {
              EasyLoading.dismiss();
              EasyLoading.showError(state.error);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: [
                // SizedBox(height: 10.h,),
                Row(
                  children: [
                    Text("All Products",
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, 'refresh');
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 10,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            MyTaskListConstants.BACK.tr(),
                            style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.greyCircleColor,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                // Text("All Products", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),),
                SizedBox(
                  height: 10.h,
                ),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.5,
                  ),
                  itemCount: widget.products.length,
                  itemBuilder: (context, index) {
                    final product = widget.products[index];

                    int productCount = 0;
                    cartData?.cart.items?.forEach((i) {
                      if (i.variantId == product.variants[0].id) {
                        productCount = i.quantity!;
                      }
                    });
                    return GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(
                              categoryId: product.categories!.first.id,
                              productData: product,
                              isSelected: _b2bStoreBloc.favIds
                                  .any((e) => e.containsKey(product.id)),
                              productIdforWishList: _b2bStoreBloc.favIds
                                      .any((e) => e.containsKey(product.id))
                                  ? _b2bStoreBloc.favIds
                                      .firstWhere((e) =>
                                          e.entries.first.key == product.id)
                                      .entries
                                      .first
                                      .value
                                  : "",
                            ),
                          ),
                        );
                        if (result != null && result == 'refresh') {
                          _refresh();
                          print(
                              'Returned from Page B with refresh signal (or physical back).');
                        } else {
                          _refresh();
                          print(
                              'Returned from Page B without refresh signal or cancelled.');
                        }
                      },
                      child: Container(
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 80.h,
                                  width: 80.h,
                                  decoration: BoxDecoration(
                                      color: AppColors.themeBackground,
                                      borderRadius: BorderRadius.circular(12.r),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: AppColors.greyShadowColor,
                                          blurRadius: 5.0,
                                          spreadRadius: 0.5,
                                          offset: Offset(0, 2),
                                        ),
                                        BoxShadow(
                                          color: AppColors.greyShadowColor,
                                          blurRadius: 5.0,
                                          spreadRadius: 0.5,
                                          offset: Offset(0, -1),
                                        ),
                                      ]),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: Image.network(
                                      product.thumbnail ?? '',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                product.variants.first.options?.first.value ==
                                        "Default option value"
                                    ? Container()
                                    : Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3.r),
                                          color: AppColors.lightCyanColor,
                                        ),
                                        child: Text(
                                          product.variants.first.options?.first
                                                  .value ??
                                              "",
                                          style: AppTextStyle.font10bold,
                                        ),
                                      ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  product.title ?? "",
                                  style: TextStyle(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    RatingWidget(
                                      ratingValue: product.averageRating,
                                      starSize: 10,
                                      starSpacing: 5,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      "(${product.reviewCount ?? 0})",
                                      style: AppTextStyle.font10bold,
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
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "MRP ${product.variants.first.calculatedPrice!.originalAmount.toString()}",
                                      style: TextStyle(
                                          decoration:
                                              product.discountable ?? false
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textgreyColor),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            if (product.variants.first.inventoryQuantity == 0)
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 0.3, sigmaY: 0.3),
                                    child: Container(
                                      color: Colors.white.withOpacity(0.4),
                                    ),
                                  ),
                                ),
                              ),
                            Positioned(
                                right: 0,
                                top: 80,
                                child: InkWell(
                                  onTap: () async {
                                    if (product
                                            .variants.first.inventoryQuantity ==
                                        0) return;

                                    _b2bStoreBloc.add(AddToCart(
                                        quantity: 1,
                                        variant_id: product.variants[0].id));
                                    await Future.delayed(
                                        const Duration(milliseconds: 500),
                                        () {});
                                  },
                                  borderRadius: BorderRadius.circular(3.r),
                                  child: AnimatedContainer(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.buttonColor,
                                            width: 1.5),
                                        color: productCount == 0
                                            ? AppColors.themeBackground
                                            : AppColors.lightCyanColor,
                                        borderRadius:
                                            BorderRadius.circular(3.r)),
                                    duration: const Duration(milliseconds: 500),
                                    child: Center(
                                      child: product.variants.first
                                                  .inventoryQuantity ==
                                              0
                                          ? InkWell(
                                              onTap: () {
                                                _b2bStoreBloc.add(
                                                  RestockSubscriptionsEvent(
                                                    phoneNumber: globalStorage
                                                        .getClientMobileNo(),
                                                    variantId:
                                                        product.variants[0].id!,
                                                  ),
                                                );
                                              },
                                              child: product.variants.first
                                                          .hasRestockSubscription ==
                                                      false
                                                  ? Text(
                                                      "Notify",
                                                      style: AppTextStyle
                                                          .font10bold,
                                                    )
                                                  : Text(
                                                      "Notified",
                                                      style: AppTextStyle
                                                          .font10bold,
                                                    ),
                                            )
                                          : productCount == 0
                                              ? Text(
                                                  "Add",
                                                  style:
                                                      AppTextStyle.font10bold,
                                                )
                                              : Row(
                                                  spacing: 10,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        if (productCount == 0)
                                                          return;

                                                        productCount == 0
                                                            ? EasyLoading.showError(
                                                                "Product count cannot be less than 0")
                                                            : null;
                                                        cartData?.cart.items
                                                            ?.forEach((i) {
                                                          if (i.variantId ==
                                                              product
                                                                  .variants[0]
                                                                  .id) {
                                                            productCount -= 1;
                                                            _b2bStoreBloc.add(
                                                                AddRemoveItemReq(
                                                                    count:
                                                                        productCount,
                                                                    itemId:
                                                                        i.id ??
                                                                            ""));
                                                          }
                                                        });
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            border: Border.all(
                                                                width: 1,
                                                                color: AppColors
                                                                    .black)),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 2,
                                                                horizontal: 2),
                                                        child: const Icon(
                                                          Icons.remove,
                                                          size: 8,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      productCount.toString(),
                                                      style:
                                                          AppTextStyle.font10,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        cartData?.cart.items
                                                            ?.forEach((i) {
                                                          if (i.variantId ==
                                                              product
                                                                  .variants[0]
                                                                  .id) {
                                                            productCount += 1;
                                                            _b2bStoreBloc.add(
                                                                AddRemoveItemReq(
                                                                    count:
                                                                        productCount,
                                                                    itemId:
                                                                        i.id ??
                                                                            ""));
                                                          }
                                                        });
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            border: Border.all(
                                                                width: 1,
                                                                color: AppColors
                                                                    .black)),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 2,
                                                                horizontal: 2),
                                                        child: const Icon(
                                                          Icons.add,
                                                          size: 10,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                    ),
                                  ),
                                )),
                            product.variants.first.inventoryQuantity == 0
                                ? Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5.w, vertical: 2.h),
                                      decoration: BoxDecoration(
                                        color: AppColors.lightCyanColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        "Out of Stock",
                                        style: TextStyle(
                                            fontSize: 6.sp,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.black),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 60.h,
                ),
              ]),
            );
          }),
    );
  }
}
