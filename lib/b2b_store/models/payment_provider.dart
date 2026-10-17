// To parse this JSON data, do
//
//     final paymentCollection = paymentCollectionFromJson(jsonString);

import 'dart:convert';

PaymentProviders paymentProvidersFromJson(String str) =>
    PaymentProviders.fromJson(json.decode(str));

String paymentProvidersToJson(PaymentProviders data) =>
    json.encode(data.toJson());

class PaymentProviders {
  final List<PaymentProvider> paymentProviders;
  final int count;
  final int offset;
  final int limit;

  PaymentProviders({
    required this.paymentProviders,
    required this.count,
    required this.offset,
    required this.limit,
  });

  factory PaymentProviders.fromJson(Map<String, dynamic> json) =>
      PaymentProviders(
        paymentProviders: List<PaymentProvider>.from(
            json["payment_providers"].map((x) => PaymentProvider.fromJson(x))),
        count: json["count"],
        offset: json["offset"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "payment_providers":
            List<dynamic>.from(paymentProviders.map((x) => x.toJson())),
        "count": count,
        "offset": offset,
        "limit": limit,
      };
}

class PaymentProvider {
  final String id;
  final bool isEnabled;

  PaymentProvider({
    required this.id,
    required this.isEnabled,
  });

  factory PaymentProvider.fromJson(Map<String, dynamic> json) =>
      PaymentProvider(
        id: json["id"],
        isEnabled: json["is_enabled"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_enabled": isEnabled,
      };
}
// To parse this JSON data, do
//
//     final paymentCollection = paymentCollectionFromJson(jsonString);

PaymentCollection paymentCollectionFromJson(String str) =>
    PaymentCollection.fromJson(json.decode(str));

String paymentCollectionToJson(PaymentCollection data) =>
    json.encode(data.toJson());

class PaymentCollection {
  final PaymentCollectionClass? paymentCollection;

  PaymentCollection({
    this.paymentCollection,
  });

  factory PaymentCollection.fromJson(Map<String, dynamic> json) =>
      PaymentCollection(
        paymentCollection: json["payment_collection"] == null
            ? null
            : PaymentCollectionClass.fromJson(json["payment_collection"]),
      );

  Map<String, dynamic> toJson() => {
        "payment_collection": paymentCollection?.toJson(),
      };
}

class PaymentCollectionClass {
  final String? id;
  final String? currencyCode;
  final dynamic amount;
  final List<PaymentSession>? paymentSessions;

  PaymentCollectionClass({
    this.id,
    this.currencyCode,
    this.amount,
    this.paymentSessions,
  });

