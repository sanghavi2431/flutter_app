import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/network/api_constant.dart';
import '../../../../../../utils/app_color.dart';
import '../../widget/searchTextfield.dart';

class LocationFieldWidget extends StatefulWidget {
  final bool isFirstTimeHost;
  final List facilitydropdownNames;
  final int roleId;
  final int facilityCount;
  final String? defaultHostLocation;
  final String? loc;
  final Function(String) onPlaceSelected;
  final VoidCallback onClear;
  final bool isFromAddTask;

  const LocationFieldWidget({
    super.key,
    required this.isFirstTimeHost,
    required this.facilitydropdownNames,
    required this.roleId,
    required this.facilityCount,
    required this.defaultHostLocation,
    required this.loc,
    required this.onPlaceSelected,
    required this.onClear,
    required this.isFromAddTask,
  });

  @override
  State<LocationFieldWidget> createState() => LocationFieldWidgetState();
}
class LocationFieldWidgetState extends State<LocationFieldWidget> {
  String? locationError;
  bool isLocationValid = true;


  @override
  Widget build(BuildContext context) {
   /* final isEnabled = !widget.isFirstTimeHost &&
        widget.facilitydropdownNames.isEmpty;*/
    final isEnabled = !widget.isFirstTimeHost &&
        !widget.isFromAddTask;
    return Column( // ✅ IMPORTANT
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.white),
          ),
          child: Stack(
            children: [
              GooglePlacesSearchField(
                isEnable: isEnabled,
                locationName: (widget.roleId == 16 &&
                    widget.facilityCount == 0)
                    ? widget.defaultHostLocation
                    : widget.loc,
                apiKey: APIConstants.GOOGLE_API_KEY,
                onPlaceSelected: widget.onPlaceSelected,

                /// ✅ VALIDATION CALLBACK
                onValidationChanged: (isValid) {
                  setState(() {
                    isLocationValid = isValid;
                    if (isValid) locationError = null;
                  });
                },
                roleId: widget.roleId,
              ),

              /// CLEAR BUTTON
              if (isEnabled)
              Positioned(
                right: 10,
                top: 12,
                child: GestureDetector(
                  onTap: widget.onClear,
                  child: const Icon(Icons.clear, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),

        /// ✅ ERROR TEXT BELOW FIELD
        if (locationError != null)
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 5),
            child: Text(
              locationError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  /// ✅ EXPOSE VALIDATION METHOD (important for Next button)
  bool validate() {
    /* if (widget.loc == null || widget.loc!.isEmpty) {
      setState(() {
        locationError = "Please select facility location";
      });
      return false;
    } else if (!isLocationValid) {
      setState(() {
        locationError = "Please select location from list";
      });
      return false;
    }
*/
    setState(() {
      locationError = null;
    });
    return true;
  }
}