import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/b2b_store/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/ecom.dart';
import 'package:woloo_smart_hygiene/enums/product_mode.dart';
import 'package:woloo_smart_hygiene/hygine_services/bloc/hygiene_service_bloc.dart';
import 'package:woloo_smart_hygiene/hygine_services/bloc/hygiene_service_event.dart';
import 'package:woloo_smart_hygiene/hygine_services/bloc/hygiene_service_state.dart';
import 'package:woloo_smart_hygiene/hygine_services/view/service_detail.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/list.dart';
import 'package:woloo_smart_hygiene/utils/logger.dart';

import '../../hygine_services/model/hygiene_services.dart';
import '../../widgets/nav_bar.dart';
import '../model/hygiene_services.dart' as hygiene;

class HygieneServicesScreen extends StatefulWidget {
  const HygieneServicesScreen({super.key});

  @override
  State<HygieneServicesScreen> createState() => _HygieneServicesScreenState();
}

class _HygieneServicesScreenState extends State<HygieneServicesScreen> {
  final HygieneServiceBloc _hygieneServiceBloc = HygieneServiceBloc();
  bool _isDataLoaded = false;
  hygiene.HygieneService? _hygieneService;
  @override
  void initState() {
    _hygieneServiceBloc.add(HygieneServiceReq());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: _hygieneServiceBloc,
        listener: (context, state) {
          // print("dssa $state");
          if (state is HygieneServiceLoading) {
            EasyLoading.show(status: state.message);
          }
          if (state is HygieneServiceSuccess) {
            EasyLoading.dismiss();
            setState(() {
              _hygieneService = state.dashboardData;
              print(_hygieneService);
              _isDataLoaded = true;
            });
          }
          if (state is HygieneServiceError) {
            EasyLoading.dismiss();
            EasyLoading.showError(state.error);
          }
        },
        builder: (context, snapshot) {
          return !_isDataLoaded
              ? Container()
              : Scaffold(
                  appBar: const EComAppbar(
                    productMode: ProductMode.serviceDetails,
                    textFieldHintText: 'Search Services',
                  ),
                  // bottomNavigationBar: const XBottomBar(),
                  body: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10.sp,
                      children: [
                        SizedBox(
                          height: 10.sp,
                        ),
                        Text(
                          'All Services',
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.bold),
                        ),
                        XDecoratedBox(
                          child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _hygieneService!.products.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 1,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemBuilder: (c, i) {
                                final category = _hygieneService!.products[i];
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ServiceDetail(
                                                    productId: _hygieneService!
                                                        .products[i].id,
                                                  )));
                                    },
                                    child: ServicesTile(category: category));
                              }),
                        ),
                        Text(
                          'Express Booking',
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 163.h,
                          child: ListView.separated(
                              separatorBuilder: (c, i) => const SizedBox(
                                    width: 10,
                                  ),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: banners.length,
                              itemBuilder: (c, i) {
                                final banner = banners[i];
                                return SizedBox(
                                  height: 163.h,
                                  width: 300.w,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.r),
                                      child: Image.asset(
                                        banner.imageUrl,
                                        fit: BoxFit.fill,
                                      )),
                                );
                              }),
                        ),
                        Text(
                          'Take a Sneak Peak',
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 221.h,
                          child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    width: 10,
                                  ),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: 6,
                              itemBuilder: (c, i) {
                                return Stack(
                                  children: [
                                    SizedBox(
                                      height: 221.h,
                                      width: 114.w,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          child: Image.asset(
                                              AppImages.pestControlImage,
                                              fit: BoxFit.cover)),
                                    ),
                                    Positioned(
                                      top: 105.h,
                                      right: 30.w,
                                      child: const Icon(
                                        Icons.play_arrow_rounded,
                                        color: AppColors.buttonYellowColor,
                                        size: 60,
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                        Text(
                          'Customers Love Us',
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.bold),
                        ),
                        Stack(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  height: 134.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                        colors: [
                                          AppColors.buttonYellowColor,
                                          AppColors.buttonYellowColor
                                              .withValues(alpha: 0.2),
                                          Colors.white
                                        ],
                                        stops: const [
                                          0.0,
                                          0.8,
                                          1.0
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 8,
                                    children: [
                                      Text(
                                        "This is game changing! Their Services are unmatched! Highly recommended to anyone who is looking for hygiene services for their business!",
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "Sasha Jain",
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.pieDataColor3),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.accepCardBgColor,
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(0, 3),
                                          color: AppColors.appBarTitleColor
                                              .withValues(alpha: 0.5),
                                          blurRadius: 16,
                                          spreadRadius: 0),
                                    ]),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                      5,
                                      (i) => SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Image.asset(AppImages.stars))),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: (MediaQuery.sizeOf(context).width / 2) - 60,
                              right:
                                  (MediaQuery.sizeOf(context).width / 2) - 60,
                              child: SizedBox(
                                height: 10,
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (c, i) => CircleAvatar(
                                          backgroundColor: i == 0
                                              ? AppColors.black
                                              : AppColors.accepCardBgColor,
                                          radius: 6,
                                        ),
                                    separatorBuilder: (c, i) => const SizedBox(
                                          width: 5,
                                        ),
                                    itemCount: 5),
                              ),
                            )
                          ],
                        ),
                        Image.asset(
                          AppImages.redeem,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          height: 60,
                        )
                      ],
                    ),
                  ),
                );
        });
  }
}

class ServicesTile extends StatelessWidget {
  const ServicesTile({
    super.key,
    required this.category,
  });

  final Product category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      width: 120.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 30,
              width: 30,
              child: CachedNetworkImage(
                imageUrl: category.thumbnail,
                fit: BoxFit.fill,
              )),
          Text(
            category.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
