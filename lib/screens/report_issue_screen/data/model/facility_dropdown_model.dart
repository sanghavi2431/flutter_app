/// id : 62
/// facility_name : "Gents Restroom"

class FacilityDropdownModel {
  FacilityDropdownModel({
    this.id,
    this.facilityName,
  });

  FacilityDropdownModel.fromJson(dynamic json) {
    id = json['id'];
    facilityName = json['facility_name'];
  }
  int? id;
  String? facilityName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['facility_name'] = facilityName;
    return map;
  }
}
