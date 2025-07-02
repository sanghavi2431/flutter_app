import 'package:equatable/equatable.dart';

abstract class IotEvent extends Equatable {
  const IotEvent();
}

class GetIot extends IotEvent {
  final int facilityId;
  final String type;

// final int locationId;

  final String clientId;
  final int janitorId;

  const GetIot({
    required this.clientId,
    required this.janitorId,
    required this.facilityId,
    required this.type,
  });

  @override
  List<Object?> get props => [facilityId, type, clientId, janitorId];
}

class GetHostDashboardData extends IotEvent {
  final String woloo_id;

  const GetHostDashboardData({required this.woloo_id});

  @override
  List<Object?> get props => [woloo_id];
}

class GenerateSummary extends IotEvent {
  final dynamic data;
  final String type;

  const GenerateSummary({
    required this.data,
    required this.type,
  });

  @override
  List<Object?> get props => [data, type];
}
