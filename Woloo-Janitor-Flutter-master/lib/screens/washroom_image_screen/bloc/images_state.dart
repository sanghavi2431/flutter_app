import 'package:woloo_smart_hygiene/core/network/failure.dart';
import 'package:equatable/equatable.dart';

abstract class ImagesState extends Equatable {
  const ImagesState();
}

class UploadImagesInitial extends ImagesState {
  @override
  List<Object> get props => [];
}

class UploadImagesLoading extends ImagesState {
  final String message;
  const UploadImagesLoading({required this.message});

  @override
  List<Object> get props => [];
}

class UploadImagesSuccessful extends ImagesState {
  @override
  List<Object> get props => [];
}

class UploadImagesError extends ImagesState {
  final Failure error;
  const UploadImagesError({required this.error});

  @override
  List<Object> get props => [error];
}
