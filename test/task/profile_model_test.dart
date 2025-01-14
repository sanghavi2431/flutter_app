import 'package:Woloo_Smart_hygiene/screens/my_account/data/model/profile_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert'; // For json.decode and json.encode

void main() {
  test('ProfileModel fromJson and toJson with hardcoded data', () {
    // Hardcoded mock data
    final mockJson = {
      "results": {
        "start_time": "2023-12-01T09:00:00Z",
        "end_time": "2023-12-01T17:00:00Z",
        "mobile": "1234567890",
        "address": "123 Main St",
        "city": "Metropolis",
        "profile_image": "profile.jpg",
        "role_id": 1,
        "email": "johndoe@example.com",
        "client_id": null,
        "first_name": "John",
        "last_name": "Doe",
        "pan_image": "pan.jpg",
        "aadhar_image": "aadhar.jpg",
        "wish_certificate_image": "certificate.jpg",
        "base_url": "http://example.com"
      },
      "success": true
    };

    // Deserialize JSON to ProfileModel
    final profileModel = ProfileModel.fromJson(mockJson);

    // Assertions
    expect(profileModel.success, true);
    expect(profileModel.results?.startTime, DateTime.parse("2023-12-01T09:00:00Z"));
    expect(profileModel.results?.endTime, DateTime.parse("2023-12-01T17:00:00Z"));
    expect(profileModel.results?.mobile, "1234567890");
    expect(profileModel.results?.address, "123 Main St");
    expect(profileModel.results?.city, "Metropolis");
    expect(profileModel.results?.profileImage, "profile.jpg");
    expect(profileModel.results?.roleId, 1);
    expect(profileModel.results?.email, "johndoe@example.com");
    expect(profileModel.results?.firstName, "John");
    expect(profileModel.results?.lastName, "Doe");
    expect(profileModel.results?.panImage, "pan.jpg");
    expect(profileModel.results?.aadharImage, "aadhar.jpg");
    expect(profileModel.results?.wishCertificateImage, "certificate.jpg");
    expect(profileModel.results?.baseUrl, "http://example.com");

    // Serialize model back to JSON
    final jsonOutput = profileModel.toJson();

    // Ensure the output JSON matches the input
    expect(jsonOutput, mockJson);
  });
}
