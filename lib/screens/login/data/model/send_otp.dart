// request_id : "6578b3fa-e484-4cb6-909d-9afb5cbc3521"

class SendOtp {
  SendOtp({
    this.requestId,
  });

  SendOtp.fromJson(dynamic json) {
    requestId = json['request_id'];
  }
  String? requestId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['request_id'] = requestId;
    return map;
  }
}
