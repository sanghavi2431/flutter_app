


import 'package:easy_pie_chart/easy_pie_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

import '../../../utils/app_color.dart';

 class ChartPie extends StatefulWidget {
    final String? complatedTask;
   final String? pendingTask;
   final String? totalTask;
   final String? accetedTask;
    final String? rejectedTask;
    final String? rfcTask;
    final String? ongoingTask;
    final String? complatedPercentage;

  const ChartPie({super.key,
   this.complatedTask,
   this.pendingTask,
   this.totalTask,
   this.accetedTask,
   this.ongoingTask,
   this.rejectedTask,
   this.rfcTask,
    this.complatedPercentage
  });

  @override
  State<ChartPie> createState() => _ChartPieState();
}

class _ChartPieState extends State<ChartPie> {
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
     print("pendin ${widget.pendingTask}");



  }

  @override
  Widget build(BuildContext context) {
        
        //  print("siizeeeee ${MediaQuery.of(context).size.width }");

    // widget.complatedTask;
    var temp =    double.parse(widget.complatedTask!)/ double.parse(widget.totalTask!)*100;

    compaltedPer =  double.parse( temp.toStringAsFixed(2)) ;

    var other =
        double.parse(widget.pendingTask!)/ double.parse(widget.totalTask!)*100;

    pendingPer =   double.parse( other.toStringAsFixed(2));

    double accpet =  double.parse(widget.accetedTask!)/ double.parse(widget.totalTask!)*100;

    acceptedPer =   double.parse( accpet.toStringAsFixed(2));

    // double reject =  double.parse(widget.rejectedTask!)/ double.parse(widget.totalTask!)*100;

    // rejectedPer =   double.parse( reject.toStringAsFixed(2));

    // double rfc =  double.parse(widget.rfcTask!)/ double.parse(widget.totalTask!)*100;

    // rfcPer =   double.parse(rfc.toStringAsFixed(2));

    double ongoing =  double.parse(widget.ongoingTask!)/ double.parse(widget.totalTask!)*100;

    onGoingPer =   double.parse(ongoing.toStringAsFixed(2));





    pies =    [
      // PieData(value:  compaltedPer!, color: const Color(0xff8BDFFB), ),
      PieData(value:  pendingPer! , color: const Color(0xff231F20)),
      // PieData(value:  acceptedPer! , color: Color(0xffB8B8B8) ),
      // PieData(value:  rejectedPer  == 0 ? 0.01 :rejectedPer! , color: AppColors.rejectButtonColor ),
      // PieData(value:  rfcPer  == 0 ? 0.01 :rfcPer! , color: AppColors.rfcCardBgColor ),
      // PieData(value:   onGoingPer! , color: const Color(0xff717171) ),

      // PieData(value: 0.45, color: Colors.lightGreen),
    ];
           debugPrint( "sime ${MediaQuery.of(context).size.width}");
    return Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            height: 420,
            width: MediaQuery.of(context).size.width/1.3,
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
                      gap: 1.3,
                      start: 0,
                      animateFromEnd: true,

                      size: 100,
                      child: Center(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                             // const SizedBox(
                             //   height: 100,
                             // ),


                             Text("${widget.complatedPercentage!}",
                             style:   TextStyle(
                               fontSize:  MediaQuery.of(context).size.width < 370 ? 80.sp :80.sp,
                               fontWeight: FontWeight.bold
                             ),
                               textAlign: TextAlign.center,
                             ),
                          
                          
                           Text("Task Buddy",
                            style: AppTextStyle.font20bold.copyWith(
                              color: const Color(0xff8BDFFB)
                            ) ,
                           ),

                          Text("Efficiency",
                           style: AppTextStyle.font20bold,
                          ),



                        ],
                      )),
                    ),

     
          ),
          // const SizedBox(
          //   width: 20,
          //    ),

           const SizedBox(
             width: 10,
           ),

          //  Container(
          //   height: 300,
          //    child: GridView.builder(
          //     physics: NeverScrollableScrollPhysics(),
              
          //     gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
          //     childAspectRatio: 3,
          //     crossAxisSpacing: 10,
          //     mainAxisSpacing: 10,
                
          //       crossAxisCount: 2) ,
          //       shrinkWrap: true,
          //       itemCount: 4,
          //      itemBuilder: (context, index) {
          //        return     Indicator(
          //          color:  const Color(0xff8BDFFB),
          //          text: ' Completed Task',
          //          taskCount: widget.complatedTask,
          //          isSquare: true,
          //          size: 24,
          //        );
          //      },  ),
          //  ),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           
              // spacing: 6.w,
              // runSpacing:10,
           
             children: [
               // const SizedBox(
               //   height: 10,
               // ),
               Indicator(
                 color:  const Color(0xff8BDFFB),
                 text: ' Completed Task',
                 taskCount: widget.complatedTask,
                 isSquare: true,
                 size: 20.r,
               ),
               Indicator(
                 color: const Color(0xffB8B8B8),
                 // AppColors.acceptedBgColor,
                 text: 'Accpeted Task',
                 isSquare: true,
                 size: 20.r,
                 taskCount: widget.accetedTask,
               ),
        
           
           
           
           
             ],
           ),

           const SizedBox(
            height: 10,
           ),

           Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
             Indicator(
                 color:  const Color(0xff717171) ,
                 text: 'On Going  Task',
                 taskCount: widget.ongoingTask,
                 isSquare: true,
                 size: 20.r,
               ),
               Indicator(
                 color:  const Color(0xff231F20),
                 text: 'Pending Task',
                 isSquare: true,
                 size: 20.r,
                 taskCount:widget.pendingTask ,
               ),

            ],
           )

          //                 const SizedBox(
          //   width: 20,
          //                 ),
          //
          //
          // const SizedBox(
          //   height: 28,
          // ),
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
    return Container(
      // width: 175,
      padding: const EdgeInsets.symmetric( vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha:0.2), // Shadow color
            spreadRadius:
            1, // How wide the shadow should spread
            blurRadius:
            10, // The blur effect of the shadow
            offset: const Offset(0,
                0), // No offset for shadow on all sides
          ),
        ],
      ),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
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
           SizedBox(
            width: 4.w,
          ),
          Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$text :",
                textAlign: TextAlign.center,
                style: TextStyle(

                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    overflow: TextOverflow.visible
                ),
              ),
              SizedBox(
                width: 1.w,
              ),
              Text(
                taskCount!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    overflow: TextOverflow.visible
                ),
              ),

            ],
          )
        ],
      ),
    );
  }
}


 

