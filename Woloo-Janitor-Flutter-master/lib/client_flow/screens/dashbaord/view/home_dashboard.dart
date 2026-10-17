
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import '../../../../core/local/global_storage.dart';
import '../../../../screens/login/view/login_screen.dart';
import '../../../../screens/supervisor_dashboard/view/supervisor_dashboard_screen.dart';
import '../../../../utils/app_images.dart';
import '../../../widgets/explore_card.dart';
import '../../iot/view/show_subscription_dialog.dart';
import '../../subcription/view/subcription.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../data/model/facility_model.dart';
import 'home.dart';
import 'home_tabbar.dart';

/*class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  ClientDashBoardBloc dashBoardBloc = ClientDashBoardBloc();
  Map<String, dynamic>? decodedToken;
  GlobalStorage globalStorage = GetIt.instance();
  List<Facility> facility = [];
  Duration difference = const Duration(
    days: 0,
  );

  bool isClientSupervisor = false;
  String? clientName;
  String? planId = "1";
  String? formatted;
  bool isChanges = false;
  bool isLoading = false;
  bool isHostLoading = false;
  late int roleId;
  int? selectedTabIndex;
  VoidCallback? onExportPdfCallback;
  Function(String)? onRangeChangeCallback;
  String _selectedRange = 'Today';

  @override
  void initState() {
    super.initState();
    var some = globalStorage.getClientToken();
    String clintId = globalStorage.getClientId();
    roleId = globalStorage.getRoleId();
    if (roleId == 16 && globalStorage.isOnboard() == false) {
      isHostLoading = true;
    }
    clientName = "";
    DateTime now = DateTime.now();
    formatted = DateFormat('h:mm a, d MMM yyyy').format(now);
    dashBoardBloc.add(SubcriptionEvent(id: int.parse(clintId)));
    decodedToken = JwtDecoder.decode(some);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomImageProvider(
              image: AppImages.dashlogo,
              width: 80,
              height: 80,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Hello, ${globalStorage.getClientMobileNo()}",
                    style: AppTextStyle.font14bold,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    formatted!,
                    style: AppTextStyle.font12,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Switch Button
          if (isClientSupervisor)
            GestureDetector(
              onTap: () {
                String supervisorToken = globalStorage.getToken();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return supervisorToken == ""
                        ? const LoginScreen(
                            type: null,
                          )
                        : const SupervisorDashboard(isFromSupervisor: true);
                  },
                ));
              },
              child: Container(
                height: 40,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomImageProvider(
                        image: AppImages.switchIcon,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          if (selectedTabIndex != null &&
              facility.isNotEmpty &&
              selectedTabIndex! < facility.length &&
              facility[selectedTabIndex!].planName == "PREMIUM")
            GestureDetector(
              onTap: () {
                if (onExportPdfCallback != null) {
                  onExportPdfCallback!();
                }
              },
              child: Container(
                height: 40,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.share, size: 24),
                      const SizedBox(width: 4),
                      const Text(
                        "",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      body: LayoutBuilder(
          builder: (context, constraints) {
            return
              Padding(
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
                          dashBoardBloc
                              .add(CheckSupvisorEvent(id: int.parse(clintId)));

                          setState(() {
                            facility = state.facilityModel!.results!
                                .facilities!;
                          });
                          isLoading =
                          state.facilityModel!.results!.facilities!.isEmpty
                              ? true
                              : false;
                        if (facility.isEmpty) {
                          }
                          facility.insert(
                              0,
                              Facility(
                                  facilityName: "Add Facility/Task",
                                  id: 0,
                                  isFutureSubscription: false));
                          print("aarati facility length ${facility.length}");
                        }
                        if (state is Subcription) {
                          planId = globalStorage.getPlanId();
                          print("plan id $planId");
                          dashBoardBloc.add(GetAllFacilityEvent(
                              clientId: int.parse(
                                  globalStorage.getClientId())));
                          DateTime currentDate = DateTime.now();
                          DateTime futureDate =
                          state.subscriptionModel!.results!.expiryDate!;
                          difference = futureDate.difference(currentDate);
                          print(
                              'Difference: ${difference
                                  .inDays}  pamnd  ${planId} days');
                          EasyLoading.dismiss();
                          if (planId == "0") {
                            int remainingDays = difference.inDays;
                            if (remainingDays < 0) {
                              remainingDays = 0;
                            }
 if (remainingDays <= 3) {
                              final bool isExpired = remainingDays == 0;

                              showDialog(
                                barrierDismissible: !isExpired,
                                context: context,
                                builder: (dialogContext) {
                                  return PopScope(
                                    canPop: !isExpired,
                                    child: AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      backgroundColor: AppColors.white,
                                      contentPadding: EdgeInsets.zero,
                                      insetPadding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                      content: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.w, vertical: 24.h),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              isExpired
                                                  ? "Your TASKMASTER Trial Period has expired. Kindly pay to Continue"
                                                  : "Your Free Subscription shall end in $remainingDays Days.",
                                              textAlign: TextAlign.center,
                                              style: AppTextStyle.font18bold,
                                            ),
                                            SizedBox(
                                              height: 24.h,
                                            ),
                                            Row(
                                              children: [
                                                if (!isExpired)
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(
                                                            dialogContext)
                                                            .pop();
                                                      },
                                                      child: Container(
                                                        height: 40.h,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                          color: const Color(
                                                              0xFFEDE8E8), // Skip button color
                                                        ),
                                                        alignment: Alignment
                                                            .center,
                                                        child: Text(
                                                          "Skip",
                                                          style: AppTextStyle
                                                              .font18bold
                                                              .copyWith(
                                                              color: AppColors
                                                                  .black),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                if (!isExpired)
                                                  SizedBox(
                                                    width: 8.w,
                                                  ),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(
                                                          dialogContext)
                                                          .pop();
                                                      showModalBottomSheet(
                                                        backgroundColor:
                                                        Colors.transparent,
                                                        context: context,
                                                        builder: (context) {
                                                          return SubcriptionScreen(
                                                            dashBoardBloc:
                                                            dashBoardBloc,
                                                            isfromFacility: true,
                                                            facilityId:
                                                            facility[1].id,
                                                          );
                                                        },
                                                      ).then((value) {
                                                     final String currentPlanId =
                                                        globalStorage
                                                            .getPlanId();
                                                        if (currentPlanId ==
                                                            "0") {
                                                          dashBoardBloc.add(
                                                              SubcriptionEvent(
                                                                  id: int.parse(
                                                                      globalStorage
                                                                          .getClientId())));
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 40.h,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                        color: const Color(
                                                            0xFF83E0FF), // Renew button color
                                                      ),
                                                      alignment: Alignment
                                                          .center,
                                                      child: Text(
                                                        "Renew It Now",
                                                        style: AppTextStyle
                                                            .font18bold
                                                            .copyWith(
                                                            color:
                                                            AppColors.black),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ).then(
                                    (value) {
                                  // No-op on dialog close
                                },
                              );
                            }
                          }
                        }
                        if (state is DashboarError) {
                          isLoading = true;
                          print("facility length ${facility}");
                          EasyLoading.dismiss();
                          EasyLoading.showError(state.error);
                        }
                      },
                      builder: (context, state) {
                        if (state is DashboarLoading) {
                          return const SizedBox();
                        }
                        if (state is Subcription) {
                          return const SizedBox();
                        }
                        if (state is GetAllFacility) {
                          return const SizedBox(
                          );
                        }
                        if (state is CheckSupervisor) {
                          print(
                              "isClientSupervisor ${difference
                                  .inDays} ${planId} ${facility.first
                                  .id} ${isLoading} ");
                          return difference.inDays != 0 && planId == "0" &&
                              !isLoading
                              ? Column(
                            children: [
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
                              : const SizedBox();
                        }
                        if (state is DashboarError) {
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
                                .checkSupervisorModel!.results!
                                .isClientSupervisor!;
                          }
                           if (state is Subcription) {
                            EasyLoading.dismiss();
                          }
                          if (state is GetAllFacility) {
                            EasyLoading.dismiss();
                          }
                          if (state is DashboarError) {
                            EasyLoading.dismiss();
                            EasyLoading.showError(state.error);
                          }
                        },
                        bloc: dashBoardBloc,
                        builder: (context, state) {
                          if (state is DashboarLoading) {
                            return const SizedBox();
                          }
                          if (state is Subcription) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text(
                                      DashboardConst.dashboardOverview,
                                      style: AppTextStyle.font20bold,
                                    ),
                                    if (selectedTabIndex != null &&
                                        facility.isNotEmpty &&
                                        selectedTabIndex! < facility.length &&
                                        facility[selectedTabIndex!].planName ==
                                            "PREMIUM")
                                      SizedBox(
                                        height: 44,
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton2<String>(
                                            value: _selectedRange,

                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.black87,
                                            ),
                                            items: ['Today', '7 days', 'Month']
                                                .map(
                                                  (value) =>
                                                  DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value),
                                                  ),
                                            )
                                                .toList(),
                                            onChanged: (value) {
                                              if (value != null &&
                                                  value != _selectedRange) {
                                                setState(
                                                        () =>
                                                    _selectedRange = value);
                                                onRangeChangeCallback?.call(
                                                    value);
                                              }
                                            },
                                            buttonStyleData: ButtonStyleData(
                                              height: 44,
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 12),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.circular(8),
                                                border: Border.all(
                                                    color: Colors.grey
                                                        .shade300),
                                              ),
                                            ),
                                            iconStyleData: const IconStyleData(
                                              icon: Icon(
                                                  Icons.keyboard_arrow_down),
                                              iconEnabledColor: Colors.black,
                                            ),
                                            dropdownStyleData: DropdownStyleData(
                                              maxHeight: 200,
                                              elevation:
                                              0,
                                             decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.12),
                                                    blurRadius: 12,
                                                    spreadRadius: 1,
                                                    offset: Offset(0, 4),
                                                  ),
                                                ],
                                              ),

                                              offset: const Offset(0, 4),
                                            ),

                                            menuItemStyleData:
                                            const MenuItemStyleData(
                                              height: 44,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12),
                                            ),
                                          ),
                                        ),
                                      )

                                  ],
                                ),
                                // isLoading ?  SizedBox() :

                                (isLoading && roleId == 16)
                                    ? Column(
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

                                  ],
                                )
                                    : SizedBox(
                                    height: constraints.maxHeight - 150.h,
                                    child:
                                    HomeTabbar(
                                      facility: facility,
                                      clientDashBoardBloc: dashBoardBloc,
                                      onTabChanged: (index) {
                                        setState(() {
                                          selectedTabIndex = index;

                                          _selectedRange = 'Today';
                                        });
                                      },
                                      onExportPdfCallbackSet: (callback) {
                                        setState(() {
                                          onExportPdfCallback = callback;
                                        });
                                      },
                                      onRangeChangeCallbackSet: (callback) {
                                        setState(() {
                                          onRangeChangeCallback = callback;
                                        });
                                      },
                                    ))
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              );
          },),
    );
  }
}
*/


