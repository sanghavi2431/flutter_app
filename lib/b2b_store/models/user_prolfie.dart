// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) => UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) => json.encode(data.toJson());

class UserProfileModel {
    bool? success;
    Results? results;

    UserProfileModel({
        this.success,
        this.results,
    });

    factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
        success: json["success"],
        results: Results.fromJson(json["results"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "results": results!.toJson(),
    };
}

class Results {
    int? id;
    Gender? role;
    String? baseUrl;
    dynamic name;
    dynamic email;
    dynamic rememberToken;
    int? mobile;
    dynamic city;
    int? pincode;
    dynamic address;
    dynamic avatar;
    dynamic fbId;
    dynamic gpId;
    String? refCode;
    dynamic sponsorId;
    dynamic wolooId;
    dynamic subscriptionId;
    dynamic expiryDate;
    dynamic voucherId;
    dynamic giftSubscriptionId;
    int? lat;
    int? lng;
    dynamic otp;
    Gender? status;
    dynamic settings;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? deletedAt;
    Gender? gender;
    int? isFirstSession;
    dynamic dob;
    int? isThirstReminder;
    dynamic thirstReminderHours;
    int? isBlogContentNotification;
    int? isRegister;

    Results({
        this.id,
        this.role,
        this.baseUrl,
        this.name,
        this.email,
        this.rememberToken,
        this.mobile,
        this.city,
        this.pincode,
        this.address,
        this.avatar,
        this.fbId,
        this.gpId,
        this.refCode,
        this.sponsorId,
        this.wolooId,
        this.subscriptionId,
        this.expiryDate,
        this.voucherId,
        this.giftSubscriptionId,
        this.lat,
        this.lng,
        this.otp,
        this.status,
        this.settings,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.gender,
        this.isFirstSession,
        this.dob,
        this.isThirstReminder,
        this.thirstReminderHours,
        this.isBlogContentNotification,
        this.isRegister,
    });

    factory Results.fromJson(Map<String, dynamic> json) => Results(
        id: json["id"],
        role: Gender.fromJson(json["role"]),
        baseUrl: json["base_url"],
        name: json["name"],
        email: json["email"],
        rememberToken: json["remember_token"],
        mobile: json["mobile"],
        city: json["city"],
        pincode: json["pincode"],
        address: json["address"],
        avatar: json["avatar"],
        fbId: json["fb_id"],
        gpId: json["gp_id"],
        refCode: json["ref_code"],
        sponsorId: json["sponsor_id"],
        wolooId: json["woloo_id"],
        subscriptionId: json["subscription_id"],
        expiryDate: json["expiry_date"],
        voucherId: json["voucher_id"],
        giftSubscriptionId: json["gift_subscription_id"],
        lat: json["lat"],
        lng: json["lng"],
        otp: json["otp"],
        status: Gender.fromJson(json["status"]),
        settings: json["settings"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        gender: Gender.fromJson(json["gender"]),
        isFirstSession: json["is_first_session"],
        dob: json["dob"],
        isThirstReminder: json["is_thirst_reminder"],
        thirstReminderHours: json["thirst_reminder_hours"],
        isBlogContentNotification: json["is_blog_content_notification"],
        isRegister: json["IsRegister"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "role": role!.toJson(),
        "base_url": baseUrl,
        "name": name,
        "email": email,
        "remember_token": rememberToken,
        "mobile": mobile,
        "city": city,
        "pincode": pincode,
        "address": address,
        "avatar": avatar,
        "fb_id": fbId,
        "gp_id": gpId,
        "ref_code": refCode,
        "sponsor_id": sponsorId,
        "woloo_id": wolooId,
        "subscription_id": subscriptionId,
        "expiry_date": expiryDate,
        "voucher_id": voucherId,
        "gift_subscription_id": giftSubscriptionId,
        "lat": lat,
        "lng": lng,
        "otp": otp,
        "status": status!.toJson(),
        "settings": settings,
        "created_at": "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
        "updated_at": "${updatedAt!.year.toString().padLeft(4, '0')}-${updatedAt!.month.toString().padLeft(2, '0')}-${updatedAt!.day.toString().padLeft(2, '0')}",
        "deleted_at": deletedAt,
        "gender": gender!.toJson(),
        "is_first_session": isFirstSession,
        "dob": dob,
        "is_thirst_reminder": isThirstReminder,
        "thirst_reminder_hours": thirstReminderHours,
        "is_blog_content_notification": isBlogContentNotification,
        "IsRegister": isRegister,
    };
}

class Gender {
    String? label;
    int? value;

    Gender({
        this.label,
        this.value,
    });

    factory Gender.fromJson(Map<String, dynamic> json) => Gender(
        label: json["label"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
    };
}
