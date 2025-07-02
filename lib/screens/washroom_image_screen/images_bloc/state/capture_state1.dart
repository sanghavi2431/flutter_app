import 'dart:io';
import 'package:woloo_smart_hygiene/core/network/failure.dart';
import 'package:equatable/equatable.dart';

abstract class CaptureState1 extends Equatable {
  const CaptureState1();
}

class AddImagesInitial1 extends CaptureState1 {
  @override
  List<Object> get props => [];
}

class AddImagesLoading1 extends CaptureState1 {
   final String? message;
const AddImagesLoading1({ required this.message});
 
  @override
  List<Object> get props => [];
}


class AddImagesSuccessful1 extends CaptureState1 {
 final File? image;
 const AddImagesSuccessful1({required this.image }); 
  @override
  List<Object> get props => [image!];
}


class AddImagesError1 extends CaptureState1 {
  final Failure error;
  const AddImagesError1({required this.error});

  @override
  List<Object> get props => [error];
}