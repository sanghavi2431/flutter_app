import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

class MultiselectDropDownDialog<T> extends StatefulWidget {
  final List<T> items;
  final bool? enabled;
  final Function? itemAsString;
  final Function? onSaved;
  final Function? onChanged;
  final Function? validator;
  final Key? widgetKey;
  final List<T>? selected;
  final String? hint;

  const MultiselectDropDownDialog({
    super.key,
    required this.items,
    this.enabled,
    this.selected,
    this.itemAsString,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.widgetKey,
    this.hint
  });

  @override
  State<MultiselectDropDownDialog<T>> createState() =>
      _DropDownDialogState<T>();
}

class _DropDownDialogState<T> extends State<MultiselectDropDownDialog<T>> {
  bool _startValidation = false;

  @override
  Widget build(BuildContext context) {
    return
      DropdownSearch<T>.multiSelection(
      selectedItems: widget.selected ?? [],


      key: widget.widgetKey,
      enabled: widget.enabled ?? true,
      autoValidateMode: _startValidation
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      items: widget.items,
      popupProps: PopupPropsMultiSelection.menu(
          // showSearchBox: true,


          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
              hintText: MyFacilityListConstants.SEARCH.tr(),
            ),
          ),
  //       itemBuilder: (context, item, isSelected) {
  //   return ListTile(
  //     leading: Checkbox(
  //       value: isSelected,
  //       onChanged: (_) {},
  //     ),
  //     title: Text(
  //       widget.itemAsString != null ? widget.itemAsString!(item) : item.toString(),
  //     ),
  //   );
  // },   

          containerBuilder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
              ),
              height: 350.h,
              child: child,
            );
          }
          
          ),
      // dropdownBuilder: (context, selectedItems) {
      //   return Container(
      //     child:  Text(selectedItems.first.toString() ),
      //   );
      // },
    dropdownBuilder: (context, selectedItems) {
  if (selectedItems.isEmpty) {
    return Text(
      widget.hint ?? '',
      style: const TextStyle(color: Colors.grey),
    );
  }

  List<Widget> displayChips = [];

  for (var i = 0; i < selectedItems.length && i < 2; i++) {
    final itemText = widget.itemAsString != null
        ? widget.itemAsString!(selectedItems[i])
        : selectedItems[i].toString();

    displayChips.add(
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          margin: EdgeInsets.only(right: 5.w),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Text(
            itemText,
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
        ),
      ),
    );
  }

  if (selectedItems.length > 2) {
    displayChips.add(
      Text(
        "+${selectedItems.length - 2} more",
        style: TextStyle(color: Colors.grey, fontSize: 13.sp),
      ),
    );
  }

  return Wrap(
    children: displayChips,
  );
},

      dropdownDecoratorProps: DropDownDecoratorProps(


        dropdownSearchDecoration: InputDecoration(
          hintText: widget.hint,
          

          floatingLabelBehavior: FloatingLabelBehavior.always,
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
          border: InputBorder.none
          // OutlineInputBorder(
          //
          //   borderRadius: BorderRadius.circular(
          //     5.r,
          //   ),
          //   borderSide: const BorderSide(
          //     width: 0,
          //     color: Colors.transparent),
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
      onSaved: (item) => (widget.onSaved != null && widget.items.isNotEmpty)
          ? widget.onSaved!(item)
          : null,
      onChanged: (item) {
        if (widget.onChanged != null) {
          widget.onChanged!(item);
        }
      },
      onBeforePopupOpening: (a) async {
        setState(() {
          _startValidation = true;
        });
        return true;
      },
    );
  }
}
