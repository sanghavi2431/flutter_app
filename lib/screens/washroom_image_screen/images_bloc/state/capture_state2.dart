

import 'dart:io';

import 'package:Woloo_Smart_hygiene/core/network/failure.dart';
import 'package:equatable/equatable.dart';

abstract class CaptureState2 extends Equatable {
  const CaptureState2();
}




class AddImagesInitial2 extends CaptureState2 {
  @override
  List<Object> get props => [];
}


class AddImagesLoading2 extends CaptureState2 {
   final String? message;
const AddImagesLoading2({ required this.message});
 
  @override
  List<Object> get props => [];
}


class AddImagesSuccessful2 extends CaptureState2 {
  File? image;
  AddImagesSuccessful2({required this.image }); 
  @override
  List<Object> get props => [image!];
}


class AddImagesError2 extends CaptureState2 {
  final Failure error;
  const AddImagesError2({required this.error});

  @override
  List<Object> get props => [error];
}