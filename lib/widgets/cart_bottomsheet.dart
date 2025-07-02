import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:woloo_smart_hygiene/b2b_store/address_change_bottomsheet.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_bloc.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_event.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_state.dart';
import 'package:woloo_smart_hygiene/b2b_store/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/address.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/cart.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:woloo_smart_hygiene/widgets/boxes/cart_item.dart';
import 'package:woloo_smart_hygiene/widgets/review_order_bottomsheet.dart';

class CartBottomSheet extends StatefulWidget {
  final Map<String, dynamic>? initialApiData; // NEW
  const CartBottomSheet({super.key, this.initialApiData}); // NEW

  @override
  State<CartBottomSheet> createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheet> {
  final B2bStoreBloc _b2bStoreBloc = B2bStoreBloc();
  bool _isDataLoaded = false;
  CartModel? cartModel;
  Addresses? address;
  final box = GetStorage();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _b2bStoreBloc.add(const GetCartData());
    super.initState();
    address = getAddress();
    print('CartBottomSheet opened with initial data: ${widget.initialApiData}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: _b2bStoreBloc,
        listener: (context, state) {
          if (state is CartLoading) {
            EasyLoading.show(status: state.message);
          }
          if (state is CartSuccess) {
            EasyLoading.dismiss();
            setState(() {
              cartModel = state.cartData;
              if (cartModel?.cart.items?.isEmpty ?? true) {
                Navigator.pop(context,
                    'cart_empty_after_load'); // Dismiss and pass result
              }
              _isDataLoaded = true;
            });
          }

          if (state is CartError) {
            EasyLoading.dismiss();
            EasyLoading.showError(state.error);
            Navigator.pop(context, 'cart_load_error'); // Dismiss on error
          }
        },
        builder: (context, snapshot) {
          return !_isDataLoaded
              ? Container(
                  child: const Text("data nay"),
                )
              : Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  // width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(40.r))),
                  child: cartModel?.cart.items?.isEmpty ?? true
                      ? Container(
                          // child: Text("No items in cart"),
                          )
                      : Column(
                          spacing: 16.h,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const XBottmSheetTopDecor(),
                            CartHeader(
                              imgPath: AppImages.cart,
                              title: "Cart",
                              subtitle: 'Checkout you purchases from here',
                            ),
                            Expanded(
                              child: ListView(
                                children: [
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    // Prevents nested scrolling
                                    itemCount: cartModel?.cart.items
                                        ?.length, // Replace with your cart item count
                                    itemBuilder: (context, index) {
                                      final item =
                                          cartModel?.cart.items?[index];
                                      int count = item?.quantity ?? 0;
                                      return Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.h),
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
                                            if (count > 0) {
                                              _b2bStoreBloc.add(
                                                  AddRemoveItemReq(
                                                      count: count,
                                                      itemId: item?.id ?? ""));
                                            } else {
                                              _b2bStoreBloc.add(DeleteItemReq(
                                                  itemId: item?.id ?? ""));
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  const Divider(),
                                  // AddressChangeWidget(address: address),
                                  XDecoratedBox(
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: 10,
                                      children: [
                                        Text(
                                          "Home",
                                          style: AppTextStyle.font14bold,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(
                                                context, "address_changed");
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
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                address?.address1 ??
                                                    "Select Address",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              SizedBox(width: 5.w),
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    shape: BoxShape.circle),
                                                child: const Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Divider(),
                                  // ApplyPromo(
                                  //   b2bStoreBloc: _b2bStoreBloc,
                                  // ),
                                  const Divider(),
                                  PricingCalculate(
                                    itemTotal: cartModel?.cart.originalItemTotal
                                        .toString(),
                                    discount: cartModel?.cart.discountTotal
                                        ?.toStringAsFixed(2),
                                    total: cartModel?.cart.total.toString(),
                                    subTotal:
                                        cartModel?.cart.subtotal.toString(),
                                    shipping: cartModel?.cart.shippingTotal
                                        .toString(),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                Expanded(
                                    child: LongLabeledButton(
                                  label: "Checkout",
                                  onTap: () {
                                    // Navigator.pop(
                                    //     context, 'checkout_initiated');
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
                                          const ReviewOrderBottomsheet(), //AddressBottomSheet
                                    );
                                  },
                                )),
                                Expanded(
                                  child: LongLabeledButton(
                                    onTap: () {
                                      Navigator.pop(context, 'keep_shopping');
                                    },
                                    label: "Keep Shopping",
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                );
        });
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
}

class AddressChangeWidget extends StatelessWidget {
  const AddressChangeWidget({
    super.key,
    required this.address,
  });

  final Addresses? address;

  @override
  Widget build(BuildContext context) {
    return XDecoratedBox(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Text(
            "Home",
            style: AppTextStyle.font14bold,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context, "address_changed");
              showModalBottomSheet(
                isScrollControlled: true,
                isDismissible: true, // <-- Allow tap outside to dismiss
                enableDrag: true, // <-- Allow swipe down to dismiss

                backgroundColor: Colors
                    .transparent, // Optional: if you want rounded corners to show correctly

                context: context,
                builder: (_) =>
                    const AddressChangeBottomSheet(), //AddressBottomSheet
              );
            },
            child: Row(
              children: [
                Text(
                  address?.address1 ?? "Select Address",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: 5.w),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      shape: BoxShape.circle),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
