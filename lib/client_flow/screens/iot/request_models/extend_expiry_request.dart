class ExtendExpiryRequest {
  final int clientId;
  final int days;

  ExtendExpiryRequest({
    required this.clientId,
    required this.days,
  });

  Map<String, dynamic> toJson() {
    return {
      "client_id": clientId,
      "days": days,
    };
  }
}
