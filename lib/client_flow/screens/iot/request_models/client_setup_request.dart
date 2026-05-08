class ClientSetupRequest {
  final String orgName;
  final String locality;
  final String clientId;
  final String address;
  final String? pincode;
  final String? mobile;
  final String? city;
  final String? facilityType;
  final String? clusterId;

  ClientSetupRequest({
    required this.orgName,
    required this.locality,
    required this.clientId,
    required this.address,
    this.pincode,
    this.mobile,
    this.city,
    this.facilityType,
    this.clusterId,
  });

  Map<String, dynamic> toJson() {
    return clusterId != null
        ? {
      "location": locality,
      "address": address,
      "city": city,
      "client_id": clientId,
      "facility_name": orgName,
      "cluster_id": clusterId,
      "facility_type": facilityType,
      "pincode": pincode,
      "mobile": mobile,
    }
        : {
      "location": locality,
      "address": address,
      "city": city,
      "client_id": clientId,
      "facility_name": orgName,
      "facility_type": facilityType,
      "pincode": pincode,
      "mobile": mobile,
    };
  }
}
