// month : "11"
// year : "2023"

class MonthListModel {
  MonthListModel({
    this.month,
    this.year,
  });

  MonthListModel.fromJson(dynamic json) {
    month = json['month']?.toString();
    year = json['year']?.toString();
  }
  String? month;
  String? year;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['month'] = month;
    map['year'] = year;
    return map;
  }
}
