import 'package:woloo_smart_hygiene/screens/login/data/model/verify_otp_model.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'path_to_model/verify_otp_model.dart'; // Update with the correct path to your model

void main() {
  test('VerifyOtpModel fromJson and toJson with hardcoded data', () {
    // Hardcoded mock data
    final mockJson = {
      "name": "John Doe",
      "mobile": "9876543210",
      "id": 1,
      "role_id": 2,
      "token": "mockToken123"
    };

    // Deserialize JSON to VerifyOtpModel
    final verifyOtp = VerifyOtpModel.fromJson(mockJson);

    // Assertions
    expect(verifyOtp.name, 'John Doe');
    expect(verifyOtp.mobile, '9876543210');
    expect(verifyOtp.id, 1);
    expect(verifyOtp.roleId, 2);
    expect(verifyOtp.token, 'mockToken123');

    // Serialize model back to JSON
    final jsonOutput = verifyOtp.toJson();

    // Ensure the output JSON matches the input
    expect(jsonOutput, mockJson);
  });
}
