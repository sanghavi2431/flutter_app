
class IotDashboardRequest {
  final int facilityId;
  final String type;

  IotDashboardRequest({
    required this.facilityId,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      "facility_id": facilityId,
      "type": type,
    };
  }
}
