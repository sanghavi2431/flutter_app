


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/subcription/bloc/subscription_state.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/subcription/data/model/coins_model.dart';
import 'package:woloo_smart_hygiene/client_flow/widgets/CustomButton.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import '../../../../core/local/global_storage.dart';
import '../../../../utils/app_constants.dart';
import '../../dashbaord/model/facility_model.dart';
import '../../login/view/login_as.dart';
import '../bloc/subscription_bloc.dart';
import '../bloc/subscription_event.dart';



class Clientprofile extends StatefulWidget {
  const Clientprofile({super.key});

  @override
  State<Clientprofile> createState() => _ClientprofileState();
}

class _ClientprofileState extends State<Clientprofile> {

     
       GlobalStorage globalStorage = GetIt.instance();
        
         String clientName = "";
          SubcriptionBloc subcriptionBloc = SubcriptionBloc();


           CoinsModel? coinsModel;



      
       @override
  void initState() {
    // TODO: implement initState
    super.initState();
   clientName = "";
   
  //  globalStorage.getSupervisorName();

   subcriptionBloc.add( const UserCoinsEvent());

  }
    

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric( horizontal: 16),
         
        child:
        Column(
          children: [

             BlocConsumer(
              bloc: subcriptionBloc,
              listener: (context, state) {
                 print("dssa $state");
              if ( state is SubscriptionLoading  ){

                 EasyLoading.show(status: state.message);
               }

               if( state is GetUserCoins ){

                  EasyLoading.dismiss();


                   coinsModel =  state.coinsModel; 

                      
                             // YYYY-MM-DD format
         
                  
                 // gender = state.tasklist;

               }
               
               if(state is SubscriptionError  ){

                 EasyLoading.dismiss();
                 EasyLoading.showError( state.error);

               }
              },
              builder: 
               (context, state) => 

            Container(
               padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.greyIcon,
                borderRadius: BorderRadius.circular(30)
              ),

              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 45,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         Text(clientName,
                         style: AppTextStyle.font16bold,
                         ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width/1.7,
                              child: const Divider()),
                           Text("${coinsModel == null ? "00" : coinsModel!.results!.totalCoins} woloo points",
                            style: AppTextStyle.font16bold,
                          )
                        ],
                      ),
                    ],
                  ),
                   const SizedBox(
                      height: 20,
                   ),       
                  const Custombutton(text: "Active Membership", width: 350),
                  const SizedBox(
                    height: 20,
                  ),
                  
                ],
              )
              ,
            ),
                ),


            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: AppColors.backgroundColor,
            ),
            const SizedBox(
              height: 20,
            ),


            GridView.builder(
              shrinkWrap: true,
             itemCount: cardList.length,  
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(   
               crossAxisSpacing: 10,
              crossAxisCount: 3), 
            itemBuilder: (context, index) {
              return  card(cardList[index].image!, cardList[index].title! );
              
            }, ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
               
                // card(ClientImages.about, "About"),
                // card(ClientImages.term, "Terms of Use"),
              
            //   ],
            // ),
             const SizedBox(
               height: 40,
             ),

            GestureDetector(
                onTap: ()async {
                  // status: MyJanitorProfileScreenConstants.LOGGING_OUT_TOAST
                  //     .tr());
                  showLogoutDialog(context);
                
                },
                child: const Custombutton(text: "Log out", width: 360)),
                  const SizedBox(
               height: 40,
             ),

                 GestureDetector(
                onTap: ()async {
                  // status: MyJanitorProfileScreenConstants.LOGGING_OUT_TOAST
                  //     .tr());
                  showDeleteUserDialog(context);
                
                },
                child: const Custombutton(
                   
                  text: "Delete User", width: 360)),
          ],
        ),
      ),
    );
  }

   card( String image, String title ){
      return Container(
        width: 100.h,
        height: 100.w,

        decoration: BoxDecoration(
          color: AppColors.white,

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues( alpha: 0.2), // Shadow color
              spreadRadius: 1, // How wide the shadow should spread
              blurRadius: 10, // The blur effect of the shadow
              offset: const Offset(0, 5), // Shadow offset, with y-offset for bottom shadow
            ),
          ],
          // color: enabled ? color ??  AppColors.backgroundColor : AppColors.disabledButtonColor,
          borderRadius: BorderRadius.circular(19),
        ),
        child: Padding(
          padding:  REdgeInsets.all(8),
        child: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageProvider(
                image: image,
                width: 46,
                height: 46,
              ),
              const SizedBox(
                height: 5,
              ),
        
               Text(
                textAlign: TextAlign.center,
                title,
               style: AppTextStyle.font13w7,
               )
        
            ],
          ),
        ),
      ));




   }


   void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      
      // contentPadding: EdgeInsets.all(30),
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(60),
       ),
      backgroundColor: AppColors.white,
      // title: const Text("Logout"),
      content:  SizedBox(
        height: 80,
        child: Center(
          
          child: Text("Are you sure you want to logout?",
          textAlign: TextAlign.center,
          style: AppTextStyle.font15.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.bold
          ),
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
         GestureDetector(
           onTap: ()async {
                 
                 Navigator.of(context).pop();
           
             
           },
          child: Custombutton(
            color: AppColors.white,
            text: "No", width: 100.w)),
    
    
        GestureDetector(
           onTap: ()async {
                    var storage = GetIt.instance<GlobalStorage>();
                  storage.removeToken();
                  storage.removeLocation();
                  storage.removeTime();
                  storage.removeClientId();
                  storage.removeClientToken();
                  await Future.delayed(const Duration(seconds: 3));
                  EasyLoading.dismiss();
                  EasyLoading.showToast(MyJanitorProfileScreenConstants
                      .LOG_OUT_SUCCESS_TOAST
                      .tr());
                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                  builder: (context) => const LoginAs()),
                  (route) => false,
                  );
             
           },
          child: Custombutton(text: "Yes", width: 100.w))
       
      ],
    ),
  );
}


   void showDeleteUserDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      
      // contentPadding: EdgeInsets.all(30),
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(60),
       ),
      backgroundColor: AppColors.white,
      // title: const Text("Logout"),
      content:  SizedBox(
        height: 80,
        child: Center(
          child: Text("Are you sure you want to delete this user?",
           textAlign: TextAlign.center,
          style: AppTextStyle.font15.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.bold
          ),
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
         GestureDetector(
           onTap: ()async {
                 
                 Navigator.of(context).pop();
           
             
           },
          child: Custombutton(
            color: AppColors.white,
            text: "No", width: 100.w)),
    
    
        GestureDetector(
           onTap: ()async {
                    var storage = GetIt.instance<GlobalStorage>();
                  storage.removeToken();
                  storage.removeLocation();
                  storage.removeTime();
                  storage.removeClientId();
                  storage.removeClientToken();
                  await Future.delayed(const Duration(seconds: 3));
                  EasyLoading.dismiss();
                  EasyLoading.showToast(MyJanitorProfileScreenConstants
                      .LOG_OUT_SUCCESS_TOAST
                      .tr());
                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                  builder: (context) => const LoginAs()),
                  (route) => false,
                  );
             
           },
          child: Custombutton(text: "Yes", width: 100.w))
       
      ],
    ),
  );
}



}


