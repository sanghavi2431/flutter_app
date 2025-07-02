

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/subcription/data/model/plan_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/subcription/data/model/plan_req_model.dart';
import 'package:woloo_smart_hygiene/client_flow/utils/client_images.dart';
import 'package:woloo_smart_hygiene/client_flow/widgets/CustomButton.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/leading_button.dart';

import '../../../../core/local/global_storage.dart';
import '../../../../screens/common_widgets/image_provider.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_textstyle.dart';
import '../../dashbaord/bloc/dashboard_bloc.dart';
import '../../dashbaord/bloc/dashboard_event.dart';
import '../bloc/subscription_bloc.dart';
import '../bloc/subscription_event.dart';
import '../bloc/subscription_state.dart';
import '../data/model/facility_status_model.dart';

class PremiumScreeen extends StatefulWidget {
  final TabController? tabController;
  final int? indexTab;
  final ClientDashBoardBloc?  clientDashBoardBloc;
  final bool fromTabbar;
  final bool isfromOnboard;
  const PremiumScreeen({super.key,  
  this.tabController, 
  this.indexTab, 
  required this.fromTabbar,
  this.clientDashBoardBloc,
  this.isfromOnboard = false
  });

  @override
  State<PremiumScreeen> createState() => _PremiumScreeenState();
}

class _PremiumScreeenState extends State<PremiumScreeen> {

   SubcriptionBloc subcriptionBloc = SubcriptionBloc();
   GlobalStorage globalStorage = GetIt.instance();
    PlanModel planModel = PlanModel();
     late Razorpay razorpay;
       String merchantKeyValue = 
  // "rzp_live_A0MkofC7Jj2xXK";
  "rzp_test_ZIlhyKgx2C38vT";
  // rzp_test_ZIlhyKgx2C38vT
  // rzp_live_A0MkofC7Jj2xXK
  String amountValue = "";
  String orderIdValue = "";
  String mobileNumberValue = "";
  String orderId = "" ;
  ClientDashBoardBloc dashBoardBloc  = ClientDashBoardBloc();


   @override
  void initState() {
    // TODO: implement initState
    super.initState();

 
   subcriptionBloc.add( const PlanEvent( ));
    // subcriptionBloc.add( GetFacilityStatusEvent( decodedToken["clientId"]));
    // subcriptionBloc.add( GetFacilityStatusEvent( mobileNumberValue));

    razorpay = Razorpay();

  }

  List plan = [
    SubcriptionConstant.stinqguardOffer,
    SubcriptionConstant.taskMasterOffer,
  ];

  int selectedIndex = -1;
  int selectedFacility = -1;
List<Result> inactiveFacilities = [];

List<PlanReqModel> planReqModel = [];


