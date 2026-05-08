import 'dart:convert';

PromotionsModel promotionsModelFromMap(String str) =>
    PromotionsModel.fromMap(json.decode(str));

String promotionsModelToMap(PromotionsModel data) => json.encode(data.toMap());

class PromotionsModel {
  final Cart? cart;

  PromotionsModel({
    this.cart,
  });

  factory PromotionsModel.fromMap(Map<String, dynamic> json) => PromotionsModel(
        cart: json["cart"] == null ? null : Cart.fromMap(json["cart"]),
      );

  Map<String, dynamic> toMap() => {
        "cart": cart?.toMap(),
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
  final int? total;
  final int? subtotal;
  final int? taxTotal;
  final int? discountTotal;
  final int? discountSubtotal;
  final int? discountTaxTotal;
  final int? originalTotal;
  final int? originalTaxTotal;
  final int? itemTotal;
  final int? itemSubtotal;
  final int? itemTaxTotal;
  final int? originalItemTotal;
  final int? originalItemSubtotal;
  final int? originalItemTaxTotal;
  final int? shippingTotal;
  final int? shippingSubtotal;
  final int? shippingTaxTotal;
  final int? originalShippingTaxTotal;
  final int? originalShippingSubtotal;
  final int? originalShippingTotal;
  final dynamic metadata;
  final String? salesChannelId;
  final String? shippingAddressId;
  final String? customerId;
  final List<dynamic>? items;
  final List<dynamic>? shippingMethods;
  final ShippingAddress? shippingAddress;
  final dynamic billingAddress;
  final Customer? customer;
  final Region? region;
  final List<dynamic>? promotions;

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
    this.metadata,
    this.salesChannelId,
    this.shippingAddressId,
    this.customerId,
    this.items,
    this.shippingMethods,
    this.shippingAddress,
    this.billingAddress,
    this.customer,
    this.region,
    this.promotions,
  });

  factory Cart.fromMap(Map<String, dynamic> json) => Cart(
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
        total: json["total"],
        subtotal: json["subtotal"],
        taxTotal: json["tax_total"],
        discountTotal: json["discount_total"],
        discountSubtotal: json["discount_subtotal"],
        discountTaxTotal: json["discount_tax_total"],
        originalTotal: json["original_total"],
        originalTaxTotal: json["original_tax_total"],
        itemTotal: json["item_total"],
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
        metadata: json["metadata"],
        salesChannelId: json["sales_channel_id"],
        shippingAddressId: json["shipping_address_id"],
        customerId: json["customer_id"],
        items: json["items"] == null
            ? []
            : List<dynamic>.from(json["items"]!.map((x) => x)),
        shippingMethods: json["shipping_methods"] == null
            ? []
            : List<dynamic>.from(json["shipping_methods"]!.map((x) => x)),
        shippingAddress: json["shipping_address"] == null
            ? null
            : ShippingAddress.fromMap(json["shipping_address"]),
        billingAddress: json["billing_address"],
        customer: json["customer"] == null
            ? null
            : Customer.fromMap(json["customer"]),
        region: json["region"] == null ? null : Region.fromMap(json["region"]),
        promotions: json["promotions"] == null
            ? []
            : List<dynamic>.from(json["promotions"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
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
        "metadata": metadata,
        "sales_channel_id": salesChannelId,
        "shipping_address_id": shippingAddressId,
        "customer_id": customerId,
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x)),
        "shipping_methods": shippingMethods == null
            ? []
            : List<dynamic>.from(shippingMethods!.map((x) => x)),
        "shipping_address": shippingAddress?.toMap(),
        "billing_address": billingAddress,
        "customer": customer?.toMap(),
        "region": region?.toMap(),
        "promotions": promotions == null
            ? []
            : List<dynamic>.from(promotions!.map((x) => x)),
      };
}

class Customer {
  final String? id;
  final String? email;
  final List<dynamic>? groups;

  Customer({
    this.id,
    this.email,
    this.groups,
  });

  factory Customer.fromMap(Map<String, dynamic> json) => Customer(
        id: json["id"],
        email: json["email"],
        groups: json["groups"] == null
            ? []
            : List<dynamic>.from(json["groups"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "groups":
            groups == null ? [] : List<dynamic>.from(groups!.map((x) => x)),
      };
}

class Region {
  final String? id;
  final String? name;
  final String? currencyCode;
  final bool? automaticTaxes;
  final List<Country>? countries;

  Region({
    this.id,
    this.name,
    this.currencyCode,
    this.automaticTaxes,
    this.countries,
  });

  factory Region.fromMap(Map<String, dynamic> json) => Region(
        id: json["id"],
        name: json["name"],
        currencyCode: json["currency_code"],
        automaticTaxes: json["automatic_taxes"],
        countries: json["countries"] == null
            ? []
            : List<Country>.from(
                json["countries"]!.map((x) => Country.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "currency_code": currencyCode,
        "automatic_taxes": automaticTaxes,
        "countries": countries == null
            ? []
            : List<dynamic>.from(countries!.map((x) => x.toMap())),
      };
}

class Country {
  final String? iso2;
  final String? iso3;
  final String? numCode;
  final String? name;
  final String? displayName;
  final String? regionId;
  final dynamic metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  Country({
    this.iso2,
    this.iso3,
    this.numCode,
    this.name,
    this.displayName,
    this.regionId,
    this.metadata,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Country.fromMap(Map<String, dynamic> json) => Country(
        iso2: json["iso_2"],
        iso3: json["iso_3"],
        numCode: json["num_code"],
        name: json["name"],
        displayName: json["display_name"],
        regionId: json["region_id"],
        metadata: json["metadata"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toMap() => {
        "iso_2": iso2,
        "iso_3": iso3,
        "num_code": numCode,
        "name": name,
        "display_name": displayName,
        "region_id": regionId,
        "metadata": metadata,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class ShippingAddress {
  final String? id;
  final dynamic firstName;
  final dynamic lastName;
  final dynamic company;
  final dynamic address1;
  final dynamic address2;
  final dynamic city;
  final dynamic postalCode;
  final String? countryCode;
  final dynamic province;
  final dynamic phone;

  ShippingAddress({
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

  factory ShippingAddress.fromMap(Map<String, dynamic> json) => ShippingAddress(
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

  Map<String, dynamic> toMap() => {
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
