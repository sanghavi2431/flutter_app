import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/bloc/dashboard_state.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/tasktime_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/widget/congrats_dailog.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/widget/dailog.dart';
import 'package:woloo_smart_hygiene/client_flow/widgets/CustomButton.dart';
import 'package:woloo_smart_hygiene/client_flow/widgets/dropdown.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';

import '../../../../core/local/global_storage.dart';
import '../../../../screens/common_widgets/dropdown_dialogue.dart';
import '../../../../screens/common_widgets/multiselect_dropdown.dart';
// import '../../../../screens/report_issue_screen/data/model/facility_dropdown_model.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_textstyle.dart';
import '../../../utils/client_images.dart';
import '../../../widgets/CustomTextField.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../login/view/login_as.dart';
import '../../subcription/view/premium_screeen.dart';
import '../../subcription/view/subcription.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../controller/dashbaord_controller.dart';
// import '../data/model/facility_model.dart';
import '../data/model/facility_dropdown_model.dart';
import '../data/model/facility_model.dart';
import '../data/model/payment_status.dart';
import '../data/model/task_model.dart';
import '../data/model/tasklist_model.dart';
// import '../model/facility_model.dart';
import '../model/facility_model.dart';
import 'dashboard.dart';
import 'widget/add_time_dailog.dart';
import 'widget/buddy_list_dailog.dart';
import 'widget/select_buddy_dailog.dart';

class Home extends StatefulWidget {
  final bool? isFromDashboard;
  const Home({super.key, required this.isFromDashboard});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ClientDashBoardBloc dashBoardBloc = ClientDashBoardBloc();
  final TextEditingController facilityController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController janNameController = TextEditingController();
  final TextEditingController janMobileController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<DropdownSearchState> _facilityKey =
      GlobalKey<DropdownSearchState>();
  GlobalStorage globalStorage = GetIt.instance();

  final GlobalKey<DropdownSearchState> _clusterNameKey =
      GlobalKey<DropdownSearchState>();
  final addSuperVisorKey = GlobalKey<FormState>();
  final addJanitorKey = GlobalKey<FormState>();
  final facilityKey = GlobalKey<FormState>();
  Map<String, dynamic>? decodedToken;
  TextEditingController controller = TextEditingController();
  int selectedIndex = -1;
  int selectedAdmin = -1;
  int selectedGender = -1;
  String? janitorGender = "";
  bool isClientSupervisor = false;
  bool canPop = true;
  bool isGender = false;

  List<Facility> facilityList = [];

  List<TaskDropdownModel> facilityNames = [];
  List<FacilityDropdownModel> facilitydropdownNames = [];

  FacilityDropdownModel? selectedFacility;

  List<TaskDropdownModel> gender = [
    TaskDropdownModel(id: 1, facilityName: "Male"),
    TaskDropdownModel(id: 1, facilityName: "Female")
  ];
  int? clusterId;
  int? locationId;
  int? facilityId;
  bool isOpenDrop = false;

  // Str planId;
  FocusNode addressFocusNode = FocusNode();
  PaymentStatusModel? paymentStatusModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var some = globalStorage.getClientToken();

    facilityFocusNode = FocusNode();

    String facalityRef =

        //  "sdsd";

        globalStorage.getFacilityRef();
    //  planId = globalStorage.getPlanId();

    decodedToken = JwtDecoder.decode(some);
    dashBoardBloc.add(ClientEvent(id: decodedToken!["id"]));

    if (facalityRef.isNotEmpty) {

      dashBoardBloc.add(PaymentStatusEvent(refId: facalityRef));
    }

    debugPrint(" toeknm ${decodedToken!["id"]}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),

              Text(
                DashboardConst.welcomeMessage,
                style: AppTextStyle.font32bold,
              ),
              const SizedBox(
                height: 20,
              ),

              CustomImageProvider(
                image: ClientImages.taskMasterblack,
                width: 171,
                height: 83,
                //  color: AppColors.black,
              ),

              const SizedBox(
                height: 35,
              ),

              CustomImageProvider(
                image: AppImages.welcome,
                width: 332,
                height: 223,
              ),

              SizedBox(
                height: 30.h,
              ),

              //  const  SizedBox(
              // height: 10,
              //   ),
              //
              //  Text(DashboardConst.dashboardTitle,
              //   style: AppTextStyle.font18bold,
              // ),
              const SizedBox(
                height: 20,
              ),

              Text(
                DashboardConst.onboardingMessage,
                textAlign: TextAlign.center,
                style: AppTextStyle.font14,
              ),

              const SizedBox(
                height: 30,
              ),
              BlocConsumer(
                  bloc: dashBoardBloc,
                  listener: (context, state) {
                    print("dashboar $state ");

                    if (state is DashboarLoading) {
                      EasyLoading.show(status: state.message);

                    }

                    if (state is ClientSetUp) {
                      EasyLoading.dismiss();
                      print("client setup ${isClientSupervisor}");
                      String clintId = globalStorage.getClientId();

                      dashBoardBloc
                          .add(CheckSupvisorEvent(id: int.parse(clintId)));

                      locationId =
                          state.clientSetupModel.results.data.locationId;
                      facilityId =
                          state.clientSetupModel.results.data.facilityId;

                      if (isClientSupervisor) {
                        String clientId = globalStorage.getClientId();
                        clusterId =
                            state.clientSetupModel.results.data.clusterId;

                        dashBoardBloc.add(AddJanitorEvent(
                            mobile: janMobileController.text,
                            name: janNameController.text,
                            gender: janitorGender,
                            roleId: "1",
                            clientId: clientId,
                            clusterId: [clusterId!]));

                        //                String clientId =   globalStorage.getClientId();
                        //                String mobile = globalStorage.getClientMobileNo();
                        //                String name = globalStorage.getSupervisorName();
                        // clusterId =     state.clientSetupModel.results.data.clusterId;

                        //  dashBoardBloc.add(
                        //        AddUserEvent(
                        //         mobile: mobile,
                        //         name: name,
                        //         roleId: "2",
                        //         clientId: clientId,
                        //         clusterId: [state.clientSetupModel.results.data.clusterId]
                        //    )  );
                      } else {
                        String clientId = globalStorage.getClientId();
                        clusterId =
                            state.clientSetupModel.results.data.clusterId;

                        dashBoardBloc.add(AddUserEvent(
                          mobile: mobileController.text,
                          name: nameController.text,
                          roleId: "2",
                          clientId: clientId,
                          // gender: janitorGender,
                          clusterId: [
                            state.clientSetupModel.results.data.clusterId
                          ],
                          isSelfAssign: isSelfAssign,
                        ));
                      }

                      // adminBottomSheet();
                    }

                    if (state is PaymentStatus) {
                      EasyLoading.dismiss();

                      paymentStatusModel = state.paymentStatusModel!;

                      print("payment ${paymentStatusModel} ");
                    }

                    if (state is AddUser) {
                      String clientId = globalStorage.getClientId();

                      print("add user succcesfull ");

                      dashBoardBloc.add(AddJanitorEvent(
                          mobile: janMobileController.text,
                          name: janNameController.text,
                          gender: janitorGender,
                          roleId: "1",
                          clientId: clientId,
                          clusterId: [
                            clusterId ?? selectedFacility!.clusterId!
                          ]));

                      EasyLoading.dismiss();

                    }

                    if (state is Addjanitor) {
                      print("add jantor succcesfull $selectedFacility");
                      //  print("add jantor succcesfull ${globalStorage.getFacilityRef()}");
                      String clientId = globalStorage.getClientId();
                    
                     selectedFacility == null ?
                      dashBoardBloc.add(AssignTaskEvent(
                        clientId: int.parse(clientId),
                        shiftTime: "${shiftTime!.hour}:${shiftTime!.minute}:00",
                        taskIds: taksIds,
                        estimatedTime: estimatedTime.toString(),
                        taskTimes: dashController.taskTimes,
                        janitorId: state.superVisorModel!.results!.data!.value!,
                        facilityRef: globalStorage.getFacilityRef(),
                        // facilityId: selectedFacility!.id
                        //                           .toString()

                      ))
                      :
                        dashBoardBloc.add(AssignTaskEvent(
                        clientId: int.parse(clientId),
                        shiftTime: "${shiftTime!.hour}:${shiftTime!.minute}:00",
                        taskIds: taksIds,
                        estimatedTime: estimatedTime.toString(),
                        taskTimes: dashController.taskTimes,
                        janitorId: state.superVisorModel!.results!.data!.value!,
                        facilityRef: "",
                        facilityId: selectedFacility!.id
                                                  .toString()

                      ));
                         globalStorage.removeFacilityRef();
                    }

                    if (state is CheckSupervisor) {
                      EasyLoading.dismiss();
                      isClientSupervisor = state
                          .checkSupervisorModel!.results!.isClientSupervisor!;
                    }

                    if (state is GetClient) {
                      EasyLoading.dismiss();
                    }

                    if (state is AssignTask) {
                      EasyLoading.dismiss();

                      canPop = false;

                      dashController.taskTimes = <Map<String, String>>[].obs;
                     

                      congratDailog();
                      //  showDialog(context: context, builder:
                      //   (context) {
                      //      return CongratsDailog(buddyName: "dskjdfkj");
                      //   },
                      //  ).then((v){
                      //    Navigator.of(context, rootNavigator: true).pop();
                      //    Navigator.of(context, rootNavigator: true).pop();
                      //    Navigator.of(context, rootNavigator: true).pop();
                      //    Navigator.of(context, rootNavigator: true).pop();
                      //    Navigator.of(context, rootNavigator: true).pop();
                      //  } );
                    }

                    if (state is GetAllJanitor) {
                      EasyLoading.dismiss();

                      // state.taskModel.

                      // facilityNames

                      // showDialog(context: context, builder:
                      //     (context) {
                      //   return BuddyListDailog( taskModel: state.taskModel, );
                      // },
                      // );
                      // taskModel =  state.taskModel;
                    }

                    if (state is GetAllFacility) {
                      
                      EasyLoading.dismiss();
                      facilitydropdownNames.clear();
                      facilityList.clear();
                      facilityList = state.facilityModel!.results!.facilities!;

                      // facilityNames.

                      // facilityList.map( ( e)=>  facilityList.add(  e.facilityName! )   );

                      for (var item in facilityList) {
                        print(" fasfkljfas list ${item.id}");
                        // print( "testing ${item["required_time"] = 15 }");
                        // item["required_time"] = 15;
                        facilitydropdownNames.add(FacilityDropdownModel(
                            id: item.id,
                            facilityName: item.facilityName,
                            locationName: item.locationName,
                            facalityType: item.facilityType,
                            endTime: item.shifts!.isEmpty
                                ? ""
                                : item.shifts!.first.endTime,
                            startTime: item.shifts!.isEmpty
                                ? ""
                                : item.shifts!.first.startTime,
                            clusterId: item.clusterId));
                      }

                      print("falicit namessss $facilitydropdownNames ");

                      // for( var facilit from facilityList ){
                      //
                      // }
                    }

                    if (state is DeltetFacility) {
                      EasyLoading.dismiss();
                    }

                    if (state is DashboarError) {
                      EasyLoading.dismiss();
                      EasyLoading.showError(state.error);
                      Future.delayed(
                        const Duration(seconds: 1),
                        () {
                          if (state.error ==
                              "Mobile number is already registered.") {
                            dashBoardBloc.add(FacilityDeleteEvent(
                                locationId: locationId!,
                                clusterId: clusterId!,
                                facilityId: facilityId!));
                          }
                        },
                      );
                    }
                  },
                  builder: (context, state) {
                    print(" state $state");
                    if (state is GetTask) {
                      debugPrint("facilkt $facilityNames");
                      debugPrint(
                          "facilkt sixe ${MediaQuery.of(context).size.height}");
                      print(
                          "facilkt sixe ${MediaQuery.of(context).size.width}");
                      EasyLoading.dismiss();
                      facilityNames = state.tasklist;
                      print("facilkt ${facilityNames.length}");
                      items.clear();
                      for (var element in facilityNames) {
                        items.add(DropdownItem(
                            label: element.facilityName!, value: element!));
                      }

                      // WidgetsBinding.instance.addPostFrameCallback((_) {

                      // if (mounted) {
                      // loadFacilities();
                      // }

                      // ✅ Safe now
                      // });

                      print("facilkt ${items.length}");

                      // gender = state.tasklist;
                    }
                    // if( state is GetTask ){

                    // }

                    return
                        // Builder(
                        // builder: ( BuildContext builderContext) {

                        widget.isFromDashboard == true
                            ? Column(
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          minimumSize:
                                              const Size(double.infinity, 59),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                12), // <-- Radius
                                          ),
                                          backgroundColor:
                                              AppColors.backgroundColor),
                                      onPressed: () {
                                        String planId =
                                            globalStorage.getPlanId();
                                        String paymentId =
                                            globalStorage.getPaymentId();

                                        print("paln id  ${planId} ");
                                        // facilityNames = [];
                                          //  dashController.taskStartTime.clear();
                                          //   dashController.taskEndTime.clear();
                                          //   dashController.taskTimes.clear();
                                          //   selectedbuddy = null;
                                          //   estimatedTime = null;
                                          //   shiftTime = null;
                                            facilityController.clear();
                                            locationController.clear();
                                            selectedIndex = -1;
                                        print("payment id  ${paymentId} ");
                                        if (paymentId.isNotEmpty) {

                                          globalStorage.removePaymentId();
                                          // paymentId = "";
                                          // setState(() {

                                          // });
                                        }
                                        if (planId == "0" &&
                                            paymentId.isEmpty) {
                                          print(" in side dsd object");
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return const Dailog(
                                                title:
                                                    "Kindly renew your subscription from dashboard",
                                                image: "",
                                                subTitle: "Go Back",
                                              );
                                            },
                                          );
                                        } else {
                                          if (paymentStatusModel == null) {
                                            showModalBottomSheet(
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              builder: (context) {
                                                return SubcriptionScreen(
                                                  dashBoardBloc: dashBoardBloc,
                                                  isfromFacility: false,
                                                );
                                              },
                                            );

                                            //  }
                                            //  }
                                          } else if (paymentStatusModel!
                                                  .results!.facilityId ==
                                              null) {
                                            print("payment id  ${paymentId} ");

                                            //              dashBoardBloc.add( const GetTaskEvent(
                                            //     category: "Home"
                                            // ) );

                                            facilityBottomSheet(false);
                                          } else {
                                            showModalBottomSheet(
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              builder: (context) {
                                                return SubcriptionScreen(
                                                  dashBoardBloc: dashBoardBloc,
                                                  isfromFacility: false,
                                                );
                                              },
                                            );
                                          }
                                        }

