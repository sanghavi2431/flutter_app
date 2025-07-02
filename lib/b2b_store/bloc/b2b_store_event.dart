import 'package:equatable/equatable.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/address.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/product_collections.dart';

abstract class B2BStoreEvent extends Equatable {
  const B2BStoreEvent();
}

class StoreCustomersReq extends B2BStoreEvent {
  final String email;
  final String pass;

  const StoreCustomersReq({
    required this.email,
    required this.pass,
  });

  @override
  List<Object?> get props => [email, pass];
}

class StoreCustomerLoginReq extends B2BStoreEvent {
  String? email;
  String? pass;
  bool? isfromlogin;
  StoreCustomerLoginReq({this.email, this.pass, this.isfromlogin});

  @override
  List<Object?> get props => [email, pass];
}

class Refresh extends B2BStoreEvent {
  final String? id;
  final String slug;
  const Refresh({this.id, required this.slug});

  @override
  List<Object?> get props => [id, slug];
}

// class RefreshById extends B2BStoreEvent {
//   final String id;
//   const RefreshById({required this.id});

//   @override
//   List<Object?> get props => [id];
// }

class AddRemoveItemReq extends B2BStoreEvent {
  final String itemId;
  final int count;
  const AddRemoveItemReq({
    required this.itemId,
    required this.count,
  });

  @override
  List<Object?> get props => [itemId, count];
}

class DeleteItemReq extends B2BStoreEvent {
  final String itemId;
  const DeleteItemReq({required this.itemId});
  @override
  List<Object?> get props => [itemId];
}

class GetIot extends B2BStoreEvent {
  final String deviceId;
  final String type;

  const GetIot({
    required this.deviceId,
    required this.type,
  });

  @override
  List<Object?> get props => [deviceId, type];
}

class GetHostDashboardData extends B2BStoreEvent {
  final String woloo_id;

  const GetHostDashboardData({required this.woloo_id});

  @override
  List<Object?> get props => [woloo_id];
}

class AddressReq extends B2BStoreEvent {
  // final AddressReqBody addressReqBody;
  final String? first_name;
  final String? last_name;
  final String? address_1;
  final String? city;
  final String? phone_number;
  final String? pincode;
  final String? province;
  final String? address_name;

  const AddressReq(
      {required this.first_name,
      required this.last_name,
      required this.address_1,
      required this.city,
      required this.phone_number,
      required this.pincode,
      required this.province,
      required this.address_name});

  @override
  List<Object?> get props => [
        first_name,
        last_name,
        address_1,
        city,
        phone_number,
        pincode,
        province,
        address_name
      ];
}

class UpdateAddressReq extends B2BStoreEvent {
  final String addressId;
  final AddressReqBody addressReqBody;

  const UpdateAddressReq(
      {required this.addressId, required this.addressReqBody});

  @override
  List<Object?> get props => [addressId, addressReqBody];
}

class GetAddress extends B2BStoreEvent {
  const GetAddress();

  @override
  List<Object?> get props => [];
}

class SelectAddress extends B2BStoreEvent {
  const SelectAddress(this.addresses);
  final Addresses addresses;
  @override
  List<Object?> get props => [addresses];
}

class DeleteAddress extends B2BStoreEvent {
  const DeleteAddress({required this.addressId});
  final String addressId;
  @override
  List<Object?> get props => [addressId];
}

class GetCartData extends B2BStoreEvent {
  const GetCartData();

  @override
  List<Object?> get props => [];
}

class Payment extends B2BStoreEvent {
  const Payment();

  @override
  List<Object?> get props => [];
}

class ProceedToShip extends B2BStoreEvent {
  const ProceedToShip();

  @override
  List<Object?> get props => [];
}

class PlaceOrder extends B2BStoreEvent {
  final String? order_id;
  const PlaceOrder({required this.order_id});

  @override
  List<Object?> get props => [];
}

class LetsTry extends B2BStoreEvent {
  const LetsTry();
  @override
  List<Object?> get props => [];
}

class AddRemoveId extends B2BStoreEvent {
  const AddRemoveId();
  @override
  List<Object?> get props => [];
}

class AddToCart extends B2BStoreEvent {
  final String? variant_id;
  final int quantity;

  const AddToCart({
    required this.variant_id,
    required this.quantity,
  });

  @override
  List<Object?> get props => [variant_id, quantity];
}

// class

class OrderDetailsEvent extends B2BStoreEvent {
  const OrderDetailsEvent();
  @override
  List<Object?> get props => [];
}

class WishlistEvent extends B2BStoreEvent {
  const WishlistEvent();
  @override
  List<Object?> get props => [];
}

class AddToWishList extends B2BStoreEvent {
  final String variantId;

  const AddToWishList({required this.variantId});

  @override
  List<Object?> get props => [variantId];
}

class RemoveWishList extends B2BStoreEvent {
  final String itemId;

  const RemoveWishList({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

class ReviewEvent extends B2BStoreEvent {
  final String product_id;
  final int rating;
  final String comment;
  final String line_item_id;
  const ReviewEvent(
      {required this.product_id,
      required this.rating,
      required this.comment,
      required this.line_item_id});
  @override
  List<Object?> get props => [product_id, rating, comment, line_item_id];
}

class GetOrderReview extends B2BStoreEvent {
  final String productId;

  const GetOrderReview({required this.productId});

  @override
  List<Object?> get props => [
        productId,
      ];
}

class RestockSubscriptionsEvent extends B2BStoreEvent {
  final String phoneNumber;
  final String variantId;

  const RestockSubscriptionsEvent({
    required this.phoneNumber,
    required this.variantId,
  });

  @override
  List<Object?> get props => [phoneNumber, variantId];
}

class ApplyPromoEvent extends B2BStoreEvent {
  final String promoCode;

  const ApplyPromoEvent({required this.promoCode});

  @override
  List<Object?> get props => [promoCode];
}

class ApplyWolooPointsEvent extends B2BStoreEvent {
  const ApplyWolooPointsEvent();

  @override
  List<Object?> get props => [];
}

class RemoveWolooPointsEvent extends B2BStoreEvent {
  const RemoveWolooPointsEvent();

  @override
  List<Object?> get props => [];
}

class RemovePromoCodeEvent extends B2BStoreEvent {
  final String promoCode;

  const RemovePromoCodeEvent({required this.promoCode});

  @override
  List<Object> get props => [promoCode];
}

class SearchProductEvent extends B2BStoreEvent {
  final String query;
  const SearchProductEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class GetProductCategoriesEvent extends B2BStoreEvent {
  const GetProductCategoriesEvent();

  @override
  List<Object?> get props => [];
}

class GetProductsByCategoryEvent extends B2BStoreEvent {
  final String categoryId;
  const GetProductsByCategoryEvent({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}
