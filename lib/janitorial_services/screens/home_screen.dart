import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

import '../../screens/common_widgets/image_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_textstyle.dart';
import '../model/product_model.dart';
import '../utils/app_images.dart';
import '../utils/app_strings.dart';
import '../widgets/header.dart';
import '../widgets/text_field.dart';
import 'service_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();

  List<String> slider = [
    ServicesImages.slider,
    ServicesImages.slider1,
    ServicesImages.slider2,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        actions: [
          CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.mediumGray,
            child: CustomImageProvider(
              image: ServicesImages.shoppingBag,
              width: 30,
              height: 30,
              // fit: BoxFit.none,
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ServicesStrings.home,
              style: AppTextStyle.font13w7,
            ),
            Text(
              ServicesStrings.address,
              style:
                  AppTextStyle.font13w7.copyWith(color: AppColors.dividerColor),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                        controller: controller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        hintText: ServicesStrings.searchProducts),
                  ),
                  //
                  // Container(
                  //   decoration: BoxDecoration(
                  //       color: AppColors.white,
                  //       borderRadius: BorderRadius.circular(30),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.black.withValues( alpha: 0.2), // Shadow color
                  //           spreadRadius: 1, // Spread radius
                  //           blurRadius: 10, // Blur radius
                  //           offset: const Offset(0, 5), // Offset for shadow
                  //         ),
                  //       ]
                  //   ),
                  //   child: CircleAvatar(
                  //     backgroundColor: AppColors.white,
                  //                 radius: 30,
                  //     child:  CustomImageProvider(
                  //      image: AppImages.filter,
                  //       width: 30,
                  //       height: 30,
                  //       // fit: BoxFit.none,
                  //     )
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 20),

              Text(
                "All Services",
                style: AppTextStyle.font20bold,
              ),
              const SizedBox(
                height: 20,
              ),
              //
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withValues(alpha: 0.2), // Shadow color
                        spreadRadius: 1, // Spread radius
                        blurRadius: 10, // Blur radius
                        offset: const Offset(0, 5), // Offset for shadow
                      ),
                    ]),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.2),
                  itemBuilder: (context, index) {
                    print("svg ${serviceList[index].icon!}");
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ServiceDetail()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: 0.2), // Shadow color
                                spreadRadius: 1, // Spread radius
                                blurRadius: 10, // Blur radius
                                offset: const Offset(0, 5), // Offset for shadow
                              ),
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // SvgPicture.string(serviceList[index].icon!,
                            //   width: 40,
                            //   height: 40,
                            //   // fit: fit,
                            // ),
                            // Image.asset(serviceList[index].icon!,
                            //  width: 30,
                            //   height: 30,
                            // ),
                            CustomImageProvider(
                              fit: BoxFit.contain,
                              image: serviceList[index].icon,
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              serviceList[index].name!,
                              style: AppTextStyle.font10bold,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: serviceList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              const Header(
                title: ServicesStrings.expressBooking,
              ),
              // Text(ServicesStrings.expressBooking,
              //  style: AppTextStyle.font20bold,
              // ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: slider.length,
                  shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomImageProvider(
                        image: slider[index],
                        width: 360,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Header(
                title: ServicesStrings.takeASneakPeek,
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomImageProvider(
                        image: ServicesImages.vertical,
                        // width: 360,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Header(
                title: ServicesStrings.customersLoveUs,
              ),

              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withValues(alpha: 0.2), // Shadow color
                        spreadRadius: 1, // Spread radius
                        blurRadius: 10, // Blur radius
                        offset: const Offset(0, 5), // Offset for shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(23),
                    gradient: const LinearGradient(
                        end: Alignment.bottomRight,

                        // begin: Alignment.bottomCenter,
                        // stops: [
                        //   0.8,
                        //   0.2
                        // ],
                        colors: [Color(0xffFFEB00), Colors.white])),
                height: 160,
                child: Swiper(
                  outer: false,
                  itemBuilder: (c, i) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width / 5,
                      //
                      // decoration: BoxDecoration(
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Colors.black.withValues( alpha: 0.2), // Shadow color
                      //         spreadRadius: 1, // Spread radius
                      //         blurRadius: 10, // Blur radius
                      //         offset: const Offset(0, 5), // Offset for shadow
                      //       ),
                      //     ],
                      //     borderRadius: BorderRadius.circular(23),
                      //     gradient: LinearGradient(
                      //         end: Alignment.bottomRight,
                      //
                      //         // begin: Alignment.bottomCenter,
                      //         stops: [
                      //           0.8,
                      //           0.2
                      //         ], colors: [
                      //       Color(0xffFFEB00),
                      //       Colors.white
                      //     ])),
                      // ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(
                            height: 30,
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                                textAlign: TextAlign.center,
                                ServicesStrings.gameChangingTestimonial,
                                style: AppTextStyle.font13w7

                                //   .copyWith(
                                //     color: AppColors.textgreyColor
                                //  ),
                                ),
                          ),

                          // Padding(padding: const EdgeInsets.only(top:6.0),child: Text("$i"),)
                        ],
                      ),
                    );
                  },
                  pagination:
                      const SwiperPagination(margin: EdgeInsets.all(5.0)),
                  itemCount: 5,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: CustomImageProvider(
                  image: ServicesImages.redeem,
                  // width: 360,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
