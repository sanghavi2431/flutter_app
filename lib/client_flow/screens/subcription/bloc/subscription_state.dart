

import 'package:equatable/equatable.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/subcription/data/model/coins_model.dart';

import '../../../../core/network/failure.dart';
import '../data/model/facility_status_model.dart';
import '../data/model/order_model.dart';
import '../data/model/plan_model.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();
}

class  SubscriptionInitial extends SubscriptionState {
  @override
  List<Object> get props => [];
}

class SubscriptionLoading extends SubscriptionState {
  final String message;
  const SubscriptionLoading({required this.message});

  @override
  List<Object> get props => [];
}

class CreateOrder extends SubscriptionState {
   OrderModel orderModel;
   CreateOrder({required this.orderModel});
  @override
  List<Object> get props => [orderModel];
}

class GetUserCoins extends SubscriptionState {
   CoinsModel  coinsModel;
   GetUserCoins({required this.coinsModel});
  @override
  List<Object> get props => [coinsModel];
}


class GetFacilityStatus extends SubscriptionState {
   FacilityStatusModel facilityStatusModel;
   GetFacilityStatus({required this.facilityStatusModel});
  @override
  List<Object> get props => [facilityStatusModel];
}

class GetPlan extends SubscriptionState {
   PlanModel  planModel;
   GetPlan({required this.planModel});
  @override
  List<Object> get props => [planModel];
}



class  SubscriptionError extends SubscriptionState {
  final String error;
  const  SubscriptionError({required this.error});

  @override
  List<Object> get props => [error];
}