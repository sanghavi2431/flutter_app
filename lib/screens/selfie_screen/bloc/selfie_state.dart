import 'package:Woloo_Smart_hygiene/core/network/failure.dart';
import 'package:equatable/equatable.dart';

abstract class SelfieState extends Equatable {
  const SelfieState();
}

class UploadSelfieInitial extends SelfieState {
  @override
  List<Object> get props => [];
}

class UploadSelfieLoading extends SelfieState {
  final String message;
  const UploadSelfieLoading({required this.message});

  @override
  List<Object> get props => [];
}

class UploadSelfieSuccessful extends SelfieState {
  @override
  List<Object> get props => [];
}

class UploadSelfieError extends SelfieState {
  final Failure error;
  const UploadSelfieError({required this.error});

  @override
  List<Object> get props => [error];
}






