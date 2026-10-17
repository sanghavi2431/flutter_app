import 'package:easy_localization/easy_localization.dart';
import 'package:easy_pie_chart/easy_pie_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

import '../../../utils/app_color.dart';

/// Parses dashboard strings: plain numbers, `"12%"`, list prints like `"[1, 1]"` / `"1, 1"`
/// (comma-separated parts are summed — matches [JanitorEfficiency.totaltask] list `.toString()`).
double? _parseChartDouble(String? raw) {
  if (raw == null) return null;
  var s = raw.trim().replaceAll(RegExp(r'[\[\]]'), '').replaceAll('%', '').trim();
  if (s.isEmpty) return null;
  if (!s.contains(',')) {
    return double.tryParse(s);
  }
  double sum = 0;
  for (final part in s.split(',')) {
    final t = part.trim();
    if (t.isEmpty) continue;
    final v = double.tryParse(t);
    if (v == null) return null;
    sum += v;
  }
  return sum;
}

class ChartPie extends StatefulWidget {
  final String? complatedTask;
  final String? pendingTask;
  final String? totalTask;
  final String? accetedTask;
  final String? rejectedTask;
  final String? rfcTask;
  final String? ongoingTask;
  final String? complatedPercentage;
  final String? pendingPercentage;
  final String? acceptedPercentage;
  final String? rejectedPercentage;
  final String? rfcPercentage;
  final String? ongoingPercentage;

  const ChartPie(
      {super.key,
      this.complatedTask,
      this.pendingTask,
      this.totalTask,
      this.accetedTask,
      this.ongoingTask,
      this.rejectedTask,
      this.rfcTask,
      this.complatedPercentage,
      this.pendingPercentage,
      this.acceptedPercentage,
      this.rejectedPercentage,
      this.rfcPercentage,
      this.ongoingPercentage});

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





    final double total = _parseChartDouble(widget.totalTask) ?? 0;
    final String totalTaskDisplay = total % 1 == 0
        ? total.toInt().toString()
        : total.toString();

    final bool hasData = total > 0;

     if (hasData) {
      final cp = _parseChartDouble(widget.complatedPercentage ?? "0") ?? 0;
      final pp = _parseChartDouble(widget.pendingPercentage ?? "0") ?? 0;
      final ap = _parseChartDouble(widget.acceptedPercentage ?? "0") ?? 0;
      final rp = _parseChartDouble(widget.rejectedPercentage ?? "0") ?? 0;
      final rfp = _parseChartDouble(widget.rfcPercentage ?? "0") ?? 0;
      final ogp = _parseChartDouble(widget.ongoingPercentage ?? "0") ?? 0;

      compaltedPer = cp;
      pendingPer = pp;
      acceptedPer = ap;
      rejectedPer = rp;
      rfcPer = rfp;
      onGoingPer = ogp;
     } else {
       compaltedPer = 0;
       pendingPer = 0;
       acceptedPer = 0;
       rejectedPer = 0;
       rfcPer = 0;
       onGoingPer = 0;
     }
    print("rfc ${widget.rfcPercentage}");
    //  print("rejected ${widget.rejectedPercentage}");
    //  print("rejected ${widget.acceptedPercentage}");
    //  print("rejected ${widget.complatedPercentage}");
    print("pending pie chart ${widget.pendingTask}");
    print("colure ${widget.rfcPercentage}");


