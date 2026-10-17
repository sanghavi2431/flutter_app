import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http;
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';

import '../utils/app_color.dart';


class IndiaLocationPicker extends StatefulWidget {
  const IndiaLocationPicker({super.key});

  @override
  State<IndiaLocationPicker> createState() => _IndiaLocationPickerState();
}

class _IndiaLocationPickerState extends State<IndiaLocationPicker> {
  late GoogleMapController _mapController;
  final TextEditingController _searchController = TextEditingController();


  Marker? _marker;
  LatLng _selectedLatLng = const LatLng(20.5937, 78.9629);

  String address = '';
  String city = '';

  static const String googleKey = MapUtilsConstants.GOOGLE_MAP_KEY;

  @override
  void initState() {
    super.initState();
    _initCurrentLocation();
  }

  /// ------------------------------
  /// CURRENT LOCATION WITH PERMISSION
  /// ------------------------------
  Future<void> _initCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    _updateLocation(LatLng(position.latitude, position.longitude));
  }

  void _handlePlaceSelect(Prediction p) async {
    if (p.lat == null || p.lng == null) return;

    final latLng = LatLng(double.parse(p.lat!), double.parse(p.lng!));

    _searchController.text = p.description ?? '';
    _updateLocation(latLng);
  }


  /// ------------------------------
  /// UPDATE MAP + ADDRESS
  /// ------------------------------
  Future<void> _updateLocation(LatLng latLng) async {
    _selectedLatLng = latLng;

    _marker = Marker(
      markerId: const MarkerId('selected'),
      position: latLng,
    );

    _mapController.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));

    final placemarks = await placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );

    if (placemarks.isNotEmpty) {
      final p = placemarks.first;
      setState(() {
        city = p.locality ?? p.administrativeArea ?? '';
        address = '${p.street}, ${p.subLocality}, ${p.locality}, ${p.administrativeArea}, ${p.postalCode}';
      });
    }
  }

  /// ------------------------------
  /// CONFIRM LOCATION
  /// ------------------------------
  void _confirmLocation() {
    Navigator.pop(context, {
      'address': address,
      'city': city,
      'lat': _selectedLatLng.latitude,
      'lng': _selectedLatLng.longitude,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLatLng,
              zoom: 5,
            ),
            markers: _marker != null ? {_marker!} : {},
            onMapCreated: (c) => _mapController = c,
            onTap: _updateLocation,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),

          /// SEARCH BAR
          Positioned(
            top: 30,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [

                      ]),
                  child: Material(
                    color: AppColors.sevenPercentWhite,
                    child:
                    GooglePlaceAutoCompleteTextField(
                      textEditingController: _searchController,
                      googleAPIKey: googleKey,
                      inputDecoration: InputDecoration(
                        hintText: 'Search area, city or state',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(14),
                        prefixIcon: const Icon(Icons.search),
                       /* suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: _searchController.clear,
                        ),*/
                      ),
                      debounceTime: 400,
                      isLatLngRequired: true,
                      countries: const ["in"],
                      getPlaceDetailWithLatLng: (Prediction prediction) {
                        _handlePlaceSelect(prediction);
                      },
                      itemClick: (Prediction prediction) {
                        _handlePlaceSelect(prediction);
                      },
                    ),
                  ),
                ),


              ],
            ),
          ),

          /// BOTTOM INFO
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Selected Address', style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  Text(address.isEmpty ? 'Fetching location...' : address , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(' $city' , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: [


                      Text('${_selectedLatLng.latitude}', style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w600)),
                      Text(' , ${_selectedLatLng.longitude}' , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
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
                      onPressed: _confirmLocation,
                      child: const Text('Confirm Location' ,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
