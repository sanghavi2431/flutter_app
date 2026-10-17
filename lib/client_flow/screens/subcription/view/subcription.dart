import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/bloc/dashboard_event.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/bloc/dashboard_state.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/subcription/bloc/subscription_event.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import '../../../../core/local/global_storage.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_images.dart';
import '../../../utils/client_images.dart';
import '../../../widgets/CustomButton.dart';
import '../../dashbaord/bloc/dashboard_bloc.dart';
import '../bloc/subscription_bloc.dart';
import '../bloc/subscription_state.dart';
import '../data/model/plan_req_model.dart';

// Refactored Subscription Screen with better structure, constants, and modular widgets

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

// -------------------- CONSTANTS --------------------
class Dimens {
  static const double padding = 20;
  static const double radiusLarge = 60;
  static const double radiusMedium = 30;
  static const double spacingSmall = 10;
  static const double spacingMedium = 20;
}

class Strings {
  static const String payNow = "Pay Now";
  static const String selectPlanError = "Please select a plan";
  static const String paymentFailed = "Oops! Your payment has not gone through";
  static const String successMsg = "Your TASKMASTER Facility is now active";
  static const String goHome = "Go to Home";
}

// -------------------- MAIN SCREEN --------------------
class SubcriptionScreen extends StatefulWidget {
  final ClientDashBoardBloc? dashBoardBloc;
  final bool? isfromFacility;
  final int? facilityId;
  final bool isFromTrail;
  final VoidCallback? onGoToHomeClick;

  const SubcriptionScreen({
    super.key,
    this.dashBoardBloc,
    required this.isfromFacility,
    this.facilityId,
    this.isFromTrail = false,
    this.onGoToHomeClick,
  });

  @override
  State<SubcriptionScreen> createState() => _SubcriptionScreenState();
}

class _SubcriptionScreenState extends State<SubcriptionScreen> {
  final List<String> plans = [
    SubcriptionConstant.stinqguardOffer,
    SubcriptionConstant.taskMasterOffer,
  ];

  int selectedIndex = -1;
  late Razorpay razorpay;

  final SubcriptionBloc subcriptionBloc = SubcriptionBloc();
  final GlobalStorage globalStorage = GetIt.instance();

