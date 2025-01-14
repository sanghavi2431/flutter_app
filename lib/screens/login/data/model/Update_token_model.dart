/// id : 156
/// name : "Snehal Chavan"
/// start_time : null
/// end_time : null
/// gender : "undefined"
/// mobile : "9284102357"
/// status : true
/// role_id : 2
/// address : "undefined"
/// city : "pune"
/// documents : {}
/// email : "snehal@mail.com"
/// client : null
/// fcm_token : "eWtBu3S7Qvm4UYGMQ8VRz-:APA91bGhcKOzy9UUlKeRKU82UDqWwrHlIZDPzwarKAdKk9optpcrjTGI_37ibqIL7MuyQjVHj4hKZ4jPq3n7QnYjQQQnIKqV-vs8iLlJiXa_5KWVh8fLD5kEIqPjT64V7zN-7vi1cdzZ"
/// client_id : null
/// password : null

class UpdateTokenModel {
  UpdateTokenModel({
    this.id,
    this.name,
    this.startTime,
    this.endTime,
    this.gender,
    this.mobile,
    this.status,
    this.roleId,
    this.address,
    this.city,
    this.documents,
    this.email,
    this.client,
    this.fcmToken,
    this.profileImage,
    this.clientId,
    this.password,
  });

  UpdateTokenModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    gender = json['gender'];
    mobile = json['mobile'];
    status = json['status'];
    roleId = json['role_id'];
    address = json['address'];
    city = json['city'];
    documents = json['documents'];
    email = json['email'];
    client = json['client'];
    fcmToken = json['fcm_token'];
    profileImage = json['profile_image'] ?? "";
    clientId = json['client_id'];
    password = json['password'];

  }
  int? id;
  String? name;
  String? startTime;
  dynamic endTime;
  String? gender;
  String? mobile;
  bool? status;
  int? roleId;
  String? address;
  String? city;
  dynamic documents;
  String? email;
  dynamic client;
  String? fcmToken;
  String? profileImage;
  dynamic clientId;
  dynamic password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['start_time'] = startTime;
    map['end_time'] = endTime;
    map['gender'] = gender;
    map['mobile'] = mobile;
    map['status'] = status;
    map['role_id'] = roleId;
    map['address'] = address;
    map['city'] = city;
    map['documents'] = documents;
    map['email'] = email;
    map['client'] = client;
    map['fcm_token'] = fcmToken;
    map['profile_image'] = profileImage ?? "";
    map['client_id'] = clientId;
    map['password'] = password;
    return map;
  }
}
