import 'package:woloo_smart_hygiene/screens/task_list/data/model/task_list_model.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:your_project_name/task_list_model.dart'; // Update with the correct path

void main() {
  group('TaskListModel', () {
    test('fromJson creates a valid TaskListModel', () {
      // Arrange
      final json = {
        "template_id": "123",
        "tasks": [
          {"id": "1", "task_id": "16", "task_name": "Doors", "status": "completed"},
          {"id": "2", "task_id": "17", "task_name": "Windows", "status": "pending"}
        ]
      };

      // Act
      final model = TaskListModel.fromJson(json);

      // Assert
      expect(model.templateId, "123");
      expect(model.tasks, isNotNull);
      expect(model.tasks!.length, 2);
      expect(model.tasks![0].taskName, "Doors");
    });

    test('toJson converts TaskListModel to JSON', () {
      // Arrange
      final tasks = [
        Tasks(id: "1", taskId: "16", taskName: "Doors", status: "completed"),
        Tasks(id: "2", taskId: "17", taskName: "Windows", status: "pending")
      ];
      final model = TaskListModel(templateId: "123", tasks: tasks);

      // Act
      final json = model.toJson();

      // Assert
      expect(json['template_id'], "123");
      expect(json['tasks'], isNotNull);
      expect(json['tasks'].length, 2);
      expect(json['tasks'][0]['task_name'], "Doors");
    });

    test('fromJson handles missing tasks gracefully', () {
      // Arrange
      final json = {
        "template_id": "123"
      };

      // Act
      final model = TaskListModel.fromJson(json);

      // Assert
      expect(model.templateId, "123");
      expect(model.tasks, isNull);
    });
  });

  group('Tasks', () {
    test('fromJson creates a valid Tasks object', () {
      // Arrange
      final json = {"id": "1", "task_id": "16", "task_name": "Doors", "status": "completed"};

      // Act
      final task = Tasks.fromJson(json);

      // Assert
      expect(task.id, "1");
      expect(task.taskId, "16");
      expect(task.taskName, "Doors");
      expect(task.status, "completed");
    });

    test('toJson converts Tasks to JSON', () {
      // Arrange
      final task = Tasks(id: "1", taskId: "16", taskName: "Doors", status: "completed");

      // Act
      final json = task.toJson();

      // Assert
      expect(json['id'], "1");
      expect(json['task_id'], "16");
      expect(json['task_name'], "Doors");
      expect(json['status'], "completed");
    });
  });
}
