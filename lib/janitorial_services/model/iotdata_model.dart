// To parse this JSON data, do
//
//     final dashboardData = dashboardDataFromJson(jsonString);

import 'dart:convert';

DashboardData dashboardDataFromJson(String str) =>
    DashboardData.fromJson(json.decode(str));

String dashboardDataToJson(DashboardData data) => json.encode(data.toJson());

class DashboardData {
  final Results? results;
  final bool? success;

  DashboardData({
    this.results,
    this.success,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
        results:
            json["results"] == null ? null : Results.fromJson(json["results"]),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "results": results?.toJson(),
        "success": success,
      };
}

class Results {
  final GaugeGraphData? gaugeGraphData;
  final AmmoniaLevelAcrossWashroomResult? ammoniaLevelAcrossWashroomResult;
  final List<AlertsNotification>? alertsNotification;
  final List<AmoniaTableDatum>? amoniaTableData;
  final String? ammoniaUnit;
  final RangeOfPpm? rangeOfPpm;
  final List<AvgppmTimeRange>? avgppmTimeRange;
  final List<UsageReportQuery>? usageReportQuery;
  final Summary? summary;
  final bool? isIotDeviceConfigured;

  Results({
    this.gaugeGraphData,
    this.ammoniaLevelAcrossWashroomResult,
    this.alertsNotification,
    this.amoniaTableData,
    this.ammoniaUnit,
    this.rangeOfPpm,
    this.avgppmTimeRange,
    this.usageReportQuery,
    this.summary,
    this.isIotDeviceConfigured,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
        gaugeGraphData: json["gauge_graph_data"] == null
            ? null
            : GaugeGraphData.fromJson(json["gauge_graph_data"]),
        ammoniaLevelAcrossWashroomResult:
            json["ammonia_level_across_washroom_result"] == null
                ? null
                : AmmoniaLevelAcrossWashroomResult.fromJson(
                    json["ammonia_level_across_washroom_result"]),
        alertsNotification: json["alerts_notification"] == null
            ? []
            : List<AlertsNotification>.from(json["alerts_notification"]!
                .map((x) => AlertsNotification.fromJson(x))),
        amoniaTableData: json["amonia_table_data"] == null
            ? []
            : List<AmoniaTableDatum>.from(json["amonia_table_data"]!
                .map((x) => AmoniaTableDatum.fromJson(x))),
        ammoniaUnit: json["ammonia_unit"],
        rangeOfPpm: json["range_of_ppm"] == null
            ? null
            : RangeOfPpm.fromJson(json["range_of_ppm"]),
        avgppmTimeRange: json["avgppm_time_range"] == null
            ? []
            : List<AvgppmTimeRange>.from(json["avgppm_time_range"]!
                .map((x) => AvgppmTimeRange.fromJson(x))),
        usageReportQuery: json["usageReportQuery"] == null
            ? []
            : List<UsageReportQuery>.from(json["usageReportQuery"]!
                .map((x) => UsageReportQuery.fromJson(x))),
        summary:
            json["summary"] == null ? null : Summary.fromJson(json["summary"]),
        isIotDeviceConfigured: json["isIotDeviceConfigured"],
      );

  Map<String, dynamic> toJson() => {
        "gauge_graph_data": gaugeGraphData?.toJson(),
        "ammonia_level_across_washroom_result":
            ammoniaLevelAcrossWashroomResult?.toJson(),
        "alerts_notification": alertsNotification == null
            ? []
            : List<dynamic>.from(alertsNotification!.map((x) => x.toJson())),
        "amonia_table_data": amoniaTableData == null
            ? []
            : List<dynamic>.from(amoniaTableData!.map((x) => x.toJson())),
        "ammonia_unit": ammoniaUnit,
        "range_of_ppm": rangeOfPpm?.toJson(),
        "avgppm_time_range": avgppmTimeRange == null
            ? []
            : List<dynamic>.from(avgppmTimeRange!.map((x) => x.toJson())),
        "usageReportQuery": usageReportQuery == null
            ? []
            : List<dynamic>.from(usageReportQuery!.map((x) => x.toJson())),
        "summary": summary?.toJson(),
        "isIotDeviceConfigured": isIotDeviceConfigured,
      };
}

class AlertsNotification {
  final DateTime? ppmTime;
  final String? condition;
  final String? dataUnit;

