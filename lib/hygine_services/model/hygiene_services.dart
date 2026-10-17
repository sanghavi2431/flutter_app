// To parse this JSON data, do
//
//     final hygieneService = hygieneServiceFromJson(jsonString);

import 'dart:convert';

HygieneService hygieneServiceFromJson(String str) =>
    HygieneService.fromJson(json.decode(str));

String hygieneServiceToJson(HygieneService data) => json.encode(data.toJson());

class HygieneService {
  final List<Product> products;
  final int count;
  final int offset;
  final int limit;

  HygieneService({
    required this.products,
    required this.count,
    required this.offset,
    required this.limit,
  });

  factory HygieneService.fromJson(Map<String, dynamic> json) => HygieneService(
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
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

class Product {
  final String id;
  final String title;
  final dynamic subtitle;
  final String description;
  final String handle;
  final bool isGiftcard;
  final bool discountable;
  final String thumbnail;
  final dynamic collectionId;
  final dynamic typeId;
  final dynamic weight;
  final dynamic length;
  final dynamic height;
  final dynamic width;
  final dynamic hsCode;
  final dynamic originCountry;
  final dynamic midCode;
  final dynamic material;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic type;
  final dynamic collection;
  final List<XImage> options;
  final List<dynamic> tags;
  final List<XImage> images;
  final List<Variant> variants;

  Product({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.handle,
    required this.isGiftcard,
    required this.discountable,
    required this.thumbnail,
    required this.collectionId,
    required this.typeId,
    required this.weight,
    required this.length,
    required this.height,
    required this.width,
    required this.hsCode,
    required this.originCountry,
    required this.midCode,
    required this.material,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    required this.collection,
    required this.options,
    required this.tags,
    required this.images,
    required this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
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
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        type: json["type"],
        collection: json["collection"],
        options:
            List<XImage>.from(json["options"].map((x) => XImage.fromJson(x))),
        tags: List<dynamic>.from(json["tags"].map((x) => x)),
        images:
            List<XImage>.from(json["images"].map((x) => XImage.fromJson(x))),
        variants: List<Variant>.from(
            json["variants"].map((x) => Variant.fromJson(x))),
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
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "type": type,
        "collection": collection,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "variants": List<dynamic>.from(variants.map((x) => x.toJson())),
      };

  @override
  String toString() => jsonEncode(toJson());
}

class Option {
  final String id;
  final String value;
  final dynamic metadata;
  final String optionId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final XImage? option;

  Option({
    required this.id,
    required this.value,
    required this.metadata,
    required this.optionId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    this.option,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json["id"],
        value: json["value"],
        metadata: json["metadata"],
        optionId: json["option_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        option: json["option"] == null ? null : XImage.fromJson(json["option"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "metadata": metadata,
        "option_id": optionId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "option": option?.toJson(),
      };
}

class XImage {
  final String id;
  final String? url;
  final dynamic metadata;
  final int? rank;
  final String productId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final String? title;
  final List<Option>? values;

  XImage({
    required this.id,
    this.url,
    required this.metadata,
    this.rank,
    required this.productId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    this.title,
    this.values,
  });

  factory XImage.fromJson(Map<String, dynamic> json) => XImage(
        id: json["id"],
        url: json["url"],
        metadata: json["metadata"],
        rank: json["rank"],
        productId: json["product_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        title: json["title"],
        values: json["values"] == null
            ? []
            : List<Option>.from(json["values"]!.map((x) => Option.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "metadata": metadata,
        "rank": rank,
        "product_id": productId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "title": title,
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class Variant {
  final String id;
  final String title;
  final dynamic sku;
  final dynamic barcode;
  final dynamic ean;
  final dynamic upc;
  final bool allowBackorder;
  final bool manageInventory;
  final dynamic hsCode;
  final dynamic originCountry;
  final dynamic midCode;
  final dynamic material;
  final dynamic weight;
  final dynamic length;
  final dynamic height;
  final dynamic width;
  final dynamic metadata;
  final int variantRank;
  final String productId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final List<Option> options;
  final CalculatedPrice calculatedPrice;

  Variant({
    required this.id,
    required this.title,
    required this.sku,
    required this.barcode,
    required this.ean,
    required this.upc,
    required this.allowBackorder,
    required this.manageInventory,
    required this.hsCode,
    required this.originCountry,
    required this.midCode,
    required this.material,
    required this.weight,
    required this.length,
    required this.height,
    required this.width,
    required this.metadata,
    required this.variantRank,
    required this.productId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.options,
    required this.calculatedPrice,
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
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        options:
            List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
        calculatedPrice: CalculatedPrice.fromJson(json["calculated_price"]),
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
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
        "calculated_price": calculatedPrice.toJson(),
      };
}

class CalculatedPrice {
  final String id;
  final bool isCalculatedPricePriceList;
  final bool isCalculatedPriceTaxInclusive;
  final int calculatedAmount;
  final RawAmount rawCalculatedAmount;
  final bool isOriginalPricePriceList;
  final bool isOriginalPriceTaxInclusive;
  final int originalAmount;
  final RawAmount rawOriginalAmount;
  final String currencyCode;
  final Price calculatedPrice;
  final Price originalPrice;

  CalculatedPrice({
    required this.id,
    required this.isCalculatedPricePriceList,
    required this.isCalculatedPriceTaxInclusive,
    required this.calculatedAmount,
    required this.rawCalculatedAmount,
    required this.isOriginalPricePriceList,
    required this.isOriginalPriceTaxInclusive,
    required this.originalAmount,
    required this.rawOriginalAmount,
    required this.currencyCode,
    required this.calculatedPrice,
    required this.originalPrice,
  });

  factory CalculatedPrice.fromJson(Map<String, dynamic> json) =>
      CalculatedPrice(
        id: json["id"],
        isCalculatedPricePriceList: json["is_calculated_price_price_list"],
        isCalculatedPriceTaxInclusive:
            json["is_calculated_price_tax_inclusive"],
        calculatedAmount: json["calculated_amount"],
        rawCalculatedAmount: RawAmount.fromJson(json["raw_calculated_amount"]),
        isOriginalPricePriceList: json["is_original_price_price_list"],
        isOriginalPriceTaxInclusive: json["is_original_price_tax_inclusive"],
        originalAmount: json["original_amount"],
        rawOriginalAmount: RawAmount.fromJson(json["raw_original_amount"]),
        currencyCode: json["currency_code"],
        calculatedPrice: Price.fromJson(json["calculated_price"]),
        originalPrice: Price.fromJson(json["original_price"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_calculated_price_price_list": isCalculatedPricePriceList,
        "is_calculated_price_tax_inclusive": isCalculatedPriceTaxInclusive,
        "calculated_amount": calculatedAmount,
        "raw_calculated_amount": rawCalculatedAmount.toJson(),
        "is_original_price_price_list": isOriginalPricePriceList,
        "is_original_price_tax_inclusive": isOriginalPriceTaxInclusive,
        "original_amount": originalAmount,
        "raw_original_amount": rawOriginalAmount.toJson(),
        "currency_code": currencyCode,
        "calculated_price": calculatedPrice.toJson(),
        "original_price": originalPrice.toJson(),
      };
}

class Price {
  final String id;
  final dynamic priceListId;
  final dynamic priceListType;
  final dynamic minQuantity;
  final dynamic maxQuantity;

  Price({
    required this.id,
    required this.priceListId,
    required this.priceListType,
    required this.minQuantity,
    required this.maxQuantity,
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

class RawAmount {
  final String value;
  final int precision;

  RawAmount({
    required this.value,
    required this.precision,
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
