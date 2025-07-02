



import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class CaptureEvent extends Equatable {
  const CaptureEvent();
}




class AddImages extends CaptureEvent {
  final File? file;
  const AddImages( {required this.file,});
        

  @override
  List<Object?> get props => [ file, ];
}


class RemoveImages extends CaptureEvent {
  final File? file;
  const RemoveImages( {required this.file,});
        

  @override
  List<Object?> get props => [ file, ];
}




