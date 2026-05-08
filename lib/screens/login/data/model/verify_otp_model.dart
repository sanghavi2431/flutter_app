// name : "Adelina"
// mobile : "8149155402"
// id : 4
// role_id : 1
// token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwiaWF0IjoxNjkwNDQxMDM2LCJleHAiOjE2OTA1Mjc0MzZ9.69tyLwx9rdVk73w7GrVlKgNniGftaG1lYO2yzHqBuEs"

import 'package:flutter/foundation.dart';

class VerifyOtpModel {
  VerifyOtpModel({
    this.name,
    this.mobile,
    this.id,
    this.roleId,
    this.token,
    this.languageCodes,
    // this.fcm_token
  });

  VerifyOtpModel.fromJson(dynamic json) {
    name = json['name'];
    mobile = json['mobile'];
    id = json['id'];
    roleId = json['role_id'];
    token = json['token'];
    debugPrint("VerifyOtpModel.fromJson - Raw language_codes from API: ${json['language_codes']}");
    debugPrint("VerifyOtpModel.fromJson - language_codes type: ${json['language_codes']?.runtimeType}");
    if (json['language_codes'] != null) {
      debugPrint("VerifyOtpModel.fromJson - language_codes is List: ${json['language_codes'] is List}");
      if (json['language_codes'] is List) {
        debugPrint("VerifyOtpModel.fromJson - language_codes length: ${(json['language_codes'] as List).length}");
      }
    }
    languageCodes = json['language_codes'] == null
        ? null
        : List<String>.from(json['language_codes'].map((x) => x.toString()));
    debugPrint("VerifyOtpModel.fromJson - Parsed languageCodes: $languageCodes");
    // fcm_token = json['fcm_token'];
  }
  String? name;
  String? mobile;
  int? id;
  int? roleId;
  String? token;
  List<String>? languageCodes;
  // String? fcm_token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['mobile'] = mobile;
    map['id'] = id;
    map['role_id'] = roleId;
    map['token'] = token;
    map['language_codes'] = languageCodes;
    // map['fcm_token'] = fcm_token;
    return map;
  }
}
