

// To parse this JSON data, do
//
//     final coinsModel = coinsModelFromJson(jsonString);

import 'dart:convert';

CoinsModel coinsModelFromJson(String str) => CoinsModel.fromJson(json.decode(str));

String coinsModelToJson(CoinsModel data) => json.encode(data.toJson());

class CoinsModel {
    bool? success;
    Results? results;

    CoinsModel({
         this.success,
         this.results,
    });

    factory CoinsModel.fromJson(Map<String, dynamic> json) => CoinsModel(
        success: json["success"],
        results: Results.fromJson(json["results"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "results": results!.toJson(),
    };
}

class Results {
    int? totalCoins;
    int? totalGiftCoins;

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
