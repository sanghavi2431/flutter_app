import 'package:equatable/equatable.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_bloc.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/address.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/customer_reviews.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/order.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/order_details.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/product_collections.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/product_details.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/restock_subscription.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/wishlist.dart';
import 'package:woloo_smart_hygiene/janitorial_services/model/host_dashboard_screen.dart';

abstract class B2BStoreState extends Equatable {
  const B2BStoreState();
}

class B2BStoreInitial extends B2BStoreState {
  @override
  List<Object> get props => [];
}

class B2BStoreLoading extends B2BStoreState {
  final String message;
  const B2BStoreLoading({required this.message});

  @override
  List<Object> get props => [message];
}

class B2BStoreError extends B2BStoreState {
  final String error;
  const B2BStoreError({required this.error});

  @override
  List<Object> get props => [error];
}

class B2BStoreSuccess extends B2BStoreState {
  final B2BStoreHomePage dashboardData;
  const B2BStoreSuccess(this.dashboardData);
  @override
  List<Object> get props => [dashboardData];
}

class HostDashboardSuccess extends B2BStoreState {
  final HostDashboardData dashboardData;
  const HostDashboardSuccess({required this.dashboardData});
  @override
  List<Object> get props => [dashboardData];
}

class AddAddressSuccess extends B2BStoreState {
  final AddAddressResBody addAddressResBody;
  const AddAddressSuccess({required this.addAddressResBody});
  @override
  List<Object> get props => [addAddressResBody];
}

class GetAddressSuccess extends B2BStoreState {
  final AddressesData addressesData;
  const GetAddressSuccess({required this.addressesData});
  @override
  List<Object> get props => [addressesData];
}

class PostAddressSuccess extends B2BStoreState {
  const PostAddressSuccess();
  @override
  List<Object> get props => [];
}

class CartInitial extends B2BStoreState {
  @override
  List<Object> get props => [];
}

class CartLoading extends B2BStoreState {
  final String message;
  const CartLoading({required this.message});

  @override
  List<Object> get props => [message];
}

class CartLoadingForPromo extends B2BStoreState {
  final String message;
  const CartLoadingForPromo({required this.message});

  @override
  List<Object> get props => [message];
}

class PromoCodeSuccess extends B2BStoreState {
  final CartModel cartData;
  final String? message;
  const PromoCodeSuccess({
    required this.cartData,
    this.message,
  });

  @override
  List<Object> get props => [
        cartData,
        if (message != null) message!,
      ];
}

class PostAddressLoading extends B2BStoreState {
  final String message;
  const PostAddressLoading({required this.message});

  @override
  List<Object> get props => [message];
}

class CartError extends B2BStoreState {
  final String error;
  const CartError({required this.error});

  @override
  List<Object> get props => [error];
}

class AddToCartSuccess extends B2BStoreState {
  final AddToCartResponse cartData;
  const AddToCartSuccess({required this.cartData});
  @override
  List<Object> get props => [cartData];
}

class SearchProductSuccess extends B2BStoreState {
  final List<XYProduct> products;
  const SearchProductSuccess({required this.products});

  @override
  List<Object> get props => [products];
}

class CartSuccess extends B2BStoreState {
  final CartModel cartData;
  final ProductCollections? productCollection;
  final int wolooPoints;
  final String? message;
  const CartSuccess({
    required this.cartData,
    this.productCollection,
    required this.wolooPoints,
    this.message,
  });

  @override
  List<Object> get props => [
        cartData,
        if (productCollection != null) productCollection!,
        wolooPoints,
        if (message != null) message!,
      ];
}

class ProceedCart extends B2BStoreState {
  final CartModel cartData;
  const ProceedCart({required this.cartData});
  @override
  List<Object> get props => [];
}

class AddressGet extends B2BStoreState {
  final Addresses addressesData;
  const AddressGet({required this.addressesData});
  @override
  List<Object> get props => [addressesData];
}

class AddressSet extends B2BStoreState {
  final Addresses message;
  const AddressSet({required this.message});

  @override
  List<Object> get props => [message];
}

class PaymentSuccess extends B2BStoreState {
  final CompleteVendor completeVendor;
  const PaymentSuccess({required this.completeVendor});

  @override
  List<Object> get props => [];
}

