// To parse this JSON data, do
//
//     final checkSupervisor = getSupervisorFromJson(jsonString);

import 'dart:convert';

GetSupervisorListModel getSupervisorFromJson(String str) =>
    GetSupervisorListModel.fromJson(json.decode(str));

String checkSupervisorToJson(GetSupervisorListModel data) =>
    json.encode(data.toJson());

class GetSupervisorListModel {
  Results? results;
  bool? success;

  GetSupervisorListModel({
    this.results,
    this.success,
  });

  factory GetSupervisorListModel.fromJson(Map<String, dynamic> json) =>
      GetSupervisorListModel(
        results: Results.fromJson(json["results"]),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
    "results": results!.toJson(),
    "success": success,
  };
}

class Results {
  List<SupervisorData>? data;
  int? total;

  Results({
    this.data,
    this.total,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
    data: json["data"] == null
        ? []
        : List<SupervisorData>.from(
        json["data"].map((x) => SupervisorData.fromJson(x))),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "total": total,
  };
}

class SupervisorData {
  int? id;
  String? name;
  String? mobile;
  bool? isClientSupervisor;


  SupervisorData({
    this.id,
    this.name,
    this.mobile,
    this.isClientSupervisor,
  });

  factory SupervisorData.fromJson(Map<String, dynamic> json) =>
      SupervisorData(
        id: json["id"],
        name: json["name"],
        mobile: json["mobile"],
        isClientSupervisor: json["isClientIsSupervisor"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "mobile": mobile,
    "isClientSupervisor": isClientSupervisor,
  };
}
