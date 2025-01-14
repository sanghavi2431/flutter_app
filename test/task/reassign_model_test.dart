import 'package:Woloo_Smart_hygiene/screens/janitor_screen/data/model/Reassign_janitor_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ReassignJanitorModel fromJson and toJson test', () {
    // Mock JSON data
    final mockJson = {
      "message": "Janitor reassigned successfully"
    };

    // Deserialize JSON to ReassignJanitorModel
    final model = ReassignJanitorModel.fromJson(mockJson);

    // Assertions for deserialized object
    expect(model.message, "Janitor reassigned successfully");

    // Serialize model back to JSON
    final jsonOutput = model.toJson();

    // Ensure the output JSON matches the input
    expect(jsonOutput, mockJson);
  });
}
