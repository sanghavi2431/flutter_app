import 'dart:async';
import 'dart:math';

import 'package:woloo_smart_hygiene/core/network/failure.dart';
import 'package:woloo_smart_hygiene/screens/login/data/model/update_token_model.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/screens/login/data/network/login_services.dart';


part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginService loginService = LoginService(dio: GetIt.instance());
  String requestId = '';
  late int roleId;
  late int janitorId;
   List<UpdateTokenModel>? profileList;

  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) {});
    on<SendOTP>(_mapSendOTPToState);
    on<VerifyOTP>(_mapVerifyOTPToState);
   // on<UpdateTokenOnVerifyOTP>(mapUpdateTokenToState);
  }

  FutureOr<void> _mapSendOTPToState(
      SendOTP event, Emitter<LoginState> emit) async {
    try {
      emit(const LoginLoading(message: "Sending OTP..."));

      var response =
          await loginService.sendOTP(phoneNumber: event.mobileNumber);

      requestId = response.requestId.toString();

      debugPrint("requestId $requestId");
      emit(LoginOTPSent());
    } catch (e) {
      emit(LoginError(error:  e.toString() ));
    }
  }

  FutureOr<void> _mapVerifyOTPToState(
      VerifyOTP event, Emitter<LoginState> emit) async {
    try {
      emit(const LoginLoading(message: "Validating OTP...."));
      debugPrint("requestId$requestId");

      var response =
          await loginService.verifyOTP(otp: event.otp, requestId: requestId);
      GlobalStorage globalStorage = GetIt.instance();

      debugPrint("tokennnnnn${response.token}");
      globalStorage.saveToken(accessToken: response.token ?? '');
      globalStorage.saveJanitorId(accessId: response.id!);
      roleId = response.roleId!;
      globalStorage.saveRoleId(accessRoleId: response.roleId!);
      globalStorage.saveSupervisorName(
          accessSupervisorName: response.name ?? '');

      debugPrint("Namee--------- ${response.roleId}");

      debugPrint("iddddd${response.id}");

      emit(LoginOTPVerified());
    } catch (e) {
      debugPrint(e.toString());
      emit(LoginError(error: e.toString() ));
    }
  }

  // FutureOr<void> mapUpdateTokenToState(
  //     UpdateTokenOnVerifyOTP event, Emitter<LoginState> emit) async {
  //   try {
  //     emit(UpdateTokenLoading());

  //     var firebase = FirebaseMessaging.instance;
  //     var token = await firebase.getToken();
  //     var response = await loginService.updateFCMToken(token: token ?? '');
  //     GlobalStorage globalStorage = GetIt.instance();
  //     print("updateTokenResponse  --------> $response");
  //     print("profile imagesssssss  --------> ${response.first.profileImage }");
  //          profileList = response;

  //    // globalStorage.saveProfile(profileName: response.first.name!);
  //     //globalStorage.saveToken(  accessToken: response.first.!);

  //    // globalStorage.saveProfileImg(profileimg: response.first.profileImage!);
  //     print("profile names  -------->$profileList");
  //     emit(UpdateTokenSuccess(data: response));
  //   } catch (e) {
  //        print("eeeee$e");
  //     emit(UpdateTokenError(error: ErrorHandler.handle(e).failure ));
  //   }
  // }
}
