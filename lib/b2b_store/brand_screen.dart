import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/b2b_store/cart.dart';

import '../utils/app_color.dart';
import '../utils/app_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'bloc/b2b_store_bloc.dart';
import 'bloc/b2b_store_event.dart';
import 'common_collections.dart';
import 'ecom.dart';
import 'models/product_collections.dart';
import 'search.dart';

class BrandScreen extends StatefulWidget {
  B2BStoreHomePage? b2bStoreHomePage;

  BrandScreen({super.key, this.b2bStoreHomePage});

  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  final B2bStoreBloc _b2bStoreBloc = B2bStoreBloc();
  // B2BStoreHomePage? _b2bStoreHomePage;
  bool _isDataLoaded = false;
  List<XYProduct> products = [];
  final searchTEC = TextEditingController();
  _refresh() {
    _b2bStoreBloc.add(const Refresh(slug: "collection_id"));
  }

  @override
  void initState() {
    _b2bStoreBloc.add(const Refresh(slug: "collection_id"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EComAppbar(
          controller: searchTEC,
          onCartTap: () async {
            final value = await Navigator.push(
                context, MaterialPageRoute(builder: (c) => const CartScreen()));
            if (value != null && value == 'refresh') {
              _refresh();
            } else {
              _refresh();
            }
          },
          onChanged: (value) {
            if (value.isEmpty) {
              products = widget.b2bStoreHomePage!.productCollections.products;
            } else {
              products = widget.b2bStoreHomePage!.productCollections.products
                  .where((e) =>
                      e.title?.toLowerCase().contains(value.toLowerCase()) ??
                      false)
                  .toList();
              //logger.w("Value: $value Products: ${products.length}");
            }

            setState(() {});
          },
          cartValue: _isDataLoaded
              ? widget.b2bStoreHomePage?.cartData.cart.items?.length ?? 0
              : 0,
          onTap: () async {
            final value = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => SearchScreen(
                          suggestions: widget
                                  .b2bStoreHomePage?.productCollections.products
                                  .map((e) => e.title ?? "")
                                  .toList() ??
                              [],
                        )));
            if (value != null && value == 'refresh') {
              _refresh();
            }
          }),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          spacing: 10.h,
          children: [
            Row(
              children: [
                Text("Top Brands",
                    style: TextStyle(
                        fontSize: 20.sp, fontWeight: FontWeight.bold)),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, 'refresh');
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 10,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        MyTaskListConstants.BACK.tr(),
                        style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.greyCircleColor,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              ],
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
              itemCount: widget.b2bStoreHomePage!.topBrands.collections!.length,
              //          >
              //     6
              // ? 6
              // : _b2bStoreHomePage!.topBrands.collections!
              //     .length, //.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    final value = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => CommonCollectionsScreen(
                                  id: widget.b2bStoreHomePage!.topBrands
                                          .collections![index].id ??
                                      "",
                                  slug: "collection_id",

                                  // products: _b2bStoreHomePage!
                                  //     .productCollections
                                  //     .products,
                                )));
                    if (value != null && value == 'refresh') {
                      _refresh();
                    }
                  },
                  child: BrandsGrid(
                    imageUrl: widget.b2bStoreHomePage!.topBrands
                            .collections![index].metadata?.image ??
                        '',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
