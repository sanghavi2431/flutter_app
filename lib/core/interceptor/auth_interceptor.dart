import 'package:context_holder/context_holder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/screens/login/view/login_screen.dart';

import '../local/global_storage.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      EasyLoading.showToast("Session timed out.\nPlease login again.");
      // Navigator.pushAndRemoveUntil(
      //   ContextHolder.currentContext,
      //   MaterialPageRoute(builder: (context) => const LoginScreen()),
      //   (route) => false,
      // );
      // return;
    }
    super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    GlobalStorage globalStorage = GetIt.instance();
    bool isAuth = options.extra['auth'] ?? false;
    bool isSuperVisor = options.extra['isSupervisor'] ?? false;
    if (isAuth) {
      debugPrint("is auth");
      // Get language codes and set accept-language header
      List<String> languageCodes = globalStorage.getLanguageCodes();
      String acceptLanguage = languageCodes.isNotEmpty ? languageCodes.first : 'en';
      
      // Add token and accept-language headers
      // Only set accept-language if not already set (to allow override if needed)
      if (!options.headers.containsKey("accept-language")) {
        options.headers["accept-language"] = acceptLanguage;
      }
      
      // Client app saves JWT in `clientToken` (verify OTP); janitor flow uses
      // `accessToken`. Requests may set only one of `isSupervisor` flags, so
      // fall back to the other store when the primary is empty.
      final String clientTok = globalStorage.getClientToken();
      final String accessTok = globalStorage.getToken();
      final String token = isSuperVisor
          ? (clientTok.isNotEmpty ? clientTok : accessTok)
          : (accessTok.isNotEmpty ? accessTok : clientTok);

      options.headers.addAll({
        "x-woloo-token": token,
      });
      
      debugPrint("AuthInterceptor - Language codes: $languageCodes");
      debugPrint("AuthInterceptor - Setting accept-language: ${options.headers["accept-language"]}");
    }
    super.onRequest(options, handler);
  }
}
