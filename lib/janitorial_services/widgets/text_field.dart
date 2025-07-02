import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String hintText;
  final TextInputType keyboardType;
  final int maxLength;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.validator,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.maxLength = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color
              spreadRadius: 1, // Spread radius
              blurRadius: 10, // Blur radius
              offset: const Offset(0, 5), // Offset for shadow
            ),
          ],
        ),
        child: TextFormField(
          keyboardType: keyboardType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textAlign: TextAlign.start,
          controller: controller,
          validator: validator,
          maxLength: maxLength,
          decoration: InputDecoration(

            // hintTextDirection: TextDirection.rtl,
            isDense: true,
            counterText: "",
            fillColor: Colors.white, // Adjust if using custom colors
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0), // Default radius
              borderSide: BorderSide.none,
            ),
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.grey, // Adjust if using custom colors
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}



