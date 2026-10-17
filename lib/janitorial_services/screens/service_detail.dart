import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/client_flow/widgets/CustomButton.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

import '../utils/app_images.dart';
import '../utils/app_strings.dart';

class ServiceDetail extends StatefulWidget {
  const ServiceDetail({super.key});

  @override
  State<ServiceDetail> createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomImageProvider(
              image: ServicesImages.banner,
              width: MediaQuery.of(context).size.width,
              height: 300,
              fit: BoxFit.cover,
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
                Container(
                  width: 145.w,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: AppColors.backgroundColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(4)),
                            child: const Icon(
                              Icons.remove,
                              size: 17,
                            )),
                      ),
                      Row(
                        children: [
                          CustomImageProvider(
                            image: ServicesImages.cart,
                            width: 20,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            "1",
                            style: AppTextStyle.font20bold,
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(4)),
                            child: const Icon(
                              Icons.add,
                              size: 17,
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              ServicesStrings.pestControl,
              style: AppTextStyle.font20bold,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ServicesStrings.pestControlPrice,
                  style: AppTextStyle.font32bold,
                ),
                const Custombutton(text: ServicesStrings.bookNow, width: 138)
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
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
            card(ServicesStrings.preServiceChecks,
                ServicesStrings.preServiceDetails, AppColors.backgroundColor),
            const SizedBox(
              height: 15,
            ),
            card(ServicesStrings.indoorUnit, ServicesStrings.indoorUnitDetails,
                AppColors.greyIcon),
            const SizedBox(
              height: 15,
            ),
            card(ServicesStrings.outdoorUnit,
                ServicesStrings.outdoorUnitDetails, AppColors.backgroundColor),
            const SizedBox(
              height: 15,
            ),
            card(ServicesStrings.finalCheckup,
                ServicesStrings.finalCheckupDetails, AppColors.greyIcon),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ServicesStrings.pestControlPrice,
                        style: AppTextStyle.font20bold,
                      ),
                      const Custombutton(
                          text: ServicesStrings.bookNow, width: 138)
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
                    color: Colors.black.withValues(alpha: 0.2), // Shadow color
                    spreadRadius: 1, // How wide the shadow should spread
                    blurRadius: 10, // The blur effect of the shadow
                    offset: const Offset(
                        0, 5), // Shadow offset, with y-offset for bottom shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CircleAvatar(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
            )
          ]),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                superVisorBottomSheet();
              },
              child: Custombutton(
                  height: 45.h, text: ServicesStrings.bookNow, width: 132.h),
            ),
            Custombutton(
                height: 45.h,
                color: AppColors.greyIcon,
                text: ServicesStrings.addToCart,
                width: 132.h)
          ],
        ),
      ),
    );
  }

  Widget card(String title, String subTitle, Color color) {
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
          Text(
            subTitle,
            textAlign: TextAlign.left,
            style: AppTextStyle.font10,
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
