import 'dart:convert';

HygieneCategories hygieneCategoriesFromJson(String str) =>
    HygieneCategories.fromJson(json.decode(str));

String hygieneCategoriesToJson(HygieneCategories data) =>
    json.encode(data.toJson());

class HygieneCategories {
  List<Product>? products;
  int? count;
  int? offset;
  int? limit;

  HygieneCategories({
    this.products,
    this.count,
    this.offset,
    this.limit,
  });

  factory HygieneCategories.fromJson(Map<String, dynamic> json) =>
      HygieneCategories(
        products: json["products"] == null
            ? null
            : List<Product>.from(
                json["products"].map((x) => Product.fromJson(x))),
        count: json["count"],
        offset: json["offset"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "products": products?.map((x) => x.toJson()).toList(),
        "count": count,
        "offset": offset,
        "limit": limit,
      };
}

class Product {
  String? id;
  List<Variant>? variants;
  List<Category>? categories;
  int? averageRating;
  int? reviewCount;

  Product({
    this.id,
    this.variants,
    this.categories,
    this.averageRating,
    this.reviewCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        variants: json["variants"] == null
            ? null
            : List<Variant>.from(
                json["variants"].map((x) => Variant.fromJson(x))),
        categories: json["categories"] == null
            ? null
            : List<Category>.from(
                json["categories"].map((x) => Category.fromJson(x))),
        averageRating: json["average_rating"],
        reviewCount: json["review_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "variants": variants?.map((x) => x.toJson()).toList(),
        "categories": categories?.map((x) => x.toJson()).toList(),
        "average_rating": averageRating,
        "review_count": reviewCount,
      };
}

class Category {
  String? id;
  String? name;
  String? description;
  String? handle;
  String? mpath;
  bool? isActive;
  bool? isInternal;
  int? rank;
  Metadata? metadata;
  ParentCategoryId? parentCategoryId;
  ParentCategory? parentCategory;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  Category({
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
    this.parentCategory,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        handle: json["handle"],
        mpath: json["mpath"],
        isActive: json["is_active"],
        isInternal: json["is_internal"],
        rank: json["rank"],
        metadata: json["metadata"] == null
            ? null
            : Metadata.fromJson(json["metadata"]),
        parentCategoryId:
            parentCategoryIdValues.map[json["parent_category_id"]],
        parentCategory: json["parent_category"] == null
            ? null
            : ParentCategory.fromJson(json["parent_category"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
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
        "metadata": metadata?.toJson(),
        "parent_category_id": parentCategoryIdValues.reverse[parentCategoryId],
        "parent_category": parentCategory?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
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

class ParentCategory {
  ParentCategoryId? id;

  ParentCategory({
    this.id,
  });

  factory ParentCategory.fromJson(Map<String, dynamic> json) => ParentCategory(
        id: parentCategoryIdValues.map[json["id"]],
      );

  Map<String, dynamic> toJson() => {
        "id": parentCategoryIdValues.reverse[id],
      };
}

enum ParentCategoryId { PCAT_01_JVYHACQY9_BGWVX0_KDCPJ17_S9 }

final parentCategoryIdValues = EnumValues({
  "pcat_01JVYHACQY9BGWVX0KDCPJ17S9":
      ParentCategoryId.PCAT_01_JVYHACQY9_BGWVX0_KDCPJ17_S9
});

class Variant {
  String? id;
  CalculatedPrice? calculatedPrice;
  bool? hasRestockSubscription;
  bool? hasWishlisted;
  dynamic wishlistItemId;

  Variant({
    this.id,
    this.calculatedPrice,
    this.hasRestockSubscription,
    this.hasWishlisted,
    this.wishlistItemId,
  });

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
        id: json["id"],
        calculatedPrice: json["calculated_price"] == null
            ? null
            : CalculatedPrice.fromJson(json["calculated_price"]),
        hasRestockSubscription: json["has_restock_subscription"],
        hasWishlisted: json["has_wishlisted"],
        wishlistItemId: json["wishlist_item_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "calculated_price": calculatedPrice?.toJson(),
        "has_restock_subscription": hasRestockSubscription,
        "has_wishlisted": hasWishlisted,
        "wishlist_item_id": wishlistItemId,
      };
}

class CalculatedPrice {
  String? id;
  bool? isCalculatedPricePriceList;
  bool? isCalculatedPriceTaxInclusive;
  int? calculatedAmount;
  RawAmount? rawCalculatedAmount;
  bool? isOriginalPricePriceList;
  bool? isOriginalPriceTaxInclusive;
  int? originalAmount;
  RawAmount? rawOriginalAmount;
  CurrencyCode? currencyCode;
  Price? calculatedPrice;
  Price? originalPrice;

  CalculatedPrice({
    this.id,
    this.isCalculatedPricePriceList,
    this.isCalculatedPriceTaxInclusive,
    this.calculatedAmount,
    this.rawCalculatedAmount,
    this.isOriginalPricePriceList,
    this.isOriginalPriceTaxInclusive,
    this.originalAmount,
    this.rawOriginalAmount,
    this.currencyCode,
    this.calculatedPrice,
    this.originalPrice,
  });

  factory CalculatedPrice.fromJson(Map<String, dynamic> json) =>
      CalculatedPrice(
        id: json["id"],
        isCalculatedPricePriceList: json["is_calculated_price_price_list"],
        isCalculatedPriceTaxInclusive:
            json["is_calculated_price_tax_inclusive"],
        calculatedAmount: json["calculated_amount"],
        rawCalculatedAmount: json["raw_calculated_amount"] == null
            ? null
            : RawAmount.fromJson(json["raw_calculated_amount"]),
        isOriginalPricePriceList: json["is_original_price_price_list"],
        isOriginalPriceTaxInclusive: json["is_original_price_tax_inclusive"],
        originalAmount: json["original_amount"],
        rawOriginalAmount: json["raw_original_amount"] == null
            ? null
            : RawAmount.fromJson(json["raw_original_amount"]),
        currencyCode: currencyCodeValues.map[json["currency_code"]],
        calculatedPrice: json["calculated_price"] == null
            ? null
            : Price.fromJson(json["calculated_price"]),
        originalPrice: json["original_price"] == null
            ? null
            : Price.fromJson(json["original_price"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_calculated_price_price_list": isCalculatedPricePriceList,
        "is_calculated_price_tax_inclusive": isCalculatedPriceTaxInclusive,
        "calculated_amount": calculatedAmount,
        "raw_calculated_amount": rawCalculatedAmount?.toJson(),
        "is_original_price_price_list": isOriginalPricePriceList,
        "is_original_price_tax_inclusive": isOriginalPriceTaxInclusive,
        "original_amount": originalAmount,
        "raw_original_amount": rawOriginalAmount?.toJson(),
        "currency_code": currencyCodeValues.reverse[currencyCode],
        "calculated_price": calculatedPrice?.toJson(),
        "original_price": originalPrice?.toJson(),
      };
}

class Price {
  String? id;
  dynamic priceListId;
  dynamic priceListType;
  dynamic minQuantity;
  dynamic maxQuantity;

  Price({
    this.id,
    this.priceListId,
    this.priceListType,
    this.minQuantity,
    this.maxQuantity,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        id: json["id"],
        priceListId: json["price_list_id"],
        priceListType: json["price_list_type"],
        minQuantity: json["min_quantity"],
        maxQuantity: json["max_quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "price_list_id": priceListId,
        "price_list_type": priceListType,
        "min_quantity": minQuantity,
        "max_quantity": maxQuantity,
      };
}

enum CurrencyCode { INR }

final currencyCodeValues = EnumValues({"inr": CurrencyCode.INR});

class RawAmount {
  String? value;
  int? precision;

  RawAmount({
    this.value,
    this.precision,
  });

  factory RawAmount.fromJson(Map<String, dynamic> json) => RawAmount(
        value: json["value"],
        precision: json["precision"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "precision": precision,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