  String amountValue = "";
  String orderId = "";
  String mobileNumberValue = "";
  String? facilityRef = "";
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
  }

  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubcriptionBloc, SubscriptionState>(
      bloc: subcriptionBloc,
      listener: (context, state) {
        if (state is SubscriptionLoading) {
          EasyLoading.show(status: state.message);
        }

        if (state is CreateOrder) {
          EasyLoading.dismiss();

          amountValue = state.orderModel.results!.amount.toString();
          orderId = state.orderModel.results!.id.toString();

          if (!(widget.isfromFacility ?? false)) {
            facilityRef = state.orderModel.results!.notes!.first.facilityRef!;
            globalStorage.saveFacilityRef(
              accessFacilityRef: facilityRef.toString(),
            );
          }
        }

        if (state is SubscriptionError) {
          EasyLoading.dismiss();
          EasyLoading.showError(state.error);
        }
      },
      child:
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimens.radiusLarge),
            topRight: Radius.circular(Dimens.radiusLarge),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Dimens.padding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _Header(),
                  const SizedBox(height: Dimens.spacingMedium),
                  _PlanList(
                    plans: plans,
                    selectedIndex: selectedIndex,
                    onSelect: _onPlanSelected,
                  ),
                  if (errorMessage.isNotEmpty)
                    Text(errorMessage,
                        style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: Dimens.spacingMedium),
                  _PayButton(onPressed: _onPayClicked),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -------------------- LOGIC --------------------

  void _onPlanSelected(int index) {
    setState(() {
      selectedIndex = index;
      errorMessage = '';
    });

    final clientId = globalStorage.getClientId();
    mobileNumberValue = globalStorage.getClientMobileNo();

    subcriptionBloc.add(CreateOrderEvent(
      isFromFacility: widget.isfromFacility,
      clientId: clientId,
      planReqModel: [
        PlanReqModel(
          itemType: "plan",
          qty: 1,
          itemId: index == 0 ? 7 : 5,
          facilityId: widget.facilityId ?? 0,
          isRenewal: true,
          startAfterCurrent: false,
        )
      ],
    ));
  }

  void _onPayClicked() {
    if (selectedIndex == -1) {
      setState(() => errorMessage = Strings.selectPlanError);
      return;
    }
    if (amountValue.isEmpty) {
      EasyLoading.showError("Please wait, creating order...");
      return;
    }

    razorpay.open(_paymentOptions());
  }

  Map<String, Object> _paymentOptions() {
    return {
      'key': APIConstants.RAZORPAY_KEY,
      'amount': int.parse(amountValue),
      'name': 'Woloo',
      'description': 'Premium Plan',
      'order_id': orderId,
      'prefill': {'contact': mobileNumberValue},
    };
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showDialog(
      context: context,
      builder: (_) => const _FailureDialog(),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    EasyLoading.dismiss(); // ✅ VERY IMPORTANT

    final clientId = globalStorage.getClientId();
    globalStorage.savePaymentId(accessPayemntId: response.paymentId!);

    // ✅ Trigger dashboard refresh (OLD FLOW)
    if (widget.isfromFacility ?? false) {
      widget.dashBoardBloc?.add(
        SubcriptionEvent(id: int.parse(clientId)),
      );
    }

    // ✅ Trigger payment status check
    final facilityRef = globalStorage.getFacilityRef();
    if (facilityRef != null && facilityRef.isNotEmpty) {
      widget.dashBoardBloc?.add(
        PaymentStatusEvent(refId: facilityRef),
      );
    }

    // ✅ Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          _SuccessDialog(
            onHome: () {
             /* Navigator.pop(context); // close dialog

              // ✅ CLOSE bottom sheet PROPERLY
              Navigator.of(context).pop(true);

              // ✅ trigger parent refresh
              widget.onGoToHomeClick?.call();*/

              Navigator.pop(context); // close dialog

              // ✅ VERY IMPORTANT: trigger full refresh BEFORE closing
              final clientId = globalStorage.getClientId();

              widget.dashBoardBloc?.add(
                GetAllFacilityEvent(clientId: int.parse(clientId)),
              );

              Navigator.of(context).pop(true); // close bottom sheet

              widget.onGoToHomeClick?.call();

            },
          ),
    );
  }


  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }
}

void showAlertDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.white),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🔹 Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              /// 🔹 Message
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 20),

              /// 🔹 Button
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // ✅ close dialog
                },
                child: Custombutton(
                  text: "Continue",
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// -------------------- WIDGETS --------------------

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CustomImageProvider(image: AppImages.premiumImage, width: 60, height: 60),
      title: const Text(
        SubcriptionConstant.upgradeToPremium,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _PlanList extends StatelessWidget {
  final List<String> plans;
  final int selectedIndex;
  final Function(int) onSelect;

  const _PlanList({required this.plans, required this.selectedIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: plans.length,
      itemBuilder: (_, index) {
        return GestureDetector(
          onTap: () => onSelect(index),
          child: _PlanCard(
            title: plans[index],
            isSelected: selectedIndex == index,
          ),
        );
      },
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final bool isSelected;

  const _PlanCard({required this.title, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5 , vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

          decoration: BoxDecoration(

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Shadow color
                  spreadRadius: 1, // Spread effect
                  blurRadius: 4, // Blur effect
                  offset: const Offset(0, 4), // Bottom shadow
                ),
              ],
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? AppColors.backgroundColor : Colors.white),),

      child: Column(
        children: [
          CustomImageProvider(image: ClientImages.taskMasterblack, width: 109, height: 55),
          const SizedBox(height: 6),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _PayButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _PayButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Custombutton(
        text: Strings.payNow,
        width: double.infinity,
      ),
    );
  }
}

class _FailureDialog extends StatelessWidget {
  const _FailureDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, // for custom UI
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.white),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// ❌ Failure Text
            Text(
              Strings.paymentFailed,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500, // 500
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 20),

            /// ✅ Optional Button (recommended)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Custombutton(
                text: "Try Again",
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessDialog extends StatelessWidget {
  final VoidCallback onHome;

  const _SuccessDialog({required this.onHome});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, // important for custom design
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.white),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// ✅ Success Text
            Text(
              Strings.successMsg,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500, // 500
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 20),

            /// ✅ Button
            GestureDetector(
              onTap: onHome,
              child: Custombutton(
                text: Strings.goHome,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*class SubcriptionScreen extends StatefulWidget {
  ClientDashBoardBloc? dashBoardBloc;
  bool? isfromFacility;
  int? facilityId;
  bool isFromTrail;
  final VoidCallback? onGoToHomeClick;

  SubcriptionScreen(
      {super.key,
      this.dashBoardBloc,
      required this.isfromFacility,
      this.facilityId,
      this.isFromTrail = false,
      this.onGoToHomeClick,});

  @override
  State<SubcriptionScreen> createState() => _SubcriptionScreenState();
}

class _SubcriptionScreenState extends State<SubcriptionScreen> {
  List plan = [
    SubcriptionConstant.stinqguardOffer,
    SubcriptionConstant.taskMasterOffer,
  ];
  int selectedIndex = -1;
  late Razorpay razorpay;
  String merchantKeyValue = APIConstants.RAZORPAY_KEY;
  String amountValue = "";
  String orderIdValue = "";
  String mobileNumberValue = "";
  SubcriptionBloc subcriptionBloc = SubcriptionBloc();
  Map<String, dynamic>? decodedToken;
  GlobalStorage globalStorage = GetIt.instance();
  String orderId = "";
  String? facalityRef = "";
  String erroradminMessage = '';

  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
  }

  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return

        Container(
      height: 500,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60.0),
          topRight: Radius.circular(60.0),
        ),
      ),

      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              ListTile(
                leading: CustomImageProvider(
                  image: AppImages.premiumImage,
                  width: 60,
                  height: 60,
                ),
                title: const Text(
                  textAlign: TextAlign.center,
                  SubcriptionConstant.upgradeToPremium,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              const SizedBox(
                height: 10,
              ),
              BlocConsumer(
                  bloc: widget.dashBoardBloc,
                  listener: (context, state) {
                    print("dssa $state");
                    if (state is SubscriptionLoading) {
                      EasyLoading.show(status: state.message);
                    }

                    if (state is Subcription) {
                      EasyLoading.dismiss();
                    }
                    if (state is SubscriptionError) {
                      EasyLoading.dismiss();
                      EasyLoading.showError(state.error);
                    }
                  },
                  builder: (context, state) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: plan.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                              var some = globalStorage.getClientId();
                              mobileNumberValue =
                                  globalStorage.getClientMobileNo();
                              if (selectedIndex == 0) {
                                subcriptionBloc.add(CreateOrderEvent(
                                    isFromFacility: widget.isfromFacility,
                                    clientId: some,
                                    planReqModel: [
                                      PlanReqModel(
                                          itemType: "plan",
                                          qty: 1,
                                          itemId: 7,
                                          facilityId: widget.facilityId ?? 0,
                                          isRenewal: true,
                                          startAfterCurrent: false)
                                    ]));
                              } else {
                                print("mobile no $mobileNumberValue");
                                subcriptionBloc.add(CreateOrderEvent(
                                    isFromFacility: widget.isfromFacility,
                                    clientId: some,
                                    planReqModel: [
                                      PlanReqModel(
                                          itemType: "plan",
                                          qty: 1,
                                          itemId: 5,
                                          facilityId: widget.facilityId ?? 0,
                                          isRenewal: true,
                                          startAfterCurrent: false)
                                    ]));
                              }
                            },
                            child: subCard(plan[index],
                                SubcriptionConstant.premiumFeature, index));
                      },
                    );
                  }),
              erroradminMessage.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        erroradminMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : const SizedBox(),

              BlocConsumer(
                  bloc: subcriptionBloc,
                  listener: (context, state) {
                    if (state is SubscriptionLoading) {
                      EasyLoading.show(status: state.message);
                    }

                    if (state is CreateOrder) {
                      amountValue = state.orderModel.results!.amount
                          .toString(); // Example future date
                      orderId = state.orderModel.results!.id.toString();
                      print(
                          "notes ${state.orderModel.results!.notes!.first.facilityRef}");
                      if (!widget.isfromFacility!) {
                        facalityRef =
                            state.orderModel.results!.notes!.first.facilityRef!;
                        globalStorage.saveFacilityRef(
                            accessFacilityRef: facalityRef.toString());
                      }
                      print("amount $amountValue");
                      print("order $orderId");
                      EasyLoading.dismiss();
                    }
                    if (state is SubscriptionError) {
                      EasyLoading.dismiss();
                      EasyLoading.showError(state.error);
                    }
                  },
                  builder: (context, state) {

                    return Container(
                      width: MediaQuery.of(context).size.width,
                      //margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: AppColors.backgroundColor,
                        ),
                        onPressed: () {
                          if (selectedIndex == -1) {
                            setState(() {
                              erroradminMessage = 'Please select a plan';
                            });
                          } else {
                            setState(() {
                              erroradminMessage = '';
                            });
                          }
                          if (amountValue.isNotEmpty) {
                            razorpay.open(getPaymentOptions());
                          }
                        },
                        child: Text(
                          "Pay Now",
                          style: AppTextStyle.font16bold.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  }),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget subCard(String title, String description, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: AppColors.white, // Background color of the container
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2), // Shadow color
              spreadRadius: 1, // How wide the shadow should spread
              blurRadius: 4, // The blur effect of the shadow
              offset: const Offset(0, 0), // No offset for shadow on all sides
            ),
          ],
          border: Border.all(
              color: selectedIndex == index
                  ? AppColors.backgroundColor
                  : AppColors.white),
          borderRadius: BorderRadius.circular(27)),
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          CustomImageProvider(
            image: ClientImages.taskMasterblack,
            width: 109,
            height: 55,
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            title,
            style: AppTextStyle.font14bold,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  Widget row(
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 35),
      child: Row(
        children: [
          CustomImageProvider(
            image: AppImages.checkIcons,
            width: 17,
            height: 17,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: AppTextStyle.font14bold,
          ),
        ],
      ),
    );
  }

  Map<String, Object> getPaymentOptions() {
    return {
      'key': merchantKeyValue,
      'amount': int.parse(amountValue), //in the smallest currency sub-unit.
      'name': 'Woloo',
      'description': 'Premium Plan',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'order_id': orderId,
      'prefill': {'contact': mobileNumberValue, 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    print("payment error response ${response.code}");
    print("payment error response ${response.message}");
    print("payment error response ${response.error.toString()}");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          backgroundColor: AppColors.white,
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
              ],
            ),
          ),
        );
      },
    );

  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {


    EasyLoading.dismiss();
    globalStorage.getClientId();
    String clintId = globalStorage.getClientId();
    if (widget.isfromFacility!) {
      widget.dashBoardBloc!.add(SubcriptionEvent(id: int.parse(clintId)));
    }
    print("is from facility");
    globalStorage.savePaymentId(accessPayemntId: response.paymentId!);


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: AppColors.white,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                CustomImageProvider(
                  image: ClientImages.verify,
                  width: 86.w,
                  height: 86.h,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  textAlign: TextAlign.center,
                  "Your TASKMASTER Facility is now active",
                  style: AppTextStyle.font18bold,
                ),
                SizedBox(
                  height: 20.h,
                ),
                GestureDetector(
                  onTap: () {
                    var facalityref = globalStorage.getFacilityRef();

                    print("aarati facilit ref ${widget.isfromFacility} , $facalityref");

                    if (facalityref!.isNotEmpty) {
                      widget.dashBoardBloc!
                          .add(PaymentStatusEvent(refId: facalityref));
                    }
                    Navigator.pop(context);
                    Navigator.of(context).pop(true);
                  },
                  child: const Custombutton(
                    width: 300,
                    text: "Go to Home",
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {

    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showAlertDialoggg(BuildContext context, String title, String message) {
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}*/
