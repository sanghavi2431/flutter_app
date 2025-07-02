import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/cart.dart' as cart;
import 'package:woloo_smart_hygiene/b2b_store/models/region.dart';
import 'package:woloo_smart_hygiene/b2b_store/network/checkout.dart';
import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';
import 'package:woloo_smart_hygiene/hygine_services/model/address.dart';
import 'package:woloo_smart_hygiene/hygine_services/model/hygiene_services.dart';
import 'package:woloo_smart_hygiene/utils/logger.dart';

class HygieneServiceApi {
  final DioClient dio;
  const HygieneServiceApi({required this.dio});
  Future<RegionsModel> getRegion({
    required String token,
  }) async {
    try {
      var response = await dio.get(
        APIConstants.GET_REGIONS,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-publishable-api-key':
                'pk_03b79693816aae4cb87568dc50b7efaa48e0d51b201040f46ef4528839078f08',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return RegionsModel.fromJson(response);
    } catch (e) {
      debugPrint("error $e");
      rethrow;
    }
  }

  Future<cart.CartModel> createCart({
    required String token,
    required String regionId,
  }) async {
    try {
      var response = await dio.post(
        APIConstants.CREATE_CART,
        data: {
          "region_id": regionId,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-publishable-api-key':
                'pk_03b79693816aae4cb87568dc50b7efaa48e0d51b201040f46ef4528839078f08',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return cart.CartModel.fromJson(response);
    } catch (e) {
      debugPrint("error $e");
      rethrow;
    }
  }

  Future<cart.AddToCartResponse> addToCart({
    required String token,
    required String cart_id,
    required String? variant_id,
    required String service_date,
    required String service_time,
    required String service_area,
    required int quantity,
  }) async {
    try {
      var response = await dio.post(
        '${APIConstants.ADD_TO_CART}$cart_id/line-items',
        data: {
          "variant_id": variant_id,
          "quantity": quantity,
          "metadata": {
            "service_date": "$service_date",
            "service_time": "$service_time",
            "service_area": "$service_area"
          }
        },
        options: Options(
          headers: {
            'x-publishable-api-key':
                'pk_03b79693816aae4cb87568dc50b7efaa48e0d51b201040f46ef4528839078f08',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );
      logger.w(response);
      return cart.AddToCartResponse.fromJson(response);
    } catch (e) {
      debugPrint("Error in add  to cart  service: $e");
      rethrow;
    }
  }

  Future<HygieneService> getAllHygieneData() async {
    try {
      var response = await dio.get(
        "https://staging-store.woloo.in/store/products?fields=*variants.calculated_price,+variants.inventory_quantity&region_id=reg_01JPH693TAM20TXZEJNBJ5QBV4",
        options: Options(
          headers: {
            'x-publishable-api-key':
                'pk_67ce4e90f35529f44006d2a95b330dbabbe576e43d3fd06021ca656ee00806cf',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      return HygieneService.fromJson(response);
    } catch (e) {
      debugPrint("Error in IOT service: $e");
      rethrow;
    }
  }

  Future<Product> getHygieneDataById({
    required String productId,
  }) async {
    try {
      var response = await dio.get(
        "https://staging-store.woloo.in/store/products/$productId?fields=*variants.calculated_price",
        options: Options(
          headers: {
            'x-publishable-api-key':
                'pk_67ce4e90f35529f44006d2a95b330dbabbe576e43d3fd06021ca656ee00806cf',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      return Product.fromJson(response['product']);
    } catch (e) {
      debugPrint("Error in IOT service: $e");
      rethrow;
    }
  }

  Future<String> updateCartAddresses({
    required String cart_id,
    required String token,
    required SetShippingAndBillingAddressModel address,
  }) async {
    try {
      final response = await dio.post(
        APIConstants.CART_BASE_URL + cart_id,
        options: Options(headers: {
          'x-publishable-api-key':
              'pk_67ce4e90f35529f44006d2a95b330dbabbe576e43d3fd06021ca656ee00806cf',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }),
        data: {
          "shipping_address": address.shippingAddress.toJson(),
          "billing_address": address.billingAddress.toJson() //.toMap(),
        },
      );

      // Assuming the response returns the updated cart, similar to AddToCartResponse
      return (response);
    } catch (e) {
      logger.w(e);
      debugPrint("Error in updateCartAddresses api call: $e");
      rethrow;
    }
  }

  Future<String> getShippingOptionsForAddress({
    required String cart_id,
    required String token,
  }) async {
    try {
      // The endpoint from the cURL command
      const String url =
          "https://staging-store.woloo.in/store/shipping-options/address";
      final response = await dio.get(
        url,
        queryParameters: {'cart_id': cart_id},
        options: Options(headers: {
          'x-publishable-api-key':
              'pk_67ce4e90f35529f44006d2a95b330dbabbe576e43d3fd06021ca656ee00806cf',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );
      return (response);
    } catch (e) {
      logger.w(e);
      debugPrint("Error in getShippingOptionsForAddress api call: $e");
      rethrow;
    }
  }

  Future<String> getShippingOption({
    required String cart_id,
    required String token,
  }) async {
    try {
      // The endpoint from the cURL command
      String url = "https://staging-store.woloo.in/store/shipping-options";
      final response = await dio.get(
        url,
        queryParameters: {'cart_id': cart_id},
        options: Options(headers: {
          'x-publishable-api-key':
              'pk_67ce4e90f35529f44006d2a95b330dbabbe576e43d3fd06021ca656ee00806cf',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );
      return (response);
    } catch (e) {
      logger.w(e);
      debugPrint("Error in getShippingOptionsForAddress api call: $e");
      rethrow;
    }
  }

  Future<String> calculateShippingOption({
    required String shippingOptionId,
    required String token,
    required String cartId,
    Map<String, dynamic>?
        data, // Optional data, defaults to empty if not provided
  }) async {
    try {
      final String url =
          "https://staging-store.woloo.in/store/shipping-options/$shippingOptionId/calculate";
      final response = await dio.post(
        url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'x-publishable-api-key':
              'pk_03b79693816aae4cb87568dc50b7efaa48e0d51b201040f46ef4528839078f08', // Or your specific key
          'Authorization': 'Bearer $token',
        }),
        data: {
          "cart_id": cartId,
          "data": data ?? {}, // Use provided data or an empty map
        },
      );
      return (response); // Assuming the response is a JSON string or can be handled as such
    } catch (e) {
      logger.w(e);
      debugPrint("Error in calculateShippingOption api call: $e");
      rethrow;
    }
  }

  Future<String> shippingMethodsForCart({
    required String cartId,
    required String token,
    required String optionId,
    Map<String, dynamic>? data, // Optional data, defaults to empty
  }) async {
    try {
      final String url =
          "https://staging-store.woloo.in/store/carts/$cartId/shipping-methods";
      final response = await dio.post(
        url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'x-publishable-api-key':
              'pk_03b79693816aae4cb87568dc50b7efaa48e0d51b201040f46ef4528839078f08', // API key from your cURL
          'Authorization': 'Bearer $token',
        }),
        data: {
          "option_id": optionId,
          "data": data ?? {}, // Use provided data or an empty map
        },
      );
      return (response); // Assuming the response is a JSON string or can be handled as such
    } catch (e) {
      logger.w(e);
      debugPrint("Error in getShippingMethodsForCart api call: $e");
      rethrow;
    }
  }

  Future<String> completeVendorForCart({
    required String cartId,
    required String token,
  }) async {
    try {
      final String url =
          "https://staging-store.woloo.in/store/carts/$cartId/complete-vendor";
      final response = await dio.post(
        url,
        options: Options(headers: {
          // 'Content-Type': 'application/json', // Not specified in cURL, but often needed for POST if there's a body. If no body, it might not be strictly necessary.
          'x-publishable-api-key':
              'pk_dc19ac771c3445df203847918955e32617a389258384c735ba0eebd4499c30b5', // API key from your cURL
          'Authorization': 'Bearer $token',
        }),
        // data: {}, // No data payload in the cURL command, so sending an empty map or null.
        // If the API expects an empty JSON body, use: data: {}
      );
      return (response); // Assuming the response is a JSON string or can be handled as such
    } catch (e) {
      logger.w(e);
      debugPrint("Error in completeVendorForCart api call: $e");
      rethrow;
    }
  }

  Future<String> completeCart({
    required String cartId,
    required String token,
  }) async {
    try {
      final String url =
          "https://staging-store.woloo.in/store/carts/$cartId/complete";
      final response = await dio.post(
        url,
        options: Options(headers: {
          // 'Content-Type': 'application/json', // Not specified in cURL, but often needed for POST if there's a body.
          'x-publishable-api-key':
              'pk_03b79693816aae4cb87568dc50b7efaa48e0d51b201040f46ef4528839078f08', // API key from your cURL
          'Authorization': 'Bearer $token',
        }),
        // data: {}, // No data payload in the cURL command.
      );
      return (response); // Assuming the response is a JSON string or can be handled as such
    } catch (e) {
      logger.w(e);
      debugPrint("Error in completeCart api call: $e");
      rethrow;
    }
  }
}
