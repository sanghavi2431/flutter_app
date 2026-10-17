import 'package:flutter/material.dart';

class SmartSingleChildScrollView extends StatelessWidget {
  const SmartSingleChildScrollView(
      {super.key, this.isEnabled = false, required this.child, this.padding});
  final bool isEnabled;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return isEnabled
        ? SingleChildScrollView(
            padding: padding,
            child: child,
          )
        : child;
  }
}
