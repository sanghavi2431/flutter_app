import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:woloo_smart_hygiene/app.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/bloc/dashboard_event.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/bloc/dashboard_state.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/subcription/bloc/subscription_event.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

import '../../../../core/local/global_storage.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_images.dart';
import '../../../utils/client_images.dart';
import '../../../widgets/CustomButton.dart';
import '../../dashbaord/bloc/dashboard_bloc.dart';
import '../../dashbaord/view/dashboard.dart';
import '../../login/bloc/signup_bloc.dart';
import '../bloc/subscription_bloc.dart';
import '../bloc/subscription_state.dart';
import '../data/model/plan_req_model.dart';

class SubcriptionScreen extends StatefulWidget {
  ClientDashBoardBloc?  dashBoardBloc; 
   bool? isfromFacility;
   int? facilityId;
   bool isFromTrail;
  // = ClientDashBoardBloc();
   SubcriptionScreen({super.key, this.dashBoardBloc, required this.isfromFacility, this.facilityId,
   
   this.isFromTrail = false});

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
  String merchantKeyValue = 
  
  // "rzp_live_A0MkofC7Jj2xXK";

  "rzp_test_ZIlhyKgx2C38vT";
  // rzp_test_ZIlhyKgx2C38vT
  // rzp_live_A0MkofC7Jj2xXK
  String amountValue = "";
  String orderIdValue = "";
  String mobileNumberValue = "";
    SubcriptionBloc subcriptionBloc = SubcriptionBloc();
      Map<String, dynamic>? decodedToken;
  GlobalStorage globalStorage = GetIt.instance();
  String orderId = "" ;
  String? facalityRef = "";
    String erroradminMessage = '';

  // ClientDashBoardBloc  dashBoardBloc = ClientDashBoardBloc();
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
     razorpay = Razorpay();


