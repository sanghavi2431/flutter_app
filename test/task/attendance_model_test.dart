import 'package:woloo_smart_hygiene/screens/dashboard/data/model/attendance_model.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'path_to_model/attendance_model.dart'; // Update with your model's path

void main() {
  test('AttendanceModel fromJson and toJson test', () {
    // Mock JSON data
    final mockJson = {
      "results": {
        "message": "Attendance recorded",
        "attendance": {
          "last_attendance": {
            "time": "2025-01-08T10:30:00.000Z",
            "type": "check-in",
            "location": [28.6139, 77.2090]
          },
          "last_attendance_date": "2025-01-08T00:00:00.000Z"
        }
      },
      "success": true
    };

    // Deserialize JSON to AttendanceModel
    final model = AttendanceModel.fromJson(mockJson);

    // Assertions for deserialized object
    expect(model.success, true);
    expect(model.results?.message, "Attendance recorded");
    expect(model.results?.attendance?.lastAttendance?.type, "check-in");
    expect(model.results?.attendance?.lastAttendance?.location, [28.6139, 77.2090]);
    expect(model.results?.attendance?.lastAttendanceDate, DateTime.parse("2025-01-08T00:00:00.000Z"));

    // Serialize model back to JSON
    final jsonOutput = model.toJson();

    // Ensure the output JSON matches the input
    expect(jsonOutput, mockJson);
  });
}
