// To parse this JSON data, do
//
//     final hygieneCategoryModel = hygieneCategoryModelFromJson(jsonString);

import 'dart:convert';

HygieneCategoryModel hygieneCategoryModelFromJson(String str) =>
    HygieneCategoryModel.fromJson(json.decode(str));

String hygieneCategoryModelToJson(HygieneCategoryModel data) =>
    json.encode(data.toJson());

class HygieneCategoryModel {
  List<Category>? categories;
  int? count;
  int? offset;
  int? limit;

  HygieneCategoryModel({
    this.categories,
    this.count,
    this.offset,
    this.limit,
  });

  factory HygieneCategoryModel.fromJson(Map<String, dynamic> json) =>
      HygieneCategoryModel(
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
        count: json["count"],
        offset: json["offset"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "categories": List<dynamic>.from(categories!.map((x) => x.toJson())),
        "count": count,
        "offset": offset,
        "limit": limit,
      };
}

class Category {
  String? id;
  String? name;
  String? description;
  String? handle;
  int? rank;
  String? parentCategoryId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Metadata? metadata;
  Category? parentCategory;
  List<CategoryChild>? categoryChildren;
  SalesChannel? salesChannel;

  Category({
    this.id,
    this.name,
    this.description,
    this.handle,
    this.rank,
    this.parentCategoryId,
    this.createdAt,
    this.updatedAt,
    this.metadata,
    this.parentCategory,
    this.categoryChildren,
    this.salesChannel,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        handle: json["handle"],
        rank: json["rank"],
        parentCategoryId: json["parent_category_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        metadata: Metadata.fromJson(json["metadata"]),
        parentCategory: Category.fromJson(json["parent_category"]),
        categoryChildren: List<CategoryChild>.from(
            json["category_children"].map((x) => CategoryChild.fromJson(x))),
        salesChannel: SalesChannel.fromJson(json["sales_channel"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "handle": handle,
        "rank": rank,
        "parent_category_id": parentCategoryId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "metadata": metadata!.toJson(),
        "parent_category": parentCategory!.toJson(),
        "category_children":
            List<dynamic>.from(categoryChildren!.map((x) => x.toJson())),
        "sales_channel": salesChannel!.toJson(),
      };
}

class CategoryChild {
  String? id;
  String? name;
  String? description;
  String? handle;
  String? mpath;
  bool? isActive;
  bool? isInternal;
  int? rank;
  Metadata? metadata;
  String? parentCategoryId;
  DateTime? createdAt;
  DateTime? updatedAt;

  CategoryChild({
    this.id,
    this.name,
    this.description,
    this.handle,
    this.mpath,
    this.isActive,
    this.isInternal,
    this.rank,
    this.metadata,
    this.parentCategoryId,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryChild.fromJson(Map<String, dynamic> json) => CategoryChild(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        handle: json["handle"],
        mpath: json["mpath"],
        isActive: json["is_active"],
        isInternal: json["is_internal"],
        rank: json["rank"],
        metadata: Metadata.fromJson(json["metadata"]),
        parentCategoryId: json["parent_category_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "handle": handle,
        "mpath": mpath,
        "is_active": isActive,
        "is_internal": isInternal,
        "rank": rank,
        "metadata": metadata!.toJson(),
        "parent_category_id": parentCategoryId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class Metadata {
  String? image;
  String? videos;
  String? listingVideo;
  String? backgroundColor;

  Metadata({
    this.image,
    this.videos,
    this.listingVideo,
    this.backgroundColor,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        image: json["image"],
        videos: json["videos"],
        listingVideo: json["listing_video"],
        backgroundColor: json["background_color"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "videos": videos,
        "listing_video": listingVideo,
        "background_color": backgroundColor,
      };
}

class SalesChannel {
  Id? id;
  Name? name;
  String? description;
  bool? isDisabled;
  dynamic metadata;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  SalesChannel({
    this.id,
    this.name,
    this.description,
    this.isDisabled,
    this.metadata,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory SalesChannel.fromJson(Map<String, dynamic> json) => SalesChannel(
        id: idValues.map[json["id"]],
        name: nameValues.map[json["name"]],
        description: json["description"],
        isDisabled: json["is_disabled"],
        metadata: json["metadata"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": idValues.reverse[id],
        "name": nameValues.reverse[name],
        "description": description,
        "is_disabled": isDisabled,
        "metadata": metadata,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

enum Id { SC_01_JTAFCK3_JCFRATWKXDC8_ZXZ8_D }

final idValues = EnumValues(
    {"sc_01JTAFCK3JCFRATWKXDC8ZXZ8D": Id.SC_01_JTAFCK3_JCFRATWKXDC8_ZXZ8_D});

enum Name { HYGIENE_SERVICES }

final nameValues = EnumValues({"Hygiene Services": Name.HYGIENE_SERVICES});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
