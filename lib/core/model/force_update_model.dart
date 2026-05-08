// To parse this JSON data, do
//
//     final forceUpdate = forceUpdateFromJson(jsonString);

import 'dart:convert';

ForceUpdate forceUpdateFromJson(String str) =>
    ForceUpdate.fromJson(json.decode(str));

String forceUpdateToJson(ForceUpdate data) => json.encode(data.toJson());

class ForceUpdate {
  Results? results;
  bool? success;

  ForceUpdate({
    this.results,
    this.success,
  });

  factory ForceUpdate.fromJson(Map<String, dynamic> json) => ForceUpdate(
        results: Results.fromJson(json["results"]),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "results": results!.toJson(),
        "success": success,
      };
}

class Results {
  AppVersion? appVersion;

  Results({
    this.appVersion,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
        appVersion: AppVersion.fromJson(json["APP_VERSION"]),
      );

  Map<String, dynamic> toJson() => {
        "APP_VERSION": appVersion!.toJson(),
      };
}

class AppVersion {
  String? versionCode;
  String? forceUpdate;
  String? updateText;

  AppVersion({
    this.versionCode,
    this.forceUpdate,
    this.updateText,
  });

  factory AppVersion.fromJson(Map<String, dynamic> json) => AppVersion(
        versionCode: json["version_code"],
        forceUpdate: json["force_update"],
        updateText: json["update_text"],
      );

  Map<String, dynamic> toJson() => {
        "version_code": versionCode,
        "force_update": forceUpdate,
        "update_text": updateText,
      };
}
