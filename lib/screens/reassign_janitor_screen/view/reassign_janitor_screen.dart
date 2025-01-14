import 'package:Woloo_Smart_hygiene/screens/common_widgets/leading_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Woloo_Smart_hygiene/screens/common_widgets/janitor_list.dart';
import 'package:Woloo_Smart_hygiene/screens/janitor_screen/data/model/Janitor_list_model.dart';
import 'package:Woloo_Smart_hygiene/utils/app_color.dart';
import 'package:Woloo_Smart_hygiene/utils/app_constants.dart';

import '../../../utils/app_textstyle.dart';

class ReassignJanitorScreen extends StatefulWidget {
  final bool isFromCluster;
  final String janitorId;
  final String? allocationId;
  List<String> selectedIds;
  final String? clusterId;

  ReassignJanitorScreen(
      {Key? key,
      required this.isFromCluster,
      required this.janitorId,
      this.allocationId,
      this.clusterId,
      required this.selectedIds})
      : super(key: key);

  @override
  State<ReassignJanitorScreen> createState() => _ReassignJanitorScreenState();
}

class _ReassignJanitorScreenState extends State<ReassignJanitorScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool cancelButtonTap = true;
  bool yesButtonTap = false;

  @override
  void initState() {
    super.initState();
    print("clusterId---->>>>${widget.clusterId}");
    print(widget.isFromCluster);
    // print(widget.isFromFacility);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leadingWidth: 100,
        elevation: 0,
        backgroundColor: AppColors.white,
      //  title:
          //  TextStyle(
          //   fontSize: 24.sp,
          //   fontWeight: FontWeight.w400,
          //   color: AppColors.yellowSplashColor,
          // ),
        // ),
        leading:
        LeadingButton()
        //  IconButton(
        //   color: AppColors.black30,
        //   icon: const Icon(
        //     Icons.arrow_back,
        //     color: Colors.white,
        //     size: 30,
        //   ),
        //   // color: AppColors.black,
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16 ),
            child: Text(
            MyJanitorsListScreenConstants.TITLE_TEXT.tr(),
            style:
            AppTextStyle.font24bold.copyWith(
              // color: AppColors.yellowSplashColor,
            ),),
          ),
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: MyFacilityListConstants.SEARCH.tr(),
                prefixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Perform the search here
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    10.r,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            child: Text(
              MyJanitorsListScreenConstants.SUB_TITLE.tr(),
              style: 
              AppTextStyle.font16.copyWith(
                 color: AppColors.titleColor,
              )
              // TextStyle(
              //   color: AppColors.titleColor,
              //   fontSize: 16.sp,
              //   fontWeight: FontWeight.w400,
              // ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 7.h,
              ),
              child: JanitorListWidget(
                isRejected: false,
                controller: _searchController,
                janitorId: widget.janitorId,
                allocationId: widget.selectedIds,
                clusterId: widget.clusterId,
                onTapItem: (JanitorListModel data) {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => TaskDetailsScreen(
                  //       isFromDashboard: false,
                  //       isFromFacility: true,
                  //       allocationId: widget.allocationId ?? '',
                  //     ),
                  //   ),
                  // );
                },
                isFromCluster: false,
                isFromDashboard: false,
                isFromFacility: true,
                isFromDashboardAssignment: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
