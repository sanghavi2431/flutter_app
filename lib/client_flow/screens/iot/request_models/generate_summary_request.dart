
class GenerateSummaryRequest {
  final dynamic data;
  final String type;

  GenerateSummaryRequest({
    required this.data,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      "data": data,
      "type": type,
    };
  }
}
