

import 'dart:io';

import 'package:woloo_smart_hygiene/core/network/failure.dart';
import 'package:equatable/equatable.dart';

abstract class CaptureState extends Equatable {
  const CaptureState();
}


class AddImagesInitial extends CaptureState {
 
  @override
  List<Object> get props => [];
}



class AddImagesLoading extends CaptureState {
   final String? message;
const AddImagesLoading({ required this.message});
 
  @override
  List<Object> get props => [];
}


class AddImagesSuccessful extends CaptureState {
  final File? image;
  const AddImagesSuccessful({required this.image }); 
  @override
  List<Object> get props => [image!];
}



class AddImagesError extends CaptureState {
  final Failure error;
  const AddImagesError({required this.error});

  @override
  List<Object> get props => [error];
}