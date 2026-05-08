class GetDashboardTaskRequest {
  final int? facilityId;
  final String type;
  final String clientId;
  final String janitorId;

  GetDashboardTaskRequest({
    this.facilityId,
    required this.type,
    required this.clientId,
    required this.janitorId,
  });

  Map<String, dynamic> toJson() {
    return facilityId != null
        ? {
      "type": type,
      "client_id": int.parse(clientId),
      "facility_id": facilityId,
      "janitor_id": janitorId,
    }
        : {
      "type": type,
      "janitor_id": janitorId,
    };
  }

  bool get isSupervisorCall => facilityId != null;
}
