import '../../../../../../core/network/api_constant.dart';

class FacilityByJanitorRequest {
  final int clientId;
  final int facilityId;

  FacilityByJanitorRequest({
    required this.clientId,
    required this.facilityId,
  });

  String get endpoint => "${APIConstants.FACILITY_BY_JANITOR}"
          "?client_id=$clientId&facility_id=$facilityId";
}
