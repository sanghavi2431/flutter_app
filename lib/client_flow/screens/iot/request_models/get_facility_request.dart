class GetAllFacilityRequest {
  final int clientId;

  GetAllFacilityRequest({
    required this.clientId,
  });

  Map<String, dynamic> toJson() {
    return {
      "client_id": clientId,
      "isAll": 1,
    };
  }
}
