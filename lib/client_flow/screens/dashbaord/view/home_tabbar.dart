import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/facility_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/home.dart';
import 'package:woloo_smart_hygiene/client_flow/widgets/CustomButton.dart';
import '../../../../core/local/global_storage.dart';
import '../../../../janitorial_services/screens/monitor-iot.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_textstyle.dart';
import '../../../widgets/chart.dart';
import '../../../widgets/tabbar_widget.dart';
import '../../iot/amonia_usage/classing_dashboard_widget.dart';
import '../../subcription/view/premium_screeen.dart';
import '../../subcription/view/subcription.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/facility_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/home.dart';
import 'package:woloo_smart_hygiene/client_flow/widgets/CustomButton.dart';

import '../../../../core/local/global_storage.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_textstyle.dart';

import '../../../widgets/tabbar_widget.dart';

import '../../subcription/view/premium_screeen.dart';

import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

import '../../../../janitorial_services/screens/monitor-iot.dart';
import '../../iot/amonia_usage/classing_dashboard_widget.dart';

/// CONSTANTS
class DashboardConstants {
  static const double tabTopSpace = 10;
  static const double expiredMessageTopSpace = 200;
  static const double expiredMessageBottomSpace = 20;

  static const String subscriptionExpired =
      "Subscription of your facility has expired, in order to continue service please Renew subscription";
}

class HomeTabbar extends StatefulWidget {
  final List<Facility>? facility;
  final ClientDashBoardBloc? clientDashBoardBloc;

  final Function(int)? onTabChanged;
  final Function(VoidCallback?)? onExportPdfCallbackSet;
  final Function(Function(String)?)? onRangeChangeCallbackSet;

  const HomeTabbar({
    super.key,
    this.facility,
    this.clientDashBoardBloc,
    this.onTabChanged,
    this.onExportPdfCallbackSet,
    this.onRangeChangeCallbackSet,
  });

  @override
  State<HomeTabbar> createState() => _HomeTabbarState();
}

