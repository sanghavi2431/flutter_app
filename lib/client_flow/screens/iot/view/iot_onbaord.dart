import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:woloo_smart_hygiene/client_flow/utils/client_constant.dart';
import 'package:woloo_smart_hygiene/client_flow/utils/client_images.dart';
import 'package:woloo_smart_hygiene/client_flow/widgets/CustomButton.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

import '../../../../core/local/global_storage.dart';
import '../../../../utils/app_color.dart';
import '../../dashbaord/bloc/dashboard_bloc.dart';
import '../../subcription/view/premium_screeen.dart';

// ignore_for_file: public_member_api_docs


class IotOnbaord extends StatefulWidget {
      ClientDashBoardBloc?   clientDashBoardBloc;
        
        IotOnbaord({ this.clientDashBoardBloc });

  // const IotOnbaord({Key? key}) : super(key: key );

  @override
  IotOnbaordState createState() => IotOnbaordState();
}

class IotOnbaordState extends State<IotOnbaord> {
  final controller = PageController(viewportFraction: 1, keepPage: true);
    GlobalStorage globalStorage = GetIt.instance();
    int onboardIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = List.generate(
        onBoardList.length,
        (index) => Container(
          
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                // color: Colors.grey.shade300,
              ),
              // margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  CustomImageProvider(
                    image: onBoardList[index].image,
                    width: double.infinity,
                    height: 270,
                  ),
                  const SizedBox(
                    height: 90,
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric( horizontal: 16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                         Text(onBoardList[index].title!,
                    style: AppTextStyle.font32bold,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  
                    Text(onBoardList[index].subTitle!,
                    style: AppTextStyle.font20,
                    ),
                    ],
                  ),
                )
                ],
              ),
            ));

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 600,
                child: PageView.builder(
                  controller: controller,
                  // itemCount: pages.length,
                  itemBuilder: (_, index) {
                      onboardIndex =  index;
                    return pages[index % pages.length];
                  },
                ),
              ),
         
              const SizedBox(
                height: 40,
              ),

                Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                   GestureDetector(
                    onTap: () {
                     Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  PremiumScreeen(
                    clientDashBoardBloc: widget.clientDashBoardBloc,
                    fromTabbar: false,
                    isfromOnboard: true,

                  ),
                ),
              );

                    },
                     child: const Custombutton(
                       color: AppColors.white,
                      text: "Skip", width: 170),
                   ),

                   GestureDetector(
                    onTap: () {
                      controller.nextPage(duration: Durations.medium1, curve: Curves.bounceIn );
                            
                          globalStorage.saveOnboarding(isOnboard: true);

             onboardIndex == 2 ?              
               Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  PremiumScreeen(
                    clientDashBoardBloc: widget.clientDashBoardBloc,
                    fromTabbar: false,
                     isfromOnboard: true,
                  ),
                ),
              ) : null ;                  
                    },
          child: const Custombutton(text: "Next", width: 170))

                ],
               ),

             const SizedBox(
                height: 40,
              ),

               SmoothPageIndicator(
                controller: controller,
                count: pages.length,
                effect:  const WormEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  activeDotColor: Color(0xff6D6D6D),
                  type: WormType.thinUnderground,
                ),
              ),
               const SizedBox(
                height: 40,
              ),


               
           

            ],
          ),
        ),
      ),
    );
  }
}

const colors = [
  Colors.red,
  Colors.green,
  Colors.greenAccent,
  Colors.amberAccent,
  Colors.blue,
  Colors.amber,
];


class OnboardModel{
 String? title;
 String? image;
 String? subTitle;


 OnboardModel({
  this.image,
  this.subTitle,
  this.title
 });

}


  List<OnboardModel> onBoardList = [
     OnboardModel(
      image: ClientImages.onboard,
      title: ClientConstant.monitorStinkLevelsTitle,
      subTitle: ClientConstant.monitorStinkLevelsDescription,
     ),
       OnboardModel(
      image: ClientImages.onbaord2,
      title: ClientConstant.monitorWalkInsTitle,
      subTitle: ClientConstant.monitorWalkInsDescription,
     ),
       OnboardModel(
      image: ClientImages.onboard1,
      title: ClientConstant.immerseIntoStinqGuardTitle,
      subTitle: ClientConstant.immerseIntoStinqGuardDescription,
      
     )
  ];