// To parse this JSON data, do
//
//     final deliveryCodesResponse = deliveryCodesResponseFromJson(jsonString);

import 'dart:convert';

DeliveryCodesResponse deliveryCodesResponseFromJson(String str) =>
    DeliveryCodesResponse.fromJson(json.decode(str));

String deliveryCodesResponseToJson(DeliveryCodesResponse data) =>
    json.encode(data.toJson());

class DeliveryCodesResponse {
  List<DeliveryCode>? deliveryCodes;

  DeliveryCodesResponse({
    this.deliveryCodes,
  });

  factory DeliveryCodesResponse.fromJson(Map<String, dynamic> json) =>
      DeliveryCodesResponse(
        deliveryCodes: List<DeliveryCode>.from(
            json["delivery_codes"].map((x) => DeliveryCode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "delivery_codes":
            List<dynamic>.from(deliveryCodes!.map((x) => x.toJson())),
      };
}

class DeliveryCode {
  PostalCode? postalCode;

  DeliveryCode({
    this.postalCode,
  });

  factory DeliveryCode.fromJson(Map<String, dynamic> json) => DeliveryCode(
        postalCode: PostalCode.fromJson(json["postal_code"]),
      );

  Map<String, dynamic> toJson() => {
        "postal_code": postalCode!.toJson(),
      };
}

class PostalCode {
  double? maxWeight;
  String? city;
  String? cod;
  String? inc;
  String? district;
  int? pin;
  double? maxAmount;
  String? prePaid;
  String? cash;
  String? stateCode;
  String? remarks;
  String? pickup;
  String? repl;
  String? covidZone;
  String? countryCode;
  String? isOda;
  bool? protectBlacklist;
  SortCode? sortCode;
  bool? sunTat;
  // List<Center>? center;

  PostalCode({
    this.maxWeight,
    this.city,
    this.cod,
    this.inc,
    this.district,
    this.pin,
    this.maxAmount,
    this.prePaid,
    this.cash,
    this.stateCode,
    this.remarks,
    this.pickup,
    this.repl,
    this.covidZone,
    this.countryCode,
    this.isOda,
    this.protectBlacklist,
    this.sortCode,
    this.sunTat,
    // this.center,
  });

  factory PostalCode.fromJson(Map<String, dynamic> json) => PostalCode(
        maxWeight: json["max_weight"],
        city: json["city"],
        cod: json["cod"],
        inc: json["inc"],
        district: json["district"],
        pin: json["pin"],
        maxAmount: json["max_amount"],
        prePaid: json["pre_paid"],
        cash: json["cash"],
        stateCode: json["state_code"],
        remarks: json["remarks"],
        pickup: json["pickup"],
        repl: json["repl"],
        covidZone: json["covid_zone"],
        countryCode: json["country_code"],
        isOda: json["is_oda"],
        protectBlacklist: json["protect_blacklist"],
        sortCode: sortCodeValues.map[json["sort_code"]],
        sunTat: json["sun_tat"],
        // center: List<Center>.from(json["center"].map((x) => Center.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "max_weight": maxWeight,
        "city": city,
        "cod": cod,
        "inc": inc,
        "district": district,
        "pin": pin,
        "max_amount": maxAmount,
        "pre_paid": prePaid,
        "cash": cash,
        "state_code": stateCode,
        "remarks": remarks,
        "pickup": pickup,
        "repl": repl,
        "covid_zone": covidZone,
        "country_code": countryCode,
        "is_oda": isOda,
        "protect_blacklist": protectBlacklist,
        "sort_code": sortCodeValues.reverse[sortCode],
        "sun_tat": sunTat,
        // "center": List<dynamic>.from(center!.map((x) => x.toJson())),
      };
}

class Center {
  String? code;
  DateTime? e;
  String? cn;
  DateTime? s;
  String? u;
  SortCode? sortCode;
  DateTime? ud;

  Center({
    this.code,
    this.e,
    this.cn,
    this.s,
    this.u,
    this.sortCode,
    this.ud,
  });

  factory Center.fromJson(Map<String, dynamic> json) => Center(
        code: json["code"],
        e: DateTime.parse(json["e"]),
        cn: json["cn"],
        s: DateTime.parse(json["s"]),
        u: json["u"],
        sortCode: sortCodeValues.map[json["sort_code"]],
        ud: DateTime.parse(json["ud"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "e": e!.toIso8601String(),
        "cn": cn,
        "s": s!.toIso8601String(),
        "u": u,
        "sort_code": sortCodeValues.reverse[sortCode],
        "ud": ud!.toIso8601String(),
      };
}

enum SortCode { BOM_CEN, BOM_CVP, NONE }

final sortCodeValues = EnumValues({
  "BOM/CEN": SortCode.BOM_CEN,
  "BOM/CVP": SortCode.BOM_CVP,
  "None": SortCode.NONE
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
