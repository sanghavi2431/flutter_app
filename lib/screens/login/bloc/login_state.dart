part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {
  final String message;
  const LoginLoading({required this.message});

  @override
  List<Object> get props => [Random().nextInt(100)];
}

class LoginOTPSent extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginOTPVerified extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginError extends LoginState {
  final String error;
  const LoginError({required this.error});

  @override
  List<Object> get props => [error];
}

class LoginGetDataSuccess extends LoginState {
  final List<String> data;
  const LoginGetDataSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class UpdateTokenLoading extends LoginState {
  @override
  List<Object?> get props => [];
}

class UpdateTokenSuccess extends LoginState {
  final List<UpdateTokenModel> data;
  const UpdateTokenSuccess({
    required this.data,
  });
  @override
  List<Object?> get props => [data];
}

class UpdateTokenError extends LoginState {
  final  Failure error;
  const UpdateTokenError({required this.error});

  @override
  List<Object?> get props => [error];
}
