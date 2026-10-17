// check_in : "-"
// check_out : "-"
// day_of_week : "Sun"
// date : "01"
// attendance : "Absent"

class AttendanceHistoryModel {
  AttendanceHistoryModel({
    this.checkIn,
    this.checkOut,
    this.dayOfWeek,
    this.date,
    this.attendance,
  });

  AttendanceHistoryModel.fromJson(dynamic json) {
    checkIn = json['check_in']?.toString();
    checkOut = json['check_out']?.toString();
    dayOfWeek = json['day_of_week']?.toString();
    date = json['date']?.toString();
    attendance = json['attendance']?.toString();
  }
  String? checkIn;
  String? checkOut;
  String? dayOfWeek;
  String? date;
  String? attendance;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['check_in'] = checkIn;
    map['check_out'] = checkOut;
    map['day_of_week'] = dayOfWeek;
    map['date'] = date;
    map['attendance'] = attendance;
    return map;
  }
}
