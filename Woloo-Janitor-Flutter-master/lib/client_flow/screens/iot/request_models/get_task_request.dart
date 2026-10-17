class GetTaskRequest {
  final String category;
  final String clientId;

  GetTaskRequest({
    required this.category,
    required this.clientId,
  });

  Map<String, dynamic> toJson() {
    return {
      "category": category,
      "client_id": clientId,
    };
  }
}
