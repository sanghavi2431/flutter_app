class TaskDropdownModel {
  TaskDropdownModel({
    this.id,
    this.facilityName,
    this.requiredTime,
    this.isSelected = false,
    this.imageUrl,
  });

  TaskDropdownModel.fromJson(dynamic json) {
    id = json['id'];
    facilityName = json['task_name'];
    requiredTime = json['required_time'];
    imageUrl = json['image_url'];
  }
  int? id;
  String? facilityName;
  int? requiredTime;
  bool? isSelected = false;
  String? imageUrl;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskDropdownModel && other.id == id;

      @override
  int get hashCode => id.hashCode;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['facility_name'] = facilityName;
    map['required_time'] = requiredTime;
    map['image_url'] = imageUrl;
    return map;
  }
}
