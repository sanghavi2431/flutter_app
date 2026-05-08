// id : 12
// name : "Shreya"

class CreateTaskIdModel {
  CreateTaskIdModel({
    this.id,
  });

  CreateTaskIdModel.fromJson(dynamic json) {
    id = json['id'];
  }
  int? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    return map;
  }
}
