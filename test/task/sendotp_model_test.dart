import 'package:woloo_smart_hygiene/screens/login/data/model/send_otp.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'path_to_model/send_otp.dart'; // Update with the correct path to your model

void main() {
  test('SendOtp fromJson and toJson with hardcoded data', () {
    // Hardcoded mock data
    final mockJson = {
      "request_id": "12345"
    };

    // Deserialize JSON to SendOtp model
    final sendOtp = SendOtp.fromJson(mockJson);

    // Assertions
    expect(sendOtp.requestId, '12345');

    // Serialize model back to JSON
    final jsonOutput = sendOtp.toJson();

    // Ensure the output JSON matches the input
    expect(jsonOutput, mockJson);
  });
}
