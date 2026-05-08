// To parse this JSON data, do
//
//     final inventoryModel = inventoryModelFromJson(jsonString);

import 'dart:convert';

InventoryModel inventoryModelFromJson(String str) =>
    InventoryModel.fromJson(json.decode(str));

String inventoryModelToJson(InventoryModel data) => json.encode(data.toJson());

class InventoryModel {
  bool? success;
  String? message;
  Data? data;

  InventoryModel({
    this.success,
    this.message,
    this.data,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) => InventoryModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  List<Item>? items;

  Data({
    this.items,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Item {
  String? inventoryItemId;
  int? requiredQuantity;
  bool? allowBackorder;
  int? quantity;
  List<String>? locationIds;

  Item({
    this.inventoryItemId,
    this.requiredQuantity,
    this.allowBackorder,
    this.quantity,
    this.locationIds,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        inventoryItemId: json["inventory_item_id"],
        requiredQuantity: json["required_quantity"],
        allowBackorder: json["allow_backorder"],
        quantity: json["quantity"],
        locationIds: List<String>.from(json["location_ids"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "inventory_item_id": inventoryItemId,
        "required_quantity": requiredQuantity,
        "allow_backorder": allowBackorder,
        "quantity": quantity,
        "location_ids": List<dynamic>.from(locationIds!.map((x) => x)),
      };
}
