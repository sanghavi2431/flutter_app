import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
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
import '../core/local/global_storage.dart';
import '../hygine_services/view/address_notifier.dart';
import '../utils/app_color.dart';
import '../utils/app_constants.dart';
import 'widgets/map_widget.dart';

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
  B2bStoreBloc? _b2bStoreBloc;
  // B2bStoreBloc();
  bool _isDataLoaded = false;
  String selectedAddressId = "";
  AddressesData _addressesData = AddressesData();
  Map<String, bool> map = {};
  final box = GetStorage();

  late LocationPermission permission;
  late Position position;
  GlobalStorage globalStorage = GetIt.instance();
  bool serviceStatus = false;
  bool haspermission = false;
  double lat = 0.0, long = 0.0;

  //  addressStore = Add

  Addresses addressStore = Addresses();

  Future checkGps() async {
    // EasyLoading.show(
    //     status: MydashboardScreenConstants.LOCATION_FETCHING_TOAST.tr());
    serviceStatus = await Geolocator.isLocationServiceEnabled();
    if (serviceStatus) {
      permission = await Geolocator.checkPermission();

      debugPrint("permission $permission");

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // permission = await Geolocator.requestPermission();
        } else if (permission == LocationPermission.deniedForever) {
          openAppSettings();
          //  permission = await Geolocator.requestPermission();
        } else if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          haspermission = true;
          setState(() {});
        }
      } else if (permission == LocationPermission.deniedForever) {
        openAppSettings();
        //  permission = await Geolocator.requestPermission();
      } else if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        haspermission = true;
      }

      print("haspermission: $haspermission");

      if (haspermission) {
        await getLocation();
      }

      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      EasyLoading.showToast(MydashboardScreenConstants.GPS_DISABLED_TOAST.tr());
    }

    return haspermission;
  }

  getLocation() async {
    print("Getting Location");
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print("Position: $position");
    } catch (e) {
      print("Error getting location: $e");
    }

    //Output: 80.24599079
    if (kDebugMode) {
      print("long lat  ${position.latitude}");
    } //Output: 29.6593457

    long = position.longitude;
    lat = position.latitude;
    print("long lat  ${position.latitude}");

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
    );

    // StreamSubscription<Position> positionStream =
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      if (kDebugMode) {
        print(position.longitude);
        print(position.latitude); //Output: 29.6593457
      } //Output: 80.24599079

      // long = position.longitude.toString();
      // lat = position.latitude.toString();

      // kGooglePlex = CameraPosition(
      //   target: LatLng( position.latitude,position.longitude),
      //   zoom: 14.4746,
      // );
      setState(() {});

      // globalStorage.saveLattitude(accessLatitude: lat);
      // globalStorage.saveLongitude(accessLongitude: long);

      if (kDebugMode) {
        // print(" lattttt---- > ${globalStorage.getLatitude()}");
        //  print(" longitttt---- > ${globalStorage.getLongitude()}");
      }

      // _getAddressFromLatLng(position);
    });
  }

  @override
  void initState() {
    _b2bStoreBloc = BlocProvider.of<B2bStoreBloc>(context);

    //  BlocProvider.of(context)<B2bStoreBloc>();
    _b2bStoreBloc!.add(const GetAddress());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    addressStore = globalStorage.getAddress();
    print("addres from meesho ${selectedAddress.value.id}");
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

              // _b2bStoreBloc!.add(
              //     UpdateAddress(addressesData: _addressesData.addresses!.first!)
              //   );

              //  _addressesData.addresses!.forEach((element) {
              //   if (element.id == selectedAddressId ) {
              //      print("Selected Address: ${element.address1.toString()}");

              //      setState(() {
              //         // selectedAddress.value =

              //      });

              //       print("Selected in value  Address: ${selectedAddress.value.toString()}");
              //     // selectedAddressId = element.id!;
              //   }
              //  });

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
                            height: 50,
                            width: 50,
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
                        height: 350,
                        child: ListView.builder(
                            itemCount: _addressesData.count,
                            itemBuilder: (c, i) {
                              final address = _addressesData.addresses![i];

                              // if(address == selectedAddress.value){
                              //        selectedAddress.value = address;
                              // }

                              box.write(
                                  'address', selectedAddress.value.toString());

                              print("updfate adrees $address");
                              print("updfate adrees $selectedAddress");

                              // selectedAddress.value.id ==
                              //               address.id ?
                              //                 selectedAddress.value = address

                              //               : null;

                              return Card(
                                child: Container(
                                  // height: 80,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  // decoration: BoxDecoration(
                                  //   color: Colors.white,
                                  //   borderRadius: BorderRadius.circular(10),

                                  // ),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: AppColors.textgreyColor,
                                        blurRadius: 4,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      XDesignedRadioButton(
                                        onSelected: addressStore.id != null
                                            ? addressStore.id == address.id
                                            : selectedAddress.value.id ==
                                                address.id,
                                        onTap: () {
                                          setState(() {
                                            // onChange(address.id ?? "");
                                            var add =
                                                globalStorage.getAddress();
                                            add.addressName != null
                                                ? globalStorage.removeAddress()
                                                : null;

                                            selectedAddress.value = address;

                                            _b2bStoreBloc!.add(UpdateAddress(
                                                addressesData: address));

                                            box.write(
                                                'address',
                                                selectedAddress.value
                                                    .toString());

                                            // setState(() {});
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
                                              address.address1!,
                                              maxLines: 3,
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
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

                                      GestureDetector(
                                        onTap: () {
                                          globalStorage.removeAddress();

                                          _b2bStoreBloc!.add(DeleteAddress(
                                              addressId: address.id ?? ""));
                                          if (selectedAddress.value.id ==
                                              address.id) {
                                            selectedAddress.value = Addresses();
                                            box.remove('address');
                                          }
                                        },
                                        child: Image.asset(
                                          "assets/images/deleteicon.png",
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                      //   IconButton(
                                      //   icon: const Icon(Icons.delete),
                                      //   onPressed: () {

                                      //     //logger.w(box.read('address'));
                                      //   },
                                      // ),
                                      const SizedBox(
                                        width: 8,
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
                                            builder: (_) =>
                                                UpdateAddressBottomSheet(
                                              adress: address,
                                            ), //AddressBottomSheet
                                          ).then((value) {
                                               _b2bStoreBloc!.add(const GetAddress());
                                            
                                          }, );

                                          selectedAddressId = address.id!;
                                          // selectedAddress.value = result;
                                          // if (result == null && result) {
                                          _b2bStoreBloc!.add(const GetAddress());
                                            // Future.delayed(Duration(milliseconds: 1000), () {
                             
                              // });
                                          // }
                                        },
                                      ),
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
                          _b2bStoreBloc!
                              .add(SelectAddress(selectedAddress.value));
                          _b2bStoreBloc!.add(UpdateAddress(
                              addressesData: selectedAddress.value));
                          switch (widget.productMode) {
                            case ProductMode.productDetails:
                              {
                                Navigator.pop(context);

                                // var jwt = box.read('login_jwt');
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
                          await checkGps();

                          Placemark result = await Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) => MapWidget(
                              lat: lat,
                              long: long,
                            ),
                          ));

                          if (result != null) {
                            print(
                                "Result from MapWidget: ${result.subThoroughfare}");

                            // print( "Result from MapWidget: ${result.postalCode}");
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              isDismissible:
                                  true, // <-- Allow tap outside to dismiss
                              enableDrag:
                                  true, // <-- Allow swipe down to dismiss
                              backgroundColor: Colors
                                  .transparent, // Optional: if you want rounded corners to show correctly
                              context: context,
                              builder: (_) => AddressBottomSheet(
                                pincode: result.postalCode ?? '',
                                city: result.locality ?? '',
                                state: result.administrativeArea ?? '',
                                appartment: result.street ?? '',
                                flatNo: result.subThoroughfare ?? '',
                              ),
                              // );//AddressBottomSheet
                            );
                            // Handle the result from the MapWidget
                          }

                          // final result = await showModalBottomSheet(
                          //   isScrollControlled: true,
                          //   isDismissible:
                          //       true, // <-- Allow tap outside to dismiss
                          //   enableDrag: true, // <-- Allow swipe down to dismiss

                          //   backgroundColor: Colors
                          //       .transparent, // Optional: if you want rounded corners to show correctly

                          //   context: context,
                          //   builder: (_) =>
                          //       const AddressBottomSheet(), //AddressBottomSheet
                          // );
                          // if (result == null && result) {
                          _b2bStoreBloc!.add(const GetAddress());
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
