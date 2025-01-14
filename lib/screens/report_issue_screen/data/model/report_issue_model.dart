/// message : "Issue has been successfully created."

class ReportIssueModel {
  ReportIssueModel({
    this.message,
  });

  ReportIssueModel.fromJson(dynamic json) {
    message = json['message'];
  }
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    return map;
  }
}