                                        //  ?

                                        // :
                                      },
                                      child: Text(
                                        DashboardConst.addNewFacility,
                                        style: AppTextStyle.font20bold
                                            .copyWith(color: AppColors.black),
                                      )),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          minimumSize:
                                              const Size(double.infinity, 59),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                12), // <-- Radius
                                          ),
                                          backgroundColor:
                                              AppColors.backgroundColor),
                                      onPressed: () {
                                        //  print("object ${ globalStorage.getClientId()}" );
                                        // janitorBottomSheet();
                                        dashBoardBloc.add(const GetTaskEvent(
                                            category: "Home"));

                                        loadFacilities();
                                        // //
                                        // facilityBottomSheet();
                                        selectBuddyDailog();

                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => const PremiumScreeen(),
                                        //   ),
                                        // );
                                      },
                                      child: Text(
                                        DashboardConst.addNewTask,
                                        style: AppTextStyle.font20bold
                                            .copyWith(color: AppColors.black),
                                      ))
                                ],
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(190, 59),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          12), // <-- Radius
                                    ),
                                    backgroundColor: AppColors.backgroundColor),
                                onPressed: () {
                                  //  print("object ${ globalStorage.getClientId()}" );
                                  // janitorBottomSheet();
                                  // dashBoardBloc.add( const GetTaskEvent(
                                  //     category: "Home"
                                  // ) );
                                  // //
                                  facilityBottomSheet(false);

                                  // adminBottomSheet();
                                  // taskBottomSheet();
                                  //    print(  globalStorage.getClientId());

                                  // dashBoardBloc.add(GetAllJanitorEvent(
                                  //   clientId: 340,
                                  // ) );
                                  // showDailog(context);
                                  // selectBuddyDailog();
                                  //  congratDailog();
                                },
                                child: Text(
                                  DashboardConst.getStarted,
                                  style: AppTextStyle.font20bold
                                      .copyWith(color: AppColors.black),
                                ));
                  }),
              // },

              SizedBox(
                height: 20.h,
              ),
              // GestureDetector(
              //     onTap: ()async {
              //       // status: MyJanitorProfileScreenConstants.LOGGING_OUT_TOAST
              //       //     .tr());
              //       var storage = GetIt.instance<GlobalStorage>();
              //       storage.removeToken();
              //       storage.removeLocation();
              //       storage.removeTime();
              //       storage.removeClientId();
              //       await Future.delayed(const Duration(seconds: 3));
              //       EasyLoading.dismiss();
              //       EasyLoading.showToast(MyJanitorProfileScreenConstants
              //           .LOG_OUT_SUCCESS_TOAST );
              //       if (!context.mounted) return;
              //       Navigator.pushAndRemoveUntil(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => const LoginAs()),
              //             (route) => false,
              //       );
              //     },
              //     child: const Custombutton(text: "Log out", width: 360)),

              SizedBox(
                height: 20.h,
              ),

              Text(
                textAlign: TextAlign.center,
                "The Task Master service of Woloo Smart Hygiene is a paid service. You are eligible for a 7-day free trial, during which you can add only one facility. After the trial period ends, you must pay ₹499 + GST to continue using the Task Master service.",
                style: AppTextStyle.font8,
              )

              // Padding(
              //   padding: EdgeInsets.symmetric(
              //     horizontal: 14.w,
              //     vertical: 10.h,
              //   ),
              //   child: CustomDropDownDialog(
              //     // key: dropDownKey,
              //     // selected: null,
              //     widgetKey:_clusterNameKey,
              //     hint:  DashboardConst.selectCleaningTasks,
              //     // key: Key('${_editMarketModel.city?.label}T4'),
              //     // selected: cities.firstWhereOrNull((element) => element.value == _editMarketModel.city?.value),
              //     // widgetKey: _keys[2],xx
              //     items: gender,
              //     itemAsString: (TaskDropdownModel item) =>
              //     item.facilityName,
              //
              //     onChanged: (TaskDropdownModel item) {
              //       print("click on the page $item");
              //       // facilityId = item.id!;
              //       // debugPrint("facilityId --->$facilityId");
              //       // dashBoardBloc.add(const GetTaskEvent(
              //       //     category: "Home"
              //       // ) );
              //
              //     },
              //
              //     validator: (value) => value == null
              //         ? MyReportIssueScreenConstants.FACILITY_VALIDATION
              //         .tr()
              //         : null,
              //   ),
              // ),

              // )
            ],
          ),
        ),
      ),
    );
  }

  showDailog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return
            // BlocProvider.value(
            //   value: builderContext.read<ClientDashBoardBloc>(),
            //   child: const
            const SelectBuddyDailog();
        // );
      },
    );
  }

  Future<void> loadFacilities() async {
    print("Fetching facilities...");
    // final facilityNames = await fetchFacilities(); // <- your API call

    final items = facilityNames
        .map((element) => DropdownItem(
              label: element.facilityName!,
              value: element,
            ))
        .toList();

    dropController.setItems(items);
  }

  Widget adminCard(String image, String title, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 38),
      child: Stack(
        children: [
          Container(
              //  width: 120,
              height: 151,
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Shadow color
                      spreadRadius: 1, // Spread effect
                      blurRadius: 10, // Blur effect
                      offset: const Offset(0, 5), // Bottom shadow
                    ),
                  ],
                  border: Border.all(
                      color: selectedAdmin == index
                          ? AppColors.backgroundColor
                          : AppColors.white)),
              child: Row(
                //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  CustomImageProvider(
                    image: image,
                    width: 106,
                    height: 106,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    title,
                    style: AppTextStyle.font32bold
                        .copyWith(fontSize: 30, color: AppColors.greyBorder),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              )),
          selectedAdmin == index
              ? Positioned(
                  bottom: 0,
                  right: 0,
                  // left: 100,
                  child: CustomImageProvider(
                    image: ClientImages.check,
                    width: 29,
                    height: 29,
                  ))
              : const SizedBox()
        ],
      ),
    );
  }

  Widget genderCard(String image, String title, int index) {
    return Stack(
      children: [
        Container(
            width: 151,
            height: 151,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    spreadRadius: 1, // Spread effect
                    blurRadius: 10, // Blur effect
                    offset: const Offset(0, 5), // Bottom shadow
                  ),
                ],
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: selectedGender == index
                        ? AppColors.backgroundColor
                        : AppColors.white)),
            child: Column(
              //  mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                CustomImageProvider(
                  image: image,
                  width: 67,
                  height: 67,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  title,
                  style: AppTextStyle.font13.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.greyBorder),
                )
              ],
            )),
        selectedGender == index
            ? Positioned(
                bottom: index == 0 ? 10 : 10,
                right: index == 0 ? 0 : 0,
                // left: 100,
                child: CustomImageProvider(
                  image: ClientImages.check,
                  width: 29,
                  height: 29,
                ))
            : const SizedBox()
      ],
    );
  }

  Widget card(String image, String title, int index) {
    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        children: [
          Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(

                  // image: DecorationImage(
                  //   alignment: Alignment.bottomRight,

                  //   image: AssetImage(
                  //   ClientImages.check,) ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Shadow color
                      spreadRadius: 1, // Spread effect
                      blurRadius: 10, // Blur effect
                      offset: const Offset(0, 5), // Bottom shadow
                    ),
                  ],
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: selectedIndex == index
                          ? AppColors.backgroundColor
                          : AppColors.white)),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  CustomImageProvider(
                    image: image,
                    width: 43,
                    height: 43,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    title,
                    style: AppTextStyle.font13
                        .copyWith(color: AppColors.greyBorder),
                  )
                ],
              )),
          selectedIndex == index
              ? CustomImageProvider(
                  image: ClientImages.check,
                  width: 29,
                  height: 29,
                )
              : const SizedBox()
        ],
        alignment: Alignment.bottomRight,
      ),
    );
  }

  bool? value = false;
  bool? assing = false;
  bool isSelected = false;
  DateTime dateTime = DateTime.now();
  TimeOfDay? shiftTime;
  bool isAdminSelected = false;
  DashBoardController dashController = Get.put(DashBoardController());
  FocusNode? facilityFocusNode;
  Prediction? loc;
  String errorMessage = '';
  String erroradminMessage = '';
  String errorGenderMessage = '';
  bool isSelfAssign = false;
  facilityBottomSheet(bool isFromTaskbuddy) {
    // locationController.clear();
    // facilityController.clear();
    var height = MediaQuery.of(context).size.height;

    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,

      // context and builder are
      // required properties in this widget
      context: context,
      isScrollControlled: true,
      // backgroundColor: AppColors.appbarBgColor,
      builder: (BuildContext context) {
        // we set up a container inside which
        // we create center column and display text

        // Returning SizedBox instead of a Container
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.8,
              maxChildSize: 0.96,
              // expand: false,
              // snap: false,
              builder: (context, controller) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Form(
                    key: facilityKey,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(80.0),
                          topRight: Radius.circular(80.0),
                        ),
                      ),
                      height: MediaQuery.of(context).size.height / 1.23,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: ListView(
                            controller: controller,

                            //  crossAxisAlignment: CrossAxisAlignment.start,
                            //  mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              header(DashboardConst.listYourFacility,
                                  "Facility", ClientImages.building),
                              //  const SizedBox(
                              //    height: 20,
                              //  ),
                              // Center(
                              //   child: Text(DashboardConst.listYourFacility,
                              //    style: AppTextStyle.font18bold,
                              //   ),
                              // ),
                              const SizedBox(
                                height: 20,
                              ),

                              facilitydropdownNames.isNotEmpty
                                  ? DropdownButtonHideUnderline(
                                    
                                      child: DropdownButton2<
                                          FacilityDropdownModel>(
                                        dropdownStyleData: DropdownStyleData(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                color: AppColors.white)),

                                        isExpanded: true,

                                        hint:
                                            //  selectItem == null ?
                                            Text(
                                          DashboardConst.organizationName,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                          onMenuStateChange: (isOpen) {
           print( "is oner $isOpen");
           isOpenDrop = isOpen;
           setState(() {
             
           }); 
                  
         },

    iconStyleData: IconStyleData(
                icon:
                isOpenDrop! ?
                 const Icon( Icons.keyboard_arrow_up_rounded,
                 size: 38,
                   color: Color(0xff8F8F8F)
                 )
                :
                 const Icon( Icons.keyboard_arrow_down_rounded,
                 size: 38,
                   color: Color(0xff8F8F8F)
                 )
              ),
                                        items: facilitydropdownNames!
                                            .map((FacilityDropdownModel item) {
                                          return DropdownMenuItem<
                                              FacilityDropdownModel>(
                                            value: item,
                                            child: Text(
                                              item.facilityName!,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                // color: Colors.grey,
                                                // fontWeight: FontWeight.w700
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        value: selectedFacility ??
                                            selectedFacility, // This should be a FacilityDropdownModel?
                                        onChanged:
                                            (FacilityDropdownModel? value) {
                                          print(
                                              "isfromtaskbuddy $isFromTaskbuddy");
                                          setState(() {
                                            selectedFacility = value;
                                            locationController.text =
                                                value!.locationName!;
                                            facilityController.text =
                                                value.facilityName!;
                                            if (facilitydropdownNames
                                                .isNotEmpty) {
                                              // if(isFromTaskbuddy){

                                              // }else{

                                              // if( selectedbuddy  != null ){

                                              if ("Home" ==
                                                  value.facalityType) {
                                                selectedIndex = 0;
                                                dashBoardBloc.add(GetTaskEvent(
                                                    category:
                                                        facility[selectedIndex]
                                                            .title!));
                                              } else if ("Office" ==
                                                  value.facalityType) {
                                                selectedIndex = 1;
                                                dashBoardBloc.add(GetTaskEvent(
                                                    category:
                                                        facility[selectedIndex]
                                                            .title!));
                                              } else if ("Restaurant" ==
                                                  value.facalityType) {
                                                selectedIndex = 2;
                                                dashBoardBloc.add(GetTaskEvent(
                                                    category:
                                                        facility[selectedIndex]
                                                            .title!));
                                              } else if ("Others" ==
                                                  value.facalityType) {
                                                selectedIndex = 3;
                                                dashBoardBloc.add(GetTaskEvent(
                                                    category:
                                                        facility[selectedIndex]
                                                            .title!));
                                              }
                                            }

                                            // }

                                            //  }
                                          });
                                        },
                                        buttonStyleData: ButtonStyleData(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          height: 55,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: AppColors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                    0.2), // Shadow color
                                                spreadRadius:
                                                    1, // Spread effect
                                                blurRadius: 10, // Blur effect
                                                offset: const Offset(
                                                    0, 5), // Bottom shadow
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),

                                        menuItemStyleData:
                                            const MenuItemStyleData(height: 40),
                                      ),
                                    )

                                  // DropDownDialog(
                                  //   isprop: true,

                                  //   // selected: clusterNames.first,
                                  //   // key: _dropDownKey,
                                  //   widgetKey: _clusterNameKey,
                                  //   hint:DashboardConst.organizationName,

                                  //   items: facilitydropdownNames,

                                  //   itemAsString: (FacilityDropdownModel item) =>
                                  //   item.facilityName,
                                  //   onChanged: (FacilityDropdownModel item) {
                                  //     debugPrint("in drop down ${item.locationName}");
                                  //     try {

                                  //       locationController.text =   item.locationName!;
                                  //       facilityController.text = item.facilityName!;
                                  //       setState(() {});

                                  //       // clusterId = item..id!;
                                  //       // reportIssueBloc.add(GetAllFacilityDropdown(
                                  //       //     clusterId: item.clusterId ?? 0));
                                  //       //
                                  //       //   // if(state is GetFacilityDropdownSuccess ){
                                  //       //     reportIssueBloc.add(GetAllTasksDropdown(
                                  //       //         clusterId: item.clusterId! ?? 0
                                  //       //     ));
                                  //       //   // }else
                                  //       //    // if( state is  GetTasksDropdownSuccess ){
                                  //       //      reportIssueBloc.add(GetAllJanitorsDropdown(
                                  //       //          clusterId: item.clusterId ?? 0));
                                  //       // }

                                  //     } catch (e) {
                                  //       debugPrint("dropppppp$e");
                                  //     }
                                  //   },
                                  //   validator: (value) =>
                                  //   value == null
                                  //       ?
                                  //       "Please select facility"
                                  //       : null,
                                  // )
                                  : CustomTextField(
                                      padding: const EdgeInsets.all(0),
                                      focusNode: facilityFocusNode,
                                      hintText: DashboardConst.organizationName,
                                      controller: facilityController,
                                      validator: (valu) {
                                        if (valu == null || valu.isEmpty) {
                                          return "Facility Name is required";
                                        }
                                      },
                                    ),

                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                // height: 36.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.2), // Shadow color
                                      spreadRadius: 1, // Spread effect
                                      blurRadius: 10, // Blur effect
                                      offset:
                                          const Offset(0, 5), // Bottom shadow
                                    ),
                                  ],
                                ),
                                child: GooglePlaceAutoCompleteTextField(
                                  focusNode: addressFocusNode,
                                  textEditingController: locationController,
                                  googleAPIKey:
                                      "AIzaSyCkPmUz4UlRdzcKG9gniW9Qfrgzsjhnb_4",
                                  inputDecoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12.0, horizontal: 5),
                                      hintText: DashboardConst.location,
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0),
                                        borderSide: BorderSide.none,
                                      ),
                                      fillColor: AppColors.white,
                                      filled: true,
                                      enabled: facilitydropdownNames.isNotEmpty
                                          ? false
                                          : true
                                      // enabledBorder: InputBorder.none,
                                      ),

                                  validator: (valu, p1) {
                                    setState(() {});
                                    print("val $valu");

                                    // FocusManager.instance.primaryFocus?.unfocus();
                                    if (valu == null || valu.isEmpty) {
                                      return "Location is required";
                                    }
                                  },

                                  // debounceTime: 400,
                                  countries: ["in", "fr"],
                                  isLatLngRequired: true,
                                  getPlaceDetailWithLatLng:
                                      (Prediction prediction) {
                                    print("placeDetails" +
                                        prediction.lat.toString());
                                  },

                                  itemClick: (Prediction prediction) {
                                    loc = prediction;

                                    locationController.text =
                                        prediction.description ?? "";
                                    locationController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset: prediction
                                                    .description?.length ??
                                                0));
                                  },

                                  // seperatedBuilder: const Divider(),
                                  containerHorizontalPadding: 10,
                                  // OPTIONAL// If you want to customize list view item builder
                                  itemBuilder:
                                      (context, index, Prediction prediction) {
                                    // prediction.id!.isNotEmpty ?

                                    //  facilityFocusNode!.unfocus();

                                    return Container(
                                      color: AppColors.white,
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.location_on),
                                          const SizedBox(
                                            width: 7,
                                          ),
                                          Expanded(
                                              child: Text(
                                                  "${prediction.description ?? ""}"))
                                        ],
                                      ),
                                    );
                                  },

                                  isCrossBtnShown:
                                      facilitydropdownNames.isNotEmpty
                                          ? false
                                          : true,

                                  formSubmitCallback: () {
                                    print("dgd");
                                  },

                                  // default 600 ms ,
                                ),
                              ),
                              //  CustomTextField(
                              //  hintText:DashboardConst.location,
                              //  controller:  locationController,
                              // ),
                              const SizedBox(
                                height: 35,
                              ),
                              Text(
                                DashboardConst.typeOfFacility,
                                style: AppTextStyle.font14bold,
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              Container(
                                width: MediaQuery.of(context).size.width,
                                // height: 120,
                                child: GridView.builder(
                                  itemCount: facility.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio:
                                              MediaQuery.of(context)
                                                          .size
                                                          .height <
                                                      640
                                                  ? 0.7
                                                  : 0.9,
                                          //  mainAxisExtent: 120,
                                          crossAxisSpacing: 45,
                                          mainAxisSpacing: 30),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        print("printr $isFromTaskbuddy");
                                        if (facilitydropdownNames.isNotEmpty) {
                                        } else {
                                          setState(() {
                                            selectedIndex = index;
                                            print(
                                                "title ${facility[selectedIndex].title!}");
                                          });

                                          // facilityNames = [];
                                          // items = [];
                                          //  dropController.clearAll();
                                          // dropController.clearAll();
                                          facility[selectedIndex].title ==
                                                  "Others"
                                              ? isSelected = true
                                              : isSelected = false;
                                          print("is slec $isSelected");
                                          dashBoardBloc.add(GetTaskEvent(
                                              category: facility[selectedIndex]
                                                  .title!));
                                        }

                                        // setState((){});
                                      },
                                      child: card(facility[index].image!,
                                          facility[index].title!, index),
                                    );
                                  },
                                ),

                                //   Wrap(
                                //     spacing: 1.0, // Adjust spacing between items
                                //     children:
                                //     List.generate(facility.length, (index) {
                                //       return
                                // GestureDetector(
                                //         onTap: () {
                                //           setState(() {
                                //             selectedIndex = index;
                                //             print("title ${facility[selectedIndex].title!}");

                                //           });
                                //           facility[selectedIndex].title == "Other"   ? isSelected = true

                                //               : isSelected = false;
                                //              print("is slec $isSelected");
                                //           dashBoardBloc.add( GetTaskEvent(
                                //               category:  facility[selectedIndex].title!
                                //           ) );
                                //           setState((){});

                                //         },
                                //         child: Padding(
                                //           padding: const EdgeInsets.all(8.0),
                                //           child: card(facility[index].image!, facility[index].title!, index),
                                //         ),
                                //       );
                                //     }),
                                // ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              errorMessage.isNotEmpty
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        errorMessage,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                    )
                                  : const SizedBox(),
                              const SizedBox(
                                height: 35,
                              ),
                              isSelected
                                  ? CustomTextField(
                                      padding: const EdgeInsets.all(0),
                                      hintText: DashboardConst
                                          .ifOthersMentionFacility,
                                        hintStyle:   TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w700
                                        ),

                                          
                                      controller: typeController,
                                      validator: (valu) {
                                        if (valu == null || valu.isEmpty) {
                                          return "Please mention other type";
                                        }
                                      },
                                    )
                                  : const SizedBox(),

                              // const Spacer(),
                               const SizedBox(
                                height: 40,
                               ),

                              GestureDetector(
                                  onTap: () {
                                    if (selectedIndex == -1) {
                                      setState(() {
                                        errorMessage =
                                            'Please select a facility';
                                      });
                                    } else {
                                      setState(() {
                                        errorMessage = '';
                                      });
                                      // Proceed with the next steps
                                      print(
                                          "Selected: ${facility[selectedIndex].title!}");
                                    }

                                    print("prediction $loc ");
                                    if (facilityKey.currentState!.validate() &&
                                        facilitydropdownNames.isNotEmpty &&
                                        selectedIndex != -1) {
                                      selectedbuddy != null
                                          ? taskExistingBottomSheet(
                                              selectedbuddy!, selectedFacility)
                                          : taskBottomSheet();
                                    } else if (facilityKey.currentState!
                                            .validate() &&
                                        loc != null &&
                                        selectedIndex != -1) {
                                      taskBottomSheet();
                                    }
                                  },
                                  child: const Custombutton(
                                      text: "Next", width: double.infinity)),

                              const SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
      },
    ).then((v) {
      facilitydropdownNames.clear();
      loc = null;
    });
  }

  adminBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setStatee) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(80.0),
                topRight: Radius.circular(80.0),
              ),
            ),
            height: 680,
            // height: 560,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Semantics(
                  label: "Admin Selection",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Semantics(
                          label: "Choose Admin",
                          child:
                              header("Choose ", "Admin", ClientImages.setting)),

                      const SizedBox(
                        height: 70,
                      ),

                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: admin.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                selectedAdmin = index;

                                if (admin[index].title ==
                                    "Monitor \nYourself") {
                                  isAdminSelected = true;
                                  isSelfAssign = true;

                                  nameController.text =
                                      globalStorage.getSupervisorName();
                                  mobileController.text =
                                      globalStorage.getClientMobileNo();
                                  //  janitorBottomSheet();
                                } else {
                                  isSelfAssign = false;
                                  nameController.clear();
                                  mobileController.clear();

                                  isAdminSelected = false;
                                }
                                setStatee(() {});
                              },
                              child: adminCard(admin[index].image!,
                                  admin[index].title!, index));
                        },
                      ),
                      erroradminMessage.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                erroradminMessage,
                                style: const TextStyle(color: Colors.red),
                              ),
                            )
                          : const SizedBox(),

                      // const SizedBox(height: 680/3.3 ),

                      // const Spacer(),
                      const SizedBox(
                        height: 30,
                      ),

                      Semantics(
                        label: "Next Button",
                        child: GestureDetector(
                            key: const ValueKey("nextButton"),
                            onTap: () {
                              print("slecredsas $selectedAdmin ");
                              if (selectedAdmin == -1) {
                                setStatee(() {
                                  erroradminMessage =
                                      'Please select a supervisor option';
                                });
                              } else {
                                setStatee(() {
                                  erroradminMessage = '';
                                });
                                // Proceed with the next steps
                                // print("Selected: ${facility[selectedIndex].title!}");
                              }

                              if (selectedAdmin != -1) {
                                superVisorBottomSheet();
                              }
                            },
                            child: const Custombutton(
                                key: ValueKey("adminNextButton"),
                                text: "Next",
                                width: double.infinity)),
                      ),

                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    ).then(
      (value) {
        isAdminSelected = false;
        isSelfAssign = false;
        erroradminMessage = '';
        selectedAdmin = -1;
      },
    );
  }

  superVisorBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(80.0),
                topRight: Radius.circular(80.0),
              ),
            ),
            height: MediaQuery.of(context).size.height / 1.4,
            child: Form(
              key: addSuperVisorKey,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      header("Assign", DashboardConst.assignsupervisor,
                          ClientImages.avatar),
                      //  Center(
                      //    child: Text(DashboardConst.assignsupervisor,
                      //      style: AppTextStyle.font18bold,
                      //    ),
                      //  ),
                      // Text(estimatedTime.toString(),
                      //   style: AppTextStyle.font18bold,
                      // ),
                      const SizedBox(
                        height: 70,
                      ),
                      CustomTextField(
                          padding: const EdgeInsets.all(0),
                          // readOnly: isAdminSelected,
                          controller: nameController,
                          hintText: DashboardConst.fullName,
                          keyboardType: TextInputType.text,
                          //  maxLength: 10,

                          validator: validateName
                          // prefixIcon: Icons.phone,
                          ),
                      const SizedBox(height: 40),

                      CustomTextField(
                          padding: const EdgeInsets.all(0),
                          readOnly: isAdminSelected,
                          controller: mobileController,
                          hintText: DashboardConst.number,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          maxLength: 10,
                          validator: validateMobile
                          // prefixIcon: Icons.phone,
                          ),

                      const Spacer(),

                      //  const SizedBox(height: 290),

                      GestureDetector(
                          onTap: () {
                            if (addSuperVisorKey.currentState!.validate()) {
                              janitorBottomSheet();
                            }
                          },
                          child: const Custombutton(
                              text: "Next", width: double.infinity)),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    ).then((v) {
      mobileController.clear();
      nameController.clear();
    });
  }

  int? estimatedTime;
  int? len;
  List<int?> taksIds = [];
  bool isNext = false;
  String? use12hour = "00:00";
  bool isTaskSelected = false;
  bool isTimePassed = false;
  List<DropdownItem<TaskDropdownModel>> items = [];
  List<TaskDropdownModel> selectedItems = [];
  final dropController = MultiSelectController<TaskDropdownModel>();

  taskBottomSheet() {
    dashController.taskTimeModel.clear();
    //     for (var element in facilityNames) {
    // items.add(DropdownItem(label: element.facilityName!, value:element! ));

//       dropController.setItems(items!
// .map((item) => TaskDropdownModel(
// facilityName: item.toString(),
// requiredTime: item.,
// // selected: widget.selectedItem!.contains(item)))
// .toList());
// // }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        Color getColor(Set<WidgetState> states) {
          const Set<WidgetState> interactiveStates = <WidgetState>{
            WidgetState.pressed,
            WidgetState.hovered,
            WidgetState.focused,
          };
          if (states.any(interactiveStates.contains)) {
            return Colors.blue;
          }
          return Colors.yellow;
        }

        return StatefulBuilder(builder: (context, StateSetter setState) {
          return DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.8,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return Form(
                  key: _formKey,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(80.0),
                        topRight: Radius.circular(80.0),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height / 1.15,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ListView(
                          controller: scrollController,
                          //  mainAxisSize: MainAxisSize.min,
                          //  crossAxisAlignment: CrossAxisAlignment.start,
                          //  mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            header(DashboardConst.assignTasks, "Tasks",
                                ClientImages.checklist),
                            //      const SizedBox(
                            //       height: 9,
                            //      ),
                            //      Center(
                            //        child: CustomImageProvider(
                            //         image: ClientImages.line,
                            //         width: 70,
                            //        ),
                            //      ),
                            //  const SizedBox(
                            //    height: 20,
                            //  ),
                            //  Center(
                            //    child: Text(items.length.toString(),
                            //      style: AppTextStyle.font18bold,
                            //    ),
                            //  ),

                            const SizedBox(
                              height: 40,
                            ),

                            Container(
                              // height: 55,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withValues(alpha: 0.2), // Shadow color
                                    spreadRadius:
                                        1, // How wide the shadow should spread
                                    blurRadius:
                                        10, // The blur effect of the shadow
                                    offset: const Offset(0,
                                        5), // Shadow offset, with y-offset for bottom shadow
                                  ),
                                ],
                                // color: enabled ? color ??  AppColors.backgroundColor : AppColors.disabledButtonColor,
                                borderRadius: BorderRadius.circular(7),
                              ),

                              child: MultiDropdown<TaskDropdownModel>(
                                // key: UniqueKey(),
                                items: items,
                                controller: dropController,
                                enabled: true,

                                selectedItemBuilder: (item) {
                                  return Text(
                                    item.label,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff8F8F8F)),
                                  );
                                },
                                // searchEnabled: true,
                                chipDecoration: const ChipDecoration(
                                  backgroundColor: Colors.yellow,
                                  wrap: true,
                                  runSpacing: 2,
                                  spacing: 10,
                                ),
                                fieldDecoration: const FieldDecoration(
                                  borderRadius: 7,
                                  // suffixIcon: Ic,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),

                                  hintText: DashboardConst.selectCleaningTasks,
                                  hintStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff8F8F8F)),
                                  //  ),
                                  // prefixIcon: const Icon(CupertinoIcons.flag),
                                  showClearIcon: false,
                                  border: InputBorder.none,
                                  suffixIcon: Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: Color(0xff8F8F8F),
                                    size: 38,
                                  ),
                                  // OutlineInputBorder(
                                  //   borderRadius: BorderRadius.circular(12),
                                  //   // borderSide: const BorderSide(color: Colors.grey),
                                  // ),
                                  // focusedBorder: OutlineInputBorder(
                                  //   borderRadius: BorderRadius.circular(12),

                                  //   // borderSide: const BorderSide(
                                  //   //   color: Colors.black87,
                                  //   // ),
                                  // ),
                                ),

                                dropdownDecoration: DropdownDecoration(
                                  footer: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                    child: GestureDetector(
                                        onTap: () {
                                          dropController.closeDropdown();
                                          //  Navigator.of(context).pop();
                                        },
                                        child: const Custombutton(
                                            text: "Done",
                                            width: double.infinity)),
                                  ),
                                  borderRadius: BorderRadius.circular(7),
                                  marginTop: 2,
                                  maxHeight: MediaQuery.of(context)
                                              .size
                                              .height <
                                          640
                                      ? 250
                                      : MediaQuery.of(context).size.height < 733
                                          ? 350
                                          : 450,

                                  // header: Padding(
                                  //   padding: EdgeInsets.all(8),
                                  //   child: Text(
                                  //     'Select countries from the list',
                                  //     textAlign: TextAlign.start,
                                  //     style: TextStyle(
                                  //       fontSize: 16,
                                  //       fontWeight: FontWeight.bold,
                                  //     ),
                                  //   ),
                                  // ),
                                ),

                                // dropdownItemDecoration: DropdownItemDecoration(

                                //   selectedIcon:
                                //       const Icon(Icons.check_box, color: Colors.green),
                                //   disabledIcon:
                                //       Icon(Icons.lock, color: Colors.grey.shade300),
                                // ),
                                // validator: (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return 'Please select a country';
                                //   }
                                //   return null;
                                // },
                                itemBuilder: (item, index, onTap) {
                                  final isSelected = dropController
                                      .selectedItems
                                      .contains(item);

                                  return ListTile(
                                    contentPadding:
                                        const EdgeInsets.only(right: 10),
                                    // minVerticalPadding: 0,
                                    minLeadingWidth: 0,
                                    horizontalTitleGap: 10,
                                    minTileHeight: 25,
                                    leading: Checkbox(
                                      shape: RoundedRectangleBorder(
                                        // side: const BorderSide(
                                        //     color: Colors.black, // border color
                                        //     width: 0.3,           // 👈 border thickness
                                        //   ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      activeColor: Colors.yellow,

                                      checkColor: Colors.black,
                                      value: isSelected,
                                      onChanged: (_) =>
                                          onTap(), // manually toggle
                                    ),
                                    title: Text(
                                      item.label,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height <
                                                  640
                                              ? 12
                                              : 15,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xff8F8F8F)),
                                    ),
                                    trailing: Text(
                                      "+ ${item.value.requiredTime.toString()} min",
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height <
                                                  640
                                              ? 12
                                              : 15,
                                          color: const Color(0xff8BDFFB),
                                          fontWeight: FontWeight.w700),
                                    ),
                                  );
                                },

                                onSelectionChange: (selectedItems) {
                                  List<int?> listTime = [];

                                  len = selectedItems.length;

                                  listTime = selectedItems
                                      .map((e) => e.requiredTime)
                                      .toList();

                                  print("total time $estimatedTime");
                                  if (selectedItems.isEmpty) {
                                    estimatedTime = null;
                                  } else if (selectedItems.isNotEmpty) {
                                    estimatedTime =
                                        listTime.reduce((a, b) => a! + b!);
                                    taksIds =
                                        selectedItems.map((e) => e.id).toList();
                                  } else if (selectedItems.isNotEmpty &&
                                      len! < selectedItems.length) {
                                    listTime = selectedItems
                                        .map((e) => e.requiredTime)
                                        .toList();
                                    estimatedTime =
                                        listTime.reduce((a, b) => a! - b!);
                                  }

                                  print("estimagte $estimatedTime ");

                                  // if(i.isEmpty ){
                                  //    estimatedTime = 0;
                                  // }
                                  setState(() {});

                                  debugPrint(
                                      "OnSelectionChange: $selectedItems");
                                },
                              ),
                            ),

                            const SizedBox(
                              height: 13,
                            ),

                            //  Padding(
                            //    padding: EdgeInsets.symmetric(
                            //      horizontal: 20.w,
                            //      vertical: 10.h,
                            //    ),
                            //    child: Container(
                            //      decoration: BoxDecoration(
                            //        color: Colors.white,

                            //        borderRadius: BorderRadius.circular(25.r),
                            //        boxShadow: [
                            //          BoxShadow(
                            //            color: Colors.black.withValues(alpha: 0.2), // Shadow color
                            //            spreadRadius: 1, // How wide the shadow should spread
                            //            blurRadius: 10, // The blur effect of the shadow
                            //            offset: const Offset(0,
                            //                5), // Shadow offset, with y-offset for bottom shadow
                            //          ),
                            //        ],
                            //      ),
                            //      child: MultiselectDropDownDialog(
                            //        widgetKey: _facilityKey,
                            //        hint: DashboardConst.selectCleaningTasks,
                            //        // key: Key(
                            //        //     '${_editProductModel.paymentMethodId?.firstOrNull?.label}T5'),
                            //        // selected: _editProductModel.paymentMethodId,
                            //        items: facilityNames,
                            //        itemAsString: (TaskDropdownModel item) {
                            //          return
                            //            "${item.facilityName}   ${item.requiredTime} min" ;  },
                            //        validator: (value) {
                            //           print("slecrte $value");
                            //          value == []
                            //            ? "Please select tasks"

                            //            : null;
                            //        },

                            //        onSaved: (List<TaskDropdownModel> i) {
                            //          // selectedIds.add(i[1].taskId!);
                            //          // selectedIds =
                            //          //     i.map((e) => e.taskId.toString()).toList();
                            //        },
                            //        onChanged: (List<TaskDropdownModel> i) {
                            //           // print(" car $i ");
                            //          List<int?> listTime = [];

                            //          len =  i.length;

                            //          listTime =  i.map( (e) =>  e.requiredTime).toList();

                            //           print("total time $estimatedTime");
                            //            if(i.isEmpty){
                            //              estimatedTime = null;
                            //            }else
                            //             if( i.isNotEmpty){
                            //               estimatedTime = listTime.reduce((a, b) => a! + b!);
                            //               taksIds =  i.map( (e) => e.id ).toList();
                            //             }
                            //            else
                            //          if( i.isNotEmpty && len! < i.length    ){
                            //            listTime =  i.map( (e) =>  e.requiredTime).toList();
                            //            estimatedTime = listTime.reduce((a, b) => a! - b!);
                            //          }

                            //           print("estimagte $estimatedTime ");

                            //          // if(i.isEmpty ){
                            //          //    estimatedTime = 0;
                            //          // }
                            //           setState( (){});

                            //          // selectedIds =
                            //          //     i.map((e) => e.taskId.toString()).toList();
                            //          // debugPrint(selectedIds.toString());
                            //        },
                            //        // label: 'Template Name',
                            //      ),
                            //    ),
                            //  ),

                            estimatedTime == null && isTaskSelected
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    child: Column(
                                      children: [
                                        // const SizedBox(
                                        //   height: 10,
                                        // ),
                                        Text(
                                          "Please select Tasks",
                                          style: AppTextStyle.font12
                                              .copyWith(color: AppColors.red),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(
                                    // height: ,
                                    ),

                            const SizedBox(
                              height: 10,
                            ),

                            Center(
                              child: Text(
                                DashboardConst.estimatedTaskCompletionTime,
                                style: AppTextStyle.font20
                                    .copyWith(color: const Color(0xff8F8F8F)),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: estimatedTime == null
                                  ? Text(
                                      '00:00',
                                      style: AppTextStyle.font24bold,
                                    )
                                  : Text(
                                      "$estimatedTime min",
                                      style: AppTextStyle.font24bold,
                                    ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DashboardConst.scheduleShift,
                                  style: AppTextStyle.font14w7
                                      .copyWith(color: const Color(0xff828282)),
                                ),
                                InkWell(
                                  onTap: () async {
                                    // if(  estimatedTime ==  null ) return;

                                    shiftTime = await showTimePicker(
                                      helpText: "Select Time",
                                      // barrierColor : AppColors.white,
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            // inputDecorationTheme: InputDecorationTheme(
                                            //  activeIndicatorBorder:
                                            // ),

                                            timePickerTheme:
                                                TimePickerThemeData(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              80),
                                                    ),
                                                    helpTextStyle: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                    hourMinuteTextColor:
                                                        Colors.black,
                                                    hourMinuteTextStyle:
                                                        const TextStyle(
                                                            fontSize: 48,
                                                            fontWeight: FontWeight
                                                                .w700),
                                                    dialHandColor:
                                                        const Color(0xffFFEB00),
                                                    dialTextColor: Colors.black,
                                                    dayPeriodColor:
                                                        const Color(0xffFFEB00),
                                                    dialTextStyle:
                                                        const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                    hourMinuteColor:
                                                        MaterialStateColor.resolveWith(
                                                            (Set<MaterialState>
                                                                states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .selected)) {
                                                        return const Color(
                                                            0xff8BDFFB);
                                                      }
                                                      return Colors.white;
                                                    }),
                                                    // timeSelectorSeparatorColor: ,
                                                    // timeSelectorSeparatorColor:

                                                    hourMinuteShape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  18.0)),
                                                      side: BorderSide.none,
                                                    ),
                                                    dayPeriodShape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  18.0)),
                                                      side: BorderSide(),
                                                    ),
                                                    // dayPeriodBorderSide: BorderSide(
                                                    //   style: BorderStyle.
                                                    // ),
                                                    dialBackgroundColor:
                                                        const Color(0xff8BDFFB),
                                                    confirmButtonStyle:
                                                        TextButton.styleFrom(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 18,
                                                              color: AppColors
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                    cancelButtonStyle:
                                                        TextButton.styleFrom(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 18,
                                                              color: AppColors
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),

                                                    //            MaterialStateProperty.all(

                                                    //   const TextStyle(fontSize: 18,
                                                    //    color: AppColors.black,
                                                    //    fontWeight: FontWeight.bold),
                                                    // ),),
                                                    // backgroundColor: MaterialStateProperty.all<Color>(Colors.brown.shade300)),

                                                    backgroundColor:
                                                        const Color.fromRGBO(
                                                            255,
                                                            255,
                                                            255,
                                                            0.8) // 👈 Your custom background
                                                    // hourMinuteTextColor: Colors.white,
                                                    // dialHandColor: Colors.red,
                                                    // entryModeIconColor: Colors.white,
                                                    ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                      // );

                                      // builder: (BuildContext context, Widget? child) {
                                      //   // return Directionality(
                                      //   //   // textDirection: TextDirection.rtl,
                                      //   //   child: child!,
                                      //   // );
                                      // },
                                    );
                                    DateTime date = DateTime.now();
                                    // date.add( Duration( hours: shiftTime!.hour, minutes: shiftTime!.minute  ) );
                                    // print("duration ${}");

                                    DateTime dateTime = DateTime(
                                        date.year,
                                        date.month,
                                        date.day,
                                        shiftTime!.hour,
                                        shiftTime!.minute);
                                    DateTime newDateTime =
                                        dateTime.add(const Duration(hours: 12));
                                    TimeOfDay newShiftTime =
                                        TimeOfDay.fromDateTime(newDateTime);
                                    final localizations =
                                        MaterialLocalizations.of(context);
                                    use12hour = localizations.formatTimeOfDay(
                                        newShiftTime,
                                        alwaysUse24HourFormat: false);
                                    // DateTime  hour =   date.add( Duration(hours: 12, minutes: 0 ));
                                    print("timen $newDateTime ");
                                    print("hour $use12hour ");
                                    isTimePassed =
                                        isShiftTimePassed(shiftTime!);

                                    // print("isTimePassed $isTimePassed");

                                    setState(() {});
                                    //                              isTimePassed ?
                                    //                               showDialog(context: context, builder:
                                    //                                (context) {
                                    //                                   return
                                    //                                          AlertDialog(
                                    //   shape: RoundedRectangleBorder(
                                    //   borderRadius: BorderRadius.circular(60),
                                    //  ),
                                    //                             backgroundColor: AppColors.white,
                                    //                             content:
                                    //                             SingleChildScrollView(
                                    //                               child: ListBody(
                                    //                                 children: <Widget>[

                                    //                                   SizedBox(
                                    //                                     height: 10.h,
                                    //                                   ),
                                    //                                   Text(
                                    //                                     textAlign: TextAlign.center,
                                    //                                     "Tasks scheduled before the current time will start tracking from the next day, as today's time may have already passed at the time of assignment"!,
                                    //                                    style: AppTextStyle.font14bold,
                                    //                                   ),
                                    //                                   SizedBox(
                                    //                                     height: 20.h,
                                    //                                   ),
                                    //                                   GestureDetector(
                                    //                                     onTap: () {
                                    //                                       Navigator.of(context).pop();
                                    //                                       // showModalBottomSheet(context: context, builder:
                                    //                                       //  (context) {
                                    //                                       //     return SubcriptionScreen();
                                    //                                       //  },
                                    //                                       // );
                                    //                                     },
                                    //                                     child:  const Custombutton(
                                    //                                       width: 300,
                                    //                                       text: "Go Back",
                                    //                                     ),
                                    //                                   ),
                                    //                                       SizedBox(
                                    //                                     height: 20.h,
                                    //                                   ),
                                    //                                 ],
                                    //                               ),
                                    //                             ),
                                    //                           );
                                    //  },
                                    // ) : null;
                                  },
                                  child: Container(
                                    width: 120,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(8),
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
                                      // ),
                                    ),
                                    child: Center(
                                        child: shiftTime != null
                                            ? Text(
                                                shiftTime!.format(context),
                                                style: AppTextStyle.font14w7
                                                    .copyWith(
                                                        color: const Color(
                                                            0xff828282)),
                                              )
                                            : Text(
                                                "Start Time *",
                                                style: AppTextStyle.font14w7
                                                    .copyWith(
                                                        color: const Color(
                                                            0xff828282)),
                                              )),
                                  ),
                                )
                              ],
                            ),

                            shiftTime == null && isNext || isTaskSelected
                                ? Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Please select shift Timing",
                                        style: AppTextStyle.font12
                                            .copyWith(color: AppColors.red),
                                      ),
                                    ],
                                  )
                                : const SizedBox(
                                    // height: ,
                                    ),

                            const SizedBox(
                              height: 20,
                            ),

                            Container(
                              // height:
                              // 70 ,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withValues(alpha: 0.2), // Shadow color
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 13),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // const SizedBox(
                                        //   height: 10,
                                        // ),
                                        Text(
                                          DashboardConst.scheduleTask,
                                          style: AppTextStyle.font14w7.copyWith(
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .height <
                                                      640
                                                  ? 12
                                                  : 15),
                                        ),

                                        GestureDetector(
                                            onTap: () {
                                              Datum? buddy;
                                              print("is$isTaskSelected");
                                              print("ese $estimatedTime");
                                              isTaskSelected = true;
                                              // isNext = true;
                                              setState(() {});
                                              //  if(  _formKey.currentState!.validate()   ){
                                              estimatedTime != null &&
                                                      shiftTime != null
                                                  ? _showMyDialog(
                                                      false,
                                                    ).then(
                                                      (value) {
                                                        isTaskSelected = false;
                                                      },
                                                    )
                                                  : null;

                                              //  }

                                              //  ;

                                              // janitorBottomSheet()
                                            },
                                            child: Custombutton(
                                                text: DashboardConst.addTimings,
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .height <
                                                        640
                                                    ? 120
                                                    : 140))

                                        //  :
                                      ],
                                    ),
                                    dashController.taskTimeModel.isEmpty &&
                                            isNext
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Please add Timing for tasks",
                                                style: AppTextStyle.font12
                                                    .copyWith(
                                                        color: AppColors.red),
                                              ),
                                            ],
                                          )
                                        : const SizedBox(
                                            // height: ,
                                            ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Obx(
                                      () => dashController.taskTimeModel.isEmpty
                                          ? const SizedBox()
                                          : const Divider(
                                              color: Color(0xff828282),
                                              thickness: 1,
                                            ),
                                    ),
                                    Obx(
                                      () => SizedBox(
                                        height:
                                            dashController.taskTimeModel.isEmpty
                                                ? 0
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    5,
                                        child: ListView.builder(
                                          physics:
                                              const ClampingScrollPhysics(),
                                          //  physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: dashController
                                              .taskTimeModel.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 2),
                                              minLeadingWidth: 0,
                                              trailing: GestureDetector(
                                                onTap: () {
                                                  // showDeleteDialog(context);
                                                  // void showDeleteDialog(BuildContext context) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(26),
                                                      ),
                                                      backgroundColor:
                                                          AppColors.white,
                                                      // title: const Text("Logout"),
                                                      content: SizedBox(
                                                        height: 175,
                                                        child: Column(
                                                          children: [
                                                            const SizedBox(
                                                              height: 30,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          30),
                                                              child: Center(
                                                                child: Text(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  "Are you sure you want to delete the current time?",
                                                                  style: AppTextStyle.font15.copyWith(
                                                                      fontSize:
                                                                          15,
                                                                      color: AppColors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Custombutton(
                                                                        color: AppColors
                                                                            .white,
                                                                        text:
                                                                            "No",
                                                                        width: 100
                                                                            .w)),
                                                                GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      dashController
                                                                          .taskTimeModel
                                                                          .removeAt(
                                                                              index);
                                                                   dashController.taskTimes.removeAt(index);
                                                                    
                                                                    //  print("task time model ${dashController.taskTimes}");

                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                          
                                                                    },
                                                                    child: Custombutton(
                                                                        text:
                                                                            "Yes",
                                                                        width: 100
                                                                            .w))
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 30,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // actionsAlignment: MainAxisAlignment.spaceEvenly,
                                                      // actions: [

                                                      // ],
                                                    ),
                                                  );
                                                  // }
                                                  //  dashController.taskTimeModel.removeAt(index);
                                                  //  dashController.taskEndTime.removeAt(index);
                                                  // dashController.taskTimes.removeAt(index);
                                                  //  setState((){});
                                                },

                                                child: CustomImageProvider(
                                                    image: ClientImages.delete,
                                                    width: 25,
                                                    height: 25),
                                                //  const Icon(  Icons.delete,),
                                                //  color: AppColors.red,
                                              ),
                                              title: Column(
                                                children: [
                                                  //  Row(
                                                  //             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //             children: [
                                                  //               Text( dashController.taskTimeModel[index].facilityName,
                                                  //                 style: AppTextStyle.font14bold,
                                                  //               ),
                                                  //                    Text( " - ",
                                                  //                 style: AppTextStyle.font14bold,
                                                  //               ),
                                                  //               // taskEndTime
                                                  //               Text( dashController.taskTimeModel[index].facilityType,
                                                  //                 style: AppTextStyle.font14bold,
                                                  //               ),
                                                  //             ],
                                                  //           ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        dashController
                                                            .taskTimeModel[
                                                                index]
                                                            .startTime
                                                            .format(context),
                                                        style: AppTextStyle
                                                            .font14bold,
                                                      ),
                                                      // taskEndTime
                                                      Text(
                                                        dashController
                                                            .taskTimeModel[
                                                                index]
                                                            .endTime
                                                            .format(context),
                                                        style: AppTextStyle
                                                            .font14bold,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            Obx(
                              () => SizedBox(
                                height: dashController.taskTimeModel.isEmpty
                                    ? 80
                                    : 20,
                              ),
                            ),
                            // const Spacer(),
                            Center(
                              child: Text(
                                "The shift shall start at ${shiftTime == null ? '00:00' : shiftTime!.format(context)}",
                                style: AppTextStyle.font15.copyWith(
                                    fontSize: 15,
                                    color: const Color(0xff828282),
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Center(
                                child: Text(
                              textAlign: TextAlign.center,
                              "Shift shall complete at ${use12hour}",
                              style: AppTextStyle.font15.copyWith(
                                  fontSize: 15,
                                  color: const Color(0xff828282),
                                  fontWeight: FontWeight.w700),
                            )),

                            //  const SizedBox(height: 10),
                            // GestureDetector(
                            //   onTap: (){},
                            //   child: Center(child: Text(
                            //       style: AppTextStyle.font18bold.copyWith(
                            //         color: AppColors.backgroundColor
                            //       ),
                            //       DashboardConst.addAnotherFacility,
                            //
                            //   )
                            //   ),
                            // ),

                            //  const Spacer(),
                            Obx(
                              () => SizedBox(
                                height: dashController.taskTimeModel.isEmpty
                                    ? 60
                                    : 15,
                              ),
                            ),
                            // const Spa

                            GestureDetector(
                                onTap: () {
                                  isNext = true;
                                  setState(() {});
                                  print(  "curtne ${_formKey.currentState!.validate()}");
                                  if (shiftTime != null &&
                                      dashController.taskTimeModel.isNotEmpty &&
                                      estimatedTime != null) {
                                    // && shiftTime != null && taskStartTime.isNotEmpty && estimatedTime != null
                                    if (isClientSupervisor) {
                                      janitorBottomSheet();
                                    } else {
                                      adminBottomSheet();
                                    }
                                  }

                                  // janitorBottomSheet()
                                  ;
                                },
                                child:
                                    Custombutton(text: "Next", width: 328.w)),

                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
      },
    ).then(
      (value) {
        isTaskSelected = false;
        dashController.taskStartTime.clear();
        dashController.taskEndTime.clear();
        dashController.taskTimes.clear();
        items = [];
        loadFacilities();
        //  dropController.clearAll();
        //  facilityList.clear();
        //  facilitydropdownNames.clear();
        //  dropController.clearAll();
        use12hour = "00:00";
        //  estimatedTime = null;
        shiftTime = null;
        isNext = false;
        setState(() {});
      },
    );
  }

  // List<TimeOfDay> taskStartTime = [];
  // List<TimeOfDay> taskEndTime = [];
  // List<Map<String, String>> taskTimes = [];

  Future<void> _showMyDialog(bool isFromExiting, {Datum? janitor}) async {
    print("shift $shiftTime ");
    print("shift $use12hour ");
    print("estima $estimatedTime ");

    showDialog<Map<String, List<TimeOfDay>>>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AddTimeDailog(
          estimatedTime: estimatedTime!,
          startTime: shiftTime,
          endTime: use12hour,
          isFromExisting: isFromExiting,
          janitorId: janitor == null ? null : janitor.id,
          facalityName: facilityController.text,
          facilityType: facility[selectedIndex].title,

          // taskStartTime: taskStartTime,
          // taskEndTime: taskEndTime,
          // taskTimes: taskTimes,
        );
      },
    );
    // .then((value) {
    //      // taskStartTime = value!["taskStartTime"]! ;
    //      //  taskEndTime = value["taskEndTime"]! ;
    //      // setState(() {
    //
    //
    //      // });
    //       print(" valeiu $taskTimes");
    //   // return;
    //    return  value;
    // }, );
  }

  janitorBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return DraggableScrollableSheet(
              initialChildSize: 0.7,
              maxChildSize: 0.8,
              builder: (context, controller) {
                return Form(
                  key: addJanitorKey,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(80.0),
                        topRight: Radius.circular(80.0),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height / 1.38,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ListView(
                          controller: controller,
                          //  crossAxisAlignment: CrossAxisAlignment.start,
                          //  mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            header("Assign", "Task Buddy", ClientImages.avatar),

                            const SizedBox(
                              height: 70,
                            ),
                            CustomTextField(
                                padding: const EdgeInsets.all(0),
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (p0) {},
                                controller: janNameController,
                                hintText: DashboardConst.taskBuddyName,
                                keyboardType: TextInputType.text,
                                //  maxLength: 10,

                                validator: validateName
                                //  (value) {
                                //    if (value == null || value.isEmpty || value.length < 10) {
                                //      return "Enter a valid 10-digit number";
                                //    }
                                //    return null;
                                //  },
                                // prefixIcon: Icons.phone,
                                ),
                            const SizedBox(height: 40),

                            CustomTextField(
                              padding: const EdgeInsets.all(0),
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (p0) {},
                              controller: janMobileController,
                              hintText: DashboardConst.number,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                              maxLength: 10,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 10) {
                                  return "Enter a valid 10-digit number";
                                }
                                return null;
                              },
                              // prefixIcon: Icons.phone,
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            Text(
                              DashboardConst.gender,
                              style: AppTextStyle.font14bold
                                  .copyWith(color: const Color(0xff8F8F8F)),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              // flex: 2,
                              width: MediaQuery.of(context).size.width,
                              height: 170,
                              child: Center(
                                child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(width: 45),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  shrinkWrap: true,
                                  itemCount: genderList.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedGender = index;
                                          });
                                          janitorGender =
                                              genderList[selectedGender].title;
                                          print("gender $janitorGender");
                                        },
                                        child: genderCard(
                                            genderList[index].image!,
                                            genderList[index].title!,
                                            index));
                                  },
                                ),
                              ),
                            ),

                            janitorGender!.isEmpty && isGender
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 10),
                                    child: Text(
                                      "Please select gender",
                                      style: AppTextStyle.font12
                                          .copyWith(color: AppColors.red),
                                    ),
                                  )
                                : const SizedBox(),

                            //  const SizedBox(height: 680/3.8),
                            // const Spacer(),
                             SizedBox(height: 30,),

                            GestureDetector(
                                onTap: () {
                                  isGender = true;
                                  setState(() {});

                                  if (addJanitorKey.currentState!.validate() &&
                                      janitorGender!.isNotEmpty &&
                                      isGender) {
                                    // print("task timing id ${taskTimes} ");

                                    String city = globalStorage.getCity();
                                    String address = globalStorage.getAddress();
                                    String pincode = globalStorage.getPincode();
                                    String clientId =
                                        globalStorage.getClientId();
                                    // print("facility $facilitydropdownNames");

                                    if (facilitydropdownNames.isNotEmpty) {
                                      print(
                                          "facility ${mobileController.text}");
                                      print("facility ${nameController.text}");
                                      print("facility $clientId");
                                      print("facility ${selectedFacility!}");

                                      dashBoardBloc.add(AddUserEvent(
                                        mobile: mobileController.text,
                                        name: nameController.text,
                                        roleId: "2",
                                        clientId: clientId,
                                        // gender: janitorGender,
                                        clusterId: [
                                          selectedFacility!.clusterId!
                                        ],
                                        isSelfAssign: isSelfAssign,
                                      ));
                                    } else {
                                    
                                      print(
                                          "janitorEstimatedTime ${estimatedTime}");

                                      dashBoardBloc.add(ClientSetUpEvent(
                                          clientId: clientId,
                                          orgName: facilityController.text,
                                          locality: locationController.text,
                                          pincode: pincode,
                                          address: address,
                                          city: city,
                                          facilityType:
                                              facility[selectedIndex].title,
                                          mobile:
                                              globalStorage.getClientMobileNo()
                                          //  unitNo: "sd"
                                          ));
                                    }

                                    // dashBoardBloc.add(
                                    //     AddUserEvent(
                                    //      mobile: mobileController.text,
                                    //      name: nameController.text,
                                    //      roleId: "2",
                                    //      clientId: decodedToken!["id"].toString(),
                                    // )  );
                                    // dashBoardBloc.add(
                                    //     AddUserEvent(
                                    //       mobile: mobileController.text,
                                    //       name: nameController.text,
                                    //       gender: janitorGender,
                                    //       roleId: "1",
                                    //       clientId: decodedToken!["id"].toString(),
                                    //     ));
                                    // dashBoardBloc.add(
                                    //     AssignTaskEvent(clientId: decodedToken!["id"],
                                    //         shiftTime: shiftTime.toString(),
                                    //         taskIds: taksIds,
                                    //         estimatedTime: estimatedTime.toString(),
                                    //         taskTimes: taskTimes
                                    //     ));

                                    // taskBottomSheet();
                                  }
                                },
                                child: const Custombutton(
                                    text: "Submit", width: double.infinity)),

                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
      },
    ).then(
      (value) {
        isGender = false;
        janitorGender = "";
      },
    );
  }

  String? selectedJanitor;

  Datum? selectedbuddy;
  bool isBuddySelected = false;

  showTaskBuddyDailog(TaskModel taskModel) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColors.white,

            //  title:
            //  ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Center(
                    child: Text(
                      "Choose an Existing Task Buddy",
                      style: AppTextStyle.font20bold,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    height: 300,
                    width: 300,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: taskModel!.results!.data!.length,
                      itemBuilder: (context, index) {
                        final janitor = taskModel!.results!.data![index].name;
                        return RadioListTile<String>(
                          contentPadding: const EdgeInsets.all(0),
                          title: Text(janitor!),
                          value: "$janitor + $index ",
                          groupValue: selectedJanitor,
                          onChanged: (value) {
                            setState(() {
                              selectedJanitor = value;
                              print(
                                  "selected ${taskModel.results!.data![index]} ");

                              selectedbuddy = taskModel.results!.data![index];
                            });
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  selectedbuddy == null && isBuddySelected == true
                      ? const Text(
                          "Please select task buddy",
                          style: TextStyle(
                              fontSize: 15, color: AppColors.redTextColor),
                        )
                      : const SizedBox(),
                  SizedBox(
                    height: 20.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigator.of(context).push( MaterialPageRoute(builder: (context) {
                      //    return ClientDashboard();
                      // }, ) );
                      isBuddySelected = true;
                      setState(() {});

                      // taskExistingBottomSheet(selectedbuddy!
                      // );
                      if (selectedbuddy != null && isBuddySelected) {
                        String clintId = globalStorage.getClientId();
                        dashBoardBloc.add(
                            GetAllFacilityEvent(clientId: int.parse(clintId)));
                      }

                      // facilityBottomSheet();
                    },
                    child:
                        Custombutton(height: 30.h, text: "Okay", width: 320.w),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          );
        });
      },
    ).then(
      (value) {
        isBuddySelected = false;
      },
    );
    // .then((v){
    //   //  selectedbuddy = null;
    // } );
  }

  dynamic planId;

  congratDailog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return PopScope(
          canPop: canPop,
          child: AlertDialog(
            backgroundColor: AppColors.white,
            title: Center(
              child: Text(
                DashboardConst.congratulations,
                style: AppTextStyle.font20bold,
              ),
            ),
            content: BlocBuilder(
                bloc: dashBoardBloc,
                builder: (context, state) {
                  if (state is DashboarLoading) {
                    EasyLoading.show(status: state.message);
                  }
                  if (state is Subcription) {
                    EasyLoading.dismiss();

                    planId = state.subscriptionModel!.results!.planId;
                    // taskModel =  state.taskModel;
                  }
                  if (state is DashboarError) {
                    EasyLoading.dismiss();
                    EasyLoading.showError(state.error);
                  }
                  return SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        CustomImageProvider(
                          image: ClientImages.celebration,
                          width: 145,
                          height: 145,
                        ),
                        // Text(DashboardConst.scheduleTask,
                        //   style: AppTextStyle.font14w7,
                        // ),
                        SizedBox(
                          height: 20.h,
                        ),

                        Text(
                          textAlign: TextAlign.center,
                          "You have assigned the Task to ${janNameController.text}",
                          style: AppTextStyle.font14w7,
                        ),

                        SizedBox(
                          height: 20.h,
                        ),

                        // isTimePassed
                        //     ?
                             Text(
                                textAlign: TextAlign.center,
                                "Tasks scheduled before the current time will start tracking from the next day, as today's time may have already passed at the time of assignment"!,
                                style: AppTextStyle.font14bold,
                              ),
                            // : const SizedBox(),

                        //  GestureDetector(
                        //    onTap: () {
                        //       selectBuddyDailog();
                        //       // showDialog(context: context, builder: (context) =>  SelectBuddyDailog(), );
                        //    },
                        //    child: Custombutton(
                        //         height: 30.h,
                        //        text:DashboardConst.addAnotherTask , width: 320.w ),
                        //  ),

                        // SizedBox(
                        //   height: 20.h,
                        // ),

                        //    GestureDetector(
                        //    onTap: () {
                        //      if ( planId == null) {
                        //       Navigator.of(context).push( MaterialPageRoute(builder: (context) {
                        //          return const SubcriptionScreen();
                        //        }, ) );

                        //      } else {

                        //      }

                        //      facilityBottomSheet();

                        //    },
                        //    child: Custombutton(
                        //         height: 30.h,
                        //        text:DashboardConst.addAnotherFacility , width: 320.w ),
                        //  ),

                        SizedBox(
                          height: 20.h,
                        ),

                        GestureDetector(
                          onTap: () {
                            // String payementId = globalStorage.getPaymentId();

                            // if (payementId.isNotEmpty) {

                            //   globalStorage.removePaymentId();

                            // }

                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return  ClientDashboard(
                                  dashIndex: 1,
                                );
                              },
                            ));
                          },
                          child: Custombutton(
                              height: 30.h,
                              text: DashboardConst.noThanks,
                              width: 320.w),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  );
                }),
          ),
        );
      },
    ).then((v) {});
    ;
  }

  selectBuddyDailog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(20),
          
          backgroundColor: AppColors.white,
          content: BlocConsumer(
            listener: (context, state) {
              // print("dfsdfsd$state");
              if (state is DashboarLoading) {
                EasyLoading.show(status: state.message);
              }
              if (state is GetAllJanitor) {
                EasyLoading.dismiss();

                showTaskBuddyDailog(state.taskModel!);
                //  showDialog(context: context, builder:
                //      (context) {
                //    return BuddyListDailog( taskModel: state.taskModel, );
                //  },
                //  );
                // taskModel =  state.taskModel;
              }
              if (state is GetAllFacility) {
                facilityBottomSheet(true);
                dashBoardBloc.add(const GetTaskEvent(category: "Home"));
              }

              if (state is DashboarError) {
                EasyLoading.dismiss();
                EasyLoading.showError(state.error);
              }
            },
            bloc: dashBoardBloc,
            builder: (context, state) => SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  // CustomImageProvider(
                  //   image: ClientImages.celebration,
                  //   width: 145,
                  //   height: 145,
                  // ),
                  // Text(DashboardConst.scheduleTask,
                  //   style: AppTextStyle.font14w7,
                  // ),
                  SizedBox(
                    height: 20.h,
                  ),

                  Text(
                    textAlign: TextAlign.center,
                    DashboardConst.taskBuddyPrompt,
                    style: AppTextStyle.font14w7,
                  ),

                  SizedBox(
                    height: 20.h,
                  ),

                  GestureDetector(
                    onTap: () {
                      // Navigator.of(context).pop();
                      // Navigator.of(context).pop();
                      //  selectedbuddy = null;
                      dashController.taskStartTime.clear();
                      dashController.taskEndTime.clear();
                      dashController.taskTimes.clear();
                      selectedbuddy = null;
                      estimatedTime = null;
                      shiftTime = null;

                      String clintId = globalStorage.getClientId();
                      dashBoardBloc.add(
                          GetAllFacilityEvent(clientId: int.parse(clintId)));
                      // //  facilityBottomSheet();
                    },
                    child: Custombutton(
                        height: 35.h,
                        textColor: AppColors.black,
                        // color: AppColors.greyBgColor,
                        // color: ,
                        text: DashboardConst.assignNewTaskBuddy,
                        width: 320.w),
                  ),

                  SizedBox(
                    height: 20.h,
                  ),

                  GestureDetector(
                    onTap: () {
                      String clientId = globalStorage.getClientId();

                      print("dfgfd $clientId");
                      // context.read<ClientDashBoardBloc>().add(
                      //     GetAllJanitorEvent(
                      //       clientId: int.parse(clientId),
                      //     )
                      // );
                      dashBoardBloc.add(GetAllJanitorEvent(
                        clientId: int.parse(clientId),
                      ));
                    },
                    child: Custombutton(
                        height: 35.h,
                        text: DashboardConst.assignExistingTaskBuddy,
                        width: double.infinity ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return "Mobile number is required";
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return "Enter a valid 10-digit number";
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name is required";
    }
    if (value.length < 3) {
      return "Name must be at least 3 characters";
    }
    return null;
  }

  TimeOfDay convertToTimeOfDay(String timeString) {
    DateTime dateTime = DateTime.parse(timeString);
    return TimeOfDay.fromDateTime(dateTime);
  }

  int? deleteIndex;
  TimeOfDay parseTime(String timeStr) {
    final parts = timeStr.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  taskExistingBottomSheet(
      Datum buddy, FacilityDropdownModel? selectedFacility) {
    shiftTime = parseTime(selectedFacility!.startTime!);
    dashController.taskTimeModel.clear();
    use12hour = parseTime(selectedFacility!.endTime!).format(context);

    if (mounted) {
      dashController.taskTimes.clear();
      janNameController.text = buddy.name!;
      for (var item in buddy.taskTimes!) {
        print("start time ${item.startTime}");
        print("end time ${item.endTime}");
        String formattedStartDate =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(item.startTime!);
        String formattedEndDate =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(item.endTime!);

        TimeOfDay startTime = convertToTimeOfDay(formattedStartDate);
        TimeOfDay endTime = convertToTimeOfDay(formattedEndDate);

        print("start time ${startTime}");
        print("end time ${endTime}");
        //  dashController.taskTimes.add({
        //    "start_time": formattedStartDate!,
        //    "end_time": formattedEndDate,
        //   //  "facility_name": item.facilityName,
        //     // "facility_type": item.facilityType,
        //  });
        dashController.taskTimeModel.add(TaskTimeModel(
            taskId: item.taskId,
            endTime: endTime,
            startTime: startTime,
            facilityName: item.facilityName,
            facilityType: item.facilityType));

        print("lenght ${dashController.taskTimeModel.length}");

        //    dashController.facalityType.add(item.facilityType);
        //    dashController.facalityName.add(item.facilityName);

        //  dashController.taskStartTime.add(startTime);
        //  dashController.taskEndTime.add(endTime);
      }
    }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // buddy.taskTimes.map((e)=> e.startTime).toList();

        // convertToTimeOfDay(buddy.taskTimes[index].startTime.toString());

        return BlocConsumer(
            bloc: dashBoardBloc,
            listener: (context, state) {
              print("deltet testdd $state");

              if (state is DashboarLoading) {
                EasyLoading.show(status: state.message);
              }

              if (state is DeltetTaskTime) {
                EasyLoading.dismiss();
                dashController.taskTimeModel.removeAt(deleteIndex!);
                dashController.taskTimes.removeAt(deleteIndex!);

                showDialog(
                  // barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
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
                              image: ClientImages.verify,
                              width: 86.w,
                              height: 86.h,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              '${state.deleteModel!.results.message}',
                              style: AppTextStyle.font18bold,
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                //  Navigator.of(context).pop();
                              },
                              child: const Custombutton(
                                width: 300,
                                text: "Go Back",
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );

                ;
                // EasyLoading.showSuccess(state.message);
              }
              // if (state is TaskTimeModel) {
              //   EasyLoading.dismiss();
              //   // taskModel = state.taskModel;
              // }

              if (state is DashboarError) {
                EasyLoading.dismiss();
                EasyLoading.showError(state.error);
              }
            },
            builder: (context, state) {
              return StatefulBuilder(builder: (context, StateSetter setState) {
                return DraggableScrollableSheet(
                    initialChildSize: 0.8,
                    minChildSize: 0.8,
                    maxChildSize: 0.9,
                    builder: (context, scrollController) {
                      return Form(
                        key: _formKey,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(80.0),
                              topRight: Radius.circular(80.0),
                            ),
                          ),
                          height: MediaQuery.of(context).size.height / 1.11,
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: ListView(
                                controller: scrollController,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  header(DashboardConst.assignTasks, "Tasks",
                                      ClientImages.checklist),
                                  // const SizedBox(
                                  //   height: 20,
                                  // ),
                                  // Center(
                                  //   child: Text(DashboardConst.assignTasks,
                                  //     style: AppTextStyle.font18bold,
                                  //   ),
                                  // ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  selectedbuddy != null
                                      ? Padding(
                                          padding: EdgeInsets.only(left: 8.h),
                                          child: Text(
                                            "Buddy Name : ${selectedbuddy!.name}",
                                            style: AppTextStyle.font14bold,
                                          ),
                                        )
                                      : const SizedBox(),

                                  selectedbuddy != null
                                      ? const SizedBox(
                                          height: 10,
                                        )
                                      : const SizedBox(),

                                  Container(
                                    // height: 55,
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                              alpha: 0.2), // Shadow color
                                          spreadRadius:
                                              1, // How wide the shadow should spread
                                          blurRadius:
                                              10, // The blur effect of the shadow
                                          offset: const Offset(0,
                                              5), // Shadow offset, with y-offset for bottom shadow
                                        ),
                                      ],
                                      // color: enabled ? color ??  AppColors.backgroundColor : AppColors.disabledButtonColor,
                                      borderRadius: BorderRadius.circular(7),
                                    ),

                                    child: MultiDropdown<TaskDropdownModel>(
                                      items: items,
                                      controller: dropController,
                                      enabled: true,

                                      selectedItemBuilder: (item) {
                                        return Text(
                                          item.label,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff8F8F8F)),
                                        );
                                      },

                                      // searchEnabled: true,
                                      chipDecoration: const ChipDecoration(
                                        backgroundColor: Colors.yellow,
                                        wrap: true,
                                        runSpacing: 2,
                                        spacing: 10,
                                      ),
                                      fieldDecoration: const FieldDecoration(
                                          borderRadius: 7,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          hintText: DashboardConst
                                              .selectCleaningTasks,
                                          hintStyle: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff8F8F8F)),
                                          // prefixIcon: const Icon(CupertinoIcons.flag),
                                          showClearIcon: false,
                                          border: InputBorder.none

                                          // OutlineInputBorder(
                                          //   borderRadius: BorderRadius.circular(12),
                                          //   // borderSide: const BorderSide(color: Colors.grey),
                                          // ),
                                          // focusedBorder: OutlineInputBorder(
                                          //   borderRadius: BorderRadius.circular(12),

                                          //   // borderSide: const BorderSide(
                                          //   //   color: Colors.black87,
                                          //   // ),
                                          // ),
                                          ),

                                      dropdownDecoration: DropdownDecoration(
                                        footer: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                          child: GestureDetector(
                                              onTap: () {
                                                dropController.closeDropdown();
                                                //  Navigator.of(context).pop();
                                              },
                                              child: const Custombutton(
                                                  text: "Done",
                                                  width: double.infinity)),
                                        ),
                                        borderRadius: BorderRadius.circular(7),
                                        marginTop: 2,
                                        maxHeight:
                                            MediaQuery.of(context).size.height <
                                                    640
                                                ? 250
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height <
                                                        733
                                                    ? 350
                                                    : 450,

                                        // header: Padding(
                                        //   padding: EdgeInsets.all(8),
                                        //   child: Text(
                                        //     'Select countries from the list',
                                        //     textAlign: TextAlign.start,
                                        //     style: TextStyle(
                                        //       fontSize: 16,
                                        //       fontWeight: FontWeight.bold,
                                        //     ),
                                        //   ),
                                        // ),
                                      ),

                                      // dropdownItemDecoration: DropdownItemDecoration(

                                      //   selectedIcon:
                                      //       const Icon(Icons.check_box, color: Colors.green),
                                      //   disabledIcon:
                                      //       Icon(Icons.lock, color: Colors.grey.shade300),
                                      // ),
                                      // validator: (value) {
                                      //   if (value == null || value.isEmpty) {
                                      //     return 'Please select a country';
                                      //   }
                                      //   return null;
                                      // },
                                      itemBuilder: (item, index, onTap) {
                                        final isSelected = dropController
                                            .selectedItems
                                            .contains(item);

                                        return ListTile(
                                          minTileHeight: 25,
                                          leading: Checkbox(
                                            shape: RoundedRectangleBorder(
                                              // side: const BorderSide(
                                              //     color: Colors.black, // border color
                                              //     width: 0.3,           // 👈 border thickness
                                              //   ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            activeColor: Colors.yellow,
                                            checkColor: Colors.black,
                                            value: isSelected,
                                            onChanged: (_) =>
                                                onTap(), // manually toggle
                                          ),
                                          title: Text(
                                            item.label,
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                            .size
                                                            .height <
                                                        640
                                                    ? 12
                                                    : 15,
                                                // color: Color(0xff8BDFFB),
                                                color: const Color(0xff8F8F8F),
                                                fontWeight: FontWeight.w700),
                                          ),
                                          trailing: Text(
                                            "+ ${item.value.requiredTime.toString()} min",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                            .size
                                                            .height <
                                                        640
                                                    ? 12
                                                    : 15,
                                                color: const Color(0xff8BDFFB),
                                                fontWeight: FontWeight.w700),
                                          ),
                                        );
                                      },

                                      onSelectionChange: (selectedItems) {
                                        List<int?> listTime = [];

                                        len = selectedItems.length;

                                        listTime = selectedItems
                                            .map((e) => e.requiredTime)
                                            .toList();

                                        print("total time $estimatedTime");
                                        if (selectedItems.isEmpty) {
                                          estimatedTime = null;
                                        } else if (selectedItems.isNotEmpty) {
                                          estimatedTime = listTime
                                              .reduce((a, b) => a! + b!);
                                          taksIds = selectedItems
                                              .map((e) => e.id)
                                              .toList();
                                        } else if (selectedItems.isNotEmpty &&
                                            len! < selectedItems.length) {
                                          listTime = selectedItems
                                              .map((e) => e.requiredTime)
                                              .toList();
                                          estimatedTime = listTime
                                              .reduce((a, b) => a! - b!);
                                        }

                                        print("estimagte $estimatedTime ");

                                        // if(i.isEmpty ){
                                        //    estimatedTime = 0;
                                        // }
                                        setState(() {});

                                        debugPrint(
                                            "OnSelectionChange: $selectedItems");
                                      },
                                    ),
                                  ),

                                  // Padding(
                                  //   padding: EdgeInsets.symmetric(
                                  //     horizontal: 20.w,
                                  //     vertical: 10.h,
                                  //   ),
                                  //   child: Container(
                                  //     decoration: BoxDecoration(
                                  //       color: Colors.white,

                                  //       borderRadius: BorderRadius.circular(25.r),
                                  //       boxShadow: [
                                  //         BoxShadow(
                                  //           color: Colors.black.withValues(alpha: 0.2), // Shadow color
                                  //           spreadRadius: 1, // How wide the shadow should spread
                                  //           blurRadius: 10, // The blur effect of the shadow
                                  //           offset: const Offset(0,
                                  //               5), // Shadow offset, with y-offset for bottom shadow
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     child: MultiselectDropDownDialog(
                                  //       widgetKey: _facilityKey,
                                  //       hint: DashboardConst.selectCleaningTasks,

                                  //       // key: Key(
                                  //       //     '${_editProductModel.paymentMethodId?.firstOrNull?.label}T5'),
                                  //       // selected: _editProductModel.paymentMethodId,
                                  //       items: facilityNames,
                                  //       itemAsString: (TaskDropdownModel item) {
                                  //         return
                                  //           "${item.facilityName}   ${item.requiredTime} min" ;  },
                                  //       validator: (value) {
                                  //         print("slecrte $value");
                                  //         value == []
                                  //             ? "Please select tasks"

                                  //             : null;
                                  //       },

                                  //       onSaved: (List<TaskDropdownModel> i) {
                                  //         // selectedIds.add(i[1].taskId!);
                                  //         // selectedIds =
                                  //         //     i.map((e) => e.taskId.toString()).toList();
                                  //       },
                                  //       onChanged: (List<TaskDropdownModel> i) {
                                  //         // print(" car $i ");
                                  //         List<int?> listTime = [];

                                  //         len =  i.length;

                                  //         listTime =  i.map( (e) =>  e.requiredTime).toList();

                                  //         print("total time $estimatedTime");
                                  //         if(i.isEmpty){
                                  //           estimatedTime = null;
                                  //         }else
                                  //         if( i.isNotEmpty){
                                  //           estimatedTime = listTime.reduce((a, b) => a! + b!);
                                  //           taksIds =  i.map( (e) => e.id ).toList();
                                  //         }
                                  //         else
                                  //         if( i.isNotEmpty && len! < i.length    ){
                                  //           listTime =  i.map( (e) =>  e.requiredTime).toList();
                                  //           estimatedTime = listTime.reduce((a, b) => a! - b!);
                                  //         }

                                  //         print("estimagte $estimatedTime ");

                                  //         // if(i.isEmpty ){
                                  //         //    estimatedTime = 0;
                                  //         // }
                                  //         setState( (){});

                                  //         // selectedIds =
                                  //         //     i.map((e) => e.taskId.toString()).toList();
                                  //         // debugPrint(selectedIds.toString());
                                  //       },
                                  //       // label: 'Template Name',
                                  //     ),
                                  //   ),
                                  // ),

                                  estimatedTime == null && isTaskSelected
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          child: Column(
                                            children: [
                                              // const SizedBox(
                                              //   height: 10,
                                              // ),
                                              Text(
                                                "Please select Tasks",
                                                style: AppTextStyle.font12
                                                    .copyWith(
                                                        color: AppColors.red),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(
                                          // height: ,
                                          ),

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  Center(
                                    child: Text(
                                      DashboardConst
                                          .estimatedTaskCompletionTime,
                                      style: AppTextStyle.font20.copyWith(
                                          color: const Color(0xff8F8F8F)),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: estimatedTime == null
                                        ? Text(
                                            '00:00',
                                            style: AppTextStyle.font24bold,
                                          )
                                        : Text(
                                            "$estimatedTime min",
                                            style: AppTextStyle.font24bold,
                                          ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DashboardConst.scheduleShift,
                                        style: AppTextStyle.font14w7,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          //                                                    shiftTime = await    showTimePicker(
                                          //                                                     helpText: "Select Time",

                                          //                                           // barrierColor : AppColors.white,
                                          //                                        context: context,
                                          //                                        initialTime: TimeOfDay.now(),

                                          //                           builder: (BuildContext context, Widget? child) {
                                          //     return Theme(
                                          //       data: Theme.of(context).copyWith(

                                          //         timePickerTheme:  TimePickerThemeData(
                                          //             shape: RoundedRectangleBorder(
                                          //           borderRadius: BorderRadius.circular(60),
                                          //             ),
                                          //           helpTextStyle: const TextStyle(
                                          //             fontSize: 20,
                                          //             fontWeight: FontWeight.w700
                                          //            ),
                                          //            hourMinuteTextColor: Colors.black,
                                          //            inputDecorationTheme: const InputDecorationTheme(

                                          //            ),
                                          //              hourMinuteTextStyle:  const TextStyle(
                                          //             fontSize: 48,
                                          //             fontWeight: FontWeight.w700
                                          //            ),
                                          //           dialHandColor: const Color(0xffFFEB00),
                                          //           dialTextColor: Colors.black,
                                          //           dialTextStyle: const TextStyle(
                                          //              fontSize: 16,
                                          //              fontWeight: FontWeight.bold
                                          //           ),
                                          //           dayPeriodColor: const Color(0xffFFEB00),
                                          //           hourMinuteColor:
                                          //               MaterialStateColor.resolveWith((Set<MaterialState> states) {
                                          //     if (states.contains(MaterialState.selected)) {
                                          //       return const Color(0xff8BDFFB);
                                          //     }
                                          //     return Colors.white;
                                          //   }),
                                          //           // timeSelectorSeparatorColor: ,
                                          //           // timeSelectorSeparatorColor:

                                          //           hourMinuteShape: const RoundedRectangleBorder(
                                          //   borderRadius: BorderRadius.all(Radius.circular(18.0)),
                                          //   side: BorderSide.none,

                                          // ),

                                          //           dayPeriodShape:
                                          // const RoundedRectangleBorder(

                                          //   borderRadius: BorderRadius.all(Radius.circular(18.0)),
                                          //   side: BorderSide(),
                                          // )
                                          //           ,
                                          //           // dayPeriodBorderSide: BorderSide(
                                          //           //   style: BorderStyle.
                                          //           // ),
                                          //           dialBackgroundColor: const Color(0xff8BDFFB),

                                          //           confirmButtonStyle:
                                          //           TextButton.styleFrom(
                                          //             textStyle: const TextStyle(fontSize: 18,
                                          //      color: AppColors.black,
                                          //      fontWeight: FontWeight.bold),
                                          //   ),

                                          //           cancelButtonStyle:
                                          //           TextButton.styleFrom(
                                          //             textStyle: const TextStyle(fontSize: 18,
                                          //      color: AppColors.black,
                                          //      fontWeight: FontWeight.bold),
                                          //   ),

                                          //   //            MaterialStateProperty.all(

                                          //   //   const TextStyle(fontSize: 18,
                                          //   //    color: AppColors.black,
                                          //   //    fontWeight: FontWeight.bold),
                                          //   // ),),
                                          //             // backgroundColor: MaterialStateProperty.all<Color>(Colors.brown.shade300)),

                                          //           backgroundColor: const Color.fromRGBO(255, 255, 255, 0.8) // 👈 Your custom background
                                          //           // hourMinuteTextColor: Colors.white,
                                          //           // dialHandColor: Colors.red,
                                          //           // entryModeIconColor: Colors.white,
                                          //         ),
                                          //       ),
                                          //       child: child!,
                                          //     );
                                          //               },
                                          //             // );

                                          //                                        // builder: (BuildContext context, Widget? child) {
                                          //                                        //   // return Directionality(
                                          //                                        //   //   // textDirection: TextDirection.rtl,
                                          //                                        //   //   child: child!,
                                          //                                        //   // );
                                          //                                        // },
                                          //                                      );
                                          //                                           DateTime date = DateTime.now();
                                          //                                           // date.add( Duration( hours: shiftTime!.hour, minutes: shiftTime!.minute  ) );
                                          //                                           // print("duration ${}");

                                          //                                           DateTime dateTime = DateTime(date.year, date.month, date.day, shiftTime!.hour, shiftTime!.minute);
                                          //                                           DateTime newDateTime = dateTime.add(const Duration(hours: 12));
                                          //                                           TimeOfDay newShiftTime = TimeOfDay.fromDateTime(newDateTime);
                                          //                                           final localizations = MaterialLocalizations.of(context);
                                          //                                           use12hour =   localizations.formatTimeOfDay(newShiftTime, alwaysUse24HourFormat: false);
                                          //                                           // DateTime  hour =   date.add( Duration(hours: 12, minutes: 0 ));
                                          //                                           print("timen $newDateTime ");
                                          //                                           print("hour $use12hour ");
                                          setState(() {});
                                        },
                                        child: Container(
                                          width: 110,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: AppColors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                            // ),
                                          ),
                                          child: Center(
                                              child: shiftTime != null
                                                  ? Text(
                                                      shiftTime!
                                                          .format(context),
                                                      style:
                                                          AppTextStyle.font14w7,
                                                    )
                                                  : Text(
                                                      "Start Time *",
                                                      style:
                                                          AppTextStyle.font14w7,
                                                    )),
                                        ),
                                      )
                                    ],
                                  ),

                                  shiftTime == null && isNext || isTaskSelected
                                      ? Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Please select shift Timing",
                                              style: AppTextStyle.font12
                                                  .copyWith(
                                                      color: AppColors.red),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(
                                          // height: ,
                                          ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  Container(
                                    // height:
                                    // 70 ,
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(16),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            // crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // const SizedBox(
                                              //   height: 10,
                                              // ),
                                              Text(
                                                DashboardConst.scheduleTask,
                                                style: AppTextStyle.font14w7,
                                              ),
                                              GestureDetector(
                                                  onTap: () {
                                                    print(
                                                        "erstimage $estimatedTime");
                                                    print(
                                                        "is slecrete $isTaskSelected");
                                                    isTaskSelected = true;
                                                    setState(() {});
                                                    estimatedTime != null
                                                        ? _showMyDialog(true,
                                                                janitor:
                                                                    selectedbuddy)
                                                            .then(
                                                            (value) {
                                                              isTaskSelected =
                                                                  false;
                                                            },
                                                          )
                                                        : null;

                                                    // janitorBottomSheet()
                                                  },
                                                  child: Custombutton(
                                                      text: DashboardConst
                                                          .addTimings,
                                                      width:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .height <
                                                                  640
                                                              ? 120
                                                              : 140))
                                            ],
                                          ),
                                          dashController
                                                      .taskStartTime.isEmpty &&
                                                  isNext
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "Please add Timing for tasks",
                                                      style: AppTextStyle.font12
                                                          .copyWith(
                                                              color: AppColors
                                                                  .red),
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox(
                                                  // height: ,
                                                  ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Obx(
                                            () => dashController
                                                    .taskTimeModel.isEmpty
                                                ? const SizedBox()
                                                : const Divider(
                                                    color: Color(0xff828282),
                                                    thickness: 1,
                                                  ),
                                          ),
                                          Obx(
                                            () => SizedBox(
                                              height: dashController
                                                      .taskTimeModel.isEmpty
                                                  ? 0
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      5,
                                              child: ListView.builder(
                                                primary: false,
                                                shrinkWrap: true,
                                                physics:
                                                    const ClampingScrollPhysics(),
                                                itemCount: dashController
                                                    .taskTimeModel.length,
                                                itemBuilder: (context, index) {
                                                  //    TimeOfDay startTime =
                                                  //    convertToTimeOfDay(buddy.taskTimes[index].startTime.toString());
                                                  //    TimeOfDay endTime =    convertToTimeOfDay(buddy.taskTimes[index].endTime.toString());
                                                  // String   formattedStartDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(buddy.taskTimes[index].startTime);
                                                  // String   formattedEndDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(buddy.taskTimes[index].endTime);
                                                  //    dashController.taskTimes.add(    {
                                                  //      "start_time" : formattedStartDate! ,
                                                  //      "end_time" : formattedEndDate
                                                  //    });

                                                  return ListTile(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 4,
                                                            horizontal: 2),
                                                    minLeadingWidth: 0,
                                                    trailing: GestureDetector(
                                                      onTap: () {
                                                        deleteIndex = index;
                                                        setState(() {});
                                                             print("DELETE DATE");
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              AlertDialog(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          26),
                                                            ),
                                                            backgroundColor:
                                                                AppColors.white,
                                                            // title: const Text("Logout"),
                                                            content: SizedBox(
                                                              height: 175,
                                                              child: Column(
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 30,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            30),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        "Are you sure you want to delete the current time?",
                                                                        style: AppTextStyle.font15.copyWith(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                AppColors.black,
                                                                            fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child: Custombutton(
                                                                              color: AppColors.white,
                                                                              text: "No",
                                                                              width: 100.w)),
                                                                      GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                                 print("DELETE");
                                                                            // dashController.taskTimeModel.removeAt(index);
                                                                            //  print("task time  ${dashController.taskTimeModel}");
                                                                            if (dashController.taskTimeModel[index].taskId !=
                                                                                0) {
                                                                              dashBoardBloc.add(DeleteEvent(taskId: dashController.taskTimeModel[index].taskId));
                                                                            } else {
                                                                              dashController.taskTimeModel.removeAt(index);
                                                                              dashController.taskTimes.removeAt(index);
                                                                            //  print("task time model ${dashController.taskTimes}");
                                                                            }

                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child: Custombutton(
                                                                              text: "Yes",
                                                                              width: 100.w))
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 30,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            // actionsAlignment: MainAxisAlignment.spaceEvenly,
                                                            // actions: [

                                                            // ],
                                                          ),
                                                        );

                                                        // dashController.taskEndTime.removeAt(index);
                                                        //  setState((){});
                                                      },

                                                      child:
                                                          CustomImageProvider(
                                                              image:
                                                                  ClientImages
                                                                      .delete,
                                                              width: 25,
                                                              height: 25),
                                                      // const Icon(  Icons.delete,),
                                                      // color: AppColors.red,
                                                    ),
                                                    title: Column(
                                                      children: [
                                                        Row(
                                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              dashController
                                                                  .taskTimeModel[
                                                                      index]
                                                                  .facilityName,
                                                              style: AppTextStyle
                                                                  .font14bold,
                                                            ),
                                                            Text(
                                                              " - ",
                                                              style: AppTextStyle
                                                                  .font14bold,
                                                            ),
                                                            // taskEndTime
                                                            Text(
                                                              dashController
                                                                  .taskTimeModel[
                                                                      index]
                                                                  .facilityType,
                                                              style: AppTextStyle
                                                                  .font14bold,
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              dashController
                                                                  .taskTimeModel[
                                                                      index]
                                                                  .startTime
                                                                  .format(
                                                                      context),
                                                              style: AppTextStyle
                                                                  .font14bold,
                                                            ),
                                                            // taskEndTime
                                                            Text(
                                                              dashController
                                                                  .taskTimeModel[
                                                                      index]
                                                                  .endTime
                                                                  .format(
                                                                      context),
                                                              style: AppTextStyle
                                                                  .font14bold,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                  // const SizedBox(height: 10),
                                  Obx(
                                    () => SizedBox(
                                      height:
                                          dashController.taskTimeModel.isEmpty
                                              ? 80
                                              : 20,
                                    ),
                                  ),
                                  Center(
                                      child: Text(
                                          "The shift shall start at ${shiftTime == null ? '00:00' : shiftTime!.format(context)}")),
                                  const SizedBox(height: 5),
                                  Center(
                                      child: Text(
                                          textAlign: TextAlign.center,
                                          "Shift shall complete at ${use12hour}")),

                                  const SizedBox(height: 10),
                                  // GestureDetector(
                                  //   onTap: (){},
                                  //   child: Center(child: Text(
                                  //       style: AppTextStyle.font18bold.copyWith(
                                  //         color: AppColors.backgroundColor
                                  //       ),
                                  //       DashboardConst.addAnotherFacility,
                                  //
                                  //   )
                                  //   ),
                                  // ),
                                  // const Spacer(),

                                  // const SizedBox(height: 10),
                                  Obx(
                                    () => SizedBox(
                                      height:
                                          dashController.taskTimeModel.isEmpty
                                              ? 60
                                              : 15,
                                    ),
                                  ),

                                  GestureDetector(
                                      onTap: () {
                                        isNext = true;
                                        setState(() {});
                                        print(
                                            "curtne ${_formKey.currentState!.validate()}");
                                        print("org ${facilityController.text}");
                                        print("org ${locationController.text}");
                                        print(
                                            "org ${dashController.taskTimes}");

                                        String city = globalStorage.getCity();
                                        String address =
                                            globalStorage.getAddress();
                                        String pincode =
                                            globalStorage.getPincode();
                                        String clientId =
                                            globalStorage.getClientId();

                                        if (shiftTime != null &&
                                            dashController
                                                .taskStartTime.isNotEmpty &&
                                            estimatedTime != null) {
                                          // && shiftTime != null && taskStartTime.isNotEmpty && estimatedTime != null
                                          // adminBottomSheet();

                                          dashBoardBloc.add(AssignTaskEvent(
                                              clientId: int.parse(clientId),
                                              shiftTime:
                                                  "${shiftTime!.hour}:${shiftTime!.minute}:00",
                                              taskIds: taksIds,
                                              estimatedTime:
                                                  estimatedTime.toString(),
                                              taskTimes:
                                                  dashController.taskTimes,
                                              janitorId: buddy.id!,
                                              facilityRef:"",                
                                              facilityId: selectedFacility.id
                                                  .toString()
                                                  )
                                                  );

                                          // print("org ${facilityController.text}");
                                          // print("org ${locationController.text}");

                                          // dashBoardBloc.add( ClientSetUpEvent(
                                          //   clientId: clientId,
                                          //   orgName: facilityController.text,
                                          //   locality: locationController.text,
                                          //   pincode: pincode,
                                          //   address: address,
                                          //   city: city,
                                          //   //  unitNo: "sd"
                                          // )  );
                                        }

                                        // janitorBottomSheet()
                                      },
                                      child: Custombutton(
                                          text: "Submit", width: 328.w)),

                                  const SizedBox(height: 30),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              });
            });
      },
    ).then(
      (value) {
        loadFacilities();
        //  selectedbuddy = null;
        // dashController.taskStartTime.clear();
        // dashController.taskEndTime.clear();
        // dashController.taskTimes.clear();
        // estimatedTime = null;
        isTaskSelected = false;
        // shiftTime = null;
        isNext = false;
      },
    );
  }

  Widget header(String title, String subTitle, String image) {
    return Column(
      children: [
        const SizedBox(
          height: 9,
        ),
        Center(
          child: CustomImageProvider(
            image: ClientImages.line,
            width: 70,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageProvider(
              image: image,
              width: 24,
              height: 24,
            ),
            const SizedBox(
              width: 6,
            ),
            Text(
              semanticsLabel: title,
              title,
              style: AppTextStyle.font18bold,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              semanticsLabel: subTitle,
              subTitle,
              style: AppTextStyle.font18bold
                  .copyWith(color: AppColors.backgroundColor),
            ),
          ],
        ),
      ],
    );
  }

  bool isShiftTimePassed(TimeOfDay shiftTime) {
    final now = TimeOfDay.now();

    // Convert both to minutes since midnight for easy comparison
    final nowMinutes = now.hour * 60 + now.minute;
    final shiftMinutes = shiftTime.hour * 60 + shiftTime.minute;

    return shiftMinutes <= nowMinutes;
  }
}

