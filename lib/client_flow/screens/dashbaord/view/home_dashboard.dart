import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:woloo_smart_hygiene/client_flow/utils/client_images.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

import '../../../../core/local/global_storage.dart';
import '../../../../janitorial_services/screens/monitor-iot.dart';
import '../../../../screens/dashboard/view/regular_task.dart';
import '../../../../screens/login/view/login_screen.dart';
import '../../../../screens/supervisor_dashboard/view/supervisor_dashboard_screen.dart';
import '../../../../utils/app_images.dart';
import '../../../widgets/CustomButton.dart';
import '../../../widgets/explore_card.dart';
import '../../subcription/view/subcription.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../data/model/facility_model.dart';
import 'home.dart';
import 'home_tabbar.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  ClientDashBoardBloc dashBoardBloc = ClientDashBoardBloc();
  Map<String, dynamic>? decodedToken;
  GlobalStorage globalStorage = GetIt.instance();
  List<Facility> facility = [

  ];
  Duration difference = const Duration(
    days: 0,
  );

  bool isClientSupervisor = false;
  String? clientName;
  String? planId = "1";
  String? formatted;
  bool isChanges = false;
  bool isLoading = false;
  //  String supervisorToken = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var some = globalStorage.getClientToken();
    //  supervisorToken   =  globalStorage.getClientToken();
    String clintId = globalStorage.getClientId();

    clientName = "";
    //  globalStorage.getSupervisorName();

    DateTime now = DateTime.now();
    formatted = DateFormat('h:mm a, d MMM yyyy').format(now);

    print("plamn  $planId");

    // dashBoardBloc.add( GetAllFacilityEvent(
    // clientId: int.parse(clintId)
    // ) );

    dashBoardBloc.add(SubcriptionEvent(id: int.parse(clintId)));

  

    decodedToken = JwtDecoder.decode(some);

    // dashBoardBloc.add( ClientEvent(
    //   id: decodedToken!["id"]
    // ) );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        titleSpacing: 0,
        // leadingWidth: 0,

        // toolbarHeight: 100,

        // leading: CustomImageProvider(
        //   image: AppImages.dashlogo,
        //   width: 80,
        //   height: 80,
        //   // fit: BoxFit.f,
        // ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomImageProvider(
              image: AppImages.dashlogo,
              width: 80,
              height: 80,
              // fit: BoxFit.f,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Hello $clientName",
                  style: AppTextStyle.font14bold,
                ),
                Text(
                  formatted!,
                  style: AppTextStyle.font12,
                )
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        // physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: [
              const SizedBox(
                height: 14,
              ),

              BlocConsumer(
                bloc: dashBoardBloc,
                listener: (context, state) {
                  print("state in dashbaord $state ");

                  if (state is DashboarLoading) {
                    // isLoading = true ;

                    EasyLoading.show(status: state.message);
                  }

                  if (state is GetAllFacility) {
                    isLoading = false;
                    EasyLoading.dismiss();
                     String clintId = globalStorage.getClientId();

                   dashBoardBloc.add(CheckSupvisorEvent(id: int.parse(clintId)));
                    // dashBoardBloc.add( SubcriptionEvent(
                    //     id: decodedToken!["id"]
                    // ) );

                    facility = state.facilityModel!.results!.facilities!;

                    isLoading =
                        state.facilityModel!.results!.facilities!.isEmpty
                            ? true
                            : false;

                    // setState(() {
                    //   print("facility length ${facility.length}");
                    // });

                    print("check loading ${isLoading}");

                    if (facility.isEmpty) {
                        //  facility.insert(
                        // 0,
                        // Facility(
                        //     facilityName: "Add Facility/Task",
                        //     id: 0,
                        //     isFutureSubscription: false));
                      // facility.add(Facility(
                      //     facilityName: "Add Facility/Task",
                      //     id: 0,
                      //     isFutureSubscription: false));
                    }
                         facility.insert(
                        0,
                        Facility(
                            facilityName: "Add Facility/Task",
                            id: 0,
                            isFutureSubscription: false));

                    // facility.insert(
                    //     0,
                    //     Facility(
                    //         facilityName: "Add Facility/Task",
                    //         id: 0,
                    //         isFutureSubscription: false));
                    //  setState(() {

                    //  });

                    print("facility length ${facility.length}");
                    // facility.add(
                    //   Facility(
                    //     facilityName: "Add Facility",
                    //     id: 0,
                    //   )
                    // );
                    //  tabController =  TabController(length: facility.length, vsync: this);
                    // setState(() {
                    //  tabController!.animateTo(1);
                    //
                    // });
                  }

                  if (state is Subcription) {
                    planId =

                        // "0";

                        globalStorage.getPlanId();
                    print("plan id $planId");

                    dashBoardBloc.add(GetAllFacilityEvent(
                        clientId: int.parse(globalStorage.getClientId())));

                    DateTime currentDate = DateTime.now();
                    // YYYY-MM-DD format
                    // DateTime dateTime = DateTime.parse(dateString);
                    DateTime futureDate = state.subscriptionModel!.results!
                        .expiryDate!; // Example future date

                    // print('Difference: $futureDate days');

                    difference =
                        //  Duration(days: 0 ) ;
                        futureDate.difference(currentDate);

                    print('Difference: ${difference.inDays}  pamnd  ${planId} days');
                    print('Paln: ${planId} days');

                    EasyLoading.dismiss();

                    if (difference.inDays == 0 || difference.inDays < 0) {
                      if (planId == "0") {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return PopScope(
                              canPop: false,
                              child: AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60),
                                ),

                                backgroundColor: AppColors.white,
                                // title:  Center(
                                //   child: Text("Your Free Subscription has expired",
                                //    style: AppTextStyle.font20bold,
                                //    textAlign: TextAlign.center,
                                //   ),
                                // ),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      CustomImageProvider(
                                        image: ClientImages.warning,
                                        width: 86.w,
                                        height: 86.h,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        textAlign: TextAlign.center,
                                        "Your TASKMASTER Trial Period has expired. Kindly pay to Continue",
                                        style: AppTextStyle.font18bold,
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (context) {
                                              return SubcriptionScreen(
                                                dashBoardBloc: dashBoardBloc,
                                                isfromFacility: true,
                                                facilityId: facility[1].id,
                                              );
                                            },
                                          );
                                        },
                                        child: const Custombutton(
                                          width: 300,
                                          text: "Pay Now",
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ).then(
                          (value) {
                            // Navigator.of(context).pop();
                          },
                        );
                      }
                    }

                    // gender = state.tasklist;
                  }

                  if (state is DashboarError) {
                    isLoading = true;
                    print("facility length ${facility}");
                    EasyLoading.dismiss();
                    EasyLoading.showError(state.error);
                  }
                },
                builder: (context, state) {
                         print( "state in suvdd builder $state ");
                     if (state is DashboarLoading){
                         return const SizedBox();
                      }
                      if   ( state is  Subcription) {
                        return const SizedBox(); 
                      }
                      if(state is GetAllFacility){
                       
                        return const SizedBox(
                          // height: 0,
                        );


                     

                      }
                       if(state is CheckSupervisor ){
                         return    
                          difference.inDays != 0 && planId == "0"
                        ? 
                        Column(
                          children: [
                     
                            Text(
                              //  textAlign: TextAlign.center,
                              "Your Free Subscription shall end in ${difference.inDays} Days.",
                              style: AppTextStyle.font13
                                  .copyWith(color: AppColors.textgreyColor),
                            ),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return SubcriptionScreen(
                                      dashBoardBloc: dashBoardBloc,
                                      isfromFacility: true,
                                      facilityId: facility[1].id,
                                      isFromTrail: true,
                                    );
                                  },
                                );

                                //  Navigator.of(context).push( MaterialPageRoute(builder: (context) {
                                //    return const SubcriptionScreen();
                                //  }, ) );
                              },
                              child: Text(
                                textAlign: TextAlign.center,
                                DashboardConst.renew,
                                style: AppTextStyle.font13.copyWith(
                                  color: AppColors.textgreyColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        )
                      :
                       const SizedBox();

                       }
                     if (state is DashboarError){
                      
                         return const SizedBox();
                      }
                      return const SizedBox();
                 
                },
              ),

              BlocConsumer(
                  listener: (context, state) {
                    if (state is DashboarLoading) {
                      EasyLoading.show(status: state.message);
                    }

                    if (state is CheckSupervisor) {
                      EasyLoading.dismiss();

                      isClientSupervisor = state
                          .checkSupervisorModel!.results!.isClientSupervisor!;
                    }

                    if (state is DashboarError) {
                      EasyLoading.dismiss();
                      EasyLoading.showError(state.error);
                    }
                  },
                  bloc: dashBoardBloc,
                  builder: (context, state) {
                      if (state is DashboarLoading){
                         return const SizedBox();
                      }
                       if   ( state is  Subcription) {
                        return const SizedBox(); 
                      }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DashboardConst.dashboardOverview,
                                style: AppTextStyle.font20bold,
                              ),

                              isClientSupervisor
                                  ? GestureDetector(
                                      onTap: () {
                                        String supervisorToken =
                                            globalStorage.getToken();

                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) {
                                            return supervisorToken == ""
                                                ? const LoginScreen(
                                                    type: null,
                                                    // isFromSupervisor: true,
                                                  )
                                                : const SupervisorDashboard(
                                                    isFromSupervisor: true);
                                          },
                                        ));
                                        //  Navigator.pushNamed(context, AppRoutes.clientDashboard);
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                  alpha: 0.2), // Shadow color
                                              spreadRadius:
                                                  1, // How wide the shadow should spread
                                              blurRadius:
                                                  10, // The blur effect of the shadow
                                              offset: const Offset(0,
                                                  0), // No offset for shadow on all sides
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CustomImageProvider(
                                            // width: 22,
                                            // height: 22,
                                            image: AppImages.changeArrow,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox()

                              // Icon(
                              //   Icons.ß
                              // )
                            ],
                          ),
                          // isLoading ?  SizedBox() :
                          isLoading
                              ? Column(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 70,
                                    ),

                                    Center(
                                      child: ExploreCard(
                                        title: "TASQ",
                                        subTitle: "MASTER",
                                        description1:
                                            "Monitor your hygiene with Woloo’s",
                                        description:
                                            "Smart Hygiene Technology Service.",
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) {
                                              return const Home(
                                                isFromDashboard: false,
                                              );
                                            },
                                          ));
                                        },
                                        img: AppImages.dashboard,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    const Text(
                                      textAlign: TextAlign.center,
                                      "Task Master is Woloo’s smart task automation and hygiene management module designed to streamline cleaning operations across public and private facilities.",
                                      style: TextStyle(
                                        wordSpacing: 1,
                                        color: AppColors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),

                                    const Text(
                                      textAlign: TextAlign.center,
                                      "It ensures that hygiene standards are met consistently through real-time monitoring, automated scheduling, and performance tracking of janitorial staff.",
                                      style: TextStyle(
                                        wordSpacing: 1,
                                        color: AppColors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),

                                    //

                                    // Text("data"),
                                  ],
                                )
                              : SizedBox(
                                  // width: MediaQuery.of(context).size.width/1,
                                  // flex: 2,
                                  height: 745.h,
                                  child:
                                      //  Text(facility.length.toString())
                                      //  isChanges ?
                                      //    const  DashboardScreen() :
                                    HomeTabbar(
                                    facility: facility,
                                    clientDashBoardBloc: dashBoardBloc,
                                  ))
                        ],
                      ),
                    );
                  }),
              //     Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [

              //     GestureDetector(
              //       onTap: () {
              //         isChanges = false;
              //         setState(() {

              //         });

              //       },

              //       child: Custombutton(text: "Tasq Master", width: 150)),

              //     GestureDetector(
              //       onTap: () {
              //          isChanges = true;
              //          setState(() {

              //          });

              //       },
              //       child: Custombutton(text: "Sting Guard", width: 150))
              //   ],
              //  ),
            ],
          ),
        ),
      ),
    );
  }
}
