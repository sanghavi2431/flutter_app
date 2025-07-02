class WolooPointsResponse {
  final bool success;
  final WolooPointsResults results;

  WolooPointsResponse({
    required this.success,
    required this.results,
  });

  factory WolooPointsResponse.fromJson(Map<String, dynamic> json) {
    return WolooPointsResponse(
      success: json['success'] ?? false,
      results: WolooPointsResults.fromJson(json['results'] ?? {}),
    );
  }
}

class WolooPointsResults {
  final TotalCoins totalCoins;
  final int points;

  WolooPointsResults({
    required this.totalCoins,
    required this.points,
  });

  factory WolooPointsResults.fromJson(Map<String, dynamic> json) {
    return WolooPointsResults(
      totalCoins: TotalCoins.fromJson(json['totalCoins'] ?? {}),
      points: json['points'] ?? 0,
    );
  }
}

class TotalCoins {
  final int totalCoins;
  final int giftCoins;

  TotalCoins({
    required this.totalCoins,
    required this.giftCoins,
  });

  factory TotalCoins.fromJson(Map<String, dynamic> json) {
    return TotalCoins(
      totalCoins: json['total_coins'] ?? 0,
      giftCoins: json['gift_coins'] ?? 0,
    );
  }
}
