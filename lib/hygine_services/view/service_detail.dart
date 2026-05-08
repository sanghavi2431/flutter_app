import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/b2b_store/product_details.dart';
import 'package:woloo_smart_hygiene/enums/product_mode.dart';
import 'package:woloo_smart_hygiene/hygine_services/bloc/hygiene_service_bloc.dart';
import 'package:woloo_smart_hygiene/hygine_services/bloc/hygiene_service_event.dart';
import 'package:woloo_smart_hygiene/hygine_services/bloc/hygiene_service_state.dart';
import 'package:woloo_smart_hygiene/hygine_services/get_date_time_bottomsheet.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:woloo_smart_hygiene/utils/logger.dart';
import 'package:woloo_smart_hygiene/b2b_store/address_change_bottomsheet.dart';

import '../../janitorial_services/utils/app_images.dart';
import '../../janitorial_services/utils/app_strings.dart';
import '../../utils/text_to_line_converter.dart';
import '../model/hygiene_services.dart';

class ServiceDetail extends StatefulWidget {
  final String productId;
  const ServiceDetail({super.key, required this.productId});

  @override
  State<ServiceDetail> createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
  final HygieneServiceBloc _hygieneServiceBloc = HygieneServiceBloc();
  bool _isDataLoaded = false;
  // hygiene.? _hygieneService;
  Product? _hygieneService;
  List<PestControlService> services = [];
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    _hygieneServiceBloc.add(HygieneServiceReqById(
      productId: widget.productId,
    ));
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
          if (state is HygieneServiceProductSuccess) {
            EasyLoading.dismiss();
            setState(() {
              _hygieneService = state.dashboardData;
              services = parseServices(_hygieneService?.description ?? "");
              _isDataLoaded = true;
            });
          }
          if (state is HygieneServiceError) {
            EasyLoading.dismiss();
            EasyLoading.showError(state.error);
            Navigator.pop(context);
          }
        },
        builder: (context, snapshot) {
          return !_isDataLoaded
              ? Container()
              : Scaffold(
                  backgroundColor: AppColors.white,
                  appBar: AppBar(
                    backgroundColor: AppColors.white,
                    leading: const BackButton(),
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // CustomImageProvider(
                            //   image: _hygieneService?.images.first,
                            //   width: MediaQuery.of(context).size.width,
                            //   height: 300,
                            //   fit: BoxFit.cover,
                            // ),
                            SizedBox(
                              height: 300,
                              width: MediaQuery.of(context).size.width,
                              child:
                                  //  _hygieneService!.images.isNotEmpty
                                  //     ? CarouselView(
                                  //         itemExtent: 1,
                                  //         children: List.generate(
                                  //           _hygieneService?.images.length ?? 0,
                                  //           (index) {
                                  //             logger.w(
                                  //                 "Images: ${_hygieneService?.images}");
                                  //             final image =
                                  //                 _hygieneService?.images[index];
                                  //             return CachedNetworkImage(
                                  //                 imageUrl: image?.url ?? "");
                                  //           },
                                  //         ),
                                  //       )
                                  //     :
                                  CachedNetworkImage(
                                      imageUrl:
                                          _hygieneService?.thumbnail ?? ""),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomImageProvider(
                                  image: ServicesImages.stars,
                                ),
                                // Container(
                                //   width: 145.w,
                                //   padding: const EdgeInsets.symmetric(
                                //       horizontal: 16, vertical: 3),
                                //   decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(7),
                                //       color: AppColors.backgroundColor),
                                //   child: Row(
                                //     mainAxisAlignment:
                                //         MainAxisAlignment.spaceBetween,
                                //     children: [
                                //       InkWell(
                                //         onTap: () {},
                                //         child: Container(
                                //             decoration: BoxDecoration(
                                //                 border: Border.all(),
                                //                 borderRadius:
                                //                     BorderRadius.circular(4)),
                                //             child: const Icon(
                                //               Icons.remove,
                                //               size: 17,
                                //             )),
                                //       ),
                                //       Row(
                                //         children: [
                                //           CustomImageProvider(
                                //             image: ServicesImages.cart,
                                //             width: 20,
                                //           ),
                                //           const SizedBox(
                                //             width: 4,
                                //           ),
                                //           Text(
                                //             "1",
                                //             style: AppTextStyle.font20bold,
                                //           ),
                                //         ],
                                //       ),
                                //       InkWell(
                                //         onTap: () {},
                                //         child: Container(
                                //             decoration: BoxDecoration(
                                //                 border: Border.all(),
                                //                 borderRadius:
                                //                     BorderRadius.circular(4)),
                                //             child: const Icon(
                                //               Icons.add,
                                //               size: 17,
                                //             )),
                                //       )
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              _hygieneService?.title ?? "N/A",
                              style: AppTextStyle.font20bold,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _hygieneService?.variants.first
                                          .calculatedPrice.calculatedAmount
                                          .toString() ??
                                      "N/A",
                                  style: AppTextStyle.font32bold,
                                ),
                                if (!isOpen)
                                  ShortLabelledButton(
                                    label: "Book Now",
                                    onTap: () {
                                      isOpen = !isOpen;
                                      setState(() {});
                                    },
                                  ),
                                if (isOpen)
                                  GestureDetector(
                                      onTap: () {
                                        isOpen = !isOpen;
                                        setState(() {});
                                      },
                                      child: const Icon(Icons.arrow_upward))
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(),
                            //add a row to show the variant of the product in listview builder
                            Visibility(
                              visible: isOpen,
                              child: SizedBox(
                                height: 160.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      _hygieneService?.variants.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: Column(children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(25.r)),
                                          child: SizedBox(
                                            height: 60.h,
                                            width: 60.w,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  _hygieneService!.thumbnail ??
                                                      "",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          _hygieneService
                                                  ?.variants[index].title ??
                                              "N/A",
                                          // style: AppTextStyle.font16regular,
                                        ),
                                        Text(
                                          _hygieneService
                                                  ?.variants[index]
                                                  .calculatedPrice
                                                  .calculatedAmount
                                                  .toString() ??
                                              "N/A",
                                          // style: AppTextStyle.font14regular,
                                        ),
                                        ShortLabelledButton(
                                          label: "Book Now",
                                          onTap: () {
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                isDismissible:
                                                    true, // <-- Allow tap outside to dismiss
                                                enableDrag:
                                                    true, // <-- Allow swipe down to dismiss

                                                backgroundColor: Colors
                                                    .transparent, // Optional: if you want rounded corners to show correctly

                                                context: context,
                                                builder: (context) {
                                                  return GetTimeScheduleBottomSheet(
                                                    productId: _hygieneService!
                                                        .variants[index].id,
                                                  );
                                                });
                                          },
                                        )
                                      ]),
                                    );
                                  },
                                ),
                                // child: ListView.builder(
                                //   scrollDirection: Axis.horizontal,
                                //   itemCount:
                                //       _hygieneService?.variants.length ?? 0,
                                //   itemBuilder: (context, index) {
                                //     return GestureDetector(
                                //       onTap: () {
                                //         // Navigator.push(
                                //         //   context,
                                //         //   MaterialPageRoute(
                                //         //     builder: (context) => ProductDetailsScreen(
                                //         //       productData: products,
                                //         //     ),
                                //         //   ),
                                //         // );
                                //       },
                                //       child: Container(
                                //         padding: EdgeInsets.symmetric(
                                //             horizontal: 10.w),
                                //         decoration: BoxDecoration(
                                //             color: AppColors.themeBackground,
                                //             borderRadius:
                                //                 BorderRadius.circular(25.r),
                                //             boxShadow: const [
                                //               BoxShadow(
                                //                 color: AppColors.greyShadowColor,
                                //                 blurRadius: 5.0,
                                //                 spreadRadius: 0.5,
                                //                 offset: Offset(0, 2),
                                //               ),
                                //               BoxShadow(
                                //                 color: AppColors.greyShadowColor,
                                //                 blurRadius: 5.0,
                                //                 spreadRadius: 0.5,
                                //                 offset: Offset(0, -1),
                                //               ),
                                //             ]),
                                //         child: Column(
                                //           spacing: 2.h,
                                //           crossAxisAlignment:
                                //               CrossAxisAlignment.start,
                                //           mainAxisSize: MainAxisSize.min,
                                //           children: [
                                //             ClipRRect(
                                //               borderRadius: BorderRadius.vertical(
                                //                   top: Radius.circular(25.r)),
                                //               child: SizedBox(
                                //                 height: 60.h,
                                //                 width: double.infinity,
                                //                 // child:
                                //                 // Image.network(
                                //                 //   _hygieneService!.thumbnail ??
                                //                 //       '',
                                //                 //   fit: BoxFit.contain,
                                //                 // ),
                                //               ),
                                //             ),
                                //             Text(
                                //               _hygieneService!
                                //                       .variants[index].title ??
                                //                   "",
                                //               style: TextStyle(
                                //                   fontSize: 10.5.sp,
                                //                   fontWeight: FontWeight.bold),
                                //               maxLines: 1,
                                //               overflow: TextOverflow.ellipsis,
                                //             ),
                                //             // Text(
                                //             //   // products.subtitle ??
                                //             //   "",
                                //             //   style: TextStyle(
                                //             //     fontSize: 8.sp,
                                //             //     color: AppColors.textgreyColor,
                                //             //     fontWeight: FontWeight.bold,
                                //             //   ),
                                //             // ),
                                //             // Row(
                                //             //   children: List.generate(
                                //             //     5,
                                //             //     (i) => Container(
                                //             //         margin:
                                //             //             EdgeInsets.only(right: 2.w),
                                //             //         height: 10.h,
                                //             //         width: 10.w,
                                //             //         child: Image.asset(
                                //             //             AppImages.stars)),
                                //             //   ),
                                //             // ),
                                //             Row(
                                //               children: [
                                //                 Text(
                                //                   "Rs. ${_hygieneService!.variants[index].calculatedPrice.calculatedAmount.toString()}",
                                //                   style: TextStyle(
                                //                     fontSize: 13.sp,
                                //                     fontWeight: FontWeight.bold,
                                //                   ),
                                //                 ),
                                //                 const Spacer(),
                                //                 const AddToCartButton()
                                //               ],
                                //             )
                                //           ],
                                //         ),
                                //       ),
                                //     );
                                //   },
                                // ),
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              ServicesStrings.aboutTheService,
                              style: AppTextStyle.font18bold,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              spacing: 15.h,
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                  services.length,
                                  (i) => card(
                                      "${services[i].icon} ${services[i].title}",
                                      services[i].description,
                                      i % 2 == 0
                                          ? AppColors.greyIcon
                                          : AppColors.backgroundColor)),
                            ),

                            // card(
                            //     services.first.icon + services.first.title,
                            //     services.first.description,
                            //     AppColors.backgroundColor),
                            // const SizedBox(
                            //   height: 15,
                            // ),
                            // card(
                            //     ServicesStrings.indoorUnit,
                            //     ServicesStrings.indoorUnitDetails,
                            //     AppColors.greyIcon),
                            // const SizedBox(
                            //   height: 15,
                            // ),
                            // card(
                            //     ServicesStrings.outdoorUnit,
                            //     ServicesStrings.outdoorUnitDetails,
                            //     AppColors.backgroundColor),
                            // const SizedBox(
                            //   height: 15,
                            // ),
                            // card(
                            //     ServicesStrings.finalCheckup,
                            //     ServicesStrings.finalCheckupDetails,
                            //     AppColors.greyIcon),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: const BoxDecoration(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CustomImageProvider(
                                    image: ServicesImages.amc,
                                    height: 134,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Text(
                                    ServicesStrings.upgradeToAmc,
                                    style: AppTextStyle.font14bold,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  CustomImageProvider(
                                    image: ServicesImages.stars,
                                    width: 100,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        ServicesStrings.pestControlPrice,
                                        style: AppTextStyle.font20bold,
                                      ),
                                      // const Custombutton(
                                      //     text: ServicesStrings.bookNow,
                                      //     width: 138)
                                      ShortLabelledButton(
                                        label: "Book Now",
                                        onTap: () {
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              isDismissible:
                                                  true, // <-- Allow tap outside to dismiss
                                              enableDrag:
                                                  true, // <-- Allow swipe down to dismiss

                                              backgroundColor: Colors
                                                  .transparent, // Optional: if you want rounded corners to show correctly

                                              context: context,
                                              builder: (context) {
                                                return const AddressChangeBottomSheet(
                                                  productMode: ProductMode
                                                      .serviceDetails,
                                                );
                                              });
                                        },
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              ServicesStrings.ratingsReviews,
                              style: AppTextStyle.font13w7,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
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
                                        5), // Shadow offset, with y-offset for bottom shadow
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
                                      const CircleAvatar(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Name",
                                            style: AppTextStyle.font14w7,
                                          ),
                                          const SizedBox(
                                            width: 300,
                                            child: Divider(
                                                // thickness: 3,
                                                // color: Colors.black,
                                                ),
                                          ),
                                          Text(
                                            "Posted on",
                                            style: AppTextStyle.font10,
                                          ),
                                        ],
                                      ),
                                      CustomImageProvider(
                                        image: ServicesImages.star,
                                        width: 20,
                                        height: 20,
                                      )
                                    ],
                                  ),
                                  const Divider(),
                                  Text(
                                    "Review",
                                    style: AppTextStyle.font10,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 70.h,
                            )
                          ]),
                    ),
                  ),
                  // bottomNavigationBar: Container(
                  //   height: 60.h,
                  //   padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       GestureDetector(
                  //         onTap: () {
                  //           superVisorBottomSheet();
                  //         },
                  //         child: Custombutton(
                  //             height: 45.h,
                  //             text: ServicesStrings.bookNow,
                  //             width: 132.h),
                  //       ),
                  //       Custombutton(
                  //           height: 45.h,
                  //           color: AppColors.greyIcon,
                  //           text: ServicesStrings.addToCart,
                  //           width: 132.h)
                  //     ],
                  //   ),
                  // ),
                  // bottomSheet: XDecoratedBox(
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: LongLabeledButton(
                  //           onTap: () {
                  //             // showCartBottomSheet(context);
                  //             Navigator.pop(context);
                  //             showModalBottomSheet(
                  //                 context: context,
                  //                 builder: (c) {
                  //                   return const ReviewOrderBottomsheet();
                  //                 });
                  //           },
                  //           label: "Buy Now",
                  //         ),
                  //       ),
                  //       const SizedBox(
                  //         width: 20,
                  //       ),
                  //       Expanded(
                  //         child: LongLabeledButton(
                  //           onTap: () {
                  //             // addToCart(context);
                  //           },
                  //           label: "Add to Cart",
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                );
        });
  }

  Widget card(String title, List<String> subtitles, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(20.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: AppTextStyle.font14w7,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              subtitles.length,
              (i) => Text(
                subtitles[i],
                textAlign: TextAlign.left,
                style: AppTextStyle.font10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _selectedValue = 1;

  superVisorBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return Container(
            height: 560,
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(80.0),
                topRight: Radius.circular(80.0),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: Text(
                        ServicesStrings.home,
                        style: AppTextStyle.font16bold,
                      ),
                      subtitle: Text(
                        ServicesStrings.fullAddress,
                        style: AppTextStyle.font12bold,
                      ),
                      leading: Radio(
                        value: 1,
                        groupValue: _selectedValue,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(
                        ServicesStrings.office,
                        style: AppTextStyle.font16bold,
                      ),
                      subtitle: Text(
                        ServicesStrings.fullAddress,
                        style: AppTextStyle.font12bold,
                      ),
                      leading: Radio(
                        value: 2,
                        groupValue: _selectedValue,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(
                        ServicesStrings.other,
                        style: AppTextStyle.font16bold,
                      ),
                      subtitle: Text(
                        ServicesStrings.fullAddress,
                        style: AppTextStyle.font12bold,
                      ),
                      leading: Radio(
                        value: 3,
                        groupValue: _selectedValue,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
