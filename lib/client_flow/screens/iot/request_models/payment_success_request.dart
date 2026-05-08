import '../../../../../../core/network/api_constant.dart';

class PaymentStatusRequest {
  final String referenceId;

  PaymentStatusRequest({required this.referenceId});

  String get endpoint => "${APIConstants.PAYMENT_STATUS}/$referenceId";
}
