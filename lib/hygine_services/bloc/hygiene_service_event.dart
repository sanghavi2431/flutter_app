import 'package:equatable/equatable.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/address.dart';

abstract class HygieneServiceEvent extends Equatable {
  const HygieneServiceEvent();
}

class HygieneServiceReq extends HygieneServiceEvent {
  @override
  List<Object?> get props => [];
}

class HygieneServiceReqById extends HygieneServiceEvent {
  final String productId;
  const HygieneServiceReqById({required this.productId});
  @override
  List<Object?> get props => [];
}

class AddToCart extends HygieneServiceEvent {
  final String? variant_id;
  final int quantity;

  final String service_date;
  final String service_time;
  final String service_area;

  ///
  ///
  const AddToCart({
    required this.service_date,
    required this.service_time,
    required this.service_area,
    required this.variant_id,
    required this.quantity,
  });

  @override
  List<Object?> get props => [variant_id, quantity];
}

class Payment extends HygieneServiceEvent {
  const Payment();

  @override
  List<Object?> get props => [];
}

class ProceedToShip extends HygieneServiceEvent {
  const ProceedToShip();

  @override
  List<Object?> get props => [];
}

class PlaceOrder extends HygieneServiceEvent {
  final String? order_id;
  const PlaceOrder({required this.order_id});

  @override
  List<Object?> get props => [];
}

class RazorpayEvent extends HygieneServiceEvent {
  const RazorpayEvent();
  @override
  List<Object?> get props => [];
}

class GetCartData extends HygieneServiceEvent {
  const GetCartData();

  @override
  List<Object?> get props => [];
}

class AddRemoveItemReq extends HygieneServiceEvent {
  final String itemId;
  final int count;
  const AddRemoveItemReq({
    required this.itemId,
    required this.count,
  });

  @override
  List<Object?> get props => [itemId, count];
}

class DeleteItemReq extends HygieneServiceEvent {
  final String itemId;
  const DeleteItemReq({required this.itemId});
  @override
  List<Object?> get props => [itemId];
}
