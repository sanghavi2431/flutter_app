// To parse this JSON data, do
//
//     final coinsModel = coinsModelFromJson(jsonString);

import 'dart:convert';

CoinsModel coinsModelFromJson(String str) =>
    CoinsModel.fromJson(json.decode(str));

String coinsModelToJson(CoinsModel data) => json.encode(data.toJson());

class CoinsModel {
  dynamic results;
  bool? success;

  CoinsModel({
    this.results,
    this.success,
  });

  factory CoinsModel.fromJson(Map<String, dynamic> json) => CoinsModel(
        results: json["results"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "results": results,
        "success": success,
      };
}
