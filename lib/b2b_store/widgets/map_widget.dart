import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:woloo_smart_hygiene/client_flow/widgets/CustomButton.dart';

import '../../client_flow/screens/dashbaord/view/widget/searchTextfield.dart';
import '../../utils/app_constants.dart';
import '../add_new_address_bottomsheet.dart';
import 'package:http/http.dart' as http;

class MapWidget extends StatefulWidget {
  final double? lat, long;
  const MapWidget({super.key, this.lat, this.long});

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  bool serviceStatus = false;
  bool haspermission = false;
  bool _isBottomSheetShown = false;
  Timer? _debounce;
  String? loc = "";

  checkGps() async {
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
        }
      } else if (permission == LocationPermission.deniedForever) {
        openAppSettings();
        //  permission = await Geolocator.requestPermission();
      } else if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        haspermission = true;
      }

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
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print("Position: $position");
    } catch (e) {
      print("Error getting location: $e");
    }

    //Output: 80.24599079
    if (kDebugMode) {
      print(position.latitude);
    } //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

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

      kGooglePlex = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.4746,
      );
      setState(() {});

      // globalStorage.saveLattitude(accessLatitude: lat);
      // globalStorage.saveLongitude(accessLongitude: long);

      if (kDebugMode) {
        // print(" lattttt---- > ${globalStorage.getLatitude()}");
        //  print(" longitttt---- > ${globalStorage.getLongitude()}");
      }

      print("lat: ${position.latitude}, long: ${position.longitude}");

      // _getAddressFromLatLng(position);
    });
  }

  Placemark? place;

  Future<void> getAddressFromLatLng(double latitude, double longitude) async {
    await placemarkFromCoordinates(latitude, longitude)
        .then((List<Placemark> placemarks) {
      place = placemarks[0];
      print("Adress$placemarks ");
      setState(() {
        // _currentAddress =
        // '${place.name},${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.administrativeArea},${place.postalCode}';

        // debugPrint("address - $_currentAddress");
        // place.postalCode;

        // globalStorage.saveLocation(accessLocation: _currentAddress ?? '');
        // location = globalStorage.getLocation();

        // debugPrint("locccccc --- > ${globalStorage.getLocation()}");
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  GoogleMapController? _mapController;
  LatLng _initialPosition = const LatLng(19.0760, 72.8777); // Mumbai as default
  Set<Marker> _markers = {};

  LatLng? target;

  Future<void> _moveCameraToPlace(String placeName) async {
    var googleApiKey = "AIzaSyCkPmUz4UlRdzcKG9gniW9Qfrgzsjhnb_4";
    
    // Get current locale language code for Google API
    final locale = context.locale;
    final languageCode = locale.languageCode; // 'en', 'hi', or 'mr'
    
    // Get place_id using Autocomplete API
    final autocompleteUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&language=$languageCode&key=${googleApiKey}';
    final autocompleteResponse = await http.get(Uri.parse(autocompleteUrl));
    final autocompleteData = jsonDecode(autocompleteResponse.body);
    final placeId = autocompleteData['predictions'].first['place_id'];

    print("placed id: $placeId");

    // Get lat/lng using Place Details API
    final detailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&language=$languageCode&key=${googleApiKey}';
    final detailsResponse = await http.get(Uri.parse(detailsUrl));

    print("address json ${jsonDecode(detailsResponse.body)}");
    final location =
        jsonDecode(detailsResponse.body)['result']['geometry']['location'];

    final lat = location['lat'];
    final lng = location['lng'];

    target = LatLng(lat, lng);

    // Move camera and add marker
    // _mapController?.animateCamera(
    //   CameraUpdate.newLatLngZoom(target, 15),
    // );

    setState(() {
      // _markers.clear();

      // _markers.add(Marker(
      //   markerId: MarkerId('selected-location'),
      //   position: target,
      //   infoWindow: InfoWindow(title: placeName),
      // ));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // checkGps();
    kGooglePlex = CameraPosition(
      target: LatLng(
          widget.lat ?? 37.42796133580664, widget.long ?? -122.085749655962),
      zoom: 14.4746,
    );
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition? kGooglePlex;
  // final Set<Marker> _markers = {};
  final MarkerId markerId = const MarkerId("myMarker");
  Future _onCameraMove(CameraPosition position) async {
    setState(() {
      _markers.removeWhere((marker) => marker.markerId == markerId);
      _markers.add(
        Marker(
          markerId: markerId,
          position: position.target,
        ),
      );
    });

    getAddressFromLatLng(position.target.latitude, position.target.longitude);

    //  await showModalBottomSheet(
    //                         isScrollControlled: true,
    //                         isDismissible:
    //                             true, // <-- Allow tap outside to dismiss
    //                         enableDrag: true, // <-- Allow swipe down to dismiss

    //                         backgroundColor: Colors
    //                             .transparent, // Optional: if you want rounded corners to show correctly

    //                         context: context,
    //                         builder: (_) =>
    //                             const AddressBottomSheet(), //AddressBottomSheet
    //                       );
  }
  //  CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 180,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              const Text(
                'Drag the map to select a location',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 55,
                child: Text(
                    overflow: TextOverflow.ellipsis,
                    '${place?.street ?? ''}  ${place?.locality ?? ''},  ${place?.administrativeArea ?? ''},',
                    style: const TextStyle(fontSize: 16, color: Colors.black)),
              ),
              // const SizedBox(height: 34),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, place);
                  // Handle confirm location tap
                },
                child: const Custombutton(
                  text: 'Confirm Location',
                  width: double.infinity,
                ),
              )
            ],
          ),
        ),
      ),

      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            onCameraMove: (CameraPosition position) async {
              await _onCameraMove(position);
              // .then((value) async{
              if (_debounce?.isActive ?? false) _debounce!.cancel();

              _debounce = Timer(const Duration(milliseconds: 800), () async {
                if (!_isBottomSheetShown) {
                  _isBottomSheetShown = true;

                  // await showModalBottomSheet(
                  //   isScrollControlled: true,
                  //   isDismissible: true,
                  //   enableDrag: true,
                  //   backgroundColor: Colors.transparent,
                  //   context: context,
                  //   builder: (_) =>  AddressBottomSheet(
                  //     pincode: place?.postalCode ?? '',
                  //     city: place?.locality ?? '',
                  //     state: place?.administrativeArea ?? '',
                  //     appartment: place?.street ?? '',
                  //     flatNo: place?.thoroughfare ?? '',
                  //   ),
                  // );

                  // Reset after it's closed
                  _isBottomSheetShown = false;
                }
              });
              // });
            },
            markers: _markers,
            initialCameraPosition: kGooglePlex!,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            top: 50,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  const BoxShadow(blurRadius: 5, color: Colors.black26)
                ],
              ),
              child: GooglePlacesSearchField(
                // isEnable: facilitydropdownNames.isNotEmpty
                //         ? false
                //         : true,
                locationName: loc,
                apiKey: "AIzaSyCkPmUz4UlRdzcKG9gniW9Qfrgzsjhnb_4",
                onPlaceSelected: (place) {
                  _moveCameraToPlace(place).then(
                    (value) async {
                      final GoogleMapController controller =
                          await _controller.future;
                      kGooglePlex = CameraPosition(
                        target: LatLng(target!.latitude ?? 37.42796133580664,
                            target!.longitude ?? -122.085749655962),
                        zoom: 14.4746,
                      );
                      await controller.animateCamera(
                          CameraUpdate.newCameraPosition(kGooglePlex!));
                    },
                  );
                  //  loc = place.latLng;
                  setState(() {});
                  print("Selected place: ${loc!.isEmpty}");
                },
              ),
              // TextField(
              //   controller:TextEditingController(),
              //   decoration: InputDecoration(

              //     hintText: "Search location",
              //     border: InputBorder.none,

              //     icon: Icon(Icons.search),
              //   ),
              // ),
            ),
          ),
        ],
      ),

      // )
      // Positioned(
      //   // top: ,
      //   bottom: 20,
      //   child: Container(
      //   height: 50,
      //   child: GooglePlacesSearchField(
      //                        // isEnable: facilitydropdownNames.isNotEmpty
      //                        //         ? false
      //                        //         : true,
      //                        locationName: loc,
      //                        apiKey: "AIzaSyCkPmUz4UlRdzcKG9gniW9Qfrgzsjhnb_4",
      //                        onPlaceSelected: (place) {
      //                          loc = place;
      //                          print("Selected place: ${loc!.isEmpty}");
      //                        },
      //                      ),
      //             ),
      // ),

      // ],
      // ),

      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: const Text('To the lake!'),
      //   icon: const Icon(Icons.directions_boat),
      // ),
    );
  }

  Future<void> _goToTheLake() async {}
}