     // razorpay.
    // razorpay = Razorpay("rzp_test_qRGYYA5wZrpFvJ");
  }


  @override
  Widget build(BuildContext context) {
    return 
    // Scaffold(
    //   backgroundColor: AppColors.white,
    //   appBar: AppBar(
    //     backgroundColor: AppColors.white,
    //   ),
    //   body: 
      Container(
        height: 600,
         
         decoration: const BoxDecoration(
          color: AppColors.white,
              borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(80.0),
                      topRight: Radius.circular(80.0),
                    ),
         ),

        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric( horizontal: 16 ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  // subtitle: Text(
                  //   SubcriptionConstant.upgradeDescription,
                  //   style: AppTextStyle.font12bold,
                  // ),
                ),
                const SizedBox(
                height: 10,
              ),
          
                // subCard(SubcriptionConstant.freePlan, SubcriptionConstant.freeFeature),
                  const SizedBox(
                   height: 30,
                    ),
                 BlocConsumer(
                  bloc: widget.dashBoardBloc,
                  listener: (context, state) {
                     print("dssa $state");
                    if ( state is SubscriptionLoading  ){

                      EasyLoading.show(status: state.message);
                    }

                    if( state is Subcription ){

                      // YYYY-MM-DD format
                      // DateTime dateTime = DateTime.parse(dateString);
                      // amountValue  =     state.orderModel.results.amount.toString(); // Example future date
                      // orderId =   state.orderModel.results.id.toString();
                      // print("amount $amountValue");
                      // print("order $orderId");
                      EasyLoading.dismiss();

                    }
                    if(state is SubscriptionError  ){

                      EasyLoading.dismiss();
                      EasyLoading.showError( state.error);

                    }
                  },
                   builder: (context, state) {
                     return 
                     ListView.builder(
                       shrinkWrap:  true,
                      physics: const NeverScrollableScrollPhysics(),
                       itemCount: plan.length,
                      itemBuilder:  (context, index) {
                        return  GestureDetector(
                           onTap: () {
                             setState(() {
                               selectedIndex = index;

                             });
                                var some =   globalStorage.getClientId();
        mobileNumberValue    =   globalStorage.getClientMobileNo();
                              if(selectedIndex == 0){

         subcriptionBloc.add( CreateOrderEvent(
       isFromFacility: widget.isfromFacility,
      clientId: some,
      planReqModel: [
        PlanReqModel(
          itemType: "plan",
          qty: 1,
          itemId: 7,
          facilityId: widget.facilityId ?? 0,
          isRenewal: true,
          startAfterCurrent: false 
        )
      ]
     ));

                              }else {
      

         print("mobile no $mobileNumberValue");
    // decodedToken = JwtDecoder.decode(some);

     subcriptionBloc.add( CreateOrderEvent(
       isFromFacility: widget.isfromFacility,
      clientId: some,
      planReqModel: [
        PlanReqModel(
          itemType: "plan",
          qty: 1,
          itemId: 5,
          facilityId: widget.facilityId ?? 0,
          isRenewal: true,
          startAfterCurrent: false 
        )
      ]
     ));
                              }
                           },
           child: subCard(plan[index], SubcriptionConstant.premiumFeature, index));
                     }, );
                    
                   }
                 ),
                  //  const SizedBox(
                  //  height: 10,
                  //   ),
                    // selectedIndex 
                                                       erroradminMessage.isNotEmpty ?
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 8.0),
                                                            child: Text(
                                                              erroradminMessage,
                                                              style: const TextStyle(color: Colors.red),
                                                            ),
                                                          ) : const SizedBox(),

                    SizedBox(height: 10,),

                                BlocConsumer(
                bloc: subcriptionBloc,
                 listener: (context, state) {
                       if ( state is SubscriptionLoading  ){

                 EasyLoading.show(status: state.message);
               }

               if( state is CreateOrder ){

                      
                             // YYYY-MM-DD format
                           // DateTime dateTime = DateTime.parse(dateString);
                    amountValue  =     state.orderModel.results!.amount.toString(); // Example future date
                    orderId =   state.orderModel.results!.id.toString();

                              //  state.orderModel.results.notes!.forEach((element) {
                              //    //  print("notes ${element.note}");
                              //    if(element.facalityRef == "facility_ref"){
                              //      facalityRef = element.facalityRef.toString();
                              //    }
                              //  });
                                 print("notes ${state.orderModel.results!.notes!.first.facilityRef}");

                                  if(!widget.isfromFacility!){

                                  facalityRef  =  state.orderModel.results!.notes!.first.facilityRef!;                                
                              //  print("notes ${state.orderModel.results.notes!.first.facilityRef}");
                                  globalStorage.saveFacilityRef( accessFacilityRef: facalityRef.toString());

                                  }


                     print("amount $amountValue");
                    print("order $orderId");
                    EasyLoading.dismiss();
                 // gender = state.tasklist;

               }
               if(state is SubscriptionError  ){

                 EasyLoading.dismiss();
                 EasyLoading.showError( state.error);

               }

                 },
                
                 builder: (context, state) {
                   return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                   minimumSize:   Size( MediaQuery.of(context).size.width/1.1 , 59),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12), // <-- Radius
                                  ),
                                backgroundColor: AppColors.backgroundColor
                   
                              ),
                   
                              onPressed: (){
                                     if (selectedIndex == -1) {
                                      setState(() {
                                        erroradminMessage = 'Please select a plan';
                                      });
                                    } else {
                                      setState(() {
                                        erroradminMessage = '';
                                      });
                                      // Proceed with the next steps
                                      // print("Selected: ${facility[selectedIndex].title!}");
                                    }
                                 if(amountValue.isNotEmpty){
                                  
                             razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
                             razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
                             razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
                             razorpay.open(getPaymentOptions());

                                 }
                                
                          
                   
                              }, child: Text("Pay Now",
                           style: AppTextStyle.font20bold.copyWith(
                             // color: AppColors.white
                           ),
                          ) );
                 }
               ),
               SizedBox(
                   height: 30,
                    ),
             
              ],
            ),
          ),
        ),
      // ),
    );
  }
  Widget subCard(String title, String description , int index) {
  return Container(
    padding: const EdgeInsets.symmetric(
        horizontal: 20,
        // vertical: 20,
      ),
      margin: const EdgeInsets.only( bottom: 20),
    decoration: BoxDecoration(
        color: AppColors.white, // Background color of the container
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2), // Shadow color
            spreadRadius: 1, // How wide the shadow should spread
            blurRadius: 10, // The blur effect of the shadow
            offset: const Offset(0, 0), // No offset for shadow on all sides
          ),
        ],
           border:  Border.all(
                         color: selectedIndex == index ?  AppColors.backgroundColor : AppColors.white
                     ),
        borderRadius: BorderRadius.circular(27)),
    child: Column(
      children: [

         const SizedBox(
           height: 15,
         ),          
           CustomImageProvider( 
            image: ClientImages.taskMasterblack,
            width: 109,
            height: 60,
           ),
         
        //  const SizedBox(
        //    height: 15,
        //  ),
        // Text(
        //   title,
        //   style: AppTextStyle.font18bold,
        // ),
        const SizedBox(
          height: 6,
        ),
        Text(
           title,
          style: AppTextStyle.font14bold,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 10,
        ),
        // row(SubcriptionConstant.freeTotalLogins),
        // const SizedBox(
        //   height: 10,
        // ),
        // row(SubcriptionConstant.freeSupervisorLogin),
        // const SizedBox(
        //   height: 10,
        // ),
        // row(SubcriptionConstant.freeJanitorLogins),
        // const SizedBox(
        //   height: 10,
        // ),
        // row(SubcriptionConstant.freeLocation),
        // const SizedBox(
        //   height: 10,
        // ),
        // row(SubcriptionConstant.freeFacilities),
        //  const SizedBox(
        //   height: 15,
        // ),



        // const SizedBox(
        //   height: 20,
        // ),
      ],
    ),
  );
}

