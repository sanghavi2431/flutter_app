import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:woloo_smart_hygiene/b2b_store/address_change_bottomsheet.dart';
import 'package:woloo_smart_hygiene/b2b_store/all_orders.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_bloc.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_event.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_state.dart';
import 'package:woloo_smart_hygiene/b2b_store/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/collections.dart';
import 'package:woloo_smart_hygiene/b2b_store/common_collections.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/address.dart';
import 'package:woloo_smart_hygiene/b2b_store/product_details.dart';
import 'package:woloo_smart_hygiene/b2b_store/search.dart';
import 'package:woloo_smart_hygiene/b2b_store/wishlist.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/subcription/view/clientprofile.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/enums/product_mode.dart';
import 'package:woloo_smart_hygiene/extensions/string_extension.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/list.dart';

import '../hygine_services/view/address_notifier.dart';
import '../utils/app_textstyle.dart';
import 'custom_widget/start_rating.dart';

enum EcomTab { seeLess, seeAll }

class EcomScreen extends StatefulWidget {
  const EcomScreen({super.key});

  @override
  State<EcomScreen> createState() => _EcomScreenState();
}

class _EcomScreenState extends State<EcomScreen> {
  B2BStoreHomePage? _b2bStoreHomePage;
  bool _isDataLoaded = false;
  final B2bStoreBloc _b2bStoreBloc = B2bStoreBloc();
  EcomTab tab = EcomTab.seeLess;
  int currentIndex = 0;
  Addresses? address;
  final box = GetStorage();
  final focus = FocusNode();
  GlobalStorage globalStorage = GetIt.instance();

  @override
  void initState() {
    _b2bStoreBloc.add(StoreCustomerLoginReq(
        email: globalStorage.getEmail(),
        pass: globalStorage.getPassword(),
        isfromlogin: false));
    super.initState();
    // address = getAddress();
  }

