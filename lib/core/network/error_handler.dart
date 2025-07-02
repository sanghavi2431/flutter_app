import 'package:woloo_smart_hygiene/core/network/failure.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../utils/app_constants.dart';


class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
           
            
     
             print("is dio exception ${error is DioException}");

    if (error is DioException) {
          // print("int the exception ${error is DioException}");

      // dio error so its an error from response of the API or from dio itself
      failure = _handleError(error);
    } else {

       print("elssssss");
       
      //  error.toString();
      // default error
      failure = 
      //  _handleError(error);
       DataSource.defaultError.getFailure();
    }
  }
}

Failure _handleError(DioException error) {
    print("error handleeeeeeeee ${error.type}");
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return DataSource.connectTimeout.getFailure();
      case DioExceptionType.sendTimeout:
        return DataSource.sendTimeout.getFailure();
      case DioExceptionType.receiveTimeout:
        return DataSource.receiveTimeout.getFailure();
    case DioExceptionType.badResponse:
      // if (error.response != null && error.response?.statusCode != null && error.response?.statusMessage != null) {
        return Failure(error.response?.statusCode ?? 0, error.response?.data["message"] ?? "");
      // }
      //  else {
        // return DataSource.defaultError.getFailure();
      // }
      case DioExceptionType.cancel:
        return DataSource.cancel.getFailure();
      default:
        return DataSource.defaultError.getFailure();
    }
  }

enum DataSource {
  success,
  noContent,
  badRequest,
  forbidden,
  unauthorised,
  notFound,
  internalServerError,
  connectTimeout,
  cancel,
  receiveTimeout,
  sendTimeout,
  cacheError,
  noInternetConnection,
  defaultError
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    // var mContext = navigatorKey!.currentState!.context;
    switch (this) {
      case DataSource.success:
        return Failure(ResponseCode.success, ResponseMessage.success.tr());
      case DataSource.noContent:
        return Failure(ResponseCode.noContent, ResponseMessage.noContent.tr());
      case DataSource.badRequest:
        return Failure(ResponseCode.badRequest, ResponseMessage.badRequest.tr());
      case DataSource.forbidden:
        return Failure(ResponseCode.forbidden, ResponseMessage.forbidden.tr());
      case DataSource.unauthorised:
        return Failure(ResponseCode.unauthorised, ResponseMessage.unauthorised.tr());
      case DataSource.notFound:
        return Failure(ResponseCode.notFound, ResponseMessage.notFound.tr());
      case DataSource.internalServerError:
        return Failure(ResponseCode.internalServerError, ResponseMessage.internalServerError.tr());
      case DataSource.connectTimeout:
        return Failure(ResponseCode.connectTimeout, ResponseMessage.connectTimeout.tr());
      case DataSource.cancel:
        return Failure(ResponseCode.cancel, ResponseMessage.cancel.tr());
      case DataSource.receiveTimeout:
        return Failure(ResponseCode.receiveTimeout, ResponseMessage.receiveTimeout.tr());
      case DataSource.sendTimeout:
        return Failure(ResponseCode.sendTimeout, ResponseMessage.sendTimeout.tr());
      case DataSource.cacheError:
        return Failure(ResponseCode.cacheError, ResponseMessage.cacheError.tr());
      case DataSource.noInternetConnection:
        return Failure(ResponseCode.noInternetConnection, ResponseMessage.noInternetConnection.tr());
      case DataSource.defaultError:
        return Failure(ResponseCode.defaultError, ResponseMessage.defaultError.tr());
    }
  }
}

class ResponseCode {
  static const int success = 200; // success with data
  static const int noContent = 201; // success with no data (no content)
  static const int badRequest = 400; // failure, API rejected request
  static const int unauthorised = 401; // failure, user is not authorised
  static const int forbidden = 403; //  failure, API rejected request
  static const int internalServerError = 500; // failure, crash in server side
  static const int notFound = 404; // failure, not found

  // local status code
  static const int connectTimeout = -1;
  static const int cancel = -2;
  static const int receiveTimeout = -3;
  static const int sendTimeout = -4;
  static const int cacheError = -5;
  static const int noInternetConnection = -6;
  static const int defaultError = -7;
}

class ResponseMessage {
  static const String success = AppError.success; // success with data
  static const String noContent = AppError.success; // success with no data (no content)
  static const String badRequest = AppError.strBadRequestError; // failure, API rejected request
  static const String unauthorised = AppError.strUnauthorizedError; // failure, user is not authorised
  static const String forbidden = AppError.strForbiddenError; //  failure, API rejected request
  static const String internalServerError = AppError.strInternalServerError; // failure, crash in server side
  static const String notFound = AppError.strNotFoundError; // failure, crash in server side

  // local status code
  static const String connectTimeout = AppError.strTimeoutError;
  static const String cancel = AppError.strDefaultError;
  static const String receiveTimeout = AppError.strTimeoutError;
  static const String sendTimeout = AppError.strTimeoutError;
  static const String cacheError = AppError.strCacheError;
  static const String noInternetConnection = AppError.strNoInternetError;
  static const String defaultError = AppError.strDefaultError;
}

class ApiInternalStatus {
  static const int success = 200;
  static const int failure = 400;
}


