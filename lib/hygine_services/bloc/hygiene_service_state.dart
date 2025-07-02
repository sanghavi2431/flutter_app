import 'package:equatable/equatable.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/cart.dart' as cart;
import 'package:woloo_smart_hygiene/b2b_store/models/order.dart';
import 'package:woloo_smart_hygiene/hygine_services/model/hygiene_services.dart';

abstract class HygieneServiceState extends Equatable {
  const HygieneServiceState();
}

class HygieneServiceInitial extends HygieneServiceState {
  @override
  List<Object> get props => [];
}

class HygieneServiceLoading extends HygieneServiceState {
  final String message;
  const HygieneServiceLoading({required this.message});

  @override
  List<Object> get props => [message];
}

class HygieneServiceError extends HygieneServiceState {
  final String error;
  const HygieneServiceError({required this.error});

  @override
  List<Object> get props => [error];
}

class HygieneServiceSuccess extends HygieneServiceState {
  final HygieneService dashboardData;
  const HygieneServiceSuccess({required this.dashboardData});
  @override
  List<Object> get props => [dashboardData];
}

class HygieneServiceProductSuccess extends HygieneServiceState {
  final Product dashboardData;
  const HygieneServiceProductSuccess({required this.dashboardData});
  @override
  List<Object> get props => [dashboardData];
}

class HygieneServiceCartSuccess extends HygieneServiceState {
  final cart.CartModel cartData;
  const HygieneServiceCartSuccess({required this.cartData});
  @override
  List<Object> get props => [];
}

class HygieneCartLoading extends HygieneServiceState {
  final String message;
  const HygieneCartLoading({required this.message});

  @override
  List<Object> get props => [message];
}

class HygieneCartError extends HygieneServiceState {
  final String error;
  const HygieneCartError({required this.error});

  @override
  List<Object> get props => [error];
}

class ReadyToShip extends HygieneServiceState {
  final cart.AddToCartResponse shippingDetails;

  const ReadyToShip({
    required this.shippingDetails,
  });
  @override
  List<Object> get props => [shippingDetails];
}

class PaymentSuccess extends HygieneServiceState {
  final CompleteVendor completeVendor;
  const PaymentSuccess({required this.completeVendor});

  @override
  List<Object> get props => [];
}

class LetsTryState extends HygieneServiceState {
  final String orderId;
  final int totalPrice;
  const LetsTryState({
    required this.orderId,
    required this.totalPrice,
  });
  @override
  List<Object> get props => [orderId];
}
