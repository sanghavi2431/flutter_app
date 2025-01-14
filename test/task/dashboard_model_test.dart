import 'package:Woloo_Smart_hygiene/screens/dashboard/data/model/dashboard_model_class.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

void main() {
  test('DashboardModelClass fromJson and toJson test', () {
    // Mock JSON data
    final mockJson = {
      "task_allocation_id": "123",
      "date": "2025-01-08",
      "janitor_id": "456",
      "request_type": "cleaning",
      "start_time": "08:00",
      "end_time": "12:00",
      "facility_id": "789",
      "template_id": 1,
      "template_name": "Morning Routine",
      "task_description": "Clean the first floor",
      "issue_description": "None",
      "facility_name": "Building A",
      "estimated_time": "4 hours",
      "total_tasks": "10",
      "booths": "5",
      "floor_number": "1",
      "location": "Entrance",
      "lat": 28.6139,
      "lng": 77.2090,
      "block_name": "Block 1",
      "pending_tasks": "2",
      "status": "Pending"
    };

    // Deserialize JSON to DashboardModelClass
    final model = DashboardModelClass.fromJson(mockJson);

    // Assertions for deserialized object
    expect(model.taskAllocationId, "123");
    expect(model.date, "2025-01-08");
    expect(model.janitorId, "456");
    expect(model.requestType, "cleaning");
    expect(model.lat, 28.6139);
    expect(model.lng, 77.2090);
    expect(model.status, "Pending");

    // Serialize model back to JSON
    final jsonOutput = model.toJson();

    // Ensure the output JSON matches the input
    expect(jsonOutput, mockJson);
  });
}
