// cluster_id : 16
// cluster_name : "Wipro"

class ClusterDropdownModel {
     int? clusterId;
     String? clusterName;
  ClusterDropdownModel({
    this.clusterId,
    this.clusterName,
  });

  ClusterDropdownModel.fromJson(dynamic json) {
    clusterId = json['cluster_id'];
    clusterName = json['cluster_name'];
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cluster_id'] = clusterId;
    map['cluster_name'] = clusterName;
    return map;
  }
}
