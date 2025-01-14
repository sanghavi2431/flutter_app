import 'package:Woloo_Smart_hygiene/core/local/global_storage.dart';
import 'package:Woloo_Smart_hygiene/screens/cluster_screen/view/cluster_screen.dart';
import 'package:Woloo_Smart_hygiene/screens/issue_list_screen/view/issue_list.dart';
import 'package:Woloo_Smart_hygiene/screens/janitor_screen/view/janitor_screen.dart';
import 'package:Woloo_Smart_hygiene/screens/my_account/view/my_account_screen.dart';
import 'package:Woloo_Smart_hygiene/screens/supervisor_dashboard/pages/templates_screen.dart';
import 'package:Woloo_Smart_hygiene/utils/app_color.dart';
import 'package:Woloo_Smart_hygiene/utils/app_constants.dart';
import 'package:Woloo_Smart_hygiene/utils/app_images.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../utils/app_textstyle.dart';
import '../../common_widgets/image_provider.dart';
import '../../report_issue_screen/view/report_issue_form.dart';

class SupervisorDashboard extends StatefulWidget {
  const SupervisorDashboard({
    Key? key,
  }) : super(key: key);

  @override
  State<SupervisorDashboard> createState() => _SupervisorDashboardState();
}

class _SupervisorDashboardState extends State<SupervisorDashboard> {
  int _currentIndex = 0;
  String? supervisorName;
  String? mobile;
  final _controller = PageController(
    initialPage: 4,
  );

  final imageList = [
    AppImages.cluster_icon,
    AppImages.janitor_icon,
    AppImages.report_issue_icon,
    AppImages.customer_request_icon,
  ];
  final labelList = <String>[
    BottomNavigatiionBarConstants.CLUSTER.tr(),
    BottomNavigatiionBarConstants.JANITORS.tr(),
    BottomNavigatiionBarConstants.REPORT_ISSUE.tr(),
    BottomNavigatiionBarConstants.ACCOUNT.tr(),
  ];
  var _bottomNavIndex = 0; // efault index of first screen
  GlobalStorage globalStorage = GetIt.instance();

  @override
  void initState() {
    supervisorName = globalStorage.getSupervisorName();
    mobile = globalStorage.getMobileNumber();
    print("mobile ----> $mobile");
    print(supervisorName);
    _bottomNavIndex = 4;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onTap: () {
          _controller.animateToPage(
            4,
            duration: const Duration(
              milliseconds: 200,
            ),
            curve: Curves.bounceOut,
          );
        },
        child: Container(
          width: 58,
          height: 58,
          decoration: const ShapeDecoration(
            color: Color(0xFF3D443D),
            shape: OvalBorder(
              side: BorderSide(
                width: 1.50,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: AppColors.bottomNavigationColor,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 10.h,
            ),
            child: CustomImageProvider(
              color: Colors.white,
              image: AppImages.fab_img,
              height: 26.h,
              width: 26.w,
            ),
          ),
        ),
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: imageList.length, height: 60.h,
        gapWidth: 40.h,
        tabBuilder: (int index, bool isActive) {
               print(" isACTIVEEE  $isActive");
          // final color = isActive
          //     ? colors.activeNavigationBarColor
          //     : colors.notActiveNavigationBarColor;

          return isActive
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomImageProvider(
                      image: imageList[index],
                      height: 20.h,
                      width: 20.w,
                      color: AppColors.white,

                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 5.h),
                      child: Text(
                          textAlign: TextAlign.center,
                           labelList[index],
                        style: 
                      AppTextStyle.font10.copyWith(
                       color: AppColors.white,
                            )
                        // TextStyle(
                        //     color: AppColors.greenText,
                        //     fontSize: 10.sp,
                        //     fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomImageProvider(
                      image: imageList[index],
                      height: 20.h,
                      width: 20.w,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 5.h),
                      child: Text(
                        textAlign: TextAlign.center,
                        labelList[index],
                        // maxLines: 1,
                        style: 
                          AppTextStyle.font10.copyWith(
                             color: AppColors.labelColor, 
                            )
                        // TextStyle(
                        //     color: AppColors.labelColor,
                        //     fontSize: 10.sp,
                        //     fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                );
        },

        backgroundColor: AppColors.bottomNavigationColor,
        activeIndex: _bottomNavIndex,

        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.softEdge,
        gapLocation: GapLocation.center,

        // leftCornerRadius: 32,
        // rightCornerRadius: 32,
        onTap: (index) {
          _controller.animateToPage(
            index,
            duration: const Duration(
              milliseconds: 200,
            ),
            curve: Curves.bounceOut,
          );
          // setState(() => _bottomNavIndex = index);
        },

      ),
      backgroundColor: AppColors.white,
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(
            () {
              _bottomNavIndex = index;
              print(" botttt $_bottomNavIndex");
            },
          );
        },
        children: [
          ClusterList(),
          JanitorList(
            rejected: false,
            isFromDashboard: true,
            isFromCluster: false,
            isFromDashboardAssignment: false,
          ),
          ReportIssueScreen(
            pageController: _controller,
          ),
          SupervisorAccountScreen(
            supervisorName: supervisorName ?? '',
            mobile_number: mobile ?? '',
          ),
          // Container(
          //   child: Center(
          //     child: Text("This screen is in progress"),
          //   ),
          // ),
          TemplateScreen(
            supervisorName: supervisorName ?? '',
          ),
        ],
      ),
    );
  }
}
