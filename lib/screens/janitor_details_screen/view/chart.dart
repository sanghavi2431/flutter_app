import 'package:easy_pie_chart/easy_pie_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_color.dart';

 class Chart extends StatefulWidget {
    final String? complatedTask;
   final String? pendingTask;
   final String? totalTask;
   final String? accetedTask;
    final String? rejectedTask;
    final String? rfcTask;
    final String? ongoingTask;

  const Chart({super.key,
   this.complatedTask,
   this.pendingTask,
   this.totalTask,
   this.accetedTask,
   this.ongoingTask,
   this.rejectedTask,
   this.rfcTask
  });

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  int touchedIndex = -1;
    double? compaltedPer;
    double? pendingPer;
    double? acceptedPer;
    double? rfcPer;
    double? rejectedPer;
    double? onGoingPer;

      List<PieData> pies = [];

     

  String tapIndex = "";
  bool showValue = false;
  


  @override
  void initState() {
  
    super.initState();

    // widget.complatedTask;
     var temp =    double.parse(widget.complatedTask!)/ double.parse(widget.totalTask!)*100;
     
         compaltedPer =  double.parse( temp.toStringAsFixed(2)) ;

    var other =
        double.parse(widget.pendingTask!)/ double.parse(widget.totalTask!)*100;

        pendingPer =   double.parse( other.toStringAsFixed(2));

    double accpet =  double.parse(widget.accetedTask!)/ double.parse(widget.totalTask!)*100;

         acceptedPer =   double.parse( accpet.toStringAsFixed(2));

    double reject =  double.parse(widget.rejectedTask!)/ double.parse(widget.totalTask!)*100;

    rejectedPer =   double.parse( reject.toStringAsFixed(2));

    double rfc =  double.parse(widget.rfcTask!)/ double.parse(widget.totalTask!)*100;

    rfcPer =   double.parse(rfc.toStringAsFixed(2));

    double ongoing =  double.parse(widget.ongoingTask!)/ double.parse(widget.totalTask!)*100;

    onGoingPer =   double.parse(ongoing.toStringAsFixed(2));





    pies =    [
      PieData(value: compaltedPer == 0 ? 0.01 :compaltedPer!, color: const Color(0xff006C7B), ),
      PieData(value:  pendingPer == 0 ? 0.01 :pendingPer! , color: Colors.cyan),
      PieData(value:  acceptedPer  == 0 ? 0.01 :acceptedPer! , color: AppColors.acceptedBgColor),
      PieData(value:  rejectedPer  == 0 ? 0.01 :rejectedPer! , color: AppColors.rejectButtonColor ),
      PieData(value:  rfcPer  == 0 ? 0.01 :rfcPer! , color: AppColors.rfcCardBgColor ),
      PieData(value:  onGoingPer  == 0 ? 0.01 :onGoingPer! , color: const Color.fromARGB(255, 232, 239, 132) ),

      // PieData(value: 0.45, color: Colors.lightGreen),
    ];

  }

  @override
  Widget build(BuildContext context) {
           debugPrint( " sime ${MediaQuery.of(context).size.height}");
    return  
      Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            width: 10,
          ),

      //       AspectRatio(
      // aspectRatio: 1.3,
      // child: Row(
      //   children: <Widget>[
      //     const SizedBox(
      //       height: 18,
      //     ),

          SizedBox(
            height: 200,
            width: 160,
            child:
               EasyPieChart(
                      key: const Key('pie 2'),
                      children: pies,
                      pieType: PieType.crust,
                      showValue: showValue,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                          // color: textColor,
                          overflow: TextOverflow.visible
                      ),
                      onTap: (index) {
                         showValue  = !showValue;
                        // tapIndex = index.toString();
                        setState(() {});
                      },
                      gap: 4,
                      start: 0,
                      animateFromEnd: true,

                      size: 130,
                      child: Center(child: Text(
                        textAlign: TextAlign.center,
                        " Total Task \n ${widget.totalTask} ",
                        style:  const TextStyle(

                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            // color: textColor,
                            overflow: TextOverflow.visible
                        ),
                      )),
                    ),

            //  Stack(
            //    children: [
            //      PieChart(


            //        PieChartData(


            //          pieTouchData: PieTouchData(




            //            touchCallback: (FlTouchEvent event, pieTouchResponse) {
            //              setState(() {
            //                if (!event.isInterestedForInteractions ||
            //                    pieTouchResponse == null ||
            //                    pieTouchResponse.touchedSection == null) {
            //                  touchedIndex = -1;
            //                  return;
            //                }
            //              //  touchedIndex = pieTouchResponse
            //                    .touchedSection!.touchedSectionIndex;
            //              });
            //            },
            //          ),
            //          borderData: FlBorderData(
            //            show: false,

            //          ),

            //          sectionsSpace: 0,
            //          // centerSpaceColor: Colors.red,

            //          centerSpaceRadius: 40,

            //          sections:

            //          showingSections(widget.pendingTask,widget.complatedTask ),
            //        ),

            //      ),

            //                  // Positioned(
            //                  //  top:
            //                  //  MediaQuery.of(context).size.height < 750 ?
            //                  //      110.h :
            //                  //
            //                  //  85.h,
            //                  //  left: 40,
            //                  //  child:Align(
            //                  //       alignment: Alignment.bottomLeft,
            //                  //      child:
            //                  //
            //                  //  )
            //                  // )
            //    ],
            //  ),
          ),
          // const SizedBox(
          //   width: 20,
          //    ),

           SingleChildScrollView(
             scrollDirection: Axis.horizontal,
             child: Row(
               mainAxisAlignment: MainAxisAlignment.start,
               // crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Indicator(
                          color:  const Color(0xff00C3DE),
                          text: 'Pending Task',
                          isSquare: true,
                          size: 35,
                          taskCount:widget.pendingTask ,
                        ),
                      ),


                      const SizedBox(
                        height: 20,
                      ),
                      Indicator(
                        color:   AppColors.acceptedBgColor,
                        text: 'Accpeted Task',
                        isSquare: true,
                        size: 35,
                        taskCount: widget.accetedTask,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Indicator(
                        color:  const Color.fromARGB(255, 232, 239, 132) ,
                        text: 'Ongoing Task',
                        taskCount: widget.ongoingTask,

                        isSquare: true,
                        size: 35,
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                    ],
                  ),
                 const SizedBox(
                   width: 20,
                 ),
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   // mainAxisAlignment: MainAxisAlignment.start,
                   children: [



                     Indicator(
                       color:   AppColors.rejectButtonColor,
                       text: 'Rejected Task',
                       taskCount: widget.rejectedTask,
                       isSquare: true,
                       size: 35,
                     ),
                     const SizedBox(
                       height: 20,
                     ),
                     Indicator(
                       color:  const Color(0xff006C7B),
                       text: ' Completed Task',
                       taskCount: widget.complatedTask,
                       isSquare: true,
                       size: 35,
                     ),
                     const SizedBox(
                       height: 20,
                     ),
                     Indicator(
                       color:   AppColors.rfcCardBgColor,
                       text: 'Request for Closure Task',
                       taskCount: widget.rfcTask,
                       isSquare: true,
                       size: 35,
                     ),
                   ],
                 )


               ],
             ),
           ),


          const SizedBox(
            height: 28,
          ),
        ],
      );

  }

   List<PieChartSectionData> showingSections(  pending , complated ) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color:  const Color(0xff006C7B),
            value: compaltedPer,
            title: '$compaltedPer%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color:

              AppColors.containerColor,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xff00C3DE),
            value: pendingPer,
            title: '$pendingPer%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.containerColor,
              shadows: shadows,
            ),
          );
        // case 2:
        //   return PieChartSectionData(
        //     color: AppColors.red,
        //     value: 15,
        //     title: '15%',
        //     radius: radius,
        //     titleStyle: TextStyle(
        //       fontSize: fontSize,
        //       fontWeight: FontWeight.bold,
        //       color: AppColors.containerColor,
        //       shadows: shadows,
        //     ),
        //   );
        // case 3:
        //   return PieChartSectionData(
        //     color:  AppColors.greenText,
        //     value: 15,
        //     title: '15%',
        //     radius: radius,
        //     titleStyle: TextStyle(
        //       fontSize: fontSize,
        //       fontWeight: FontWeight.bold,
        //       color: AppColors.containerColor,
        //       shadows: shadows,
        //     ),
        //   );
        default:
          throw Error();
      }
    });}
}

