import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/cart.dart';
import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';
import 'package:woloo_smart_hygiene/utils///logger.dart';

import '../models/delhivery_codes.dart';
import '../models/inventory_model.dart';
import '../models/inventrory_error_model.dart';

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

  //  https://staging-store.woloo.in/store/carts/cart_01JZ5G83JADS2RWKFFW7VJESFY/check-inventory

  Future<dynamic> checkInventory({
    required String token,
    required String cartId,
    // required String promoCode,
  }) async {
    var inventoryModel;
    try {
      final response = await get(
        Uri.parse(
            "https://staging-store.woloo.in/store/carts/$cartId/check-inventory"),
        headers: {
          'x-publishable-api-key':
              'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        // options: Options(
        //   headers: {
        //     'x-publishable-api-key':
        //         'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
        //     'Content-Type': 'application/json',
        //     'Authorization': 'Bearer $token'
        //   },
        // ),
        // data: {
        //   "promo_codes": [promoCode]
        // },
      );

      logger.w("Check Inventory Response: ${response.statusCode}");
      if (response.statusCode == 200) {
        inventoryModel = inventoryModelFromJson(response.body);

        // InventoryModel.fromJson(response.body);
      } else if (response.statusCode == 400) {
        // Handle 400 Bad Request
        logger.w("400 Response: ${response.body}");
        inventoryModel = inventoryErrorModelFromJson(response.body);
        //  /   inventoryModel = InventoryModel.fromJson(response.body);
      } else {
        logger.e("Error in checkInventory: ${response.body}");
        throw Exception('Failed to check inventory');
      }

      return inventoryModel;
      // InventoryModel.fromJson(response.body);
    } catch (e) {
      print("400 Response: ${e}");
      //   if (e.response != null && e.response!.statusCode == 400) {
      //     // You can access e.response!.data here
      //     logger.w("400 Response: ${e.response!.data}");

      //   // Optionally parse partial/failed response
      //   return InventoryModel.fromJson(e.response!.data);
      // }
      logger.e("Error in removePromoCode: $e");
      throw Exception(e);
    }
  }

  //  Future<dynamic> getDeliveryPartnersListFromPincode({
  //   required String fields,
  //   // required String promoCode,
  // }) async {
  //   var delhiveryModel;
  //   try {
  //     final response = await get(
  //       Uri.parse(
  //           "https://track.delhivery.com/c/api/pin-codes/json?filter_codes=$fields"),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Token 427fac3f9e72dae810b631fcaa481f9f29ff65ee'
  //       },

  //     );

  //     logger.w("Check Pincode Response: ${response.statusCode}");
  //     if (response.statusCode == 200) {

  //       delhiveryModel = DeliveryCodesResponse.fromJson(response.body);

  //       // InventoryModel.fromJson(response.body);

  //     }
  //     else {

  //       logger.e("Product not available on this pin code: ${response.body}");
  //       throw Exception('Product not available on this pin code');
  //     }

  //     return delhiveryModel;
  //     // InventoryModel.fromJson(response.body);
  //   }   catch (e) {

  //     logger.e("Product not available on this pin code: $e");
  //     throw Exception(e);
  //   }
  // }

  Future<DeliveryCodesResponse> getDeliveryPartnersListFromPincode({
    required String fields,
  }) async {
    try {
      final response = await dio.get(
        "https://track.delhivery.com/c/api/pin-codes/json?filter_codes=$fields",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token 427fac3f9e72dae810b631fcaa481f9f29ff65ee'
          },
        ),
        // data: {
        //   "promo_codes": [promoCode]
        // },
      );
      var del = DeliveryCodesResponse.fromJson(response);
      print("api ka res in ${del}");

      return DeliveryCodesResponse.fromJson(response);
    } catch (e) {
      logger.e("Error in removePromoCode: $e");
      throw Exception('Something went wrong. Please try again later.');
    }
  }
}
