import 'package:equatable/equatable.dart';

import '../../../host/edit_host_details.dart';

abstract class IotEvent extends Equatable {
  const IotEvent();
}

class GetIot extends IotEvent {
  final int facilityId;
  final String type;

// final int locationId;

  final String clientId;
  final String janitorId;

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

class GetHostDetailsData extends IotEvent {
  final String id;
  const GetHostDetailsData({required this.id});

  @override
  List<Object?> get props => [id];
}

class UpdateHostDetailsEvent extends IotEvent {
  final UpdateHostRequest request;

  const UpdateHostDetailsEvent(this.request);

  @override
  List<Object?> get props => [request];
}


class GetReviewListEvent extends IotEvent {
  final int pageNumber;
  final int wolooId;

  const GetReviewListEvent({required this.pageNumber, required this.wolooId});

  @override
  List<Object?> get props => [pageNumber, wolooId];
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

class StartPolling extends IotEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}

