import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../core/network/dio_client.dart';
import '../model/profile_model.dart';

class ProfileService {
  final DioClient dio;
  const ProfileService({required this.dio});

  Future<ProfileModel> getProfile({required int supervisorId, String? token}) async {
    try {

      var response = await dio.get(
       "${APIConstants.USER_DETAILS}?id=${supervisorId.toString()}",
       options:
        token != null ? Options(
            headers: {
              "x-woloo-token":  token
            },
          ) :
        Options(extra: {"auth": true}),
      );

      debugPrint("suprer s ${response['results']} " );
     // ProfileModel output = [];
      // for (var item in response['results']) {
      //   output.add(ProfileModel.fromJson(item));
      // }

    var   res  = ProfileModel.fromJson(response);
       
      return res;
    } catch (e) {
      rethrow;
    }
  }
}