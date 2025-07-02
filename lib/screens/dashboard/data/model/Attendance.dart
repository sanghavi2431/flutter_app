// last_attendance : {"type":"check_out","location":[19,20]}
// last_attendance_date : "2023-10-09T07:26:54.627Z"

// class Attendance {
//   Attendance({
//     this.lastAttendance,
//     this.lastAttendanceDate,
//   });
//
//   Attendance.fromJson(dynamic json) {
//     lastAttendance = json['last_attendance'] != null
//         ? LastAttendance.fromJson(json['last_attendance'])
//         : null;
//     lastAttendanceDate = json['last_attendance_date'];
//   }
//   LastAttendance? lastAttendance;
//   String? lastAttendanceDate;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     if (lastAttendance != null) {
//       map['last_attendance'] = lastAttendance?.toJson();
//     }
//     map['last_attendance_date'] = lastAttendanceDate;
//     return map;
//   }
// }

// To parse this JSON data, do
//
//     final attendance = attendanceFromJson(jsonString);

// import 'dart:convert';

// Attendance attendanceFromJson(String str) => Attendance.fromJson(json.decode(str));

// String attendanceToJson(Attendance data) => json.encode(data.toJson());

// class Attendance {
//   Results? results;
//   bool? success;

//   Attendance({
//     this.results,
//     this.success,
//   });

//   factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
//     results: Results.fromJson(json["results"]),
//     success: json["success"],
//   );

//   Map<String, dynamic> toJson() => {
//     "results": results!.toJson(),
//     "success": success,
//   };
// }

// class Results {
//   String? message;
//   AttendanceClass? attendance;

//   Results({
//     this.message,
//     this.attendance,
//   });

//   factory Results.fromJson(Map<String, dynamic> json) => Results(
//     message: json["message"],
//     attendance: AttendanceClass.fromJson(json["attendance"]),
//   );

//   Map<String, dynamic> toJson() => {
//     "message": message,
//     "attendance": attendance!.toJson(),
//   };
// }

// class AttendanceClass {
//   LastAttendance? lastAttendance;
//   DateTime? lastAttendanceDate;

//   AttendanceClass({
//     this.lastAttendance,
//     this.lastAttendanceDate,
//   });

//   factory AttendanceClass.fromJson(Map<String, dynamic> json) => AttendanceClass(
//     lastAttendance: LastAttendance.fromJson(json["last_attendance"]),
//     lastAttendanceDate: DateTime.parse(json["last_attendance_date"]),
//   );

//   Map<String, dynamic> toJson() => {
//     "last_attendance": lastAttendance!.toJson(),
//     "last_attendance_date": lastAttendanceDate!.toIso8601String(),
//   };
// }

// class LastAttendance {
//   DateTime? time;
//   String? type;
//   List<double>? location;

//   LastAttendance({
//     this.time,
//     this.type,
//     this.location,
//   });

//   factory LastAttendance.fromJson(Map<String, dynamic> json) => LastAttendance(
//     time: DateTime.parse(json["time"]),
//     type: json["type"],
//     location: List<double>.from(json["location"].map((x) => x.toDouble())),
//   );

//   Map<String, dynamic> toJson() => {
//     "time": time!.toIso8601String(),
//     "type": type,
//     "location": List<dynamic>.from(location!.map((x) => x)),
//   };
// }

