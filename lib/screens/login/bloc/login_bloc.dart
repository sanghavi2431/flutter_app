import 'dart:async';
import 'dart:math';

import 'package:Woloo_Smart_hygiene/core/network/failure.dart';
import 'package:Woloo_Smart_hygiene/screens/login/data/model/Update_token_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:Woloo_Smart_hygiene/core/local/global_storage.dart';
import 'package:Woloo_Smart_hygiene/screens/login/data/network/login_services.dart';

import '../../../core/network/error_handler.dart';

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

      print("requestId $requestId");
      emit(LoginOTPSent());
    } catch (e) {
      emit(LoginError(error:  ErrorHandler.handle(e).failure ));
    }
  }

  FutureOr<void> _mapVerifyOTPToState(
      VerifyOTP event, Emitter<LoginState> emit) async {
    try {
      emit(const LoginLoading(message: "Validating OTP...."));
      print("requestId" + requestId);

      var response =
          await loginService.verifyOTP(otp: event.otp, requestId: requestId);
      GlobalStorage globalStorage = GetIt.instance();

      print("tokennnnnn" + response.token.toString());
      globalStorage.saveToken(accessToken: response.token ?? '');
      globalStorage.saveJanitorId(accessId: response.id!);
      roleId = response.roleId!;
      globalStorage.saveRoleId(accessRoleId: response.roleId!);
      globalStorage.saveSupervisorName(
          accessSupervisorName: response.name ?? '');

      print("Namee--------- " + response.roleId.toString());

      print("iddddd" + response.id.toString());

      emit(LoginOTPVerified());
    } catch (e) {
      print(e.toString());
      emit(LoginError(error: ErrorHandler.handle(e).failure ));
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
