// lib/hygine_services/model/store_product_category.dart

import '../../b2b_store/models/product_details.dart';
import '../model/product_metadata.dart';

class StoreProductCategory {
  String? id;
  String? name;
  String? description;
  String? handle;
  int? rank;
  String? parent_category_id;
  String? created_at;
  String? updated_at;
  ProductMetaData? metadata;
  ParentCategory? parent_category;
  bool? isSelected;

  StoreProductCategory({
    this.id,
    this.name,
    this.description,
    this.handle,
    this.rank,
    this.parent_category_id,
    this.created_at,
    this.updated_at,
    this.metadata,
    this.parent_category,
    this.isSelected = false,
  });

  factory StoreProductCategory.fromJson(Map<String, dynamic> json) {
    return StoreProductCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      handle: json['handle'],
      rank: json['rank'],
      parent_category_id: json['parent_category_id'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      metadata: json['metadata'] != null
          ? ProductMetaData.fromJson(json['metadata'])
          : null,
      parent_category: json['parent_category'] != null
          ? ParentCategory.fromJson(json['parent_category'])
          : null,
    );
  }
}