Widget row(
  String title,
) {
  return Padding(
    padding: const EdgeInsets.only(left: 35 ),
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
      'amount': int.parse(amountValue),
      'name': 'Woloo',
      'description': 'Premium Plan',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'order_id': orderId,
      'prefill': {
        'contact': mobileNumberValue,
        'email': 'test@razorpay.com'
      },
      'external': {
        'wallets': ['paytm']
      }
    };
  }

    void handlePaymentErrorResponse(PaymentFailureResponse response){

    /** PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    **/
              showDialog(
                              // barrierDismissible: false,
                              context: context, builder:
                              (context) {
                                return 
                                 AlertDialog(
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
                                  content:
                                  SingleChildScrollView(
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

  void handlePaymentSuccessResponse(PaymentSuccessResponse response){

    /** Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    **/
    
      globalStorage.getClientId();
      String clintId = globalStorage.getClientId();
           if(widget.isfromFacility!){
             widget.dashBoardBloc!.add(SubcriptionEvent(id: int.parse(clintId)));
                                           
                                              
                                               }
    //    widget.dashBoardBloc!.add( SubcriptionEvent(
    //      id: int.parse(clintId)
    //  ) );
                // if(widget.isfromFacility!){
                       print("is from facility");

                      globalStorage.savePaymentId(accessPayemntId: response.paymentId! );

                // }
        
                        showDialog(
                              // barrierDismissible: false,
                              context: context, builder:
                              (context) {
                                return 
                                 AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  
                                  backgroundColor: AppColors.white,
                                  // title:  Center(
                                  //   child: Text("Your Free Subscription has expired",
                                  //    style: AppTextStyle.font20bold,
                                  //    textAlign: TextAlign.center,
                                  //   ),
                                  // ),
                                  content:
                                  SingleChildScrollView(
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

                                            // plan[selectedIndex] ?

                                           var facalityref =    globalStorage.getFacilityRef();


                                              print("facilit ref ${widget.isfromFacility}");
                                          
                                         

                                              
                                                  if(facalityref!.isNotEmpty){
                                    // ClientDashBoardBloc dashBoardBloc  = ClientDashBoardBloc();
                                                        widget.dashBoardBloc!.add(
                                                            PaymentStatusEvent(
                                                            refId: facalityref
                                                             )
                                                        );
                                                        
                                                  // dashBoardBloc.add( PaymentStatusEvent(refId: facalityRef));

                                                  }




                                               Navigator.of(context).pop();
                                               Navigator.of(context).pop();
                                               if (widget.isfromFacility! && widget.isFromTrail  == false  ) {
                                                
                                                Navigator.of(context).pop();
                                                 
                                               }

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

    // showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
      
  }

  void handleExternalWalletSelected(ExternalWalletResponse response){
    showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }


   void showAlertDialog(BuildContext context, String title, String message){
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed:  () {},
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
// }

   void showAlertDialoggg(BuildContext context, String title, String message){
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed:  () {},
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




}


