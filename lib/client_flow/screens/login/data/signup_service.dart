

import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';

import '../../dashbaord/model/login_model.dart';
import 'model/otp_model.dart';
import 'model/verify_otp_model.dart';

class SignupService {
  final DioClient dio;
  const SignupService({required this.dio});

  Future creatClient({
  required String phoneNumber,  
  required String name,
  required String email,
  required String password,
  required String address,
    required String city,
    required String pincode,
   
   }) async {
    try {
      var response = await dio.post(
        APIConstants.CREATE_CLIENT,
        data: {
          "name": name,
          "email": email,
          "password": password,
          "mobile": phoneNumber,
          "address": address,
          "city": city,
          "pincode":  pincode
        },
      );

      return response['results']["user_id"].toString();

    } catch (e) {
      rethrow;
    }
  }


  Future<bool> signUp({
  required String userId,
   String? mobileNumber,
   String? name,
   String? email,
   String? password,
  // required int clientUserId,
  required int clientTypeId,
   String? address,
   String? city,
   String? pincode,
    }) async {
    try {

      //
      var response = await dio.post(
        options:  Options(
          headers: {
            "x-api-key":  "k45GQj8FtKt0NR074UfFyvCEPAfJBzxY"
          },
        ),
        APIConstants.CLIENT_SIGNUP,
        data: {
          "client_user_id": userId,
          // "client_name": name,
          "client_type_id":clientTypeId,
          // "email":  email,
          "mobile": mobileNumber,
          // "address": address,
          // "city": city,
          // "pincode":  pincode
        },

      );


      return response['success'];
    } catch (e) {
      rethrow;
    }
  }


  Future<LoginModel> login({
  required String email,
  required String password,
  // required int clientUserId,

    }) async {
    try {
      var response = await dio.post(
        APIConstants.CLIENT_LOGIN,
        data: {
          "email":  email,
          "password": password
        },
      );


      return LoginModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }



  Future<OtpModel> sendOtp({
  required String mobileNo,

    }) async {
    try {
      var response = await dio.post(
        APIConstants.SEND_OTP_CLIENT,
        data: {
          "mobileNumber":  mobileNo,
        },
      );


      return OtpModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }



  Future<VerfiyOtpModel> verifyOtp({
  required String requestId,
  required String otp,
    }) async {
    try {

      var response = await dio.post(
        APIConstants.VERIFY_OTP_CLIENT,
        data: {
          "request_id": requestId,
          "otp": otp
        },
      );
      
      return VerfiyOtpModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }





  Future<LoginModel> extendExpiry({
  required int clientId,
  required int days,
  // required int clientUserId,

    }) async {
    try {
      var response = await dio.post(
        APIConstants.EXTEND_EXPIRY,
        data: {
             "client_id": clientId,
             "days": 15
        },
      );


      return LoginModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }



 
    Future<bool> updateCustomer({
    // required String email,
    required String token,
    // required String token,
  }) async {
    try {
      var response = await dio.patch(
        APIConstants.UPDATE_CUSTOMER,
        
        // data: {
        //   "email": email,
        //   "password": pass,
        // },
        options: Options(
          headers: {
            "x-woloo-token": token,
            // 'x-publishable-api-key':
                // 'pk_03b79693816aae4cb87568dc50b7efaa48e0d51b201040f46ef4528839078f08',
            'Content-Type': 'application/json',
            //  'Authorization': 'Bearer $token'
          },
        ),
      );
    
      return response["success"];
    } catch (e) {
      debugPrint("Error in IOT service: $e");
      rethrow;
    }
  }











}
