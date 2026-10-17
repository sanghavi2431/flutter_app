import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';

import '../../b2b_store/network/login_reg_flow.dart';
import '../../screens/my_account/data/network/profile_service.dart';
import '../local/global_storage.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) {
      print("Error-----> $err");
    }

    if (err.type == DioExceptionType.unknown) {
      if (err.toString().contains('No address associated with hostname')) {
        throw "Please check your internet connection";
      }
    }

    if (err.response?.statusCode == 500 || err.response?.statusCode == 401) {
      print("⚠️ Server error 500 detected, attempting to re-login...");

      try {
        GlobalStorage globalStorage = GetIt.instance();
        final box = GetStorage();
        final LoginFlowService loginFlowService =
            LoginFlowService(dio: GetIt.instance());
        ProfileService profileService = ProfileService(dio: GetIt.instance());

        var res = await loginFlowService.getProfile();

        if (res.results!.isRegister == 0) {
          loginFlowService.emailPassRegister(
            email: globalStorage.getEmail(),
            pass: globalStorage.getPassword(),
          );
        } else {
          final loginToken = await loginFlowService.loginCustomer(
            email: globalStorage.getEmail(),
            pass: globalStorage.getPassword(),
          );
          box.write('login_jwt', loginToken);
        }
      } catch (e) {
        print("Re-login failed: $e");
        return handler.next(err); // Pass error onward if retry fails
      }
    }
    Logger(printer: PrettyPrinter()).e(err.response);
    if (err.response?.statusCode == 400) {
      err.response?.data = err.response?.data['message'];
    }
    super.onError(err, handler);
  }
}
