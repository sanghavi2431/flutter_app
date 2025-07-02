import 'package:equatable/equatable.dart';

import '../data/model/verify_otp_model.dart';


abstract class SignUpState extends Equatable {
  const SignUpState();
}

class SignUpInitial extends SignUpState {
  @override
  List<Object> get props => [];
}

class SignUpLoading extends SignUpState {
  final String message;
  const SignUpLoading({required this.message});

  @override
  List<Object> get props => [];
}

class CreateClient extends SignUpState {

  @override
  List<Object> get props => [];
}

class RegisterUser extends SignUpState {
  @override
  List<Object> get props => [];
}

class LoginUser extends SignUpState {
  @override
  List<Object> get props => [];
}

class VerifyOTP extends SignUpState {
  VerfiyOtpModel? verfiyOtpModel;
 
  VerifyOTP({this.verfiyOtpModel});

  @override
  List<Object> get props => [verfiyOtpModel!];
}

class ExtendExpiry extends SignUpState {
  @override
  List<Object> get props => [];
}


class SignUpError extends SignUpState {
  final String error;
  const SignUpError({required this.error});

  @override
  List<Object> get props => [error];
}