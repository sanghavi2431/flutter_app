import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/bloc/dashboard_state.dart'
    hide HostDetailsSuccess;
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/leading_button.dart';

import '../../../../core/local/global_storage.dart';
import '../../../../host/host_details.dart';
import '../../../../janitorial_services/screens/bloc/iot_bloc.dart';
import '../../../../janitorial_services/screens/bloc/iot_event.dart';
import '../../../../janitorial_services/screens/bloc/iot_state.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_textstyle.dart';
import '../../../utils/client_images.dart';
import '../../subcription/view/subcription.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart' hide GetHostDetailsData;
import '../controller/dashbaord_controller.dart';
import '../data/model/facility_dropdown_model.dart';
import '../data/model/facility_model.dart';
import '../data/model/payment_status.dart';
import '../data/model/task_model.dart';
import '../data/model/tasklist_model.dart';
import '../model/facility_model.dart';
import '../model/facility_type_model.dart';
import 'add_facility_task/congratulations_dialog.dart';
import 'add_facility_task/add facility screen/facility_bottom_sheet.dart';
import 'add_facility_task/membership_dialog_expired.dart';
import 'add_facility_task/select_buddy_dialog.dart';
import 'add_facility_task/show_task_buddy_dialog.dart';

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
  GlobalStorage globalStorage = GetIt.instance();
  int? roleId;
  IotBloc iotBloc = IotBloc();
  HostDetails? _hostDetailsData;
  String? selectedJanitor;
  Datum? selectedbuddy;
  bool isBuddySelected = false;
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
  String? defaultHostLocation;
  List<Facility> facilityList = [];
  List<TaskDropdownModel> facilityNames = [];
  List<FacilityDropdownModel> facilitydropdownNames = [];
  List<TypeFacility>? facilityType = [];
  int facilityCount = 0;
  bool isFirstTimeHost = false;
  FacilityDropdownModel? selectedFacility;
  List<TaskDropdownModel> gender = [
    TaskDropdownModel(id: 1, facilityName: "Male"),
    TaskDropdownModel(id: 1, facilityName: "Female")
  ];
  int? clusterId;
  int? locationId;
  int? facilityId;
  bool isOpenDrop = false;
  FocusNode addressFocusNode = FocusNode();
  PaymentStatusModel? paymentStatusModel;
  bool? value = false;
  bool? assing = false;
  bool isSelected = false;
  DateTime dateTime = DateTime.now();
  TimeOfDay? shiftTime = const TimeOfDay(hour: 12, minute: 0);
  bool isAdminSelected = false;
  DashBoardController dashController = Get.put(DashBoardController());
  FocusNode? facilityFocusNode;
  String? loc = "";
  String errorMessage = '';
  String erroradminMessage = '';
  String errorGenderMessage = '';
  bool isSelfAssign = false;
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
  List<String>? taskName = [];
  List<int>? selectedId = [];
  bool isExpand = false;
  dynamic planId;
  bool addNewTaskClicked = false;

  /// Set when [AddUserEvent] is dispatched from [ClientSetUp]; refresh list if it fails.
  bool _addUserAwaitingResult = false;
  bool _hasRequestedFacilitiesOnLoad = false;

  @override
  void initState() {
    super.initState();

    var some = globalStorage.getClientToken();
    roleId = globalStorage.getRoleId();

    print("aarati data role ${roleId}");
    if (roleId == 16) {
      print("aarati data  api");
      iotBloc.add(const GetHostDetailsData(id: "woloo_id"));
    }
    _requestFacilitiesOnLoad();
    facilityFocusNode = FocusNode();

    String facalityRef = globalStorage.getFacilityRef();

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
      appBar: AppBar(
        leading: LeadingButton(
          refresh: widget.isFromDashboard == true ? true : false,
        ),
        leadingWidth: 100,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                builder: (context, state) {
                  return BlocConsumer(
                      bloc: dashBoardBloc,
                      listener: (context, state) {
                        print("dashboar $state ");

                        if (state is DashboarLoading) {
                          EasyLoading.show(status: state.message);
                        }

                        if (state is FacilityType) {
                          EasyLoading.dismiss();
                          setState(() {
                            facilityType =
                                // state.facilityTypeModel ==  null ?   []  :
                                state.facilityTypeModel?.results!;
                          });
                          final results = _hostDetailsData?.results;
                          if (results != null) {
                            facilityController.text = results.name!;
                            defaultHostLocation =
                                "${results.address},${results.city!}";
                          }

                          dashBoardBloc
                              .add(const GetTaskEvent(category: "Home"));
                          print(
                              "Aarati default host loc home $defaultHostLocation");
                          if (addNewTaskClicked == false) {
                            facilityBottomSheet(
                                context,
                                facilityKey,
                                facilityController,
                                facilityType,
                                facilityList,
                                facilityCount,
                                typeController,
                                isFirstTimeHost,
                                defaultHostLocation,
                                errorMessage,
                                loc,
                                selectedIndex,
                                isOpenDrop,
                                selectedFacility,
                                facility,
                                items,
                                facilityNames,
                                isClientSupervisor,
                                selectedbuddy,
                                _clusterIdForFlow(),
                                isSelected,
                                facilitydropdownNames,
                                roleId!,
                                dashBoardBloc,
                                facilityFocusNode,
                                addNewTaskClicked);
                          }
                          if (addNewTaskClicked == true) {
                            String clintId = globalStorage.getClientId();
                            dashBoardBloc.add(GetAllFacilityEvent(
                                clientId: int.parse(clintId),
                                clusterId: clusterId));
                          }
                        }
                        if (state is IotLoading) {
                          EasyLoading.show(status: state.message);
                        }

                        if (state is HostDetailsSuccess) {
                          EasyLoading.dismiss();

                          setState(() {
                            _hostDetailsData = state.hostDetailsHome;
                            print("aarati data data ${_hostDetailsData}");
                          });
                        }

                        if (state is IotError) {
                          EasyLoading.dismiss();
                          EasyLoading.showError(state.error);
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

                            // Get language codes from storage (set in profile or from verifyOTP)
                            List<String> languageCodes =
                                globalStorage.getLanguageCodes();
                            List<String>? languageCodesList =
                                languageCodes.isNotEmpty ? languageCodes : null;

                            dashBoardBloc.add(AddJanitorEvent(
                                mobile: janMobileController.text,
                                name: janNameController.text,
                                gender: janitorGender,
                                roleId: "1",
                                clientId: clientId,
                                clusterId: [clusterId!],
                                languageCodes: languageCodesList));
                          } else {
                            String clientId = globalStorage.getClientId();
                            clusterId =
                                state.clientSetupModel.results.data.clusterId;

                            _addUserAwaitingResult = true;
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
                          _addUserAwaitingResult = false;
                          String clientId = globalStorage.getClientId();

                          print("add user succcesfull ");

                          // Get language codes from storage (set in profile or from verifyOTP)
                          List<String> languageCodes =
                              globalStorage.getLanguageCodes();
                          List<String>? languageCodesList =
                              languageCodes.isNotEmpty ? languageCodes : null;

                          dashBoardBloc.add(AddJanitorEvent(
                              mobile: janMobileController.text,
                              name: janNameController.text,
                              gender: janitorGender,
                              roleId: "1",
                              clientId: clientId,
                              clusterId: [
                                clusterId ?? selectedFacility!.clusterId!
                              ],
                              languageCodes: languageCodesList));

                          EasyLoading.dismiss();
                        }

                        if (state is Addjanitor) {
                          print(
                              "task mdddd succcesfull ${dashController.taskTimeModel.length}");
                          //  print("add jantor succcesfull ${globalStorage.getFacilityRef()}");
                          String clientId = globalStorage.getClientId();

                          shiftTime = const TimeOfDay(hour: 12, minute: 0);

                          // Add days to each taskTimes item (default to all days if not selected)
                          // Convert days to full names format expected by API
                          final defaultDays = [
                            "Monday",
                            "Tuesday",
                            "Wednesday",
                            "Thursday",
                            "Friday",
                            "Saturday",
                            "Sunday"
                          ];
                          final taskTimesWithDays =
                              dashController.taskTimes.map((taskTime) {
                            return {
                              ...taskTime,
                              "days":
                                  defaultDays, // Add days array to each task_time item
                            };
                          }).toList();

                          print("task timemssss ids ${taskTimesWithDays} ");
                          print(
                              "shift time  ${shiftTime!.hour}:${shiftTime!.minute}:00 ");

                          final facilityRefSnapshot =
                              globalStorage.getFacilityRef();
                          selectedFacility == null
                              ? dashBoardBloc.add(AssignTaskEvent(
                                  clientId: int.parse(clientId),
                                  shiftTime:
                                      "${shiftTime!.hour}:${shiftTime!.minute}:00",
                                  taskTimes: taskTimesWithDays,
                                  janitorId: state
                                      .superVisorModel!.results!.data!.value!,
                                  facilityRef: facilityRefSnapshot,
                                ))
                              : dashBoardBloc.add(AssignTaskEvent(
                                  clientId: int.parse(clientId),
                                  shiftTime:
                                      "${shiftTime!.hour}:${shiftTime!.minute}:00",
                                  taskTimes: taskTimesWithDays,
                                  janitorId: state
                                      .superVisorModel!.results!.data!.value!,
                                  facilityId: selectedFacility!.id.toString()));
                          globalStorage.removeFacilityRef();
                        }

                        if (state is CheckSupervisor) {
                          EasyLoading.dismiss();
                          isClientSupervisor = state.checkSupervisorModel!
                              .results!.isClientSupervisor!;
                        }

                        if (state is GetClient) {
                          EasyLoading.dismiss();
                          final String facilityRef =
                              state.client.results?.facilityRef ?? "";
                          _requestFacilitiesOnLoad();
                          if (facilityRef.isNotEmpty) {
                            globalStorage.saveFacilityRef(
                              accessFacilityRef: facilityRef,
                            );
                            if (paymentStatusModel == null) {
                              dashBoardBloc.add(
                                PaymentStatusEvent(refId: facilityRef),
                              );
                            }
                          }
                        }

                        if (state is AssignTask) {
                          EasyLoading.dismiss();

                          canPop = false;

                          dashController.taskTimes =
                              <Map<String, dynamic>>[].obs;

                          congratDailog(
                            context: context,
                            dashBoardBloc: dashBoardBloc,
                            janNameController: janNameController,
                            roleId: roleId!,
                            canPop: canPop,
                            planId: planId,
                          );
                        }

                        if (state is GetAllJanitor) {
                          EasyLoading.dismiss();
                          showTaskBuddyDailog(
                              state.taskModel!,
                              selectedJanitor!,
                              isBuddySelected,
                              context,
                              dashBoardBloc);
                        }

                        if (state is GetAllFacility) {
                          EasyLoading.dismiss();
                          final updatedList = state.facilityModel!.results!.facilities!;
                          if (addNewTaskClicked ==true && updatedList.every((e) =>
                          e.subscriptionStatus == "inactive" && e.isFreeTrial == false)) {
                            Fluttertoast.showToast(
                              msg: "All facilities are inactive.Please activate at least one facility to proceed.",
                              backgroundColor: Colors.red,
                            );
                          } else {
                            facilitydropdownNames.clear();
                            facilityList.clear();
                            facilityList =
                            state.facilityModel!.results!.facilities!;
                            for (var element in facilityList) {
                              facilitydropdownNames.add(
                                FacilityDropdownModel(
                                  id: element.id,
                                  facilityName: element.facilityName,
                                  clusterId: element.clusterId,
                                  subscriptionStatus: element.subscriptionStatus,
                                  isFreeTrial: element.isFreeTrial,
                                ),
                              );
                              print(
                                  "aarati falicit namessss ${element
                                      .facilityName} sub status ${element
                                      .subscriptionStatus} free trial ${element
                                      .isFreeTrial}");
                            }
                            facilityCount = state.facilityModel!.results!
                                .total!;

                            print(
                                "aarati falicit namessss $facilitydropdownNames $facilityCount");

                            if (addNewTaskClicked == true)
                              facilityBottomSheet(
                                  context,
                                  facilityKey,
                                  facilityController,
                                  facilityType,
                                  facilityList,
                                  facilityCount,
                                  typeController,
                                  isFirstTimeHost,
                                  defaultHostLocation,
                                  errorMessage,
                                  loc,
                                  selectedIndex,
                                  isOpenDrop,
                                  selectedFacility,
                                  facility,
                                  items,
                                  facilityNames,
                                  isClientSupervisor,
                                  selectedbuddy,
                                  _clusterIdForFlow(),
                                  isSelected,
                                  facilitydropdownNames,
                                  roleId!,
                                  dashBoardBloc,
                                  facilityFocusNode,
                                  addNewTaskClicked);
                          }
                        }

                        if (state is DeltetFacility) {
                          EasyLoading.dismiss();
                          final idStr = globalStorage.getClientId();
                          final cid = int.tryParse(idStr);
                          if (cid != null) {
                            dashBoardBloc.add(
                              GetAllJanitorEvent(clientId: cid),
                            );
                          }
                        }

                        if (state is DashboarError) {
                          EasyLoading.dismiss();
                          EasyLoading.showError(state.error);
                          if (_addUserAwaitingResult) {
                            _addUserAwaitingResult = false;
                            final idStr = globalStorage.getClientId();
                            final cid = int.tryParse(idStr);
                            if (cid != null) {
                              dashBoardBloc.add(
                                GetAllJanitorEvent(clientId: cid),
                              );
                            }
                          }
                          Future.delayed(
                            const Duration(seconds: 1),
                            () {
                              if (selectedFacility == null &&
                                  locationId != null &&
                                  clusterId != null &&
                                  facilityId != null) {
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
                            print("facilkt ${element.requiredTime}");
                            items.add(DropdownItem(
                                label: element.facilityName!, value: element!));
                          }

                          print("facilkt ${items.length}");
                        }

                        return widget.isFromDashboard == true
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
                                        handleAddNewFacility(
                                          context,
                                          clusterId: clusterId,
                                        );
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
                                      onPressed: handleAddTask,
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
                                  String clientid = globalStorage.getClientId();
                                  dashBoardBloc.add(FacilityTypeEvent(
                                      clientId: int.parse(clientid)));
                                },
                                child: Text(
                                  DashboardConst.getStarted,
                                  style: AppTextStyle.font20bold
                                      .copyWith(color: AppColors.black),
                                ));
                      });
                },
                bloc: iotBloc,
                listener: (BuildContext context, Object? state) {
                  print("aarati dssa $state");
                  if (state is IotLoading) {
                    EasyLoading.show(status: state.message);
                  }

                  if (state is HostDetailsSuccess) {
                    print(
                        "aarati data ${state.hostDetailsHome.results?.title}  $facilityCount");
                    print(
                        "aarati data ${state.hostDetailsHome.results?.city} ${facilityList.length} ${facilityNames.length}");
                    setState(() {
                      isFirstTimeHost = roleId == 16 && facilityCount == 0;
                      if (isFirstTimeHost) {
                        _hostDetailsData = state.hostDetailsHome;
                        facilityController.text =
                            state.hostDetailsHome.results!.title!;
                        defaultHostLocation =
                            "${state.hostDetailsHome.results!.address!},${state.hostDetailsHome.results!.city!}";
                      }
                    });
                    EasyLoading.dismiss();
                  }
                  if (state is IotError) {
                    EasyLoading.dismiss();
                    EasyLoading.showError(state.error);
                  }
                },
              ),
              // },

              SizedBox(
                height: 20.h,
              ),

              SizedBox(
                height: 20.h,
              ),

              Text(
                textAlign: TextAlign.center,
                "The Task Master service of Woloo Smart Hygiene is a paid service. You are eligible for a free trial, during which you can add only one facility. After the trial period ends, you must pay ₹499 + GST to continue using the Task Master service.",
                style: AppTextStyle.font8,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _requestFacilitiesOnLoad() {
    if (_hasRequestedFacilitiesOnLoad) return;
    final String clientIdRaw = globalStorage.getClientId();
    final int? parsedClientId = int.tryParse(clientIdRaw);
    if (parsedClientId == null) return;
    _hasRequestedFacilitiesOnLoad = true;
    dashBoardBloc.add(
      GetAllFacilityEvent(
        clientId: parsedClientId,
        clusterId: clusterId,
      ),
    );
  }

  int? _clusterIdForFlow() {
    if (clusterId != null) return clusterId;
    if (facilityList.isNotEmpty) return facilityList.first.clusterId;
    return null;
  }

  Future<void> loadFacilities() async {
    print("Fetching facilities...");

    final items = facilityNames
        .map((element) => DropdownItem(
              label: element.facilityName!,
              value: element,
            ))
        .toList();

    dropController.setItems(items);
  }

  TimeOfDay parseTime(String timeStr) {
    final parts = timeStr.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  bool isShiftTimePassed(TimeOfDay shiftTime) {
    final now = TimeOfDay.now();
    // Convert both to minutes since midnight for easy comparison
    final nowMinutes = now.hour * 60 + now.minute;
    final shiftMinutes = shiftTime.hour * 60 + shiftTime.minute;

    return shiftMinutes <= nowMinutes;
  }

  void handleAddNewFacility(BuildContext context, {int? clusterId}) {
    final int? resolvedClusterId =
        clusterId ?? this.clusterId ?? _clusterIdForFlow();
    this.clusterId = resolvedClusterId;
    addNewTaskClicked = false;
    facilitydropdownNames = [];
    String planId = globalStorage.getPlanId();
    String paymentId = globalStorage.getPaymentId();

    facilityController.clear();
    locationController.clear();
    selectedIndex = -1;
    print("payment id  ${paymentId} ");
    if (paymentId.isNotEmpty) {
      globalStorage.removePaymentId();
    }
    if (planId == "0" && paymentId.isEmpty) {
      print(" in side dsd object");

      // Capture the home screen context

      final homeContext = context;

      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return MembershipExpiredDialog(
            onButtonTap: () {
              Navigator.pop(context); // close dialog
              Navigator.of(homeContext).pop(true); // go back to dashboard
            },
          );
        },
      );
    } else {
      if (paymentStatusModel == null) {
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return SubcriptionScreen(
              dashBoardBloc: dashBoardBloc,
              isfromFacility: false,
              onGoToHomeClick: () {
                handleAddNewFacility(context, clusterId: resolvedClusterId);
              },
            );
          },
        );

        //  }
        //  }
      } else if (paymentStatusModel!.results!.facilityId == null) {
        print("payment id  ${paymentId} ");

        //              dashBoardBloc.add( const GetTaskEvent(
        //     category: "Home"
        // ) );

        String clientid = globalStorage.getClientId();
        dashBoardBloc.add(FacilityTypeEvent(clientId: int.parse(clientid)));

        //  facilityBottomSheet(false);
      } else {
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return SubcriptionScreen(
              dashBoardBloc: dashBoardBloc,
              isfromFacility: false,
              onGoToHomeClick: () {
                handleAddNewFacility(context, clusterId: resolvedClusterId);
              },
            );
          },
        );
      }
    }
  }

  void handleAddTask() {
    addNewTaskClicked = true;
    /*if (selectedJanitor == null) {
      EasyLoading.showError("Please select janitor first");
      return;
    }

    if (facilityNames.isEmpty) {
      EasyLoading.showError("Tasks not loaded");
      return;
    }*/

    loadFacilities();

    for (var element in facilityList) {
      print(
          "aarati ${element.facilityName} sub status ${element.subscriptionStatus} free trial ${element.isFreeTrial}");
    }


    /* selectBuddyDailog(
        selectedbuddy,
        selectedJanitor,
        isBuddySelected,
        context,
        dashBoardBloc,
       // facilitydropdownNames,
        facilityList,
        dashController,
        estimatedTime,
        shiftTime
    );*/

    dashController.taskStartTime.clear();
    dashController.taskEndTime.clear();
    dashController.taskTimes.clear();
    selectedbuddy = null;
    estimatedTime = null;
    shiftTime = null;

    String clintId = globalStorage.getClientId();

    dashBoardBloc.add(FacilityTypeEvent(clientId: int.parse(clintId)));
    /* dashBoardBloc.add(
        GetAllFacilityEvent(clientId: int.parse(
            clintId)));*/
  }
}