    pies = [
      PieData(value: compaltedPer!, color: const Color(0xffC9F1FF),),
      PieData(value: pendingPer!, color: const Color(0xff19586C)),
      PieData(value: acceptedPer!, color: const Color(0xff8BDFFB)),
      // PieData(value:  rejectedPer  == 0 ? 0.01 :rejectedPer! , color: AppColors.rejectButtonColor ),
      // PieData(value:  rfcPer  == 0 ? 0.01 :rfcPer! , color: AppColors.rfcCardBgColor ),
      PieData(value: onGoingPer!, color: const Color(0xff33B8E4)),
      PieData(value: rfcPer!, color: const Color(0xff208AAC)),
      PieData(value: rejectedPer!, color: const Color(0xff03171E)),

      // PieData(value: 0.45, color: Colors.lightGreen),
    ];
    debugPrint("sime ${MediaQuery.of(context).size.width}");
    print("widht ${MediaQuery.of(context).size.width < 370}");
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
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
            width: MediaQuery.of(context).size.width / 1.4,
            child: EasyPieChart(
              key: const Key('pie 2'),
              children: pies,
              pieType: PieType.crust,
              showValue: showValue,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                  // color: textColor,
                  overflow: TextOverflow.visible),
              onTap: hasData ?(index) {
                showValue = !showValue;
                // tapIndex = index.toString();
                setState(() {});
              } : null,
              gap: 0,
              start: 0,
              borderEdge: StrokeCap.square,
              animateFromEnd: true,
              size: 100,
              child: Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const SizedBox(
                  //   height: 100,
                  // ),

                  Text(
                    widget.complatedPercentage ?? '0%',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width < 370
                            ? 80.sp
                            : 80.sp,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),

                  Text(
                    "Cleaning".tr(),
                    style: AppTextStyle.font20bold
                        .copyWith(color: const Color(0xff8BDFFB)),
                  ),

                  Text(
                    "efficiency".tr(),
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
            children: [
              Expanded(
                child: Indicator(
                  color: const Color(0xffC9F1FF),
                  text: 'completedTask'.tr(),
                  taskCount: widget.complatedTask,
                  isSquare: true,
                  size: 20.r,
                  textColor: Colors.black,
                  totalTask: totalTaskDisplay,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Indicator(
                  color: const Color(0xff8BDFFB),
                  text: 'acceptedTask'.tr(),
                  taskCount: widget.accetedTask,
                  isSquare: true,
                  size: 20.r,
                  totalTask: totalTaskDisplay,
                ),
              ),
            ],
          ),


          const SizedBox(
            height: 10,
          ),

          Row(
            children: [
              Expanded(
                child: Indicator(
                  color: const Color(0xff33B8E4),
                  text: 'onGoingTask'.tr(),
                  taskCount: widget.ongoingTask,
                  isSquare: true,
                  size: 20.r,
                  totalTask: totalTaskDisplay,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Indicator(
                  color: const Color(0xff208AAC),
                  text: 'requestForClosure'.tr(),
                  taskCount: widget.rfcTask,
                  isSquare: true,
                  size: 20.r,
                  totalTask: totalTaskDisplay,
                ),
              ),
            ],
          ),


          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Indicator(
                  color: const Color(0xff19586C),
                  text: 'pending'.tr(),
                  taskCount: widget.pendingTask,
                  isSquare: true,
                  size: 20.r,
                  totalTask: totalTaskDisplay,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Indicator(
                  color: const Color(0xff03171E),
                  text: 'rejected'.tr(),
                  taskCount: widget.rejectedTask,
                  isSquare: true,
                  size: 20.r,
                  totalTask: totalTaskDisplay,
                ),
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
      ),
    );
  }

  List<PieChartSectionData> showingSections(pending, complated) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff006C7B),
            value: compaltedPer,
            title: '$compaltedPer%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.containerColor,
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
    });
  }
}



class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
    required this.taskCount,
    required this.totalTask,   // ✅ add totalTask
  });

  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;
  final String? taskCount;
  final String? totalTask;    // ✅ new field

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 370;

    return Container(
      width: isSmall ? 148 : 160,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [

         Row(
              children: [

                /// colored dot (no number inside)
                Container(
                  width: isSmall ? 15 : 17,
                  height: isSmall ? 15 : 17,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),

                const SizedBox(width: 6),

                Flexible(
                  child: Text(
                    text,
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      fontSize: isSmall ? 10.sp : 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),

          /// Right → value/total
          Text(
            "${taskCount ?? "0"}/${totalTask ?? "0"}",
            style: TextStyle(
              fontSize: isSmall ? 16.sp : 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

