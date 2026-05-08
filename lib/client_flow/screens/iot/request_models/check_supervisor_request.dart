import '../../../../../../core/network/api_constant.dart';

class CheckSupervisorRequest {
  final int id;

  CheckSupervisorRequest({required this.id});

  String get endpoint => "${APIConstants.SUPERVISOR_CHECK}?client_id=$id";
}
