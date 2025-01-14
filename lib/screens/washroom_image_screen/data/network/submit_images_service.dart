import 'dart:io';

import 'package:Woloo_Smart_hygiene/core/network/api_constant.dart';
import 'package:Woloo_Smart_hygiene/core/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class SubmitImagesService {
  final DioClient dio;

  const SubmitImagesService({required this.dio});

  Future<String> uploadImages({
    required String type,
    required List<File> images,
    required String id,
    required String remarks,
  }) async {
    try {
      FormData formData = FormData();

      /// Add image
      formData = FormData.fromMap({
        "type": type,
        "id": id,
        "remarks": remarks,
      });

      for (var file in images) {
        formData.files.add(MapEntry(
          "image",
          await MultipartFile.fromFile(
            file.path,
            filename: getFileName(file.path),
            contentType: MediaType(getType(file.path), getFileExtension(file.path)),
          ),
        ));
      }

      var response = await dio.post(
        APIConstants.UPLOAD_SELFIE,
        data: formData,
        options: Options(extra: {"auth": true}),
      );

      return response['results']?.toString() ?? '';
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateStatus({
    required String id,
    required String status,
  }) async {
    try {
      var response = await dio.post(
        APIConstants.UPDATE_STATUS,
        data: {
          "id": id,
          "status": status,
        },
        options: Options(extra: {"auth": true}),
      );

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
