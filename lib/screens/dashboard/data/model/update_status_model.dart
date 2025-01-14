/// id : 95
/// status : 3

class UpdateStatusModel {
  UpdateStatusModel({
    this.id,
    this.status,
  });

  UpdateStatusModel.fromJson(dynamic json) {
    id = json['id'];
    status = json['status'];
  }
  int? id;
  int? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['status'] = status;
    return map;
  }
}
