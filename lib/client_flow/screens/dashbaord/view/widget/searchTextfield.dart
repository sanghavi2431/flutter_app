import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

import '../../../../../utils/app_constants.dart';
import '../../../../widgets/CustomTextField.dart';

class GooglePlacesSearchField extends StatefulWidget {
  final String? locationName;
  final String apiKey;
  final bool? isEnable;
  final void Function(String suggestion)? onPlaceSelected;
  final InputDecoration? decoration;
  final void Function(bool isValidSelection)? onValidationChanged;
  final int? roleId;

  const GooglePlacesSearchField(
      {super.key,
      required this.apiKey,
      this.onPlaceSelected,
      this.decoration,
      this.locationName,
      this.isEnable,
        this.onValidationChanged,
       this.roleId});

  @override
  State<GooglePlacesSearchField> createState() =>
      _GooglePlacesSearchFieldState();
}

class _GooglePlacesSearchFieldState extends State<GooglePlacesSearchField> {
  late TextEditingController _controller;
  SuggestionsController<String> suggestionsController = SuggestionsController();
  bool isSuggestionSelected = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.locationName ?? "");
  }


  @override
  void didUpdateWidget(covariant GooglePlacesSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.locationName != oldWidget.locationName) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.text = widget.locationName ?? "";
      });
    }
  }



  Future<List<String>> _getSuggestions(String input) async {
    if (input.isEmpty) return [];

    // Get current locale language code for Google API
    final locale = context.locale;
    final languageCode = locale.languageCode; // 'en', 'hi', or 'mr'

    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=geocode&language=$languageCode&key=${widget.apiKey}';

    final response = await http.get(Uri.parse(url));
    print("Google Places API error: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final predictions = data['predictions'] as List;

      return predictions.map((item) => item['description'] as String).toList();
    } else {
      print("Google Places API error: ${response.body}");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    //_controller.text = widget.locationName ?? "";
    return TypeAheadField<String>(
      // decorationBuilder: ,
      controller: _controller,
      hideOnEmpty: true,
      hideWithKeyboard: false,
      hideOnUnfocus: false,
      hideKeyboardOnDrag: false,
      showOnFocus: true,
      suggestionsController: suggestionsController,
      //  hideWithKeyboard: false,
      suggestionsCallback: _getSuggestions,
      decorationBuilder: (context, child) => Material(
        type: MaterialType.card,
        elevation: 4,
        color: Colors.white,
        // borderRadius: borderRadius,
        child: child,
      ),

      itemBuilder: (context, suggestion) {
        print("list suggestion $suggestion");
        return ListTile(
          tileColor: Colors.white,
          leading: Icon(Icons.location_on_outlined),
          title: Text(suggestion),
        );
      },
      onSelected: (suggestion) {
        print('selected suggestion: $suggestion');
        _controller.text = suggestion;
        isSuggestionSelected = true;

        FocusScope.of(context).unfocus();

        widget.onValidationChanged?.call(true);
        // setState(() {});
        if (widget.onPlaceSelected != null) {
          widget.onPlaceSelected!(suggestion);
        }
      },
      builder: (context, innerController, focusNode) {
        print('search text: ${innerController.text}.');
       // _controller = innerController;
        return
            //  CustomTextField(
            //           padding: const EdgeInsets.all(0),
            //           hintText:  DashboardConst.location,
            //           // DashboardConst
            //           //     .ifOthersMentionFacility,
            //             hintStyle:   TextStyle(
            //               color: Colors.grey,
            //               fontSize: 13.sp,
            //               fontWeight: FontWeight.w700
            //             ),

            //           controller: innerController,
            //           validator: (valu) {
            //             if (valu == null || valu.isEmpty) {
            //               return "Please mention other type";
            //             }
            //           },
            //         );
            TextFormField(
          enabled: widget.isEnable,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please mention location";
            }
          /* else if (!isSuggestionSelected && widget.roleId != 16 && widget.isEnable == true) {
             return  "Please select location from list";
            }*/

          },
              onChanged: (value) {
                isSuggestionSelected = false;
                widget.onValidationChanged?.call(false);
              },
          controller: innerController,
          focusNode: focusNode,
          decoration: widget.decoration ??
              InputDecoration(
                hintText: 'Search location...',
                hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700),
                // prefixIcon: Icon(Icons.search),
               /* border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide.none,
                ),*/
                border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.only(
                  right: 40,
                ),
              ),

        );
      },

      debounceDuration: const Duration(milliseconds: 400),
      hideOnLoading: false,
    );
  }
}