  AlertsNotification({
    this.ppmTime,
    this.condition,
    this.dataUnit,
  });

  factory AlertsNotification.fromJson(Map<String, dynamic> json) =>
      AlertsNotification(
        ppmTime:
            json["ppm_time"] == null ? null : DateTime.parse(json["ppm_time"]),
        condition: json["condition"],
        dataUnit: json["data_unit"],
      );

  Map<String, dynamic> toJson() => {
        "ppm_time": ppmTime?.toIso8601String(),
        "condition": condition,
        "data_unit": dataUnit,
      };
}

class AmmoniaLevelAcrossWashroomResult {
  final DistinctDataModified? distinctDataModified;
  final DistinctDataModified? distinctPeopleDataModified;
  final String? distinctPeopleDataUnit;

  AmmoniaLevelAcrossWashroomResult({
    this.distinctDataModified,
    this.distinctPeopleDataModified,
    this.distinctPeopleDataUnit,
  });

  factory AmmoniaLevelAcrossWashroomResult.fromJson(
          Map<String, dynamic> json) =>
      AmmoniaLevelAcrossWashroomResult(
        distinctDataModified: json["distinct_data_modified"] == null
            ? null
            : DistinctDataModified.fromJson(json["distinct_data_modified"]),
        distinctPeopleDataModified:
            json["distinct_people_data_modified"] == null
                ? null
                : DistinctDataModified.fromJson(
                    json["distinct_people_data_modified"]),
        distinctPeopleDataUnit: json["distinct_people_data_unit"],
      );

  Map<String, dynamic> toJson() => {
        "distinct_data_modified": distinctDataModified?.toJson(),
        "distinct_people_data_modified": distinctPeopleDataModified?.toJson(),
        "distinct_people_data_unit": distinctPeopleDataUnit,
      };
}

class DistinctDataModified {
  final List<Datum>? data;
  final List<String>? category;

  DistinctDataModified({
    this.data,
    this.category,
  });

