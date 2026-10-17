import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:razorpay_web/razorpay_web.dart';
import 'package:woloo_smart_hygiene/b2b_store/address_change_bottomsheet.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_bloc.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_event.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_state.dart';
import 'package:woloo_smart_hygiene/b2b_store/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/ecom.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/address.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/order_details.dart';
import 'package:woloo_smart_hygiene/b2b_store/network/product.dart';
import 'package:woloo_smart_hygiene/b2b_store/order_details_from_checkout.dart';
import 'package:woloo_smart_hygiene/client_flow/utils/client_images.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:woloo_smart_hygiene/widgets/cart_bottomsheet.dart';
import 'package:woloo_smart_hygiene/widgets/dialogs/order_successful.dart';

import '../b2b_store/order_suucess_dialog.dart';
import '../client_flow/screens/dashbaord/view/dashboard.dart';
import 'boxes/cart_item.dart';

class OrderSummeryBottomSheet extends StatefulWidget {
  const OrderSummeryBottomSheet({
    super.key,
  });

  @override
  State<OrderSummeryBottomSheet> createState() =>
      _OrderSummeryBottomSheetState();
}

class _OrderSummeryBottomSheetState extends State<OrderSummeryBottomSheet> {
  GlobalStorage globalStorage = GetIt.instance();
  final B2bStoreBloc _b2bStoreBloc = B2bStoreBloc();
  bool _isDataLoaded = false;
  CartModel? cartModel;
  Addresses? address;
  final box = GetStorage();
  String order_id = "";
  int wolooPoints = 0;
  int wolooPointsUsed = 0;
  bool isWolooApplied = false;
  bool isPromoApplied = false;
  String promoName = "";
  // Razorpay razorpay = Razorpay();

  late Razorpay razorpay;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
    _b2bStoreBloc.add(const GetCartData());
    address = getAddress();
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
            if (state.wolooPoints > 0) {
              wolooPoints = state.wolooPoints;
            }
            print("aarati $wolooPoints");
            // _addressesData = state.addressesData;
            // _b2bStoreHomePage = state.dashboardData;
            cartModel = state.cartData;
            _isDataLoaded = true;

            final promoList = cartModel?.cart?.promotions ?? [];

            if (promoList.isNotEmpty) {
              final found = promoList
                  .any((promo) => promo.code?.toLowerCase() == "woloo_coins");

              if (found) {
                final woloocode = promoList.firstWhere(
                  (promo) => promo.code?.toLowerCase() == "woloo_coins",
                );

                print("aarati 2 ${woloocode.applicationMethod!.value}");

                setState(() {
                  isWolooApplied = true;
                  wolooPointsUsed = woloocode.applicationMethod!.value!;
                });
              } else {
                setState(() {
                  isWolooApplied = false;
                });
              }
            }

            print("aarati $wolooPointsUsed  $isWolooApplied");

