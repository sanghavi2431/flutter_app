
import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class CaptureEvent3 extends Equatable {
  const CaptureEvent3();
}




class AddImages3 extends CaptureEvent3 {
  final File? file;
  const AddImages3( {required this.file,});
        

  @override
  List<Object?> get props => [ file, ];
}


class RemoveImages3 extends CaptureEvent3 {
  final File? file;
  const RemoveImages3( {required this.file,});
        

  @override
  List<Object?> get props => [ file, ];
}