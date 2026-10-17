import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/delhivery_check.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/order.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/payment_provider.dart'
    as payment_provider;
import 'package:woloo_smart_hygiene/b2b_store/models/payment_provider.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/promotion.dart';
import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';

class CheckoutApiService {
  final DioClient dio;
  const CheckoutApiService({required this.dio});

  Future<PromotionsModel> cartPromotions({
    required String cart_id,
    required String token,
  }) async {
    try {
      final response = await dio.post(
          '${APIConstants.CART_BASE_URL}$cart_id/promotions',
          options: getHeaders(token),
          data: {
            "promo_codes": ["WOLOO_COINS"]
          });

      return PromotionsModel.fromMap(response);
    } catch (e) {
      ////logger.w(e);
      debugPrint("Error in cartPromotions api call : $e");
      rethrow;
    }
  }

  Future<bool> pincodeCheck({
    required String pincode,
    required String delhivery_token,
  }) async {
    try {
      final response = await dio.get(
        "https://track.delhivery.com/c/api/pin-codes/json?filter_codes=$pincode",
        options: Options(headers: {"Authorization": "Token $delhivery_token"}),
      );

      return PincodeCheckResponse.fromMap(response).deliveryCodes!.isNotEmpty;
    } catch (e) {
      ////logger.w(e);
      debugPrint("Error in pincodeCheck api call: $e");
      rethrow;
    }
  }

  Future<ShippingOptionsResponse> shippingOptions({
    required String cart_id,
    required String token,
  }) async {
    try {
      final response = await dio.get(
        "${APIConstants.SHIPPING_OPTIONS}address?cart_id=$cart_id",
        options: getHeaders(token),
      );

      return ShippingOptionsResponse.fromMap(response);
    } catch (e) {
      ////logger.w(e);
      debugPrint("Error in shippingOptions api call: $e");
      rethrow;
    }
  }

  Future<ShippingOption> shippingOptionsCalculate({
    required String? shipping_option,
    required String token,
    required String cart_id,
  }) async {
    try {
      // https://staging-store.woloo.in/store/shipping-options/so_01JR9FH2BZ89VG30A6ENB747KQ/calculate
      final response = await dio.post(
          "${APIConstants.SHIPPING_OPTIONS}$shipping_option/calculate",
          options: getHeaders(token),
          data: {"cart_id": cart_id});

      return ShippingOption.fromMap(response['shipping_option']);
    } catch (e) {
      ////logger.w(e);
      debugPrint("shippingOptionsCalculate: $e");
      rethrow;
    }
  }

  Future<AddToCartResponse> shippingMethods({
    required List<Map<String, dynamic>> shipping_option,
    // required String? shipping_option,
    required String token,
    required String cart_id,
  }) async {
    try {
      final body = {"options": shipping_option};
      // https://staging-store.woloo.in/store/carts/cart_01JTQVACY3V5FY8NBBZY3ZZ06C/shipping-methods
      final response = await dio.post(
          "https://staging-store.woloo.in/store/carts/$cart_id/add-shipping-methods",
          options: getHeaders(token),
          data: body);

      return AddToCartResponse.fromJson(response);
    } catch (e) {
      ////logger.w(e);
      debugPrint("shippingMethods: $e");
      rethrow;
    }
  }

  Future<PaymentProviders> paymentProviders({
    required String token,
    required String region_id,
  }) async {
    try {
      // https://staging-store.woloo.in/store/payment-providers?region_id=reg_01JPH693TAM20TXZEJNBJ5QBV4
      final response = await dio.get(
        "https://staging-store.woloo.in/store/payment-providers?region_id=$region_id",
        options: getHeaders(token),
      );

      return PaymentProviders.fromJson(response);
    } catch (e) {
      ////logger.w(e);
      debugPrint("paymentProviders: $e");
      rethrow;
    }
  }

  Future<String> paymentCollections({
    required String token,
    required String cart_id,
  }) async {
    try {
      final response = await dio.post(
          "https://staging-store.woloo.in/store/payment-collections",
          options: getHeaders(token),
          data: {"cart_id": cart_id});

      // ////logger.w(response['payment_collection']["id"]);
      // ////logger.w()
      /*

          pay_col: paymentCollections.paymentCollection?.id,
          provider_id: paymentProviders.paymentProviders[0].id
      */
      return response['payment_collection']["id"];
    } catch (e) {
      ////logger.w(e);
      debugPrint("paymentCollections: $e");
      rethrow;
    }
  }

  Future<payment_provider.PaymentCollection> paymentSessions({
    required String token,
    required String? pay_col,
    required String? provider_id,
  }) async {
    try {
      final response = await dio.post(
          "https://staging-store.woloo.in/store/payment-collections/$pay_col/payment-sessions",
          options: getHeaders(token),
          data: {"provider_id": "pp_razorpay_razorpay"});

      return payment_provider.PaymentCollection.fromJson(response);
    } catch (e) {
      ////logger.w(e);
      debugPrint("paymentSessions: $e");
      rethrow;
    }
  }

  Future<CompleteVendor> completeVendor({
    required String token,
    required String cart_id,
  }) async {
    try {
      final response = await dio.post(
        "https://staging-store.woloo.in/store/carts/$cart_id/split-and-complete-cart",
        options: getHeaders(token),
      );

      return CompleteVendor.fromJson(response);
    } catch (e) {
      ////logger.w(e);
      debugPrint("completeVendor: $e");
      rethrow;
    }
  }

  // Future<CompleteVendor> placeOrder({
  //   required String token,
  //   required String? order_id,
  //   required String? cart_id,
  // }) async {
  //   try {
  //     final response = await dio.post(
  //       "https://staging-store.woloo.in/store/carts/$cart_id/complete",
  //       options: getHeaders(token),
  //     );
  //
  //     return CompleteVendor.fromJson(response);
  //   } catch (e) {
  //     ////logger.w(e);
  //     debugPrint("Error in shippingOptionsCalculate api call: $e");
  //     rethrow;
  //   }
  // }
}

Options getHeaders(String token) {
  return Options(headers: {
    'x-publishable-api-key':
        'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  });
}
