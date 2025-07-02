// To parse this JSON data, do
//
//     final completeVendor = completeVendorFromJson(jsonString);

import 'dart:convert';

import 'package:woloo_smart_hygiene/b2b_store/models/order_details.dart';

CompleteVendor completeVendorFromJson(String str) =>
    CompleteVendor.fromJson(json.decode(str));

String completeVendorToJson(CompleteVendor data) => json.encode(data.toJson());

class CompleteVendor {
  final OrderSet? orderSet;

  CompleteVendor({
    this.orderSet,
  });

  factory CompleteVendor.fromJson(Map<String, dynamic> json) => CompleteVendor(
        orderSet: json["order_set"] == null
            ? null
            : OrderSet.fromJson(json["order_set"]),
      );

  Map<String, dynamic> toJson() => {
        "order_set": orderSet?.toJson(),
      };
}
