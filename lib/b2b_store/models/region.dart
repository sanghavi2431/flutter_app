class RegionsModel {
  List<Regions>? regions;
  int? count;
  int? offset;
  int? limit;

  RegionsModel({this.regions, this.count, this.offset, this.limit});

  RegionsModel.fromJson(Map<String, dynamic> json) {
    if (json['regions'] != null) {
      regions = <Regions>[];
      json['regions'].forEach((v) {
        regions!.add(new Regions.fromJson(v));
      });
    }
    count = json['count'];
    offset = json['offset'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.regions != null) {
      data['regions'] = this.regions!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    data['offset'] = this.offset;
    data['limit'] = this.limit;
    return data;
  }
}

class Regions {
  String? id;
  String? name;
  String? currencyCode;
  String? createdAt;
  String? updatedAt;
  dynamic? deletedAt;
  dynamic? metadata;
  List<Countries>? countries;

  Regions(
      {this.id,
      this.name,
      this.currencyCode,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.metadata,
      this.countries});

  Regions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    currencyCode = json['currency_code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    metadata = json['metadata'];
    if (json['countries'] != null) {
      countries = <Countries>[];
      json['countries'].forEach((v) {
        countries!.add(new Countries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['currency_code'] = this.currencyCode;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['metadata'] = this.metadata;
    if (this.countries != null) {
      data['countries'] = this.countries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Countries {
  String? iso2;
  String? iso3;
  String? numCode;
  String? name;
  String? displayName;
  String? regionId;
  dynamic? metadata;
  String? createdAt;
  String? updatedAt;
  dynamic? deletedAt;

  Countries(
      {this.iso2,
      this.iso3,
      this.numCode,
      this.name,
      this.displayName,
      this.regionId,
      this.metadata,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Countries.fromJson(Map<String, dynamic> json) {
    iso2 = json['iso_2'];
    iso3 = json['iso_3'];
    numCode = json['num_code'];
    name = json['name'];
    displayName = json['display_name'];
    regionId = json['region_id'];
    metadata = json['metadata'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iso_2'] = this.iso2;
    data['iso_3'] = this.iso3;
    data['num_code'] = this.numCode;
    data['name'] = this.name;
    data['display_name'] = this.displayName;
    data['region_id'] = this.regionId;
    data['metadata'] = this.metadata;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
