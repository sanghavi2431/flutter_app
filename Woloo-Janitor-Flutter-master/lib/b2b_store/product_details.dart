import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:woloo_smart_hygiene/CartItemErrorDialog.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_bloc.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_event.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_state.dart';
import 'package:woloo_smart_hygiene/b2b_store/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/address.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/cart.dart' as cart_model;
import 'package:woloo_smart_hygiene/b2b_store/models/customer_reviews.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/product_collections.dart'
    as product_collections;
import 'package:woloo_smart_hygiene/extensions/string_extension.dart';
import 'package:woloo_smart_hygiene/hygine_services/view/address_notifier.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/widgets/cart_bottomsheet.dart';

import '../core/local/global_storage.dart';
import '../utils/app_constants.dart';
import '../utils/app_textstyle.dart';
import '../widgets/rating_widget.dart';
import 'address_change_bottomsheet.dart';
import 'models/product_collections.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductDetailsScreen extends StatefulWidget {
  String? categoryId;
  final product_collections.XYProduct? productData;
  ProductDetailsScreen(
      {super.key,
      this.productData,
      this.categoryId,
      required this.isSelected,
      this.productIdforWishList = ''});
  final bool isSelected;
  String productIdforWishList;
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final B2bStoreBloc b2bStoreBloc = B2bStoreBloc();
  bool _isDataLoaded = false;
  cart_model.CartModel? cartModel;
  ProductCollections? _productCollection;
  int productCount = 0;
  late bool isSelected;
  CustomerReviews? customerReviews;
  final box = GetStorage();
  bool _shouldShowCartBottomSheetAfterAdd = false;
  bool isAddedToCart = false;
  Addresses? address;
  Tag? sizeVarient;
  Tag? colorVarient;
  String? imageURL;
  Map<String, List<Map<String, String>>> colorMap = {};
  String selectedColor = '';
  String selectedVarientId = '';
  String calculatedAmount = '';
  String originalAmount = '';
  String selectedVariant = '';
  int? inventoryQuantity;
  String selectedSize = '';
  String selectedPrice = '';
  List<Map<String, String>> list = [];
  ProductCollections? products;
  double value = 3.5;
  // Addresses? address;
  // GlobalStorage globalStorage = GetIt.instance();
  String rgbToHex(int r, int g, int b) {
    // Ensure values are in range 0–255
    assert(r >= 0 && r <= 255);
    assert(g >= 0 && g <= 255);
    assert(b >= 0 && b <= 255);

    return '#${(r << 16 | g << 8 | b).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  @override
  initState() {
    super.initState();
    b2bStoreBloc.add(const GetCartData());
    // logger.w("prodid ${widget.productData?.id}");

    //  getAddress();
    b2bStoreBloc.add(GetOrderReview(productId: widget.productData?.id ?? ''));
    b2bStoreBloc.add(GetProductsByCategoryEvent(
        categoryId: widget.categoryId!, sized: null));

    isSelected = widget.isSelected;
    // colorMap=widget.productData?.variants.map((e)=>MapEntry(e.options.first.value??"",[...widget.productData.variants.where((e)=>e)] ));
    for (Variant i in widget.productData?.variants ?? []) {
      final color = i.options?.first.value ?? "";
      print("Color: $color");
      // final List<Map<String, String>> list = [];

      for (Variant j in widget.productData?.variants ?? []) {
        if (color == j.options?.first.value) {
          list.add({
            j.options?.last.value ?? "": j.id ?? "",
            "price": j.calculatedPrice?.calculatedAmount.toString() ?? "0",
            "originalPrice":
                j.calculatedPrice?.originalAmount.toString() ?? "0",
            "inventoryQuantity": j.inventoryQuantity?.toString() ?? "",
          });
          print(" Inventory quantity: ${j.inventoryQuantity}");
        }
      }
      colorMap[color] = list;

      print("Variants: $list");
      print("Color Map: $colorMap");
    }
    selectedVarientId = widget.productData?.variants[0].id ?? "";
    calculatedAmount = widget
            .productData?.variants[0].calculatedPrice?.calculatedAmount
            .toString() ??
        "0";
    inventoryQuantity = widget.productData?.variants[0].inventoryQuantity;
    originalAmount = widget
            .productData?.variants[0].calculatedPrice?.originalAmount
            .toString() ??
        "0";

    selectedColor = colorMap.keys.toList()[0];
    //logger.w(colorMap);
    //logger.w("Calculated Amount: $calculatedAmount");
  }

  Addresses? getAddress() {
    final addressJson = box.read("address");
    if (addressJson == null) {
      return null; // or return a default address
    }
    address = Addresses.fromJson(jsonDecode(box.read("address")));
    // setState(() {});
    return address;
  }

  _refresh() {
    b2bStoreBloc.add(const Refresh(slug: "collection_id"));
  }

  GlobalStorage globalStorage = GetIt.instance();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: BlocConsumer(
        bloc: b2bStoreBloc,
        listener: (context, state) async {
          print("state in print $state ");
          if (state is CartLoading) {
            EasyLoading.show(status: state.message);
          }
          if (state is B2BStoreSuccess) {
            EasyLoading.dismiss();
            // setState(() {
            cartModel = state.dashboardData.cartData;
            _productCollection = state.dashboardData.productCollections;

            _isDataLoaded = true;

            // _dashboardData = state.dashboardData;
            // });
          }
          if (state is B2BStoreError)
            {
              EasyLoading.dismiss();
              showDialog(
                context: context,
                builder: (context) => const CartItemErrorDialog(),
              );
            }
          // if (state is WishlistLoading) {
          //   EasyLoading.show(status: state.message);
          // }
          if (state is CartSuccess) {
            EasyLoading.dismiss();
            setState(() {
              imageURL = widget.productData?.thumbnail ?? '';
              cartModel = state.cartData;

              print(" cart model $cartModel  ");

              final itemsData = cartModel?.cart.items ?? [];

              if (itemsData.isEmpty) {
                productCount = 0;
              } else {
                // setState(() {});
                for (var i in itemsData) {
                  if (widget.productData?.variants
                          .any((e) => e.id == i.variantId) ??
                      false) {
                    productCount = i.quantity ?? 0;
                  } else {
                    productCount = 0;
                  }
                }
              }
              // print(state.cartData.cart);
              // _addressesData = state.addressesData;
              // _b2bStoreHomePage = state.dashboardData;
              // _productCollection = state.productCollection;
              // _refresh();
              _isDataLoaded = true;
              if(isAddedToCart){
                isAddedToCart = false;
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const CartScreen()));
                });
              }
              // _dashboardData = state.dashboardData;
            });

            // if (selectedAddress.value.id == null) {
            //   showModalBottomSheet(
            //     isScrollControlled: true,
            //     isDismissible: false, // <-- Allow tap outside to dismiss
            //     enableDrag: true, // <-- Allow swipe down to dismiss
            //     backgroundColor: Colors
            //         .transparent, // Optional: if you want rounded corners to show correctly
            //     context: context,
            //     builder: (_) =>
            //         const AddressChangeBottomSheet(), //AddressBottomSheet
            //   );
            // }
            // if (_shouldShowCartBottomSheetAfterAdd) {
            //   _shouldShowCartBottomSheetAfterAdd = false; // Reset the flag
            //   final resultFromBottomSheet = await showCartBottomSheet(
            //       context, {'from': 'buy_now_success'});
            //   _handleCartBottomSheetDismissal(resultFromBottomSheet);
            // }
            // _refresh();
          }

          if (state is WishlistSuccess) {
            EasyLoading.dismiss();
            //logger.w(state);
            // widget.productData?.id ==
            //     state.wishlistData.wishlist.items.first.productVariant.productId;
            final data = state.wishlistData.wishlist?.items?.firstWhere(
                (item) =>
                    item.productVariant?.productId == widget.productData?.id);

            setState(() {
              widget.productIdforWishList = data?.id ?? '';
              _productCollection = state.productCollections;
            });
            _refresh();
          }
          if (state is RestockSubscriptionsSuccess) {
            EasyLoading.dismiss();
            EasyLoading.showSuccess("Notification set successfully");
          }

          if (state is CustomerReviewSuccess) {
            customerReviews = state.customerReview;
            _productCollection = state.productCollection;
            _refresh();
            //logger.w(customerReviews);
          }

          if (state is CartError) {
            _shouldShowCartBottomSheetAfterAdd = false;
            EasyLoading.dismiss();
            EasyLoading.showError(state.error);
          }

          if (state is ProductsByCategorySuccess) {
            products = state.products;
          }

          // if (state is WishlistError) {
          //   EasyLoading.dismiss();
          //   EasyLoading.showError(state.error);
          // }

          // if (state is ReadyToShip) {
          //   EasyLoading.dismiss();
          //   showCartBottomSheet(context);
          // }
        },
        builder: (context, state) {
          return !_isDataLoaded
              ? Container()
              : Scaffold(
                  bottomSheet: XDecoratedBox(
                    child: Row(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (selectedVariant.isNotEmpty)
                              Text(selectedVariant,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold)),
                            Row(
                              spacing: 8,
                              children: [
                                Text(
                                  "\u{20B9} $calculatedAmount/-",
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "MRP \u{20B9} $originalAmount/-",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.greyBorder,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              ],
                            ),
                            Text("Inclusive of all Taxes",
                                style: TextStyle(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textgreyColor)),
                          ],
                        ),
                        // if (productCount != 0) const Spacer(),
                        const SizedBox(
                          width: 20,
                        ),
                        //  Text("$productCount "),

                        inventoryQuantity == 0
                            ? Expanded(
                                child: Container(
                                  width: double.infinity,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: AppColors.white,
                                  ),
                                  child: Center(
                                      child: Text(
                                    "Out of Stock",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp),
                                  )),
                                ),
                              )
                            :
                            // productCount == 0
                            // ?
                            Expanded(
                                child: LongLabeledButton(
                                height: 40,
                                onTap: () {
                                  addToCart(context);
                                },
                                label: "Add to Cart",
                              ))
                      ],
                    ),
                  ),
                  // appBar: const BackAppBar(),
                  body: SafeArea(
                    child: SingleChildScrollView(
                      // padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Column(
                        spacing: 16.h,
                        children: [
                          ImageView(
                            onBackTap: () {
                              Navigator.pop(
                                  context, 'refresh'); // Pop the image view
                            },
                            imageUrl: imageURL ?? "",
                            onTap: () {
                              if (!isSelected) {
                                b2bStoreBloc.add(AddToWishList(
                                  variantId:
                                      widget.productData?.variants[0].id ?? '',
                                ));
                              } else {
                                b2bStoreBloc.add(RemoveWishList(
                                    itemId: widget.productIdforWishList));
                              }

                              isSelected = !isSelected;
                              setState(() {});
                            },
                            isSelected: isSelected,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  spacing: 10,
                                  children: [
                                    RatingWidget(
                                      ratingValue:
                                          widget.productData!.averageRating,
                                      starSize: 17,
                                      starSpacing: 6,
                                    ),
                                    //                RatingStars(
                                    //             value: widget.productData!.averageRating ?? 0.0,
                                    //             onValueChanged: (v) {
                                    //               //
                                    //               setState(() {
                                    //                 value = v;
                                    //               });
                                    //             },
                                    //             starBuilder: (index, color){
                                    //                  bool isStarOn = color == Colors.yellow;

                                    // return Image.asset(
                                    //   isStarOn
                                    //       ? "assets/images/star_rating.png"  // filled star image
                                    //       : "assets/images/empty_star.png", // empty star image
                                    //   width: 20,
                                    //   height: 20,
                                    // );

                                    //             },
                                    //             starCount: 5,
                                    //             starSize: 20,
                                    //             valueLabelColor: const Color(0xff9b9b9b),
                                    //             valueLabelTextStyle: const TextStyle(
                                    //                 color: Colors.white,
                                    //                 fontWeight: FontWeight.w400,
                                    //                 fontStyle: FontStyle.normal,
                                    //                 fontSize: 12.0),
                                    //             valueLabelRadius: 10,
                                    //             maxValue: 5,
                                    //             starSpacing: 6,
                                    //             maxValueVisibility: false,
                                    //             valueLabelVisibility: false,
                                    //             // animationDuration: Duration(milliseconds: 1000),
                                    //             valueLabelPadding:
                                    //                 const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                                    //             valueLabelMargin: const EdgeInsets.only(right: 8),
                                    //             starOffColor: const Color(0xffe7e8ea),
                                    //             starColor: Colors.yellow,

                                    //           ),

                                    if (widget.productData?.reviewCount !=
                                            null &&
                                        widget.productData?.reviewCount != 0)
                                      Text(
                                        "(${widget.productData?.reviewCount})",
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    if (false)
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color:
                                                  AppColors.alertShadowColor),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                    const Spacer(),
                                    // if (false)
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  widget.productData?.title ?? "",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                  ),
                                ),
                                if (false)
                                  Row(
                                    children: [
                                      Text(
                                        "\u{20B9} ${widget.productData?.variants[0].calculatedPrice!.calculatedAmount.toString()}",
                                        // "\u{20B9} ${productData.variants!.last.calculatedPrice!.calculatedAmount.toString()}",

                                        // "\u{20B9} 799",
                                        style: TextStyle(
                                            fontSize: 36.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Spacer(),
                                      ShortLabelledButton(
                                        onTap: () async {
                                          if (productCount == 0) {
                                            await addToCart(context);

                                            return;
                                          } else {
                                            final resultFromBottomSheet =
                                                await showCartBottomSheet(
                                                    context,
                                                    {'from': 'buy_now'});
                                            _handleCartBottomSheetDismissal(
                                                resultFromBottomSheet);
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                Text(
                                  widget.productData?.subtitle ?? "",
                                  style: TextStyle(
                                      color: AppColors.textgreyColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                const Divider(
                                  thickness: 2,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  "Description",
                                  style: TextStyle(
                                      // color: AppColors.textgreyColor,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.productData?.description ?? "",
                                  style: TextStyle(
                                      // color: AppColors.textgreyColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                // SizedBox(
                                //   height: 20.h,
                                // ),
                                // const Divider(
                                //   thickness: 2,
                                // ),
                                // SizedBox(
                                //   height: 10.h,
                                // ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       "Delivery in 7-10 Days to ",
                                //       style: TextStyle(
                                //           fontSize: 14.sp,
                                //           color: AppColors.textgreyColor,
                                //           fontWeight: FontWeight.bold),
                                //     ),
                                //     ValueListenableBuilder(
                                //         valueListenable: selectedAddress,
                                //         builder: (context, value, child) {
                                //           return Text(
                                //             "Pin Code: ${value.postalCode}",
                                //             style: TextStyle(
                                //                 decoration:
                                //                     TextDecoration.underline,
                                //                 fontSize: 14.sp,
                                //                 color: AppColors.textgreyColor,
                                //                 fontWeight: FontWeight.bold),
                                //           );
                                //         }),
                                //   ],
                                // )
                              ],
                            ),
                          ),

                          // const ProductTitleDesc(),
                          // const XColorsSelection(),
                          // (sizeList: sizeList),SizeWidget
                          if (colorMap.isNotEmpty &&
                              colorMap.length > 1 &&
                              colorMap.keys.first.isHex)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: VarientContainer(
                                child: Column(
                                  // spacing: 10.h,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      "Color",
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Divider(
                                            thickness: 2,
                                          ),
                                        ),
                                        Spacer(
                                          flex: 4,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 26,
                                      child: ListView.separated(
                                          itemCount: colorMap.keys.length,
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(
                                              width: 5,
                                            );
                                          },
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (c, i) {
                                            final color =
                                                colorMap.keys.toList()[i];
                                            return InkWell(
                                              onTap: () {
                                                // colorVarient = size;
                                                // // final image = widget
                                                // //     .productData?.images
                                                // //     ?.firstWhere((e) => e.url
                                                // //         ?.contains(size?.value
                                                // //             ?.toLowerCase()));
                                                selectedColor = color;
                                                final image = widget
                                                    .productData?.images
                                                    ?.firstWhere((e) =>
                                                        e.url?.contains(
                                                            selectedColor
                                                                .toLowerCase()) ??
                                                        false);
                                                imageURL = image?.url;

                                                setState(() {});
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.w,
                                                    vertical: 4.h),
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                      spreadRadius: 1,
                                                      blurRadius: 5,
                                                      offset:
                                                          const Offset(0, 3),
                                                    ),
                                                  ],
                                                  color: color.toColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: selectedColor == color
                                                    ? const Icon(
                                                        Icons.check,
                                                        size: 10,
                                                        color: Colors.black,
                                                      )
                                                    : null,
                                              ),
                                            );
                                          }),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          if (selectedColor.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: VarientContainer(
                                child: Column(
                                  // spacing: 10.h,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Text(
                                      "Size",
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Divider(
                                            thickness: 2,
                                          ),
                                        ),
                                        Spacer(
                                          flex: 4,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 36.h,
                                      child: ListView.builder(
                                          itemCount: list.length,
                                          //  colorMap
                                          //         .containsKey(selectedColor)
                                          //     ? colorMap[selectedColor]?.length ??
                                          //         0
                                          //     : colorMap.length,
                                          // separatorBuilder: (context, index) {
                                          //   return
                                          //   const SizedBox(
                                          //     width: 5,
                                          //   );
                                          // },
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (c, i) {
                                            final size = list[i];
                                            selectedVariant =
                                                list[0].keys.first;
                                            // colorMap[selectedColor]?[i];
                                            return InkWell(
                                              onTap: () {
                                                selectedVarientId =
                                                    size?.entries.first.value ??
                                                        "";
                                                calculatedAmount =
                                                    size!['price'] ?? "";
                                                originalAmount =
                                                    size['originalPrice'] ?? "";

                                                inventoryQuantity =
                                                    size!['inventoryQuantity'] !=
                                                            null
                                                        ? int.parse(size![
                                                            'inventoryQuantity']!)
                                                        : null;
                                                print(
                                                    'Inventory quantity: $inventoryQuantity');

                                                // sizeVarient = size;
                                                selectedVariant =
                                                    size!.keys.first;
                                                setState(() {});
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15.w,
                                                      vertical: 4.h),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.3),
                                                        spreadRadius: 1,
                                                        blurRadius: 5,
                                                        offset:
                                                            const Offset(0, 3),
                                                      ),
                                                    ],
                                                    color: selectedVarientId ==
                                                            size?.entries.first
                                                                .value
                                                        ? AppColors
                                                            .lightCyanColor
                                                        : Colors.white,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                        size?.keys.first ?? ""),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                    // const SizedBox(
                                    //   height: 10,
                                    // ),
                                  ],
                                ),
                              ),
                            ),

                          // if (selectedColor.isEmpty)
                          //   Padding(
                          //     padding: EdgeInsets.symmetric(horizontal: 16.w),
                          //     child: VarientContainer(
                          //       child: Column(
                          //         // spacing: 10.h,
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           SizedBox(
                          //             height: 10.h,
                          //           ),
                          //           Text(
                          //             "Size",
                          //             style: TextStyle(
                          //                 fontSize: 15.sp,
                          //                 fontWeight: FontWeight.bold),
                          //           ),
                          //           const Row(
                          //             children: [
                          //               Expanded(
                          //                 flex: 2,
                          //                 child: Divider(
                          //                   thickness: 2,
                          //                 ),
                          //               ),
                          //               Spacer(
                          //                 flex: 4,
                          //               ),
                          //             ],
                          //           ),
                          //           SizedBox(
                          //             height: 26,
                          //             child: ListView.separated(
                          //                 itemCount: widget
                          //                         .productData?.variants.length ??
                          //                     0,
                          //                 separatorBuilder: (context, index) {
                          //                   return const SizedBox(
                          //                     width: 5,
                          //                   );
                          //                 },
                          //                 scrollDirection: Axis.horizontal,
                          //                 itemBuilder: (c, i) {
                          //                   return InkWell(
                          //                     onTap: () {
                          //                       // selectedVarientId =
                          //                       //     size?.entries.first.value ??
                          //                       //         "";
                          //                       // calculatedAmount =
                          //                       //     size!['price'] ?? "";
                          //                       // originalAmount =
                          //                       //     size['originalPrice'] ?? "";
                          //                       // selectedVariant =
                          //                       //     size.entries.first.key;
                          //                       // // sizeVarient = size;
                          //                       setState(() {
                          //                         selectedSize = widget
                          //                                 .productData
                          //                                 ?.variants[i]
                          //                                 .options
                          //                                 ?.first
                          //                                 .value ??
                          //                             "";
                          //                         selectedVarientId = widget
                          //                                 .productData
                          //                                 ?.variants[i]
                          //                                 .id ??
                          //                             "";
                          //                         selectedPrice = widget
                          //                                 .productData
                          //                                 ?.variants[i]
                          //                                 .calculatedPrice
                          //                                 ?.calculatedAmount
                          //                                 .toString() ??
                          //                             "";
                          //                       });
                          //                     },
                          //                     child: Container(
                          //                       padding: EdgeInsets.symmetric(
                          //                           horizontal: 10.w,
                          //                           vertical: 4.h),
                          //                       decoration: BoxDecoration(
                          //                         boxShadow: [
                          //                           BoxShadow(
                          //                             color: Colors.grey
                          //                                 .withOpacity(0.3),
                          //                             spreadRadius: 1,
                          //                             blurRadius: 5,
                          //                             offset: const Offset(0, 3),
                          //                           ),
                          //                         ],
                          //                         color: selectedSize ==
                          //                                 widget
                          //                                     .productData
                          //                                     ?.variants[i]
                          //                                     .options
                          //                                     ?.first
                          //                                     .value
                          //                             ? AppColors.lightCyanColor
                          //                             : Colors.white,
                          //                       ),
                          //                       child: Center(
                          //                         child: Text(
                          //                             "  ${widget.productData?.variants[i].options?.first.value}"),
                          //                       ),
                          //                     ),
                          //                   );
                          //                 }),
                          //           ),
                          //           const SizedBox(
                          //             height: 10,
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),

                          Padding(
                            // padding: const EdgeInsets.all(8.0),
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: const Divider(
                              thickness: 2,
                            ),
                          ),
                          //Address Selection
                          Padding(
                            // padding: const EdgeInsets.all(8.0),
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: XDecoratedBox(
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                // spacing: 10,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Address - ",
                                        style: AppTextStyle.font14bold,
                                      ),
                                      ValueListenableBuilder<Addresses>(
                                          valueListenable: selectedAddress,
                                          builder: (context, value, child) {
                                            address =
                                                globalStorage.getAddress();
                                            return Expanded(
                                              child: Text(
                                                address!.addressName ??
                                                    value.addressName ??
                                                    "",
                                                style: AppTextStyle.font14bold,
                                              ),
                                              //  Text(
                                              //   value.address1.isEmptyOrNull
                                              //       ? "Select New Address"
                                              //       : value.addressName!,
                                              //   style: TextStyle(
                                              //     fontSize: 12.sp,
                                              //     color: Colors.grey,
                                              //   ),
                                              // ),
                                            );
                                          }),
                                      GestureDetector(
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
                                                const AddressChangeBottomSheet(), //AddressBottomSheet
                                          ).then((value) {
                                          // .then(v){
                                            getAddress();
                                            setState(() {
                                              
                                            });
                                          });
                                          

                                        },
                                        child: Text(
                                          "Change",
                                          style:
                                              AppTextStyle.font14bold.copyWith(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Divider(
                                          thickness: 2,
                                          color: Color(0xffDCDCDC),
                                        ),
                                      ),
                                      Spacer(
                                        flex: 4,
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Navigator.pop(context, "address_changed");
                                    },
                                    child: Row(
                                      children: [
                                        ValueListenableBuilder<Addresses>(
                                            valueListenable: selectedAddress,
                                            builder: (context, value, child) {
                                              address =
                                                  globalStorage.getAddress();
                                              return Expanded(
                                                child: Text(
                                                  value.address1.isEmptyOrNull
                                              ?
                                           address!.address1 != null ?  
                                           address!.address1! :  
                                               "Add Address"
                                              : address!.address1 ??
                                                  value.address1!,
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              );
                                            }),
                                        SizedBox(width: 5.w),
                                        // Image.asset(
                                        //   AppImages.icon_see_more, // ✅ just the image now
                                        //   width: 15,
                                        //   height: 15,
                                        //   color: Colors.grey, // optional: keep same color tone as before
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            // padding: const EdgeInsets.all(8.0),
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: const Divider(
                              thickness: 2,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 16.0),
                            child: Row(
                              children: [
                                Text(
                                  "Related Products",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                // SeeMoreButton(
                                //   onTap: () {},
                                // ),
                              ],
                            ),
                          ),
                          RecentSearches(
                            products: products!,
                            cartModel: cartModel,
                            b2bStoreBloc: b2bStoreBloc,
                          ),
                          const SizedBox(height: 5),
                          // if (customerReviews?.reviews.isNotEmpty ?? false)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0), // Only leading padding
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Ratings & Reviews",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // const Spacer(),
                                      // SeeMoreButton(onTap: () {}),
                                    ],
                                  ),
                                  //const SizedBox(height: 8),
                                  Center(
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount:
                                          customerReviews?.reviews.length ?? 0,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final review =
                                            customerReviews?.reviews[index];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: ReviewCard(
                                            name: review?.customer?.firstName ??
                                                "Customer",
                                            date: review?.formattedCreatedAt ??
                                                "",
                                            rating:
                                                review?.rating?.toDouble() ??
                                                    0.0,
                                            review: review?.comment ??
                                                "No review provided",
                                          ),
                                        );
                                      },
                                      // separatorBuilder: (context, index) =>
                                      // const SizedBox(height: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ));
        },
      ),
    );
  }

  void _handleCartBottomSheetDismissal(String? result) {
    // Here you can update UI or trigger further actions based on the result
    setState(() {
      if (result == 'checkout_initiated') {
        // User initiated checkout from cart, maybe navigate to final checkout screen
        EasyLoading.showSuccess('Checkout initiated from cart!');
      } else if (result == 'keep_shopping' ||
          result == 'cart_empty_after_load') {
        // User wants to keep shopping or cart is empty
        EasyLoading.showInfo('Cart dismissed. Happy shopping!');
      } else if (result == 'cart_load_error') {
        EasyLoading.showError('Error loading cart.');
      } else if (result == 'address_changed') {
        EasyLoading.showToast('Address updated!');
        // If changing address in CartBottomSheet affects ProductDetailsScreen,
        // dispatch an event to refresh relevant data here.
        // e.g., _b2bStoreBloc.add(const GetCartData()); // To refresh cart prices with new address
      }
      // You can add more cases based on results popped from CartBottomSheet
    });
    // You might also want to refresh the cart data here in case it was modified
    // from outside the bloc listener (e.g. if the bottom sheet was dismissed by drag)

    b2bStoreBloc.add(const GetCartData()); // Always refresh cart data
  }

  Future<String?> showCartBottomSheet(
      BuildContext context, Map<String, dynamic> preCartData) async {
    // _b2bStoreBloc.add(const ProceedToShip());
    // await Future.delayed(Duration(seconds: 2));
    final v = await showModalBottomSheet<String>(
      isScrollControlled: true,
      isDismissible: true, // <-- Allow tap outside to dismiss
      enableDrag: true, // <-- Allow swipe down to dismiss

      backgroundColor: Colors
          .transparent, // Optional: if you want rounded corners to show correctly

      context: context,
      builder: (_) => CartBottomSheet(
        initialApiData: preCartData,
      ), //AddressBottomSheet
    );
    return v;
  }

  addToCart(BuildContext context) async {
    _shouldShowCartBottomSheetAfterAdd = true;
    try {
      isAddedToCart = true;
      b2bStoreBloc.add(AddToCart(quantity: 1, variant_id: selectedVarientId));
      productCount = 1;
      setState(() {});

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Item added to cart!'),
      //   ),
      // );
    } catch (e) {}
  }
}

class ShortLabelledButton extends StatelessWidget {
  const ShortLabelledButton({
    super.key,
    this.onTap,
    this.label = "Buy Now",
  });
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        decoration: BoxDecoration(
            color: AppColors.lightCyanColor,
            borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            label,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class RecentSearches extends StatelessWidget {
  final ProductCollections? products;
  final B2bStoreBloc? b2bStoreBloc;
  final cart_model.CartModel? cartModel;
  const RecentSearches(
      {super.key, this.products, this.b2bStoreBloc, this.cartModel});

  @override
  Widget build(BuildContext context) {
    print("object in the flased $cartModel ");
    return SizedBox(
      height: 145.h,
      width: double.infinity,
      child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (c, i) => HorizontalListTile(
                products: products!.products[i],
                cartModel: cartModel,
                b2bStoreBloc: b2bStoreBloc,
                // imgURL:  products!.products[i].thumbnail!,
              ),
          separatorBuilder: (c, i) => const SizedBox(
                width: 10,
              ),
          itemCount: products!.products.length
          // products.

          // topBrands.length

          ),
    );
  }
}

class HomeAddress extends StatelessWidget {
  const HomeAddress({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.themeBackground,
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
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                "Address -",
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                "Change",
                style: TextStyle(
                    color: AppColors.textgreyColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          const Row(
            children: [
              Expanded(
                flex: 2,
                child: Divider(
                  thickness: 2,
                ),
              ),
              Spacer(
                flex: 4,
              )
            ],
          ),
          Text(
            "1234 Lane road, Area, Location, Landmark",
            style: TextStyle(fontSize: 14.sp, color: AppColors.textgreyColor),
          )
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.name,
    required this.date,
    required this.rating,
    required this.review,
  });

  final String name;
  final String date;
  final double rating;
  final String review;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey, // Placeholder for profile image
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Posted on $date",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Image.asset(
                      width: 16, height: 16, "assets/images/star_rating.png"),
                  // Icon(
                  //   Icons.star,
                  //   color: Colors.amber,
                  //   size: 16.sp,
                  // ),
                  SizedBox(width: 4.w),
                  Text(
                    rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(
            thickness: 1,
            height: 20,
          ),
          Text(
            review,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalListTile extends StatefulWidget {
  final XYProduct? products;
  final cart_model.CartModel? cartModel;
  final B2bStoreBloc? b2bStoreBloc;
  const HorizontalListTile(
      {super.key, this.products, this.cartModel, this.b2bStoreBloc
      // required this.imgURL,
      });

  @override
  State<HorizontalListTile> createState() => _HorizontalListTileState();
}

class _HorizontalListTileState extends State<HorizontalListTile> {
  // final B2bStoreBloc _b2bStoreBloc = B2bStoreBloc();
  B2BStoreHomePage? _b2bStoreHomePage;
  int productCount = 0;
  GlobalStorage globalStorage = GetIt.instance();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print(" producr counr$productCount ");
  }

  // final String imgURL;
  @override
  Widget build(BuildContext context) {
    print("idjd ${_b2bStoreHomePage?.cartData}");
    widget.cartModel!.cart.items?.forEach((i) {
      if (i.variantId == widget.products!.variants[0].id) {
        productCount = i.quantity ?? 0;
        print("idjd ${i.quantity}");
      }
    });
    return GestureDetector(
      onTap: () async {
        // print("categoty id ${ _b2bStoreHomePage!.productCollections.products.first.categories!.first.id}");

        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              categoryId: widget.products!.categories!.first.id,
              productData: widget.products,
              isSelected: widget.b2bStoreBloc!.favIds
                  .any((e) => e.containsKey(widget.products!.id)),
              productIdforWishList: widget.b2bStoreBloc!.favIds
                      .any((e) => e.containsKey(widget.products!.id))
                  ? widget.b2bStoreBloc!.favIds
                      .firstWhere(
                          (e) => e.entries.first.key == widget.products!.id)
                      .entries
                      .first
                      .value
                  : "",
            ),
          ),
        );
        if (result != null && result == 'refresh') {
          // _refresh();
          print('Returned from Page B with refresh signal (or physical back).');
          // _initializeData(); // Re-initialize or refresh data
        } else {
          // _refresh();
          print('Returned from Page B without refresh signal or cancelled.');
        }
      },
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                    child: widget.products!.thumbnail?.isEmpty ?? true
                        ? Image.asset(AppImages.woloologo)
                        : Image.network(
                            widget.products!.thumbnail ?? '',
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                widget.products!.variants.first.options?.first.value ==
                        "Default option value"
                    ? Container()
                    : Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.r),
                          color: AppColors.lightCyanColor,
                        ),
                        child: Text(
                          widget.products!.variants.first.options?.first
                                  .value ??
                              "",
                          style: AppTextStyle.font10bold,
                        ),
                      ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  width: 120,
                  child: Text(
                    widget.products!.title ?? "",
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold),
                  ),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RatingWidget(
                      ratingValue: widget.products!.averageRating ?? 0,

                      // product.averageRating,
                      starSize: 10,
                      starSpacing: 4,
                    ),
                    const SizedBox(
                      width: 5,
                    ),

                    // if (product.reviewCount !=
                    //         null &&
                    //     product.reviewCount != 0)
                    Text(
                      "(${widget.products!.reviewCount ?? 0})",
                      style: AppTextStyle.font10bold
                          .copyWith(fontSize: 8, fontWeight: FontWeight.bold),
                    )
                  ],
                ),

                Row(
                  spacing: 5.w,
                  children: [
                    Text(
                      "\u{20B9}${widget.products!.variants.first.calculatedPrice!.calculatedAmount.toString()}/-",
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //TODO: Check Price Logic -- Abar asibo fire
                    widget.products!.variants.first.calculatedPrice!
                                .originalAmount !=
                            widget.products!.variants.first.calculatedPrice!
                                .calculatedAmount
                        ? Text(
                            "MRP ${widget.products!.variants.first.calculatedPrice!.originalAmount.toString()}",
                            style: TextStyle(
                                decoration:
                                    widget.products!.discountable ?? false
                                        ? TextDecoration.lineThrough
                                        : null,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textgreyColor),
                          )
                        : const SizedBox(),
                  ],
                )
              ],
            ),
            if (widget.products!.variants.first.inventoryQuantity == 0)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0.3, sigmaY: 0.3),
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
                    if (widget.products!.variants.first.inventoryQuantity == 0)
                      return;
                    // //logger.w(
                    //     "Selected Address: ${selectedAddress.value.id}");
                    // if (selectedAddress
                    //         .value.id ==
                    //     null) {
                    //   showModalBottomSheet(
                    //     isScrollControlled: true,
                    //     isDismissible:
                    //         false, // <-- Allow tap outside to dismiss
                    //     enableDrag:
                    //         true, // <-- Allow swipe down to dismiss
                    //     backgroundColor: Colors
                    //         .transparent, // Optional: if you want rounded corners to show correctly
                    //     context: context,
                    //     builder: (_) =>
                    //         const AddressChangeBottomSheet(), //AddressBottomSheet
                    //   );
                    //   return;
                    // }
                    widget.b2bStoreBloc!.add(AddToCart(
                        quantity: 1,
                        variant_id: widget.products!.variants[0].id));
                    // if (widget.isSelected) {
                    //   widget.onRemove?.call();
                    // } else {
                    //   widget.onAdd?.call();
                    // }
                    // setState(() {
                    //   mode = AddButtonMode.add;
                    // });
                    await Future.delayed(const Duration(milliseconds: 500), () {
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
                  borderRadius: BorderRadius.circular(3.r),
                  child: AnimatedContainer(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.buttonColor, width: 1.5),
                        color: productCount == 0
                            ? AppColors.themeBackground
                            : AppColors.lightCyanColor,
                        borderRadius: BorderRadius.circular(3.r)),
                    duration: const Duration(milliseconds: 500),
                    child: Center(
                        child: widget.products!.variants.first
                                    .inventoryQuantity ==
                                0
                            ? InkWell(
                                onTap: () {
                                  print(" it me object");

                                  widget.b2bStoreBloc!.add(
                                    RestockSubscriptionsEvent(
                                      phoneNumber:
                                          globalStorage.getClientMobileNo(),
                                      variantId:
                                          widget.products!.variants[0].id!,
                                    ),
                                  );
                                },
                                child: Text(
                                  "Notify",
                                  style: AppTextStyle.font10bold,
                                ),
                              )
                            : productCount == 0
                                ? Text(
                                    "Add",
                                    style: AppTextStyle.font10bold,
                                  )
                                : Row(
                                    spacing: 10,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (productCount == 0) return;

                                          productCount == 0
                                              ? EasyLoading.showError(
                                                  "Product count cannot be less than 0")
                                              : null;

                                          widget.cartModel?.cart.items
                                              ?.forEach((i) {
                                            if (i.variantId ==
                                                widget
                                                    .products!.variants[0].id) {
                                              productCount -= 1;
                                              widget.b2bStoreBloc!.add(
                                                  AddRemoveItemReq(
                                                      count: productCount,
                                                      itemId: i.id ?? ""));
                                            }
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                  width: 1,
                                                  color: AppColors.black)),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 2),
                                          child: const Icon(
                                            Icons.remove,
                                            size: 8,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        productCount.toString(),
                                        style: AppTextStyle.font10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          widget.cartModel?.cart.items
                                              ?.forEach((i) {
                                            if (i.variantId ==
                                                widget
                                                    .products!.variants[0].id) {
                                              productCount += 1;
                                              widget.b2bStoreBloc!.add(
                                                  AddRemoveItemReq(
                                                      count: productCount,
                                                      itemId: i.id ?? ""));
                                            }
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                  width: 1,
                                                  color: AppColors.black)),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 2),
                                          child: const Icon(
                                            Icons.add,
                                            size: 10,
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                  ),
                )),
            if (widget.products!.variants.first.inventoryQuantity == 0)
              Positioned(
                top: 2.h, // or adjust based on spacing needed from top
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColors.lightCyanColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "Out of Stock",
                      style: TextStyle(
                        fontSize: 6.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
              )
            else if (widget.products!.tags?.isNotEmpty == true)
              Positioned(
                top: 2.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColors.lightCyanColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "${widget.products!.tags?.first.value}",
                      style: TextStyle(
                        fontSize: 6.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class XColorsSelection extends StatelessWidget {
  const XColorsSelection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
          color: AppColors.themeBackground,
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
      child: Column(
        // spacing: 10.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.h,
          ),
          Text(
            "Colours",
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
          ),
          const Row(
            children: [
              Expanded(
                flex: 2,
                child: Divider(
                  thickness: 2,
                ),
              ),
              Spacer(
                flex: 4,
              ),
            ],
          ),
          SizedBox(
            height: 26,
            child: ListView.separated(
              itemCount: 10,
              separatorBuilder: (context, index) {
                return const SizedBox(
                  width: 5,
                );
              },
              scrollDirection: Axis.horizontal,
              itemBuilder: (c, i) => Container(
                height: 26,
                width: 26,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.red),
                child: const Center(
                  child: Icon(Icons.check),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
        ],
      ),
    );
  }
}

class CartAddRemove extends StatelessWidget {
  const CartAddRemove({
    super.key,
    this.onRemove,
    this.onAdd,
    this.value = 1,
  });
  final VoidCallback? onRemove;
  final VoidCallback? onAdd;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: AppColors.lightCyanColor,
          borderRadius: BorderRadius.circular(4)),
      child: Row(
        spacing: 7,
        children: [
          XAddRemove(
            onTap: onRemove,
            // if (productCount <= 1) return;
            // _b2bStoreBloc.add(AddRemoveItemReq(
            //     itemId: widget.productId, count: productCount));
            // setState(() {
            //   productCount--;
            // });

            icon: Icons.remove,
          ),
          const SizedBox(
            width: 8,
          ),
          SizedBox(
            width: 15,
            height: 15,
            child: Image.asset(
              AppImages.cart_icon,
              fit: BoxFit.contain,
            ),
          ),
          Text(
            value.toString(),
            style: const TextStyle(
                fontFamily: 'CenturyGothic',
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 8,
          ),
          XAddRemove(
            onTap: onAdd,
            icon: Icons.add,
          ),
        ],
      ),
    );
  }
}

class XAddRemove extends StatelessWidget {
  const XAddRemove({
    super.key,
    this.onTap,
    required this.icon,
  });
  final VoidCallback? onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(width: 2, color: AppColors.black)),
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        child: Icon(
          icon,
          size: 15,
        ),
      ),
    );
  }
}