  factory PaymentCollectionClass.fromJson(Map<String, dynamic> json) =>
      PaymentCollectionClass(
        id: json["id"],
        currencyCode: json["currency_code"],
        amount: json["amount"]?.toDouble(),
        paymentSessions: json["payment_sessions"] == null
            ? []
            : List<PaymentSession>.from(json["payment_sessions"]!
                .map((x) => PaymentSession.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "currency_code": currencyCode,
        "amount": amount,
        "payment_sessions": paymentSessions == null
            ? []
            : List<dynamic>.from(paymentSessions!.map((x) => x.toJson())),
      };
}

class PaymentSession {
  final String? id;
  final String? currencyCode;
  final String? providerId;
  final Data? data;
  final Context? context;
  final String? status;
  final dynamic authorizedAt;
  final String? paymentCollectionId;
  final dynamic metadata;
  final RawAmount? rawAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final dynamic amount;

  PaymentSession({
    this.id,
    this.currencyCode,
    this.providerId,
    this.data,
    this.context,
    this.status,
    this.authorizedAt,
    this.paymentCollectionId,
    this.metadata,
    this.rawAmount,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.amount,
  });

  factory PaymentSession.fromJson(Map<String, dynamic> json) => PaymentSession(
        id: json["id"],
        currencyCode: json["currency_code"],
        providerId: json["provider_id"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        context:
            json["context"] == null ? null : Context.fromJson(json["context"]),
        status: json["status"],
        authorizedAt: json["authorized_at"],
        paymentCollectionId: json["payment_collection_id"],
        metadata: json["metadata"],
        rawAmount: json["raw_amount"] == null
            ? null
            : RawAmount.fromJson(json["raw_amount"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        amount: json["amount"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "currency_code": currencyCode,
        "provider_id": providerId,
        "data": data?.toJson(),
        "context": context?.toJson(),
        "status": status,
        "authorized_at": authorizedAt,
        "payment_collection_id": paymentCollectionId,
        "metadata": metadata,
        "raw_amount": rawAmount?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "amount": amount,
      };
}

class Context {
  final Customer? customer;

  Context({
    this.customer,
  });

  factory Context.fromJson(Map<String, dynamic> json) => Context(
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
      );

  Map<String, dynamic> toJson() => {
        "customer": customer?.toJson(),
      };
}

class Customer {
  final dynamic id;
  final String? email;
  final dynamic phone;
  final dynamic metadata;
  final List<Address>? addresses;
  final dynamic lastName;
  final dynamic firstName;
  final dynamic companyName;
  final List<dynamic>? accountHolders;
  final Address? billingAddress;

  Customer({
    this.id,
    this.email,
    this.phone,
    this.metadata,
    this.addresses,
    this.lastName,
    this.firstName,
    this.companyName,
    this.accountHolders,
    this.billingAddress,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        email: json["email"],
        phone: json["phone"],
        metadata: json["metadata"],
        addresses: json["addresses"] == null
            ? []
            : List<Address>.from(
                json["addresses"]!.map((x) => Address.fromJson(x))),
        lastName: json["last_name"],
        firstName: json["first_name"],
        companyName: json["company_name"],
        accountHolders: json["account_holders"] == null
            ? []
            : List<dynamic>.from(json["account_holders"]!.map((x) => x)),
        billingAddress: json["billing_address"] == null
            ? null
            : Address.fromJson(json["billing_address"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "phone": phone,
        "metadata": metadata,
        "addresses": addresses == null
            ? []
            : List<dynamic>.from(addresses!.map((x) => x.toJson())),
        "last_name": lastName,
        "first_name": firstName,
        "company_name": companyName,
        "account_holders": accountHolders == null
            ? []
            : List<dynamic>.from(accountHolders!.map((x) => x)),
        "billing_address": billingAddress?.toJson(),
      };
}

class Address {
  final String? id;
  final String? city;
  final String? phone;
  final dynamic company;
  final dynamic metadata;
  final String? province;
  final String? address1;
  final String? address2;
  final String? lastName;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final String? firstName;
  final DateTime? updatedAt;
  final String? customerId;
  final String? postalCode;
  final String? addressName;
  final dynamic countryCode;
  final bool? isDefaultBilling;
  final bool? isDefaultShipping;

  Address({
    this.id,
    this.city,
    this.phone,
    this.company,
    this.metadata,
    this.province,
    this.address1,
    this.address2,
    this.lastName,
    this.createdAt,
    this.deletedAt,
    this.firstName,
    this.updatedAt,
    this.customerId,
    this.postalCode,
    this.addressName,
    this.countryCode,
    this.isDefaultBilling,
    this.isDefaultShipping,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        city: json["city"],
        phone: json["phone"],
        company: json["company"],
        metadata: json["metadata"],
        province: json["province"],
        address1: json["address_1"],
        address2: json["address_2"],
        lastName: json["last_name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        deletedAt: json["deleted_at"],
        firstName: json["first_name"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        customerId: json["customer_id"],
        postalCode: json["postal_code"],
        addressName: json["address_name"],
        countryCode: json["country_code"],
        isDefaultBilling: json["is_default_billing"],
        isDefaultShipping: json["is_default_shipping"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "city": city,
        "phone": phone,
        "company": company,
        "metadata": metadata,
        "province": province,
        "address_1": address1,
        "address_2": address2,
        "last_name": lastName,
        "created_at": createdAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "first_name": firstName,
        "updated_at": updatedAt?.toIso8601String(),
        "customer_id": customerId,
        "postal_code": postalCode,
        "address_name": addressName,
        "country_code": countryCode,
        "is_default_billing": isDefaultBilling,
        "is_default_shipping": isDefaultShipping,
      };
}

class Data {
  final String? id;
  final Notes? notes;
  final int? amount;
  final String? entity;
  final String? status;
  final String? receipt;
  final int? attempts;
  final String? currency;
  final dynamic offerId;
  final int? amountDue;
  final int? createdAt;
  final int? amountPaid;

  Data({
    this.id,
    this.notes,
    this.amount,
    this.entity,
    this.status,
    this.receipt,
    this.attempts,
    this.currency,
    this.offerId,
    this.amountDue,
    this.createdAt,
    this.amountPaid,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        notes: json["notes"] == null ? null : Notes.fromJson(json["notes"]),
        amount: json["amount"],
        entity: json["entity"],
        status: json["status"],
        receipt: json["receipt"],
        attempts: json["attempts"],
        currency: json["currency"],
        offerId: json["offer_id"],
        amountDue: json["amount_due"],
        createdAt: json["created_at"],
        amountPaid: json["amount_paid"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "notes": notes?.toJson(),
        "amount": amount,
        "entity": entity,
        "status": status,
        "receipt": receipt,
        "attempts": attempts,
        "currency": currency,
        "offer_id": offerId,
        "amount_due": amountDue,
        "created_at": createdAt,
        "amount_paid": amountPaid,
      };
}

class Notes {
  final Customer? customer;
  final String? idempotencyKey;

  Notes({
    this.customer,
    this.idempotencyKey,
  });

  factory Notes.fromJson(Map<String, dynamic> json) => Notes(
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        idempotencyKey: json["idempotency_key"],
      );

  Map<String, dynamic> toJson() => {
        "customer": customer?.toJson(),
        "idempotency_key": idempotencyKey,
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
