// To parse this JSON data, do
//
//     final setShippingAndBillingAddressModel = setShippingAndBillingAddressModelFromJson(jsonString);

import 'dart:convert';

SetShippingAndBillingAddressModel setShippingAndBillingAddressModelFromJson(
        String str) =>
    SetShippingAndBillingAddressModel.fromJson(json.decode(str));

String setShippingAndBillingAddressModelToJson(
        SetShippingAndBillingAddressModel data) =>
    json.encode(data.toJson());

class SetShippingAndBillingAddressModel {
  final IngAddress shippingAddress;
  final IngAddress billingAddress;

  SetShippingAndBillingAddressModel({
    required this.shippingAddress,
    required this.billingAddress,
  });

  factory SetShippingAndBillingAddressModel.fromJson(
          Map<String, dynamic> json) =>
      SetShippingAndBillingAddressModel(
        shippingAddress: IngAddress.fromJson(json["shipping_address"]),
        billingAddress: IngAddress.fromJson(json["billing_address"]),
      );

  Map<String, dynamic> toJson() => {
        "shipping_address": shippingAddress.toJson(),
        "billing_address": billingAddress.toJson(),
      };
}

class IngAddress {
  final String firstName;
  final String lastName;
  final String address1;
  final String city;
  final String countryCode;
  final String postalCode;
  final String phone;

  IngAddress({
    required this.firstName,
    required this.lastName,
    required this.address1,
    required this.city,
    required this.countryCode,
    required this.postalCode,
    required this.phone,
  });

  factory IngAddress.fromJson(Map<String, dynamic> json) => IngAddress(
        firstName: json["first_name"],
        lastName: json["last_name"],
        address1: json["address_1"],
        city: json["city"],
        countryCode: json["country_code"],
        postalCode: json["postal_code"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "address_1": address1,
        "city": city,
        "country_code": countryCode,
        "postal_code": postalCode,
        "phone": phone,
      };
}