class ImageView extends StatelessWidget {
  final String imageUrl;
  const ImageView(
      {super.key,
      required this.imageUrl,
      this.onTap,
      this.isSelected = false,
      required this.onBackTap});
  final VoidCallback? onTap;
  final VoidCallback? onBackTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 382,
      width: double.infinity,
      decoration: const BoxDecoration(
        // borderRadius: BorderRadius.circular(47),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(3, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.fill, // Ensures the image fills the container
            height: 382, // Match the container's height
            width: double.infinity, // Match the container's width
          ),
          Positioned(
            top: 20,
            right: 20,
            child: InkWell(
                onTap: onTap,
                child: Icon(
                  isSelected
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isSelected ? Colors.pink : null,
                  size: 30.sp,
                )),
          ),
          Positioned(
              top: 5,
              left: 10,
              child: InkWell(
                onTap: onBackTap,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                      color: AppColors.lightCyanColor,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]),

                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_back_ios,
                        size: 15,
                      ),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            MyTaskListConstants.BACK.tr(),
                            style: AppTextStyle.font12bold
                                .copyWith(color: AppColors.alertTitleColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ), // Padding around the text
                ),
              ))
        ],
      ),
    );
  }
}

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BackAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white, // Matches the design
      elevation: 0, // Removes shadow for a flat look
      leadingWidth: 100, // Adjust width for the "Back" button
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context, 'refresh'); // Navigate back when tapped
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 10), // Add spacing from the edge
            const Icon(
              Icons.arrow_back_ios,
              color: AppColors.textgreyColor,
              size: 16, // Adjust icon size
            ),
            const SizedBox(width: 5), // Spacing between icon and text
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  MyTaskListConstants.BACK.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textgreyColor,
                    fontSize: 14, // Adjust font size
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class VarientContainer extends StatelessWidget {
  const VarientContainer({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
          color: AppColors.themeBackground,
          borderRadius: BorderRadius.circular(16),
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
      child: child,
    );
  }
}
