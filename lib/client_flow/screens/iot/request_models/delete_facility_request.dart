class DeleteFacilityRequest {
  final int? locationId;
  final int? clusterId;
  final int? facilityId;

  DeleteFacilityRequest({
    required this.locationId,
    required this.clusterId,
    required this.facilityId,
  });

  Map<String, dynamic> toJson() {
    return {
      "location_id": locationId,
      "cluster_id": clusterId,
      "facility_id": facilityId,
    };
  }
}
