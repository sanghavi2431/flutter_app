import 'package:woloo_smart_hygiene/core/model/app_launch_model.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'path_to_model/app_launch_model.dart'; // Update with your model's path

void main() {
  test('AppLaunchModel fromJson and toJson test', () {
    // Mock JSON data
    final mockJson = {
      "last_attendance": "2025-01-01 08:00:00",
      "last_attendance_date": "2025-01-01"
    };

    // Deserialize JSON to AppLaunchModel
    final model = AppLaunchModel.fromJson(mockJson);

    // Assertions for deserialized object
    expect(model.lastAttendance, "2025-01-01 08:00:00");
    expect(model.lastAttendanceDate, "2025-01-01");

    // Serialize model back to JSON
    final jsonOutput = model.toJson();

    // Ensure the output JSON matches the input
    expect(jsonOutput, mockJson);
  });
}
