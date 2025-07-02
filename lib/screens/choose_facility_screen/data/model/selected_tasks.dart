// allocation_id : 94
// data : [{"task_id":1,"task_name":"task_1","status":1}]

class SelectTaskModel {
  SelectTaskModel({
    this.data,
  });

  SelectTaskModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(SelectedData.fromJson(v));
      });
    }
  }
  List<SelectedData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class SelectedData {
  SelectedData({
    this.allocationId,
  });

  SelectedData.fromJson(dynamic json) {
    allocationId = json['allocation_id'];
  }
  String? allocationId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['allocation_id'] = allocationId;

    return map;
  }
}
