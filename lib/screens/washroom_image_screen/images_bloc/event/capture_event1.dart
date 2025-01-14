





import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class CaptureEvent1 extends Equatable {
  const CaptureEvent1();
}




class AddImages1 extends CaptureEvent1 {
  final File? file;
  const AddImages1( {required this.file,});
        

  @override
  List<Object?> get props => [ file, ];
}




class RemoveImages1 extends CaptureEvent1 {
  final File? file;
  const RemoveImages1( {required this.file,});
        

  @override
  List<Object?> get props => [ file, ];
}