  _refresh() {
    _b2bStoreBloc.add(const Refresh(slug: "collection_id"));
    focus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: _b2bStoreBloc,
        listener: (context, state) {
          // print("dssa $state");
          if (state is B2BStoreLoading) {
            EasyLoading.show(status: state.message);
          }
          if (state is CartLoading) {
            EasyLoading.show(status: state.message);
          }
          if (state is B2BStoreSuccess) {
            EasyLoading.dismiss();
            setState(() {
              _b2bStoreHomePage = state.dashboardData;

              _isDataLoaded = true;

              // _dashboardData = state.dashboardData;
            });
          }
          if (state is WishlistSuccess) {
            EasyLoading.dismiss();
            _refresh();
          }
          if (state is CartSuccess) {
            EasyLoading.dismiss();
            _refresh();
          }
          if (state is B2BStoreError) {
            EasyLoading.dismiss();
            EasyLoading.showError(state.error);
          }
          if (state is RestockSubscriptionsLoading) {
            EasyLoading.show(status: state.message);
          }
          if (state is RestockSubscriptionsSuccess) {
            EasyLoading.dismiss();
            EasyLoading.showSuccess("Notification set successfully");
          }
          if (state is RestockSubscriptionsError) {
            EasyLoading.dismiss();
            EasyLoading.showError(state.error);
          }
        },
        builder: (context, snapshot) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            // bottomNavigationBar: const XBottomBar(),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     //logger.w("Cart ID: ${box.read('cart_id')}");
            //     // box.read('login_jwt')
            //     //logger.w("Bearer: ${box.read('login_jwt')}");
            //   },
            //   child: const Icon(Icons.abc),
            // ),
            appBar: EComAppbar(
              userShowed: true,
              focus: focus,
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
                  ? _b2bStoreHomePage?.cartData.cart.items?.length
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
            body: SingleChildScrollView(
              child: _isDataLoaded
                  ? Column(
                      children: [
                        // TextField(focusNode: FocusNode(),),
                        // CategoriesSection(
                        //   productCategory: _b2bStoreHomePage!.productCategory,
                        // ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 10.h),
                          decoration: const BoxDecoration(
                            color: AppColors.containerTabColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Categories',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              SizedBox(
                                height: 100.h,
                                child: ListView.separated(
                                  itemCount: _b2bStoreHomePage!.productCategory
                                              .productCategories !=
                                          null
                                      ? _b2bStoreHomePage!.productCategory
                                          .productCategories!.length
                                      : 0,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final category = Category(
                                      name: _b2bStoreHomePage!.productCategory
                                              .productCategories?[index].name ??
                                          '',
                                      imageUrl: _b2bStoreHomePage!
                                              .productCategory
                                              .productCategories?[index]
                                              .metadata
                                              ?.image ??
                                          '',
                                      color: Color(int.tryParse(
                                              "0xFF${_b2bStoreHomePage!.productCategory.productCategories?[index].metadata?.backgroundColor}") ??
                                          00000),
                                    );
                                    return InkWell(
                                      // onTap: () {
                                      onTap: () async {
                                        final value = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (c) =>
                                                    CommonCollectionsScreen(
                                                      id: _b2bStoreHomePage!
                                                              .productCategory
                                                              .productCategories![
                                                                  index]
                                                              .id ??
                                                          "",
                                                      slug: "category_id",
                                                      // products: _b2bStoreHomePage!
                                                      //     .productCollections
                                                      //     .products,
                                                    )));
                                        if (value != null &&
                                            value == 'refresh') {
                                          _refresh();
                                        }
                                      },
                                      //               )
                                      // CommonCollectionsScreen();
                                      // },
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 36.5.r,
                                            backgroundColor: category.color,
                                            child: Center(
                                              child: category
                                                      .imageUrl.isEmptyOrNull
                                                  ? Image.asset(
                                                      AppImages.woloologo,
                                                      width: 40.w,
                                                      height: 40.h,
                                                    )
                                                  : Image.network(
                                                      category.imageUrl,
                                                      width: 40.w,
                                                      height: 40.h,
                                                      fit: BoxFit.fill,
                                                    ),
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(
                                            category.name,
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      width: 10.w,
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),

                        Container(
                          color: AppColors.themeBackground,
                          padding: EdgeInsets.symmetric(
                              vertical: 16.h, horizontal: 20.w),
                          child: Row(
                            children: [
                              Expanded(
                                  child: XTabButton(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AllOrderScreen(),
                                          ),
                                        );
                                      },
                                      logo: AppImages.bag,
                                      label: "Order")),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                  child: XTabButton(
                                      onTap: () async {
                                        final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (c) => WishListScreen(
                                                      productData:
                                                          _b2bStoreHomePage!
                                                              .productCollections
                                                              .products,

                                                      //          _b2bStoreBloc.favIds
                                                      // .any((e) =>
                                                      //     e.containsKey(product.id))
                                                    )));
                                        if (result != null &&
                                            result == 'refresh') {
                                          _refresh();
                                          print(
                                              'Returned from Page B with refresh signal (or physical back).');
                                        } else {
                                          _refresh();
                                          print(
                                              'Returned from Page B without refresh signal or cancelled.');
                                        }
                                      },
                                      logo: AppImages.favourites,
                                      label: "Favourites")),
                            ],
                          ),
                        ),
                        // LandingProducts(
                        //   favIds: _b2bStoreBloc.favIds,
                        //   topBrands: _b2bStoreHomePage!.topBrands,
                        //   productCollections:
                        //       _b2bStoreHomePage!.productCollections,
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (c) => CollectionsScreen(
                        //                   products: _b2bStoreHomePage!
                        //                       .productCollections.products,
                        //                 )));
                        //   },
                        // ),
                        Container(
                          color: AppColors.themeBackground,
                          padding: EdgeInsets.symmetric(
                              vertical: 16.h, horizontal: 20.w),
                          child: Column(
                            spacing: 10.h,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Top Brands",
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  const SeeMoreButton()
                                ],
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1.0,
                                ),
                                itemCount: _b2bStoreHomePage!
                                    .topBrands.collections!.length,
                                //          >
                                //     6
                                // ? 6
                                // : _b2bStoreHomePage!.topBrands.collections!
                                //     .length, //.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () async {
                                      final value = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (c) =>
                                                  CommonCollectionsScreen(
                                                    id: _b2bStoreHomePage!
                                                            .topBrands
                                                            .collections![index]
                                                            .id ??
                                                        "",
                                                    slug: "collection_id",

                                                    // products: _b2bStoreHomePage!
                                                    //     .productCollections
                                                    //     .products,
                                                  )));
                                      if (value != null && value == 'refresh') {
                                        _refresh();
                                      }
                                    },
                                    child: BrandsGrid(
                                      imageUrl: _b2bStoreHomePage!
                                              .topBrands
                                              .collections![index]
                                              .metadata
                                              ?.image ??
                                          '',
                                    ),
                                  );
                                },
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Collections",
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  SeeMoreButton(
                                    onTap: () async {
                                      final value = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (c) =>
                                                  const CommonCollectionsScreen(
                                                    slug: '', id: '',
                                                    // products: _b2bStoreHomePage!
                                                    //     .productCollections
                                                    //     .products,
                                                  )));
                                      if (value != null && value == 'refresh') {
                                        _refresh();
                                      }
                                    },
                                  )
                                ],
                              ),

                              //product collections
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
                                itemCount: _b2bStoreHomePage!.productCollections
                                            .products.length >
                                        9
                                    ? 9
                                    : _b2bStoreHomePage!
                                        .productCollections.products.length,
                                itemBuilder: (context, index) {
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
                                            productData: product,
                                            isSelected: _b2bStoreBloc.favIds
                                                .any((e) =>
                                                    e.containsKey(product.id)),
                                            productIdforWishList: _b2bStoreBloc
                                                    .favIds
                                                    .any((e) => e.containsKey(
                                                        product.id))
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
                                      if (result != null &&
                                          result == 'refresh') {
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
                                                            BorderRadius
                                                                .circular(3.r),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
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
                                                    "\u{20B9}${product.variants.first.calculatedPrice!.calculatedAmount.toString()}/-",
                                                    style: TextStyle(
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  //TODO: Check Price Logic -- Abar asibo fire
                                                  product
                                                              .variants
                                                              .first
                                                              .calculatedPrice!
                                                              .originalAmount !=
                                                          product
                                                              .variants
                                                              .first
                                                              .calculatedPrice!
                                                              .calculatedAmount
                                                      ? Text(
                                                          "MRP ${product.variants.first.calculatedPrice!.originalAmount.toString()}",
                                                          style: TextStyle(
                                                              decoration: product
                                                                          .discountable ??
                                                                      false
                                                                  ? TextDecoration
                                                                      .lineThrough
                                                                  : null,
                                                              fontSize: 10.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors
                                                                  .textgreyColor),
                                                        )
                                                      : const SizedBox(),
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
                                                  // //logger.w(
                                                  //     "Selected Address: ${selectedAddress.value.id}");
                                                  if (selectedAddress
                                                          .value.id ==
                                                      null) {
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
                                                  }
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
                                                                      _b2bStoreHomePage
                                                                          ?.cartData
                                                                          .cart
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
                                                                      _b2bStoreHomePage
                                                                          ?.cartData
                                                                          .cart
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

// product.tags.first.value

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
                                              : product.tags?.isNotEmpty == true
                                                  ? Align(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5.w,
                                                                vertical: 2.h),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .lightCyanColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                        child: Text(
                                                          "${product.tags?.first.value}",
                                                          style: TextStyle(
                                                              fontSize: 6.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors
                                                                  .black),
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

                                    //  GridItem(
                                    //   productCount: productCount,
                                    //   b2bStoreBloc: _b2bStoreBloc,
                                    //   products: product,
                                    //   cartModel:  _b2bStoreHomePage?.cartData.cart,

                                    //   isSelected: _b2bStoreBloc.favIds.any(
                                    //       (e) => e.containsKey(product.id)),
                                    //   productIdforWishList: _b2bStoreBloc.favIds
                                    //           .any((e) =>
                                    //               e.containsKey(product.id))
                                    //       ? _b2bStoreBloc.favIds
                                    //           .firstWhere((e) =>
                                    //               e.entries.first.key ==
                                    //               product.id)
                                    //           .entries
                                    //           .first
                                    //           .value
                                    //       : "",
                                    //   // imageUrl: productCollections.products![index].thumbnail ?? '',
                                    // ),
                                  );
                                },
                              ),

                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                "New in Store",
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              //latest 6 from products
                              SizedBox(
                                height: 130.h,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 6,
                                  //  _b2bStoreHomePage!
                                  //     .productCollections.products.length,
                                  itemBuilder: (c, i) {
                                    final product = _b2bStoreHomePage!
                                        .productCollections.products[i];
                                    final products = _b2bStoreHomePage!
                                        .productCollections.products
                                        .toList()
                                      ..sort((a, b) {
                                        final aDate = a.createdAt ??
                                            DateTime.fromMillisecondsSinceEpoch(
                                                0);
                                        final bDate = b.createdAt ??
                                            DateTime.fromMillisecondsSinceEpoch(
                                                0);
                                        return bDate.compareTo(aDate);
                                      });
                                    final latestProducts =
                                        products.take(6).toList();
                                    return InkWell(
                                      // onTap: () {

                                      onTap: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailsScreen(
                                              productData: latestProducts[i],
                                              isSelected: _b2bStoreBloc.favIds
                                                  .any((e) => e.containsKey(
                                                      latestProducts[i].id)),
                                              productIdforWishList:
                                                  _b2bStoreBloc.favIds.any(
                                                          (e) => e.containsKey(
                                                              latestProducts[i]
                                                                  .id))
                                                      ? _b2bStoreBloc.favIds
                                                          .firstWhere((e) =>
                                                              e.entries.first
                                                                  .key ==
                                                              latestProducts[i]
                                                                  .id)
                                                          .entries
                                                          .first
                                                          .value
                                                      : "",
                                            ),
                                          ),
                                        );
                                        if (result != null &&
                                            result == 'refresh') {
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
                                      // },
                                      child: SizedBox(
                                        width: 280.w,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          child: latestProducts[i]
                                                      .thumbnail
                                                      ?.isEmpty ??
                                                  true
                                              ? Image.asset(AppImages.woloologo)
                                              : Image.network(
                                                  latestProducts[i].thumbnail ??
                                                      '',
                                                  fit: BoxFit.fill,
                                                ),
                                        ),
                                      ),
                                    );
                                  },
                                  // ClipRRect(
                                  //     borderRadius:
                                  //         BorderRadius.circular(25.r),
                                  //     child:
                                  //         Image.asset(AppImages.bTemplate)),

                                  separatorBuilder: (c, i) => const SizedBox(
                                    width: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 70.h,
                        ),
                      ],
                    )
                  : Container(),
            ),
          );
        });
  }

  Addresses? getAddress() {
    final addressData = box.read("address");
    //logger.w(addressData);
    address = Addresses.fromJson(jsonDecode(addressData ?? ""));
    //logger.w(address);
    // address = Addresses.fromJson(jsonDecode(addressData));
    // print(address);
    // setState(() {});
    return address;
  }
}