 int itemTotal = 0;


    


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const LeadingButton(),
        leadingWidth: 100,
        // title: const Text('Premium'),
      ),
      body: 
  SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric( horizontal: 16),
      child: Column(children: [  
                    ListTile(
                      contentPadding: const EdgeInsets.all( 0),
                      leading: CustomImageProvider(
                        image: AppImages.premiumImage,
                        width: 60,
                        height: 60,
                      ),
                      title: const Text(
                    
                       "Upgrade to Premium",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      subtitle: Text(
                        "Upgrade to a premium plan to explore more benefits",
                        style: AppTextStyle.font12,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                       ),
                  BlocConsumer(
                     bloc: subcriptionBloc, 
                     listener: (context, state) {
                      if (state is SubscriptionLoading) {
                        EasyLoading.show(status: state.message);
                      } else if (state is SubscriptionError) {
                        EasyLoading.dismiss();
                        EasyLoading.showError(state.error);
                      } else if (state is GetPlan) {
                          planModel = state.planModel!;
                         
                        EasyLoading.dismiss();
                      }
                     },
                     builder: (context, state) {
                      // if (state is GetPlan) {
                      //     planModel = state.planModel!;
                      //   // EasyLoading.dismiss();
                      //   print("planModel ${planModel.results!.plans!.length}");
                      // }
                      return 
                      planModel.results == null ? const SizedBox() :
                     ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: planModel.results!.plans!.length,
                    itemBuilder: (context, index) => 
                    GestureDetector(
                    onTap: () {

                      setState(() {
                        selectedIndex = index;
                      });
                       print("selectedIndex $selectedIndex");
                            var some =   globalStorage.getClientId();
                                         inactiveFacilities.clear();
                       mobileNumberValue    =   globalStorage.getClientMobileNo();  
                            subcriptionBloc.add( FacilityStatusEvent( 
                               clientId: some,
                               plan: selectedIndex == 0 ? "PREMIUM" : "CLASSIC"   
                                 
                                 ));

                    },
                      child: planCard(
                         planModel.results!.plans![index], index),
                    ),
                    // ),
                  );
                    // }
                    // return Container();
                  }),
                  

                  BlocConsumer<SubcriptionBloc, SubscriptionState>(
                    bloc: subcriptionBloc,
                    listener: (context, state) {
                      if (state is SubscriptionLoading) {
                        EasyLoading.show(status: state.message);
                      } else if (state is SubscriptionError) {
                        EasyLoading.dismiss();
                        EasyLoading.showError(state.error);
                      } else if (state is GetFacilityStatus) {
                        EasyLoading.dismiss();
                       inactiveFacilities = state.facilityStatusModel.results!;
                       
                        // state.facilityStatusModel.results!.where((element) => element.subscriptionStatus == "inactive" ).toList();
                        
                         print("inactiveFacilities ${inactiveFacilities.length}");
                      }

                      if( state is CreateOrder ){

                      
                             // YYYY-MM-DD format
                           // DateTime dateTime = DateTime.parse(dateString);
                    amountValue  =     state.orderModel.results!.amount.toString(); // Example future date
                    orderId =   state.orderModel.results!.id.toString();
                     print("amount $amountValue");
                           razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
                            razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
                            razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
                            razorpay.open(getPaymentOptions());

                    print("order $orderId");
                    EasyLoading.dismiss();
                 // gender = state.tasklist;

               }
                    },

                    builder: (context, state) {
                      // if (state is SubscriptionLoading) {

                      //   EasyLoading.show(status: state.message);
                      // } else if (state is GetFacilityStatus) {
                      //   EasyLoading.dismiss();
       

                        return 
                        inactiveFacilities.isEmpty ? const SizedBox()  :
                        totalWidget(inactiveFacilities);
                        // Column(
                        //   children: state.facilityStatusModel.results!
                        //       .map((facility) => CheckboxListTile(
                        //             title: Text(facility.facilityName!),
                        //             value: facility.value,
                        //             onChanged: (value) {
                        //               setState(() {
                        //                 facility.value = value!;
                        //               });
                        //             },
                        //           ))
                        //       .toList(),
                        // );
                      // } else if (state is SubscriptionError) {
                      //   EasyLoading.dismiss();
                      //   EasyLoading.showError( state.error.message);
                      // }
                      // return Container();
                    },
                  )



                  // totalWidget(),
           
                

      ],),
    ),
 

  ) ,
  // bottomNavigationBar: Container(
  //   decoration: BoxDecoration(
  //     color: Colors.white,
  //     borderRadius: BorderRadius.circular(15),
  //     //  boxShadow: [
  //     //   BoxShadow(
  //     //     color: Colors.black.withValues( alpha: 0.2), // Shadow color
  //     //     spreadRadius: 1, // How wide the shadow should spread
  //     //     blurRadius: 10, // The blur effect of the shadow
  //     //     offset: const Offset(0, 5), // Shadow offset, with y-offset for bottom shadow
  //     //   ),
  //     // ],
  //   ),
  //   height: 90,
  //   width: double.infinity,
  //   padding: const EdgeInsets.symmetric( horizontal: 16), 
  //   child:  Column(
  //     children: [
  //        const SizedBox(
  //         height: 20,
  //        ),
  //       GestureDetector(
  //         onTap: () {
  //           print("planReqModel $planReqModel");
  //             //    var some =   globalStorage.getClientId();
  //             //  subcriptionBloc.add( CreateOrderEvent(clientId: some,
  //             //   planReqModel: planReqModel
  //             //  ));
  //           showRadioOptionDialog(context);
  //         },
  //         child: const Custombutton(text: "Pay Now", width: double.infinity)),
  //         const SizedBox(
  //         height: 20,
  //        ),
        
        

  //     ],
  //   ),
  //   )
    );

  }
   List<Result>multipleSelected = [];
  List checkListItems = [
    {
      "id": 0,
      "value": false,
      "title": "Facility 1",
    },
    {
      "id": 1,
      "value": false,
      "title": "Facility 2",
    },
    {
      "id": 2,
      "value": false,
      "title": "Facility 3",
    },
    {
      "id": 3,
      "value": false,
      "title": "Facility 4",
    },
    {
      "id": 4,
      "value": false,
      "title": "Facility 5",
    },
    {
      "id": 5,
      "value": false,
      "title": "Facility 6",
    },
    {
      "id": 6,
      "value": false,
      "title": "Facility 7",
    },
  ];


