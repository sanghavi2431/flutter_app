// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
    Results? results;
    bool? success;

    ProfileModel({
        this.results,
        this.success,
    });

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        results: Results.fromJson(json["results"]) ,
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "results": results!.toJson(),
        "success": success,
    };
}

class Results {
    DateTime? startTime;
    DateTime? endTime;
    Gender? gender;
    String? mobile;
    String? address;
    String? city;
    String? profileImage;
    Status? status;
    int? roleId;
    String? email;
    dynamic clientId;
    ClientName? clientName;
    String? firstName;
    String? lastName;
    String? panImage;
    String? aadharImage;
    String? wishCertificateImage;
    List<Gender>? cluster;
    String? baseUrl;

    Results({
        this.startTime,
        this.endTime,
        this.gender,
        this.mobile,
        this.address,
        this.city,
        this.profileImage,
        this.status,
        this.roleId,
        this.email,
        this.clientId,
        this.clientName,
        this.firstName,
        this.lastName,
        this.panImage,
        this.aadharImage,
        this.wishCertificateImage,
        this.cluster,
        this.baseUrl,
    });

    factory Results.fromJson(Map<String, dynamic> json) => Results(
        startTime: DateTime.parse(json["start_time"] ?? DateTime.now().toString() )  ,
        endTime: DateTime.parse(json["end_time"] ?? DateTime.now().toString() ),
        // gender: Gender.fromJson(json["gender"]),
        mobile: json["mobile"],
        address: json["address"],
        city: json["city"],
        profileImage: json["profile_image"],
        // status: Status.fromJson(json["status"]),
        roleId: json["role_id"],
        email: json["email"],
        clientId: json["client_id"],
        // clientName: ClientName.fromJson(json["client_name"]),
        firstName: json["first_name"],
        lastName: json["last_name"],
        panImage: json["pan_image"],
        aadharImage: json["aadhar_image"],
        wishCertificateImage: json["wish_certificate_image"],
        // cluster: List<Gender>.from(json["cluster"].map((x) => Gender.fromJson(x))),
        baseUrl: json["base_url"],
    );

    Map<String, dynamic> toJson() => {
        "start_time": startTime!.toIso8601String(),
        "end_time": endTime!.toIso8601String(),
        // "gender": gender!.toJson(),
        "mobile": mobile,
        "address": address,
        "city": city,
        "profile_image": profileImage,
        "status": status!.toJson(),
        "role_id": roleId,
        "email": email,
        "client_id": clientId,
        "client_name": clientName!.toJson(),
        "first_name": firstName,
        "last_name": lastName,
        "pan_image": panImage,
        "aadhar_image": aadharImage,
        "wish_certificate_image": wishCertificateImage,
        "cluster": List<dynamic>.from(cluster!.map((x) => x.toJson())),
        "base_url": baseUrl,
    };
}

class ClientName {
    String? label;
    String? value;

    ClientName({
        this.label,
        this.value,
    });

    factory ClientName.fromJson(Map<String, dynamic> json) => ClientName(
        label: json["label"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
    };
}

class Gender {
    int? value;
    String? label;

    Gender({
        this.value,
        this.label,
    });

    factory Gender.fromJson(Map<String, dynamic> json) => Gender(
        value: json["value"],
        label: json["label"],
    );

    Map<String, dynamic> toJson() => {
        "value": value,
        "label": label,
    };
}

class Status {
    String? label;
    bool? value;

    Status({
        this.label,
        this.value,
    });

    factory Status.fromJson(Map<String, dynamic> json) => Status(
        label: json["label"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
    };
}
