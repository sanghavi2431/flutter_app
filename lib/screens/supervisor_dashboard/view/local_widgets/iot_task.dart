import 'package:woloo_smart_hygiene/screens/common_widgets/tab_widget.dart';
import 'package:woloo_smart_hygiene/screens/supervisor_dashboard/view/local_widgets/supervisor_dashboard_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/app_color.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_textstyle.dart';
import '../../../task_details_screen/view/task_details.dart';
// import '../../../utils/app_color.dart';
// import '../../../utils/app_textstyle.dart';
import '../../model/supervisor_model_dashboard.dart';
// import '../bloc/dashboard_bloc.dart';
// import '../bloc/dashboard_event.dart';
// import '../data/model/dashboard_model_class.dart';
// import 'local_widgets/dashboard_list.dart';

class IotTask extends StatefulWidget {
 
  final String? lat;
  final String? long;
  // final List<DashboardModelClass> filter;
  // final DashboardBloc dashboardBloc;
  const IotTask({
  super.key, 
  this.lat, 
  this.long,  
  // required this.dashboardBloc,
  // required this.filter, 
   });
  

  @override
  State<IotTask> createState() => _IotTaskState();
}

class _IotTaskState extends State<IotTask> with SingleTickerProviderStateMixin {
      // int _selectedIndex = 0;
        // GlobalKey key = GlobalKey();
  //  static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // static const List<Widget> _widgetOptions = <Widget>[
  //   RegularTask(),
  //   IotTask()
  //   // Text(
  //   //   'Index 1: Business',
  //   //   style: optionStyle,
  //   // ),
  //   // Text(
  //   //   'Index 2: School',
  //   //   style: optionStyle,
  //   // ),
  // ];

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }
  TabController? _tabController;
  // DashboardBloc dashboardBloc = DashboardBloc();

   @override
  void initState() {
    
    super.initState();
      _tabController =  TabController(length: 4, vsync: this);
  }


  

  @override
  Widget build(BuildContext context) {
    return 
     Scaffold(
       backgroundColor: AppColors.white,
      // appBar: AppBar(
      //   title: const Text('BottomNavigationBar Sample'),
      // ),
      body:
       Column(
                                children: [

                                  SizedBox(
                                    height: 10.h,
                                  ),
                                   TabBar(
                                     padding: EdgeInsets.zero,
                                   indicatorPadding: EdgeInsets.zero,
                                   indicatorSize: TabBarIndicatorSize.label,
                                   labelPadding: const EdgeInsets.only(right: 0, left: 8 ),

                                   //  labelColor:AppColors.buttonBgColor ,
                                     tabAlignment: TabAlignment.start,
                                     isScrollable: true, labelStyle: AppTextStyle
                                       .font12bold
                                       .copyWith(
                                   color: AppColors.black,
                                   ),
                                       // physics: NeverScrollableScrollPhysics(),
                                     controller: _tabController,
                                           tabs: [
                                                 Tab(icon:
                                                 TabWidget(title: MydashboardScreenConstants.PENDING_TASK.tr() )
                                              ),


                                             //  Tab(icon:
                                             //    TabWidget(title:"Accepted")
                                             //   ),
                                             //  Tab(icon:
                                             //   TabWidget(title:"Ongoing")
                                             //    ),
                                             Tab(icon:
                                               TabWidget(title: MydashboardScreenConstants.Rquest_TASK.tr() )
                                                ),
                                              Tab(icon:
                                               TabWidget(title: MydashboardScreenConstants.COMPLETE_TASK.tr())

                                               
                                               ),
         Tab(icon:
          TabWidget(title: MydashboardScreenConstants.REJECTED_TASk.tr()))
                                           ],
                                         ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(
                      const Duration(seconds: 1),
                          () {
                     //   dashboardBloc.add(const GetTaskTamplates());
                      },
                    );
                  },
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                
                        children: [
                
                               SupervisorDashboardListWidget(
                                errorData:EmptyWidgetConstants.PENDING_TASK_ERROR.tr(),
                                status: "Pending",
                                reqType: "IOT",
                            // key: key,
                            onTapItem: (SupervisorModelDashboard data, bool isApproved) async {
                              debugPrint("templates ${data.status!}");
                               if( data.status == "Request for closure" ){
                    await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TaskDetailsScreen(
                          isFromDashboard: true,
                          isFromFacility: false,
                          allocationId: "${data.taskAllocationId ?? ''}",
                          isApproved: isApproved,
                        )),
                              );
                              //  key = GlobalKey();
                               }    
                            },
                          ),
                
                
                                           SupervisorDashboardListWidget(
                                            errorData: EmptyWidgetConstants.RFC_TASK_ERROR.tr(),
                                            status: "Request for closure",
                                             reqType: "IOT",
                            // key: key,
                            onTapItem: (SupervisorModelDashboard data, bool isApproved) async {
                              debugPrint("templates ${data.status!}");
                               if( data.status == "Request for closure" ){
                    await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TaskDetailsScreen(
                          isFromDashboard: true,
                          isFromFacility: false,
                          allocationId: "${data.taskAllocationId ?? ''}",
                          isApproved: isApproved,
                        )),
                              );
                              //  key = GlobalKey();
                               }    
                            },
                          ),
                
                
                             
                
                                  SupervisorDashboardListWidget(
                                    errorData:  EmptyWidgetConstants.ACCEPTED_TASK_ERROR.tr(),
                                            status: "Completed",
                                            reqType: "IOT",
                            // key: key,
                            onTapItem: (SupervisorModelDashboard data, bool isApproved) async {
                              debugPrint("templates ${data.status!}");
                               if( data.status == "Request for closure" ){
                    await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TaskDetailsScreen(
                          isFromDashboard: true,
                          isFromFacility: false,
                          allocationId: "${data.taskAllocationId ?? ''}",
                          isApproved: isApproved,
                        )),
                              );
                              //  key = GlobalKey();
                               }    
                            },
                          ),

                          SupervisorDashboardListWidget(
                            errorData:  EmptyWidgetConstants.ACCEPTED_TASK_ERROR.tr(),
                            status: "Rejected",
                            reqType: "IOT",
                            // key: key,
                            onTapItem: (SupervisorModelDashboard data, bool isApproved) async {
                              debugPrint("templates ${data.status!}");
                              if( data.status == "Request for closure" ){
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TaskDetailsScreen(
                                        isFromDashboard: true,
                                        isFromFacility: false,
                                        allocationId: "${data.taskAllocationId ?? ''}",
                                        isApproved: isApproved,
                                      )),
                                );
                                //  key = GlobalKey();
                              }
                            },
                          ),



                          // DashboardListWidget(
                                          //   current_lattitude: widget.lat,
                                          //   current_longitude: widget.long,
                                          //   filter: widget.filter.where( (e)=> e.status == "Completed" ).toList(),
                                          //   dashboardBloc: widget.dashboardBloc,
                                          //   onTapItem: () {
                
                                          //   },
                                          // ),
                
                        ],
                      ),
                ),
              ),



                          ]

                              ),

      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.business),
      //       label: 'Business',
      //     ),
      //
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.amber[800],
      //   onTap: _onItemTapped,
      // ),
    );

  }
}