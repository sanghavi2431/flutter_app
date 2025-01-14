import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError( DioException err, ErrorInterceptorHandler handler) {
    print("Error-----> $err");
    if (err.type ==  DioExceptionType.unknown ) {
      if (err.toString().contains('No address associated with hostname')) {
        throw "Please check your internet connection";
      }
    }
    Logger(printer: PrettyPrinter()).e(err.response);
    if (err.response?.statusCode == 400) {
      err.response?.data = err.response?.data['message'];
    }
    super.onError(err, handler);
  }
}
