


import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class CaptureEvent2 extends Equatable {
  const CaptureEvent2();
}




class AddImages2 extends CaptureEvent2 {
  final File? file;
  const AddImages2( {required this.file,});
        

  @override
  List<Object?> get props => [ file, ];
}


class RemoveImages2 extends CaptureEvent2 {
  final File? file;
  const RemoveImages2( {required this.file,});
        

  @override
  List<Object?> get props => [ file, ];
}