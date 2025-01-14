/// cluster_id : 20
/// cluster_name : "Accenture"
/// pincode : 454565
/// janitor_id : 12
/// janitor_name : "Snehal"
/// completed_task : 2
/// pending_task : 0
/// total_task : 2

// To parse this JSON data, do
//
//     final clusterModel = clusterModelFromJson(jsonString);

import 'dart:convert';

ClusterModel clusterModelFromJson(String str) => ClusterModel.fromJson(json.decode(str));

String clusterModelToJson(ClusterModel data) => json.encode(data.toJson());

class ClusterModel {
  int? clusterId;
  String? clusterName;
  dynamic pincode;
  String? pendingTasks;
  String? completedTasks;
  String? totalTasks;

  ClusterModel({
    this.clusterId,
    this.clusterName,
    this.pincode,
    this.pendingTasks,
    this.completedTasks,
    this.totalTasks,
  });

  factory ClusterModel.fromJson(Map<String, dynamic> json) => ClusterModel(
    clusterId: json["cluster_id"],
    clusterName: json["cluster_name"],
    pincode: json["pincode"],
    pendingTasks: json["pending_tasks"],
    completedTasks: json["completed_tasks"],
    totalTasks: json["total_tasks"],
  );

  Map<String, dynamic> toJson() => {
    "cluster_id": clusterId,
    "cluster_name": clusterName,
    "pincode": pincode,
    "pending_tasks": pendingTasks,
    "completed_tasks": completedTasks,
    "total_tasks": totalTasks,
  };
}

