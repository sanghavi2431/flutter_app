import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class SelfieEvent extends Equatable {
  const SelfieEvent();
}

class UploadSelfie extends SelfieEvent {
  final String type;
  final File image;
  final String id;
  final String remarks;
  const UploadSelfie({
    required this.type,
    required this.image,
    required this.id,
    required this.remarks,
  });

  @override
  List<Object?> get props => [
        type,
        image,
        id,
        remarks,
      ];
}

