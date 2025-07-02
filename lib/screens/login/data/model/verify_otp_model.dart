
// name : "Adelina"
// mobile : "8149155402"
// id : 4
// role_id : 1
// token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwiaWF0IjoxNjkwNDQxMDM2LCJleHAiOjE2OTA1Mjc0MzZ9.69tyLwx9rdVk73w7GrVlKgNniGftaG1lYO2yzHqBuEs"

class VerifyOtpModel {
  VerifyOtpModel({
    this.name,
    this.mobile,
    this.id,
    this.roleId,
    this.token,
    // this.fcm_token
  });

  VerifyOtpModel.fromJson(dynamic json) {
    name = json['name'];
    mobile = json['mobile'];
    id = json['id'];
    roleId = json['role_id'];
    token = json['token'];
    // fcm_token = json['fcm_token'];
  }
  String? name;
  String? mobile;
  int? id;
  int? roleId;
  String? token;
  // String? fcm_token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['mobile'] = mobile;
    map['id'] = id;
    map['role_id'] = roleId;
    map['token'] = token;
    // map['fcm_token'] = fcm_token;
    return map;
  }
}
