import 'dart:convert';

ProductCollections productCollectionsFromJson(String str) =>
    ProductCollections.fromJson(json.decode(str));

String productCollectionsToJson(ProductCollections data) =>
    json.encode(data.toJson());

class ProductCollections {
  List<XYProduct> products;
  int? count;
  int? offset;
  int? limit;

  ProductCollections({
    this.products = const [],
    this.count,
    this.offset,
    this.limit,
  });

  factory ProductCollections.fromJson(Map<String, dynamic> json) =>
      ProductCollections(
        products: json["products"] == null
            ? []
            : List<XYProduct>.from(
                json["products"]!.map((x) => XYProduct.fromJson(x))),
        count: json["count"],
        offset: json["offset"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "count": count,
        "offset": offset,
        "limit": limit,
      };
}

class XYProduct {
  String? id;
  String? title;
  String? subtitle;
  String? description;
  String? handle;
  bool? isGiftcard;
  bool? discountable;
  String? thumbnail;
  String? collectionId;
  dynamic typeId;
  String? weight;
  String? length;
  String? height;
  String? width;
  dynamic hsCode;
  dynamic originCountry;
  dynamic midCode;
  String? material;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic type;
  Tion? collection;
  List<ProductCategoryImage>? options;
  List<Tag>? tags;
  List<ProductCategoryImage>? images;
  List<Variant> variants;
  double? averageRating;
  int? reviewCount;

  XYProduct({
    this.id,
    this.title,
    this.subtitle,
    this.description,
    this.handle,
    this.isGiftcard,
    this.discountable,
    this.thumbnail,
    this.collectionId,
    this.typeId,
    this.weight,
    this.length,
    this.height,
    this.width,
    this.hsCode,
    this.originCountry,
    this.midCode,
    this.material,
    this.createdAt,
    this.updatedAt,
    this.type,
    this.collection,
    this.options,
    this.tags,
    this.images,
    this.variants = const [],
    this.averageRating,
    this.reviewCount,
  });