class _HomeTabbarState extends State<HomeTabbar>
    with TickerProviderStateMixin {
  TabController? tabController;

  final GlobalStorage globalStorage = GetIt.instance();

  Map<String, dynamic>? decodedToken;

  String clintId = "";
  dynamic planId;

  /// INIT
  @override
  void initState() {
    super.initState();

    clintId = globalStorage.getClientId();
  }

  /// TAB CONTROLLER INIT
 /* void _initTabController() {
    if (widget.facility == null || widget.facility!.isEmpty) return;

    tabController?.dispose();

    tabController = TabController(
      length: widget.facility!.length,
      vsync: this,
    );

    tabController!.addListener(_onTabChanged);

    if (widget.facility!.length > 1) {
      tabController!.index = 1;
    }
  }*/

  void _initTabController() {
    if (widget.facility == null || widget.facility!.isEmpty) return;

    tabController?.removeListener(_onTabChanged);
    tabController?.dispose();

    tabController = TabController(
      length: widget.facility!.length,
      vsync: this,
      initialIndex: widget.facility!.length > 1 ? 1 : 0,
    );

    tabController!.addListener(_onTabChanged);
  }

  /// TAB CHANGE LISTENER
  void _onTabChanged() {
    if (mounted &&
        tabController != null &&
        !tabController!.indexIsChanging &&
        widget.onTabChanged != null) {
      widget.onTabChanged!(tabController!.index);
    }
  }

  @override
  void didUpdateWidget(covariant HomeTabbar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.facility?.length != widget.facility?.length) {
      _initTabController();
    }
  }

  @override
  void dispose() {
    tabController?.removeListener(_onTabChanged);
    tabController?.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    /*if (tabController == null && widget.facility!.isNotEmpty) {
      _initTabController();
    }*/

    return BlocConsumer(
      bloc: widget.clientDashBoardBloc,
      listener: (context, state) {
        if (state is DashboarLoading) {
          EasyLoading.show(status: state.message);
        }

        if (state is GetAllFacility) {
          EasyLoading.dismiss();
        }

        if (state is Subcription) {
          EasyLoading.dismiss();
          planId = globalStorage.getPlanId();
        }

        if (state is DashboarError) {
          EasyLoading.dismiss();
          if (state.error != "Does Not Exist") {
            EasyLoading.showError(state.error);
          }
        }
      },
      builder: (context, state) {
        if (tabController == null ||
            tabController!.length != widget.facility!.length) {
          _initTabController();
        }

        if (tabController == null) return const SizedBox();

        return Column(
          children: [
            SizedBox(height: DashboardConstants.tabTopSpace.h),

            /// TAB BAR
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.04,
              child: TabBar(
                controller: tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,

                indicatorColor: AppColors.backgroundColor,
                indicatorPadding: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                indicatorSize: TabBarIndicatorSize.label,

                labelPadding: const EdgeInsets.only(left: 8),

                labelStyle: AppTextStyle.font10bold.copyWith(
                  color: AppColors.black,
                ),

                /// TAP HANDLER (fix outside click issue)


        onTap: (index) async {
        final facility = widget.facility![index];

        if (facility.id == 0) {
        final result = await Navigator.push(
        context,
        MaterialPageRoute(
        builder: (_) => const Home(isFromDashboard: true),
        ),
        );

        if (result == true || result == null) {
          tabController?.animateTo(1);
        }

        if (result == true && tabController != null) {
          tabController!.animateTo(1); // go to first facility tab
        }
        } else {
          tabController!.animateTo(
          widget.facility!.indexOf(facility));
          }
        },
                tabs: widget.facility!
                    .map(
                      (e) => Tab(
                    child: TabbarWidget(
                      id: e.id,
                      title: e.facilityName,
                    ),
                  ),
                )
                    .toList(),
              ),
            ),

            /// TAB VIEW
            Expanded(
              child: TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: widget.facility!.map((e) {
                  /// SUBSCRIPTION EXPIRED
                  if (e.subscriptionStatus == "inactive" &&
                      !e.isFreeTrial!) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: DashboardConstants
                              .expiredMessageTopSpace,
                        ),
                        Center(
                          child: Text(
                            DashboardConstants.subscriptionExpired,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.font14bold,
                          ),
                        ),
                        const SizedBox(
                          height: DashboardConstants
                              .expiredMessageBottomSpace,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PremiumScreeen(
                                  indexTab:
                                  widget.facility!.indexOf(e),
                                  tabController: tabController,
                                  clientDashBoardBloc:
                                  widget.clientDashBoardBloc,
                                  fromTabbar: true,
                                ),
                              ),
                            );
                          },
                          child: const Custombutton(
                            text: "Renew",
                            width: 200,
                          ),
                        )
                      ],
                    );
                  }

                  /// PREMIUM PLAN
                  if (e.planName == "PREMIUM") {
                    return DashboardScreen(
                      facilityId: e.id,
                      plan: e.planName,
                      status: e.subscriptionStatus,
                      tabIndex: widget.facility!.indexOf(e),
                      facility: widget.facility!,
                      clientDashBoardBloc:
                      widget.clientDashBoardBloc,
                      isFutureSub: e.isFutureSubscription!,
                      janitorId: e.id,
                      onExportPdfCallbackSet:
                      widget.onExportPdfCallbackSet,
                      onRangeChangeCallbackSet:
                      widget.onRangeChangeCallbackSet,
                    );
                  }

                  /// NORMAL PLAN
                  return TaskDashboardScreen(
                    facilityId: e.id,
                    clientId: clintId,
                    planName: e.planName,
                    subscriptionStatus: e.subscriptionStatus,
                    tabIndex: widget.facility!.indexOf(e),
                    facility: widget.facility,
                    clientDashBoardBloc:
                    widget.clientDashBoardBloc,
                    isFutureSub: e.isFutureSubscription,
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}


