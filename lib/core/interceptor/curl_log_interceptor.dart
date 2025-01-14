import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Middleware to log request and response
extension Curl on RequestOptions {
  String toCurl() {
    final components = ['curl -i'];
    components.add('\"${uri.toString()}\"');

    components.add('-X $method');

    headers.forEach((k, v) {
      if (k != 'Cookie') {
        components.add('-H \"$k: $v\"');
      }
    });

    var data = json.encode(this.data);
    if (data != '{}') {
      data = data.replaceAll('\"', '\\\"');
      components.add('-d \"$data\"');
    }

    return components.join('\\\n\t');
  }
}

extension ResponseCurl on Response {
  String toCurl() {
    final components = ['response'];

    components.add('Status: $statusCode');

    headers.forEach((k, v) {
      if (k != 'Cookie') {
        components.add('-H \"$k: $v\"');
      }
    });

    var data = json.encode(this.data);
    data = data.replaceAll('\"', '\\\"');
    components.add('-d \"$data\"');

    return components.join('\\\n\t');
  }
}

class CurlLogInterceptor extends PrettyDioLogger {
  CurlLogInterceptor({bool disableRequestBody =false})
      : super(
          requestBody: !disableRequestBody,
          requestHeader: true,
          responseHeader: true,
        );
}
