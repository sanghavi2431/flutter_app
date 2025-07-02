import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:woloo_smart_hygiene/b2b_store/add_new_address_bottomsheet.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_bloc.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_event.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_state.dart';
import 'package:woloo_smart_hygiene/b2b_store/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/address.dart';
import 'package:woloo_smart_hygiene/b2b_store/update_address_bottomsheet.dart';
import 'package:woloo_smart_hygiene/enums/product_mode.dart';
import 'package:woloo_smart_hygiene/extensions/string_extension.dart';
import 'package:woloo_smart_hygiene/hygine_services/get_date_time_bottomsheet.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils///logger.dart';

import '../hygine_services/view/address_notifier.dart';

class AddressChangeBottomSheet extends StatefulWidget {
  const AddressChangeBottomSheet({
    super.key,
    this.productMode = ProductMode.productDetails,
    this.productId,
  });
  final ProductMode productMode;
  final String? productId;

  @override
  State<AddressChangeBottomSheet> createState() =>
      _AddressChangeBottomSheetState();
}

class _AddressChangeBottomSheetState extends State<AddressChangeBottomSheet> {
  final B2bStoreBloc _b2bStoreBloc = B2bStoreBloc();
  bool _isDataLoaded = false;
  AddressesData _addressesData = AddressesData();
  Map<String, bool> map = {};
  final box = GetStorage();
  @override
  void initState() {
    _b2bStoreBloc.add(const GetAddress());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: _b2bStoreBloc,
        listener: (context, state) {
          // print("dssa $state");
          if (state is B2BStoreLoading) {
            EasyLoading.show(status: state.message);
          }
          if (state is GetAddressSuccess) {
            EasyLoading.dismiss();
            setState(() {
              _addressesData = state.addressesData;
              map = Map.fromEntries(_addressesData.addresses!
                  .map((e) => MapEntry(e.id ?? "", false)));

              _isDataLoaded = true;
            });
          }

          if (state is B2BStoreError) {
            EasyLoading.dismiss();
            EasyLoading.showError(state.error);
            Navigator.pop(context);
          }
        },
        builder: (context, snapshot) {
          return !_isDataLoaded
              ? Container()
              : Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(40.r))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10.h,
                    children: [
                      const XBottmSheetTopDecor(),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        spacing: 10.w,
                        children: [
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: Image.asset(AppImages.addresses),
                          ),
                          Column(
                            // spacing: 10.h,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Addresses",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp),
                              ),
                              Text(
                                "Select or edit your addresses",
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                            itemCount: _addressesData.count,
                            itemBuilder: (c, i) {
                              final address = _addressesData.addresses![i];
                              return Card(
                                child: Container(
                                  height: 80,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      XDesignedRadioButton(
                                        onSelected: selectedAddress.value.id ==
                                            address.id,
                                        onTap: () {
                                          setState(() {
                                            // onChange(address.id ?? "");
                                            selectedAddress.value = address;
                                            setState(() {});
                                          });
                                        },
                                      ),
                                      const Spacer(
                                        flex: 1,
                                      ),
                                      Expanded(
                                        flex: 15,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              address.city.toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "${address.city} \n${address.postalCode}",
                                              style: TextStyle(fontSize: 12.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(
                                        flex: 1,
                                      ),
                                      EditButton(
                                        onTap: () async {
                                          final result =
                                              await showModalBottomSheet(
                                            isScrollControlled: true,
                                            isDismissible:
                                                true, // <-- Allow tap outside to dismiss
                                            enableDrag:
                                                true, // <-- Allow swipe down to dismiss

                                            backgroundColor: Colors
                                                .transparent, // Optional: if you want rounded corners to show correctly

                                            context: context,
                                            builder: (_) => Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: UpdateAddressBottomSheet(
                                                adress: address,
                                              ),
                                            ), //AddressBottomSheet
                                          );
                                          // if (result == null && result) {
                                          _b2bStoreBloc.add(const GetAddress());
                                          // }
                                        },
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          _b2bStoreBloc.add(DeleteAddress(
                                              addressId: address.id ?? ""));
                                          if (selectedAddress.value.id ==
                                              address.id) {
                                            selectedAddress.value = Addresses();
                                            box.remove('address');
                                          }

                                          //logger.w(box.read('address'));
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      LongLabeledButton(
                        label: "Select Address",
                        onTap: () {
                          if (selectedAddress.value.address1.isEmptyOrNull) {
                            EasyLoading.showError("Please select an address");
                            return;
                          }
                          _b2bStoreBloc
                              .add(SelectAddress(selectedAddress.value));
                          switch (widget.productMode) {
                            case ProductMode.productDetails:
                              {
                                Navigator.pop(context);

                                var jwt = box.read('login_jwt');
                                //logger.w(jwt);
                                box.write('address',
                                    selectedAddress.value.toString());
                              }

                              break;
                            case ProductMode.serviceDetails:
                              {
                                //logger.w("This Is Executing");
                                Navigator.pop(context);
                                final box = GetStorage();
                                box.write('address',
                                    selectedAddress.value.toString());

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
                                        productId: widget.productId ?? "",
                                      );
                                    });
                              }

                              break;
                          }
                        },
                      ),
                      LongLabeledButton(
                        label: "Add Address",
                        onTap: () async {
                          final result = await showModalBottomSheet(
                            isScrollControlled: true,
                            isDismissible:
                                true, // <-- Allow tap outside to dismiss
                            enableDrag: true, // <-- Allow swipe down to dismiss

                            backgroundColor: Colors
                                .transparent, // Optional: if you want rounded corners to show correctly

                            context: context,
                            builder: (_) =>
                                const AddressBottomSheet(), //AddressBottomSheet
                          );
                          // if (result == null && result) {
                          _b2bStoreBloc.add(const GetAddress());
                          // }
                        },
                      )
                    ],
                  ),
                );
        });
  }

  setAll(bool val) {
    if (_addressesData.addresses == null) return;
    map = Map.fromEntries(
        _addressesData.addresses!.map((e) => MapEntry(e.id ?? "", val)));
  }

  onChange(String val) {
    setState(() {
      setAll(false);
      map[val] = true;
    });
  }
}

class EditButton extends StatelessWidget {
  const EditButton({
    super.key,
    this.onTap,
  });
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 20,
        width: 20,
        child: Image.asset(AppImages.edit),
      ),
    );
  }
}

class XDesignedRadioButton extends StatelessWidget {
  const XDesignedRadioButton({
    super.key,
    this.onSelected = false,
    this.onTap,
  });
  final bool onSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all()),
        child: Center(
          child: Container(
            height: 12,
            width: 12,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(),
                color: onSelected ? Colors.green : null),
          ),
        ),
      ),
    );
  }
}

class XBottmSheetTopDecor extends StatelessWidget {
  const XBottmSheetTopDecor({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Spacer(),
        Expanded(
            child: Divider(
          thickness: 5,
        )),
        Spacer()
      ],
    );
  }
}
