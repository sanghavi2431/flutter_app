import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/cart.dart';
import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';
import 'package:woloo_smart_hygiene/utils///logger.dart';

class CartApiService {
  final DioClient dio;
  const CartApiService({required this.dio});

  Future<AddToCartResponse> addToCart({
    required String token,
    required String cart_id,
    required String? variant_id,
    required int quantity,
  }) async {
    try {
      var response = await dio.post(
        '${APIConstants.ADD_TO_CART}$cart_id/line-items',
        data: {
          "variant_id": variant_id,
          "quantity": quantity,
          "metadata": {
            //TODO: for hygine service i need to add {
            // data - val and time - val
            // }
          }
        },
        options: Options(
          headers: {
            'x-publishable-api-key':
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );

      return AddToCartResponse.fromJson(response);
    } catch (e) {
      debugPrint("Error in add  to cart  service: $e");
      rethrow;
    }
  }

  Future<CartModel> getAllCartData({
    required String token,
    required String cartId,
  }) async {
    try {
      var response = await dio.get(
        APIConstants.GET_ALL_CART_DATA + cartId,
        options: Options(
          headers: {
            'x-publishable-api-key':
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': 'Bearer $token'
          },
        ),
      );
      // ////logger.w(response);
      return CartModel.fromJson(response);
    } catch (e) {
      debugPrint("Error in IOT service: $e");
      rethrow;
    }
  }

  Future<CartModel> addOrRemoveItem(
      {required String cartId,
      required String itemId,
      required int count,
      required String token}) async {
    try {
      ////logger.w(
      // "URL: ${APIConstants.ADD_TO_CART + cartId + APIConstants.Add_Remove_Item + itemId}");
      final res = await dio.post(
          APIConstants.ADD_TO_CART +
              cartId +
              APIConstants.Add_Remove_Item +
              itemId,
          data: {"quantity": count},
          options: Options(headers: {
            'x-publishable-api-key':
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }));
      return CartModel.fromJson(res);
    } catch (e) {
      //logger.e("Error in add or remove item service: $e");
      rethrow;
    }
  }

  Future<bool> deleteItem(
      {required String cartId,
      required String itemId,
      required String token}) async {
    try {
      final res = await dio.delete(
          APIConstants.ADD_TO_CART +
              cartId +
              APIConstants.Add_Remove_Item +
              itemId,
          options: Options(headers: {
            'x-publishable-api-key':
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }));

      return res["deleted"];
    } catch (e) {
      //logger.e("Error in delete item service: $e");
      rethrow;
    }
  }

  Future<CartModel> applyPromoCode({
    required String token,
    required String cartId,
    required String promoCode,
  }) async {
    try {
      final response = await dio
          .post("https://staging-store.woloo.in/store/carts/$cartId/promotions",
              options: Options(
                headers: {
                  'x-publishable-api-key':
                      'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token'
                },
              ),
              data: {
            "promo_codes": [promoCode]
          });

      return CartModel.fromJson(response);
    } catch (e) {
      //logger.e("Error in applyPromoCode: $e");
      throw Exception('Something went wrong. Please try again later.');
    }
  }

  Future<CartModel> removePromoCode({
    required String token,
    required String cartId,
    required String promoCode,
  }) async {
    try {
      final response = await dio.delete(
        "https://staging-store.woloo.in/store/carts/$cartId/promotions",
        options: Options(
          headers: {
            'x-publishable-api-key':
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
        data: {
          "promo_codes": [promoCode]
        },
      );

      return CartModel.fromJson(response);
    } catch (e) {
      //logger.e("Error in removePromoCode: $e");
      throw Exception('Something went wrong. Please try again later.');
    }
  }
}
