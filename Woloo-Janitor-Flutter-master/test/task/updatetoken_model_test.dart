import 'package:woloo_smart_hygiene/screens/login/data/model/update_token_model.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'path_to_model/update_token_model.dart'; // Update with the correct path to your model

void main() {
  test('UpdateTokenModel fromJson and toJson with hardcoded data', () {
    // Hardcoded mock data
    final mockJson = {
      "id": 1,
      "name": "John Doe",
      "start_time": "09:00 AM",
      "end_time": "05:00 PM",
      "gender": "Male",
      "mobile": "9876543210",
      "status": true,
      "role_id": 2,
      "address": "123 Street Name",
      "city": "Metropolis",
      "documents": null,
      "email": "johndoe@example.com",
      "client": null,
      "fcm_token": "sampleFcmToken",
      "profile_image": "profile.jpg",
      "client_id": 100,
      "password": "securepassword"
    };

    // Deserialize JSON to UpdateTokenModel
    final updateTokenModel = UpdateTokenModel.fromJson(mockJson);

    // Assertions
    expect(updateTokenModel.id, 1);
    expect(updateTokenModel.name, "John Doe");
    expect(updateTokenModel.startTime, "09:00 AM");
    expect(updateTokenModel.endTime, "05:00 PM");
    expect(updateTokenModel.gender, "Male");
    expect(updateTokenModel.mobile, "9876543210");
    expect(updateTokenModel.status, true);
    expect(updateTokenModel.roleId, 2);
    expect(updateTokenModel.address, "123 Street Name");
    expect(updateTokenModel.city, "Metropolis");
    expect(updateTokenModel.documents, null);
    expect(updateTokenModel.email, "johndoe@example.com");
    expect(updateTokenModel.client, null);
    expect(updateTokenModel.fcmToken, "sampleFcmToken");
    expect(updateTokenModel.profileImage, "profile.jpg");
    expect(updateTokenModel.clientId, 100);
    expect(updateTokenModel.password, "securepassword");

    // Serialize model back to JSON
    final jsonOutput = updateTokenModel.toJson();

    // Ensure the output JSON matches the input
    expect(jsonOutput, mockJson);
  });
}