class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {

  late ClientDashBoardBloc dashBoardBloc;

  Map<String, dynamic>? decodedToken;
  GlobalStorage globalStorage = GetIt.instance();

  List<Facility> facility = [];

  Duration difference = const Duration(days: 0);

  bool isClientSupervisor = false;

  String? clientName;

  String? planId = "1";

  String? formatted;

  bool isChanges = false;

  bool isLoading = false;

  bool isHostLoading = false;

  late int roleId;

  int? selectedTabIndex;

  VoidCallback? onExportPdfCallback;

  Function(String)? onRangeChangeCallback;

  String _selectedRange = 'Today';

  bool _facilityApiCalled = false;

  int _lastTabIndex = 0;

  @override
  void initState() {

    super.initState();

    dashBoardBloc = context.read<ClientDashBoardBloc>();

   // dashBoardBloc = ClientDashBoardBloc();



    final token = globalStorage.getClientToken();

    final clientId = globalStorage.getClientId();

    roleId = globalStorage.getRoleId();

    if (roleId == 16 && globalStorage.isOnboard() == false) {
      isHostLoading = true;
    }

    clientName = "";

    final now = DateTime.now();

    formatted = DateFormat('h:mm a, d MMM yyyy').format(now);

    dashBoardBloc.add(SubcriptionEvent(id: int.parse(clientId)));

    decodedToken = JwtDecoder.decode(token);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.white,

      appBar: _buildAppBar(),

      body: LayoutBuilder(
        builder: (context, constraints) {

          return Padding(

            padding: const EdgeInsets.symmetric(horizontal: 0),

            child: Column(

              children: [

                const SizedBox(height: 14),

                _subscriptionBloc(),

                _dashboardBloc(constraints),

              ],

            ),

          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {

    return AppBar(

      automaticallyImplyLeading: false,

      backgroundColor: AppColors.white,

      titleSpacing: 0,

      title: Row(

        children: [

          CustomImageProvider(
            image: AppImages.dashlogo,
            width: 80,
            height: 80,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Hello, ${globalStorage.getClientMobileNo()}",
                  style: AppTextStyle.font14bold,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),

                Text(
                  formatted!,
                  style: AppTextStyle.font12,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),

      actions: [

      /*  if (isClientSupervisor == true) _buildSupervisorSwitch(),
*/
        isClientSupervisor == true
            ? _buildSupervisorSwitch()
            : const SizedBox.shrink(),

        if (selectedTabIndex != null &&
            facility.isNotEmpty &&
            selectedTabIndex! < facility.length &&
            facility[selectedTabIndex!].planName == "PREMIUM")
          _buildShareButton(),
      ],
    );
  }

  Widget _buildSupervisorSwitch() {

    return GestureDetector(

      onTap: () {

        String supervisorToken = globalStorage.getToken();

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return supervisorToken == ""
                  ? const LoginScreen(type: null)
                  : const SupervisorDashboard(isFromSupervisor: true);
            },
          ),
        );
      },

      child: Container(

        height: 40,

        margin: const EdgeInsets.only(right: 8),

        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),

        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              CustomImageProvider(
                image: AppImages.switchIcon,
              ),
              const SizedBox(width: 4),
              const Text(""),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareButton() {

    return GestureDetector(

      onTap: () {
        onExportPdfCallback?.call();
      },

      child: Container(

        height: 40,

        margin: const EdgeInsets.only(right: 8),

        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),

        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(Icons.share, size: 24),
              SizedBox(width: 4),
              Text(""),
            ],
          ),
        ),
      ),
    );
  }

  Widget _subscriptionBloc() {

    return BlocConsumer(

      bloc: dashBoardBloc,

      listener: (context, state) {

        if (state is DashboarLoading) {
          EasyLoading.show(status: state.message);
        }

        if (state is GetAllFacility) {
          setState(() {}); // or update UI
        }

        if (state is Subcription) {
          if (!_facilityApiCalled) {

          _facilityApiCalled = true;

          dashBoardBloc.add(
            GetAllFacilityEvent(
              clientId: int.parse(globalStorage.getClientId()),
            ),
          );
        }

          EasyLoading.dismiss();

          planId = globalStorage.getPlanId();

          DateTime currentDate = DateTime.now();

          DateTime futureDate =
          state.subscriptionModel!.results!.expiryDate!;

          difference = futureDate.difference(currentDate);



          /// ADD THIS BLOCK BACK
         /* if (planId == "0") {

            int remainingDays = difference.inDays;

            if (remainingDays < 0) remainingDays = 0;

            if (remainingDays <= 3) {

              final bool isExpired = remainingDays == 0;

              showSubscriptionDialog(remainingDays, isExpired , context ,dashBoardBloc , facility);
            }
          }*/
        }
        if (state is GetAllFacility) {

          isLoading = false;
          EasyLoading.dismiss();


          facility = state.facilityModel?.results?.facilities ?? [];

          if (planId == "0") {

            int remainingDays = difference.inDays;

            if (remainingDays < 0) remainingDays = 0;

            if (remainingDays <= 3) {

              final bool isExpired = remainingDays == 0;

              showSubscriptionDialog(remainingDays, isExpired , context ,dashBoardBloc , facility);
            }
          }

          isLoading =
          state.facilityModel!.results!.facilities!.isEmpty
              ? true
              : false;
          if (facility.isEmpty || facility.first.id != 0) {
            facility.insert(
              0,
              Facility(
                facilityName: "Add Facility/Task",
                id: 0,
                isFutureSubscription: false,
              ),
            );
          }


          dashBoardBloc.add(
            CheckSupvisorEvent(
              id: int.parse(globalStorage.getClientId()),
            ),
          );

          if (selectedTabIndex == null && facility.length > 1) {
            selectedTabIndex = 1; // 👈 FIRST REAL FACILITY
          } else {
            selectedTabIndex ??= 0;
          }

          /// 🔥 KEY FIX
          setState(() {
           // selectedTabIndex ??= 0; // assign only if null
          });

        }

        if (state is DashboarError) {

          EasyLoading.dismiss();

          EasyLoading.showError(state.error);
        }
      },

      builder: (context, state) {
        return const SizedBox();
      },
    );
  }

  Widget _dashboardBloc(BoxConstraints constraints) {

    return BlocConsumer(

      bloc: dashBoardBloc,

      listener: (context, state) {

        if (state is CheckSupervisor) {
          setState(() {
            isClientSupervisor =
                state.checkSupervisorModel?.results?.isClientSupervisor ?? false;
          });
        }
      },

      builder: (context, state) {

        return Padding(

          padding: const EdgeInsets.symmetric(horizontal: 16),

          child: Column(

            children: [

              if (difference.inDays != 0 && planId == "0" && !isLoading)
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor:
                      Colors.transparent,
                      context: context,
                      isScrollControlled: true,
                      scrollControlDisabledMaxHeightRatio: 0.8,
                      builder: (context) {
                        return  /*Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.75,
                          child:*/ SubcriptionScreen(
                          dashBoardBloc:
                          dashBoardBloc,
                          isfromFacility: true,
                          facilityId:
                          facility[1].id,
                      //  ),
                      //      ),
                        );
                      },
                    ).then((value) {
                      final String currentPlanId =
                      globalStorage
                          .getPlanId();
                      if (currentPlanId ==
                          "0") {
                        dashBoardBloc.add(
                            SubcriptionEvent(
                                id: int.parse(
                                    globalStorage
                                        .getClientId())));
                      }
                    });
                  },
                  child: Column(
                  children: [
                    Text(
                      DashboardConst.renew,
                      style: AppTextStyle.font13.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  const SizedBox(height: 5),
                  ],
                  )
                ),


              _dashboardHeader(),


              (isLoading && roleId == 16)
                  ? _emptyDashboard()
                  : SizedBox(
                height: constraints.maxHeight - 150.h,
                child: HomeTabbar(
                  facility: facility,
                  clientDashBoardBloc: dashBoardBloc,

                  onTabChanged: (index) {

                    if (_lastTabIndex == index) return;

                    _lastTabIndex = index;

                    setState(() {

                      selectedTabIndex = index;

                      _selectedRange = 'Today';
                    });
                  },

                  onExportPdfCallbackSet: (callback) {
        setState(() {
                    onExportPdfCallback = callback;
        });
                  },

                  onRangeChangeCallbackSet: (callback) {
        setState(() {
          onRangeChangeCallback = callback;
        });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _dashboardHeader() {

    return Row(

      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [

        Text(
          DashboardConst.dashboardOverview,
          style: AppTextStyle.font20bold,
        ),

        if (selectedTabIndex != null &&
            facility.isNotEmpty &&
            selectedTabIndex! < facility.length &&
            facility[selectedTabIndex!].planName == "PREMIUM")
          _rangeDropdown(),
      ],
    );
  }

  Widget _rangeDropdown() {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
          )
        ],
      ),

      height: 44,

      child:DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          value: _selectedRange,

          items: ['Today', '7 days', 'Month']
              .map(
                (value) => DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          )
              .toList(),

          onChanged: (value) {
            if (value != null && value != _selectedRange) {
              setState(() => _selectedRange = value);
              onRangeChangeCallback?.call(value);
            }
          },


          /// ✅ DROPDOWN STYLE (background 40% opacity white)
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),

          /// ✅ TEXT STYLE (selected value)
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),

          /// Optional: item height spacing
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
      )
      /* DropdownButtonHideUnderline(

        child: DropdownButton2<String>(

          value: _selectedRange,

          items: ['Today', '7 days', 'Month']
              .map(
                (value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ),
          )
              .toList(),

          onChanged: (value) {

            if (value != null && value != _selectedRange) {

              setState(() => _selectedRange = value);

              onRangeChangeCallback?.call(value);
            }
          },
        ),
      ),*/
    );
  }

  Widget _emptyDashboard() {

    if(EasyLoading.isShow)
      EasyLoading.dismiss();

    return Column(
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

      ],
    );
  }
}