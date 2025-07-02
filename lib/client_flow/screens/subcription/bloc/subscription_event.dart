


import 'package:equatable/equatable.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/subcription/data/model/plan_req_model.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();
}


class CreateOrderEvent extends SubscriptionEvent {
  final String clientId;
  final List<PlanReqModel>? planReqModel;
  final bool? isFromFacility;
  // final String name;
  // final String email;
  // final String password;
  const CreateOrderEvent({required this.clientId ,  this.planReqModel, required this.isFromFacility });

  @override
  List<Object?> get props => [
    clientId,
    planReqModel,
    isFromFacility
    ];
}


class UserCoinsEvent extends SubscriptionEvent {
  // final CoinsModel  coinsModel;
  // final String name;
  // final String email;
  // final String password;
  const UserCoinsEvent( );

  @override
  List<Object?> get props => [
    // coinsModel
    ];
}


class FacilityStatusEvent extends SubscriptionEvent {
    final String? clientId;
    final String? plan;
  // final CoinsModel  coinsModel;
  // final String name;
  // final String email;
  // final String password;
  const FacilityStatusEvent( {this.clientId,this.plan});

  @override
  List<Object?> get props => [
    // coinsModel
    clientId,
    plan
    ];
}



class PlanEvent extends SubscriptionEvent {
    // final String clientId;
  // final CoinsModel  coinsModel;
  // final String name;
  // final String email;
  // final String password;
  const PlanEvent( );

  @override
  List<Object?> get props => [
    // coinsModel
    ];
}