// class BuddyListDailog extends StatefulWidget {
//  final TaskModel? taskModel;
//   const BuddyListDailog({super.key, required this.taskModel});

//   @override
//   State<BuddyListDailog> createState() => _BuddyListDailogState();
// }

// class _BuddyListDailogState extends State<BuddyListDailog> {
//   ClientDashBoardBloc dashBoardBloc  = ClientDashBoardBloc();
//   // GlobalStorage globalStorage = GetIt.instance();
//   List janitors = ["John", "David", "Emma", "Sophia"];
//   String? selectedJanitor;

//   @override
//   Widget build(BuildContext context) {
//     return

//   }
// }

// class TaskDropdownModel {
//   final String facilityName;
//   final int requiredTime;fvt

//   TaskDropdownModel({required this.facilityName, required this.requiredTime});
// }

class CustomMultiSelectDropdown extends StatefulWidget {
  final List<TaskDropdownModel> items;
  final List<TaskDropdownModel> selectedItems;
  final Function(List<TaskDropdownModel>) onSelectionChanged;

  const CustomMultiSelectDropdown({
    Key? key,
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<CustomMultiSelectDropdown> createState() =>
      _CustomMultiSelectDropdownState();
}

class _CustomMultiSelectDropdownState extends State<CustomMultiSelectDropdown> {
  bool isDropdownOpen = false;

  void _toggleDropdown() {
    setState(() {
      isDropdownOpen = !isDropdownOpen;
    });
  }

  void _onItemTapped(TaskDropdownModel item) {
    setState(() {
      if (widget.selectedItems.contains(item)) {
        widget.selectedItems.remove(item);
      } else {
        widget.selectedItems.add(item);
      }
      widget.onSelectionChanged(widget.selectedItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown button
        GestureDetector(
          onTap: _toggleDropdown,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.selectedItems.isEmpty
                        ? 'Select Items'
                        : widget.selectedItems
                            .map((e) => e.facilityName)
                            .join(', '),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),

        // Dropdown content
        if (isDropdownOpen)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  final isSelected = widget.selectedItems.contains(item);

                  return InkWell(
                    onTap: () => _onItemTapped(item),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isSelected,
                          onChanged: (_) => _onItemTapped(item),
                          activeColor: Colors.yellow,
                          checkColor: Colors.black,
                        ),
                        Expanded(
                          child: Text(
                            item.facilityName!,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xff8F8F8F)),
                          ),
                        ),
                        Text(
                          "${item.requiredTime}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xff8BDFFB)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class FloatingMultiSelectDropdown extends StatefulWidget {
  final List<TaskDropdownModel> items;
  final List<TaskDropdownModel> selectedItems;
  final Function(List<TaskDropdownModel>) onSelectionChanged;

  const FloatingMultiSelectDropdown({
    Key? key,
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<FloatingMultiSelectDropdown> createState() =>
      _FloatingMultiSelectDropdownState();
}

class _FloatingMultiSelectDropdownState
    extends State<FloatingMultiSelectDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final GlobalKey _key = GlobalKey();

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    setState(() {});

  }

  void _onItemTapped(TaskDropdownModel item) {
    setState(() {
      if (widget.selectedItems.contains(item)) {
        widget.selectedItems.remove(item);
      } else {
        widget.selectedItems.add(item);
      }
      widget.onSelectionChanged(widget.selectedItems);
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        left: offset.dx,
        top: offset.dy + size.height,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final isSelected = widget.selectedItems.contains(item);

                return InkWell(
                  onTap: () => _onItemTapped(item),
                  child: Row(
                    children: [
                      Checkbox(
                        value: isSelected,
                        onChanged: (_) => _onItemTapped(item),
                        activeColor: Colors.yellow,
                        checkColor: Colors.black,
                      ),
                      Expanded(
                        child: Text(
                          item.facilityName!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xff8F8F8F)),
                        ),
                      ),
                      Text(
                        "${item.requiredTime}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff8BDFFB)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        key: _key,
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.selectedItems.isEmpty
                      ? 'Select Items'
                      : widget.selectedItems
                          .map((e) => e.facilityName)
                          .join(', '),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}
