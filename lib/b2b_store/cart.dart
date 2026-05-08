import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:razorpay_web/razorpay_web.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:woloo_smart_hygiene/b2b_store/address_change_bottomsheet.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_bloc.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_event.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_state.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/product_details.dart';
import 'package:woloo_smart_hygiene/b2b_store/widgets/smart_widgets.dart';
import 'package:woloo_smart_hygiene/extensions/string_extension.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:woloo_smart_hygiene/utils/logger.dart';
import 'package:woloo_smart_hygiene/widgets/boxes/cart_item.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/inventory_model.dart'
    as invent;
import 'package:woloo_smart_hygiene/widgets/order_summery_bottomsheet.dart';
import '../client_flow/screens/dashbaord/view/dashboard.dart';
import '../client_flow/screens/subcription/bloc/subscription_bloc.dart';
import '../client_flow/screens/subcription/bloc/subscription_event.dart';
import '../client_flow/screens/subcription/bloc/subscription_state.dart';
import '../core/local/global_storage.dart';
import '../hygine_services/view/address_notifier.dart';
import 'ecom.dart';
import 'invalid_promo_code_dialog.dart';
import 'inventory_checkout_bottom_sheet.dart';
import 'models/address.dart';
import 'models/inventrory_error_model.dart';
import 'widgets/radio_labeled_tile.dart';
// import '../bloc/subscription_event.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // final

  final box = GetStorage();
  late String shippingAmount = "0";
  Razorpay razorpay = Razorpay();
  final B2bStoreBloc _b2bStoreBloc = B2bStoreBloc();
  SubcriptionBloc subcriptionBloc = SubcriptionBloc();
  bool _isDataLoaded = false;
  CartModel? cartModel;
  bool isExpressBooking = false;
  int wolooPoints = 0;
  bool isWolooPointsApplied = false;
  bool isWolooPromotionApplied = false;
  bool isWolooPointsLoading = false;
  String? wolooPointsError;
  String wolooPromoOrUserCode = "USER_CODE";
  Addresses? address;
  GlobalStorage globalStorage = GetIt.instance();

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
    /*isWolooPromotionApplied = box.read(
      box.read('cart_id') + "promoCode",
    ) ??
        false;*/
    _b2bStoreBloc.add(const GetCartData());
    super.initState();
    if (selectedAddress.value != null) {
      _b2bStoreBloc.add(SelectAddress(selectedAddress.value));
    }

    address = globalStorage.getAddress();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Place any code here that should run after the first build is complete.
      if (selectedAddress.value.id == null) {
        // showModalBottomSheet(
        //   isScrollControlled: true,
        //   isDismissible: false, // <-- Allow tap outside to dismiss
        //   enableDrag: true, // <-- Allow swipe down to dismiss
        //   backgroundColor: Colors
        //       .transparent, // Optional: if you want rounded corners to show correctly
        //   context: context,
        //   builder: (_) => const AddressChangeBottomSheet(), //AddressBottomSheet
        // );
        // return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: _b2bStoreBloc,
        listener: (context, state) {
          print("state in ddd $state");
          print("Aarati Statre check $state");
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
              // if (state.wolooPoints > 0) {
              //   wolooPoints = state.wolooPoints;
              // }

              isWolooPointsLoading = false;
              wolooPointsError = null;
              _isDataLoaded = true;
            });
            logger.d(cartModel?.cart.shippingTotal);
            final promoList = cartModel?.cart?.promotions ?? [];

            final isWolooApplied = promoList.any(
              (promo) => promo.code?.toLowerCase() == "woloo_coins",
            );
            print(" is applide $isWolooApplied ");
            isWolooPointsApplied = isWolooApplied;
            print(" is applide $isWolooPointsApplied ");
            subcriptionBloc.add(const UserCoinsEvent());

            // Show success message if provided
            // if (state.message != null) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(
            //       content: Text(state.message!),
            //       backgroundColor: Colors.green,
            //     ),
            //   );
            // }

            final itemCount = cartModel?.cart?.items?.length ?? 0;
            if (itemCount == 0) {
              // Clear navigation stack and go to Ecom screen
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (c) => ClientDashboard(
                          dashIndex: 0,
                        )),
                (route) => false,
              );
              return; // stop further execution
            }

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
            print(
                "Amount is Shipping Amount ${state.shippingDetails.cart?.shippingTotal.toString()}");
            shippingAmount =
                state.shippingDetails.cart!.shippingTotal.toString();
            EasyLoading.dismiss();
            showCartBottomSheet(context);
          }
          if (state is CartLoadingForPromo) {
            setState(() {
              isLoading = true;
              errorMessage = null;
            });
          }
          if (state is CheckInventorySuccess) {
            EasyLoading.dismiss();
            state.inventoryModel;

            if (state.inventoryModel is invent.InventoryModel) {
              _b2bStoreBloc
                  .add(GetDeliveryPartners(selectedAddress.value.postalCode!));
              //  _b2bStoreBloc.add(const ProceedToShip());
              // cartModel = CartModel.fromJson(state.inventoryModel.data!.toJson());
              // _b2bStoreBloc.add(ReadyToShip(cartData: cartModel!));
            } else if (state.inventoryModel is InventoryErrorModel) {
              InventoryErrorModel inventoryModel =
                  state.inventoryModel as InventoryErrorModel;

              // final inventoryModel = state.inventoryModel as InventoryErrorModel;

              List<String> variantIds = [];
              List<Item>? filteredCartItems = [];

// Collect variant IDs from error list
              for (var error in inventoryModel.errors!) {
                variantIds.add(error.variantId!);
              }

// Initialize list to hold filtered cart items

// List<Item>?
              print("object $variantIds ");

// Filter cart items where variant_id matches any variantId from errors
              for (var item in cartModel!.cart.items!) {
                print("varinf ${variantIds.contains(item.variantId)}");
                print("idddd ${item.id}");
                if (variantIds.contains(item.variantId)) {
                  filteredCartItems!.add(item);
                  print("filter ${filteredCartItems}");
                }
              }

              print("cart lisree $filteredCartItems ");

              //  Future.delayed(
              //   Duration(seconds: 2),
              //   () {
              showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) {
                    return InventoryCheckoutBottomSheet(
                      filteredCartItems: filteredCartItems!,
                      b2bStoreBloc: _b2bStoreBloc,

                      // items: state.inventoryModel.data?.items ?? [],
                      // message: state.inventoryModel.message ?? "Inventory Error",
                    );
                  }).then((value) {
                // Initialize list to hold variant IDs from errors

                //  print("invalidItems: $filteredCartItems");
                // variant_01JYTTYYKZ4AM2KZNV8HBZ7MDQ
                // variant_01JYTTYYKZ4AM2KZNV8HBZ7MDQ

                filteredCartItems.forEach((error) {
                  _b2bStoreBloc.add(DeleteItemReq(itemId: error.id ?? ""));
                  //  _b2bStoreBloc.add(AddRemoveItemReq(
                  //             count: error.quantity ?? 0,
                  //             itemId:  error.id ?? ""));
                });
                // Handle the result if needed
              });

              // },
              //  );

              // state.inventoryModel.?.forEach((error) {
              //    _b2bStoreBloc.add(AddRemoveItemReq(
              //                       count: error.requestedQuantity,
              //                       itemId: error.id ?? ""));
              // });

              // EasyLoading.showError(state.inventoryModel.message ?? "Inventory Error");
              // _b2bStoreBloc.add(CheckInventoryError(error: state.inventoryModel.message ?? "Inventory Error"));
            }
          }

          if (state is CheckInventoryError) {
            print("Check Inventory Error: ${state.error}");

            EasyLoading.showError(state.error);
          }

          if (state is DeliveryPartnersSuccess) {
            print("Check pincode Aarati: ${state.response}");
            EasyLoading.dismiss();
            state.response.deliveryCodes!.isEmpty
                ? Fluttertoast.showToast(
                    msg: "Product is not delivaraible at this pincode",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    fontSize: 16.0)
                : _b2bStoreBloc.add(const ProceedToShip());
          }

          if (state is DeliveryPartnersError) {
            print("Check pincode Aarati: ${state.error}");

            // EasyLoading.showError(state.error);
            EasyLoading.showError(
                "Product is not available at selected pincode.");
          }

          if (state is PromoCodeSuccess) {
            setState(() {
              isLoading = false;
              errorMessage = null;
              cartModel = state.cartData;

              print("promtionssss ${cartModel?.cart?.promotions} ");

              final userEnteredCode = _promoController.text.trim();
              final promoList = cartModel?.cart?.promotions ?? [];

              // ✅ Check if user-entered code is applied and not "woloo_coins"
              var isUserCodeApplied = promoList.any((promo) =>
                  promo.code?.toLowerCase() == userEnteredCode.toLowerCase());
              isWolooPromotionApplied = isUserCodeApplied;

              print("woloo code $isWolooPromotionApplied ");

              if (!isUserCodeApplied) {
                state.message == "Promo code removed successfully!"
                    ? null
                    : showDialog(
                        context: context,
                        builder: (context) => const InvalidPromoCodeDialog(),
                      );
                // isUserCodeApplied = false;
              }
              // ✅ Check if WOLOO_COINS promo is applied
              final isWolooApplied = promoList.any(
                (promo) => promo.code?.toLowerCase() == "woloo_coins",
              );
              isWolooPointsApplied = isWolooApplied;

              // ✅ Clear promo field if promo was removed
              if (state.message?.contains("removed") ?? false) {
                _promoController.clear();
              } else {
                _promoController.text = userEnteredCode;
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
          if (state is RestockSubscriptionsLoading) {
            EasyLoading.show(status: state.message);
          }
          if (state is RestockSubscriptionsSuccess) {
            EasyLoading.dismiss();
            //  _refresh();
            EasyLoading.showSuccess("Notification set successfully");
            // Navigator.of(context).pop();
          }
          if (state is RestockSubscriptionsError) {
            EasyLoading.dismiss();
            EasyLoading.showError(state.error);
          }

          // if (selectedAddress.value.id == null) {
          //   showModalBottomSheet(
          //     isScrollControlled: true,
          //     isDismissible: false, // <-- Allow tap outside to dismiss
          //     enableDrag: true, // <-- Allow swipe down to dismiss
          //     backgroundColor: Colors
          //         .transparent, // Optional: if you want rounded corners to show correctly
          //     context: context,
          //     builder: (_) =>
          //     const AddressChangeBottomSheet(), //AddressBottomSheet
          //   );
          // }
        },
        builder: (context, snapshot) {
          return Scaffold(
              bottomSheet: cartModel?.cart.items?.isEmpty ?? true
                  ? const SizedBox.shrink()
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            12), // optional for rounded look
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.1), // shadow color
                            blurRadius: 10, // soften the shadow
                            spreadRadius: 2, // extend the shadow
                            offset:
                                const Offset(0, 4), // move shadow down (x, y)
                          ),
                        ],
                      ),
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
                            _b2bStoreBloc.add(const CheckInventory());
                            // _b2bStoreBloc.add(const ProceedToShip());
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
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        spacing: 16.h,
                        children: [
                          CartHeader(
                            imgPath: AppImages.cart,
                            title: "Cart",
                            subtitle: 'Checkout your purchases from here',
                          ),
                          const SizedBox(
                            height: 1,
                            child: Divider(
                              color: Colors.grey,
                              thickness: 1,
                              height: 1,
                            ),
                          ),
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
                            Transform.translate(
                              offset: const Offset(0, -10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Total Items: ${cartModel?.cart.items?.length} Unit",
                                  style: AppTextStyle.font14bold,
                                ),
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
                                  // padding: EdgeInsets.symmetric(vertical: 8.h),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8), // Outer spacing
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
                                    isFromCartSummery: false,
                                  ),
                                );
                              },
                            ),
                            // const Divider(),

                            BlocConsumer(
                                bloc: subcriptionBloc,
                                listener: (context, state) {
                                  print("dssa $state");
                                  if (state is SubscriptionLoading) {
                                    EasyLoading.show(status: state.message);
                                  }

                                  if (state is GetUserCoins) {
                                    EasyLoading.dismiss();

                                    print(
                                        "woloo coins ${state.coinsModel.results}");

                                    wolooPoints = state.coinsModel.results;

                                    // YYYY-MM-DD format

                                    // gender = state.tasklist;
                                  }

                                  if (state is SubscriptionError) {
                                    EasyLoading.dismiss();
                                    EasyLoading.showError(state.error);
                                  }
                                },
                                builder: (context, state) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: Image.asset(
                                                  AppImages.appLogo),
                                            ),
                                            Text(
                                              "Redeem your Woloo Points",
                                              style: TextStyle(
                                                fontFamily: 'CenturyGothic',
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "You have $wolooPoints Woloo Points to Redeem",
                                          style: TextStyle(
                                            fontFamily: 'CenturyGothic',
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
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
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2),
                                              )
                                            else ...[
                                              Expanded(
                                                child: Text(
                                                  "Redeem ${wolooPoints < 10 ? wolooPoints : 10} woloo points \u{20B9}${wolooPoints < 10 ? wolooPoints : 10}/-",
                                                  style: AppTextStyle.font10bold
                                                      .copyWith(
                                                    color:
                                                        wolooPointsError != null
                                                            ? Colors.red
                                                            : Colors.grey,
                                                    fontFamily: 'CenturyGothic',
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              CyanTextButton(
                                                onTap: isWolooPointsLoading
                                                    ? null
                                                    : () {
                                                        if (wolooPointsError !=
                                                            null) {
                                                          // Retry action
                                                          _b2bStoreBloc.add(
                                                              const ApplyWolooPointsEvent());
                                                        } else if (isWolooPointsApplied) {
                                                          // Remove points
                                                          setState(() {
                                                            box.remove(box.read(
                                                                    'cart_id') +
                                                                "wolooPoints");
                                                            //   isWolooPointsApplied = false;
                                                          });
                                                          _b2bStoreBloc.add(
                                                              const RemoveWolooPointsEvent());
                                                        } else {
                                                          // Apply points
                                                          setState(() {
                                                            // isWolooPointsApplied = true;
                                                            box.write(
                                                                box.read(
                                                                        'cart_id') +
                                                                    "wolooPoints",
                                                                true);
                                                          });
                                                          _b2bStoreBloc.add(
                                                              const ApplyWolooPointsEvent());
                                                        }
                                                      },
                                                /* label: wolooPointsError != null
                                                  ? "Retry"
                                                  : (isWolooPointsApplied ? "Remove" : "Apply"),*/
                                                label: isWolooPointsApplied
                                                    ? "Remove"
                                                    : "Apply",
                                                color: AppColors.lightCyanColor,
                                              ),
                                            ],
                                            if (wolooPointsError != null)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4),
                                                child: Text(
                                                  wolooPointsError!,
                                                  style: AppTextStyle.font10bold
                                                      .copyWith(
                                                          color: Colors.red),
                                                ),
                                              )
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                }),
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
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
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Image.asset(
                                            AppImages.salePercentage),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: _promoController,
                                        enabled: !isLoading,
                                        style: TextStyle(
                                          fontFamily: 'CenturyGothic',
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          isCollapsed: true,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          hintText: "Enter Promocode",
                                          errorText: errorMessage,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    CyanTextButton(
                                      onTap: isLoading
                                          ? null
                                          : () {
                                              if (isWolooPromotionApplied) {
                                                _removePromoCode();
                                              } else {
                                                _applyPromoCode();
                                              }
                                            },
                                      label: isWolooPromotionApplied
                                          ? "Remove"
                                          : "Apply",
                                      color: AppColors.lightCyanColor,
                                    ),
                                  ],
                                )),
                            /*   if (_promoController.text != "") ...[
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
                                  ],*/
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
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
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
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
                                      //     Text(
                                      // address!.addressName ?? selectedAddress.value.addressName.toString(),
                                      //       style: TextStyle(
                                      //         fontFamily: 'CenturyGothic',
                                      //         fontSize: 15.sp,
                                      //         fontWeight: FontWeight.bold,
                                      //         color: Colors.black,
                                      //       ),
                                      //     ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          // if (selectedAddress.value.id == null) {
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            isDismissible: false,
                                            // <-- Allow tap outside to dismiss
                                            enableDrag: true,
                                            // <-- Allow swipe down to dismiss
                                            backgroundColor: Colors.transparent,
                                            // Optional: if you want rounded corners to show correctly
                                            context: context,
                                            builder: (_) =>
                                                const AddressChangeBottomSheet(), //AddressBottomSheet
                                          ).then((value) {
                                            // .then(v){
                                            // getAddress();
                                            setState(() {});
                                          });
                                          ;
                                          // }
                                        },
                                        child: Text(
                                          "Change",
                                          style: TextStyle(
                                            fontFamily: 'CenturyGothic',
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Divider(
                                          thickness: 1,
                                          color: AppColors.greyBorder,
                                        ),
                                      ),
                                      Spacer(
                                        flex: 4,
                                      )
                                    ],
                                  ),
                                  ValueListenableBuilder<Addresses>(
                                      valueListenable: selectedAddress,
                                      builder: (context, value, child) {
                                        address = globalStorage.getAddress();
                                        return Text(
                                          (() {
                                            final parts = [
                                              address?.address1 ??
                                                  value.address1,
                                              address?.city ?? value.city,
                                              address?.postalCode ??
                                                  value.postalCode,
                                            ]
                                                .where((e) =>
                                                    e != null && e!.isNotEmpty)
                                                .toList();
                                            return parts.isNotEmpty
                                                ? parts.join(', ')
                                                : "Select New Address";
                                          })(),
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: Colors.grey,
                                          ),
                                        );
                                      }),
                                  // Text(
                                  // address!.address1 ??  selectedAddress.value.address1.toString(),
                                  //   style: TextStyle(
                                  //     fontFamily: 'CenturyGothic',
                                  //     fontSize: 14.sp,
                                  //     fontWeight: FontWeight.normal,
                                  //     color:AppColors.textgreyColor,
                                  //   ),
                                  // )
                                ],
                              ),
                            ),

                            const Divider(),
                            PricingCalculate(
                              itemTotal:
                                  cartModel?.cart.originalItemTotal.toString(),
                              discount: cartModel?.cart.discountTotal
                                  ?.toStringAsFixed(2),
                              total: cartModel?.cart.total.toString(),
                              subTotal: cartModel?.cart.subtotal.toString(),
                              /*  shipping: cartModel?.cart.shippingTotal
                                  .toString(),*/
                              shipping: shippingAmount.toString(),
                            ),
                            const SizedBox(
                              height: 70,
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // shadow color
              blurRadius: 10, // soften the shadow
              spreadRadius: 2, // extend the shadow
              offset: const Offset(0, 4), // move shadow down (x, y)
            ),
          ],
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
    final discount = double.parse(widget.discount.toString());
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
            if (widget.isHeader) ...[
              Text(
                "Order Summary",
                style: TextStyle(
                    fontFamily: 'CenturyGothic',
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
            ItemNamePrice(
              item: "Item Total",
              price: "\u{20B9} ${widget.itemTotal!}/-",
            ),
            ItemNamePrice(
              item: "Discount",
              price: "\u{20B9} ${discount}/-",
            ),
            /* widget.shipping != "" && widget.shipping != "0"
            ? ItemNamePrice(
                item: "Shipping",
                price: "\u{20B9} ${widget.shipping!.split(".").first}/-",
              )
            : const ItemNamePrice(
                item: "Shipping",
                price: "\u{20B9} 0/-",
              ),*/
            (widget.shipping!.isNotEmpty || widget.shipping != "0")
                ? ItemNamePrice(
                    item: "Shipping",
                    price: "\u{20B9} ${widget.shipping!}/-",
                  )
                : const SizedBox.shrink(),
            // ItemNamePrice(
            //   item: "Item Total",
            //   price: "\u{20B9} $subTotal",
            // ),
            const Divider(),
            ItemNamePrice(
              item: "Grand Total",
              price: "\u{20B9} ${widget.total!}/-",
              itemStyle:
                  TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
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
        Expanded(
          flex: 2, // weight = 1
          child: Text(
            item,
            style: itemStyle ??
                TextStyle(
                    fontFamily: 'CenturyGothic',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1, // weight = 1
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              price,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontFamily: 'CenturyGothic',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textgreyColor),
            ),
          ),
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
        borderRadius: BorderRadius.circular(20.0),
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
              fontFamily: 'CenturyGothic',
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
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.only(left: 15),
      child: Row(
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
                  style: TextStyle(
                      fontFamily: 'CenturyGothic',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style:
                      TextStyle(fontFamily: 'CenturyGothic', fontSize: 12.sp),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
