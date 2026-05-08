// To parse this JSON data, do
//
//     final languageModel = languageModelFromJson(jsonString);

import 'dart:convert';

LanguageModel languageModelFromJson(String str) =>
    LanguageModel.fromJson(json.decode(str));

String languageModelToJson(LanguageModel data) =>
    json.encode(data.toJson());

class LanguageModel {
  List<LanguageData>? results;
  bool? success;

  LanguageModel({
    this.results,
    this.success,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) =>
      LanguageModel(
        results: json["results"] == null
            ? null
            : List<LanguageData>.from(
                json["results"].map((x) => LanguageData.fromJson(x))),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "results": results == null
            ? null
            : List<dynamic>.from(results!.map((x) => x.toJson())),
        "success": success,
      };
}

class LanguageData {
  String? languageCode;
  String? languageNameEn;
  String? languageNameNative;

  LanguageData({
    this.languageCode,
    this.languageNameEn,
    this.languageNameNative,
  });

  factory LanguageData.fromJson(Map<String, dynamic> json) => LanguageData(
        languageCode: json["language_code"],
        languageNameEn: json["language_name_en"],
        languageNameNative: json["language_name_native"],
      );

  Map<String, dynamic> toJson() => {
        "language_code": languageCode,
        "language_name_en": languageNameEn,
        "language_name_native": languageNameNative,
      };
}

