import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_bloc.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_event.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_state.dart';
import 'package:woloo_smart_hygiene/b2b_store/custom_widget/start_rating.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/product_collections.dart';
import 'package:woloo_smart_hygiene/b2b_store/product_details.dart';
import 'package:woloo_smart_hygiene/hygine_services/view/address_notifier.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:woloo_smart_hygiene/utils/logger.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    this.suggestions = const [],
  });
  final List<String> suggestions;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final B2bStoreBloc _b2bStoreBloc = B2bStoreBloc();
  // B2BStoreHomePage? _b2bStoreHomePage;
  bool _isDataLoaded = false;
  List<XYProduct> products = [];
  List<String> filteredSuggestions = [];
  final searchTEC = TextEditingController();
  OverlayEntry? _overlayEntry;
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  CartModel? cartData;
  _refresh() {
    _b2bStoreBloc.add(const GetCartData());
  }

  @override
  void initState() {
    _b2bStoreBloc.add(const GetCartData());
    super.initState();
    searchTEC.addListener(() {
      final query = searchTEC.text.toLowerCase();
      if (query.isEmpty) {
        setState(() {
          filteredSuggestions = [];
        });
        _overlayEntry?.remove();
        _overlayEntry = null;
        return;
      } else if (query.length > 2) {
        setState(() {
          filteredSuggestions = widget.suggestions
              .where((item) => item.toLowerCase().contains(query))
              .toList();
        });

        _overlayEntry?.remove();
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry!);
      }
    });

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width - 40,
        right: 20,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(20, 60),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            child: ListView.builder(
              itemCount: filteredSuggestions.length,
              itemBuilder: (context, index) {
                final suggestion = filteredSuggestions[index];

                return ListTile(
                  title: Text(suggestion),
                  onTap: () {
                    searchTEC.text = suggestion;
                    _b2bStoreBloc.add(SearchProductEvent(query: suggestion));
                    _overlayEntry?.remove();
                    _overlayEntry = null;
                    _focusNode.unfocus();
                  },
                );
              },
              padding: EdgeInsets.zero,
              shrinkWrap: true,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchTEC.dispose();
    _focusNode.dispose();
    _overlayEntry?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: _b2bStoreBloc,
        listener: (context, state) {
          if (state is RestockSubscriptionsLoading) {}
          if (state is RestockSubscriptionsSuccess) {
            EasyLoading.dismiss();
            EasyLoading.showSuccess("Notification set successfully");
          }
          if (state is RestockSubscriptionsError) {
            EasyLoading.dismiss();
            EasyLoading.showError(state.error);
          }
          if (state is B2BStoreLoading) {}
          if (state is CartLoading) {}
          if (state is CartSuccess) {
            cartData = state.cartData;
          }

          if (state is SearchProductSuccess) {
            // Add search query to recent searches in local storage
            final box = GetStorage();
            List<String> recentSearches =
                (box.read<List>('recent_searches') ?? []).cast<String>();
            // if (!recentSearches.contains(searchTEC.text) &&
            //     searchTEC.text.isNotEmpty) {
            // recentSearches.insert(0, searchTEC.text);
            // Keep only last 10 searches
            // if (recentSearches.length > 10) {
            recentSearches.add(state.products.first.id ?? "");
            recentSearches.reversed;
            // }
            box.write('recent_searches', recentSearches);
            // }

            // Filter products based on whether their IDs exist in recent_searches local storage
            List<XYProduct> filteredProducts = [];
            for (var product in state.products) {
              // Check if product ID exists in recent_searches
              bool isProductInRecentSearches =
                  recentSearches.contains(product.id);

              // Only include products that are saved in recent_searches
              if (isProductInRecentSearches) {
                filteredProducts.add(product);
              }
            }

            setState(() {
              _isDataLoaded = true;
              products = filteredProducts;
            });
          }

          if (state is B2BStoreError) {
            EasyLoading.dismiss();
            EasyLoading.showError(state.error);
          }
        },
        builder: (context, snapshot) {
          return PopScope(
            canPop: false,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leadingWidth: 100,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context, 'refresh');
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
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50.h),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            decoration: BoxDecoration(
                              color: AppColors.themeBackground,
                              borderRadius: BorderRadius.circular(8.r),
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
                              ],
                            ),
                            child: CompositedTransformTarget(
                              link: _layerLink,
                              child: TextField(
                                controller: searchTEC,
                                onChanged: (value) {},
                                decoration: InputDecoration(
                                  hintText: "Search Products",
                                  filled: true,
                                  fillColor: AppColors.themeBackground,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: const Icon(Icons.search,
                                      color: AppColors.textgreyColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                                Text("All Products",
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold)),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context, 'refresh');
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
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];

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
                                        builder: (context) =>
                                            ProductDetailsScreen(
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              height: 80.h,
                                              width: 80.h,
                                              decoration: BoxDecoration(
                                                  color:
                                                      AppColors.themeBackground,
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
                                                    BorderRadius.circular(12.r),
                                                child: Image.network(
                                                  product.thumbnail ?? '',
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
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
                                            ),
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
                                                  emptyIcon: Icons.star_border,
                                                  onChanged: (a) {},
                                                  displayRatingValue: true,
                                                  interactiveTooltips: true,
                                                  customFilledIcon: Icons.star,
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
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
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
                                                          child: Text(
                                                            "Notify",
                                                            style: AppTextStyle
                                                                .font10bold,
                                                          ),
                                                        )
                                                      : productCount == 0
                                                          ? Text(
                                                              "Add",
                                                              style: AppTextStyle
                                                                  .font10bold,
                                                            )
                                                          : Row(
                                                              spacing: 10,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    if (productCount ==
                                                                        0)
                                                                      return;

                                                                    productCount ==
                                                                            0
                                                                        ? EasyLoading.showError(
                                                                            "Product count cannot be less than 0")
                                                                        : null;
                                                                    cartData
                                                                        ?.cart
                                                                        .items
                                                                        ?.forEach(
                                                                            (i) {
                                                                      if (i.variantId ==
                                                                          product
                                                                              .variants[0]
                                                                              .id) {
                                                                        productCount -=
                                                                            1;
                                                                        _b2bStoreBloc.add(AddRemoveItemReq(
                                                                            count:
                                                                                productCount,
                                                                            itemId:
                                                                                i.id ?? ""));
                                                                      }
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                4),
                                                                        border: Border.all(
                                                                            width:
                                                                                1,
                                                                            color:
                                                                                AppColors.black)),
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
                                                                  style:
                                                                      AppTextStyle
                                                                          .font10,
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    cartData
                                                                        ?.cart
                                                                        .items
                                                                        ?.forEach(
                                                                            (i) {
                                                                      if (i.variantId ==
                                                                          product
                                                                              .variants[0]
                                                                              .id) {
                                                                        productCount +=
                                                                            1;
                                                                        _b2bStoreBloc.add(AddRemoveItemReq(
                                                                            count:
                                                                                productCount,
                                                                            itemId:
                                                                                i.id ?? ""));
                                                                      }
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                4),
                                                                        border: Border.all(
                                                                            width:
                                                                                1,
                                                                            color:
                                                                                AppColors.black)),
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            2,
                                                                        horizontal:
                                                                            2),
                                                                    child:
                                                                        const Icon(
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
                                        product.variants.first
                                                    .inventoryQuantity ==
                                                0
                                            ? Align(
                                                alignment: Alignment.topCenter,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
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
