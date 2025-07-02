// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

OrderModel orderModelFromJson(String str) => OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
    Results? results;
    bool? success;

    OrderModel({
        this.results,
        this.success,
    });

    factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        results: Results.fromJson(json["results"]),
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "results": results!.toJson(),
        "success": success,
    };
}

class Results {
    int? amount;
    int? amountDue;
    int? amountPaid;
    int? attempts;
    int? createdAt;
    String? currency;
    String? entity;
    String? id;
    List<Note>? notes;
    dynamic offerId;
    String? receipt;
    String? status;

    Results({
        this.amount,
        this.amountDue,
        this.amountPaid,
        this.attempts,
        this.createdAt,
        this.currency,
        this.entity,
        this.id,
        this.notes,
        this.offerId,
        this.receipt,
        this.status,
    });

    factory Results.fromJson(Map<String, dynamic> json) => Results(
        amount: json["amount"],
        amountDue: json["amount_due"],
        amountPaid: json["amount_paid"],
        attempts: json["attempts"],
        createdAt: json["created_at"],
        currency: json["currency"],
        entity: json["entity"],
        id: json["id"],
        notes: List<Note>.from(json["notes"].map((x) => Note.fromJson(x))),
        offerId: json["offer_id"],
        receipt: json["receipt"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "amount": amount,
        "amount_due": amountDue,
        "amount_paid": amountPaid,
        "attempts": attempts,
        "created_at": createdAt,
        "currency": currency,
        "entity": entity,
        "id": id,
        "notes": List<dynamic>.from(notes!.map((x) => x.toJson())),
        "offer_id": offerId,
        "receipt": receipt,
        "status": status,
    };
}

class Note {
    String? clientId;
    String? facilityRef;
    bool? isRenewal;
    int? itemId;
    String? itemType;
    String? planName;
    bool? startAfterCurrent;

    Note({
        this.clientId,
        this.facilityRef,
        this.isRenewal,
        this.itemId,
        this.itemType,
        this.planName,
        this.startAfterCurrent,
    });

    factory Note.fromJson(Map<String, dynamic> json) => Note(
        clientId: json["client_id"],
        facilityRef: json["facilityRef"],
        isRenewal: json["isRenewal"],
        itemId: json["item_id"],
        itemType: json["item_type"],
        planName: json["plan_name"],
        startAfterCurrent: json["startAfterCurrent"],
    );

    Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "facilityRef": facilityRef,
        "isRenewal": isRenewal,
        "item_id": itemId,
        "item_type": itemType,
        "plan_name": planName,
        "startAfterCurrent": startAfterCurrent,
    };
}