Widget totalWidget(List<Result> results){
    return Column(
      children: [
             const SizedBox(
                    height: 25,
                  ),
                  Text(
                    selectedIndex == 0 ?
                    SubcriptionConstant.addFacilityForPremium :
                    SubcriptionConstant.addFacilityForTaskMaster,
                  style: AppTextStyle.font16bold.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700
                  ),
                  ),
                const SizedBox(
                    height: 25,
                  ),
               
                  SizedBox(
                    height: 380,
                    child: ListView.builder(
                      shrinkWrap: true,
                    itemCount: results.length,
                 itemBuilder: ( context, index) => ListTile(
                  
                  //  checkboxShape:  RoundedRectangleBorder(

                  //           borderRadius: BorderRadius.circular(6),
                  //      ),
                      //  shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(6),
                      //  ),
                      // activeColor: Colors.yellow,
                      //  checkColor: Colors.black,
                      // controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      // dense: true,
                      title: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            results[index].facilityName!,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                           Text(
                            results[index].planName!,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                              Text(
                            results[index].endDate!.toIso8601String().split("T").first,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                              const SizedBox(
                            width: 40,
                          ),
                          // const Spacer(),

                          GestureDetector(
                            onTap: () {
                              selectedFacility =  index;
                                print("selectedfacility $selectedFacility");
                               if( planModel.results!.plans![selectedIndex].name == "PREMIUM" && results[index].planName! == "CLASSIC"  ){
                                   showRadioOptionDialog(context);

                      //               planReqModel.insert(0, PlanReqModel(
                      //   itemId: 7,
                      //   itemType: "plan",
                      //   qty: 1,
                      //   facilityId: inactiveFacilities[index].facilityId,
                      //   isRenewal: false,
                      //   // startAfterCurrent: false
                      // ));

                    //              planReqModel.insert(
                    //   PlanReqModel(
                    //     itemId: 7,
                    //     itemType: "plan",
                    //     qty: 1,
                    //     facilityId: inactiveFacilities[selectedIndex].facilityId,
                    //     isRenewal: false,
                    //     // startAfterCurrent: false
                    //   )
                    // );
                               }
                               else if(results[index].planName! == "PREMIUM" && results[index].subscriptionStatus! == "inactive"  ){


           subcriptionBloc.add(
                CreateOrderEvent(
                  isFromFacility: true,
                  clientId: globalStorage.getClientId(),
                planReqModel: [PlanReqModel(
                        itemId:7,
                        itemType: "plan",
                        qty: 1,
                        facilityId: inactiveFacilities[index].facilityId,
                        isRenewal: true,
                       startAfterCurrent: false
                      

                        // startAfterCurrent: false
                      )]
               ));

                               }
                               else{
              subcriptionBloc.add(
                CreateOrderEvent(
                  isFromFacility: true,
                  clientId: globalStorage.getClientId(),
                planReqModel: [PlanReqModel(
                        itemId:5,
                        itemType: "plan",
                        qty: 1,
                        facilityId: inactiveFacilities[index].facilityId,
                        isRenewal: true,
                            startAfterCurrent: false
                        // startAfterCurrent: false
                      )]
               ));

                               }
                              // ?
                      
                              //  : 
                                  //  
              
                              
                              //  
                            },
                            child:
                            CustomImageProvider(
                              width: 34,
                              height: 34,
                              image:     planModel.results!.plans![selectedIndex].name == "PREMIUM" &&  results[index].planName! == "CLASSIC"
                                  ? ClientImages.upgrade
                                  : ClientImages.renew,
                            )
                            //  Custombutton(text: 
                            
                            //  planModel.results!.plans![selectedIndex].name == "PREMIUM" &&  results[index].planName! == "CLASSIC" ?
                            //  "Upgrade" :
                            // "Renew", width: 120,)
                            
                            )
                        ],
                      ),
                  
                      
                      // value: results[index].value,
                      // onChanged: (value) {
                      //   setState(() {
                      //     results[index].value = value!;
                      //     if (multipleSelected.contains(results[index])) {
                      //       multipleSelected.remove(results[index]);
                      //          itemTotal -= results[index].price!;

                             
                      //               planReqModel.removeAt(index );
                         
                      
                      //     } else {

                      //        multipleSelected.add(results[index]);
                      //         itemTotal += results[index].price!;
                      //           planReqModel.add( PlanReqModel(
                      //             itemId: 5,
                      //             itemType: "plan",
                      //             qty: 1,
                      //             facilityId:results[index].facilityId,
                      //             isRenewal: true,
                      //             startAfterCurrent:  false
                      //           ) );
                         
                        
                      //     }
                          
                      //        print(" isSelected $value");    
                       
                      //   });
                      // },
                      //   trailing : Text(
                      //   "Rs. ${results[index].price}",
                      //   style: const TextStyle(
                      //     fontSize: 14.0,
                      //     color: Colors.black,
                      //   ),
                      // ),
                    ),
                                  ),
                  ),
              // ),
                     
                     const SizedBox(
                      height: 25,
                     ),
          //  Container(
          //           width: double.infinity,
          //                 decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(26),
          //            boxShadow: [
          //       BoxShadow(
          //         color: Colors.black.withValues( alpha: 0.2), // Shadow color
          //         spreadRadius: 1, // How wide the shadow should spread
          //         blurRadius: 10, // The blur effect of the shadow
          //         offset: const Offset(0, 5), // Shadow offset, with y-offset for bottom shadow
          //       ),
          //     ],
              
          //         ),
          //           // height: 1,
          //           child: Padding(
          //             padding: const EdgeInsets.symmetric( horizontal: 12),
          //             child: Column(
          //               children: [
          //                    const SizedBox(
          //                   height: 20,),
          //                 rowItem(title: SubcriptionConstant.itemTotal, subTitle: "Rs. $itemTotal"),
          //                 const SizedBox(
          //                   height: 6,),
          //                   // rowItem(title: SubcriptionConstant.discount, subTitle: "Rs. ${ itemTotal  }"),
          //                     const SizedBox(
          //                   height: 6,),
          //                     rowItem(title: SubcriptionConstant.finalTotal, subTitle: "Rs. ${itemTotal }"),
          //                      const SizedBox(
          //                   height: 11,),
          //                   const Divider(),
          //                       const SizedBox(
          //                   height: 14,),
          //                    Row(
    
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     children: [
          //                       Text(SubcriptionConstant.grandTotal,
          //                       style: AppTextStyle.font16bold.copyWith(
          //                         fontSize: 24,
          //                         fontWeight: FontWeight.w700
          //                       ),
          //                       ),
          //                       Text("Rs. 7,447",
          //                       style: AppTextStyle.font16bold.copyWith(
          //                         fontSize: 24,
          //                         fontWeight: FontWeight.w700,
          //                            color: const Color(0xff828282)
          //                       ),
          //                       )
          //                     ],
          //                    ),
          //               const SizedBox(
          //                   height: 20,),
                                      
          //               ], 

          //             ),
          //           ),
          //         ),


                  const SizedBox(
                    height: 20,
                  ),
      ],
    );
  }

  void insertOnlyOneAtZero(PlanReqModel newItem) {
  if (planReqModel.isEmpty) {
    planReqModel.insert(0, newItem);
  } else {
    planReqModel[0] = newItem; // Replace the existing first item
  }
}


  void showRadioOptionDialog(BuildContext context) {
  String selectedOption = ''; // default selection

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric( horizontal: 20),
            // contentPadding: EdgeInsets.symmetric( horizontal: 10),
            backgroundColor: AppColors.white,
            title:  Text('Renew Your Membership',
              style: AppTextStyle.font16bold,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title:  Text('Renew Membership after the current Membership gets over',
                   style: AppTextStyle.font14,
                  ),
                  value: 'Plan',
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value!;

                    });

                    insertOnlyOneAtZero(PlanReqModel(
                        itemId: 7,
                        itemType: "plan",
                        qty: 1,
                        facilityId: inactiveFacilities[selectedFacility].facilityId,
                        isRenewal: true,
                        startAfterCurrent: true
                      ));
              
                  },
                ),
                RadioListTile<String>(
                  title:  Text('Renew Membership immediately',
                  style: AppTextStyle.font14,
                  ),
                  value: 'Addon',
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value!;
                    });

                     insertOnlyOneAtZero(PlanReqModel(
                        itemId: 7,
                        itemType: "plan",
                        qty: 1,
                        facilityId: inactiveFacilities[selectedFacility].facilityId,
                        isRenewal: true,
                        startAfterCurrent: false
                      ));
            
                  },
                ),

                 const SizedBox(height: 20,),

                 GestureDetector(
                  onTap: () {
                    //  print("planReqModel $planReqModel");
                      var some =   globalStorage.getClientId();
                    
               subcriptionBloc.add( CreateOrderEvent(
                 isFromFacility: true,
                clientId: some,
                planReqModel: planReqModel
               ));

                  },
                   child: const Custombutton(text: 'Continue', width: double.infinity,
                                   
                    ),
                 ),
                  const SizedBox(height: 20,),
                  
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Custombutton(text: 'Cancel', width: double.infinity,

                                          ),
                      ),
                
                    //  const SizedBox(height: 20,), 
              ],
            ),
            // actionsAlignment: ,
            // actionsAlignment: ,
            // actions: [
            //   TextButton(
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //       print('Selected: $selectedOption');
            //       // Do something with selectedOption
            //     },
            //     child: const Text('OK'),
            //   ),
            //   TextButton(
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     },
            //     child: const Text('Cancel'),
            //   ),
            // ],
          );
        },
      );
    },
  );
}



 Widget planCard( Plan plans, int index) {
   return        Container(
                  height: 160,
                  margin: const EdgeInsets.only( bottom: 20),
                    width: double.infinity,
                          decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                     boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues( alpha: 0.2), // Shadow color
                  spreadRadius: 1, // How wide the shadow should spread
                  blurRadius: 10, // The blur effect of the shadow
                  offset: const Offset(0, 5), // Shadow offset, with y-offset for bottom shadow
                ),
              ],
                  border:  Border.all(
                         color: selectedIndex == index ?  AppColors.backgroundColor : AppColors.white
                     )
                  ),
                    // height: 1,
                    child: Column(
                      children: [
                         const SizedBox(
                          height: 20,),
                         CustomImageProvider( 
                          image: ClientImages.taskMasterblack,
                          width: 106,
                          height: 60,
                        ),
                            const SizedBox(
                          height: 6,),
                       
                        Text( plans.name!,
                        textAlign: TextAlign.center,
                         style: AppTextStyle.font16bold.copyWith( 
                          fontSize: 16,
                          
                        )),
                           const SizedBox(
                          height: 12,),
                      ], 
                    ),
                  );
 }


  Widget rowItem({required String title, required String subTitle}) {
    return  Row(
                      children: [
                        Text(title,
                         style: AppTextStyle.font20.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700
                         ),
                         ),
                         const Spacer(),
                          Text(subTitle,
                         style: AppTextStyle.font20.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff828282)
                         ),
                         )
                      ],
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
    //   String clintId = globalStorage.getClientId();
    //    widget.dashBoardBloc!.add( SubcriptionEvent(
    //      id: int.parse(clintId)
    //  ) );
    //             if(widget.isfromFacility!){
    //                    print("is from facility");

    //                   globalStorage.savePaymentId(accessPayemntId: response.paymentId! );

    //             }
        
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

                                             print("client ir ${widget.clientDashBoardBloc!}");



                                            //  widget.clientDashBoardBloc.add(event)
                                            
                                           widget.clientDashBoardBloc!.add(GetAllFacilityEvent(
                                            clientId: int.parse(globalStorage.getClientId())
                                          ) );




                                                  // if(widget.isfromOnboard){
                                                  //     Navigator.of(context).pop();
                                                  //     Navigator.of(context).pop();
                                                  //      Navigator.of(context).pop();
                                                  //      Navigator.of(context).pop();


                                                  // }


                                    

                                              if ( planModel.results!.plans![selectedIndex].name == "PREMIUM" &&  widget.fromTabbar == false  ) {
                                               Navigator.of(context).pop();
                                               Navigator.of(context).pop();
                                               Navigator.of(context).pop(inactiveFacilities[selectedFacility]);
                                               if(widget.isfromOnboard){
                                                  
                                                 Navigator.of(context).pop(inactiveFacilities[selectedFacility]);
                                                //  Navigator.of(context).pop();
                                                }
     
                                              } else {

                                                 Navigator.of(context).pop();
                                                 Navigator.of(context).pop(inactiveFacilities[selectedFacility]);
                                                //  Navigator.of(context).pop();
                                                  //  widget.tabController!.animateTo(widget.indexTab!);
                                                
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



}