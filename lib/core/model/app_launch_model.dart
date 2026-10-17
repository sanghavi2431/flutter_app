// last_attendance : "check_in"
// last_attendance_date : "2023-10-09T07:26:54.627Z"

class AppLaunchModel {
  AppLaunchModel({
    this.lastAttendance,
    this.lastAttendanceDate,
  });

  AppLaunchModel.fromJson(dynamic json) {
    final raw = json['last_attendance'];
    // API may return a string ("check_in") or an object ({"type":"check_in",...}).
    if (raw is Map) {
      lastAttendance = raw['type']?.toString();
    } else {
      lastAttendance = raw?.toString();
    }
    lastAttendanceDate = json['last_attendance_date']?.toString();
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
