import 'dart:async';
import 'package:Woloo_Smart_hygiene/core/local/global_storage.dart';
import 'package:Woloo_Smart_hygiene/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:Woloo_Smart_hygiene/screens/dashboard/bloc/dashboard_state.dart';
import 'package:Woloo_Smart_hygiene/screens/supervisor_dashboard/model/Supervisor_model_dashboard.dart';
import 'package:Woloo_Smart_hygiene/screens/supervisor_dashboard/view/local_widgets/supervisor_dashboard_list.dart';
import 'package:Woloo_Smart_hygiene/screens/task_details_screen/view/task_details.dart';
import 'package:Woloo_Smart_hygiene/utils/app_color.dart';
import 'package:Woloo_Smart_hygiene/utils/app_constants.dart';
import 'package:Woloo_Smart_hygiene/utils/app_textstyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';

import '../../../utils/app_images.dart';
import '../../common_widgets/image_provider.dart';
import '../view/local_widgets/iot_task.dart';
import '../view/local_widgets/regular_task.dart';

class TemplateScreen extends StatefulWidget {
  final String supervisorName;

  const TemplateScreen({
    Key? key,
    required this.supervisorName,
  }) : super(key: key);

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  int selectedCard = -1;
  GlobalStorage globalStorage = GetIt.instance();

  bool servicestatus = false;
  bool haspermission = false;
       int _selectedIndex = 0;
       void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  // bool showList = false;
  // bool onTapCheckIn = false;

  // String check_in_time = "";
  // String check_out_time = "";

  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
   List<Widget> _widgetOptions = <Widget>[];

  DateTime currentTime = DateTime.now();

  late StreamSubscription<Position> positionStream;

  var _bottomNavIndex = 0; // efault index of first screen
  DashboardBloc dashboardBloc = DashboardBloc();
  GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(" template screeen");
    return BlocConsumer(
      bloc: dashboardBloc,
      listener: (context, state) {
        
      },
      builder: (context, state) {
        print(" template screeen   $state");
        if (state is ClockInLoading) {
          EasyLoading.show(status: state.message);
        }

        if (state is ClockInError) {
          EasyLoading.dismiss();
          EasyLoading.showError(state.error.message);
        }
        if (state is ClockInSuccessful) {
          EasyLoading.dismiss();
          

          // setState(() {
          //   showList = true;
          //   onTapCheckIn = true;
          // });
          // String formattedDate = DateFormat('hh:mm:ss  a').format(currentTime);
          // check_in_time = formattedDate;
        }

        if (state is ClockOutSuccessful) {
          EasyLoading.dismiss();
          print(state);
      
          // setState(() {
          //   showList = false;
          //   onTapCheckIn = false;
          // });
          // String formattedDate = DateFormat('hh:mm:ss  a').format(currentTime);
          // check_out_time = formattedDate;
        }
        if (state is ClockOutLoading) {
          EasyLoading.show(status: state.message);
        }

        if (state is ClockOutError) {
          EasyLoading.dismiss();
          EasyLoading.showError(state.error.message);
        }
                    _widgetOptions = [
           const RegularTask(),
           const IotTask()
          
        ];
      // },

      // child: 
   return   Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.white,
            title: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.w),
                    child: Text(
                      "${MyTemplateScreenConstants.HELLO.tr()}, ${widget.supervisorName.toTitleCase()}"
                          ?? '',
                      maxLines: 1,
                      softWrap: false,
                      style:
                      AppTextStyle.font24bold.copyWith(
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.black,
                      )
                      //  TextStyle(
                      //   fontSize: 24.sp,
                      //   overflow: TextOverflow.ellipsis,
                      //   fontWeight: FontWeight.w400,
                      //   color: AppColors.yellowSplashColor,
                      // ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body:
         _widgetOptions.elementAt(_selectedIndex),
          // SupervisorDashboardListWidget(
          //   key: key,
          //   onTapItem: (SupervisorModelDashboard data, bool isApproved) async {
          //     print("templates " + data.status!);
          //      if( data.status == "Request for closure" ){
          //           await Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => TaskDetailsScreen(
          //                 isFromDashboard: true,
          //                 isFromFacility: false,
          //                 allocationId: "${data.taskAllocationId ?? ''}",
          //                 isApproved: isApproved,
          //               )),
          //     );
          //      key = GlobalKey();
          //      }
           
                  
          //   },
          
          


          // ),

            bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.white,
        elevation: 15,
        unselectedItemColor:  AppColors.black,
        unselectedLabelStyle:  AppTextStyle.font12bold,
        items:  <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.task_outlined,
             size: 30,
            ),
            label: 'Regular Task',

          ),
          BottomNavigationBarItem(
            icon:  CustomImageProvider(
              image: AppImages.iotIcons,
              width: 30,
              height: 30,
              color:
              _selectedIndex == 1 ?
              AppColors.buttonBgColor
                  : null
              ,
            ),
            label: 'IOT Task',

          ),
        
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.buttonBgColor,
        onTap: _onItemTapped,
      ),
      
          );
      }
    );
  }
}
extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}