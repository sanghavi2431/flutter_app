import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/customer_reviews.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/order_details.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';
import 'package:woloo_smart_hygiene/utils///logger.dart';

class OrderDetailsService {
  final DioClient dio;
  const OrderDetailsService({required this.dio});

  Future<OrderDetails> getOrderDetails({required String token}) async {
    try {
      var response = await dio.get(
        "https://staging-store.woloo.in/store/order-sets",
        options: Options(
          headers: {
            'x-publishable-api-key':
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );
      //logger.w(response);
      return OrderDetails.fromJson(response);
    } catch (e) {
      debugPrint("Error in getOrderDetails service: $e");
      rethrow;
    }
  }

  Future<CustomerReviews> getOrderReviews(
      {required String token, required String productId}) async {
    try {
      // //logger.i("Fetching reviews for product ID: $productId");
      final response = await dio.get(
        "https://staging-store.woloo.in/store/products/$productId/reviews?all=2",
        options: Options(
          headers: {
            'x-publishable-api-key':
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
            'Authorization': 'Bearer $token'
          },
        ),
      );
      // ////logger.w("Response received: $response");

      return CustomerReviews.fromJson(response["data"]);
    } catch (e) {
      //logger.e("Error in getOrderReviews service: $e");
      rethrow;
    }
  }
}
