import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../../utils/app_color.dart';
import '../dashboard/bloc/dashboard_bloc.dart';
import '../dashboard/bloc/dashboard_event.dart';
import '../dashboard/data/model/dashboard_model_class.dart';

//swipe card to the right side
Widget swipeRightButton(CardSwiperController controller,
 int length
) {
  // We can listen to the controller to get updated as the card shifts position!
//  return

    // ListenableBuilder(
    // // listenable: controller,
    // builder: (context, child) {
      // final SwiperPosition? position = controller.position;
      // final SwiperActivity? activity = controller.swipeActivity;
      // // Lets measure the progress of the swipe iff it is a horizontal swipe.
      // final double progress = (activity is Swipe || activity == null) &&
      //         position != null &&
      //         position.offset.toAxisDirection().isHorizontal
      //     ? position.progressRelativeToThreshold.clamp(-1, 1)
      //     : 0;
      // Lets animate the button according to the
      // progress. Here we'll color the button more grey as we swipe away from
      // it.
      final Color color =    const Color(0xFFD9D9D9);


      return GestureDetector(

        onTap: () {

          controller.undo();


        
      //   print(" swiped ${controller.cardIndex}");

        },
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.9),
                spreadRadius: -10,
                blurRadius: 20,
                offset: const Offset(0, 20), // changes position of shadow
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.black,
            size: 30,
            // weight: IconThemeD,
            // size: 40,
          ),
        ),
      );
   // },
 // );
}

//swipe card to the left side
Widget swipeLeftButton(CardSwiperController controller, int length ) {
 // return
    // ListenableBuilder(
    // listenable: controller,
    // builder: (context, child) {
    //   final SwiperPosition? position = controller.position;
    //   final SwiperActivity? activity = controller.swipeActivity;
    //   final double horizontalProgress =
    //       (activity is Swipe || activity == null) &&
    //               position != null &&
    //               position.offset.toAxisDirection().isHorizontal
    //           ? -1 * position.progressRelativeToThreshold.clamp(-1, 1)
    //           : 0;
      final Color color =     const Color(0xFFD9D9D9);

      return GestureDetector(
        onTap:
        // controller.cardIndex != length ?
            () {

             // controller.events;


              controller.swipe(CardSwiperDirection.right);



              //  if(controller.cardIndex != length){
              //    print("indexxxxx  ${controller.cardIndex} $length ");
              //    controller.swipeLeft();
              //  }else{
              //    print("iwelse ");

              //  }

        },
        // : null,

        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.9),
                spreadRadius: -10,
                blurRadius: 20,
                offset: const Offset(0, 20), // changes position of shadow
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.arrow_forward,
            color: AppColors.black,
            size: 30,
          ),
        ),
      );
    // },
  // );
}

//unswipe card
Widget unswipeButton(CardSwiperController controller) {
  return GestureDetector(
    onTap: () {
      controller.moveTo(0);
    },
    
    //controller.unswipe(),
    child: Container(
      decoration: BoxDecoration(
        color:   const Color(0xFFD9D9D9),
        shape: BoxShape.circle,

      ),
      height: 60,
      width: 60,
      alignment: Alignment.center,
      child: const Icon(
        Icons.rotate_right,
        color: AppColors.black,
        size: 30,


      ),
    ),
  );
}

class TutorialAnimationButton extends StatelessWidget {
  const TutorialAnimationButton(this.onTap, {super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(
        Icons.question_mark,
        color: CupertinoColors.systemGrey2,
      ),
    );
  }
}