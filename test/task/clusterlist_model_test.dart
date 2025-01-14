import 'package:Woloo_Smart_hygiene/screens/cluster_screen/data/model/Cluster_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
// import 'path_to_model/cluster_model.dart'; // Update with your model's path

void main() {
  test('ClusterModel fromJson and toJson test', () {
    // Mock JSON data
    final mockJson = {
      "cluster_id": 101,
      "cluster_name": "Cluster A",
      "pincode": "110001",
      "pending_tasks": "5",
      "completed_tasks": "15",
      "total_tasks": "20"
    };

    // Deserialize JSON to ClusterModel
    final model = ClusterModel.fromJson(mockJson);

    // Assertions for deserialized object
    expect(model.clusterId, 101);
    expect(model.clusterName, "Cluster A");
    expect(model.pincode, "110001");
    expect(model.pendingTasks, "5");
    expect(model.completedTasks, "15");
    expect(model.totalTasks, "20");

    // Serialize model back to JSON
    final jsonOutput = model.toJson();

    // Ensure the output JSON matches the input
    expect(jsonOutput, mockJson);
  });
}
