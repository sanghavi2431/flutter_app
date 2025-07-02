// To parse this JSON data, do
//
//     final wishlist = wishlistFromJson(jsonString);

import 'dart:convert';

Wishlist wishlistFromJson(String str) => Wishlist.fromJson(json.decode(str));

String wishlistToJson(Wishlist data) => json.encode(data.toJson());

class Wishlist {
  final WishlistClass? wishlist;

  Wishlist({
    this.wishlist,
  });

  factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
        wishlist: json["wishlist"] == null
            ? null
            : WishlistClass.fromJson(json["wishlist"]),
      );

  Map<String, dynamic> toJson() => {
        "wishlist": wishlist?.toJson(),
      };
}

class WishlistClass {
  final String? id;
  final String? customerId;
  final String? salesChannelId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final List<Item>? items;

  WishlistClass({
    this.id,
    this.customerId,
    this.salesChannelId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.items,
  });

  factory WishlistClass.fromJson(Map<String, dynamic> json) => WishlistClass(
        id: json["id"],
        customerId: json["customer_id"],
        salesChannelId: json["sales_channel_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "sales_channel_id": salesChannelId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Item {
  final String? id;
  final String? productVariantId;
  final String? wishlistId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final ProductVariant? productVariant;

  Item({
    this.id,
    this.productVariantId,
    this.wishlistId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.productVariant,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        productVariantId: json["product_variant_id"],
        wishlistId: json["wishlist_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        productVariant: json["product_variant"] == null
            ? null
            : ProductVariant.fromJson(json["product_variant"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_variant_id": productVariantId,
        "wishlist_id": wishlistId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "product_variant": productVariant?.toJson(),
      };
}

class ProductVariant {
  final String? id;
  final String? title;
  final dynamic sku;
  final dynamic barcode;
  final dynamic ean;
  final dynamic upc;
  final bool? allowBackorder;
  final bool? manageInventory;
  final dynamic hsCode;
  final dynamic originCountry;
  final dynamic midCode;
  final dynamic material;
  final dynamic weight;
  final dynamic length;
  final dynamic height;
  final dynamic width;
  final dynamic metadata;
  final int? variantRank;
  final String? productId;
  final Product? product;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final CalculatedPrice? calculatedPrice;

  ProductVariant({
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
    this.product,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.calculatedPrice,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
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
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        calculatedPrice: json["calculated_price"] == null
            ? null
            : CalculatedPrice.fromJson(json["calculated_price"]),
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
        "product": product?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "calculated_price": calculatedPrice?.toJson(),
      };
}

class CalculatedPrice {
  final String? id;
  final bool? isCalculatedPricePriceList;
  final bool? isCalculatedPriceTaxInclusive;
  final int? calculatedAmount;
  final RawAmount? rawCalculatedAmount;
  final bool? isOriginalPricePriceList;
  final bool? isOriginalPriceTaxInclusive;
  final int? originalAmount;
  final RawAmount? rawOriginalAmount;
  final String? currencyCode;
  final Price? calculatedPrice;
  final Price? originalPrice;

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
        currencyCode: json["currency_code"],
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
        "currency_code": currencyCode,
        "calculated_price": calculatedPrice?.toJson(),
        "original_price": originalPrice?.toJson(),
      };
}

class Price {
  final String? id;
  final dynamic priceListId;
  final dynamic priceListType;
  final dynamic minQuantity;
  final dynamic maxQuantity;

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

class RawAmount {
  final String? value;
  final int? precision;

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

class Product {
  final String? id;
  final String? title;
  final String? handle;
  final String? subtitle;
  final String? description;
  final bool? isGiftcard;
  final String? status;
  final String? thumbnail;
  final dynamic weight;
  final dynamic length;
  final dynamic height;
  final dynamic width;
  final dynamic originCountry;
  final dynamic hsCode;
  final dynamic midCode;
  final dynamic material;
  final bool? discountable;
  final dynamic externalId;
  final dynamic metadata;
  final dynamic typeId;
  final dynamic type;
  final String? collectionId;
  final Collection? collection;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  Product({
    this.id,
    this.title,
    this.handle,
    this.subtitle,
    this.description,
    this.isGiftcard,
    this.status,
    this.thumbnail,
    this.weight,
    this.length,
    this.height,
    this.width,
    this.originCountry,
    this.hsCode,
    this.midCode,
    this.material,
    this.discountable,
    this.externalId,
    this.metadata,
    this.typeId,
    this.type,
    this.collectionId,
    this.collection,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        title: json["title"],
        handle: json["handle"],
        subtitle: json["subtitle"],
        description: json["description"],
        isGiftcard: json["is_giftcard"],
        status: json["status"],
        thumbnail: json["thumbnail"],
        weight: json["weight"],
        length: json["length"],
        height: json["height"],
        width: json["width"],
        originCountry: json["origin_country"],
        hsCode: json["hs_code"],
        midCode: json["mid_code"],
        material: json["material"],
        discountable: json["discountable"],
        externalId: json["external_id"],
        metadata: json["metadata"],
        typeId: json["type_id"],
        type: json["type"],
        collectionId: json["collection_id"],
        collection: json["collection"] == null
            ? null
            : Collection.fromJson(json["collection"]),
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
        "title": title,
        "handle": handle,
        "subtitle": subtitle,
        "description": description,
        "is_giftcard": isGiftcard,
        "status": status,
        "thumbnail": thumbnail,
        "weight": weight,
        "length": length,
        "height": height,
        "width": width,
        "origin_country": originCountry,
        "hs_code": hsCode,
        "mid_code": midCode,
        "material": material,
        "discountable": discountable,
        "external_id": externalId,
        "metadata": metadata,
        "type_id": typeId,
        "type": type,
        "collection_id": collectionId,
        "collection": collection?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class Collection {
  final String? id;

  Collection({
    this.id,
  });

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
