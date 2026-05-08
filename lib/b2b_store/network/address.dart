import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/address.dart';
import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';
import 'package:woloo_smart_hygiene/utils///logger.dart';

class AddAddressReqBody {
  final String? first_name;
  final String? last_name;
  final String? address_1;
  final String? city;
  final String? phone_number;
  final String? postal_code;
  final String? province;
  final String? address_name;
  // Assuming this class is defined elsewhere in your codebase
  AddAddressReqBody.fromJson(Map<String, dynamic> json)
      : first_name = json['first_name'],
        last_name = json['last_name'],
        address_1 = json['address_1'],
        city = json['city'],
        phone_number = json['phone'],
        postal_code = json['postal_code'],
        province = json['province'],
        address_name = json['address_name'];
  Map<String, dynamic> toJson() {
    return {
      'first_name': first_name,
      'last_name': last_name,
      'address_1': address_1,
      'city': city,
      'phone': phone_number,
      'postal_code': postal_code,
      'province': province,
      'address_name': address_name,
    };
  }

  AddAddressReqBody({
    required this.first_name,
    required this.last_name,
    required this.address_1,
    required this.city,
    required this.phone_number,
    required this.postal_code,
    required this.province,
    required this.address_name,
  });
}

class AddressService {
  final DioClient dio;
  const AddressService({required this.dio});

  Future<AddAddressResBody> addAddress({
    required AddAddressReqBody body,
    required String token,
  }) async {
    try {
      final Map<String, dynamic> data = body.toJson();
      ////logger.w(data);
      var response = await dio.post(
        APIConstants.CREATE_ADDRESS,
        data: data,
        options: Options(
          headers: {
            'x-publishable-api-key':
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': 'Bearer $token'
          },
        ),
      );

      return AddAddressResBody.fromJson(response);
    } catch (e) {
      debugPrint("Error in IOT service: $e");
      rethrow;
    }
  }

  Future<AddAddressResBody> updateAddress({
    required AddressReqBody body,
    required String addressId,
    required String token,
  }) async {
    try {
      final data = body.toJson();
      ////logger.w(data);
      var response = await dio.post(
        APIConstants.UPDATE_ADDRESS + addressId,
        data: data,
        options: Options(
          headers: {
            'x-publishable-api-key':
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );

      return AddAddressResBody.fromJson(response);
    } catch (e) {
      debugPrint("Error in IOT service: $e");
      rethrow;
    }
  }

  Future<AddressesData> getAllAddress({
    required String token,
  }) async {
    // ////logger.w("Token: $token");
    try {
      var response = await dio.get(
        APIConstants.GET_ADDRESS + "?fields=+address_name",
        options: Options(
          headers: {
            'x-publishable-api-key':
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': 'Bearer $token'
          },
        ),
      );

      return AddressesData.fromJson(response);
    } catch (e) {
      debugPrint("Error in IOT service: $e");
      rethrow;
    }
  }

  Future<AddAddressResBody> setAddress({
    required AddressReqBody shippingAddress,
    required AddressReqBody billingAddress,
    required String token,
    required String cartId,
  }) async {
    try {
      var response = await dio.post(
        APIConstants.SET_BILLING_ADDRESS + cartId,
        data: {
          'billing_address': billingAddress.toJson(),
          'shipping_address': shippingAddress.toJson(),
        },
        options: Options(
          headers: {
            'x-publishable-api-key':
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': 'Bearer $token'
          },
        ),
      );

      return AddAddressResBody.fromJson(response);
    } catch (e) {
      debugPrint("Error in IOT service: $e");
      rethrow;
    }
  }

  Future selectAddress({
    required Addresses shippingAddress,
    required String token,
    required String cartId,
  }) async {
    try {
      ////logger.w("Address: ${shippingAddress.toFieldData()}");
      var response = await dio.post(
        APIConstants.SET_BILLING_ADDRESS + cartId,
        data: {
          'billing_address': shippingAddress.toFieldData(),
          'shipping_address': shippingAddress.toFieldData(),
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

      return response;
    } catch (e) {
      debugPrint("Error in IOT service: $e");
      rethrow;
    }
  }

  Future deleteAddress(
      {required String addressId, required String token}) async {
    try {
      final url = "${APIConstants.GET_ADDRESS}/$addressId";
      final res = await dio.delete(
        url,
        options: Options(
          headers: {
            'x-publishable-api-key':
                'pk_11664986800fe08913d9c7c090d91839cbdefceda3f8b4c60722d79000f49a48',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );
      return res;
    } catch (e) {
      //logger.e("Delete Address Issue: $e");
      rethrow;
    }
  }
}
