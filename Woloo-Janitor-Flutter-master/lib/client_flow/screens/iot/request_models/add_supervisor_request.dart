import 'package:dio/dio.dart';

class AddSupervisorRequest {
  final String roleId;
  final String name;
  final String mobile;
  final String clientId;
  final String? gender;
  final bool? isSelfAssign;
  final List<int>? clusterId;

  AddSupervisorRequest({
    required this.roleId,
    required this.name,
    required this.mobile,
    required this.clientId,
    this.gender,
    this.isSelfAssign,
    required this.clusterId,
  });

  FormData toFormData() {
    return roleId == "1"
        ? FormData.fromMap({
      "role_id": roleId,
      "first_name": name,
      "cluster_ids": clusterId.toString(),
      "mobile": mobile,
      "gender": gender,
    })
        : FormData.fromMap({
      "role_id": roleId,
      "first_name": name,
      "cluster_ids": clusterId.toString(),
      "mobile": mobile,
      "gender": gender,
      "isSelfAssign": isSelfAssign,
    });
  }
}
