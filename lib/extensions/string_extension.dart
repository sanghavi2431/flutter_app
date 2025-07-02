import 'package:flutter/material.dart';

extension NullCheckExtension on String? {
  bool get isEmptyOrNull {
    return this != null ? this!.isEmpty : true;
  }
}

extension ColorExtension on String? {
  Color get toColor {
    if (this == null || this!.isEmpty) {
      return Colors.white; // or any default color you prefer
    }
    return Color(int.parse('0xFF$this'));
  }
}

extension HexValueCheck on String? {
  bool get isHex {
    if (this == null || this!.isEmpty) {
      return false;
    }
    try {
      final val = this!.replaceFirst('#', '');
      int.parse(val, radix: 16);
      return true;
    } catch (e) {
      return false;
    }
  }
}
