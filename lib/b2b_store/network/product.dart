import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/product_collections.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/product_details.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/region.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/restock_subscription.dart';
import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';
import 'package:woloo_smart_hygiene/utils/logger.dart';

class ProductService {
  final DioClient dio;
  const ProductService({required this.dio});

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
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
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

  Future<CartModel> createCart({
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
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return CartModel.fromJson(response);
    } catch (e) {
      debugPrint("error $e");
      rethrow;
    }
  }

  Future<RestockSubscriptions> restockSubscriptions(
      {required String token,
      required String variantId,
      required String phoneNumber}) async {
    try {
      var response = await dio.post(
        "https://staging-store.woloo.in/store/restock-subscriptions",
        data: {"phone": phoneNumber, "variant_id": variantId},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-publishable-api-key':
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return RestockSubscriptions.fromJson(response);
    } catch (e) {
      debugPrint("error $e");
      rethrow;
    }
  }

  Future<ProductCategory> getProductCategories({
    required String token,
  }) async {
    try {
      var response = await dio.get(
        APIConstants.GET_PRODUCT_CATEGORIES,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-publishable-api-key':
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return ProductCategory.fromJson(response);
    } catch (e) {
      debugPrint("error $e");
      rethrow;
    }
  }

  Future<TopBrands> getTopBrands({
    required String token,
  }) async {
    try {
      var response = await dio.get(
        APIConstants.TOP_BRANDS,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-publishable-api-key':
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return TopBrands.fromJson(response);
    } catch (e) {
      debugPrint("error $e");
      rethrow;
    }
  }

  Future<ProductCollections> getProductCollections({
    required String token,
  }) async {
    try {
      var response = await dio.get(
        APIConstants.PRODUCT_COLLECTIONS,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-publishable-api-key':
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      ////logger.w(response);
      return ProductCollections.fromJson(response);
    } catch (e) {
      debugPrint("error $e");
      rethrow;
    }
  }

  Future<ProductCollections> getProductCollectionsById({
    required String slug,
    required String token,
    required String id,
  }) async {
    ////logger.w("getProductCollectionsById called with id: $id");
    try {
      ////logger.w("getProductCollectionsById id: $id");
      ////logger.w("Token: $token");
      var response = await dio.get(
        "https://staging-store.woloo.in/store/products?fields=*variants.calculated_price,+variants.inventory_quantity&$slug=$id",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-publishable-api-key':
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      // ////logger.w(response);
      return ProductCollections.fromJson(response);
    } catch (e) {
      debugPrint("error $e");
      rethrow;
    }
  }

  Future<ProductCollections> searchProducts(
      {required token, required String regionId, required String query}) async {
    query = Uri.encodeComponent(query);
    try {
      var response = await dio.get(
        "https://staging-store.woloo.in/store/products?fields=*variants.calculated_price%2C+variants.inventory_quantity&region_id=$regionId&q=$query",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-publishable-api-key':
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return ProductCollections.fromJson(response);
    } catch (e) {
      logger.e("error $e");
      rethrow;
    }
  }

  Future<ProductCollections> getProductsByCategoryId({
    required String token,
    required String categoryId,
  }) async {
    try {
      var response = await dio.get(
        "https://staging-store.woloo.in/store/products?fields=*variants.calculated_price%2C+variants.inventory_quantity&category_id=$categoryId",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-publishable-api-key':
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
            'Authorization': 'Bearer $token',
            'user-agent': 'Android/22110/10',
          },
        ),
      );

      return ProductCollections.fromJson(response);
    } catch (e) {
      logger.e("Error in getProductsByCategoryId: $e");
      rethrow;
    }
  }
}
