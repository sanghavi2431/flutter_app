// To parse this JSON data, do
//
//     final userRoleModel = userRoleModelFromJson(jsonString);

import 'dart:convert';

UserRoleModel userRoleModelFromJson(String str) =>
    UserRoleModel.fromJson(json.decode(str));

String userRoleModelToJson(UserRoleModel data) => json.encode(data.toJson());

class UserRoleModel {
  Results? results;
  bool? success;

  UserRoleModel({
    this.results,
    this.success,
  });

  factory UserRoleModel.fromJson(Map<String, dynamic> json) => UserRoleModel(
        results: Results.fromJson(json["results"]),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "results": results!.toJson(),
        "success": success,
      };
}

class Results {
  String? role;

  Results({
    this.role,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "role": role,
      };
}
