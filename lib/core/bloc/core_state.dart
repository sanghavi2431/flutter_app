part of 'core_bloc.dart';

abstract class CoreState extends Equatable {
  const CoreState();
}

class CoreInitial extends CoreState {
  @override
  List<Object> get props => [];
}

class CoreLoading extends CoreState {
  @override
  List<Object?> get props => [];
}

class CoreSuccess extends CoreState {
  final bool isLoggedIn;
  const CoreSuccess({
    required this.isLoggedIn,
  });

  @override
  List<Object?> get props => [isLoggedIn];
}

class CoreError extends CoreState {
  final String error;
  const CoreError({required this.error});

  @override
  List<Object?> get props => [error];
}

class UpdateTokenLoading extends CoreState {
  @override
  List<Object?> get props => [];
}

class UpdateTokenSuccess extends CoreState {
  @override
  List<Object?> get props => [];
}

class UpdateTokenError extends CoreState {
  final String error;
  const UpdateTokenError({required this.error});

  @override
  List<Object?> get props => [error];
}