// class PieChartSample2 extends StatefulWidget {
//    final String complatedTask;
//    final String pendingTask;
//    final String totalTask;
//   const PieChartSample2({
//     super.key, 
//    required this.complatedTask, 
//    required this.pendingTask, 
//    required this.totalTask});

//   @override
//   State<StatefulWidget> createState() => _PieChart2State();
// }

// class _PieChart2State extends State {
//   int touchedIndex = -1;

//   double? compaltedPer;
//   double? pendingPer;

//   @override
//   void initState() {
//     
//     super.initState();
//   widget.;
    
//     // compaltedPer =  widget.complatedTask;
//          //double.parse(widget.complatedTask);
    
//   }



//   @override
//   Widget build(BuildContext context) {
//  //  widget.

//     return
//      AspectRatio(
//       aspectRatio: 1.3,
//       child: Row(
//         children: <Widget>[
//           const SizedBox(
//             height: 18,
//           ),

//           // Expanded(
//           //   child: AspectRatio(
//           //     aspectRatio: 1,
//           //     child: PieChart(
//           //       PieChartData(
//           //         pieTouchData: PieTouchData(
//           //           touchCallback: (FlTouchEvent event, pieTouchResponse) {
//           //             setState(() {
//           //               if (!event.isInterestedForInteractions ||
//           //                   pieTouchResponse == null ||
//           //                   pieTouchResponse.touchedSection == null) {
//           //                 touchedIndex = -1;
//           //                 return;
//           //               }
//           //               touchedIndex = pieTouchResponse
//           //                   .touchedSection!.touchedSectionIndex;
//           //             });
//           //           },
//           //         ),
//           //         borderData: FlBorderData(
//           //           show: false,
//           //         ),
//           //         sectionsSpace: 0,
//           //         centerSpaceRadius: 40,
//           //         sections:
//           //
//           //         showingSections(),
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           const Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Indicator(
//                 color:  Color(0xff00C3DE),
//                 text: '4 Tasks Done',
//                 isSquare: true,
//                 size: 40,
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Indicator(
//                 color:  Color(0xff006C7B),
//                 text: '2 Tasks Done',
//                 isSquare: true,
//                 size: 40,
//               ),
//               SizedBox(
//                 height: 4,
//               )
//             ],
//           ),
//           const SizedBox(
//             width: 28,
//           ),
//         ],
//       ),
//     );
//   }

//   List<PieChartSectionData> showingSections(  pending , complated ) {
//     return List.generate(2, (i) {
//       final isTouched = i == touchedIndex;
//       final fontSize = isTouched ? 25.0 : 16.0;
//       final radius = isTouched ? 60.0 : 50.0;
//       const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
//       switch (i) {
//         case 0:
//           return PieChartSectionData(
//             color:  AppColors.containerColor,
//             value: 40,
//             title: '40%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color:

//               AppColors.containerColor,
//               shadows: shadows,
//             ),
//           );
//         case 1:
//           return PieChartSectionData(
//             color: AppColors.blue,
//             value: 30,
//             title: '30%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: AppColors.containerColor,
//               shadows: shadows,
//             ),
//           );
//         // case 2:
//         //   return PieChartSectionData(
//         //     color: AppColors.red,
//         //     value: 15,
//         //     title: '15%',
//         //     radius: radius,
//         //     titleStyle: TextStyle(
//         //       fontSize: fontSize,
//         //       fontWeight: FontWeight.bold,
//         //       color: AppColors.containerColor,
//         //       shadows: shadows,
//         //     ),
//         //   );
//         // case 3:
//         //   return PieChartSectionData(
//         //     color:  AppColors.greenText,
//         //     value: 15,
//         //     title: '15%',
//         //     radius: radius,
//         //     titleStyle: TextStyle(
//         //       fontSize: fontSize,
//         //       fontWeight: FontWeight.bold,
//         //       color: AppColors.containerColor,
//         //       shadows: shadows,
//         //     ),
//         //   );
//         default:
//           throw Error();
//       }
//     });
//   }
// }


// import 'package:flutter/material.dart'; 

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
    required this.taskCount
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;
  final String? taskCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // SizedBox(
        //   width: 100.w,
        // ),
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
            borderRadius: BorderRadius.circular(11.r)
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(

                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  overflow: TextOverflow.visible
              ),
            ),
            Text(
              taskCount!,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  overflow: TextOverflow.visible
              ),
            ),

          ],
        )
      ],
    );
  }
}


 

