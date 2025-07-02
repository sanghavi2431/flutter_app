import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/utils/logger.dart';

import '../../../../core/local/global_storage.dart';
import '../data/signup_service.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignUpState> {
  final SignupService signupService = SignupService(dio: GetIt.instance());
  var requestId = '';
  late int roleId;
  late int janitorId;
  //  List<UpdateTokenModel>? profileList;

  SignupBloc() : super(SignUpInitial()) {
    // on<LoginEvent>((event, emit) {});
    on<CreateClientEvent>(_mapSendOTPToState);
    on<VerifyOtpEvent>(_mapVerifyOTPToState);
    on<Login>(_maploginToState);
    on<ExpiryEvent>(_mapExtendExpiryState);
    on<Signup>(_mapSingUPToState);
    // on<UpdateTokenOnVerifyOTP>(mapUpdateTokenToState);
  }

  FutureOr<void> _mapSendOTPToState(
      CreateClientEvent event, Emitter<SignUpState> emit) async {
    try {
      emit(const SignUpLoading(message: "Sending OTP..."));

      var response = await signupService.creatClient(
        phoneNumber: event.mobileNumber,
        email: event.email,
        name: event.name,
        password: event.password,
        pincode: event.pincode,
        address: event.address,
        city: event.city,
      );
      debugPrint("requestId $response");
      requestId = response;

      // debugPrint("requestId $requestId");
      emit(CreateClient());
    } catch (e) {
      emit(SignUpError(error: e.toString()));
    }
  }

  FutureOr<void> _mapVerifyOTPToState(
      VerifyOtpEvent event, Emitter<SignUpState> emit) async {
    try {
      emit(const SignUpLoading(message: "Validating OTP...."));
      debugPrint("requestId$requestId");

      var response =
          await signupService.verifyOtp(otp: event.otp, requestId: requestId);

      GlobalStorage globalStorage = GetIt.instance();

      // debugPrint("tokennnnnn${response.results!.requestId}");

      await signupService.updateCustomer(token: response.results!.token!);

      // globalStorage.
      globalStorage.saveClientToken(accessToken: response.results!.token ?? '');
      // globalStorage.saveToken(accessToken: response.token ?? '');
      // globalStorage.saveJanitorId(accessId: response.results!.id!);
      // roleId = response.results.roleId!;
      globalStorage.saveRoleId(accessRoleId: response.results!.roleId!);
      // globalStorage.saveSupervisorName(
      //     accessSupervisorName: response.results!.name ?? '');
      globalStorage.saveClientMobileNo(
          accessClientMobileNo: response.results!.mobile ?? '');
      // globalStorage.saveCity(accessCity:  response.results!.city ?? '');
      // GlobalStorage globalStorage = GetIt.instance();

      // debugPrint("tokennnnnn${response.token}");
      // globalStorage.saveToken(accessToken: response.token ?? '');

      // debugPrint("Namee--------- ${response.roleId}");
      // debugPrint("iddddd${response.id}");

      emit(VerifyOTP(verfiyOtpModel: response));
    } catch (e) {
      // debugPrint(e.toString());
      emit(SignUpError(error: e.toString()));
    }
  }

  FutureOr<void> _mapSingUPToState(
      Signup event, Emitter<SignUpState> emit) async {
    try {
      emit(const SignUpLoading(message: "Validating OTP...."));
      debugPrint("sign up req $requestId");

      var response = await signupService.signUp(
          userId: event.userId.toString(),
          clientTypeId: event.clientTypeId,
          mobileNumber: event.mobileNumber
          // otp:event.otp,
          // requestId:requestId
          );
      // GlobalStorage globalStorage = GetIt.instance();

      // debugPrint("tokennnnnn${response.token}");
      // globalStorage.saveToken(accessToken: response.token ?? '');

      debugPrint("Namee--------- ${response}");
      // debugPrint("iddddd${response.id}");

      emit(RegisterUser(
          // verfiyOtpModel: response
          ));
    } catch (e) {
      // debugPrint(e.toString());
      emit(SignUpError(error: e.toString()));
    }
  }

  FutureOr<void> _maploginToState(
      Login event, Emitter<SignUpState> emit) async {
    try {
      emit(const SignUpLoading(message: "Validating OTP...."));
      debugPrint("requestId$requestId");

      var response = await signupService.sendOtp(mobileNo: event.mobileNo
          // email: event.email,
          // password: event.password,
          );

      requestId = response.results!.requestId!;
      // GlobalStorage globalStorage = GetIt.instance();

      // debugPrint("tokennnnnn${response.results!.requestId}");

      // globalStorage.
      //  globalStorage.saveClientToken(accessToken: response.results!.token ?? '');
      // // globalStorage.saveToken(accessToken: response.token ?? '');
      // globalStorage.saveJanitorId(accessId: response.results!.id!);
      // // roleId = response.results.roleId!;
      // globalStorage.saveRoleId(accessRoleId: response.results!.roleId!);
      // globalStorage.saveSupervisorName(
      //     accessSupervisorName: response.results!.name ?? '');
      //     globalStorage.saveClientMobileNo( accessClientMobileNo: response.results!.mobile ?? '');
      // globalStorage.saveCity(accessCity:  response.results!.city ?? '');
      // globalStorage.saveAddress(accessAddress: response.results!.address ?? '');
      // globalStorage.savePincode(accessPincode: response.results!.pincode ?? '');

      // debugPrint("Namee--------- ${response.roleId}");

      // debugPrint("iddddd${response.id}");

      emit(LoginUser());
    } catch (e) {
      print("is dio bloc  exception ${e is DioException}");
      debugPrint("debug print $e");
      emit(SignUpError(error: e.toString()));
    }
  }

  FutureOr<void> _mapExtendExpiryState(
      ExpiryEvent event, Emitter<SignUpState> emit) async {
    try {
      emit(const SignUpLoading(message: "Loading...."));
      // debugPrint("requestId$requestId");

      var response = await signupService.extendExpiry(
          clientId: event.clientId, days: event.days);

      // debugPrint("Namee--------- ${response.roleId}");

      // debugPrint("iddddd${response.id}");

      emit(ExtendExpiry());
    } catch (e) {
      print("is dio bloc  exception ${e is DioException}");
      debugPrint("debug print $e");
      emit(SignUpError(error: e.toString()));
    }
  }
}
