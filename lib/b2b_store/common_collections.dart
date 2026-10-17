import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_bloc.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_event.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_state.dart';
import 'package:woloo_smart_hygiene/b2b_store/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/ecom.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/product_details.dart';
import 'package:woloo_smart_hygiene/b2b_store/product_details.dart';
import 'package:woloo_smart_hygiene/b2b_store/search.dart';
import 'package:woloo_smart_hygiene/hygine_services/view/address_notifier.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:easy_localization/easy_localization.dart';

import '../widgets/rating_widget.dart';

class CommonCollectionsScreen extends StatefulWidget {
  final String id;
  final String slug;
  const CommonCollectionsScreen({
    required this.slug,
    super.key,
    required this.id,
  });

  @override
  State<CommonCollectionsScreen> createState() =>
      CommonCollectionsScreenState();
}

class CommonCollectionsScreenState extends State<CommonCollectionsScreen> {
  Map<String, dynamic>? selectedFilters = {};
  final B2bStoreBloc _b2bStoreBloc = B2bStoreBloc();
  B2BStoreHomePage? _b2bStoreHomePage;
  bool _isDataLoaded = false;
  ProductCategory? _productCategories;

  List<String> sizes = [];

  _refresh() {
    _b2bStoreBloc.add(const GetCartData());
  }

  _refreshCategories() {
    _b2bStoreBloc.add(const GetProductCategoriesEvent());
  }

  _loadProductsByCategory(String categoryId, String? size) {
    print("Loading products for category: $categoryId with size: $size");
    // Using the category ID from the curl request
    // const categoryId = 'pcat_01JPH86Z9NW5QEBTSXSHZP3TYJ';
    _b2bStoreBloc
        .add(GetProductsByCategoryEvent(categoryId: categoryId, sized: size));
  }

