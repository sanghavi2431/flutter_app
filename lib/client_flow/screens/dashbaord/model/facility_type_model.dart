// To parse this JSON data, do
//
//     final facilityTypeModel = facilityTypeModelFromJson(jsonString);

import 'dart:convert';

FacilityTypeModel facilityTypeModelFromJson(String str) => FacilityTypeModel.fromJson(json.decode(str));

String facilityTypeModelToJson(FacilityTypeModel data) => json.encode(data.toJson());

class FacilityTypeModel {
    List<TypeFacility>? results;
    bool? success;

    FacilityTypeModel({
        this.results,
        this.success,
    });

    factory FacilityTypeModel.fromJson(Map<String, dynamic> json) => FacilityTypeModel(
        results: List<TypeFacility>.from(json["results"].map((x) => TypeFacility.fromJson(x))),
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results!.map((x) => x.toJson())),
        "success": success,
    };
}

class TypeFacility {
    String? typeName;
    String? imageUrl;
    String? source;

    TypeFacility({
        this.typeName,
        this.imageUrl,
        this.source,
    });

    factory TypeFacility.fromJson(Map<String, dynamic> json) => TypeFacility(
        typeName: json["type_name"],
        imageUrl: json["image_url"],
        source: json["source"],
    );

    Map<String, dynamic> toJson() => {
        "type_name": typeName,
        "image_url": imageUrl,
        "source": source,
    };
}
