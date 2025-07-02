import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:woloo_smart_hygiene/b2b_store/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/address.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/cart.dart';
// import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_bloc.dart';
// import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_event.dart';
// import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_state.dart';
// import 'package:woloo_smart_hygiene/b2b_store/cart.dart';
// import 'package:woloo_smart_hygiene/b2b_store/ecom.dart';
// import 'package:woloo_smart_hygiene/b2b_store/models/address.dart';
// import 'package:woloo_smart_hygiene/b2b_store/models/cart.dart';
import 'package:woloo_smart_hygiene/client_flow/utils/client_images.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/hygine_services/bloc/hygiene_service_bloc.dart';
import 'package:woloo_smart_hygiene/hygine_services/bloc/hygiene_service_event.dart';
import 'package:woloo_smart_hygiene/hygine_services/bloc/hygiene_service_state.dart';
import 'package:woloo_smart_hygiene/hygine_services/view/hygine_landing.dart';
import 'package:woloo_smart_hygiene/janitorial_services/screens/host_dashboard_screen.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:woloo_smart_hygiene/b2b_store/address_change_bottomsheet.dart';
import 'package:woloo_smart_hygiene/widgets/boxes/cart_item.dart';
import 'package:woloo_smart_hygiene/widgets/cart_bottomsheet.dart';
import 'package:woloo_smart_hygiene/widgets/dialogs/order_successful.dart';

class HygineServicesOrderSummeryBottomSheet extends StatefulWidget {
  const HygineServicesOrderSummeryBottomSheet({
    super.key,
  });

  @override
  State<HygineServicesOrderSummeryBottomSheet> createState() =>
      _OrderSummeryBottomSheetState();
}

class _OrderSummeryBottomSheetState
    extends State<HygineServicesOrderSummeryBottomSheet> {
  GlobalStorage globalStorage = GetIt.instance();
  // final B2bStoreBloc _b2bStoreBloc = B2bStoreBloc();

  final HygieneServiceBloc _hygieneServiceBloc = HygieneServiceBloc();
  bool _isDataLoaded = false;
  CartModel? cartModel;
  Addresses? address;
  final box = GetStorage();
  String order_id = "";
  // Razorpay razorpay = Razorpay();

  late Razorpay razorpay;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
    _hygieneServiceBloc.add(const GetCartData());
    address = getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _hygieneServiceBloc,
      listener: (context, state) {
        if (state is HygieneCartLoading) {
          EasyLoading.show(status: state.message);
        }
        if (state is HygieneServiceCartSuccess) {
          EasyLoading.dismiss();
          setState(() {
            // print(state.cartData.cart);
            // _addressesData = state.addressesData;
            // _b2bStoreHomePage = state.dashboardData;
            cartModel = state.cartData;
            _isDataLoaded = true;
            // _dashboardData = state.dashboardData;
          });
        }

        if (state is HygieneCartError) {
          EasyLoading.dismiss();
          EasyLoading.showError(state.error);
        }
        if (state is PaymentSuccess) {
          EasyLoading.dismiss();
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const HygieneServicesScreen()),
              (route) => false);
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
                height: MediaQuery.of(context).size.height * 0.6,
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
                          title: "Order Summary",
                          subtitle:
                              "Check the summary of your order here before paying"),
                      const Divider(),
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
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  child: CartItemCard(
                                    item: item,
                                    onDelete: () {
                                      _hygieneServiceBloc.add(DeleteItemReq(
                                          itemId: item?.id ?? ""));
                                    },
                                    onAdd: () {
                                      count++;
                                      _hygieneServiceBloc.add(AddRemoveItemReq(
                                          count: count,
                                          itemId: item?.id ?? ""));
                                    },
                                    onRemove: () {
                                      count--;
                                      if (count > 0) {
                                        _hygieneServiceBloc.add(
                                            AddRemoveItemReq(
                                                count: count,
                                                itemId: item?.id ?? ""));
                                      } else {
                                        _hygieneServiceBloc.add(DeleteItemReq(
                                            itemId: item?.id ?? ""));
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                            const Divider(),
                            AddressChangeWidget(address: address),
                            const Divider(),
                            XDecoratedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                spacing: 10,
                                children: [
                                  const EditHeader(label: "Payment Details"),
                                  Row(
                                    children: [
                                      SizedBox(
                                          height: 40,
                                          width: 40,
                                          child:
                                              Image.asset(AppImages.upiIcon)),
                                      const Text(
                                        "UPI App",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            PricingCalculate(
                              itemTotal:
                                  cartModel?.cart.originalItemTotal.toString(),
                              discount:
                                  cartModel?.cart.discountTotal.toString(),
                              total: cartModel?.cart.total.toString(),
                              subTotal: cartModel?.cart.subtotal.toString(),
                              shipping:
                                  cartModel?.cart.shippingTotal.toString(),
                              // itemTotal: cartModel?.cart.itemTotal,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      const Divider(),

                      LongLabeledButton(
                        label: "Pay via [payment method]",
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
                          _hygieneServiceBloc.add(const Payment());
                          // try {
                          // _b2bStoreBloc.add(Payment(razorpay: razorpay));
                          // } catch (e) {}
                        },
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

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /** PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    **/
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
    _hygieneServiceBloc.add(PlaceOrder(order_id: order_id));

    // _b2bStoreBloc.add(SubcriptionEvent(id: int.parse(clintId)));
    // if (widget.isfromFacility!) {
    //   print("is from facility");
    //   globalStorage.savePaymentId(accessPayemntId: response.paymentId!);
    // }

    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (context) {
        return const OrderSuccessfulDialog();
      },
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
