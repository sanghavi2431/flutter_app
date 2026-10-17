// id : "57"
// template_name : "Washroom Cleaning"

class TaskNamesModels {
  TaskNamesModels({this.id, this.templateName, this.estimatedTime});

  TaskNamesModels.fromJson(dynamic json) {
    id = json['id'];
    templateName = json['template_name'];
    estimatedTime = json['estimated_time'];
    //  != null ? int.parse(json['estimated_time'].toString()) : null;
  }

  String? id;
  String? templateName;
  int? estimatedTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['template_name'] = templateName;
    map['estimated_time'] = estimatedTime;
    return map;
  }
}