class XTabButton extends StatelessWidget {
  const XTabButton({
    super.key,
    required this.logo,
    required this.label,
    this.onTap,
  });
  final String logo;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.buttonYellowColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          spacing: 10,
          children: [
            ImageIcon(
              AssetImage(logo),
              size: 20,
            ),
            Text(
              label,
              style: AppTextStyle.font14bold,
            )
          ],
        ),
      ),
    );
  }
}

class BrandsGrid extends StatelessWidget {
  const BrandsGrid({super.key, required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.r),
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
        borderRadius: BorderRadius.circular(25.r),
        child: imageUrl.isEmpty
            ? Image.asset(AppImages.woloologo)
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.fill,
              ),
      ),
    );
  }
}

// class AddToCartButton extends StatelessWidget {
//   const AddToCartButton({
//     super.key,
//     this.onTap,
//   });
//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(3.r),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
//         decoration: BoxDecoration(
//             color: AppColors.buttonColor,
//             borderRadius: BorderRadius.circular(3.r)),
//         child: Row(
//           children: [
//             Icon(
//               Icons.shopping_cart_outlined,
//               color: AppColors.black,
//               size: 10.sp,
//             ),
//             SizedBox(
//               width: 5.w,
//             ),
//             Text(
//               "Add to Cart",
//               style: TextStyle(
//                   fontSize: 8.sp,
//                   color: AppColors.black,
//                   fontWeight: FontWeight.bold),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class SeeMoreButton extends StatelessWidget {
  const SeeMoreButton({
    super.key,
    this.onTap,
  });
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "See More",
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.greyCircleColor,
            ),
          ),
          SizedBox(
            width: 5.w,
          ),
          Container(
            height: 15.h,
            width: 15.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.greyCircleColor,
                width: 1.5,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.black,
                size: 12,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class EComAppbar extends StatelessWidget implements PreferredSizeWidget {
  const EComAppbar(
      {super.key,
      this.isAll = false,
      this.textFieldHintText = 'Search Products',
      this.cartValue,
      this.productMode = ProductMode.productDetails,
      this.onTap,
      this.onFilterTap,
      this.onChanged,
      this.controller,
      this.onCartTap,
      this.focus,
      this.userShowed = false});
  final ProductMode productMode;

  final String textFieldHintText;
  final bool isAll;
  final VoidCallback? onFilterTap;
  final VoidCallback? onTap;
  final VoidCallback? onCartTap;
  final int? cartValue;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final FocusNode? focus;
  final bool userShowed;
  @override
  Size get preferredSize => const Size.fromHeight(130);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Remove default back button
      backgroundColor: AppColors.themeBackground,
      actions: [
        if (userShowed)
          Container(
            decoration: BoxDecoration(
                color: AppColors.lightCyanColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(2, 3),
                      color: Color.fromARGB(255, 230, 228, 228),
                      spreadRadius: 2,
                      blurRadius: 10),
                ]),
            child: IconButton(
              icon: const Icon(Icons.person_outlined),
              onPressed: () {
                // refreshCart(context);
                //  TODO:Add Profile
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Clientprofile(),
                    ));
              },
            ),
          ),
        const SizedBox(
          width: 10,
        )
      ],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Address Name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder<Addresses>(
                  valueListenable: selectedAddress,
                  builder: (context, value, child) {
                    return Text(
                      value.addressName.isEmptyOrNull
                          ? "Select Address"
                          : value.addressName!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
                  }),
              InkWell(
                onTap: () => showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: true,
                  enableDrag: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (_) => AddressChangeBottomSheet(
                    productMode: productMode,
                  ),
                ),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 200.w),
                  child: Row(
                    children: [
                      Flexible(
                        child: ValueListenableBuilder<Addresses>(
                          valueListenable: selectedAddress,
                          builder: (context, value, child) {
                            return Text(
                              value.address1.isEmptyOrNull
                                  ? "Select New Address"
                                  : value.address1!,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            shape: BoxShape.circle),
                        child: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Cart Icon
            ],
          ),
          SizedBox(),
          // Address Selector with Arrow
          if (isAll)
            cartValue != 0
                ? Badge(
                    label: Text(cartValue.toString()),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(2, 3),
                                color: Color.fromARGB(255, 230, 228, 228),
                                spreadRadius: 2,
                                blurRadius: 10),
                          ]),
                      child: IconButton(
                          icon: ImageIcon(AssetImage(AppImages.bag)),
                          onPressed: onCartTap),
                    ),
                  )
                : Badge(
                    label: const Text("0"),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(2, 3),
                                color: Color.fromARGB(255, 230, 228, 228),
                                spreadRadius: 2,
                                blurRadius: 10),
                          ]),
                      child: IconButton(
                        icon: ImageIcon(AssetImage(AppImages.bag)),
                        onPressed: () {
                          if (cartValue != null && cartValue! > 0) {
                            onCartTap?.call();
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 50.w, vertical: 60.h),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            spreadRadius: 1,
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Your cart is empty. Please add items to cart",
                                            style: AppTextStyle.font14bold,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 20),
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 40.w,
                                                  vertical: 4.h),
                                              decoration: BoxDecoration(
                                                color: AppColors.lightCyanColor,
                                                borderRadius:
                                                    BorderRadius.circular(4.r),
                                              ),
                                              child: Text(
                                                "close",
                                                style: AppTextStyle.font14bold,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }
                        },
                      ),
                    ),
                  ),
        ],
      ),

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
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
                  child: TextField(
                    onTap: onTap,
                    readOnly: true,
                    focusNode: focus,
                    controller: controller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.themeBackground,
                      hintText: textFieldHintText,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    enableSuggestions: true,
                    onChanged: onChanged,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              if (isAll) ...[
                InkWell(
                  onTap: onFilterTap,
                  child: Container(
                    height: 41.h,
                    width: 41.h,
                    decoration: const BoxDecoration(
                      color: AppColors.themeBackground,
                      shape: BoxShape.circle,
                      boxShadow: [
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
                    child: Center(
                      child: Image.asset(
                        AppImages.tuneLogo,
                        height: 20.h,
                        width: 20.w,
                      ),
                    ),
                  ),
                )
              ],
              if (!isAll) ...[
                cartValue != 0
                    ? Badge(
                        label: Text(cartValue.toString()),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(2, 3),
                                    color: Color.fromARGB(255, 230, 228, 228),
                                    spreadRadius: 2,
                                    blurRadius: 10),
                              ]),
                          child: IconButton(
                              icon: ImageIcon(AssetImage(AppImages.bag)),
                              onPressed: onCartTap),
                        ),
                      )
                    : Badge(
                        label: const Text("0"),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(2, 3),
                                    color: Color.fromARGB(255, 230, 228, 228),
                                    spreadRadius: 2,
                                    blurRadius: 10),
                              ]),
                          child: IconButton(
                            icon: ImageIcon(AssetImage(AppImages.bag)),
                            onPressed: () {
                              if (cartValue != null && cartValue! > 0) {
                                onCartTap?.call();
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 50.w, vertical: 60.h),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 10,
                                                offset: const Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Your cart is empty. Please add items to cart",
                                                style: AppTextStyle.font14bold,
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 20),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 40.w,
                                                      vertical: 4.h),
                                                  decoration: BoxDecoration(
                                                    color: AppColors
                                                        .lightCyanColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.r),
                                                  ),
                                                  child: Text(
                                                    "close",
                                                    style:
                                                        AppTextStyle.font14bold,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }
                            },
                          ),
                        ),
                      ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  // void refreshCart(context) async {
  //   final value = await Navigator.push(
  //       context, MaterialPageRoute(builder: (_) => const CartScreen()));
  //   if (value != null && value == 'refresh') {
  //     if (onTap != null) {
  //       onTap!();
  //     }
  //   }
  // }
}
