import 'package:Woloo_Smart_hygiene/screens/common_widgets/tab_widget.dart';
import 'package:Woloo_Smart_hygiene/screens/dashboard/view/iot_task.dart';
import 'package:Woloo_Smart_hygiene/screens/dashboard/view/regular_task.dart';
import 'package:Woloo_Smart_hygiene/utils/app_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart'hide Trans;

import '../../../utils/app_color.dart';
import '../../../utils/app_textstyle.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../data/model/dashboard_model_class.dart';
import 'local_widgets/dashboard_list.dart';

class RegularTask extends StatefulWidget {
 
  final lat;
  final long;
  final List<DashboardModelClass> filter;
  final DashboardBloc dashboardBloc;
  const RegularTask({
  super.key, 
  this.lat, 
  this.long,  
  required this.dashboardBloc,
  required this.filter, 
   });
  

  @override
  State<RegularTask> createState() => _RegularTaskState();
}

class _RegularTaskState extends State<RegularTask> with SingleTickerProviderStateMixin {
      int _selectedIndex = 0;
   static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  TabController? _tabController;
  DashboardBloc dashboardBloc = DashboardBloc();

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
      _tabController =  TabController(length: 6, vsync: this);
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
                                   labelPadding: EdgeInsets.only(right: 0, left: 8 ),

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
        
           Tab(icon: 
             TabWidget(title: MydashboardScreenConstants.ACCEPT_TASk.tr()  )
            ),
      
            Tab(icon:
              TabWidget(title: MydashboardScreenConstants.Onging_TASK.tr()  )
            ),
          Tab(icon: 
            TabWidget(title: MydashboardScreenConstants.Rquest_TASK.tr() )  
             ),
           Tab(icon:
            TabWidget(title: MydashboardScreenConstants.COMPLETE_TASK.tr() )
            ),
         Tab(icon:
           TabWidget(title: MydashboardScreenConstants.REJECTED_TASk.tr()))
        ]
      ),
              Expanded(
                // height: MediaQuery.of(context).size.height/2.1,
                child: RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(
                      Duration(seconds: 1),
                          () {
                        dashboardBloc.add(const GetTaskTamplates());
                      },
                    );
                  },
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),

                    controller: _tabController,

                        children: [

                                         DashboardListWidget(
                                          tabController: _tabController,
                                                                        current_lattitude: widget.lat,
                                                                        current_longitude: widget.long,
                                                                        filter: widget.filter.where( (e)=> e.status == "Pending" ).toList(),
                                                                        dashboardBloc:  widget.dashboardBloc,
                                                                        onTapItem: () {

                                                                        },
                                           dataforEmyptyList:  EmptyWidgetConstants.PENDING_TASK_ERROR.tr(),
                                                                      ),



                                          DashboardListWidget(
                                             tabController: _tabController,
                                            current_lattitude: widget.lat,
                                            current_longitude: widget.long,
                                            filter: widget.filter.where( (e)=> e.status == "Accepted" ).toList(),
                                            dashboardBloc:  widget.dashboardBloc,
                                            onTapItem: () {

                                            },
                                          dataforEmyptyList: EmptyWidgetConstants.ACCEPTED_TASK_ERROR.tr(),
                                          ),


                                          DashboardListWidget(
                                             tabController: _tabController,
                                            current_lattitude: widget.lat,
                                            current_longitude: widget.long,
                                            filter: widget.filter.where( (e)=> e.status == "Ongoing" ).toList(),
                                            dashboardBloc:  widget.dashboardBloc,
                                            onTapItem: () {

                                            },
                                          dataforEmyptyList: EmptyWidgetConstants.ONGOING_TASK_ERROR.tr(),
                                          ),


                                          DashboardListWidget(
                                             tabController: _tabController,
                                                                                       current_lattitude: widget.lat,
                                                                                      current_longitude: widget.long,
                                            filter: widget.filter.where( (e)=> e.status == "Request for closure" ).toList(),
                                            dashboardBloc:  widget.dashboardBloc,
                                            onTapItem: () {

                                            },
                                                                                       dataforEmyptyList: EmptyWidgetConstants.RFC_TASK_ERROR.tr(),
                                          ),


                                          DashboardListWidget(
                                             tabController: _tabController,
                                            current_lattitude: widget.lat,
                                            current_longitude: widget.long,
                                            filter: widget.filter.where( (e)=> e.status == "Completed" ).toList(),
                                            dashboardBloc: widget.dashboardBloc,
                                            onTapItem: () {

                                            },
                                           dataforEmyptyList: EmptyWidgetConstants.COMPELTED_TASK_ERROR.tr(),
                                          ),
                                                    DashboardListWidget(
                                             tabController: _tabController,
                                            current_lattitude: widget.lat,
                                            current_longitude: widget.long,
                                            filter: widget.filter.where( (e)=> e.status == "Rejected" ).toList(),
                                            dashboardBloc: widget.dashboardBloc,
                                            onTapItem: () {

                                            },
                                           dataforEmyptyList: EmptyWidgetConstants.COMPELTED_TASK_ERROR.tr(),
                                          ),

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