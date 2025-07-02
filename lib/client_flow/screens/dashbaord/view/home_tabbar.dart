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
import '../../subcription/view/premium_screeen.dart';
import '../../subcription/view/subcription.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

class HomeTabbar extends StatefulWidget {
  List<Facility>? facility;
  ClientDashBoardBloc? clientDashBoardBloc;
  HomeTabbar({super.key, this.facility, this.clientDashBoardBloc});

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
  Widget build(BuildContext context) {
      print("facility in tabbar ${widget.facility!.length}");
    tabController = TabController(length: widget.facility!.length, vsync: this);
    tabController!.animateTo(1);

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
             
              if(state.error == "Does Not Exist"){

              }else{
                
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
                                          print("object");
                                          // if (planId == null) {
                                            // showModalBottomSheet(
                                            //   backgroundColor:
                                            //       Colors.transparent,
                                            //   // isScrollControlled: true,
                                            //   context: context,

                                            //   builder: (context) {
                                            //     return SubcriptionScreen(
                                            //       dashBoardBloc: dashBoardBloc,
                                            //       isfromFacility: false,
                                            //     );
                                            //   },
                                            // );

                                            //   Navigator.of(context).push( MaterialPageRoute(builder: (context) {
                                            //  return const SubcriptionScreen();
                                            //     }, ) );
                                          // } else {
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
                                    
                                      e.subscriptionStatus == "inactive" 
                                       && !e.isFreeTrial!

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
                                                  tabController: tabController,
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
                                          tabIndex: widget.facility!.indexOf(e),
                                          facility: widget.facility,
                                          clientDashBoardBloc:
                                              widget.clientDashBoardBloc,
                                          isFutureSub: e.isFutureSubscription!,    
                                        )
                                      : 
                                          // Text("${e.isFutureSubscription}"))
                                      Charts(

                                          facilityId: e.id,
                                          plan: e.planName,
                                          status: e.subscriptionStatus,
                                          tabIndex: widget.facility!.indexOf(e),
                                          facility: widget.facility,
                                          clientDashBoardBloc:
                                              widget.clientDashBoardBloc,
                                          isFutureSub: e.isFutureSubscription!,    
                                        ))
                              .toList(),
                        ),
                      ),
                    ]);
        });
  }
}
