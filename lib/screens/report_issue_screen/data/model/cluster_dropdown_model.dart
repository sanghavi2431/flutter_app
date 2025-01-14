/// cluster_id : 16
/// cluster_name : "Wipro"

class ClusterDropdownModel {
  ClusterDropdownModel({
    this.clusterId,
    this.clusterName,
  });

  ClusterDropdownModel.fromJson(dynamic json) {
    clusterId = json['cluster_id'];
    clusterName = json['cluster_name'];
  }
  int? clusterId;
  String? clusterName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cluster_id'] = clusterId;
    map['cluster_name'] = clusterName;
    return map;
  }
}
