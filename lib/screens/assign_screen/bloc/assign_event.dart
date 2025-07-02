import 'dart:math';

import 'package:equatable/equatable.dart';

import '../../../core/network/failure.dart';

abstract class AssignEvent extends Equatable {
  const AssignEvent();
}



class GetJanitorTask extends AssignEvent {
   final int? id;
  const GetJanitorTask({ required this.id});

  @override
  List<Object?> get props => [Random().nextInt(100)];
}
 

class GetJanitorList extends AssignEvent {
    final int facilityId;
  const GetJanitorList({required this.facilityId});

  @override
  List<Object?> get props => [Random().nextInt(100)];
}


class AssignTask extends AssignEvent {
  final List<String> facilityId;
  final String startTime;
  final String endTime;
  final bool isAssing;
  final int janitorId;
  final String status;
  const AssignTask({required this.facilityId , required this.startTime, required this.endTime,
     required this.isAssing ,required this.janitorId, required this.status
  });


  @override
  List<Object?> get props => [Random().nextInt(100)];
}
 


class JanitorLoadingEvent extends AssignEvent {
  const JanitorLoadingEvent();

  @override
  List<Object?> get props => [];
} 

 
class JanitorErrorEvent extends AssignEvent {
  final Failure error;
  const JanitorErrorEvent({required this.error});

  @override
  List<Object?> get props => [];
} 
