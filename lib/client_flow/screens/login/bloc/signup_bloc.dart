import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/local/global_storage.dart';
import '../../../../screens/login/data/network/login_services.dart';
import '../data/signup_service.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignUpState> {
  final SignupService signupService = SignupService(dio: GetIt.instance());
  final LoginService loginService = LoginService(dio: GetIt.instance());
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
    on<UserEvent>(_mapUserRoleState);
    on<SendOTP>(_mapSendOTPJanToState);
    on<VerifyOTPEvent>(_mapVerifyOTPJanToState);

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

      var response = await signupService.verifyOtp(otp: event.otp, requestId: requestId);

      GlobalStorage globalStorage = GetIt.instance();



      // await signupService.updateCustomer(token: response.results!.token!);

      // Save client token - check if token exists and is not empty
      final token = response.results!.token ?? '';
      if (token.isEmpty) {
        debugPrint("WARNING: Client token is empty in verify OTP response");
      } else {
        debugPrint("Client token received and saved (length: ${token.length})");
        debugPrint("tokennnnnn${response.results!.token}");
      }
      globalStorage.saveClientToken(accessToken: token);
      // globalStorage.saveToken(accessToken: response.token ?? '');
      // globalStorage.saveJanitorId(accessId: response.results!.id!);
      // roleId = response.results.roleId!;

      globalStorage.saveRoleId(accessRoleId: response.results!.roleId!);
      // globalStorage.saveSupervisorName(
      //     accessSupervisorName: response.results!.name ?? '');
      globalStorage.saveClientMobileNo(accessClientMobileNo: response.results!.mobile ?? '');
      // Save language codes if available
      if (response.results!.languageCodes != null &&
          response.results!.languageCodes!.isNotEmpty) {
        globalStorage.saveLanguageCodes(languageCodes: response.results!.languageCodes!);
      }
      // globalStorage.saveCity(accessCity:  response.results!.city ?? '');
      // GlobalStorage globalStorage = GetIt.instance();


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
          mobileNumber: event.mobileNumber,
          hostFacility: event.hostFacility,
          hostLocation: event.hostLocation,
          address: event.address,
          city: event.city,
          lat: event.lat,
          long: event.long,
          roleId: event.roleId,
          pincode: event.pincode,
          faciliyType: event.facilityType);

      debugPrint("Namee--------- ${response}");

      emit(RegisterUser());
    } catch (e) {
      emit(SignUpError(error: e.toString()));
    }
  }

  FutureOr<void> _maploginToState(
      Login event, Emitter<SignUpState> emit) async {
    try {
      emit(const SignUpLoading(message: "Validating OTP...."));
      debugPrint("requestId$requestId");

      var response = await signupService.sendOtp(mobileNo: event.mobileNo);

      requestId = response.results!.requestId!;

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

  FutureOr<void> _mapUserRoleState(
      UserEvent event, Emitter<SignUpState> emit) async {
    try {
      emit(const SignUpLoading(message: "Loading...."));
      // debugPrint("requestId$requestId");

      var response = await signupService.getUserRole(mobileNo: event.mobileNo);

      debugPrint("Namee--------- ${response}");

      // debugPrint("iddddd${response.id}");

      emit(UserRole(userRoleModel: response));
    } catch (e) {
      print("is dio bloc  exception ${e is DioException}");
      debugPrint("debug print $e");
      emit(SignUpError(error: e.toString()));
    }
  }

  FutureOr<void> _mapSendOTPJanToState(
      SendOTP event, Emitter<SignUpState> emit) async {
    try {
      emit(const LoginLoading(message: "Sending OTP..."));
      requestId = '';

      var response =
          await loginService.sendOTP(phoneNumber: event.mobileNumber);

      requestId = response.requestId.toString();

      emit(LoginOTPSent(
          // requestId: newRequestId
          ));
    } catch (e) {
      emit(LoginError(error: e.toString()));
    }
  }

  FutureOr<void> _mapVerifyOTPJanToState(
      VerifyOTPEvent event, Emitter<SignUpState> emit) async {
    try {
      emit(const LoginLoading(message: "Validating OTP...."));

      print("bloc state $state ");

      //  if (state is LoginOTPSent) {

      //    requestId = (state as LoginOTPSent).requestId!;

      //    }
      // BlocProvider.of<ModulesBloc>(context).myString;

      debugPrint("requestId verfiy otp $requestId");

      var response =
          await loginService.verifyOTP(otp: event.otp, requestId: requestId);
      GlobalStorage globalStorage = GetIt.instance();

      debugPrint("tokennnnnn${response.token}");
      debugPrint("VerifyOTP Janitor - Full response: ${response.toJson()}");
      debugPrint(
          "VerifyOTP Janitor - Response language codes type: ${response.languageCodes.runtimeType}");
      debugPrint(
          "VerifyOTP Janitor - Response language codes value: ${response.languageCodes}");
      debugPrint(
          "VerifyOTP Janitor - Response language codes is null: ${response.languageCodes == null}");
      debugPrint(
          "VerifyOTP Janitor - Response language codes isEmpty: ${response.languageCodes?.isEmpty ?? 'null'}");

      globalStorage.saveToken(accessToken: response.token ?? '');
      globalStorage.saveJanitorId(accessId: response.id!);
      roleId = response.roleId!;
      globalStorage.saveRoleId(accessRoleId: response.roleId!);
      globalStorage.saveSupervisorName(
          accessSupervisorName: response.name ?? '');
      // Save language codes if available and update locale
      debugPrint(
          "VerifyOTP Janitor - Response language codes: ${response.languageCodes}");
      if (response.languageCodes != null &&
          response.languageCodes!.isNotEmpty) {
        debugPrint(
            "VerifyOTP Janitor - Saving language codes: ${response.languageCodes}");
        globalStorage.saveLanguageCodes(languageCodes: response.languageCodes!);
        final savedCodes = globalStorage.getLanguageCodes();
        debugPrint("VerifyOTP Janitor - Language codes saved: $savedCodes");
        // Note: Locale update is handled in UI layer (didChangeDependencies) after EasyLocalization is ready
      } else {
        debugPrint(
            "VerifyOTP Janitor - No language codes in response or empty");
      }

      requestId = '';
      debugPrint("requestId$requestId");

      debugPrint("Namee--------- ${response.roleId}");

      debugPrint("iddddd${response.id}");

      emit(LoginOTPVerified());
    } catch (e) {
      debugPrint(e.toString());
      emit(LoginError(error: e.toString()));
    }
  }
}
