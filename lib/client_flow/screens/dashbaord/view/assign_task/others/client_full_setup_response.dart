class ClientFullSetupResponse {
  final bool success;
  final String message;

  ClientFullSetupResponse({
    required this.success,
    required this.message,
  });

  factory ClientFullSetupResponse.fromJson(Map<String, dynamic> json) {
    return ClientFullSetupResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
    );
  }
}