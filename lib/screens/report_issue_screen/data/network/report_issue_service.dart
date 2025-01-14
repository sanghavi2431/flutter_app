import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:Woloo_Smart_hygiene/core/network/api_constant.dart';
import 'package:Woloo_Smart_hygiene/core/network/dio_client.dart';
import 'package:Woloo_Smart_hygiene/screens/report_issue_screen/data/model/Cluster_dropdown_model.dart';
import 'package:Woloo_Smart_hygiene/screens/report_issue_screen/data/model/Janitor_dropdown_model.dart';
import 'package:Woloo_Smart_hygiene/screens/report_issue_screen/data/model/report_issue_model.dart';
import 'package:Woloo_Smart_hygiene/screens/report_issue_screen/data/model/task_names_model.dart';
import 'package:Woloo_Smart_hygiene/screens/report_issue_screen/data/model/facility_dropdown_model.dart';
import 'package:Woloo_Smart_hygiene/screens/task_list/data/model/task_list_model.dart';

class ReportIssueService {
  final DioClient dio;
  const ReportIssueService({required this.dio});

  Future<List<ClusterDropdownModel>> getClusterDropdownData() async {
    try {
      var response = await dio.get(APIConstants.GET_CLUSTER_DROPDOWN_DATA,
          options: Options(
            extra: {"auth": true},
          ));

      List<ClusterDropdownModel> output = [];
      for (var item in response['results']) {
        output.add(ClusterDropdownModel.fromJson(item));
      }

      return output;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<FacilityDropdownModel>> getFacilitiesDropdownData({required int clusterId}) async {
    try {
      var response = await dio.get(APIConstants.GET_FACILITIES_DROPDOWN_DATA,
          options: Options(
            extra: {"auth": true},
          ),
          queryParameters: {
            "cluster_id": clusterId,
          });

      List<FacilityDropdownModel> output = [];
      for (var item in response['results']) {
        output.add(FacilityDropdownModel.fromJson(item));
      }

      return output;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TaskNamesModels>> getTasksDropdownData(
     int clusterId
  ) async {
    try {
      var response = await dio.get(
        "${APIConstants.GET_TASKS_DROPDOWN_DATA}?cluster_id=$clusterId",
        options: Options(
          extra: {"auth": true},
        ),
      );
      List<TaskNamesModels> output = [];
      for (var item in response['results']) {
        output.add(TaskNamesModels.fromJson(item));
      }
      return output;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<JanitorDropdownModel>> getJanitorsDropdownData({required int clusterId}) async {
    try {
      var response = await dio.get(APIConstants.GET_JANITOR_DROPDOWN_DATA,
          options: Options(
            extra: {"auth": true},
          ),
          queryParameters: {
            "cluster_id": clusterId,
          });

      List<JanitorDropdownModel> output = [];
      for (var item in response['results']) {
        output.add(JanitorDropdownModel.fromJson(item));
      }

      return output;
    } catch (e) {
      rethrow;
    }
  }

  Future<TaskListModel> getAllTasksList({required String id}) async {
    try {
      var response = await dio.get(
        APIConstants.GET_ALL_TASKS,
        options: Options(extra: {"auth": true}),
        queryParameters: {
          "id": id,
        },
      );
      print(response['results']?.toString() == '[]');
      if (response['results']?.toString() == '[]') {
        return TaskListModel(templateId: id.toString(), tasks: []);
      }
      return TaskListModel.fromJson(response['results']);
    } catch (e) {
      rethrow;
    }
  }

  Future<ReportIssueModel> reportIssue({
    required String template_id,
    required int facility_id,
    required String description,
    required File task_images,
    required int janitor_id,
    required List<String> task_list,
  }) async {
    try {
      FormData formData = FormData();

      /// Add image
      formData = FormData.fromMap({
        "template_id": template_id,
        "facility_id": facility_id,
        "description": description,
        "janitor_id": janitor_id,
        "task_list": task_list.toString(),
      });

      formData.files.addAll([
        MapEntry(
          "task_images",
          await MultipartFile.fromFile(
            task_images.path,
            filename: getFileName(task_images.path),
            contentType: MediaType(getType(task_images.path), getFileExtension(task_images.path)),
          ),
        ),
      ]);

      var response = await dio.post(
        APIConstants.REPORT_ISSUE,
        data: formData,
        options: Options(extra: {"auth": true}),
      );

      return ReportIssueModel.fromJson(response['results']);
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
