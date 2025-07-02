


import 'package:woloo_smart_hygiene/utils/app_constants.dart';
// import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';


class CustomDropDownDialog<T> extends StatefulWidget {
  final List<T> items;
  final bool? enabled;
  final Function? itemAsString;
  final Function? onSaved;
  final Function? onChanged;
  final Function? validator;
  final GlobalKey<DropdownSearchState>? widgetKey;
  final String? hint;
  final T? selected;

  const CustomDropDownDialog({
    super.key,
    required this.items,
    this.enabled,
    this.selected,
    this.itemAsString,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.widgetKey,
   required this.hint
  });

  @override
  State<CustomDropDownDialog<T>> createState() => _CustomDropDownDialogState<T>();
}

class _CustomDropDownDialogState<T> extends State<CustomDropDownDialog<T>> {

  // dropDownKey
  // GlobalKey<DropdownSearchState> dropDownKey = GetIt.instance();

  //GlobalKey<DropdownSearchState>();

  @override
  Widget build(BuildContext context) {
     debugPrint("TEST ${widget.selected}");
    return 
    Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,

        
        borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2), // Shadow color
                          spreadRadius: 1, // How wide the shadow should spread
                          blurRadius: 10, // The blur effect of the shadow
                          offset: const Offset(0,
                              5), // Shadow offset, with y-offset for bottom shadow
                        ),
                      ],
      ),
      child: DropdownSearch<T>(
        


        selectedItem: widget.selected ,
        key: widget.widgetKey,
        enabled: widget.enabled ?? true,
        
        autoValidateMode:
        // _startValidation
        //     ? AutovalidateMode.always
        //    :
        AutovalidateMode.disabled,
        items: widget.items,
        
        popupProps: PopupProps.dialog(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                // contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                hintText: MyFacilityListConstants.SEARCH.tr(),
              ),
            ),
            containerBuilder: (context, child) {
              return SizedBox(
                height: 350.h,
                child: child,
              );
            }),
            
            //  dropdownBuilder: (ctx, selectedItem) =>
            //             Icon(Icons.face, color:  Colors.black , size: 24),
        dropdownDecoratorProps: DropDownDecoratorProps(
          
          dropdownSearchDecoration: InputDecoration(
            hintText: widget.hint,
            hintStyle:  TextStyle(
              color: Colors.grey,
              fontSize: 16.sp,
            ),

              suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: (){}
                            ),

          //  suffixIcon: Icon( Icons.arrow_back,
          //   color: AppColors.black,
          //  ),
            //  suffix: Icon( Icons.arrow_back,
            //  color: AppColors.black,
            //  ),

      
            labelStyle: const TextStyle(
              color: AppColors.black,
            ),
            errorStyle: const TextStyle(
              color: Colors.redAccent,
            ),
            errorBorder:  InputBorder.none,

            // OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(
            //     5.r,
            //   ),
            //   borderSide: const BorderSide(
            //     color: Colors.redAccent,
            //   ),
            // ),
            
            contentPadding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 10.h,
            ),
            border:  InputBorder.none
            // OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(
            //     5.r,
            //   ),
            //   borderSide: const BorderSide(color: AppColors.black),
            // ),
          ),
          baseStyle: TextStyle(
            color: widget.enabled ?? true ? Colors.black : Colors.grey,
          ),
        ),
        itemAsString: (item) =>
            widget.itemAsString != null ? widget.itemAsString!(item) : "",
        validator: (value) =>
            widget.validator != null ? widget.validator!(value) : null,
        onSaved: (item) {
          if (item != null && widget.onSaved != null && widget.items.isNotEmpty) {
            widget.onSaved!(item);
          }
        },
        onChanged: (item) {
              if(item != null){
                if (widget.onChanged != null) {
                  widget.onChanged!(item);
                }

              }

        },
        onBeforePopupOpening: (a) async {
          return true;
        },
      ),
    );
  }
}
