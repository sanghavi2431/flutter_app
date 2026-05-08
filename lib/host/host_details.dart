import 'dart:convert';

HostDetails hostDetailsFromJson(String str) =>
    HostDetails.fromJson(json.decode(str));

String hostDetailsToJson(HostDetails data) => json.encode(data.toJson());

class HostDetails {
  bool? success;
  ResultsHostDetails? results;

  HostDetails({
    this.success,
    this.results,
  });

  factory HostDetails.fromJson(Map<String, dynamic> json) => HostDetails(
    success: json["success"],
    results: json["results"] == null
        ? null
        : ResultsHostDetails.fromJson(json["results"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "results": results?.toJson(),
  };
}

class ResultsHostDetails {
  int? id;
  String? code;
  String? mobile;
  String? email;
  String? name;
  String? title;
  List<String>? image;
  String? openingHours;
  String? address;
  String? city;
  String? lat;
  String? lng;
  int? userId;
  String? description;
  int? isNew;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? pincode;
  dynamic recommendedBy;
  dynamic recommendedMobile;
  int? rating;
  String? baseUrl;

  IsCleanAndHygiene? status;
  IsCleanAndHygiene? restaurant;
  IsCleanAndHygiene? isSafeSpace;
  IsCleanAndHygiene? isCovidFree;
  IsCleanAndHygiene? isCleanAndHygiene;
  IsCleanAndHygiene? isSanitaryPadsAvailable;
  IsCleanAndHygiene? isMakeupRoomAvailable;
  IsCleanAndHygiene? isCoffeeAvailable;
  IsCleanAndHygiene? isSanitizerAvailable;
  IsCleanAndHygiene? isFeedingRoom;
  IsCleanAndHygiene? isWheelchairAccessible;
  IsCleanAndHygiene? isWashroom;
  IsCleanAndHygiene? isPremium;
  IsCleanAndHygiene? isFranchise;
  IsCleanAndHygiene? segregated;

  String? hostOwner;
  HostDashboardData? hostDashboardData;
  int? hostDashboardTotalCoins;
  dynamic planId;
  DateTime? expiryDate;
  int? clientCoins;

  ResultsHostDetails({
    this.id,
    this.code,
    this.mobile,
    this.email,
    this.name,
    this.title,
    this.image,
    this.openingHours,
    this.address,
    this.city,
    this.lat,
    this.lng,
    this.userId,
    this.description,
    this.isNew,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.pincode,
    this.recommendedBy,
    this.recommendedMobile,
    this.rating,
    this.baseUrl,
    this.status,
    this.restaurant,
    this.isSafeSpace,
    this.isCovidFree,
    this.isCleanAndHygiene,
    this.isSanitaryPadsAvailable,
    this.isMakeupRoomAvailable,
    this.isCoffeeAvailable,
    this.isSanitizerAvailable,
    this.isFeedingRoom,
    this.isWheelchairAccessible,
    this.isWashroom,
    this.isPremium,
    this.isFranchise,
    this.segregated,
    this.hostOwner,
    this.hostDashboardData,
    this.hostDashboardTotalCoins,
    this.planId,
    this.expiryDate,
    this.clientCoins,
  });

  factory ResultsHostDetails.fromJson(Map<String, dynamic> json) =>
      ResultsHostDetails(
        id: json["id"],
        code: json["code"],
        mobile: json["mobile"],
        email: json["email"],
        name: json["name"],
        title: json["title"]?.toString(),
        image:
        (json["image"] as List?)?.map((e) => e.toString()).toList() ?? [],
        openingHours: json["opening_hours"]?.toString(),
        address: json["address"],
        city: json["city"],
        lat: json["lat"]?.toString(),
        lng: json["lng"]?.toString(),
        userId: json["user_id"],
        description: json["description"],
        isNew: json["is_new"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        pincode: json["pincode"],
        recommendedBy: json["recommended_by"],
        recommendedMobile: json["recommended_mobile"],
        rating: json["rating"],
        baseUrl: json["base_url"],
        status: json["status"] == null
            ? null
            : IsCleanAndHygiene.fromJson(json["status"]),
        restaurant: json["restaurant"] == null
            ? null
            : IsCleanAndHygiene.fromJson(json["restaurant"]),
        isSafeSpace: json["is_safe_space"] == null
            ? null
            : IsCleanAndHygiene.fromJson(json["is_safe_space"]),
        isCovidFree: json["is_covid_free"] == null
            ? null
            : IsCleanAndHygiene.fromJson(json["is_covid_free"]),
        isCleanAndHygiene: json["is_clean_and_hygiene"] == null
            ? null
            : IsCleanAndHygiene.fromJson(json["is_clean_and_hygiene"]),
        isSanitaryPadsAvailable:
        json["is_sanitary_pads_available"] == null
            ? null
            : IsCleanAndHygiene.fromJson(
            json["is_sanitary_pads_available"]),
        isMakeupRoomAvailable:
        json["is_makeup_room_available"] == null
            ? null
            : IsCleanAndHygiene.fromJson(
            json["is_makeup_room_available"]),
        isCoffeeAvailable: json["is_coffee_available"] == null
            ? null
            : IsCleanAndHygiene.fromJson(json["is_coffee_available"]),
        isSanitizerAvailable: json["is_sanitizer_available"] == null
            ? null
            : IsCleanAndHygiene.fromJson(json["is_sanitizer_available"]),
        isFeedingRoom: json["is_feeding_room"] == null
            ? null
            : IsCleanAndHygiene.fromJson(json["is_feeding_room"]),
        isWheelchairAccessible:
        json["is_wheelchair_accessible"] == null
            ? null
            : IsCleanAndHygiene.fromJson(
            json["is_wheelchair_accessible"]),
        isWashroom: json["is_washroom"] == null
            ? null
            : IsCleanAndHygiene.fromJson(json["is_washroom"]),
        isPremium: json["is_premium"] == null
            ? null
            : IsCleanAndHygiene.fromJson(json["is_premium"]),
        isFranchise: json["is_franchise"] == null
            ? null
            : IsCleanAndHygiene.fromJson(json["is_franchise"]),
        segregated: json["segregated"] == null
            ? null
            : IsCleanAndHygiene.fromJson(json["segregated"]),
        hostOwner: json["host_owner"],
        hostDashboardData: json["hostDashboardData"] == null
            ? null
            : HostDashboardData.fromJson(json["hostDashboardData"]),
        hostDashboardTotalCoins: json["HostDashboardTotalCoins"],
        planId: json["plan_id"],
        expiryDate: json["expiry_date"] == null
            ? null
            : DateTime.parse(json["expiry_date"]),
        clientCoins: json["clientCoins"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "mobile": mobile,
    "email": email,
    "name": name,
    "title": title,
    "image": image ?? [],
    "opening_hours": openingHours,
    "address": address,
    "city": city,
    "lat": lat,
    "lng": lng,
    "user_id": userId,
    "description": description,
    "is_new": isNew,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "pincode": pincode,
    "recommended_by": recommendedBy,
    "recommended_mobile": recommendedMobile,
    "rating": rating,
    "base_url": baseUrl,
    "status": status?.toJson(),
    "restaurant": restaurant?.toJson(),
    "is_safe_space": isSafeSpace?.toJson(),
    "is_covid_free": isCovidFree?.toJson(),
    "is_clean_and_hygiene": isCleanAndHygiene?.toJson(),
    "is_sanitary_pads_available":
    isSanitaryPadsAvailable?.toJson(),
    "is_makeup_room_available":
    isMakeupRoomAvailable?.toJson(),
    "is_coffee_available": isCoffeeAvailable?.toJson(),
    "is_sanitizer_available": isSanitizerAvailable?.toJson(),
    "is_feeding_room": isFeedingRoom?.toJson(),
    "is_wheelchair_accessible":
    isWheelchairAccessible?.toJson(),
    "is_washroom": isWashroom?.toJson(),
    "is_premium": isPremium?.toJson(),
    "is_franchise": isFranchise?.toJson(),
    "segregated": segregated?.toJson(),
    "host_owner": hostOwner,
    "hostDashboardData": hostDashboardData?.toJson(),
    "HostDashboardTotalCoins": hostDashboardTotalCoins,
    "plan_id": planId,
    "expiry_date": expiryDate?.toIso8601String(),
    "clientCoins": clientCoins,
  };
}

class HostDashboardData {
  String? wahScore;
  String? wahScoreImage;
  String? wahScoreColour;
  WalkInsLastHr? walkInsLast1Hr;
  WalkInsLastHr? walkInsLast3Hr;
  WalkInsLastHr? walkInsLast6Hr;

  HostDashboardData({
    this.wahScore,
    this.wahScoreImage,
    this.wahScoreColour,
    this.walkInsLast1Hr,
    this.walkInsLast3Hr,
    this.walkInsLast6Hr,
  });

  factory HostDashboardData.fromJson(Map<String, dynamic> json) =>
      HostDashboardData(
        wahScore: json["wah_score"],
        wahScoreImage: json["wah_score_image"],
        wahScoreColour: json["wah_score_colour"],
        walkInsLast1Hr: json["walk_ins_last_1Hr"] == null
            ? null
            : WalkInsLastHr.fromJson(json["walk_ins_last_1Hr"]),
        walkInsLast3Hr: json["walk_ins_last_3Hr"] == null
            ? null
            : WalkInsLastHr.fromJson(json["walk_ins_last_3Hr"]),
        walkInsLast6Hr: json["walk_ins_last_6Hr"] == null
            ? null
            : WalkInsLastHr.fromJson(json["walk_ins_last_6Hr"]),
      );

  Map<String, dynamic> toJson() => {
    "wah_score": wahScore,
    "wah_score_image": wahScoreImage,
    "wah_score_colour": wahScoreColour,
    "walk_ins_last_1Hr": walkInsLast1Hr?.toJson(),
    "walk_ins_last_3Hr": walkInsLast3Hr?.toJson(),
    "walk_ins_last_6Hr": walkInsLast6Hr?.toJson(),
  };
}

class WalkInsLastHr {
  int? currentCount;
  int? previousCount;
  int? percentageChange;

  WalkInsLastHr({
    this.currentCount,
    this.previousCount,
    this.percentageChange,
  });

  factory WalkInsLastHr.fromJson(Map<String, dynamic> json) =>
      WalkInsLastHr(
        currentCount: json["currentCount"],
        previousCount: json["previousCount"],
        percentageChange: json["percentageChange"],
      );

  Map<String, dynamic> toJson() => {
    "currentCount": currentCount,
    "previousCount": previousCount,
    "percentageChange": percentageChange,
  };
}

class IsCleanAndHygiene {
  String? label;
  int? value;

  IsCleanAndHygiene({
    this.label,
    this.value,
  });

  factory IsCleanAndHygiene.fromJson(Map<String, dynamic> json) =>
      IsCleanAndHygiene(
        label: json["label"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
    "label": label,
    "value": value,
  };
}

class Restaurant {
  String? label;
  String? value;

  Restaurant({
    this.label,
    this.value,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      Restaurant(
        label: json["label"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
    "label": label,
    "value": value,
  };
}

class HostUpdateResponse {
  bool? success;
  String? message;

  HostUpdateResponse({
    this.success,
    this.message,
  });

  factory HostUpdateResponse.fromJson(Map<String, dynamic> json) =>
      HostUpdateResponse(
        success: json["success"],
        message: json["results"]?["MESSAGE"],
      );
}
