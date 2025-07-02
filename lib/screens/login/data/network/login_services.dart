import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';
import 'package:woloo_smart_hygiene/screens/login/data/model/send_otp.dart';
import 'package:woloo_smart_hygiene/screens/login/data/model/verify_otp_model.dart';

class LoginService {
  final DioClient dio;
  const LoginService({required this.dio});

  Future<SendOtp> sendOTP({required String phoneNumber}) async {
    try {
      var response = await dio.post(
        APIConstants.SEND_OTP,
        data: {
          "mobileNumber": phoneNumber,
        },
      );

      return SendOtp.fromJson(response['results']);
    } catch (e) {
      rethrow;
    }
  }

  // Future<String> checkIn({required String type, required List<double> locations}) async {
  //   try {
  //     var response = await dio.post(
  //       APIConstants.SEND_OTP,
  //       data: {
  //         "type": type,
  //         "location": locations,
  //       },
  //       options: Options(extra: {"auth": true}),
  //     );

  //     return response['results']?.toString() ?? '';
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<List<UpdateTokenModel>> updateFCMToken({required String token}) async {
  //   try {
  //     var response = await dio.put(
  //       APIConstants.UPDATE_TOKEN_FCM,
  //       data: {
  //         "token": token,
  //       },
  //       options: Options(extra: {"auth": true}),
  //     );
  //     List<UpdateTokenModel> output = [];
  //     for (var item in response['results']) {
  //       output.add(UpdateTokenModel.fromJson(item));
  //     }
  //     return output;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<VerifyOtpModel> verifyOTP({required String otp, required String requestId}) async {
    try {
      var response = await dio.post(
        APIConstants.VERIFY_OTP,
        data: {
          "request_id": requestId,
          "otp": otp,
        },
      );


      return VerifyOtpModel.fromJson(response['results']);
    } catch (e) {
      rethrow;
    }
  }
}