/*
class HomeTabbar extends StatefulWidget {
  List<Facility>? facility;
  ClientDashBoardBloc? clientDashBoardBloc;
  Function(int)? onTabChanged;
  Function(VoidCallback?)? onExportPdfCallbackSet;
  Function(Function(String)?)? onRangeChangeCallbackSet;
  HomeTabbar(
      {super.key,
        this.facility,
        this.clientDashBoardBloc,
        this.onTabChanged,
        this.onExportPdfCallbackSet,
        this.onRangeChangeCallbackSet});

  @override
  State<HomeTabbar> createState() => _HomeTabbarState();
}

class _HomeTabbarState extends State<HomeTabbar> with TickerProviderStateMixin {
  TabController? tabController;
  ClientDashBoardBloc dashBoardBloc = ClientDashBoardBloc();
  Map<String, dynamic>? decodedToken;
  GlobalStorage globalStorage = GetIt.instance();
  //  List<Facility> facility = [];
  dynamic planId;
  String clintId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var some = globalStorage.getClientToken();
    // tabController =  TabController(length: widget.facility.length, vsync: this);

    clintId = globalStorage.getClientId();

    // dashBoardBloc.add( GetAllFacilityEvent(
    //     clientId: int.parse(clintId)
    // ) );

    print("facility in tabbar ${widget.facility!.length}");

    // tabController =  TabController(length:2, vsync: this);

    decodedToken = JwtDecoder.decode(some);

    // String clintId = globalStorage.getClientId();

    dashBoardBloc.add(SubcriptionEvent(id: int.parse(clintId)));

    //  facility = state.facilityModel!.results!.facilities!;

    //  widget.facility!.insert(0,  Facility(
    //    facilityName: "Add Facility/Task",
    //    id: 0,));
    // facility.add(
    //   Facility(
    //     facilityName: "Add Facility",
    //     id: 0,
    //   )
    // );
    // print("facilty  lent ${widget.facility!.length}");

    // setState(() {
    //  tabController!.animateTo(1);

    // facality();

    // print("facilty  lent ${widget.facility!.length}");
    // print("controller lent ${tabController!.length}");
  }

  @override
  void dispose() {
    tabController?.removeListener(_onTabChanged);
    tabController?.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (mounted &&
        tabController != null &&
        !tabController!.indexIsChanging &&
        widget.onTabChanged != null) {
      widget.onTabChanged!(tabController!.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("facility in tabbar ${widget.facility!.length}");

    // Only create TabController if it doesn't exist or length changed
    if (tabController == null ||
        tabController!.length != widget.facility!.length) {
      tabController?.removeListener(_onTabChanged);
      tabController?.dispose();
      tabController =
          TabController(length: widget.facility!.length, vsync: this);
      tabController!.addListener(_onTabChanged);
      // Set initial tab after a frame to avoid issues
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted &&
            tabController != null &&
            !tabController!.indexIsChanging) {
          tabController!.animateTo(1);
        }
      });
    }

    print("state in tabar ${widget.facility} ");

    return BlocConsumer(
        bloc: widget.clientDashBoardBloc,
        listener: (context, state) {
          print("state in tabar $state ");

          if (state is DashboarLoading) {
            EasyLoading.show(status: state.message);
          }

          if (state is GetAllFacility) {
            EasyLoading.dismiss();
            //  state.facilityModel!.results!.facilities!;
            // print("lent ${state.facilityModel!.results!.facilities!.length}");
            // dashBoardBloc.add( SubcriptionEvent(
            //     id: decodedToken!["id"]
            // ) );
          }

          if (state is Subcription) {
            EasyLoading.dismiss();

            print(
                "state.facilityModel!.results!.facilities! ${widget.facility!.length}");
            //
            // });

            planId = globalStorage.getPlanId();
            //          widget.clientDashBoardBloc!.add(FacilityByJanitorEvent(
            // facilityId: widget.facility![1].id!,
            // clientId: int.parse(clintId)));

            // state.subscriptionModel!.results!.planId;
            // taskModel =  state.taskModel;
          }

          if (state is DashboarError) {
            EasyLoading.dismiss();

            if (state.error == "Does Not Exist") {
            } else {
              EasyLoading.showError(state.error);
            }
          }
        },
        builder: (context, state) {
          print("facilty in buidler ${widget.facility!.length}");

          return tabController == null
              ? Container()
              : Column(
            // mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.04,
                  child: TabBar(
                    indicatorColor: AppColors.backgroundColor,
                    padding: EdgeInsets.zero,
                    indicatorPadding: EdgeInsets.zero,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelPadding:
                    const EdgeInsets.only(right: 0, left: 8),

                    //  labelColor:AppColors.buttonBgColor ,
                    tabAlignment: TabAlignment.start,

                    isScrollable: true,
                    labelStyle: AppTextStyle.font10bold.copyWith(
                      color: AppColors.black,
                      // color: AppColors.buttonBgColor,
                    ),
                    // physics: NeverScrollableScrollPhysics(),
                    controller: tabController,
                    tabs: widget.facility!
                        .map((e) => Tab(
                      // child: Icon( Icons.add),

                      // icon: Icon(Icons.home),

                      icon: GestureDetector(
                        onTap: () {
                          print("object");
                          if (e.id == 0) {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) {
                                return const Home(
                                  isFromDashboard: true,
                                );
                              },
                            ));
                            // }
                          } else {
                            tabController!.animateTo(
                                widget.facility!.indexOf(e));
                          }
                        },
                        child: TabbarWidget(
                          id: e.id,
                          title: e.facilityName,
                        ),
                      ),
                    ))
                        .toList(),
                  ),
                ),
                Expanded(
                  // flex: 1,
                  // height: MediaQuery.of(context).size.height/2.1,
                  child: TabBarView(
                    // viewportFraction: 3,
                    physics: const NeverScrollableScrollPhysics(),
                    controller: tabController,
                    children: widget.facility!
                        .map((e) =>
                    // e.planName == "PREMIUM" &&   e.planName == "CLASSIC" &&
                    //  e.id == 1 ?

                    //   SizedBox() :

                    e.subscriptionStatus == "inactive" &&
                        !e.isFreeTrial!
                        ? Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 200,
                        ),
                        Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            "Subscription of your facility has expired, in order to continue service please Renew subscription",
                            style: AppTextStyle.font14bold,
                          ),
                        ),
                        //
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PremiumScreeen(
                                      indexTab: widget.facility!
                                          .indexOf(e),
                                      tabController:
                                      tabController,
                                      clientDashBoardBloc: widget
                                          .clientDashBoardBloc,
                                      fromTabbar: true,
                                    ),
                              ),
                            );
                          },
                          child: const Custombutton(
                              text: "Renew", width: 200),
                        )
                      ],
                    )
                        : e.planName == "PREMIUM"
                        ? DashboardScreen(
                      facilityId: e.id,
                      plan: e.planName,
                      status: e.subscriptionStatus,
                      tabIndex:
                      widget.facility!.indexOf(e),
                      facility: widget.facility!,
                      clientDashBoardBloc:
                      widget.clientDashBoardBloc,
                      isFutureSub:
                      e.isFutureSubscription!,
                      janitorId: e.id,
                      onExportPdfCallbackSet:
                      widget.onExportPdfCallbackSet,
                      onRangeChangeCallbackSet: widget
                          .onRangeChangeCallbackSet,
                    )
                        :
                    // Text("${e.isFutureSubscription}"))
                    TaskDashboardScreen(
                      facilityId: e.id,
                      clientId: clintId,
                      planName: e.planName,
                      subscriptionStatus:
                      e.subscriptionStatus,
                      tabIndex:
                      widget.facility!.indexOf(e),
                      facility: widget.facility,
                      clientDashBoardBloc:
                      widget.clientDashBoardBloc,
                      isFutureSub:
                      e.isFutureSubscription,
                    ))
                        .toList(),
                  ),
                ),
              ]);
        });
  }
}*/



