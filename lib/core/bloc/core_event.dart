part of 'core_bloc.dart';

abstract class CoreEvent extends Equatable {
  const CoreEvent();
}

class CheckUserIsLoggedInOrNot extends CoreEvent {
  @override
  List<Object?> get props => [];
}

class UpdateToken extends CoreEvent {
  final String token;
  const UpdateToken({required this.token});

  @override
  List<Object?> get props => [];
}


class ClientEvent extends CoreEvent {
  final int id;
  const ClientEvent({required this.id});

  @override
  List<Object?> get props => [];
}