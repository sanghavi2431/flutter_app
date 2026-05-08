import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauge_chart/gauge_chart.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:woloo_smart_hygiene/app.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/dashboard.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/janitorial_services/model/host_dashboard_screen.dart';
import 'package:woloo_smart_hygiene/janitorial_services/model/referral_coins.dart';
import 'package:woloo_smart_hygiene/janitorial_services/screens/bloc/iot_bloc.dart';
import 'package:woloo_smart_hygiene/janitorial_services/screens/bloc/iot_event.dart';
import 'package:woloo_smart_hygiene/janitorial_services/screens/bloc/iot_state.dart';
import 'package:woloo_smart_hygiene/host/get_hosts_all_revies.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:woloo_smart_hygiene/b2b_store/address_change_bottomsheet.dart';

import '../../host/amenities_config.dart';
import '../../host/change_address.dart';
import '../../host/edit_host_details.dart';
import '../../host/host_details.dart';
import '../../client_flow/screens/dashbaord/view/widget/amenities_map.dart';
import '../../client_flow/screens/dashbaord/view/widget/review_expanded_section.dart';
import '../../host/address_input.dart';
import '../../host/wah_score_widget.dart';
import '../../utils/app_images.dart';
import '../../utils/contacts_helper.dart';

class HostDashboard extends StatefulWidget {
  const HostDashboard({super.key});

  @override
  State<HostDashboard> createState() => _HostDashboardState();
}

class _HostDashboardState extends State<HostDashboard> {
  IotBloc iotBloc = IotBloc();
  // HostDashboardData? _hostDashboardData;
  HostDetails? _hostDetailsData;
  List<ReviewAllHost> reviewsAllHost = [];
  ReferralCoins? coins;
  // bool _isLoading = false;
  final String _error = '';
  final String _timeFilter = 'ALL';
  String? formatted;
  bool showEditContainer = true;
  List<String> selectedAmenities = [];
  bool isExpanded = false;
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  bool isAddressReadOnly = true;
  bool isScreenLoading = true;
  bool isShowSubmit = false;
  final Set<String> mandatoryAmenities = {
    "is_safe_space",
    "is_covid_free",
    "is_clean_and_hygiene",
  };

  var i = 0;
  GlobalStorage globalStorage = GetIt.instance();
  bool isInactive = false;
  String baseUrlImage = "";

  @override
  void initState() {
    super.initState();
    selectedAmenities.addAll(mandatoryAmenities);
    //  iotBloc.add(const GetHostDashboardData(woloo_id: "woloo_id"));
    iotBloc.add(const GetHostDetailsData(id: "woloo_id"));
    iotBloc.add(
      const GetReviewListEvent(
        pageNumber: 1,
        wolooId: 1,
      ),
    );
    // _fetchDashboardData();
    DateTime now = DateTime.now();
    formatted = DateFormat('h:mm a, d MMM yyyy').format(now);
  }