class LetsTryState extends B2BStoreState {
  final String orderId;
  final dynamic totalPrice;
  const LetsTryState({
    required this.orderId,
    required this.totalPrice,
  });
  @override
  List<Object> get props => [orderId];
}

class ReadyToShip extends B2BStoreState {
  final AddToCartResponse shippingDetails;

  const ReadyToShip({
    required this.shippingDetails,
  });
  @override
  List<Object> get props => [shippingDetails];
}

class OrderDetailsSuccess extends B2BStoreState {
  final OrderDetails orderDetailsData;
  const OrderDetailsSuccess({required this.orderDetailsData});
  @override
  List<Object> get props => [orderDetailsData];
}

class OrderDetailsLoading extends B2BStoreState {
  final String message;
  const OrderDetailsLoading({required this.message});

  @override
  List<Object> get props => [message];
}

class OrderDetailsError extends B2BStoreState {
  final String error;
  const OrderDetailsError({required this.error});

  @override
  List<Object> get props => [error];
}

class WishlistSuccess extends B2BStoreState {
  final Wishlist wishlistData;
  final CartModel? cartModel;
  final ProductCollections? productCollections;
  const WishlistSuccess(
      {required this.wishlistData, this.cartModel, this.productCollections});
  @override
  List<Object> get props => [
        wishlistData,
        if (cartModel != null) cartModel!,
        if (productCollections != null) productCollections!,
      ];
}

class WishlistLoading extends B2BStoreState {
  final String message;
  const WishlistLoading({required this.message});

  @override
  List<Object> get props => [message];
}

class WishlistError extends B2BStoreState {
  final String error;
  const WishlistError({required this.error});

  @override
  List<Object> get props => [error];
}

class ReviewSuccess extends B2BStoreState {
  final String message;
  const ReviewSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

class ReviewLoading extends B2BStoreState {
  final String message;
  const ReviewLoading({required this.message});

  @override
  List<Object> get props => [message];
}

class ReviewError extends B2BStoreState {
  final String error;
  const ReviewError({required this.error});

  @override
  List<Object> get props => [error];
}

class CustomerReviewSuccess extends B2BStoreState {
  final CustomerReviews customerReview;

  final ProductCollections? productCollection;
  const CustomerReviewSuccess(
      {required this.customerReview, this.productCollection});
  @override
  List<Object> get props =>
      [customerReview, if (productCollection != null) productCollection!];
}

class RestockSubscriptionsSuccess extends B2BStoreState {
  final RestockSubscriptions restockSubscriptions;
  const RestockSubscriptionsSuccess({required this.restockSubscriptions});

  @override
  List<Object> get props => [restockSubscriptions];
}

class RestockSubscriptionsLoading extends B2BStoreState {
  final String message;
  const RestockSubscriptionsLoading({required this.message});

  @override
  List<Object> get props => [message];
}

class RestockSubscriptionsError extends B2BStoreState {
  final String error;
  const RestockSubscriptionsError({required this.error});

  @override
  List<Object> get props => [error];
}

class PromoApplySuccess extends B2BStoreState {
  final CartModel cartData;
  const PromoApplySuccess({required this.cartData});
  @override
  List<Object> get props => [cartData];
}

class PromoApplyError extends B2BStoreState {
  final String error;
  const PromoApplyError({required this.error});
  @override
  List<Object> get props => [error];
}

class ProductCategoriesLoading extends B2BStoreState {
  final String message;
  const ProductCategoriesLoading({required this.message});

  @override
  List<Object> get props => [message];
}

class ProductCategoriesSuccess extends B2BStoreState {
  final ProductCategory productCategories;
  const ProductCategoriesSuccess({required this.productCategories});

  @override
  List<Object> get props => [productCategories];
}

class ProductCategoriesError extends B2BStoreState {
  final String error;
  const ProductCategoriesError({required this.error});

  @override
  List<Object> get props => [error];
}

class ProductsByCategoryLoading extends B2BStoreState {
  final String message;
  const ProductsByCategoryLoading({required this.message});

  @override
  List<Object> get props => [message];
}

class ProductsByCategorySuccess extends B2BStoreState {
  final ProductCollections products;
  const ProductsByCategorySuccess({required this.products});

  @override
  List<Object> get props => [products];
}

class ProductsByCategoryError extends B2BStoreState {
  final String error;
  const ProductsByCategoryError({required this.error});

  @override
  List<Object> get props => [error];
}
