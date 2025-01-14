/// facility_id : 62
/// janitor_id : 12
/// janitor_name : "Shreya"
/// status : "Request for closure"
/// facility_name : "Gents Restroom"
/// floor_number : 0
/// description : "Restroom"
/// cluster_name : "Wipro"

class IssueListModel {
  IssueListModel({
    this.facilityId,
    this.janitorId,
    this.janitorName,
    this.status,
    this.facilityName,
    this.floorNumber,
    this.description,
    this.clusterName,
    this.baseUrl,
    this.profileImage
  });

  IssueListModel.fromJson(dynamic json) {
    facilityId = json['facility_id'];
    janitorId = json['janitor_id'];
    janitorName = json['janitor_name'] ?? "-" ;
    status = json['status'];
    facilityName = json['facility_name' ] ?? "-" ;
    floorNumber = json['floor_number'];
    description = json['description'];
    clusterName = json['cluster_name'];
    baseUrl = json['base_url'];
    profileImage = json['profile_image'] ?? "" ;
  }
  int? facilityId;
  int? janitorId;
  String? janitorName;
  String? status;
  String? facilityName;
  int? floorNumber;
  String? description;
  String? clusterName;
  String? profileImage;
  String? baseUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['facility_id'] = facilityId;
    map['janitor_id'] = janitorId;
    map['janitor_name'] = janitorName;
    map['status'] = status;
    map['facility_name'] = facilityName;
    map['floor_number'] = floorNumber;
    map['description'] = description;
    map['cluster_name'] = clusterName;
    map['base_url'] = baseUrl;
    map['profile_image'] = profileImage;
    return map;
  }
}