  @override
  void initState() {
    _b2bStoreBloc.add(Refresh(slug: widget.slug, id: widget.id));
    _b2bStoreBloc.add(const GetProductCategoriesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: _b2bStoreBloc,
        listener: (context, state) {
          if (state is RestockSubscriptionsLoading) {
            EasyLoading.show(status: state.message);
          }
          if (state is RestockSubscriptionsSuccess) {
            EasyLoading.dismiss();
            EasyLoading.showSuccess("Notification set successfully");
            _b2bStoreBloc.add(Refresh(slug: widget.slug, id: widget.id));
            _b2bStoreBloc.add(const GetProductCategoriesEvent());
          }
          if (state is RestockSubscriptionsError) {
            EasyLoading.dismiss();
            EasyLoading.showError(state.error);
          }
          // print("dssa $state");
          if (state is B2BStoreLoading) {
            EasyLoading.show(status: state.message);
          }
          if (state is CartLoading) {
            EasyLoading.show(status: state.message);
          }
          if (state is CartSuccess) {
            EasyLoading.dismiss();
            setState(() {
              _b2bStoreHomePage?.cartData = state.cartData;
            });
          }
          if (state is B2BStoreSuccess) {
            EasyLoading.dismiss();
            setState(() {
              _b2bStoreHomePage = state.dashboardData;

              _isDataLoaded = true;

              // _dashboardData = state.dashboardData;
            });
          }

          if (state is B2BStoreError) {
            EasyLoading.dismiss();
            EasyLoading.showError(state.error);
          }

          if (state is ProductCategoriesLoading) {
            EasyLoading.show(status: state.message);
          }
          if (state is ProductCategoriesSuccess) {
            // EasyLoading.dismiss();
            setState(() {
              _productCategories = state.productCategories;
            });
            _b2bStoreBloc.add(const GetAllProductsEvent());
          }
          if (state is AllProductsSuccess) {
            EasyLoading.dismiss();
            // setState(() {
            // _b2bStoreHomePage?.productCollections =

            state.productCollections.products.forEach((product) {
              product.options!.forEach((option) {
                option.values!.forEach((value) {
                  sizes.add(value.value!);
                  // logger.w("Option Value: $value");
                });
              });
              // logger.w("Product: ${product.title}");
              // logger.w("Product ID: ${product.id}");
              // logger.w("Product Variants: ${product.variants.length}");
            });

            print("sizes: ${sizes.toSet().toList()} ");
            // });
            // _loadProductsByCategory(_productCategories?.productCategories?[0].id ??
            //     "");
          }

          if (state is ProductCategoriesError) {
            EasyLoading.dismiss();
            EasyLoading.showError(state.error);
          }

          if (state is ProductsByCategoryLoading) {
            EasyLoading.show(status: state.message);
          }
          if (state is ProductsByCategorySuccess) {
            EasyLoading.dismiss();
            setState(() {
              _b2bStoreHomePage?.productCollections.products =
                  state.products.products;
            });
          }
          if (state is ProductsByCategoryError) {
            EasyLoading.dismiss();
            EasyLoading.showError(state.error);
          }
        },
        builder: (context, snapshot) {
          return PopScope(
            canPop: true,
            child: Scaffold(
              // bottomNavigationBar: const XBottomBar(),
              appBar: EComAppbar(
                onFilterTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    isDismissible: true, // <-- Allow tap outside to dismiss
                    enableDrag: true, // <-- Allow swipe down to dismiss

                    backgroundColor: Colors
                        .transparent, // Optional: if you want rounded corners to show correctly

                    context: context,
                    builder: (_) => FilterBottomSheet(
                      sizes: sizes.toSet().toList(),
                      onApplyFilters: (filters) {
                        setState(() {
                          selectedFilters = filters;
                        });
                        _loadProductsByCategory(
                            selectedFilters?['categories'][0],
                            selectedFilters?['size']);
                        // size
                      },
                      productCategories: _productCategories,
                    ), //AddressBottomSheet
                  );
                },
                isAll: true,
                onChanged: (value) {
                  if (value.isEmpty) {
                    // final products =
                    //     _b2bStoreHomePage!.productCollections.products;
                  } else {
                    final products = _b2bStoreHomePage!
                        .productCollections.products
                        .where((e) =>
                            e.title
                                ?.toLowerCase()
                                .contains(value.toLowerCase()) ??
                            false)
                        .toList();
                    //logger.w("Value: $value Products: ${products.length}");
                  }

                  setState(() {});
                },
                onCartTap: () async {
                  final value = await Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const CartScreen()));
                  if (value != null && value == 'refresh') {
                    _refresh();
                  } else {
                    _refresh();
                  }
                },
                cartValue: _isDataLoaded
                    ? _b2bStoreHomePage?.cartData.cart.items?.length ?? 0
                    : 0,
                onTap: () async {
                  final value = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => SearchScreen(
                                suggestions: _b2bStoreHomePage
                                        ?.productCollections.products
                                        .map((e) => e.title ?? "")
                                        .toList() ??
                                    [],
                              )));
                  if (value != null && value == 'refresh') {
                    _refresh();
                  }
                },
              ),
              body: _isDataLoaded
                  ? SingleChildScrollView(
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
                                Text("All Products ",
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold)),
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
                              itemCount: _b2bStoreHomePage!
                                  .productCollections.products.length,
                              itemBuilder: (context, index) {
                                final variantCount = _b2bStoreHomePage!
                                    .productCollections
                                    .products[index]
                                    .variants
                                    .length;
                                final product = _b2bStoreHomePage!
                                    .productCollections.products[index];

                                int productCount = 0;
                                _b2bStoreHomePage?.cartData.cart.items
                                    ?.forEach((i) {
                                  if (i.variantId == product.variants[0].id) {
                                    productCount = i.quantity ?? 0;
                                  }
                                });
                                // AddButtonMode mode = AddButtonMode.remove;
                                return GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailsScreen(
                                          categoryId:
                                              product.categories!.first.id,
                                          productData: product,
                                          isSelected: _b2bStoreBloc.favIds.any(
                                              (e) => e.containsKey(product.id)),
                                          productIdforWishList: _b2bStoreBloc
                                                  .favIds
                                                  .any((e) =>
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
                                      _refresh();
                                      print(
                                          'Returned from Page B with refresh signal (or physical back).');
                                      // _initializeData(); // Re-initialize or refresh data
                                    } else {
                                      _refresh();
                                      print(
                                          'Returned from Page B without refresh signal or cancelled.');
                                    }
                                  },
                                  child: Container(
                                    // padding: EdgeInsets.symmetric(horizontal: 10.w),
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Stack(
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
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.r),
                                                    child: product.thumbnail
                                                                ?.isEmpty ??
                                                            true
                                                        ? Image.asset(
                                                            AppImages.woloologo)
                                                        : Image.network(
                                                            product.thumbnail ??
                                                                '',
                                                            fit: BoxFit.fill,
                                                          ),
                                                  ),
                                                ),
                                                product.variants.first
                                                            .inventoryQuantity ==
                                                        0
                                                    ? Positioned(
                                                        top: 2
                                                            .h, // or adjust based on spacing needed from top
                                                        left: 0,
                                                        right: 0,
                                                        child: Center(
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5.w,
                                                                    vertical:
                                                                        2.h),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .lightCyanColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                            ),
                                                            child: Text(
                                                              "Out of Stock",
                                                              style: TextStyle(
                                                                fontSize: 6.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            product.variants.first.options
                                                        ?.first.value ==
                                                    "Default option value"
                                                ? Container()
                                                : Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.w,
                                                            vertical: 2.h),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3.r),
                                                      color: AppColors
                                                          .lightCyanColor,
                                                    ),
                                                    child: Text(
                                                      product
                                                              .variants
                                                              .first
                                                              .options
                                                              ?.first
                                                              .value ??
                                                          "",
                                                      style: AppTextStyle
                                                          .font10bold,
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
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Row(
                                              children: [
                                                RatingWidget(
                                                  ratingValue:
                                                      product.averageRating ??
                                                          0,

                                                  // product.averageRating,
                                                  starSize: 10,
                                                  starSpacing: 4,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "(${product.reviewCount ?? 0})",
                                                  style: AppTextStyle.font10bold
                                                      .copyWith(
                                                          fontSize: 8,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                                await Future.delayed(
                                                    const Duration(
                                                        milliseconds: 500),
                                                    () {});

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
                                                            .lightCyanColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3.r)),
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                child: Center(
                                                  child: product.variants.first
                                                              .inventoryQuantity ==
                                                          0
                                                      ? InkWell(
                                                          onTap: () {
                                                            _b2bStoreBloc.add(
                                                              RestockSubscriptionsEvent(
                                                                phoneNumber:
                                                                    selectedAddress
                                                                            .value
                                                                            .phone ??
                                                                        "",
                                                                variantId: product
                                                                    .variants[0]
                                                                    .id!,
                                                              ),
                                                            );
                                                          },
                                                          child: product
                                                                      .variants
                                                                      .first
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
                                                      : productCount == 0 &&
                                                              variantCount > 1
                                                          // AddButtonMode.remove
                                                          ? Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text(
                                                                  "Add",
                                                                  style: AppTextStyle
                                                                      .font10bold,
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        1), // small gap between text and count
                                                                Text(
                                                                  "$variantCount Options",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: 5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : productCount == 0
                                                              // AddButtonMode.remove
                                                              ? Text(
                                                                  "Add",
                                                                  style: AppTextStyle
                                                                      .font10bold,
                                                                )
                                                              : Row(
                                                                  spacing: 10,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        if (productCount ==
                                                                            0)
                                                                          return;

                                                                        productCount ==
                                                                                0
                                                                            ? EasyLoading.showError("Product count cannot be less than 0")
                                                                            : null;
                                                                        _b2bStoreHomePage
                                                                            ?.cartData
                                                                            .cart
                                                                            .items
                                                                            ?.forEach((i) {
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
                                                                            borderRadius:
                                                                                BorderRadius.circular(4),
                                                                            border: Border.all(width: 1, color: AppColors.black)),
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
                                                                          size:
                                                                              8,
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
                                                                      onTap:
                                                                          () {
                                                                        // productCount += 1;
                                                                        // setState(() {});
                                                                        // if (widget.onAdd != null) {
                                                                        //   widget.onAdd!();
                                                                        // }
                                                                        //  productCount == 0
                                                                        //   ? addToCart(context)
                                                                        //   :
                                                                        // To add value
                                                                        _b2bStoreHomePage
                                                                            ?.cartData
                                                                            .cart
                                                                            .items
                                                                            ?.forEach((i) {
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
                                                                            borderRadius:
                                                                                BorderRadius.circular(4),
                                                                            border: Border.all(width: 1, color: AppColors.black)),
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
                                                                              8,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
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
                    )
                  : Container(),
            ),
          );
        });
  }
}

class FilterBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>)? onApplyFilters;
  final ProductCategory? productCategories;
  final List<String>? sizes;
  // final Map<String, dynamic>? initialFilters;

  const FilterBottomSheet({
    Key? key,
    this.onApplyFilters,
    this.productCategories,
    this.sizes,
    // this.initialFilters,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? selectedCategories;
  String? selectedSize;
  int selectedIndex = -1;

  List<Map<String, String>> get categories {
    if (widget.productCategories?.productCategories != null) {
      return widget.productCategories!.productCategories!
          .where((category) =>
              !(category.name?.toLowerCase().contains("new in store") ?? false))
          .map((category) => {
                'id': category.id ?? '',
                'name': category.name ?? '',
              })
          .toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(80),
          topRight: Radius.circular(80),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF9E9E9E),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Categories
                  _buildCategoryFilters(),

                  const SizedBox(height: 32),

                  // Size section
                  _buildSizeFilters(widget.sizes!),

                  const SizedBox(height: 36),

                  // Action buttons
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2), // Shadow color
            spreadRadius: 1, // How wide the shadow should spread
            blurRadius: 10, // The blur effect of the shadow
            offset: const Offset(
                0, 5), // Shadow offset, with y-offset for bottom shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 12,
            children: categories.map((category) {
              final isSelected = selectedCategories == category['id'];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedCategories = null;
                    } else {
                      selectedCategories = category['id'];
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withValues(alpha: 0.2), // Shadow color
                        spreadRadius: 1, // How wide the shadow should spread
                        blurRadius: 10, // The blur effect of the shadow
                        offset: const Offset(0,
                            5), // Shadow offset, with y-offset for bottom shadow
                      ),
                    ],
                    color: isSelected ? AppColors.buttonColor : AppColors.white,
                    borderRadius: BorderRadius.circular(32),
                    // border: isSelected
                    //     ? Border.all(color: const Color(0xFF1976D2), width: 1)
                    //     : null,
                  ),
                  child: Text(
                    category['name']!,
                    style: TextStyle(
                      // color:
                      // isSelected
                      //     ? const Color(0xFF1565C0)
                      //  const Color(0xFF888585),
                      // color: ,
                      fontSize: 15,

                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.bold,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeFilters(List<String> sizesList) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        // vertical: 16.h,
      ),
      // height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2), // Shadow color
            spreadRadius: 1, // How wide the shadow should spread
            blurRadius: 10, // The blur effect of the shadow
            offset: const Offset(
                0, 5), // Shadow offset, with y-offset for bottom shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Size',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(width: 150, child: Divider()),
          // const SizedBox(height: 10),
          Container(
            height: 60,
            // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            // decoration: BoxDecoration(
            //       color:
            //       // isSelected
            //           // ?
            //            const Color(0xFFE3F2FD),
            //           // : const Color(0xFFF5F5F5),
            //       borderRadius: BorderRadius.circular(32),
            //       border:
            //       //  isSelected
            //           // ?
            //           Border.all(color: const Color(0xFF1976D2), width: 1)
            //           // : null,
            //     ),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: sizesList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      selectedSize = sizesList[index];
                    },

                    // },
                    child: Container(
                        width: 150,
                        margin: const EdgeInsets.only(right: 8, left: 2),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withValues(alpha: 0.2), // Shadow color
                              spreadRadius:
                                  1, // How wide the shadow should spread
                              blurRadius: 10, // The blur effect of the shadow
                              offset: const Offset(0,
                                  5), // Shadow offset, with y-offset for bottom shadow
                            ),
                          ],
                          color: selectedIndex == index
                              ? AppColors.buttonColor
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Center(
                            child: Text(
                          sizesList[index],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            //  color: Color(0xFF888585)
                          ),
                        ))),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                //  print(object: "Selected Categories: $selectedCategories");
                print("Selected Size: $selectedSize");
                final filters = {
                  'categories':
                      selectedCategories != null ? [selectedCategories!] : [],
                  'size': selectedSize,
                };
                widget.onApplyFilters?.call(filters);
                Navigator.pop(context, filters);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF8BDFFB),
                foregroundColor: const Color(0xFF212121),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 4,
                shadowColor: Colors.black,
              ),
              child: const Text(
                'Apply',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedCategories = null;
                  selectedSize = null;
                  selectedIndex = -1;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: const Color(0xFF212121),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 4,
                shadowColor: Colors.black,
              ),
              child: const Text(
                'Reset',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
