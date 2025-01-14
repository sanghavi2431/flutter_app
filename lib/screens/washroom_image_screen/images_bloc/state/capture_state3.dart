

import 'dart:io';

import 'package:Woloo_Smart_hygiene/core/network/failure.dart';
import 'package:equatable/equatable.dart';

abstract class CaptureState3 extends Equatable {
  const CaptureState3();
}




class AddImagesInitial3 extends CaptureState3 {
  @override
  List<Object> get props => [];
}


class AddImagesLoading3 extends CaptureState3 {
   final String? message;
const AddImagesLoading3({ required this.message});
 
  @override
  List<Object> get props => [];
}


class AddImagesSuccessful3 extends CaptureState3 {
  File? image;
  AddImagesSuccessful3({required this.image }); 
  @override
  List<Object> get props => [image!];
}


class AddImagesError3 extends CaptureState3 {
  final Failure error;
  const AddImagesError3({required this.error});

  @override
  List<Object> get props => [error];
}