            if (promoList != null) {
              isPromoApplied = promoList.any(
                (promo) => promo.code?.toLowerCase() != "woloo_coins",
              );
              if (isPromoApplied) {
                final userPromo = promoList.firstWhere(
                    (promo) => promo.code?.toLowerCase() != "woloo_coins");

                // Safely parse the discount or amount from the promo object
                promoName = userPromo.code!;
              }
            }
          });
        }

        if (state is CartError) {
          EasyLoading.dismiss();
          EasyLoading.showError(state.error);
        }
        if (state is PaymentSuccess) {
          EasyLoading.dismiss();
          Navigator.pop(context);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (c) => OrderScreenCheckout(
                      orderSet: OrderSet.fromJson(
                          state.completeVendor.orderSet?.toJson() ?? {}),
                      // orderSet: state.completeVendor.orderSet,
                    )),
            (route) => false,
          );
        }
        if (state is LetsTryState) {
          setState(() {
            order_id = state.orderId;
          });
          EasyLoading.dismiss();
          final v = {
            "key": "rzp_test_ZIlhyKgx2C38vT",
            "amount": state.totalPrice * 100,
            "name": "Woloo",
            "description": "Premium Plan",
            "retry": {"enabled": true, "max_count": 1},
            "send_sms_hash": true,
            "order_id": state.orderId,
            "prefill": {"contact": "8097473483", "email": "test@razorpay.com"},
            "external": {
              "wallets": ["paytm"]
            }
          };
          razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
          razorpay.on(
              Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
          razorpay.on(
              Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
          razorpay.open(v);
        }
      },
      builder: (context, state) {
        return !_isDataLoaded
            ? Container()
            : Container(
                height: MediaQuery.of(context).size.height * 0.75,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(40.r))),
                child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10,
                    children: [
                      const XBottmSheetTopDecor(),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      CartHeader(
                          imgPath: AppImages.list,
                          title: "Cart Summary",
                          subtitle:
                              "Check the summary of your order here before paying"),
                      const Divider(),
                      Text(
                          "Total Items: ${cartModel?.cart.items?.length} Unit",
                          style: AppTextStyle.font14bold,
                        ),
                      Expanded(
                        child: ListView(
                          children: [
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              // Prevents nested scrolling
                              itemCount: cartModel?.cart.items
                                  ?.length, // Replace with your cart item count
                              itemBuilder: (context, index) {
                                final item = cartModel?.cart.items?[index];
                                int count = item?.quantity ?? 0;
                                return Container(
                                  // padding: EdgeInsets.symmetric(vertical: 8.h),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: 
                                  CartItemCard(
                                    item: item,
                                    onDelete: () {},
                                    isFromCartSummery: true,
                                  ),
                                );
                              },
                            ),
                            //const Divider(),
                            isWolooApplied
                                ? Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
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
                                        Text(
                                          "You have $wolooPoints Woloo Points to Redeem",
                                          style: TextStyle(
                                            fontFamily: 'CenturyGothic',
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Text(
                                          "Used points: $wolooPointsUsed",
                                          style: TextStyle(
                                            fontFamily: 'CenturyGothic',
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.greyBorder,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                      ],
                                    ),
                                  )
                                : SizedBox.shrink(),
                            isPromoApplied
                                ? Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
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
                                        Text(
                                          "Promo code Applied: $promoName",
                                          style: TextStyle(
                                            fontFamily: 'CenturyGothic',
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.greyBorder,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                      ],
                                    ),
                                  )
                                : SizedBox.shrink(),
                            // const Divider(),
                            AddressChangeWidget(changeAddress: address),
                            const Divider(),
                            // XDecoratedBox(
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     mainAxisSize: MainAxisSize.min,
                            //     spacing: 10,
                            //     children: [
                            //       const EditHeader(label: "Payment Details"),
                            //       Row(
                            //         children: [
                            //           SizedBox(
                            //               height: 40,
                            //               width: 40,
                            //               child:
                            //                   Image.asset(AppImages.upiIcon)),
                            //           const Text(
                            //             "UPI App",
                            //             style: TextStyle(
                            //                 fontWeight: FontWeight.bold),
                            //           ),
                            //         ],
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // const Divider(),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: PricingCalculate(
                                itemTotal: cartModel?.cart.originalItemTotal
                                    .toString(),
                                discount: cartModel?.cart.discountTotal
                                    ?.toStringAsFixed(2),
                                total: cartModel?.cart.total.toString(),
                                subTotal: cartModel?.cart.subtotal.toString(),
                                shipping:
                                    cartModel?.cart.shippingTotal.toString(),
                              ),
                            ),
                            //    const Divider(),
                            // const SizedBox(
                            //   height: 20,
                            // ),
                          ],
                        ),
                      ),
                      // const Divider(),

                      /*LongLabeledButton(
                        label: "Checkout",
                        onTap: () {
                          // final v = {
                          //   "key": "rzp_test_ZIlhyKgx2C38vT",
                          //   "amount": 58900,
                          //   "name": "Woloo",
                          //   "description": "Premium Plan",
                          //   "retry": {"enabled": true, "max_count": 1},
                          //   "send_sms_hash": true,
                          //   "order_id": "order_QUiITAh35chkgQ",
                          //   "prefill": {
                          //     "contact": "8097473483",
                          //     "email": "test@razorpay.com"
                          //   },
                          //   "external": {
                          //     "wallets": ["paytm"]
                          //   }
                          // };

                          // razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                          //     handlePaymentErrorResponse);
                          // razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                          //     handlePaymentSuccessResponse);
                          // razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                          //     handleExternalWalletSelected);
                          // razorpay.open(v);
                          _b2bStoreBloc.add(const Payment());

                          // try {
                          // _b2bStoreBloc.add(Payment(razorpay: razorpay));
                          // } catch (e) {}
                        },
                      )*/

                      Row(
                        children: [
                          Expanded(
                            child: LongLabeledButton(
                              label: "Checkout",
                              onTap: () {
                                _b2bStoreBloc.add(const Payment());
                              },
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: LongLabeledButton(
                              label: "Keep Shopping",
                              color: Colors.grey.shade300,
                              onTap: () {
                                
                            Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) =>  ClientDashboard(
                                        dashIndex: 0,
                                      )),
                                  (route) => false,
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ]),
              );
      },
    );
  }

  Map<String, Object> getPaymentOptions(
      {required String amountValue, orderId, mobileNumberValue}) {
    String merchantKeyValue = "rzp_test_ZIlhyKgx2C38vT";
    return {
      'key': merchantKeyValue,
      'amount': int.parse(amountValue),
      'name': 'Woloo',
      'description': 'Premium Plan',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'order_id': 'cart_01JV50CYN7X1W3KX62X4G44GQE',
      'prefill': {'contact': mobileNumberValue, 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) async {
    /** PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    **/

    final ProductService productService = ProductService(dio: GetIt.instance());
    await productService
        .createCart(
            token: box.read('login_jwt'), regionId: box.read('region_id'))
        .then((cartData) {
      box.write('cart_id', cartData.cart.id);
    });
    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),

          backgroundColor: AppColors.white,
          // title:  Center(
          //   child: Text("Your Free Subscription has expired",
          //    style: AppTextStyle.font20bold,
          //    textAlign: TextAlign.center,
          //   ),
          // ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                CustomImageProvider(
                  image: ClientImages.warning,
                  width: 86.w,
                  height: 86.h,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  textAlign: TextAlign.center,
                  "Oops! Your payment has not gone through",
                  style: AppTextStyle.font18bold,
                ),
                SizedBox(
                  height: 20.h,
                ),
                // const Custombutton(
                //   width: 300,
                //   text: "Pay Now",
                // )
              ],
            ),
          ),
        );
      },
    );
    // showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  //TODO:implement on success
  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /** Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    **/
    globalStorage.getClientId();
    String clintId = globalStorage.getClientId();
    _b2bStoreBloc.add(PlaceOrder(order_id: order_id));

    // _b2bStoreBloc.add(SubcriptionEvent(id: int.parse(clintId)));
    // if (widget.isfromFacility!) {
    //   print("is from facility");
    //   globalStorage.savePaymentId(accessPayemntId: response.paymentId!);
    // }

    /* showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (context) {
        return const OrderSuccessfulDialog();
      },
    );
*/

    showDialog(
      context: context,
      barrierDismissible: false, // can't dismiss by tapping outside
      builder: (ctx) => buildOrderSuccessDialog(ctx),
    );

    // showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Addresses? getAddress() {
    address = Addresses.fromJson(jsonDecode(box.read("address")));
    // setState(() {});
    return address;
  }
}
