import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HeaderOptions {

  /// ---- Generic Auth (NO isSupervisor) ----
  static Options authOnly() {
    return Options(
      extra: {
        "auth": true,
      },
    );
  }

  static Options clientAuthWithToken(String token) {
    return Options(
      headers: {
        "x-woloo-token": token,
      },
      extra: {
        "auth": true,
        "isSupervisor": false,
      },
    );
  }

  /// ---- Supervisor WITHOUT token ----

  static Options supervisorAuth({String? token}) {
    return Options(
      headers: token != null
          ? {"x-woloo-token": token}
          : null,
      extra: {
        "auth": true,
        "isSupervisor": true,
      },
    );
  }

  /// ---- Supervisor WITH token ----

  static Options supervisorAuthWithToken(String token) {
    return Options(
      headers: {
        "x-woloo-token": token,
      },
      extra: {
        "auth": true,
        "isSupervisor": true,
      },
    );
  }

  /// ---- Client signup header ----

  static Options clientSignUpHeader(){
    return Options(
    headers: {
    "x-api-key": "k45GQj8FtKt0NR074UfFyvCEPAfJBzxY",
    "Content-Type": "application/json",
    },
    );
  }


  /// options: token != null
  ///   ? Options(headers: {"x-woloo-token": token})
  ///   : Options(extra: {"auth": true})
  static Options tokenOrAuthOnly({String? token}) {
    return token != null
        ? Options(
      headers: {"x-woloo-token": token},
    )
        : Options(
      extra: {"auth": true},
    );
  }


  static Options authUserOptions() {
    return Options(
      extra: {
        "auth": true,
        "isSupervisor": false,
      },
    );
  }

  static Options authWithFacilityId({
    int? facilityId,
    String? token,
  }) {
    return Options(
      headers: token != null
          ? {"x-woloo-token": token}
          : null,
      extra: {
        "auth": true,
        "isSupervisor": facilityId != null,
      },
    );
  }


}
