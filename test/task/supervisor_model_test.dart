import 'package:Woloo_Smart_hygiene/screens/supervisor_dashboard/model/Supervisor_model_dashboard.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:your_project_name/supervisor_model_dashboard.dart'; // Adjust the import path

void main() {
  group('SupervisorModelDashboard', () {
    test('fromJson correctly parses valid JSON', () {
      
      final json = {
        "task_allocation_id": 101,
        "date": "2025-01-01",
        "janitor_id": 5,
        "request_type": "cleaning",
        "start_time": "08:00",
        "end_time": "10:00",
        "facility_id": 2,
        "template_id": 1,
        "template_name": "Daily Cleaning",
        "description": "Clean all floors",
        "facility_name": "Building A",
        "estimated_time": 120,
        "total_tasks": 10,
        "booths": 5,
        "floor_number": 2,
        "location": "Main Hall",
        "lat": 12.971598,
        "lng": 77.594566,
        "janitor_name": "John Doe",
        "block_name": "Block B",
        "pending_tasks": "2",
        "status": "in-progress"
      };

      
      final model = SupervisorModelDashboard.fromJson(json);

      
      expect(model.taskAllocationId, 101);
      expect(model.date, "2025-01-01");
      expect(model.janitorId, 5);
      expect(model.requestType, "cleaning");
      expect(model.startTime, "08:00");
      expect(model.endTime, "10:00");
      expect(model.facilityId, 2);
      expect(model.templateId, 1);
      expect(model.templateName, "Daily Cleaning");
      expect(model.description, "Clean all floors");
      expect(model.facilityName, "Building A");
      expect(model.estimatedTime, 120);
      expect(model.totalTasks, 10);
      expect(model.booths, 5);
      expect(model.floorNumber, 2);
      expect(model.location, "Main Hall");
      expect(model.lat, 12.971598);
      expect(model.lng, 77.594566);
      expect(model.janitorName, "John Doe");
      expect(model.blockName, "Block B");
      expect(model.pendingTasks, "2");
      expect(model.status, "in-progress");
    });

    test('toJson converts SupervisorModelDashboard to valid JSON', () {
      // Arrange
      final model = SupervisorModelDashboard(
        taskAllocationId: 101,
        date: "2025-01-01",
        janitorId: 5,
        requestType: "cleaning",
        startTime: "08:00",
        endTime: "10:00",
        facilityId: 2,
        templateId: 1,
        templateName: "Daily Cleaning",
        description: "Clean all floors",
        facilityName: "Building A",
        estimatedTime: 120,
        totalTasks: 10,
        booths: 5,
        floorNumber: 2,
        location: "Main Hall",
        lat: 12.971598,
        lng: 77.594566,
        janitorName: "John Doe",
        blockName: "Block B",
        pendingTasks: "2",
        status: "in-progress",
      );

      
      final json = model.toJson();

    
      expect(json['task_allocation_id'], 101);
      expect(json['date'], "2025-01-01");
      expect(json['janitor_id'], 5);
      expect(json['request_type'], "cleaning");
      expect(json['start_time'], "08:00");
      expect(json['end_time'], "10:00");
      expect(json['facility_id'], 2);
      expect(json['template_id'], 1);
      expect(json['template_name'], "Daily Cleaning");
      expect(json['description'], "Clean all floors");
      expect(json['facility_name'], "Building A");
      expect(json['estimated_time'], 120);
      expect(json['total_tasks'], 10);
      expect(json['booths'], 5);
      expect(json['floor_number'], 2);
      expect(json['location'], "Main Hall");
      expect(json['lat'], 12.971598);
      expect(json['lng'], 77.594566);
      expect(json['janitor_name'], "John Doe");
      expect(json['block_name'], "Block B");
      expect(json['pending_tasks'], "2");
      expect(json['status'], "in-progress");
    });

    test('fromJson handles missing fields gracefully', () {
      
      final json = {
        "task_allocation_id": 101,
       
      };

      // Act
      final model = SupervisorModelDashboard.fromJson(json);

      // Assert
      expect(model.taskAllocationId, 101);
      expect(model.date, isNull);
      expect(model.janitorId, isNull);
    });
  });
}
