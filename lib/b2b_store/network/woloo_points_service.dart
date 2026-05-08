import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/cart.dart';
import 'package:woloo_smart_hygiene/utils///logger.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/woloo_points.dart';

class WolooPointsService {
  final DioClient dio;
  const WolooPointsService({required this.dio});

  Future<WolooPointsResponse> getWolooPoints() async {
    GlobalStorage globalStorage = GetIt.instance();
    String clintId = globalStorage.getClientToken();

    final decodedToken = JwtDecoder.decode(clintId);
    //logger.w(decodedToken["id"]);

    try {
      final userId = decodedToken["id"]; //box.read('user_id');
      final token = clintId; //box.read('woloo_token');

      final response = await dio.get(
        'https://staging-api.woloo.in/api/wolooGuest/profile',
        queryParameters: {
          'id': userId,
        },
        options: Options(
          headers: {
            'x-woloo-token': token,
          },
        ),
      );

      return WolooPointsResponse.fromJson(response);
    } catch (e) {
      logger.e('Error fetching Woloo points: $e');
      rethrow;
    }
  }

  Future<CartModel> applyWolooPoints({
    required String token,
    required String cartId,
  }) async {
    try {
      final response = await dio.post(
        'https://staging-store.woloo.in/store/carts/$cartId/promotions',
        data: {
          "promo_codes": ["WOLOO_COINS"]
        },
        options: Options(headers: {
          'user-agent': 'Android/22110/10',
          'x-publishable-api-key':
              'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );

      return CartModel.fromJson(response);
    } catch (e) {
      //logger.e('Error applying Woloo points: $e');
      rethrow;
    }
  }

  Future<CartModel> removeWolooPoints({
    required String token,
    required String cartId,
  }) async {
    try {
      final response = await dio.delete(
        'https://staging-store.woloo.in/store/carts/$cartId/promotions',
        data: {
          "promo_codes": ["WOLOO_COINS"]
        },
        options: Options(headers: {
          'user-agent': 'Android/22110/10',
          'x-publishable-api-key':
              'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );

      return CartModel.fromJson(response);
    } catch (e) {
      //logger.e('Error removing Woloo points: $e');
      rethrow;
    }
  }

  /// Calls the ecomCoinUpdate API to update coins after order placement
  Future<Map<String, dynamic>> ecomCoinUpdate({
    required int coins,
    required String orderId,
    required String type,
    // required String wolooToken,
  }) async {
    try {
      final response = await dio.post(
        'https://staging-api.woloo.in/api/blog/ecomCoinUpdate',
        data: {
          'coins': coins,
          'orderid': orderId,
          'type': type,
        },
        // options: Options(
        //   headers: {
        //     'user-agent': 'Android/22110/10',
        //     'x-woloo-token': wolooToken,
        //     'Content-Type': 'application/json',
        //   },
        // ),
        options: Options(extra: {"auth": true, "isSupervisor": true}),
      );
      return Map<String, dynamic>.from(response);
    } catch (e) {
      logger.e('Error in ecomCoinUpdate: $e');
      rethrow;
    }
  }
}
