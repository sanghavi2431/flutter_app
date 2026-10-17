class FacilityDropdownModel {
  FacilityDropdownModel(
      {this.id,
      this.facilityName,
      this.locationName,
      this.facalityType,
      this.endTime,
      this.startTime,
      this.clusterId,
        this.subscriptionStatus,
        this.isFreeTrial,
      // this.requiredTime
      });

  FacilityDropdownModel.fromJson(dynamic json) {
    id = json["id"];
    facilityName = json["facility_name"];
    locationName = json["location_name"];
    facalityType = json["facility_type"];
    endTime = json["end_time"];
    // shiftId: json["shift_id"];
    // shiftName: json["shift_name"];
    startTime = json["start_time"];
    clusterId = json["cluster_id"];
    subscriptionStatus = json["subscription_status"];
    isFreeTrial = json["isFreeTrial"];

    // requiredTime = json['required_time'];
  }
  int? id;
  String? facilityName;
  String? locationName;
  String? facalityType;
  String? endTime;
  String? startTime;
  int? clusterId;
  String? subscriptionStatus;
  bool? isFreeTrial;
  // int? requiredTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['facility_name'] = facilityName;
    map['location_name'] = locationName;
    map['facility_type'] = facalityType;
    map["end_time"] = endTime;
    map["start_time"] = startTime;
    map["cluster_id"] = clusterId;
    map["subscription_status"] = subscriptionStatus;
    map["isFreeTrial"] = isFreeTrial;
    // map['required_time'] = requiredTime;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FacilityDropdownModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
