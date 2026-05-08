import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/login_flow.dart';
import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';
import 'package:woloo_smart_hygiene/janitorial_services/model/host_dashboard_screen.dart';
import 'package:woloo_smart_hygiene/janitorial_services/model/iotdata_model.dart';
import 'package:woloo_smart_hygiene/utils///logger.dart';

import '../../core/local/global_storage.dart';
import '../models/user_prolfie.dart';

class LoginFlowService {
  final DioClient dio;
  const LoginFlowService({required this.dio});

  Future<String> emailPassRegister({
    required String email,
    required String pass,
  }) async {
    try {
      var response = await dio.post(
        APIConstants.EMAIL_PASS_REGISTER,
        data: {
          "email": email,
          "password": pass,
        },
        options: Options(
          headers: {
            'x-publishable-api-key':
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
            'Content-Type': 'application/x-www-form-urlencoded',
            'Cookie':
                'connect.sid=s%3ASfJ36OuHe8J1gf7mca9Ypke1aASxt4Ol.u11Lo%2BTCFXo04cJRSLUarjOOCDi6xR5Q9ZdEyDihHh8'
          },
        ),
      );

      return (response['token']);
    } catch (e) {
      debugPrint("Error in IOT service: $e");
      rethrow;
    }
  }

  Future<StoreCustomersRes> createCustomer({
    required String email,
    required String token,
  }) async {
    try {
      var response = await dio.post(
        APIConstants.STORE_CUSTOMER_REGISTER,
        data: {
          "email": email,
        },
        options: Options(
          headers: {
            'x-publishable-api-key':
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
            'Content-Type': 'application/json',
            'Cookie':
                'connect.sid=s%3ASfJ36OuHe8J1gf7mca9Ypke1aASxt4Ol.u11Lo%2BTCFXo04cJRSLUarjOOCDi6xR5Q9ZdEyDihHh8; connect.sid=s%3ASfJ36OuHe8J1gf7mca9Ypke1aASxt4Ol.u11Lo%2BTCFXo04cJRSLUarjOOCDi6xR5Q9ZdEyDihHh8',
            'Authorization': 'Bearer $token'
          },
        ),
      );

      return StoreCustomersRes.fromJson(response);
    } catch (e) {
      debugPrint("Error in IOT service: $e");
      rethrow;
    }
  }

  Future<String> loginCustomer({
    required String email,
    required String pass,
    // required String token,
  }) async {
    try {
      var response = await dio.post(
        APIConstants.STORE_CUSTOMER_LOGIN,
        data: {
          "email": email,
          "password": pass,
        },
        options: Options(
          headers: {
            'x-publishable-api-key':
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );
      ////logger.w(response);
      return (response['token']);
    } catch (e) {
      debugPrint("Error in IOT service: $e");
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
           options:  Options(extra: {"auth": true, "isSupervisor": true }),
      );
    
      return response["success"];
    } catch (e) {
      debugPrint("Error in IOT service: $e");
      rethrow;
    }
  }



      Future<UserProfileModel> getProfile(
    // required String email,
  
    // required String clientUserId,
  ) async {
    try {
      GlobalStorage globalStorage = GetIt.instance();

       
      var some =   globalStorage.getClientToken();
      // globalStorage.getToken();
        print( "token in profile  ${some} ");
      var decodedToken = JwtDecoder.decode(some);
        
       print( "iddd ${decodedToken["id"]} ");

      var response = await dio.get(
        '${APIConstants.GET_PROFILE}?id=64501',
        //   options: Options(
        //   headers: {
        //     'Content-Type': 'application/json',
        //     'x-publishable-api-key':
        //         'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
        //     'Authorization': 'Bearer $token',
        //   },
        // ),
        options:  Options(extra: {"auth": true, "isSupervisor": true }),
      );


    
      return UserProfileModel.fromJson(response);
    } catch (e) {
      debugPrint("Error in IOT service: $e");
      rethrow;
    }
  }




}
