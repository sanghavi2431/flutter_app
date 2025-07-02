class ProductCategory {
  List<ProductCategories>? productCategories;
  int? count;
  int? offset;
  int? limit;

  ProductCategory(
      {this.productCategories, this.count, this.offset, this.limit});

  ProductCategory.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      productCategories = <ProductCategories>[];
      json['categories'].forEach((v) {
        productCategories!.add(new ProductCategories.fromJson(v));
      });
    }
    count = json['count'];
    offset = json['offset'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productCategories != null) {
      data['categories'] =
          this.productCategories!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    data['offset'] = this.offset;
    data['limit'] = this.limit;
    return data;
  }
}

class ProductCategories {
  String? id;
  String? name;
  String? description;
  String? handle;
  int? rank;
  String? parentCategoryId;
  String? createdAt;
  String? updatedAt;
  Metadata? metadata;
  ParentCategory? parentCategory;
  List<CategoryChildren>? categoryChildren;

  ProductCategories(
      {this.id,
      this.name,
      this.description,
      this.handle,
      this.rank,
      this.parentCategoryId,
      this.createdAt,
      this.updatedAt,
      this.metadata,
      this.parentCategory,
      this.categoryChildren});

  ProductCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    handle = json['handle'];
    rank = json['rank'];
    parentCategoryId = json['parent_category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
    parentCategory = json['parent_category'] != null
        ? new ParentCategory.fromJson(json['parent_category'])
        : null;
    if (json['category_children'] != null) {
      categoryChildren = <CategoryChildren>[];
      json['category_children'].forEach((v) {
        categoryChildren!.add(new CategoryChildren.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['handle'] = this.handle;
    data['rank'] = this.rank;
    data['parent_category_id'] = this.parentCategoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    if (this.parentCategory != null) {
      data['parent_category'] = this.parentCategory!.toJson();
    }
    if (this.categoryChildren != null) {
      data['category_children'] =
          this.categoryChildren!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Metadata {
  String? image;
  String? backgroundColor;

  Metadata({this.image, this.backgroundColor});

  Metadata.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    backgroundColor = json['background_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['background_color'] = this.backgroundColor;
    return data;
  }
}

class ParentCategory {
  String? id;
  String? name;
  String? description;
  String? handle;
  int? rank;
  Metadata? metadata;
  dynamic? parentCategoryId;
  String? createdAt;
  String? updatedAt;

  ParentCategory(
      {this.id,
      this.name,
      this.description,
      this.handle,
      this.rank,
      this.metadata,
      this.parentCategoryId,
      this.createdAt,
      this.updatedAt});

  ParentCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    handle = json['handle'];
    rank = json['rank'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
    parentCategoryId = json['parent_category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['handle'] = this.handle;
    data['rank'] = this.rank;
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    data['parent_category_id'] = this.parentCategoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class CategoryChildren {
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
  String? createdAt;
  String? updatedAt;

  CategoryChildren(
      {this.id,
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
      this.updatedAt});

  CategoryChildren.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    handle = json['handle'];
    mpath = json['mpath'];
    isActive = json['is_active'];
    isInternal = json['is_internal'];
    rank = json['rank'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
    parentCategoryId = json['parent_category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['handle'] = this.handle;
    data['mpath'] = this.mpath;
    data['is_active'] = this.isActive;
    data['is_internal'] = this.isInternal;
    data['rank'] = this.rank;
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    data['parent_category_id'] = this.parentCategoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

// -------------- Top Brands ----------------------
class TopBrands {
  List<Collections>? collections;
  int? count;
  int? offset;
  int? limit;

  TopBrands({this.collections, this.count, this.offset, this.limit});

  TopBrands.fromJson(Map<String, dynamic> json) {
    if (json['collections'] != null) {
      collections = <Collections>[];
      json['collections'].forEach((v) {
        collections!.add(new Collections.fromJson(v));
      });
    }
    count = json['count'];
    offset = json['offset'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.collections != null) {
      data['collections'] = this.collections!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    data['offset'] = this.offset;
    data['limit'] = this.limit;
    return data;
  }
}

class Collections {
  String? id;
  String? title;
  Metadata? metadata;

  Collections({this.id, this.title, this.metadata});

  Collections.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    return data;
  }
}

// class Metadata {
//   String? image;

//   Metadata({this.image});

//   Metadata.fromJson(Map<String, dynamic> json) {
//     image = json['image'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['image'] = this.image;
//     return data;
//   }
// }
// -------------------