  @override
  void dispose() {
    addressController.dispose();
    cityController.dispose();
    mobileController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  void populateSelectedAmenitiesFromApi(HostDetails details) {
    final results = details.results;

    final List<String> tempSelected = [];

    void checkAndAdd(String key, dynamic field) {
      if (field != null && field.value.toString() == "1") {
        tempSelected.add(key);
      }
    }

    checkAndAdd("restaurant", results?.restaurant);
    checkAndAdd("is_clean_and_hygiene", results?.isCleanAndHygiene);
    checkAndAdd("segregated", results?.segregated);
    checkAndAdd("is_coffee_available", results?.isCoffeeAvailable);
    checkAndAdd("is_safe_space", results?.isSafeSpace);
    checkAndAdd("is_wheelchair_accessible", results?.isWheelchairAccessible);
    checkAndAdd("is_sanitary_pads_available", results?.isSanitaryPadsAvailable);
    checkAndAdd("is_makeup_room_available", results?.isMakeupRoomAvailable);
    checkAndAdd("is_sanitizer_available", results?.isSanitizerAvailable);
    checkAndAdd("is_feeding_room", results?.isFeedingRoom);
    checkAndAdd("is_washroom", results?.isWashroom);
    checkAndAdd("is_premium", results?.isPremium);
    checkAndAdd("is_franchise", results?.isFranchise);
    checkAndAdd("is_covid_free", results?.isCovidFree);

    selectedAmenities = tempSelected;
  }

  /// Builds a proper image URL by handling double slashes and normalizing the path
  String _buildImageUrl(String imagePath, String baseUrlApi) {
    if (imagePath.isEmpty) return '';

    // Remove leading slash from image path if present
    String normalizedPath =
        imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;

    // Ensure IMAGE_BASE_URL doesn't have trailing slash issues
    String baseUrl = baseUrlApi;
    if (baseUrl.endsWith('/')) {
      return '$baseUrl$normalizedPath';
    } else {
      return '$baseUrl/$normalizedPath';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double size = (screenWidth / 2) - 50;
    const double radius = 5;
    const double margin = 5;

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer(
          bloc: iotBloc,
          listener: (context, state) {
            print("aarati dssa $state");
            if (state is IotLoading) {
              EasyLoading.show(status: state.message);
            }
            /*  if (state is HostDashboardSuccess) {
              EasyLoading.dismiss();
              setState(() {
                _hostDashboardData = state.hostDashboardHome.dashboardData;
                coins = state.hostDashboardHome.coins;
              });
            }*/
            if (state is HostDetailsSuccess) {
              setState(() {
                _hostDetailsData = state.hostDetailsHome;
                addressController.text =
                    state.hostDetailsHome.results?.address ?? "";
                cityController.text = state.hostDetailsHome.results?.city ?? "";
                mobileController.text =
                    state.hostDetailsHome.results?.mobile ?? "";
                latitudeController.text =
                    state.hostDetailsHome.results?.lat ?? "";
                longitudeController.text =
                    state.hostDetailsHome.results?.lng ?? "";
                baseUrlImage = state.hostDetailsHome.results?.baseUrl ?? "";
              });
              EasyLoading.dismiss();
              populateSelectedAmenitiesFromApi(state.hostDetailsHome);

              final statusLabel =
              state.hostDetailsHome.results?.status?.label?.toUpperCase();

            /*  if (statusLabel != null && statusLabel == "INACTIVE") {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showInactiveDialog(context);
                });
              }*/

              setState(() {
                isInactive = statusLabel == "INACTIVE";
              });


            }
            if (state is IotError) {
              EasyLoading.dismiss();
              EasyLoading.showError(state.error);
            }

            if (state is GetReviewListLoading) {}

            if (state is IotUpdateSuccess) {
              EasyLoading.dismiss();

              EasyLoading.showSuccess(state.message);

              // Close edit mode
              setState(() {
                showEditContainer = true;
                isExpanded = false;
                isShowSubmit = false;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Details submitted successfully"),
                  duration: Duration(seconds: 2),
                ),
              );
              // 🔁 REFRESH HOST DETAILS
              iotBloc.add(const GetHostDetailsData(id: "woloo_id"));
            }

            if (state is GetReviewListSuccess) {
              final reviews = state.data.results.review;
              reviewsAllHost = state.data.results.review;
            }

            if (state is GetReviewListError) {}
          },
          builder: (context, state) {
            return Stack(
                children: [
            Column(   // ✅ directly use Column
            children: [
            Expanded(
                child: Column(children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 23.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Hello, ${_hostDetailsData?.results?.name}",
                                      style: AppTextStyle.font14bold,
                                    ),
                                  ],
                                ),
                                Text(
                                  formatted ?? '',
                                  style: AppTextStyle.font12,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "Your Facility",
                            style: AppTextStyle.font16bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      WahScore(
                          score: _hostDetailsData
                                  ?.results?.hostDashboardData?.wahScore ??
                              "",
                          imgUrl: _hostDetailsData
                                  ?.results?.hostDashboardData?.wahScoreImage ??
                              'https://woloo-prod.s3.ap-south-1.amazonaws.com/Cibil_Images/excellent.png',
                          reviewsHost: reviewsAllHost),
                      SizedBox(height: 16.h),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.textgreyColor,
                                  blurRadius: 4,
                                  offset: Offset(0, 1),
                                ),
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(
                                        7), // space around image
                                    decoration: const BoxDecoration(
                                      color: AppColors
                                          .lightCyanColor, // background color
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      AppImages.piggy_bank_img,
                                      height: 28,
                                      width: 28,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Total Points Earned",
                                    style: AppTextStyle.font14,
                                  ),
                                ],
                              ),

                              /// Right side value
                              Text(
                                _hostDetailsData
                                        ?.results?.hostDashboardTotalCoins
                                        ?.toString() ??
                                    "",
                                style: AppTextStyle.font14bold.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          )),
                      SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.textgreyColor,
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Photos",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () => _showPhotoUpdateDialog(context),
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightCyanColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Image.asset(
                                      AppImages.hostEditIcon,
                                      width: 14,
                                      height: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (_hostDetailsData?.results?.image != null &&
                                    _hostDetailsData!
                                        .results!.image!.isNotEmpty)
                                  Container(
                                    margin: const EdgeInsets.all(margin),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(radius),
                                      child: Image.network(
                                        _buildImageUrl(_hostDetailsData!
                                                .results?.image?.first ??
                                            '' , _hostDetailsData!
                                            .results!.baseUrl!),
                                        height: size,
                                        width: size,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return SizedBox(
                                            height: size,
                                            width: size,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            height: size,
                                            width: size,
                                            color: Colors.grey[300],
                                            child: Icon(
                                              Icons.image_not_supported,
                                              size: size * 0.5,
                                              color: Colors.grey[600],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    margin: const EdgeInsets.all(margin),
                                    child: SizedBox(
                                      height: size,
                                      width: size,
                                    ),
                                  ), // placeholder or loader

                                if ((_hostDetailsData?.results?.image?.length ??
                                        0) >
                                    1)
                                  Container(
                                    margin: const EdgeInsets.all(margin),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(radius),
                                      child: Image.network(
                                        _buildImageUrl(_hostDetailsData!
                                                .results?.image?.last ??
                                            '' , _hostDetailsData!
                                            .results!.baseUrl!),
                                        height: size,
                                        width: size,
                                        fit: BoxFit.fill,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return SizedBox(
                                            height: size,
                                            width: size,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            height: size,
                                            width: size,
                                            color: Colors.grey[300],
                                            child: Icon(
                                              Icons.image_not_supported,
                                              size: size * 0.5,
                                              color: Colors.grey[600],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    margin: const EdgeInsets.all(margin),
                                    child: SizedBox(
                                      height: size,
                                      width: size,
                                    ),
                                  ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Facility Details",
                                      style: AppTextStyle.font14bold),
                                  GestureDetector(
                                    onTap: () {
                                      print(
                                          "aarati on edit tap $showEditContainer");
                                      setState(() {
                                        print(
                                            "aarati on edit tap 1 $showEditContainer");
                                        showEditContainer = !showEditContainer;
                                        isShowSubmit = !isShowSubmit;
                                        print(
                                            "aarati on edit tap 2 $showEditContainer");
                                        if (!showEditContainer) {
                                          isExpanded = true;
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        color: AppColors.lightCyanColor,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Image.asset(
                                        AppImages.hostEditIcon,
                                        width: 14,
                                        height: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (showEditContainer)
                                Container(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 12),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            AppImages.hostLocationIcon,
                                            width: 20,
                                            height: 20, // optional tint
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              "${_hostDetailsData?.results?.address}, ${_hostDetailsData?.results?.city}",
                                              style: AppTextStyle.font10,
                                              maxLines: 3,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Image.asset(
                                            AppImages.hostContactIcon,
                                            width: 20,
                                            height: 20, // optional tint
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                              _hostDetailsData
                                                      ?.results?.mobile ??
                                                  "",
                                              style: AppTextStyle.font10,
                                              maxLines: 1),
                                        ],
                                      ),
                                      const SizedBox(height: 18),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Amenities",
                                            style: AppTextStyle.font14bold),
                                      ),
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Wrap(
                                          alignment: WrapAlignment
                                              .start, // 👈 left align
                                          runAlignment: WrapAlignment.start,
                                          spacing: 10,
                                          runSpacing: 10,
                                          children: _hostDetailsData?.results !=
                                                  null
                                              ? buildAmenityChips(
                                                  _hostDetailsData!.results!)
                                              : [],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                SingleChildScrollView(
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: GestureDetector(
                                            onTap: () async {
                                              final result =
                                                  await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      const IndiaLocationPicker(),
                                                ),
                                              );

                                              if (result != null) {
                                                setState(() {
                                                  cityController.text =
                                                      result['city'] ?? '';
                                                  addressController.text =
                                                      result['address'] ?? '';
                                                  latitudeController.text =
                                                      result['lat']
                                                              ?.toString() ??
                                                          '';
                                                  longitudeController.text =
                                                      result['lng']
                                                              ?.toString() ??
                                                          '';
                                                  isAddressReadOnly = false;
                                                });
                                              }
                                            },
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.only(top: 8),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 8),
                                              decoration: BoxDecoration(
                                                color: AppColors.lightCyanColor,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: const Text(
                                                "Select Address from Map",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 1),
                                        const Text(
                                          "City",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: TextField(
                                            controller: cityController,
                                            readOnly: true,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Enter your city",
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          "Address",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: TextField(
                                            controller: addressController,
                                            readOnly: isAddressReadOnly,
                                            maxLines: 4,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Enter your address",
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            /// LATITUDE
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Latitude",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade200,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12),
                                                    child: TextField(
                                                      controller:
                                                          latitudeController,
                                                      readOnly: false,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            "Enter latitude",
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(width: 12),

                                            /// LONGITUDE
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Longitude",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade200,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12),
                                                    child: TextField(
                                                      controller:
                                                          longitudeController,
                                                      readOnly: false,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            "Enter longitude",
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          "Mobile Number",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: TextField(
                                            controller: mobileController,
                                            readOnly: true,
                                            keyboardType: TextInputType.phone,
                                            maxLines: 1,
                                            maxLength: 10,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            decoration: const InputDecoration(
                                              counterText: "",
                                              border: InputBorder.none,
                                              hintText: "Enter mobile number",
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        const Text(
                                          "Amenities",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        const SizedBox(height: 8),
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () => setState(
                                                () => isExpanded = !isExpanded),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 10),
                                                      child: selectedAmenities
                                                              .isEmpty
                                                          ? const Text(
                                                              "Select",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                            )
                                                          : Wrap(
                                                              spacing: 8,
                                                              runSpacing: 8,
                                                              children:
                                                                  selectedAmenities
                                                                      .map(
                                                                          (key) {
                                                                final item =
                                                                    amenityMap[
                                                                        key]!;
                                                                return AmenityChip(
                                                                  title: item[
                                                                      "label"]!,
                                                                  iconPath: item[
                                                                      "icon"]!,
                                                                );
                                                              }).toList(),
                                                            ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Icon(
                                                    isExpanded
                                                        ? Icons
                                                            .keyboard_arrow_up
                                                        : Icons
                                                            .keyboard_arrow_down,
                                                    size: 28,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (isExpanded) ...[
                                          const SizedBox(height: 12),
                                          Column(
                                            children:
                                                amenityMap.keys.map((key) {
                                              final item = amenityMap[key]!;
                                              final isSelected =
                                                  selectedAmenities
                                                      .contains(key);
                                              final bool isMandatory =
                                                  mandatoryAmenities
                                                      .contains(key);
                                              return InkWell(
                                                onTap: isMandatory
                                                    ? null // 🚫 disable tap
                                                    : () {
                                                        setState(() {
                                                          isSelected
                                                              ? selectedAmenities
                                                                  .remove(key)
                                                              : selectedAmenities
                                                                  .add(key);
                                                        });
                                                      },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5,
                                                        vertical: 5),
                                                    child: Row(
                                                      children: [
                                                        Image.asset(
                                                            item["icon"]!,
                                                            width: 22,
                                                            height: 22,
                                                            color:
                                                                Colors.black),
                                                        const SizedBox(
                                                            width: 12),
                                                        Text(
                                                          item["label"]!,
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors
                                                                  .black),
                                                        ),
                                                        const Spacer(),
                                                        if (isSelected)
                                                          const Icon(
                                                              Icons.check,
                                                              color:
                                                                  Colors.black),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                        SizedBox(height: 25.h),
                                      ],
                                    ),
                                  ),
                                ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
              if (isShowSubmit)
                Container(
                  color: Colors.transparent,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightCyanColor,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (selectedAmenities.isEmpty) {
                          _showAmenityDialog(
                              context,
                              "Please add at least one amenity to continue.",
                              "Amenities Required");
                          return;
                        }

                        if (latitudeController.text.isEmpty) {
                          _showAmenityDialog(context, "Please enter latitude",
                              "Latitude Required");
                          return;
                        }

                        if (longitudeController.text.isEmpty) {
                          _showAmenityDialog(context, "Please enter longitude",
                              "Longitude Required");
                          return;
                        }

                        final amenitiesPayload =
                            buildAmenitiesPayload(selectedAmenities.toSet());

                        final request = UpdateHostRequest(
                          address: addressController.text.trim(),
                          mobile: mobileController.text.trim(),
                          city: cityController.text.trim(),
                          amenities: amenitiesPayload,
                          lat: latitudeController.text.trim(),
                          lng: longitudeController.text.trim(),
                        );

                        debugPrint("REQUEST BODY ---> ${request.toJson()}");

                        iotBloc.add(UpdateHostDetailsEvent(request));
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 75.h),
            ])), ],),
                  if (isInactive)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black54,
                        child: const Center(
                          child: AlertDialog(
                            title: Text("Facility Inactive"),
                            content: Text(
                                "Your facility is currently inactive. Please contact support."),
                            actions: [
                             /* TextButton(
                                onPressed: () {}, // 🚫 Do nothing
                                child: const Text("OK"),
                              ),*/
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
            );
          },
        ),
      ),
    );
  }

  void _showAmenityDialog(BuildContext context, String message, String header) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.white,
        title: Text(
          "$header",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        content: Text(
          "$message",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightCyanColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OKAY',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPhotoUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// HEADER TEXT
                const Text(
                  "Photo updates need to be verified by the Woloo team. "
                  "Raise a request and we’ll connect with you to update the photos.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 20),

                /// SEND REQUEST BUTTON


                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightCyanColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          ContactHelper.openWhatsApp(
                            SubcriptionConstant.wolooWhatsApp,
                            hostName: _hostDetailsData?.results?.name ??
                                'Unknown Host',
                            hostId: _hostDetailsData?.results?.id?.toString() ??
                                'N/A',
                          );
                        },
                        child: const Text(
                          "Request via WhatsApp",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightCyanColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          sendEmailDirectly(
                            emailId: SubcriptionConstant.wolooMail,
                            subject: "Photo Update",
                            message:
                                "I am a user with ${_hostDetailsData?.results?.id}  & ${_hostDetailsData?.results?.name}  want to upload more images for my host on Woloo",
                          );
                        },
                        child: const Text(
                          "Send Email",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// CANCEL BUTTON
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.black12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _callWolooSupport() async {
    const phoneNumber = "+912249741750"; // replace with actual number
    final Uri uri = Uri.parse("tel:$phoneNumber");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> sendEmailDirectly({
    required String emailId,
    required String subject,
    required String message,
  }) async {
    final emailUri = Uri(
      scheme: 'mailto',
      path: emailId,
      queryParameters: {
        'subject': subject,
        'body': message,
      },
    );

    await launchUrl(emailUri, mode: LaunchMode.externalApplication);
  }




}
