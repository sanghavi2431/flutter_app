import '../../../../../../core/network/api_constant.dart';

class FacilityTypeRequest {
  final int clientId;

  FacilityTypeRequest({required this.clientId});

  String get endpoint => "${APIConstants.FACILITY_TYPE}?client_id=$clientId";
}
