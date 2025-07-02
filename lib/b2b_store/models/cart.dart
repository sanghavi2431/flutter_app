import 'dart:convert';

import 'package:woloo_smart_hygiene/utils///logger.dart';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class Item {
  final String? id;
  final String? thumbnail;
  final String? variantId;
  final String? productId;
  final dynamic productTypeId;
  final String? productTitle;
  final String? productDescription;
  final String? productSubtitle;
  final dynamic productType;
  final String? productCollection;
  final String? productHandle;
  final dynamic variantSku;
  final dynamic variantBarcode;
  final String? variantTitle;
  final bool? requiresShipping;
  final Metadata? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? title;
  final int? quantity;
  final int? unitPrice;
  final int? compareAtUnitPrice;
  final bool? isTaxInclusive;
  final List<dynamic>? taxLines;
  final List<Adjustment>? adjustments;
  final Product? product;

  Item({
    this.id,
    this.thumbnail,
    this.variantId,
    this.productId,
    this.productTypeId,
    this.productTitle,
    this.productDescription,
    this.productSubtitle,
    this.productType,
    this.productCollection,
    this.productHandle,
    this.variantSku,
    this.variantBarcode,
    this.variantTitle,
    this.requiresShipping,
    this.metadata,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.quantity,
    this.unitPrice,
    this.compareAtUnitPrice,
    this.isTaxInclusive,
    this.taxLines,
    this.adjustments,
    this.product,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        thumbnail: json["thumbnail"],
        variantId: json["variant_id"],
        productId: json["product_id"],
        productTypeId: json["product_type_id"],
        productTitle: json["product_title"],
        productDescription: json["product_description"],
        productSubtitle: json["product_subtitle"],
        productType: json["product_type"],
        productCollection: json["product_collection"],
        productHandle: json["product_handle"],
        variantSku: json["variant_sku"],
        variantBarcode: json["variant_barcode"],
        variantTitle: json["variant_title"],
        requiresShipping: json["requires_shipping"],
        metadata: json["metadata"] == null
            ? null
            : Metadata.fromJson(json["metadata"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        title: json["title"],
        quantity: json["quantity"],
        unitPrice: json["unit_price"],
        compareAtUnitPrice: json["compare_at_unit_price"],
        isTaxInclusive: json["is_tax_inclusive"],
        taxLines: json["tax_lines"] == null
            ? []
            : List<dynamic>.from(json["tax_lines"]!.map((x) => x)),
        adjustments: json["adjustments"] == null
            ? []
            : List<Adjustment>.from(
                json["adjustments"]!.map((x) => Adjustment.fromJson(x))),
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "thumbnail": thumbnail,
        "variant_id": variantId,
        "product_id": productId,
        "product_type_id": productTypeId,
        "product_title": productTitle,
        "product_description": productDescription,
        "product_subtitle": productSubtitle,
        "product_type": productType,
        "product_collection": productCollection,
        "product_handle": productHandle,
        "variant_sku": variantSku,
        "variant_barcode": variantBarcode,
        "variant_title": variantTitle,
        "requires_shipping": requiresShipping,
        "metadata": metadata?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "title": title,
        "quantity": quantity,
        "unit_price": unitPrice,
        "compare_at_unit_price": compareAtUnitPrice,
        "is_tax_inclusive": isTaxInclusive,
        "tax_lines":
            taxLines == null ? [] : List<dynamic>.from(taxLines!.map((x) => x)),
        "adjustments": adjustments == null
            ? []
            : List<dynamic>.from(adjustments!.map((x) => x.toJson())),
        "product": product?.toJson(),
      };
}

class CartModel {
  final Cart cart;

  CartModel({
    required this.cart,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    try {
      return CartModel(
        cart: Cart.fromJson(json["cart"]),
      );
    } catch (e) {
      //logger.e(e);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        "cart": cart.toJson(),
      };
}

class Cart {
  final String? id;
  final String? currencyCode;
  final String? email;
  final String? regionId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic completedAt;
  final double? total;
  final dynamic subtotal;
  final dynamic taxTotal;
  final double? discountTotal;
  final double? discountSubtotal;
  final dynamic discountTaxTotal;
  final dynamic originalTotal;
  final dynamic originalTaxTotal;
  final double? itemTotal;
  final dynamic itemSubtotal;
  final dynamic itemTaxTotal;
  final dynamic originalItemTotal;
  final dynamic originalItemSubtotal;
  final dynamic originalItemTaxTotal;
  final dynamic shippingTotal;
  final dynamic shippingSubtotal;
  final dynamic shippingTaxTotal;
  final dynamic originalShippingTaxTotal;
  final dynamic originalShippingSubtotal;
  final dynamic originalShippingTotal;
  final dynamic creditLineSubtotal;
  final dynamic creditLineTaxTotal;
  final dynamic creditLineTotal;
  final dynamic metadata;
  final String? salesChannelId;
  final String? shippingAddressId;
  final String? billingAddressId;
  final String? customerId;
  final List<Item>? items;
  final List<ShippingMethod>? shippingMethods;
  final IngAddress? shippingAddress;
  final IngAddress? billingAddress;
  final List<dynamic>? creditLines;
  final Customer? customer;
  final Region? region;
  final List<Promotion>? promotions;

  Cart({
    this.id,
    this.currencyCode,
    this.email,
    this.regionId,
    this.createdAt,
    this.updatedAt,
    this.completedAt,
    this.total,
    this.subtotal,
    this.taxTotal,
    this.discountTotal,
    this.discountSubtotal,
    this.discountTaxTotal,
    this.originalTotal,
    this.originalTaxTotal,
    this.itemTotal,
    this.itemSubtotal,
    this.itemTaxTotal,
    this.originalItemTotal,
    this.originalItemSubtotal,
    this.originalItemTaxTotal,
    this.shippingTotal,
    this.shippingSubtotal,
    this.shippingTaxTotal,
    this.originalShippingTaxTotal,
    this.originalShippingSubtotal,
    this.originalShippingTotal,
    this.creditLineSubtotal,
    this.creditLineTaxTotal,
    this.creditLineTotal,
    this.metadata,
    this.salesChannelId,
    this.shippingAddressId,
    this.billingAddressId,
    this.customerId,
    this.items,
    this.shippingMethods,
    this.shippingAddress,
    this.billingAddress,
    this.creditLines,
    this.customer,
    this.region,
    this.promotions,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json["id"],
        currencyCode: json["currency_code"],
        email: json["email"],
        regionId: json["region_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        completedAt: json["completed_at"],
        total: json["total"]?.toDouble(),
        subtotal: json["subtotal"],
        taxTotal: json["tax_total"],
        discountTotal: json["discount_total"]?.toDouble(),
        discountSubtotal: json["discount_subtotal"]?.toDouble(),
        discountTaxTotal: json["discount_tax_total"],
        originalTotal: json["original_total"],
        originalTaxTotal: json["original_tax_total"],
        itemTotal: json["item_total"]?.toDouble(),
        itemSubtotal: json["item_subtotal"],
        itemTaxTotal: json["item_tax_total"],
        originalItemTotal: json["original_item_total"],
        originalItemSubtotal: json["original_item_subtotal"],
        originalItemTaxTotal: json["original_item_tax_total"],
        shippingTotal: json["shipping_total"],
        shippingSubtotal: json["shipping_subtotal"],
        shippingTaxTotal: json["shipping_tax_total"],
        originalShippingTaxTotal: json["original_shipping_tax_total"],
        originalShippingSubtotal: json["original_shipping_subtotal"],
        originalShippingTotal: json["original_shipping_total"],
        creditLineSubtotal: json["credit_line_subtotal"],
        creditLineTaxTotal: json["credit_line_tax_total"],
        creditLineTotal: json["credit_line_total"],
        metadata: json["metadata"],
        salesChannelId: json["sales_channel_id"],
        shippingAddressId: json["shipping_address_id"],
        billingAddressId: json["billing_address_id"],
        customerId: json["customer_id"],
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
        shippingMethods: json["shipping_methods"] == null
            ? []
            : List<ShippingMethod>.from(json["shipping_methods"]!
                .map((x) => ShippingMethod.fromJson(x))),
        shippingAddress: json["shipping_address"] == null
            ? null
            : IngAddress.fromJson(json["shipping_address"]),
        billingAddress: json["billing_address"] == null
            ? null
            : IngAddress.fromJson(json["billing_address"]),
        creditLines: json["credit_lines"] == null
            ? []
            : List<dynamic>.from(json["credit_lines"]!.map((x) => x)),
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        region: json["region"] == null ? null : Region.fromJson(json["region"]),
        promotions: json["promotions"] == null
            ? []
            : List<Promotion>.from(
                json["promotions"]!.map((x) => Promotion.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "currency_code": currencyCode,
        "email": email,
        "region_id": regionId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "completed_at": completedAt,
        "total": total,
        "subtotal": subtotal,
        "tax_total": taxTotal,
        "discount_total": discountTotal,
        "discount_subtotal": discountSubtotal,
        "discount_tax_total": discountTaxTotal,
        "original_total": originalTotal,
        "original_tax_total": originalTaxTotal,
        "item_total": itemTotal,
        "item_subtotal": itemSubtotal,
        "item_tax_total": itemTaxTotal,
        "original_item_total": originalItemTotal,
        "original_item_subtotal": originalItemSubtotal,
        "original_item_tax_total": originalItemTaxTotal,
        "shipping_total": shippingTotal,
        "shipping_subtotal": shippingSubtotal,
        "shipping_tax_total": shippingTaxTotal,
        "original_shipping_tax_total": originalShippingTaxTotal,
        "original_shipping_subtotal": originalShippingSubtotal,
        "original_shipping_total": originalShippingTotal,
        "credit_line_subtotal": creditLineSubtotal,
        "credit_line_tax_total": creditLineTaxTotal,
        "credit_line_total": creditLineTotal,
        "metadata": metadata,
        "sales_channel_id": salesChannelId,
        "shipping_address_id": shippingAddressId,
        "billing_address_id": billingAddressId,
        "customer_id": customerId,
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "shipping_methods": shippingMethods == null
            ? []
            : List<dynamic>.from(shippingMethods!.map((x) => x.toJson())),
        "shipping_address": shippingAddress?.toJson(),
        "billing_address": billingAddress?.toJson(),
        "credit_lines": creditLines == null
            ? []
            : List<dynamic>.from(creditLines!.map((x) => x)),
        "customer": customer?.toJson(),
        "region": region?.toJson(),
        "promotions": promotions == null
            ? []
            : List<dynamic>.from(promotions!.map((x) => x.toJson())),
      };
}

class Customer {
  final String id;
  final String email;
  final List<dynamic> groups;

  Customer({
    required this.id,
    required this.email,
    required this.groups,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        email: json["email"],
        groups: List<dynamic>.from(json["groups"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "groups": List<dynamic>.from(groups.map((x) => x)),
      };
}

class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata();

  Map<String, dynamic> toJson() => {};
}

class Product {
  final String id;
  final dynamic collectionId;
  final dynamic typeId;
  final List<dynamic> categories;
  final List<dynamic> tags;

  Product({
    required this.id,
    required this.collectionId,
    required this.typeId,
    required this.categories,
    required this.tags,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        collectionId: json["collection_id"],
        typeId: json["type_id"],
        categories: List<dynamic>.from(json["categories"].map((x) => x)),
        tags: List<dynamic>.from(json["tags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "collection_id": collectionId,
        "type_id": typeId,
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "tags": List<dynamic>.from(tags.map((x) => x)),
      };
}

class Region {
  final String id;
  final String name;
  final String currencyCode;
  final bool automaticTaxes;
  final List<Country> countries;

  Region({
    required this.id,
    required this.name,
    required this.currencyCode,
    required this.automaticTaxes,
    required this.countries,
  });

  factory Region.fromJson(Map<String, dynamic> json) => Region(
        id: json["id"],
        name: json["name"],
        currencyCode: json["currency_code"],
        automaticTaxes: json["automatic_taxes"],
        countries: List<Country>.from(
            json["countries"].map((x) => Country.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "currency_code": currencyCode,
        "automatic_taxes": automaticTaxes,
        "countries": List<dynamic>.from(countries.map((x) => x.toJson())),
      };
}

class Country {
  final String iso2;
  final String iso3;
  final String numCode;
  final String name;
  final String displayName;
  final String regionId;
  final dynamic metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;

  Country({
    required this.iso2,
    required this.iso3,
    required this.numCode,
    required this.name,
    required this.displayName,
    required this.regionId,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        iso2: json["iso_2"],
        iso3: json["iso_3"],
        numCode: json["num_code"],
        name: json["name"],
        displayName: json["display_name"],
        regionId: json["region_id"],
        metadata: json["metadata"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "iso_2": iso2,
        "iso_3": iso3,
        "num_code": numCode,
        "name": name,
        "display_name": displayName,
        "region_id": regionId,
        "metadata": metadata,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class ShippingAddress {
  final String id;
  final dynamic firstName;
  final dynamic lastName;
  final dynamic company;
  final dynamic address1;
  final dynamic address2;
  final dynamic city;
  final dynamic postalCode;
  final String countryCode;
  final dynamic province;
  final dynamic phone;

  ShippingAddress({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.company,
    required this.address1,
    required this.address2,
    required this.city,
    required this.postalCode,
    required this.countryCode,
    required this.province,
    required this.phone,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      ShippingAddress(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        company: json["company"],
        address1: json["address_1"],
        address2: json["address_2"],
        city: json["city"],
        postalCode: json["postal_code"],
        countryCode: json["country_code"],
        province: json["province"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "company": company,
        "address_1": address1,
        "address_2": address2,
        "city": city,
        "postal_code": postalCode,
        "country_code": countryCode,
        "province": province,
        "phone": phone,
      };
}

class Countries {
  String? iso2;
  String? iso3;
  String? numCode;
  String? name;
  String? displayName;
  String? regionId;
  dynamic metadata;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['iso_2'] = iso2;
    data['iso_3'] = iso3;
    data['num_code'] = numCode;
    data['name'] = name;
    data['display_name'] = displayName;
    data['region_id'] = regionId;
    data['metadata'] = metadata;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

AddToCartResponse addToCartResponseFromJson(String str) =>
    AddToCartResponse.fromJson(json.decode(str));

String addToCartResponseToJson(AddToCartResponse data) =>
    json.encode(data.toJson());

class AddToCartResponse {
  final Cart? cart;

  AddToCartResponse({
    this.cart,
  });

  factory AddToCartResponse.fromJson(Map<String, dynamic> json) =>
      AddToCartResponse(
        cart: json["cart"] == null ? null : Cart.fromJson(json["cart"]),
      );

  Map<String, dynamic> toJson() => {
        "cart": cart?.toJson(),
      };
}

class IngAddress {
  final String? id;
  final String? firstName;
  final String? lastName;
  final dynamic company;
  final String? address1;
  final dynamic address2;
  final String? city;
  final String? postalCode;
  final String? countryCode;
  final String? province;
  final String? phone;

  IngAddress({
    this.id,
    this.firstName,
    this.lastName,
    this.company,
    this.address1,
    this.address2,
    this.city,
    this.postalCode,
    this.countryCode,
    this.province,
    this.phone,
  });

  factory IngAddress.fromJson(Map<String, dynamic> json) => IngAddress(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        company: json["company"],
        address1: json["address_1"],
        address2: json["address_2"],
        city: json["city"],
        postalCode: json["postal_code"],
        countryCode: json["country_code"],
        province: json["province"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "company": company,
        "address_1": address1,
        "address_2": address2,
        "city": city,
        "postal_code": postalCode,
        "country_code": countryCode,
        "province": province,
        "phone": phone,
      };
}

class Adjustment {
  final String? id;
  final String? code;
  final String? promotionId;
  final double? amount;

  Adjustment({
    this.id,
    this.code,
    this.promotionId,
    this.amount,
  });

  factory Adjustment.fromJson(Map<String, dynamic> json) => Adjustment(
        id: json["id"],
        code: json["code"],
        promotionId: json["promotion_id"],
        amount: json["amount"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "promotion_id": promotionId,
        "amount": amount,
      };
}

class Category {
  final String? id;

  Category({
    this.id,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

class Promotion {
  final String? id;
  final String? code;
  final bool? isAutomatic;
  final ApplicationMethod? applicationMethod;

  Promotion({
    this.id,
    this.code,
    this.isAutomatic,
    this.applicationMethod,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
        id: json["id"],
        code: json["code"],
        isAutomatic: json["is_automatic"],
        applicationMethod: json["application_method"] == null
            ? null
            : ApplicationMethod.fromJson(json["application_method"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "is_automatic": isAutomatic,
        "application_method": applicationMethod?.toJson(),
      };
}

class ApplicationMethod {
  final int? value;
  final String? type;
  final String? currencyCode;

  ApplicationMethod({
    this.value,
    this.type,
    this.currencyCode,
  });

  factory ApplicationMethod.fromJson(Map<String, dynamic> json) =>
      ApplicationMethod(
        value: json["value"],
        type: json["type"],
        currencyCode: json["currency_code"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "type": type,
        "currency_code": currencyCode,
      };
}

class ShippingMethod {
  final int? amount;
  final bool? isTaxInclusive;
  final String? shippingOptionId;
  final String? id;
  final List<dynamic>? taxLines;
  final List<dynamic>? adjustments;

  ShippingMethod({
    this.amount,
    this.isTaxInclusive,
    this.shippingOptionId,
    this.id,
    this.taxLines,
    this.adjustments,
  });

  factory ShippingMethod.fromJson(Map<String, dynamic> json) => ShippingMethod(
        amount: json["amount"],
        isTaxInclusive: json["is_tax_inclusive"],
        shippingOptionId: json["shipping_option_id"],
        id: json["id"],
        taxLines: json["tax_lines"] == null
            ? []
            : List<dynamic>.from(json["tax_lines"]!.map((x) => x)),
        adjustments: json["adjustments"] == null
            ? []
            : List<dynamic>.from(json["adjustments"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "is_tax_inclusive": isTaxInclusive,
        "shipping_option_id": shippingOptionId,
        "id": id,
        "tax_lines":
            taxLines == null ? [] : List<dynamic>.from(taxLines!.map((x) => x)),
        "adjustments": adjustments == null
            ? []
            : List<dynamic>.from(adjustments!.map((x) => x)),
      };
}
