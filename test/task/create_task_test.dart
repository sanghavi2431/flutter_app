import 'package:Woloo_Smart_hygiene/screens/task_list/data/model/create_task_model.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:your_project_name/create_task_model.dart'; // Adjust the import path

void main() {
  group('CreateTaskModel', () {
    test('fromJson correctly parses valid JSON', () {
      // Arrange
      final json = {
        "allocation_id": "123",
        "data": [
          {"task_id": "1", "task_name": "task_1", "status": 1},
          {"task_id": "2", "task_name": "task_2", "status": 0}
        ]
      };

      // Act
      final model = CreateTaskModel.fromJson(json);

      // Assert
      expect(model.allocationId, "123");
      expect(model.data, isNotNull);
      expect(model.data!.length, 2);
      expect(model.data![0].taskName, "task_1");
    });

    test('toJson converts CreateTaskModel to valid JSON', () {
      // Arrange
      final dataList = [
        InternalData(taskId: "1", taskName: "task_1", status: 1),
        InternalData(taskId: "2", taskName: "task_2", status: 0),
      ];
      final model = CreateTaskModel(allocationId: "123", data: dataList);

      // Act
      final json = model.toJson();

      // Assert
      expect(json['allocation_id'], "123");
      expect(json['data'], isNotNull);
      expect(json['data'].length, 2);
      expect(json['data'][0]['task_name'], "task_1");
    });

    test('fromJson handles missing data gracefully', () {
      // Arrange
      final json = {
        "allocation_id": "123",
      };

      // Act
      final model = CreateTaskModel.fromJson(json);

      // Assert
      expect(model.allocationId, "123");
      expect(model.data, isNull);
    });
  });

  group('InternalData', () {
    test('fromJson correctly parses valid JSON', () {
      // Arrange
      final json = {"task_id": "1", "task_name": "task_1", "status": 1};

      // Act
      final data = InternalData.fromJson(json);

      // Assert
      expect(data.taskId, "1");
      expect(data.taskName, "task_1");
      expect(data.status, 1);
    });

    test('toJson converts InternalData to valid JSON', () {
      // Arrange
      final data = InternalData(taskId: "1", taskName: "task_1", status: 1);

      // Act
      final json = data.toJson();

      // Assert
      expect(json['task_id'], "1");
      expect(json['task_name'], "task_1");
      expect(json['status'], 1);
    });

    test('fromJson handles missing fields gracefully', () {
      // Arrange
      final json = {
        "task_id": "1",
        // Missing task_name and status
      };

      // Act
      final data = InternalData.fromJson(json);

      // Assert
      expect(data.taskId, "1");
      expect(data.taskName, isNull);
      expect(data.status, isNull);
    });
  });
}