  factory XYProduct.fromJson(Map<String, dynamic> json) => XYProduct(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        description: json["description"],
        handle: json["handle"],
        isGiftcard: json["is_giftcard"],
        discountable: json["discountable"],
        thumbnail: json["thumbnail"],
        collectionId: json["collection_id"],
        typeId: json["type_id"],
        weight: json["weight"],
        length: json["length"],
        height: json["height"],
        width: json["width"],
        hsCode: json["hs_code"],
        originCountry: json["origin_country"],
        midCode: json["mid_code"],
        material: json["material"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        type: json["type"],
        collection: json["collection"] == null
            ? null
            : Tion.fromJson(json["collection"]),
        options: json["options"] == null
            ? []
            : List<ProductCategoryImage>.from(
                json["options"]!.map((x) => ProductCategoryImage.fromJson(x))),
        tags: json["tags"] == null
            ? []
            : List<Tag>.from(json["tags"]!.map((x) => Tag.fromJson(x))),
        images: json["images"] == null
            ? []
            : List<ProductCategoryImage>.from(
                json["images"]!.map((x) => ProductCategoryImage.fromJson(x))),
        variants: json["variants"] == null
            ? []
            : List<Variant>.from(
                json["variants"]!.map((x) => Variant.fromJson(x))),
        averageRating: json["average_rating"]?.toDouble(),
        reviewCount: json["review_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "description": description,
        "handle": handle,
        "is_giftcard": isGiftcard,
        "discountable": discountable,
        "thumbnail": thumbnail,
        "collection_id": collectionId,
        "type_id": typeId,
        "weight": weight,
        "length": length,
        "height": height,
        "width": width,
        "hs_code": hsCode,
        "origin_country": originCountry,
        "mid_code": midCode,
        "material": material,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "type": type,
        "collection": collection?.toJson(),
        "options": options == null
            ? []
            : List<dynamic>.from(options!.map((x) => x.toJson())),
        "tags": tags == null
            ? []
            : List<dynamic>.from(tags!.map((x) => x.toJson())),
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
        "variants": List<dynamic>.from(variants.map((x) => x.toJson())),
        "average_rating": averageRating,
        "review_count": reviewCount,
      };
}

class Tion {
  String? id;
  String? title;
  String? handle;
  Metadata? metadata;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? productId;

  Tion({
    this.id,
    this.title,
    this.handle,
    this.metadata,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.productId,
  });

  factory Tion.fromJson(Map<String, dynamic> json) => Tion(
        id: json["id"],
        title: json["title"],
        handle: json["handle"],
        metadata: json["metadata"] == null
            ? null
            : Metadata.fromJson(json["metadata"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        productId: json["product_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "handle": handle,
        "metadata": metadata?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "product_id": productId,
      };
}

class Metadata {
  String? image;

  Metadata({
    this.image,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
      };
}

class ProductCategoryImage {
  String? id;
  String? url;
  dynamic metadata;
  int? rank;
  String? productId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? title;
  List<Tag>? values;

  ProductCategoryImage({
    this.id,
    this.url,
    this.metadata,
    this.rank,
    this.productId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.title,
    this.values,
  });

  factory ProductCategoryImage.fromJson(Map<String, dynamic> json) =>
      ProductCategoryImage(
        id: json["id"],
        url: json["url"],
        metadata: json["metadata"],
        rank: json["rank"],
        productId: json["product_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        title: json["title"],
        values: json["values"] == null
            ? []
            : List<Tag>.from(json["values"]!.map((x) => Tag.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "metadata": metadata,
        "rank": rank,
        "product_id": productId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "title": title,
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class Tag {
  String? id;
  String? value;
  dynamic metadata;
  String? optionId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  Tion? option;

  Tag({
    this.id,
    this.value,
    this.metadata,
    this.optionId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.option,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["id"],
        value: json["value"],
        metadata: json["metadata"],
        optionId: json["option_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        option: json["option"] == null ? null : Tion.fromJson(json["option"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "metadata": metadata,
        "option_id": optionId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "option": option?.toJson(),
      };
}

class Variant {
  String? id;
  String? title;
  dynamic sku;
  dynamic barcode;
  dynamic ean;
  dynamic upc;
  bool? allowBackorder;
  bool? manageInventory;
  dynamic hsCode;
  dynamic originCountry;
  dynamic midCode;
  dynamic material;
  int? weight;
  int? length;
  int? height;
  int? width;
  dynamic metadata;
  int? variantRank;
  String? productId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  List<Tag>? options;
  CalculatedPrice? calculatedPrice;
  bool? hasRestockSubscription;
  bool? hasWishlisted;
  int? inventoryQuantity;

  Variant({
    this.id,
    this.title,
    this.sku,
    this.barcode,
    this.ean,
    this.upc,
    this.allowBackorder,
    this.manageInventory,
    this.hsCode,
    this.originCountry,
    this.midCode,
    this.material,
    this.weight,
    this.length,
    this.height,
    this.width,
    this.metadata,
    this.variantRank,
    this.productId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.options,
    this.calculatedPrice,
    this.hasRestockSubscription,
    this.hasWishlisted,
    this.inventoryQuantity,
  });

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
        id: json["id"],
        title: json["title"],
        sku: json["sku"],
        barcode: json["barcode"],
        ean: json["ean"],
        upc: json["upc"],
        allowBackorder: json["allow_backorder"],
        manageInventory: json["manage_inventory"],
        hsCode: json["hs_code"],
        originCountry: json["origin_country"],
        midCode: json["mid_code"],
        material: json["material"],
        weight: json["weight"],
        length: json["length"],
        height: json["height"],
        width: json["width"],
        metadata: json["metadata"],
        variantRank: json["variant_rank"],
        productId: json["product_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        options: json["options"] == null
            ? []
            : List<Tag>.from(json["options"]!.map((x) => Tag.fromJson(x))),
        calculatedPrice: json["calculated_price"] == null
            ? null
            : CalculatedPrice.fromJson(json["calculated_price"]),
        hasRestockSubscription: json["has_restock_subscription"],
        hasWishlisted: json["has_wishlisted"],
        inventoryQuantity: json["inventory_quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "sku": sku,
        "barcode": barcode,
        "ean": ean,
        "upc": upc,
        "allow_backorder": allowBackorder,
        "manage_inventory": manageInventory,
        "hs_code": hsCode,
        "origin_country": originCountry,
        "mid_code": midCode,
        "material": material,
        "weight": weight,
        "length": length,
        "height": height,
        "width": width,
        "metadata": metadata,
        "variant_rank": variantRank,
        "product_id": productId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "options": options == null
            ? []
            : List<dynamic>.from(options!.map((x) => x.toJson())),
        "calculated_price": calculatedPrice?.toJson(),
        "has_restock_subscription": hasRestockSubscription,
        "has_wishlisted": hasWishlisted,
        "inventory_quantity": inventoryQuantity,
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
        currencyCode: currencyCodeValues.map[json["currency_code"]]!,
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
  String? priceListId;
  String? priceListType;
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
