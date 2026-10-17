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
  final AvgppmPeriodComparison? avgppmPeriodComparison;
  final TodayVsYesterdayAlertTrend? todayVsYesterdayAlertTrend;
  final bool? isDeviceOff;
  final List<HourlyData>? hourlydata;


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
    this.avgppmPeriodComparison,
    this.todayVsYesterdayAlertTrend,
    this.isDeviceOff,
    this.hourlydata
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
        avgppmPeriodComparison: json["avgppm_period_comparison"] == null
            ? null
            : AvgppmPeriodComparison.fromJson(json["avgppm_period_comparison"]),
        todayVsYesterdayAlertTrend:
            json["today_vs_yesterday_alert_trend"] == null
                ? null
                : TodayVsYesterdayAlertTrend.fromJson(
                    json["today_vs_yesterday_alert_trend"]),
    isDeviceOff: json["isdeviceOff"],
    hourlydata: (json['hourlydata'] as List?)
        ?.map((e) => HourlyData.fromJson(e))
        .toList(),
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
        "avgppm_period_comparison": avgppmPeriodComparison?.toJson(),
        "today_vs_yesterday_alert_trend": todayVsYesterdayAlertTrend?.toJson(),
    "isdeviceOff": isDeviceOff,
    'hourlydata': hourlydata?.map((e) => e.toJson()).toList(),
      };
}

class AlertsNotification {
  final DateTime? ppmTime;
  final String? ppmValue;
  final String? message;
  final String? condition;
  final String? dataUnit;

  AlertsNotification({
    this.ppmTime,
    this.ppmValue,
    this.message,
    this.condition,
    this.dataUnit,
  });

  factory AlertsNotification.fromJson(Map<String, dynamic> json) =>
      AlertsNotification(
        ppmTime:
            json["ppm_time"] == null ? null : DateTime.parse(json["ppm_time"]),
        ppmValue: json["ppm_value"],
        message: json["message"],
        condition: json["condition"],
        dataUnit: json["data_unit"],
      );

  Map<String, dynamic> toJson() => {
        "ppm_time": ppmTime?.toIso8601String(),
        "ppm_value": ppmValue,
        "message": message,
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
            : List<String>.from(
                json["category"]!.map((x) => x?.toString() ?? '')),
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
            : List<double>.from(json["value"]!.map(
                (x) => (x is num ? x.toDouble() : (x?.toDouble() ?? 0.0)))),
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
  final String? maxPpmValue;
  final String? maxPpmTime;

  GaugeGraphData({
    this.avgAmonia,
    this.pcdMax,
    this.ppm,
    this.condition,
    this.maxPpmValue,
    this.maxPpmTime,
  });

  factory GaugeGraphData.fromJson(Map<String, dynamic> json) => GaugeGraphData(
        avgAmonia: json["avg_amonia"],
        pcdMax: json["pcd_max"],
        ppm: json["ppm"] == null ||
                (json["ppm"] is Map && (json["ppm"] as Map).isEmpty)
            ? null
            : Ppm.fromJson(json["ppm"]),
        condition: json["condition"],
        maxPpmValue: json["ppm_max_value"],
        maxPpmTime: json["ppm_max_time"]
      );


  Map<String, dynamic> toJson() => {
        "avg_amonia": avgAmonia,
        "pcd_max": pcdMax,
        "ppm": ppm?.toJson(),
        "condition": condition,
        "ppm_max_value": maxPpmValue,
        "ppm_max_time": maxPpmTime,
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

class AvgppmPeriodComparison {
  final String? currentPpmAvg;
  final String? previousPpmAvg;
  final dynamic ppmAvgDiffPct;

  final String? currentPcdMax;
  final String? previousPcdMax;
  final dynamic pcdMaxDiffPct;

  AvgppmPeriodComparison({
    this.currentPpmAvg,
    this.previousPpmAvg,
    this.ppmAvgDiffPct,
    this.currentPcdMax,
    this.previousPcdMax,
    this.pcdMaxDiffPct,
  });

  factory AvgppmPeriodComparison.fromJson(Map<String, dynamic> json) =>
      AvgppmPeriodComparison(
        currentPpmAvg: json["current_ppm_avg"],
        previousPpmAvg: json["previous_ppm_avg"],
        ppmAvgDiffPct: json["ppm_avg_diff_pct"],
        currentPcdMax: json["current_pcd_max"],
        previousPcdMax: json["previous_pcd_max"],
        pcdMaxDiffPct: json["pcd_max_diff_pct"],
      );

  Map<String, dynamic> toJson() => {
        "current_ppm_avg": currentPpmAvg,
        "previous_ppm_avg": previousPpmAvg,
        "ppm_avg_diff_pct": ppmAvgDiffPct,
        "current_pcd_max": currentPcdMax,
        "previous_pcd_max": previousPcdMax,
        "pcd_max_diff_pct": pcdMaxDiffPct,
      };
}

class TodayVsYesterdayAlertTrend {
  final String? todayCount;
  final String? yesterdayCount;
  final dynamic percentageDifference;
  final String? alertStatus;
  final String? arrowDirection;

  TodayVsYesterdayAlertTrend({
    this.todayCount,
    this.yesterdayCount,
    this.percentageDifference,
    this.alertStatus,
    this.arrowDirection,
  });

  factory TodayVsYesterdayAlertTrend.fromJson(Map<String, dynamic> json) =>
      TodayVsYesterdayAlertTrend(
        todayCount: json["today_count"],
        yesterdayCount: json["yesterday_count"],
        percentageDifference: json["percentage_difference"],
        alertStatus: json["alert_status"],
        arrowDirection: json["arrow_direction"],
      );

  Map<String, dynamic> toJson() => {
        "today_count": todayCount,
        "yesterday_count": yesterdayCount,
        "percentage_difference": percentageDifference,
        "alert_status": alertStatus,
        "arrow_direction": arrowDirection,
      };
}

class HourlyData {
  final String? timeRange;
  final String? aqi;
  final String? usage;

  HourlyData({
    this.timeRange,
    this.aqi,
    this.usage,
  });

  factory HourlyData.fromJson(Map<String, dynamic> json) {
    return HourlyData(
      timeRange: json['time_range'],
      aqi: json['aqi'],
      usage: json['usage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time_range': timeRange,
      'aqi': aqi,
      'usage': usage,
    };
  }
}