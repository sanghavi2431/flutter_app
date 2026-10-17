import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_bloc.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_event.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_state.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/product_collections.dart';
import 'package:woloo_smart_hygiene/b2b_store/product_details.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/hygine_services/view/address_notifier.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

import '../utils/app_constants.dart';
import '../utils/app_images.dart';
import '../widgets/rating_widget.dart';
import 'search_all.dart';
import 'package:easy_localization/easy_localization.dart';

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
  List<dynamic> recentSearches = [];
  List<String> filteredSuggestions = [];
  final searchTEC = TextEditingController();
  OverlayEntry? _overlayEntry;
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  CartModel? cartData;
  //  List<String> recentSearches = [];
  GlobalStorage globalStorage = GetIt.instance();
  _refresh() {
    _b2bStoreBloc.add(const GetCartData());
  }

  _refresh2() {
    _b2bStoreBloc.add(SearchProductEvent(query: searchTEC.text));
    // _b2bStoreBloc.add(const Refresh(slug: "collection_id"));
    // focus.unfocus();
  }

  @override
  void initState() {
    _b2bStoreBloc.add(const GetCartData());
    super.initState();
    recentSearches =
        //  var res =
        globalStorage.getRecentSearch();
    print("recentSearches: ${globalStorage.getRecentSearch()}");
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
        width: size.width - 80,
        right: 20,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60),
          child: Material(
            elevation: 4.0,
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            child: ListView.builder(
              itemCount: filteredSuggestions.length,
              itemBuilder: (context, index) {
                final suggestion = filteredSuggestions[index];

                return ListTile(
                  title: Text(suggestion),
                  onTap: () {
                    searchTEC.text = suggestion;

                    recentSearches.add(suggestion);
                    // recentSearches = recentSearches.reversed.toList();

                    globalStorage.saveRecentSearch(
                        recentSearch: recentSearches);

                    _b2bStoreBloc.add(SearchProductEvent(query: suggestion));
                    _overlayEntry?.remove();
                    _overlayEntry = null;
                    _focusNode.unfocus();
                    List<dynamic> search = [];
                    search = globalStorage.getRecentSearch();

                    recentSearches = search.toSet().toList();

                    recentSearches.length > 5
                        ? recentSearches.removeAt(5)
                        : null;
                    globalStorage.saveRecentSearch(
                        recentSearch: recentSearches);
                    print("recentSearches: $recentSearches");
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
            _refresh2();
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
            canPop: true,
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leadingWidth: 100,
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context, 'refresh');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.textgreyColor,
                          size: 16,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              MyTaskListConstants.BACK.tr(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textgreyColor,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(50.h),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
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
                body:
                    // _isDataLoaded
                    // ?
                    SingleChildScrollView(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.themeBackground,
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10.h,
                      children: [
                        Row(
                          children: [
                            Text("Recently Searched",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                // Clear recent searches
                                recentSearches.clear();
                                setState(() {});
                              },
                              child: const Text(
                                "Clear",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.greyCircleColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        // ListView.builder(
                        //   shrinkWrap: true,
                        //   itemCount:recentSearches.length ,
                        //   itemBuilder: (context, index) {
                        //
                        //    return
                        // recentSearches.map(toElement);
                        Wrap(
                          alignment: WrapAlignment.start,
                          runAlignment: WrapAlignment.start,
                          spacing: 8.w, // horizontal spacing
                          runSpacing: 8.h, // vertical spacing
                          children: recentSearches.map((search) {
                            return InkWell(
                              onTap: () {
                                searchTEC.text = search;
                              },
                              child: Container(
                                width: 156.w,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 5.h),
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
                                  ],
                                ),
                                child:
                                    //  Row(
                                    //   children: [
                                    //  Icon(
                                    //   Icons.,
                                    //   size: 16,
                                    //   color: AppColors.textgreyColor,),

                                    Row(
                                  children: [
                                    CustomImageProvider(
                                      image: AppImages.refresh_icon,
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Text(search,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Color(0xffC5C5C5),
                                            fontWeight: FontWeight.bold,
                                          )
                                          // ),
                                          ),
                                    ),
                                  ],
                                ),
                                //   ],
                                // ),
                              ),
                            );
                          }).toList(),
                        ),

                        //    Container(
                        //     padding: EdgeInsets.symmetric(
                        //         horizontal: 10.w, vertical: 5.h),
                        //     decoration: BoxDecoration(
                        //       color: AppColors.themeBackground,
                        //       borderRadius: BorderRadius.circular(8.r),
                        //       boxShadow: const [
                        //         BoxShadow(
                        //           color: AppColors.greyShadowColor,
                        //           blurRadius: 5.0,
                        //           spreadRadius: 0.5,
                        //           offset: Offset(0, 2),
                        //         ),

                        //       ],
                        //     ),
                        //     child: Text(recentSearches[index]));
                        // },
                        // ),

                        Row(
                          children: [
                            Text("Based on your Recent Searches",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold)),
                            const Spacer(),

                            InkWell(
                              onTap: () {
                                products.isEmpty
                                    ? null
                                    : Navigator.of(context)
                                        .push(MaterialPageRoute(
                                        builder: (context) => SearchAll(
                                          products: products,
                                        ),
                                      ));
                              },
                              child: Text("View All",
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      color: AppColors.greyCircleColor,
                                      fontWeight: FontWeight.bold)),
                            ),
                            // )
                            // GestureDetector(
                            //   onTap: () {
                            //     Navigator.pop(context, 'refresh');
                            //   },
                            //   child: const Row(
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: [
                            //       Icon(
                            //         Icons.arrow_back_ios_new_rounded,
                            //         size: 10,
                            //       ),
                            //       SizedBox(
                            //         width: 5,
                            //       ),
                            //       Text(
                            //         "Back",
                            //         style: TextStyle(
                            //             fontSize: 10,
                            //             color: AppColors.greyCircleColor,
                            //             fontWeight: FontWeight.bold),
                            //       )
                            //     ],
                            //   ),
                            // )
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
                                    builder: (context) => ProductDetailsScreen(
                                      categoryId: product.categories!.first.id,
                                      productData: product,
                                      isSelected: _b2bStoreBloc.favIds.any(
                                          (e) => e.containsKey(product.id)),
                                      productIdforWishList: _b2bStoreBloc.favIds
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
                                              color: AppColors.themeBackground,
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color:
                                                      AppColors.greyShadowColor,
                                                  blurRadius: 5.0,
                                                  spreadRadius: 0.5,
                                                  offset: Offset(0, 2),
                                                ),
                                                BoxShadow(
                                                  color:
                                                      AppColors.greyShadowColor,
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
                                        product.variants.first.options?.first
                                                    .value ==
                                                "Default option value"
                                            ? Container()
                                            : Container(
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
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            RatingWidget(
                                              ratingValue:
                                                  product.averageRating,
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
                                                      product.discountable ??
                                                              false
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : null,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      AppColors.textgreyColor),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    if (product
                                            .variants.first.inventoryQuantity ==
                                        0)
                                      Positioned.fill(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 0.3, sigmaY: 0.3),
                                            child: Container(
                                              color:
                                                  Colors.white.withOpacity(0.4),
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
                                                variant_id:
                                                    product.variants[0].id));
                                            await Future.delayed(
                                                const Duration(
                                                    milliseconds: 500),
                                                () {});
                                          },
                                          borderRadius:
                                              BorderRadius.circular(3.r),
                                          child: AnimatedContainer(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w, vertical: 2.h),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        AppColors.buttonColor,
                                                    width: 1.5),
                                                color: productCount == 0
                                                    ? AppColors.themeBackground
                                                    : AppColors.lightCyanColor,
                                                borderRadius:
                                                    BorderRadius.circular(3.r)),
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
                                                                globalStorage
                                                                    .getClientMobileNo(),
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
                                                      //  Text(
                                                      //   "Notify",
                                                      //   style: AppTextStyle
                                                      //       .font10bold,
                                                      // ),
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
                                                                    0) return;

                                                                productCount ==
                                                                        0
                                                                    ? EasyLoading
                                                                        .showError(
                                                                            "Product count cannot be less than 0")
                                                                    : null;
                                                                cartData
                                                                    ?.cart.items
                                                                    ?.forEach(
                                                                        (i) {
                                                                  if (i.variantId ==
                                                                      product
                                                                          .variants[
                                                                              0]
                                                                          .id) {
                                                                    productCount -=
                                                                        1;
                                                                    _b2bStoreBloc.add(AddRemoveItemReq(
                                                                        count:
                                                                            productCount,
                                                                        itemId: i.id ??
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
                                                                        width:
                                                                            1,
                                                                        color: AppColors
                                                                            .black)),
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 2,
                                                                    horizontal:
                                                                        2),
                                                                child:
                                                                    const Icon(
                                                                  Icons.remove,
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
                                                                    ?.cart.items
                                                                    ?.forEach(
                                                                        (i) {
                                                                  if (i.variantId ==
                                                                      product
                                                                          .variants[
                                                                              0]
                                                                          .id) {
                                                                    productCount +=
                                                                        1;
                                                                    _b2bStoreBloc.add(AddRemoveItemReq(
                                                                        count:
                                                                            productCount,
                                                                        itemId: i.id ??
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
                                                                        width:
                                                                            1,
                                                                        color: AppColors
                                                                            .black)),
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 2,
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
                                    product.variants.first.inventoryQuantity ==
                                            0
                                        ? Align(
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5.w,
                                                  vertical: 2.h),
                                              decoration: BoxDecoration(
                                                color: AppColors.lightCyanColor,
                                                borderRadius:
                                                    BorderRadius.circular(4),
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
                      ],
                    ),
                  ),
                )
                // : Container(),
                ),
          );
        });
  }
}
