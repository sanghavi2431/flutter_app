// To parse this JSON data, do
//
//     final verfiyOtpModel = verfiyOtpModelFromJson(jsonString);

import 'dart:convert';

VerfiyOtpModel verfiyOtpModelFromJson(String str) => VerfiyOtpModel.fromJson(json.decode(str));

String verfiyOtpModelToJson(VerfiyOtpModel data) => json.encode(data.toJson());

class VerfiyOtpModel {
    bool? success;
    Results? results;

    VerfiyOtpModel({
        this.success,
        this.results,
    });

    factory VerfiyOtpModel.fromJson(Map<String, dynamic> json) => VerfiyOtpModel(
        success: json["success"],
        results: Results.fromJson(json["results"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "results": results!.toJson(),
    };
}

class Results {
    int? id;
    String? name;
    int? roleId;
    dynamic email;
    String? mobile;
    String? shopPassword;
    int? isRegister;
    dynamic pincode;
    dynamic city;
    dynamic address;
    int? wolooId;
    String? hostFacility;
    String? hostLocation;
    String? hostCity;
    String? lat;
    String? lng;
    String? facilityType;
    String? rolesAccess;
    String? permissions;
    String? token;
    int? userId;
    List<String>? languageCodes;

    Results({
        this.id,
        this.name,
        this.roleId,
        this.email,
        this.mobile,
        this.shopPassword,
        this.isRegister,
        this.pincode,
        this.city,
        this.address,
        this.wolooId,
        this.hostFacility,
        this.hostLocation,
        this.hostCity,
        this.lat,
        this.lng,
        this.facilityType,
        this.rolesAccess,
        this.permissions,
        this.token,
        this.userId,
        this.languageCodes,
    });

    factory Results.fromJson(Map<String, dynamic> json) => Results(
        id: json["id"],
        name: json["name"],
        roleId: json["role_id"],
        email: json["email"],
        mobile: json["mobile"],
        shopPassword: json["shop_password"],
        isRegister: json["isRegister"],
        pincode: json["pincode"],
        city: json["city"],
        address: json["address"],
        wolooId: json["woloo_id"],
        hostFacility: json["host_facility"],
        hostLocation: json["host_location"],
        hostCity: json["host_city"],
        lat: json["lat"],
        lng: json["lng"],
        facilityType: json["facility_type"],
        rolesAccess: json["rolesAccess"],
        permissions: json["permissions"],
        token: json["token"],
        userId: json["user_id"],
        languageCodes: json["language_codes"] == null
            ? null
            : List<String>.from(json["language_codes"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "role_id": roleId,
        "email": email,
        "mobile": mobile,
        "shop_password": shopPassword,
        "isRegister": isRegister,
        "pincode": pincode,
        "city": city,
        "address": address,
        "woloo_id": wolooId,
        "host_facility": hostFacility,
        "host_location": hostLocation,
        "host_city": hostCity,
        "lat": lat,
        "lng": lng,
        "facility_type": facilityType,
        "rolesAccess": rolesAccess,
        "permissions": permissions,
        "token": token,
        "user_id": userId,
        "language_codes": languageCodes == null
            ? null
            : List<dynamic>.from(languageCodes!.map((x) => x)),
    };
}
