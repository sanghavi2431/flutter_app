
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
// import 'package:http_parser/http_parser.dart';
import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';
import 'package:woloo_smart_hygiene/screens/login/data/model/update_token_model.dart';

import '../../client_flow/screens/dashbaord/data/model/client_model.dart';



class CoreService {
  final DioClient dio = GetIt.instance<DioClient>();

  Future<List<UpdateTokenModel>>  updateFCMToken({required String token}) async {
    try {
       debugPrint("api call $token");
      var response = await dio.put(
        APIConstants.UPDATE_TOKEN_FCM,
        data: {
          "token": token,
        },
        options: Options(extra: {"auth": true}),
      );



        List<UpdateTokenModel> output = [];
      for (var item in response['results']) {
        output.add(UpdateTokenModel.fromJson(item));
      }

       debugPrint("token update notitification $output");

      return output;
    } catch (e) {
      rethrow;
    }
  }


 
 Future<ClientModel> getClient({
  required int id,
}) async {
  try {
      
     ClientModel clientModel;
    // Data payload with all parameters
 

    var response = await dio.get(
     "${APIConstants.GET_CLIENT_ID}?user_id=$id",
      options:  Options(extra: {"auth": true, "isSupervisor": true }),
    );

     clientModel =  ClientModel.fromJson(response);

    return clientModel;
  } catch (e) {
    rethrow;
  }
}
 

  getFileName(String path) {
    return path.split('/').last;
  }

  getFileExtension(String path) {
    return path.split('/').last.split(".").last;
  }

  getType(String path) {
    String extension = getFileExtension(path);
    switch (extension) {
      case "pdf":
        return "application";
      case "jpg":
        return "image";
      case "jpeg":
        return "image";
      case "png":
        return "image";
    }
    return "";
  }
}
