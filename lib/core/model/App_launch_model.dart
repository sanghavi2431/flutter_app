/// last_attendance : "check_in"
/// last_attendance_date : "2023-10-09T07:26:54.627Z"

class AppLaunchModel {
  AppLaunchModel({
    this.lastAttendance,
    this.lastAttendanceDate,
  });

  AppLaunchModel.fromJson(dynamic json) {
    lastAttendance = json['last_attendance'];
    lastAttendanceDate = json['last_attendance_date'];
  }
  String? lastAttendance;
  String? lastAttendanceDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['last_attendance'] = lastAttendance;
    map['last_attendance_date'] = lastAttendanceDate;
    return map;
  }
}
