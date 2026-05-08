// To parse this JSON data, do
//
//     final inventoryErrorModel = inventoryErrorModelFromJson(jsonString);

import 'dart:convert';

InventoryErrorModel inventoryErrorModelFromJson(String str) =>
    InventoryErrorModel.fromJson(json.decode(str));

String inventoryErrorModelToJson(InventoryErrorModel data) =>
    json.encode(data.toJson());

class InventoryErrorModel {
  bool? success;
  String? message;
  List<Error>? errors;
  Summary? summary;

  InventoryErrorModel({
    this.success,
    this.message,
    this.errors,
    this.summary,
  });

  factory InventoryErrorModel.fromJson(Map<String, dynamic> json) =>
      InventoryErrorModel(
        success: json["success"],
        message: json["message"],
        errors: List<Error>.from(json["errors"].map((x) => Error.fromJson(x))),
        summary: Summary.fromJson(json["summary"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errors": List<dynamic>.from(errors!.map((x) => x.toJson())),
        "summary": summary!.toJson(),
      };
}

class Error {
  String? variantId;
  String? title;
  int? requestedQuantity;
  int? availableQuantity;

  Error({
    this.variantId,
    this.title,
    this.requestedQuantity,
    this.availableQuantity,
  });

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        variantId: json["variant_id"],
        title: json["title"],
        requestedQuantity: json["requested_quantity"],
        availableQuantity: json["available_quantity"],
      );

  Map<String, dynamic> toJson() => {
        "variant_id": variantId,
        "title": title,
        "requested_quantity": requestedQuantity,
        "available_quantity": availableQuantity,
      };
}

class Summary {
  int? totalItemsChecked;
  int? itemsOutOfStock;
  int? itemsInStock;

  Summary({
    this.totalItemsChecked,
    this.itemsOutOfStock,
    this.itemsInStock,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        totalItemsChecked: json["total_items_checked"],
        itemsOutOfStock: json["items_out_of_stock"],
        itemsInStock: json["items_in_stock"],
      );

  Map<String, dynamic> toJson() => {
        "total_items_checked": totalItemsChecked,
        "items_out_of_stock": itemsOutOfStock,
        "items_in_stock": itemsInStock,
      };
}
