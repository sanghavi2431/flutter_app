import 'Attendance.dart';

/// message : "Janitor checked_out successfully"
/// attendance : {"last_attendance":{"type":"check_out","location":[19,20]},"last_attendance_date":"2023-10-09T07:26:54.627Z"}

// To parse this JSON data, do
//
//     final attendanceModel = attendanceModelFromJson(jsonString);

import 'dart:convert';

AttendanceModel attendanceModelFromJson(String str) => AttendanceModel.fromJson(json.decode(str));

String attendanceModelToJson(AttendanceModel data) => json.encode(data.toJson());

class AttendanceModel {
    Results? results;
    bool? success;

    AttendanceModel({
        this.results,
        this.success,
    });

    factory AttendanceModel.fromJson(Map<String, dynamic> json) => AttendanceModel(
        results: Results.fromJson(json["results"]),
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "results": results!.toJson(),
        "success": success,
    };
}

class Results {
    String? message;
    Attendance? attendance;

    Results({
        this.message,
        this.attendance,
    });

    factory Results.fromJson(Map<String, dynamic> json) => Results(
        message: json["message"],
        attendance: Attendance.fromJson(json["attendance"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "attendance": attendance!.toJson(),
    };
}

class Attendance {
    LastAttendance? lastAttendance;
    DateTime? lastAttendanceDate;

    Attendance({
        this.lastAttendance,
        this.lastAttendanceDate,
    });

    factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        lastAttendance: LastAttendance.fromJson(json["last_attendance"]),
        lastAttendanceDate: DateTime.parse(json["last_attendance_date"]),
    );

    Map<String, dynamic> toJson() => {
        "last_attendance": lastAttendance!.toJson(),
        "last_attendance_date": lastAttendanceDate!.toIso8601String(),
    };
}

class LastAttendance {
    DateTime? time;
    String? type;
    List<double>? location;

    LastAttendance({
        this.time,
        this.type,
        this.location,
    });

    factory LastAttendance.fromJson(Map<String, dynamic> json) => LastAttendance(
        time: DateTime.parse(json["time"]),
        type: json["type"],
        location: List<double>.from(json["location"].map((x) => x.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "time": time!.toIso8601String(),
        "type": type,
        "location": List<dynamic>.from(location!.map((x) => x)),
    };
}
