import 'dart:io';

import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

class SelfieService {
  final DioClient dio;

  const SelfieService({required this.dio});

  Future<String> uploadSelfie({required String type, required File image, required String id, required String remarks, String? token}) async {
    try {
      FormData formData = FormData();

      /// Add image
      formData = FormData.fromMap({
        "type": type,
        "id": id,
        "remarks": remarks,
      });
      debugPrint("image.path ${image.path}");
      debugPrint("dfs $id");
      debugPrint("dsds ${getFileName(image.path)}");
      debugPrint("exr ${getFileExtension(image.path)}");

      formData.files.addAll([
        MapEntry(
          "image",
          await MultipartFile.fromFile(
            image.path,
            filename: getFileName(image.path),
            contentType: MediaType(getType(image.path), getFileExtension(image.path)),
          ),
        ),
      ]);

      var response = await dio.post(
        APIConstants.UPLOAD_SELFIE,
        data: formData,
        options:
         token != null ? 
            Options(
            headers: {
              "x-woloo-token":  token
            },
          )
        // Options(extra: {"auth": true}) 
         :
         Options(extra: {"auth": true}),
      );
      debugPrint("response $response");

      return response['results']?.toString() ?? '';
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
