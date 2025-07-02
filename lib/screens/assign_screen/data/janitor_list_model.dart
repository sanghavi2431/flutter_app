// To parse this JSON data, do
//
//     final janitorListModel = janitorListModelFromJson(jsonString);

import 'dart:convert';

JanitorListModel janitorListModelFromJson(String str) => JanitorListModel.fromJson(json.decode(str));

String janitorListModelToJson(JanitorListModel data) => json.encode(data.toJson());

class JanitorListModel {
    List<Datum>? data;
    int? total;

    JanitorListModel({
        this.data,
        this.total,
    });

    factory JanitorListModel.fromJson(Map<String, dynamic> json) => JanitorListModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "total": total,
    };
}

class Datum {
    int? id;
    String? name;
    String? mobile;
    String? city;
    String? address;
    bool? status;
    String? email;
    int? total;

    Datum({
        this.id,
        this.name,
        this.mobile,
        this.city,
        this.address,
        this.status,
        this.email,
        this.total,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        mobile: json["mobile"],
        city: json["city"],
        address: json["address"],
        status: json["status"],
        email: json["email"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobile": mobile,
        "city": city,
        "address": address,
        "status": status,
        "email": email,
        "total": total,
    };
}
