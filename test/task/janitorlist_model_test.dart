import 'package:Woloo_Smart_hygiene/screens/janitor_screen/data/model/Janitor_list_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('JanitorListModel fromJson and toJson test', () {
    // Mock JSON data
    final mockJson = {
      "id": "123",
      "name": "John Doe",
      "mobile": "9876543210",
      "cluster_id": "456",
      "cluster_name": "Cluster A",
      "pincode": "123456",
      "start_time": "2023-12-01T09:00:00Z",
      "end_time": "2023-12-01T17:00:00Z",
      "total": "10",
      "pending": "2",
      "accepted": "6",
      "rejects": "1",
      "requestForClosure": "1",
      "ongoing": "3",
      "isPresent": true,
      "shift": "Morning",
      "completed": "8",
      "base_url": "http://example.com",
      "profile_image": "profile.jpg",
      "gender": "Male"
    };

    // Deserialize JSON to JanitorListModel
    final janitor = JanitorListModel.fromJson(mockJson);

    // Assertions for deserialized object
    expect(janitor.id, "123");
    expect(janitor.name, "John Doe");
    expect(janitor.mobile, "9876543210");
    expect(janitor.clusterId, "456");
    expect(janitor.clusterName, "Cluster A");
    expect(janitor.pincode, "123456");
    expect(janitor.startTime, "2023-12-01T09:00:00Z");
    expect(janitor.endTime, "2023-12-01T17:00:00Z");
    expect(janitor.totalTaskCount, "10");
    expect(janitor.pendingTaskCount, "2");
    expect(janitor.acceptedTaskCount, "6");
    expect(janitor.rejectsTaskCount, "1");
    expect(janitor.rfcTaskCount, "1");
    expect(janitor.onGoingTaskCount, "3");
    expect(janitor.isPresent, true);
    expect(janitor.shift, "Morning");
    expect(janitor.completedTaskCount, "8");
    expect(janitor.baseUrl, "http://example.com");
    expect(janitor.profileImage, "profile.jpg");
    expect(janitor.gender, "Male");

    // Serialize model back to JSON
    final jsonOutput = janitor.toJson();

    // Ensure the output JSON matches the input
    expect(jsonOutput, mockJson);
  });
}
