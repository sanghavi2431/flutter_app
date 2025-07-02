import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

import 'package:woloo_smart_hygiene/b2b_store/models/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/payment_provider.dart';
import 'package:woloo_smart_hygiene/b2b_store/network/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/network/checkout.dart';
import 'package:woloo_smart_hygiene/b2b_store/network/product.dart';
import 'package:woloo_smart_hygiene/hygine_services/network/hygiene_service.dart';
import 'package:woloo_smart_hygiene/utils/logger.dart';

import 'hygiene_service_event.dart';
import 'hygiene_service_state.dart';

class HygieneServiceBloc
    extends Bloc<HygieneServiceEvent, HygieneServiceState> {
  final box = GetStorage();
  final HygieneServiceApi hygieneServiceApi =
      HygieneServiceApi(dio: GetIt.instance());
  final CartApiService _cartService = CartApiService(dio: GetIt.instance());

  final CheckoutApiService _checkoutApiService =
      CheckoutApiService(dio: GetIt.instance());
  final ProductService _productService = ProductService(dio: GetIt.instance());

  HygieneServiceBloc() : super(HygieneServiceInitial()) {
    on<HygieneServiceReq>(_getAllHygieneData);
    on<HygieneServiceReqById>(_getHygieneDataById);
    on<AddToCart>(_addToCart);
    on<ProceedToShip>(_proceedToSheep);
    on<Payment>(_proceedToCheckOut);
    on<PlaceOrder>(_placeOrder);
    on<GetCartData>(_getCart);
    on<DeleteItemReq>(_deleteItem);
    on<AddRemoveItemReq>(_addRemoveItems);
  }

  FutureOr<void> _getAllHygieneData(
    HygieneServiceReq event,
    Emitter<HygieneServiceState> emit,
  ) async {
    try {
      emit(const HygieneServiceLoading(message: "Loading data..."));
      final regionResponse =
          await hygieneServiceApi.getRegion(token: box.read('login_jwt'));
      box.write('region_id', regionResponse.regions![0].id);
      await hygieneServiceApi
          .createCart(
              token: box.read('login_jwt'),
              regionId: regionResponse.regions![0].id.toString())
          .then((e) {
        box.write('cart_id', e.cart.id);
      });
      final response = await hygieneServiceApi.getAllHygieneData();
      debugPrint("requestId $response");
      logger.w(response);
      // emit(HygieneServiceSuccess());
      emit(HygieneServiceSuccess(dashboardData: response));
    } catch (e) {
      emit(HygieneServiceError(error: e.toString()));
      debugPrint("Error in _getAllHygieneData service: $e");
    }
  }

  FutureOr<void> _getHygieneDataById(
    HygieneServiceReqById event,
    Emitter<HygieneServiceState> emit,
  ) async {
    try {
      emit(const HygieneServiceLoading(message: "Loading data..."));
      final response = await hygieneServiceApi.getHygieneDataById(
          productId: event.productId);

      debugPrint("requestId $response");
      print(response);
      // emit(HygieneServiceSuccess());
      emit(HygieneServiceProductSuccess(dashboardData: response));
    } catch (e) {
      emit(HygieneServiceError(error: e.toString()));
      debugPrint("Error in _getAllHygieneData service: $e");
    }
  }

  FutureOr<void> _addToCart(
    AddToCart event,
    Emitter<HygieneServiceState> emit,
  ) async {
    try {
      //TODO:Add event
      emit(const HygieneServiceLoading(message: "Loading data..."));
      AddToCartResponse res = await hygieneServiceApi.addToCart(
        service_date: event.service_date,
        service_time: event.service_time,
        service_area: event.service_area,
        token: box.read('login_jwt'),
        cart_id: box.read('cart_id'),
        variant_id: event.variant_id,
        quantity: event.quantity,
      );
      CartModel response = await _cartService.getAllCartData(
          token: box.read('login_jwt'), cartId: box.read('cart_id'));

      //TODO:Add event
      // emit(CartSuccess(cartData: response));
      emit(HygieneServiceCartSuccess(cartData: response));
    } catch (e) {
      //TODO:Add event
      // emit(B2BStoreError(error: e.toString()));
      debugPrint("Error in ATC service: $e");
      emit(HygieneServiceError(error: e.toString()));
    }
  }

  FutureOr<void> _proceedToSheep(
    ProceedToShip event,
    Emitter<HygieneServiceState> emit,
  ) async {
    emit(const HygieneCartLoading(message: "Proceed to cart"));
    try {
      //call on checkout button click then add delivery total at cart bottom sheet

      final shippingOptions = await _checkoutApiService.shippingOptions(
        cart_id: box.read('cart_id'),
        token: box.read('login_jwt'),
      );

      // final shippingOptionsCalculate =
      //     await _checkoutApiService.shippingOptionsCalculate(
      //   shipping_option: shippingOptions.shippingOptions!.first.id,
      //   token: box.read('login_jwt'),
      //   cart_id: box.read('cart_id'),
      // );

      final shippingMethods = await _checkoutApiService.shippingMethods(
          shipping_option:
              // shippingOptions.shippingOptions!.first.id,
              shippingOptions.shippingOptions!
                  .map<Map<String, dynamic>>((option) => {'id': option.id})
                  .toList(),
          token: box.read('login_jwt'),
          cart_id: box.read('cart_id'));

      emit(ReadyToShip(
        shippingDetails: shippingMethods,
      ) //completeVendor.orderSet.orders[0].items[0].total)
          );
    } catch (e) {
      emit(HygieneCartError(error: e.toString()));
    }
  }

  FutureOr<void> _proceedToCheckOut(
    Payment event,
    Emitter<HygieneServiceState> emit,
  ) async {
    //TODO:Add event
    emit(const HygieneCartLoading(message: "Proceed to cart"));
    try {
      final shippingOptions = await _checkoutApiService.shippingOptions(
        cart_id: box.read('cart_id'),
        token: box.read('login_jwt'),
      );

      // final shippingOptionsCalculate =
      //     await _checkoutApiService.shippingOptionsCalculate(
      //   shipping_option: shippingOptions.shippingOptions!.first.id,
      //   token: box.read('login_jwt'),
      //   cart_id: box.read('cart_id'),
      // );

      final shippingMethods = await _checkoutApiService.shippingMethods(
          shipping_option:
              // shippingOptions.shippingOptions!.first.id,
              shippingOptions.shippingOptions!
                  .map<Map<String, dynamic>>((option) => {'id': option.id})
                  .toList(),
          token: box.read('login_jwt'),
          cart_id: box.read('cart_id'));

      final paymentProviders = await _checkoutApiService.paymentProviders(
          token: box.read('login_jwt'), region_id: box.read('region_id'));

      final paymentCollections = await _checkoutApiService.paymentCollections(
          token: box.read('login_jwt'), cart_id: box.read('cart_id'));

      final paymentSessions = await _checkoutApiService.paymentSessions(
          token: box.read('login_jwt'),
          pay_col: paymentCollections, //.paymentCollection!.id,
          provider_id: paymentProviders.paymentProviders![0].id);

      final orderId =
          paymentSessions.paymentCollection!.paymentSessions![0].data!.id ??
              "0";

      //TODO:Add event
      emit(LetsTryState(
        orderId: orderId,
        totalPrice:
            paymentSessions.paymentCollection!.paymentSessions![0].amount ?? 0,
      ));
    } catch (e) {
      //TODO:Add event
      logger.e("Error in payment: $e");
      emit(HygieneCartError(error: e.toString()));
    }
  }

  FutureOr<void> _getCart(
    GetCartData event,
    Emitter<HygieneServiceState> emit,
  ) async {
    try {
      emit(const HygieneCartLoading(message: "Loading data..."));
      CartModel response = await _cartService.getAllCartData(
          token: box.read('login_jwt'), cartId: box.read('cart_id'));

      debugPrint("requestId $response");
      print(response);

      emit(HygieneServiceCartSuccess(cartData: response));
    } catch (e) {
      emit(HygieneCartError(error: e.toString()));
      debugPrint("Error in GetCart service: $e");
    }
  }

  FutureOr<void> _addRemoveItems(
    AddRemoveItemReq event,
    Emitter<HygieneServiceState> emit,
  ) async {
    try {
      emit(const HygieneCartLoading(message: "Loading data..."));
      CartModel response = await _cartService.addOrRemoveItem(
          itemId: event.itemId,
          count: event.count,
          token: box.read('login_jwt'),
          cartId: box.read('cart_id'));
      logger.w(response);
      emit(HygieneServiceCartSuccess(cartData: response));
    } catch (e) {
      logger.w("Error in bloc: $e");
      emit(HygieneCartError(error: e.toString()));
      rethrow;
    }
  }

  FutureOr<void> _deleteItem(
    DeleteItemReq event,
    Emitter<HygieneServiceState> emit,
  ) async {
    emit(const HygieneCartLoading(message: "Proceed to cart"));
    try {
      await _cartService.deleteItem(
          itemId: event.itemId,
          token: box.read('login_jwt'),
          cartId: box.read('cart_id'));
      // logger.w(response);
      CartModel response = await _cartService.getAllCartData(
          token: box.read('login_jwt'), cartId: box.read('cart_id'));

      emit(HygieneServiceCartSuccess(cartData: response));
    } catch (e) {
      logger.e("Error in delete Item Bloc: $e");
      emit(HygieneCartError(error: e.toString()));
    }
  }

  FutureOr<void> _placeOrder(
    PlaceOrder event,
    Emitter<HygieneServiceState> emit,
  ) async {
    emit(const HygieneCartLoading(message: "Proceed to cart"));
    try {
      // final placeOrder = await _checkoutApiService.placeOrder(
      //     cart_id: box.read('cart_id'),
      //     token: box.read('login_jwt'),
      //     order_id: event.order_id);
      final completeVendor = await _checkoutApiService.completeVendor(
          token: box.read('login_jwt'), cart_id: box.read('cart_id'));
      await _productService
          .createCart(
              token: box.read('login_jwt'), regionId: box.read('region_id'))
          .then((cartData) {
        box.write('cart_id', cartData.cart.id);
      });
      emit(PaymentSuccess(completeVendor: completeVendor));
    } catch (e) {
      emit(HygieneCartError(error: e.toString()));
    }
  }
}
