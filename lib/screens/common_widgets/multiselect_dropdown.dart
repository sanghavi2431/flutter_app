import 'package:Woloo_Smart_hygiene/utils/app_constants.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Woloo_Smart_hygiene/utils/app_color.dart';

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
    Key? key,
    required this.items,
    this.enabled,
    this.selected,
    this.itemAsString,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.widgetKey,
    this.hint
  }) : super(key: key);

  @override
  State<MultiselectDropDownDialog<T>> createState() =>
      _DropDownDialogState<T>();
}

class _DropDownDialogState<T> extends State<MultiselectDropDownDialog<T>> {
  bool _startValidation = false;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>.multiSelection(
      selectedItems: widget.selected ?? [],
      key: widget.widgetKey,
      enabled: widget.enabled ?? true,
      autoValidateMode: _startValidation
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      items: widget.items,
      popupProps: PopupPropsMultiSelection.dialog(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
              hintText: MyFacilityListConstants.SEARCH.tr(),
            ),
          ),
          containerBuilder: (context, child) {
            return SizedBox(
              height: 350.h,
              child: child,
            );
          }),
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
