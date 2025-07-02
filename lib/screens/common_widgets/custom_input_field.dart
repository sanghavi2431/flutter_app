import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';

class CustomInputField extends StatefulWidget {
  final bool? enabled;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final Icon? suffixIcon;
  final Function? validator;
  final Function? onSaved;
  final String? initialValue;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatter;
  final String? hint;

  const CustomInputField({
    super.key,
    this.initialValue,
    this.suffixIcon,
    this.enabled,
    this.readOnly,
    this.keyboardType,
    this.controller,
    this.validator,
    this.onSaved,
    required this.hint,
    this.inputFormatter,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      Future.delayed(Duration.zero).then((value) {
        widget.controller?.text = widget.initialValue ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly ?? false,
      controller: widget.controller,
      enabled: widget.enabled,
      initialValue: widget.controller != null ? null : widget.initialValue,
      cursorColor: AppColors.greyText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatter,
      style: TextStyle(
        color: (widget.enabled ?? true) ? AppColors.black : Colors.grey,
      ),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 10.w,
        ),
        hintText: widget.hint,
        labelStyle: const TextStyle(
          color: AppColors.black,
        ),
        errorStyle: const TextStyle(
          color: Colors.redAccent,
        ),
        errorBorder: InputBorder.none,
        // OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(5.r),
        //   borderSide: const BorderSide(
        //     color: Colors.redAccent,
        //   ),
        // ),
        border: InputBorder.none,
        // OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(5.r),
        //   borderSide: const BorderSide(
        //     color: AppColors.greyIcon,
        //   ),
        // ),
        focusedBorder:InputBorder.none,
       
        suffixIcon: widget.suffixIcon,
      ),
      validator: (value) =>
          widget.validator != null ? widget.validator!(value) : null,
      onSaved: (value) =>
          widget.onSaved != null ? widget.onSaved!(value) : null,
    );
  }
}
