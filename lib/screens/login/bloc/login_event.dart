part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class SendOTP extends LoginEvent {
  final String mobileNumber;
  const SendOTP({required this.mobileNumber});

  @override
  List<Object?> get props => [mobileNumber];
}

class VerifyOTP extends LoginEvent {
  final String otp;
  const VerifyOTP({required this.otp});

  @override
  List<Object?> get props => [otp];
}

class UpdateTokenOnVerifyOTP extends LoginEvent {
  final String token;
  const UpdateTokenOnVerifyOTP({required this.token});

  @override
  List<Object?> get props => [token];
}
