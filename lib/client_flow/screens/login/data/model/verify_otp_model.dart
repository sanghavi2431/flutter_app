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
    dynamic name;
    int? roleId;
    dynamic email;
    String? mobile;
    String? shopPassword;
    int? isRegister;
    dynamic pincode;
    dynamic city;
    dynamic address;
    dynamic wolooId;
    dynamic facilityName;
    dynamic facilityAddress;
    String? facilityType;
    String? rolesAccess;
    String? permissions;
    String? token;
    int? userId;

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
        this.facilityName,
        this.facilityAddress,
        this.facilityType,
        this.rolesAccess,
        this.permissions,
        this.token,
        this.userId,
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
        facilityName: json["facility_name"],
        facilityAddress: json["facility_address"],
        facilityType: json["facility_type"],
        rolesAccess: json["rolesAccess"],
        permissions: json["permissions"],
        token: json["token"],
        userId: json["user_id"],
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
        "facility_name": facilityName,
        "facility_address": facilityAddress,
        "facility_type": facilityType,
        "rolesAccess": rolesAccess,
        "permissions": permissions,
        "token": token,
        "user_id": userId,
    };
}
