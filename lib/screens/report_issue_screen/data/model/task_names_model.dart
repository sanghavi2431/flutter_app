// id : "57"
// template_name : "Washroom Cleaning"

class TaskNamesModels {
  TaskNamesModels({
    this.id,
    this.templateName,
  });

  TaskNamesModels.fromJson(dynamic json) {
    id = json['id'];
    templateName = json['template_name'];
  }
  String? id;
  String? templateName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['template_name'] = templateName;
    return map;
  }
}
