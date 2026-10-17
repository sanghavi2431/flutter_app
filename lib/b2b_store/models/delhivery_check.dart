// To parse this JSON data, do
//
//     final pincodeCheckResponse = pincodeCheckResponseFromMap(jsonString);

import 'dart:convert';

ShippingOptionsResponse shippingOptionsResponseFromMap(String str) =>
    ShippingOptionsResponse.fromMap(json.decode(str));

String shippingOptionsResponseToMap(ShippingOptionsResponse data) =>
    json.encode(data.toMap());

class ShippingOptionsResponse {
  final List<ShippingOption>? shippingOptions;

  ShippingOptionsResponse({
    this.shippingOptions,
  });

  factory ShippingOptionsResponse.fromMap(Map<String, dynamic> json) =>
      ShippingOptionsResponse(
        shippingOptions: json["shipping_options"] == null
            ? []
            : List<ShippingOption>.from(json["shipping_options"]!
                .map((x) => ShippingOption.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "shipping_options": shippingOptions == null
            ? []
            : List<dynamic>.from(shippingOptions!.map((x) => x.toMap())),
      };
}

class ShippingOption {
  final String? id;
  final String? name;
  final String? priceType;
  final String? serviceZoneId;
  final String? shippingProfileId;
  final String? providerId;
  final Data? data;
  final ServiceZone? serviceZone;
  final Type? type;
  final Provider? provider;
  final List<Rule>? rules;
  final CalculatedPrice? calculatedPrice;
  final List<PriceElement>? prices;
  final bool? isTaxInclusive;
  final int? amount;

  ShippingOption({
    this.id,
    this.name,
    this.priceType,
    this.serviceZoneId,
    this.shippingProfileId,
    this.providerId,
    this.data,
    this.serviceZone,
    this.type,
    this.provider,
    this.rules,
    this.calculatedPrice,
    this.prices,
    this.isTaxInclusive,
    this.amount,
  });

  factory ShippingOption.fromMap(Map<String, dynamic> json) => ShippingOption(
        id: json["id"],
        name: json["name"],
        priceType: json["price_type"],
        serviceZoneId: json["service_zone_id"],
        shippingProfileId: json["shipping_profile_id"],
        providerId: json["provider_id"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
        serviceZone: json["service_zone"] == null
            ? null
            : ServiceZone.fromMap(json["service_zone"]),
        type: json["type"] == null ? null : Type.fromMap(json["type"]),
        provider: json["provider"] == null
            ? null
            : Provider.fromMap(json["provider"]),
        rules: json["rules"] == null
            ? []
            : List<Rule>.from(json["rules"]!.map((x) => Rule.fromMap(x))),
        calculatedPrice: json["calculated_price"] == null
            ? null
            : CalculatedPrice.fromMap(json["calculated_price"]),
        prices: json["prices"] == null
            ? []
            : List<PriceElement>.from(
                json["prices"]!.map((x) => PriceElement.fromMap(x))),
        isTaxInclusive: json["is_tax_inclusive"],
        amount: json["amount"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "price_type": priceType,
        "service_zone_id": serviceZoneId,
        "shipping_profile_id": shippingProfileId,
        "provider_id": providerId,
        "data": data?.toMap(),
        "service_zone": serviceZone?.toMap(),
        "type": type?.toMap(),
        "provider": provider?.toMap(),
        "rules": rules == null
            ? []
            : List<dynamic>.from(rules!.map((x) => x.toMap())),
        "calculated_price": calculatedPrice?.toMap(),
        "prices": prices == null
            ? []
            : List<dynamic>.from(prices!.map((x) => x.toMap())),
        "is_tax_inclusive": isTaxInclusive,
        "amount": amount,
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

  factory CalculatedPrice.fromMap(Map<String, dynamic> json) => CalculatedPrice(
        id: json["id"],
        isCalculatedPricePriceList: json["is_calculated_price_price_list"],
        isCalculatedPriceTaxInclusive:
            json["is_calculated_price_tax_inclusive"],
        calculatedAmount: json["calculated_amount"],
        rawCalculatedAmount: json["raw_calculated_amount"] == null
            ? null
            : RawAmount.fromMap(json["raw_calculated_amount"]),
        isOriginalPricePriceList: json["is_original_price_price_list"],
        isOriginalPriceTaxInclusive: json["is_original_price_tax_inclusive"],
        originalAmount: json["original_amount"],
        rawOriginalAmount: json["raw_original_amount"] == null
            ? null
            : RawAmount.fromMap(json["raw_original_amount"]),
        currencyCode: json["currency_code"],
        calculatedPrice: json["calculated_price"] == null
            ? null
            : Price.fromMap(json["calculated_price"]),
        originalPrice: json["original_price"] == null
            ? null
            : Price.fromMap(json["original_price"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "is_calculated_price_price_list": isCalculatedPricePriceList,
        "is_calculated_price_tax_inclusive": isCalculatedPriceTaxInclusive,
        "calculated_amount": calculatedAmount,
        "raw_calculated_amount": rawCalculatedAmount?.toMap(),
        "is_original_price_price_list": isOriginalPricePriceList,
        "is_original_price_tax_inclusive": isOriginalPriceTaxInclusive,
        "original_amount": originalAmount,
        "raw_original_amount": rawOriginalAmount?.toMap(),
        "currency_code": currencyCode,
        "calculated_price": calculatedPrice?.toMap(),
        "original_price": originalPrice?.toMap(),
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

  factory Price.fromMap(Map<String, dynamic> json) => Price(
        id: json["id"],
        priceListId: json["price_list_id"],
        priceListType: json["price_list_type"],
        minQuantity: json["min_quantity"],
        maxQuantity: json["max_quantity"],
      );

  Map<String, dynamic> toMap() => {
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

  factory RawAmount.fromMap(Map<String, dynamic> json) => RawAmount(
        value: json["value"],
        precision: json["precision"],
      );

  Map<String, dynamic> toMap() => {
        "value": value,
        "precision": precision,
      };
}

class Data {
  final String? id;
  final String? name;

  Data({
    this.id,
    this.name,
  });

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}

class PriceElement {
  final String? id;
  final dynamic title;
  final String? currencyCode;
  final dynamic minQuantity;
  final dynamic maxQuantity;
  final int? rulesCount;
  final String? priceSetId;
  final dynamic priceListId;
  final dynamic priceList;
  final RawAmount? rawAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final List<dynamic>? priceRules;
  final int? amount;

  PriceElement({
    this.id,
    this.title,
    this.currencyCode,
    this.minQuantity,
    this.maxQuantity,
    this.rulesCount,
    this.priceSetId,
    this.priceListId,
    this.priceList,
    this.rawAmount,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.priceRules,
    this.amount,
  });

  factory PriceElement.fromMap(Map<String, dynamic> json) => PriceElement(
        id: json["id"],
        title: json["title"],
        currencyCode: json["currency_code"],
        minQuantity: json["min_quantity"],
        maxQuantity: json["max_quantity"],
        rulesCount: json["rules_count"],
        priceSetId: json["price_set_id"],
        priceListId: json["price_list_id"],
        priceList: json["price_list"],
        rawAmount: json["raw_amount"] == null
            ? null
            : RawAmount.fromMap(json["raw_amount"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        priceRules: json["price_rules"] == null
            ? []
            : List<dynamic>.from(json["price_rules"]!.map((x) => x)),
        amount: json["amount"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "currency_code": currencyCode,
        "min_quantity": minQuantity,
        "max_quantity": maxQuantity,
        "rules_count": rulesCount,
        "price_set_id": priceSetId,
        "price_list_id": priceListId,
        "price_list": priceList,
        "raw_amount": rawAmount?.toMap(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "price_rules": priceRules == null
            ? []
            : List<dynamic>.from(priceRules!.map((x) => x)),
        "amount": amount,
      };
}

class Provider {
  final String? id;
  final bool? isEnabled;

  Provider({
    this.id,
    this.isEnabled,
  });

  factory Provider.fromMap(Map<String, dynamic> json) => Provider(
        id: json["id"],
        isEnabled: json["is_enabled"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "is_enabled": isEnabled,
      };
}

class Rule {
  final String? attribute;
  final String? value;
  final String? ruleOperator;

  Rule({
    this.attribute,
    this.value,
    this.ruleOperator,
  });

  factory Rule.fromMap(Map<String, dynamic> json) => Rule(
        attribute: json["attribute"],
        value: json["value"],
        ruleOperator: json["operator"],
      );

  Map<String, dynamic> toMap() => {
        "attribute": attribute,
        "value": value,
        "operator": ruleOperator,
      };
}

class ServiceZone {
  final String? fulfillmentSetId;
  final String? id;

  ServiceZone({
    this.fulfillmentSetId,
    this.id,
  });

  factory ServiceZone.fromMap(Map<String, dynamic> json) => ServiceZone(
        fulfillmentSetId: json["fulfillment_set_id"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "fulfillment_set_id": fulfillmentSetId,
        "id": id,
      };
}

class Type {
  final String? id;
  final String? label;
  final String? description;
  final String? code;

  Type({
    this.id,
    this.label,
    this.description,
    this.code,
  });

  factory Type.fromMap(Map<String, dynamic> json) => Type(
        id: json["id"],
        label: json["label"],
        description: json["description"],
        code: json["code"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "label": label,
        "description": description,
        "code": code,
      };
}

class PincodeCheckResponse {
  final List<DeliveryCode>? deliveryCodes;

  PincodeCheckResponse({
    this.deliveryCodes,
  });

  factory PincodeCheckResponse.fromMap(Map<String, dynamic> json) =>
      PincodeCheckResponse(
        deliveryCodes: json["delivery_codes"] == null
            ? []
            : List<DeliveryCode>.from(
                json["delivery_codes"]!.map((x) => DeliveryCode.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "delivery_codes": deliveryCodes == null
            ? []
            : List<dynamic>.from(deliveryCodes!.map((x) => x.toMap())),
      };
}

class DeliveryCode {
  final PostalCode? postalCode;

  DeliveryCode({
    this.postalCode,
  });

  factory DeliveryCode.fromMap(Map<String, dynamic> json) => DeliveryCode(
        postalCode: json["postal_code"] == null
            ? null
            : PostalCode.fromMap(json["postal_code"]),
      );

  Map<String, dynamic> toMap() => {
        "postal_code": postalCode?.toMap(),
      };
}

class PostalCode {
  final dynamic? maxWeight;
  final String? city;
  final String? cod;
  final String? inc;
  final String? district;
  final dynamic? pin;
  final dynamic? maxAmount;
  final String? prePaid;
  final String? cash;
  final String? stateCode;
  final String? remarks;
  final String? pickup;
  final String? repl;
  final String? covidZone;
  final String? countryCode;
  final String? isOda;
  final bool? protectBlacklist;
  final String? sortCode;
  final bool? sunTat;
  // final List<Center>? center;

  PostalCode({
    this.maxWeight,
    this.city,
    this.cod,
    this.inc,
    this.district,
    this.pin,
    this.maxAmount,
    this.prePaid,
    this.cash,
    this.stateCode,
    this.remarks,
    this.pickup,
    this.repl,
    this.covidZone,
    this.countryCode,
    this.isOda,
    this.protectBlacklist,
    this.sortCode,
    this.sunTat,
    // this.center,
  });

  factory PostalCode.fromMap(Map<String, dynamic> json) => PostalCode(
        maxWeight: json["max_weight"],
        city: json["city"],
        cod: json["cod"],
        inc: json["inc"],
        district: json["district"],
        pin: json["pin"],
        maxAmount: json["max_amount"],
        prePaid: json["pre_paid"],
        cash: json["cash"],
        stateCode: json["state_code"],
        remarks: json["remarks"],
        pickup: json["pickup"],
        repl: json["repl"],
        covidZone: json["covid_zone"],
        countryCode: json["country_code"],
        isOda: json["is_oda"],
        protectBlacklist: json["protect_blacklist"],
        sortCode: json["sort_code"],
        sunTat: json["sun_tat"],
      );

  Map<String, dynamic> toMap() => {
        "max_weight": maxWeight,
        "city": city,
        "cod": cod,
        "inc": inc,
        "district": district,
        "pin": pin,
        "max_amount": maxAmount,
        "pre_paid": prePaid,
        "cash": cash,
        "state_code": stateCode,
        "remarks": remarks,
        "pickup": pickup,
        "repl": repl,
        "covid_zone": covidZone,
        "country_code": countryCode,
        "is_oda": isOda,
        "protect_blacklist": protectBlacklist,
        "sort_code": sortCode,
        "sun_tat": sunTat,
      };
}
