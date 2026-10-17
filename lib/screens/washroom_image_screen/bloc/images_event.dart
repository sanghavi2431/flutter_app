import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ImagesEvent extends Equatable {
  const ImagesEvent();
}

class UploadImages extends ImagesEvent {
  final String type;
  final List<File>? image;
  final String id;
  final String allocationId;

  final String remarks;
  const UploadImages(
      {required this.type,
      required this.image,
      required this.id,
      required this.remarks,
      required this.allocationId});

  @override
  List<Object?> get props => [type, image, id, remarks, allocationId];
}
