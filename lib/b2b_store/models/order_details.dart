// To parse this JSON data, do
//
//     final orderDetails = orderDetailsFromJson(jsonString);

import 'dart:convert';

OrderDetails orderDetailsFromJson(String str) =>
    OrderDetails.fromJson(json.decode(str));

String orderDetailsToJson(OrderDetails data) => json.encode(data.toJson());

class OrderDetails {
  final List<OrderSet> orderSets;
  final dynamic count;
  final dynamic offset;
  final dynamic limit;

  OrderDetails({
    required this.orderSets,
    this.count,
    this.offset,
    this.limit,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
        orderSets: json["order_sets"] == null
            ? []
            : List<OrderSet>.from(
                json["order_sets"]!.map((x) => OrderSet.fromJson(x))),
        count: json["count"],
        offset: json["offset"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "order_sets": orderSets == null
            ? []
            : List<dynamic>.from(orderSets!.map((x) => x.toJson())),
        "count": count,
        "offset": offset,
        "limit": limit,
      };
}

class OrderSet {
  final String? id;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final String? cartId;
  final String? paymentCollectionId;
  final Cart? cart;
  final PaymentCollection? paymentCollection;
  final List<Order>? orders;
  final String? status;
  final String? paymentStatus;
  final String? fulfillmentStatus;
  final String? taxTotal;
  final String? shippingTaxTotal;
  final String? shippingTotal;
  final String? total;
  final String? subtotal;
  final String? discountTotal;
  final String? discountTaxTotal;
  final String? originalTotal;
  final String? originalTaxTotal;
  final String? itemTotal;
  final String? itemSubtotal;
  final String? itemTaxTotal;
  final String? originalItemTotal;
  final String? originalItemSubtotal;
  final String? originalItemTaxTotal;

  OrderSet({
    this.id,
    this.updatedAt,
    this.createdAt,
    this.cartId,
    this.paymentCollectionId,
    this.cart,
    this.paymentCollection,
    this.orders,
    this.status,
    this.paymentStatus,
    this.fulfillmentStatus,
    this.taxTotal,
    this.shippingTaxTotal,
    this.shippingTotal,
    this.total,
    this.subtotal,
    this.discountTotal,
    this.discountTaxTotal,
    this.originalTotal,
    this.originalTaxTotal,
    this.itemTotal,
    this.itemSubtotal,
    this.itemTaxTotal,
    this.originalItemTotal,
    this.originalItemSubtotal,
    this.originalItemTaxTotal,
  });

  factory OrderSet.fromJson(Map<String, dynamic> json) => OrderSet(
        id: json["id"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        cartId: json["cart_id"],
        paymentCollectionId: json["payment_collection_id"],
        cart: json["cart"] == null ? null : Cart.fromJson(json["cart"]),
        paymentCollection: json["payment_collection"] == null
            ? null
            : PaymentCollection.fromJson(json["payment_collection"]),
        orders: json["orders"] == null
            ? []
            : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
        status: json["status"],
        paymentStatus: json["payment_status"],
        fulfillmentStatus: json["fulfillment_status"],
        taxTotal: json["tax_total"],
        shippingTaxTotal: json["shipping_tax_total"],
        shippingTotal: json["shipping_total"],
        total: json["total"],
        subtotal: json["subtotal"],
        discountTotal: json["discount_total"],
        discountTaxTotal: json["discount_tax_total"],
        originalTotal: json["original_total"],
        originalTaxTotal: json["original_tax_total"],
        itemTotal: json["item_total"],
        itemSubtotal: json["item_subtotal"],
        itemTaxTotal: json["item_tax_total"],
        originalItemTotal: json["original_item_total"],
        originalItemSubtotal: json["original_item_subtotal"],
        originalItemTaxTotal: json["original_item_tax_total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "cart_id": cartId,
        "payment_collection_id": paymentCollectionId,
        "cart": cart?.toJson(),
        "payment_collection": paymentCollection?.toJson(),
        "orders": orders == null
            ? []
            : List<dynamic>.from(orders!.map((x) => x.toJson())),
        "status": status,
        "payment_status": paymentStatus,
        "fulfillment_status": fulfillmentStatus,
        "tax_total": taxTotal,
        "shipping_tax_total": shippingTaxTotal,
        "shipping_total": shippingTotal,
        "total": total,
        "subtotal": subtotal,
        "discount_total": discountTotal,
        "discount_tax_total": discountTaxTotal,
        "original_total": originalTotal,
        "original_tax_total": originalTaxTotal,
        "item_total": itemTotal,
        "item_subtotal": itemSubtotal,
        "item_tax_total": itemTaxTotal,
        "original_item_total": originalItemTotal,
        "original_item_subtotal": originalItemSubtotal,
        "original_item_tax_total": originalItemTaxTotal,
      };
}

class Cart {
  final String? id;
  final String? regionId;
  final String? customerId;
  final String? salesChannelId;
  final String? email;
  final String? currencyCode;
  final dynamic metadata;
  final DateTime? completedAt;
  final Address? shippingAddress;
  final Address? billingAddress;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? shippingAddressId;
  final String? billingAddressId;

  Cart({
    this.id,
    this.regionId,
    this.customerId,
    this.salesChannelId,
    this.email,
    this.currencyCode,
    this.metadata,
    this.completedAt,
    this.shippingAddress,
    this.billingAddress,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.shippingAddressId,
    this.billingAddressId,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json["id"],
        regionId: json["region_id"],
        customerId: json["customer_id"],
        salesChannelId: json["sales_channel_id"],
        email: json["email"],
        currencyCode: json["currency_code"],
        metadata: json["metadata"],
        completedAt: json["completed_at"] == null
            ? null
            : DateTime.parse(json["completed_at"]),
        shippingAddress: json["shipping_address"] == null
            ? null
            : Address.fromJson(json["shipping_address"]),
        billingAddress: json["billing_address"] == null
            ? null
            : Address.fromJson(json["billing_address"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        shippingAddressId: json["shipping_address_id"],
        billingAddressId: json["billing_address_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "region_id": regionId,
        "customer_id": customerId,
        "sales_channel_id": salesChannelId,
        "email": email,
        "currency_code": currencyCode,
        "metadata": metadata,
        "completed_at": completedAt?.toIso8601String(),
        "shipping_address": shippingAddress?.toJson(),
        "billing_address": billingAddress?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "shipping_address_id": shippingAddressId,
        "billing_address_id": billingAddressId,
      };
}

class Address {
  final String? id;
  final String? customerId;
  final dynamic company;
  final String? firstName;
  final String? lastName;
  final String? address1;
  final dynamic address2;
  final String? city;
  final String? countryCode;
  final String? province;
  final String? postalCode;
  final String? phone;
  final dynamic metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? addressName;
  final bool? isDefaultBilling;
  final bool? isDefaultShipping;

  Address({
    this.id,
    this.customerId,
    this.company,
    this.firstName,
    this.lastName,
    this.address1,
    this.address2,
    this.city,
    this.countryCode,
    this.province,
    this.postalCode,
    this.phone,
    this.metadata,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.addressName,
    this.isDefaultBilling,
    this.isDefaultShipping,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        customerId: json["customer_id"],
        company: json["company"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        address1: json["address_1"],
        address2: json["address_2"],
        city: json["city"],
        countryCode: json["country_code"],
        province: json["province"],
        postalCode: json["postal_code"],
        phone: json["phone"],
        metadata: json["metadata"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        addressName: json["address_name"],
        isDefaultBilling: json["is_default_billing"],
        isDefaultShipping: json["is_default_shipping"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "company": company,
        "first_name": firstName,
        "last_name": lastName,
        "address_1": address1,
        "address_2": address2,
        "city": city,
        "country_code": countryCode,
        "province": province,
        "postal_code": postalCode,
        "phone": phone,
        "metadata": metadata,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "address_name": addressName,
        "is_default_billing": isDefaultBilling,
        "is_default_shipping": isDefaultShipping,
      };
}

class Order {
  final String? id;
  final String? currencyCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? status;
  final dynamic total;
  final dynamic subtotal;
  final dynamic taxTotal;
  final dynamic discountTotal;
  final dynamic discountTaxTotal;
  final dynamic originalTotal;
  final dynamic originalTaxTotal;
  final dynamic itemTotal;
  final dynamic itemSubtotal;
  final dynamic itemTaxTotal;
  final String? salesChannelId;
  final dynamic originalItemTotal;
  final dynamic originalItemSubtotal;
  final dynamic originalItemTaxTotal;
  final dynamic shippingTotal;
  final dynamic shippingSubtotal;
  final dynamic shippingTaxTotal;
  final List<Item>? items;
  final List<Fulfillment>? fulfillments;
  final List<PaymentCollection>? paymentCollections;
  final String? paymentStatus;
  final String? fulfillmentStatus;

  Order({
    this.id,
    this.currencyCode,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.total,
    this.subtotal,
    this.taxTotal,
    this.discountTotal,
    this.discountTaxTotal,
    this.originalTotal,
    this.originalTaxTotal,
    this.itemTotal,
    this.itemSubtotal,
    this.itemTaxTotal,
    this.salesChannelId,
    this.originalItemTotal,
    this.originalItemSubtotal,
    this.originalItemTaxTotal,
    this.shippingTotal,
    this.shippingSubtotal,
    this.shippingTaxTotal,
    this.items,
    this.fulfillments,
    this.paymentCollections,
    this.paymentStatus,
    this.fulfillmentStatus,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        currencyCode: json["currency_code"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        status: json["status"],
        total: json["total"],
        subtotal: json["subtotal"],
        taxTotal: json["tax_total"],
        discountTotal: json["discount_total"],
        discountTaxTotal: json["discount_tax_total"],
        originalTotal: json["original_total"],
        originalTaxTotal: json["original_tax_total"],
        itemTotal: json["item_total"],
        itemSubtotal: json["item_subtotal"],
        itemTaxTotal: json["item_tax_total"],
        salesChannelId: json["sales_channel_id"],
        originalItemTotal: json["original_item_total"],
        originalItemSubtotal: json["original_item_subtotal"],
        originalItemTaxTotal: json["original_item_tax_total"],
        shippingTotal: json["shipping_total"],
        shippingSubtotal: json["shipping_subtotal"],
        shippingTaxTotal: json["shipping_tax_total"],
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
        fulfillments: json["fulfillments"] == null
            ? []
            : List<Fulfillment>.from(
                json["fulfillments"]!.map((x) => Fulfillment.fromJson(x))),
        paymentCollections: json["payment_collections"] == null
            ? []
            : List<PaymentCollection>.from(json["payment_collections"]!
                .map((x) => PaymentCollection.fromJson(x))),
        paymentStatus: json["payment_status"],
        fulfillmentStatus: json["fulfillment_status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "currency_code": currencyCode,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "status": status,
        "total": total,
        "subtotal": subtotal,
        "tax_total": taxTotal,
        "discount_total": discountTotal,
        "discount_tax_total": discountTaxTotal,
        "original_total": originalTotal,
        "original_tax_total": originalTaxTotal,
        "item_total": itemTotal,
        "item_subtotal": itemSubtotal,
        "item_tax_total": itemTaxTotal,
        "sales_channel_id": salesChannelId,
        "original_item_total": originalItemTotal,
        "original_item_subtotal": originalItemSubtotal,
        "original_item_tax_total": originalItemTaxTotal,
        "shipping_total": shippingTotal,
        "shipping_subtotal": shippingSubtotal,
        "shipping_tax_total": shippingTaxTotal,
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "fulfillments": fulfillments == null
            ? []
            : List<dynamic>.from(fulfillments!.map((x) => x.toJson())),
        "payment_collections": paymentCollections == null
            ? []
            : List<dynamic>.from(paymentCollections!.map((x) => x.toJson())),
        "payment_status": paymentStatus,
        "fulfillment_status": fulfillmentStatus,
      };
}

class Fulfillment {
  final String? id;
  final String? locationId;
  final DateTime? packedAt;
  final dynamic shippedAt;
  final dynamic markedShippedBy;
  final dynamic createdBy;
  final dynamic deliveredAt;
  final dynamic canceledAt;
  final FulfillmentData? data;
  final bool? requiresShipping;
  final PaymentSession? provider;
  final String? shippingOptionId;
  final PaymentSession? shippingOption;
  final Address? deliveryAddress;
  final dynamic metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? providerId;
  final String? deliveryAddressId;

  Fulfillment({
    this.id,
    this.locationId,
    this.packedAt,
    this.shippedAt,
    this.markedShippedBy,
    this.createdBy,
    this.deliveredAt,
    this.canceledAt,
    this.data,
    this.requiresShipping,
    this.provider,
    this.shippingOptionId,
    this.shippingOption,
    this.deliveryAddress,
    this.metadata,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.providerId,
    this.deliveryAddressId,
  });

  factory Fulfillment.fromJson(Map<String, dynamic> json) => Fulfillment(
        id: json["id"],
        locationId: json["location_id"],
        packedAt: json["packed_at"] == null
            ? null
            : DateTime.parse(json["packed_at"]),
        shippedAt: json["shipped_at"],
        markedShippedBy: json["marked_shipped_by"],
        createdBy: json["created_by"],
        deliveredAt: json["delivered_at"],
        canceledAt: json["canceled_at"],
        data: json["data"] == null
            ? null
            : FulfillmentData.fromJson(json["data"]),
        requiresShipping: json["requires_shipping"],
        provider: json["provider"] == null
            ? null
            : PaymentSession.fromJson(json["provider"]),
        shippingOptionId: json["shipping_option_id"],
        shippingOption: json["shipping_option"] == null
            ? null
            : PaymentSession.fromJson(json["shipping_option"]),
        deliveryAddress: json["delivery_address"] == null
            ? null
            : Address.fromJson(json["delivery_address"]),
        metadata: json["metadata"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        providerId: json["provider_id"],
        deliveryAddressId: json["delivery_address_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "location_id": locationId,
        "packed_at": packedAt?.toIso8601String(),
        "shipped_at": shippedAt,
        "marked_shipped_by": markedShippedBy,
        "created_by": createdBy,
        "delivered_at": deliveredAt,
        "canceled_at": canceledAt,
        "data": data?.toJson(),
        "requires_shipping": requiresShipping,
        "provider": provider?.toJson(),
        "shipping_option_id": shippingOptionId,
        "shipping_option": shippingOption?.toJson(),
        "delivery_address": deliveryAddress?.toJson(),
        "metadata": metadata,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "provider_id": providerId,
        "delivery_address_id": deliveryAddressId,
      };
}

class FulfillmentData {
  final String? shipmentId;
  final String? trackingNumber;

  FulfillmentData({
    this.shipmentId,
    this.trackingNumber,
  });

  factory FulfillmentData.fromJson(Map<String, dynamic> json) =>
      FulfillmentData(
        shipmentId: json["shipment_id"],
        trackingNumber: json["tracking_number"],
      );

  Map<String, dynamic> toJson() => {
        "shipment_id": shipmentId,
        "tracking_number": trackingNumber,
      };
}

class PaymentSession {
  final String? id;

  PaymentSession({
    this.id,
  });

  factory PaymentSession.fromJson(Map<String, dynamic> json) => PaymentSession(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

class Item {
  final String? id;
  final String? title;
  final String? subtitle;
  final String? thumbnail;
  final String? variantId;
  final String? productId;
  final String? productTitle;
  final String? productDescription;
  final String? productSubtitle;
  final dynamic productType;
  final dynamic productTypeId;
  final String? productCollection;
  final String? productHandle;
  final dynamic variantSku;
  final dynamic variantBarcode;
  final String? variantTitle;
  final dynamic variantOptionValues;
  final bool? requiresShipping;
  final bool? isGiftcard;
  final bool? isDiscountable;
  final bool? isTaxInclusive;
  final bool? isCustomPrice;
  final Metadata? metadata;
  final Raw? rawCompareAtUnitPrice;
  final Raw? rawUnitPrice;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final List<dynamic>? taxLines;
  final List<Adjustment>? adjustments;
  final dynamic compareAtUnitPrice;
  final dynamic unitPrice;
  final dynamic quantity;
  final Raw? rawQuantity;
  final Detail? detail;
  final dynamic subtotal;
  final dynamic total;
  final dynamic originalTotal;
  final dynamic discountTotal;
  final dynamic discountSubtotal;
  final dynamic discountTaxTotal;
  final dynamic taxTotal;
  final dynamic originalTaxTotal;
  final dynamic refundableTotalPerUnit;
  final dynamic refundableTotal;
  final dynamic fulfilledTotal;
  final dynamic shippedTotal;
  final dynamic returnRequestedTotal;
  final dynamic returnReceivedTotal;
  final dynamic returnDismissedTotal;
  final dynamic writeOffTotal;
  final Raw? rawSubtotal;
  final Raw? rawTotal;
  final Raw? rawOriginalTotal;
  final Raw? rawDiscountTotal;
  final Raw? rawDiscountSubtotal;
  final Raw? rawDiscountTaxTotal;
  final Raw? rawTaxTotal;
  final Raw? rawOriginalTaxTotal;
  final Raw? rawRefundableTotalPerUnit;
  final Raw? rawRefundableTotal;
  final Raw? rawFulfilledTotal;
  final Raw? rawShippedTotal;
  final Raw? rawReturnRequestedTotal;
  final Raw? rawReturnReceivedTotal;
  final Raw? rawReturnDismissedTotal;
  final Raw? rawWriteOffTotal;
  final Variant? variant;

  Item({
    this.id,
    this.title,
    this.subtitle,
    this.thumbnail,
    this.variantId,
    this.productId,
    this.productTitle,
    this.productDescription,
    this.productSubtitle,
    this.productType,
    this.productTypeId,
    this.productCollection,
    this.productHandle,
    this.variantSku,
    this.variantBarcode,
    this.variantTitle,
    this.variantOptionValues,
    this.requiresShipping,
    this.isGiftcard,
    this.isDiscountable,
    this.isTaxInclusive,
    this.isCustomPrice,
    this.metadata,
    this.rawCompareAtUnitPrice,
    this.rawUnitPrice,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.taxLines,
    this.adjustments,
    this.compareAtUnitPrice,
    this.unitPrice,
    this.quantity,
    this.rawQuantity,
    this.detail,
    this.subtotal,
    this.total,
    this.originalTotal,
    this.discountTotal,
    this.discountSubtotal,
    this.discountTaxTotal,
    this.taxTotal,
    this.originalTaxTotal,
    this.refundableTotalPerUnit,
    this.refundableTotal,
    this.fulfilledTotal,
    this.shippedTotal,
    this.returnRequestedTotal,
    this.returnReceivedTotal,
    this.returnDismissedTotal,
    this.writeOffTotal,
    this.rawSubtotal,
    this.rawTotal,
    this.rawOriginalTotal,
    this.rawDiscountTotal,
    this.rawDiscountSubtotal,
    this.rawDiscountTaxTotal,
    this.rawTaxTotal,
    this.rawOriginalTaxTotal,
    this.rawRefundableTotalPerUnit,
    this.rawRefundableTotal,
    this.rawFulfilledTotal,
    this.rawShippedTotal,
    this.rawReturnRequestedTotal,
    this.rawReturnReceivedTotal,
    this.rawReturnDismissedTotal,
    this.rawWriteOffTotal,
    this.variant,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        thumbnail: json["thumbnail"],
        variantId: json["variant_id"],
        productId: json["product_id"],
        productTitle: json["product_title"],
        productDescription: json["product_description"],
        productSubtitle: json["product_subtitle"],
        productType: json["product_type"],
        productTypeId: json["product_type_id"],
        productCollection: json["product_collection"],
        productHandle: json["product_handle"],
        variantSku: json["variant_sku"],
        variantBarcode: json["variant_barcode"],
        variantTitle: json["variant_title"],
        variantOptionValues: json["variant_option_values"],
        requiresShipping: json["requires_shipping"],
        isGiftcard: json["is_giftcard"],
        isDiscountable: json["is_discountable"],
        isTaxInclusive: json["is_tax_inclusive"],
        isCustomPrice: json["is_custom_price"],
        metadata: json["metadata"] == null
            ? null
            : Metadata.fromJson(json["metadata"]),
        rawCompareAtUnitPrice: json["raw_compare_at_unit_price"] == null
            ? null
            : Raw.fromJson(json["raw_compare_at_unit_price"]),
        rawUnitPrice: json["raw_unit_price"] == null
            ? null
            : Raw.fromJson(json["raw_unit_price"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        taxLines: json["tax_lines"] == null
            ? []
            : List<dynamic>.from(json["tax_lines"]!.map((x) => x)),
        adjustments: json["adjustments"] == null
            ? []
            : List<Adjustment>.from(
                json["adjustments"]!.map((x) => Adjustment.fromJson(x))),
        compareAtUnitPrice: json["compare_at_unit_price"],
        unitPrice: json["unit_price"],
        quantity: json["quantity"],
        rawQuantity: json["raw_quantity"] == null
            ? null
            : Raw.fromJson(json["raw_quantity"]),
        detail: json["detail"] == null ? null : Detail.fromJson(json["detail"]),
        subtotal: json["subtotal"],
        total: json["total"],
        originalTotal: json["original_total"],
        discountTotal: json["discount_total"],
        discountSubtotal: json["discount_subtotal"],
        discountTaxTotal: json["discount_tax_total"],
        taxTotal: json["tax_total"],
        originalTaxTotal: json["original_tax_total"],
        refundableTotalPerUnit: json["refundable_total_per_unit"],
        refundableTotal: json["refundable_total"],
        fulfilledTotal: json["fulfilled_total"],
        shippedTotal: json["shipped_total"],
        returnRequestedTotal: json["return_requested_total"],
        returnReceivedTotal: json["return_received_total"],
        returnDismissedTotal: json["return_dismissed_total"],
        writeOffTotal: json["write_off_total"],
        rawSubtotal: json["raw_subtotal"] == null
            ? null
            : Raw.fromJson(json["raw_subtotal"]),
        rawTotal:
            json["raw_total"] == null ? null : Raw.fromJson(json["raw_total"]),
        rawOriginalTotal: json["raw_original_total"] == null
            ? null
            : Raw.fromJson(json["raw_original_total"]),
        rawDiscountTotal: json["raw_discount_total"] == null
            ? null
            : Raw.fromJson(json["raw_discount_total"]),
        rawDiscountSubtotal: json["raw_discount_subtotal"] == null
            ? null
            : Raw.fromJson(json["raw_discount_subtotal"]),
        rawDiscountTaxTotal: json["raw_discount_tax_total"] == null
            ? null
            : Raw.fromJson(json["raw_discount_tax_total"]),
        rawTaxTotal: json["raw_tax_total"] == null
            ? null
            : Raw.fromJson(json["raw_tax_total"]),
        rawOriginalTaxTotal: json["raw_original_tax_total"] == null
            ? null
            : Raw.fromJson(json["raw_original_tax_total"]),
        rawRefundableTotalPerUnit: json["raw_refundable_total_per_unit"] == null
            ? null
            : Raw.fromJson(json["raw_refundable_total_per_unit"]),
        rawRefundableTotal: json["raw_refundable_total"] == null
            ? null
            : Raw.fromJson(json["raw_refundable_total"]),
        rawFulfilledTotal: json["raw_fulfilled_total"] == null
            ? null
            : Raw.fromJson(json["raw_fulfilled_total"]),
        rawShippedTotal: json["raw_shipped_total"] == null
            ? null
            : Raw.fromJson(json["raw_shipped_total"]),
        rawReturnRequestedTotal: json["raw_return_requested_total"] == null
            ? null
            : Raw.fromJson(json["raw_return_requested_total"]),
        rawReturnReceivedTotal: json["raw_return_received_total"] == null
            ? null
            : Raw.fromJson(json["raw_return_received_total"]),
        rawReturnDismissedTotal: json["raw_return_dismissed_total"] == null
            ? null
            : Raw.fromJson(json["raw_return_dismissed_total"]),
        rawWriteOffTotal: json["raw_write_off_total"] == null
            ? null
            : Raw.fromJson(json["raw_write_off_total"]),
        variant:
            json["variant"] == null ? null : Variant.fromJson(json["variant"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "thumbnail": thumbnail,
        "variant_id": variantId,
        "product_id": productId,
        "product_title": productTitle,
        "product_description": productDescription,
        "product_subtitle": productSubtitle,
        "product_type": productType,
        "product_type_id": productTypeId,
        "product_collection": productCollection,
        "product_handle": productHandle,
        "variant_sku": variantSku,
        "variant_barcode": variantBarcode,
        "variant_title": variantTitle,
        "variant_option_values": variantOptionValues,
        "requires_shipping": requiresShipping,
        "is_giftcard": isGiftcard,
        "is_discountable": isDiscountable,
        "is_tax_inclusive": isTaxInclusive,
        "is_custom_price": isCustomPrice,
        "metadata": metadata?.toJson(),
        "raw_compare_at_unit_price": rawCompareAtUnitPrice?.toJson(),
        "raw_unit_price": rawUnitPrice?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "tax_lines":
            taxLines == null ? [] : List<dynamic>.from(taxLines!.map((x) => x)),
        "adjustments": adjustments == null
            ? []
            : List<dynamic>.from(adjustments!.map((x) => x.toJson())),
        "compare_at_unit_price": compareAtUnitPrice,
        "unit_price": unitPrice,
        "quantity": quantity,
        "raw_quantity": rawQuantity?.toJson(),
        "detail": detail?.toJson(),
        "subtotal": subtotal,
        "total": total,
        "original_total": originalTotal,
        "discount_total": discountTotal,
        "discount_subtotal": discountSubtotal,
        "discount_tax_total": discountTaxTotal,
        "tax_total": taxTotal,
        "original_tax_total": originalTaxTotal,
        "refundable_total_per_unit": refundableTotalPerUnit,
        "refundable_total": refundableTotal,
        "fulfilled_total": fulfilledTotal,
        "shipped_total": shippedTotal,
        "return_requested_total": returnRequestedTotal,
        "return_received_total": returnReceivedTotal,
        "return_dismissed_total": returnDismissedTotal,
        "write_off_total": writeOffTotal,
        "raw_subtotal": rawSubtotal?.toJson(),
        "raw_total": rawTotal?.toJson(),
        "raw_original_total": rawOriginalTotal?.toJson(),
        "raw_discount_total": rawDiscountTotal?.toJson(),
        "raw_discount_subtotal": rawDiscountSubtotal?.toJson(),
        "raw_discount_tax_total": rawDiscountTaxTotal?.toJson(),
        "raw_tax_total": rawTaxTotal?.toJson(),
        "raw_original_tax_total": rawOriginalTaxTotal?.toJson(),
        "raw_refundable_total_per_unit": rawRefundableTotalPerUnit?.toJson(),
        "raw_refundable_total": rawRefundableTotal?.toJson(),
        "raw_fulfilled_total": rawFulfilledTotal?.toJson(),
        "raw_shipped_total": rawShippedTotal?.toJson(),
        "raw_return_requested_total": rawReturnRequestedTotal?.toJson(),
        "raw_return_received_total": rawReturnReceivedTotal?.toJson(),
        "raw_return_dismissed_total": rawReturnDismissedTotal?.toJson(),
        "raw_write_off_total": rawWriteOffTotal?.toJson(),
        "variant": variant?.toJson(),
      };
}

class Adjustment {
  final String? id;
  final dynamic description;
  final String? promotionId;
  final String? code;
  final String? providerId;
  final String? itemId;
  final Raw? rawAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final dynamic amount;
  final dynamic subtotal;
  final dynamic total;
  final Raw? rawSubtotal;
  final Raw? rawTotal;

  Adjustment({
    this.id,
    this.description,
    this.promotionId,
    this.code,
    this.providerId,
    this.itemId,
    this.rawAmount,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.amount,
    this.subtotal,
    this.total,
    this.rawSubtotal,
    this.rawTotal,
  });

  factory Adjustment.fromJson(Map<String, dynamic> json) => Adjustment(
        id: json["id"],
        description: json["description"],
        promotionId: json["promotion_id"],
        code: json["code"],
        providerId: json["provider_id"],
        itemId: json["item_id"],
        rawAmount: json["raw_amount"] == null
            ? null
            : Raw.fromJson(json["raw_amount"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        amount: json["amount"],
        subtotal: json["subtotal"],
        total: json["total"],
        rawSubtotal: json["raw_subtotal"] == null
            ? null
            : Raw.fromJson(json["raw_subtotal"]),
        rawTotal:
            json["raw_total"] == null ? null : Raw.fromJson(json["raw_total"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "promotion_id": promotionId,
        "code": code,
        "provider_id": providerId,
        "item_id": itemId,
        "raw_amount": rawAmount?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "amount": amount,
        "subtotal": subtotal,
        "total": total,
        "raw_subtotal": rawSubtotal?.toJson(),
        "raw_total": rawTotal?.toJson(),
      };
}

class Raw {
  final String? value;
  final dynamic precision;

  Raw({
    this.value,
    this.precision,
  });

  factory Raw.fromJson(Map<String, dynamic> json) => Raw(
        value: json["value"],
        precision: json["precision"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "precision": precision,
      };
}

class Detail {
  final String? id;
  final dynamic version;
  final dynamic metadata;
  final String? orderId;
  final Raw? rawUnitPrice;
  final Raw? rawCompareAtUnitPrice;
  final Raw? rawQuantity;
  final Raw? rawFulfilledQuantity;
  final Raw? rawDeliveredQuantity;
  final Raw? rawShippedQuantity;
  final Raw? rawReturnRequestedQuantity;
  final Raw? rawReturnReceivedQuantity;
  final Raw? rawReturnDismissedQuantity;
  final Raw? rawWrittenOffQuantity;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? itemId;
  final dynamic unitPrice;
  final dynamic compareAtUnitPrice;
  final dynamic quantity;
  final dynamic fulfilledQuantity;
  final dynamic deliveredQuantity;
  final dynamic shippedQuantity;
  final dynamic returnRequestedQuantity;
  final dynamic returnReceivedQuantity;
  final dynamic returnDismissedQuantity;
  final dynamic writtenOffQuantity;

  Detail({
    this.id,
    this.version,
    this.metadata,
    this.orderId,
    this.rawUnitPrice,
    this.rawCompareAtUnitPrice,
    this.rawQuantity,
    this.rawFulfilledQuantity,
    this.rawDeliveredQuantity,
    this.rawShippedQuantity,
    this.rawReturnRequestedQuantity,
    this.rawReturnReceivedQuantity,
    this.rawReturnDismissedQuantity,
    this.rawWrittenOffQuantity,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.itemId,
    this.unitPrice,
    this.compareAtUnitPrice,
    this.quantity,
    this.fulfilledQuantity,
    this.deliveredQuantity,
    this.shippedQuantity,
    this.returnRequestedQuantity,
    this.returnReceivedQuantity,
    this.returnDismissedQuantity,
    this.writtenOffQuantity,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["id"],
        version: json["version"],
        metadata: json["metadata"],
        orderId: json["order_id"],
        rawUnitPrice: json["raw_unit_price"] == null
            ? null
            : Raw.fromJson(json["raw_unit_price"]),
        rawCompareAtUnitPrice: json["raw_compare_at_unit_price"] == null
            ? null
            : Raw.fromJson(json["raw_compare_at_unit_price"]),
        rawQuantity: json["raw_quantity"] == null
            ? null
            : Raw.fromJson(json["raw_quantity"]),
        rawFulfilledQuantity: json["raw_fulfilled_quantity"] == null
            ? null
            : Raw.fromJson(json["raw_fulfilled_quantity"]),
        rawDeliveredQuantity: json["raw_delivered_quantity"] == null
            ? null
            : Raw.fromJson(json["raw_delivered_quantity"]),
        rawShippedQuantity: json["raw_shipped_quantity"] == null
            ? null
            : Raw.fromJson(json["raw_shipped_quantity"]),
        rawReturnRequestedQuantity:
            json["raw_return_requested_quantity"] == null
                ? null
                : Raw.fromJson(json["raw_return_requested_quantity"]),
        rawReturnReceivedQuantity: json["raw_return_received_quantity"] == null
            ? null
            : Raw.fromJson(json["raw_return_received_quantity"]),
        rawReturnDismissedQuantity:
            json["raw_return_dismissed_quantity"] == null
                ? null
                : Raw.fromJson(json["raw_return_dismissed_quantity"]),
        rawWrittenOffQuantity: json["raw_written_off_quantity"] == null
            ? null
            : Raw.fromJson(json["raw_written_off_quantity"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        itemId: json["item_id"],
        unitPrice: json["unit_price"],
        compareAtUnitPrice: json["compare_at_unit_price"],
        quantity: json["quantity"],
        fulfilledQuantity: json["fulfilled_quantity"],
        deliveredQuantity: json["delivered_quantity"],
        shippedQuantity: json["shipped_quantity"],
        returnRequestedQuantity: json["return_requested_quantity"],
        returnReceivedQuantity: json["return_received_quantity"],
        returnDismissedQuantity: json["return_dismissed_quantity"],
        writtenOffQuantity: json["written_off_quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "version": version,
        "metadata": metadata,
        "order_id": orderId,
        "raw_unit_price": rawUnitPrice?.toJson(),
        "raw_compare_at_unit_price": rawCompareAtUnitPrice?.toJson(),
        "raw_quantity": rawQuantity?.toJson(),
        "raw_fulfilled_quantity": rawFulfilledQuantity?.toJson(),
        "raw_delivered_quantity": rawDeliveredQuantity?.toJson(),
        "raw_shipped_quantity": rawShippedQuantity?.toJson(),
        "raw_return_requested_quantity": rawReturnRequestedQuantity?.toJson(),
        "raw_return_received_quantity": rawReturnReceivedQuantity?.toJson(),
        "raw_return_dismissed_quantity": rawReturnDismissedQuantity?.toJson(),
        "raw_written_off_quantity": rawWrittenOffQuantity?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "item_id": itemId,
        "unit_price": unitPrice,
        "compare_at_unit_price": compareAtUnitPrice,
        "quantity": quantity,
        "fulfilled_quantity": fulfilledQuantity,
        "delivered_quantity": deliveredQuantity,
        "shipped_quantity": shippedQuantity,
        "return_requested_quantity": returnRequestedQuantity,
        "return_received_quantity": returnReceivedQuantity,
        "return_dismissed_quantity": returnDismissedQuantity,
        "written_off_quantity": writtenOffQuantity,
      };
}

class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata();

  Map<String, dynamic> toJson() => {};
}

class Variant {
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
  final dynamic variantRank;
  final String? productId;
  final PaymentSession? product;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final List<Option>? options;

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
    this.product,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.options,
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
        product: json["product"] == null
            ? null
            : PaymentSession.fromJson(json["product"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        options: json["options"] == null
            ? []
            : List<Option>.from(
                json["options"]!.map((x) => Option.fromJson(x))),
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
        "options": options == null
            ? []
            : List<dynamic>.from(options!.map((x) => x.toJson())),
      };
}

class Option {
  final String? id;
  final String? value;
  final dynamic metadata;
  final String? optionId;
  final PaymentSession? option;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  Option({
    this.id,
    this.value,
    this.metadata,
    this.optionId,
    this.option,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json["id"],
        value: json["value"],
        metadata: json["metadata"],
        optionId: json["option_id"],
        option: json["option"] == null
            ? null
            : PaymentSession.fromJson(json["option"]),
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
        "value": value,
        "metadata": metadata,
        "option_id": optionId,
        "option": option?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class PaymentCollection {
  final String? id;
  final String? currencyCode;
  final dynamic completedAt;
  final String? status;
  final dynamic metadata;
  final Raw? rawAmount;
  final Raw? rawAuthorizedAmount;
  final Raw? rawCapturedAmount;
  final Raw? rawRefundedAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final List<PaymentForOrderDetails>? payments;
  final dynamic amount;
  final dynamic authorizedAmount;
  final dynamic capturedAmount;
  final dynamic refundedAmount;

  PaymentCollection({
    this.id,
    this.currencyCode,
    this.completedAt,
    this.status,
    this.metadata,
    this.rawAmount,
    this.rawAuthorizedAmount,
    this.rawCapturedAmount,
    this.rawRefundedAmount,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.payments,
    this.amount,
    this.authorizedAmount,
    this.capturedAmount,
    this.refundedAmount,
  });

  factory PaymentCollection.fromJson(Map<String, dynamic> json) =>
      PaymentCollection(
        id: json["id"],
        currencyCode: json["currency_code"],
        completedAt: json["completed_at"],
        status: json["status"],
        metadata: json["metadata"],
        rawAmount: json["raw_amount"] == null
            ? null
            : Raw.fromJson(json["raw_amount"]),
        rawAuthorizedAmount: json["raw_authorized_amount"] == null
            ? null
            : Raw.fromJson(json["raw_authorized_amount"]),
        rawCapturedAmount: json["raw_captured_amount"] == null
            ? null
            : Raw.fromJson(json["raw_captured_amount"]),
        rawRefundedAmount: json["raw_refunded_amount"] == null
            ? null
            : Raw.fromJson(json["raw_refunded_amount"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        payments: json["payments"] == null
            ? []
            : List<PaymentForOrderDetails>.from(json["payments"]!
                .map((x) => PaymentForOrderDetails.fromJson(x))),
        amount: json["amount"],
        authorizedAmount: json["authorized_amount"],
        capturedAmount: json["captured_amount"],
        refundedAmount: json["refunded_amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "currency_code": currencyCode,
        "completed_at": completedAt,
        "status": status,
        "metadata": metadata,
        "raw_amount": rawAmount?.toJson(),
        "raw_authorized_amount": rawAuthorizedAmount?.toJson(),
        "raw_captured_amount": rawCapturedAmount?.toJson(),
        "raw_refunded_amount": rawRefundedAmount?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "payments": payments == null
            ? []
            : List<dynamic>.from(payments!.map((x) => x.toJson())),
        "amount": amount,
        "authorized_amount": authorizedAmount,
        "captured_amount": capturedAmount,
        "refunded_amount": refundedAmount,
      };
}

class PaymentForOrderDetails {
  final String? id;
  final String? currencyCode;
  final String? providerId;
  final PaymentData? data;
  final dynamic metadata;
  final dynamic capturedAt;
  final dynamic canceledAt;
  final String? paymentCollectionId;
  final PaymentSession? paymentSession;
  final Raw? rawAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? paymentSessionId;
  final List<dynamic>? refunds;
  final dynamic amount;

  PaymentForOrderDetails({
    this.id,
    this.currencyCode,
    this.providerId,
    this.data,
    this.metadata,
    this.capturedAt,
    this.canceledAt,
    this.paymentCollectionId,
    this.paymentSession,
    this.rawAmount,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.paymentSessionId,
    this.refunds,
    this.amount,
  });

  factory PaymentForOrderDetails.fromJson(Map<String, dynamic> json) =>
      PaymentForOrderDetails(
        id: json["id"],
        currencyCode: json["currency_code"],
        providerId: json["provider_id"],
        data: json["data"] == null ? null : PaymentData.fromJson(json["data"]),
        metadata: json["metadata"],
        capturedAt: json["captured_at"],
        canceledAt: json["canceled_at"],
        paymentCollectionId: json["payment_collection_id"],
        paymentSession: json["payment_session"] == null
            ? null
            : PaymentSession.fromJson(json["payment_session"]),
        rawAmount: json["raw_amount"] == null
            ? null
            : Raw.fromJson(json["raw_amount"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        paymentSessionId: json["payment_session_id"],
        refunds: json["refunds"] == null
            ? []
            : List<dynamic>.from(json["refunds"]!.map((x) => x)),
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "currency_code": currencyCode,
        "provider_id": providerId,
        "data": data?.toJson(),
        "metadata": metadata,
        "captured_at": capturedAt,
        "canceled_at": canceledAt,
        "payment_collection_id": paymentCollectionId,
        "payment_session": paymentSession?.toJson(),
        "raw_amount": rawAmount?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "payment_session_id": paymentSessionId,
        "refunds":
            refunds == null ? [] : List<dynamic>.from(refunds!.map((x) => x)),
        "amount": amount,
      };
}

class PaymentData {
  final String? id;
  final Notes? notes;
  final dynamic amount;
  final String? entity;
  final String? status;
  final String? receipt;
  final dynamic attempts;
  final String? currency;
  final dynamic offerId;
  final dynamic amountDue;
  final dynamic createdAt;
  final dynamic amountPaid;

  PaymentData({
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

  factory PaymentData.fromJson(Map<String, dynamic> json) => PaymentData(
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

class Customer {
  final String? id;
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
