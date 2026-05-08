class ReferralCoins {
  final bool? success;
  final Results? results;

  ReferralCoins({
    this.success,
    this.results,
  });

  factory ReferralCoins.fromJson(Map<String, dynamic> json) => ReferralCoins(
        success: json["success"],
        results:
            json["results"] == null ? null : Results.fromJson(json["results"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "results": results?.toJson(),
      };
}

class Results {
  final int? totalCoins;
  final int? totalGiftCoins;

  Results({
    this.totalCoins,
    this.totalGiftCoins,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
        totalCoins: json["totalCoins"],
        totalGiftCoins: json["totalGiftCoins"],
      );

  Map<String, dynamic> toJson() => {
        "totalCoins": totalCoins,
        "totalGiftCoins": totalGiftCoins,
      };
}
