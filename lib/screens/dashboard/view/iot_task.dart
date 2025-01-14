import 'package:Woloo_Smart_hygiene/utils/app_textstyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
// import 'package:get/state_manager.dart';
import 'package:Woloo_Smart_hygiene/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:Woloo_Smart_hygiene/screens/dashboard/view/local_widgets/dashboard_list.dart';
import 'package:Woloo_Smart_hygiene/utils/app_color.dart';

import '../../../utils/app_constants.dart';
import '../../common_widgets/tab_widget.dart';
import '../data/model/dashboard_model_class.dart';

class IotTask extends StatefulWidget {
   final lat;
  final long;
  final List<DashboardModelClass> filter;
  final DashboardBloc dashboardBloc;
  const IotTask({
    Key? key,
  this.lat, 
  this.long,  
  required this.dashboardBloc,
  required this.filter, 
  }) : super(key: key);

  @override
  State<IotTask> createState() => _IotTaskState();
}

class _IotTaskState extends State<IotTask> with SingleTickerProviderStateMixin{
 
  TabController? tabController;
    int _selectedIndex = 0;
      void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    tabController =  TabController(length: 6, vsync: this);
   

 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      // appBar: AppBar(
      //   title: const Text('BottomNavigationBar Sample'),
      // ),
      body: 
       Column(
         // mainAxisSize: MainAxisSize.min,
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
                                  
                                     isScrollable: true,
    labelStyle:    AppTextStyle
                                       .font12bold
                                       .copyWith(
                                          color: AppColors.black,
                                   // color: AppColors.buttonBgColor,
                                   ),
    // physics: NeverScrollableScrollPhysics(),
                                     controller: tabController,
        tabs:
      [
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
            TabWidget(title: MydashboardScreenConstants.COMPLETE_TASK.tr()  )
            ),
              Tab(icon:
          TabWidget(title: MydashboardScreenConstants.REJECTED_TASk.tr()))
        ],
      ),
                                  Expanded(
                                 //   height: MediaQuery.of(context).size.height/2.1,
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,

                      children: [
                         
                                                    DashboardListWidget(
                                                       tabController: tabController,
                                                      dataforEmyptyList: EmptyWidgetConstants.PENDING_TASK_ERROR.tr(),
                                                                      current_lattitude: widget.lat,
                                                                      current_longitude: widget.long,
                                                                      filter: widget.filter.where( (e)=> e.status == "Pending" ).toList(),
                                                                      dashboardBloc:  widget.dashboardBloc,
                                                                      onTapItem: () {
                                                                 
                                                                      },
                                                                    ),
                                    

                                
                                        DashboardListWidget(
                                           tabController: tabController,
                                          dataforEmyptyList: EmptyWidgetConstants.ACCEPTED_TASK_ERROR.tr(),
                                          current_lattitude: widget.lat,
                                          current_longitude: widget.long,
                                          filter: widget.filter.where( (e)=> e.status == "Accepted" ).toList(),
                                          dashboardBloc:  widget.dashboardBloc,
                                          onTapItem: () {
                                         
                                          },
                                        ),
                                    
                                
                                        DashboardListWidget(
                                           tabController: tabController,
                                          dataforEmyptyList: EmptyWidgetConstants.ONGOING_TASK_ERROR.tr(),
                                          current_lattitude: widget.lat,
                                          current_longitude: widget.long,
                                          filter: widget.filter.where( (e)=> e.status == "Ongoing" ).toList(),
                                          dashboardBloc:  widget.dashboardBloc,
                                          onTapItem: () {
                                          
                                          },
                                        ),
                                    
                                
                                        DashboardListWidget(
                                           tabController: tabController,
                                          dataforEmyptyList: EmptyWidgetConstants.RFC_TASK_ERROR.tr(),
                                                                                   current_lattitude: widget.lat,
                                                                                  current_longitude: widget.long,
                                          filter: widget.filter.where( (e)=> e.status == "Request for closure" ).toList(),
                                          dashboardBloc:  widget.dashboardBloc,
                                          onTapItem: () {
                                         
                                          },
                                        ),
                                    
                                
                                        DashboardListWidget(
                                           tabController: tabController,
                                          current_lattitude: widget.lat,
                                          current_longitude: widget.long,
                                          filter: widget.filter.where( (e)=> e.status == "Completed" ).toList(),
                                          dashboardBloc: widget.dashboardBloc,
                                          onTapItem: () {
                                         
                                          },
                                          dataforEmyptyList: EmptyWidgetConstants.COMPELTED_TASK_ERROR.tr(),
                                       
                                    ),
                                        DashboardListWidget(
                                           tabController: tabController,
                                          current_lattitude: widget.lat,
                                          current_longitude: widget.long,
                                          filter: widget.filter.where( (e)=> e.status == "Rejected" ).toList(),
                                          dashboardBloc: widget.dashboardBloc,
                                          onTapItem: () {
                                         
                                          },
                                          dataforEmyptyList: EmptyWidgetConstants.COMPELTED_TASK_ERROR.tr(),
                                        
                                    )
                      ],
                    ),
              ),
  

                               
                          ]

                              ),
      //
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