  factory DistinctDataModified.fromJson(Map<String, dynamic> json) =>
      DistinctDataModified(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        category: json["category"] == null
            ? []
            : List<String>.from(json["category"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "category":
            category == null ? [] : List<dynamic>.from(category!.map((x) => x)),
      };
}

class Datum {
  final String? color;
  final dynamic y;

  Datum({
    this.color,
    this.y,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        color: json["color"],
        y: json["y"],
      );

  Map<String, dynamic> toJson() => {
        "color": color,
        "y": y,
      };
}

class AmoniaTableDatum {
  final String? pcdMax;
  final String? ppmAvg;
  final String? heading;
  final dynamic ppmDiff;
  final List<double>? value;

  AmoniaTableDatum({
    this.pcdMax,
    this.ppmAvg,
    this.heading,
    this.ppmDiff,
    this.value,
  });

  factory AmoniaTableDatum.fromJson(Map<String, dynamic> json) =>
      AmoniaTableDatum(
        pcdMax: json["pcd_max"],
        ppmAvg: json["ppm_avg"],
        heading: json["heading"],
        ppmDiff: json["ppm_diff"],
        value: json["value"] == null
            ? []
            : List<double>.from(json["value"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "pcd_max": pcdMax,
        "ppm_avg": ppmAvg,
        "heading": heading,
        "ppm_diff": ppmDiff,
        "value": value == null ? [] : List<dynamic>.from(value!.map((x) => x)),
      };
}

class AvgppmTimeRange {
  final String? timeRange;
  final String? avgPpmAvg;
  final String? avgPpmMax;
  final String? avgPcdMax;
  final String? avgPchMax;

  AvgppmTimeRange({
    this.timeRange,
    this.avgPpmAvg,
    this.avgPpmMax,
    this.avgPcdMax,
    this.avgPchMax,
  });

  factory AvgppmTimeRange.fromJson(Map<String, dynamic> json) =>
      AvgppmTimeRange(
        timeRange: json["time_range"],
        avgPpmAvg: json["avg_ppm_avg"],
        avgPpmMax: json["avg_ppm_max"],
        avgPcdMax: json["avg_pcd_max"],
        avgPchMax: json["avg_pch_max"],
      );

  Map<String, dynamic> toJson() => {
        "time_range": timeRange,
        "avg_ppm_avg": avgPpmAvg,
        "avg_ppm_max": avgPpmMax,
        "avg_pcd_max": avgPcdMax,
        "avg_pch_max": avgPchMax,
      };
}

class GaugeGraphData {
  final String? avgAmonia;
  final String? pcdMax;
  final Ppm? ppm;
  final String? condition;

  GaugeGraphData({
    this.avgAmonia,
    this.pcdMax,
    this.ppm,
    this.condition,
  });

  factory GaugeGraphData.fromJson(Map<String, dynamic> json) => GaugeGraphData(
        avgAmonia: json["avg_amonia"],
        pcdMax: json["pcd_max"],
        ppm: json["ppm"] == null ? null : Ppm.fromJson(json["ppm"]),
        condition: json["condition"],
      );

  Map<String, dynamic> toJson() => {
        "avg_amonia": avgAmonia,
        "pcd_max": pcdMax,
        "ppm": ppm?.toJson(),
        "condition": condition,
      };
}

class Ppm {
  Ppm();

  factory Ppm.fromJson(Map<String, dynamic> json) => Ppm();

  Map<String, dynamic> toJson() => {};
}

class RangeOfPpm {
  final String? unhealthyMax;
  final String? unhealthyMin;
  final String? healthyMin;
  final String? healthyMax;
  final String? moderateMax;
  final String? moderateMin;

  RangeOfPpm({
    this.unhealthyMax,
    this.unhealthyMin,
    this.healthyMin,
    this.healthyMax,
    this.moderateMax,
    this.moderateMin,
  });

  factory RangeOfPpm.fromJson(Map<String, dynamic> json) => RangeOfPpm(
        unhealthyMax: json["unhealthy_max"],
        unhealthyMin: json["unhealthy_min"],
        healthyMin: json["healthy_min"],
        healthyMax: json["healthy_max"],
        moderateMax: json["moderate_max"],
        moderateMin: json["moderate_min"],
      );

  Map<String, dynamic> toJson() => {
        "unhealthy_max": unhealthyMax,
        "unhealthy_min": unhealthyMin,
        "healthy_min": healthyMin,
        "healthy_max": healthyMax,
        "moderate_max": moderateMax,
        "moderate_min": moderateMin,
      };
}

class Summary {
  final String? alertsNotificationSummary;
  final String? avgppmOverLocation;
  final String? avgppmTimeRangeInsights;

  Summary({
    this.alertsNotificationSummary,
    this.avgppmOverLocation,
    this.avgppmTimeRangeInsights,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        alertsNotificationSummary: json["alerts_notification_summary"],
        avgppmOverLocation: json["avgppm_over_location"],
        avgppmTimeRangeInsights: json["avgppm_time_range_insights"],
      );

  Map<String, dynamic> toJson() => {
        "alerts_notification_summary": alertsNotificationSummary,
        "avgppm_over_location": avgppmOverLocation,
        "avgppm_time_range_insights": avgppmTimeRangeInsights,
      };
}

class UsageReportQuery {
  final String? dayName;
  final String? dayInitial;
  final String? avgPcdMax;

  UsageReportQuery({
    this.dayName,
    this.dayInitial,
    this.avgPcdMax,
  });

  factory UsageReportQuery.fromJson(Map<String, dynamic> json) =>
      UsageReportQuery(
        dayName: json["day_name"],
        dayInitial: json["day_initial"],
        avgPcdMax: json["avg_pcd_max"],
      );

  Map<String, dynamic> toJson() => {
        "day_name": dayName,
        "day_initial": dayInitial,
        "avg_pcd_max": avgPcdMax,
      };
}
