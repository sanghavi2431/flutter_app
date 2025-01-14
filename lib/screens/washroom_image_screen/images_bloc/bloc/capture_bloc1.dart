



import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

// import '../event/capture_event.dart';
import '../../../../core/network/error_handler.dart';
import '../event/capture_event1.dart';
// import '../state/capture_state.dart';
import '../state/capture_state1.dart';

class CaptureBloc1 extends Bloc<CaptureEvent1, CaptureState1> {
  CaptureBloc1() : super(AddImagesInitial1(),  ) {
    on<CaptureEvent1>((event, emit) {});
   // on<AddImages>(_addImageToState);
     on<AddImages1>(_addImage1ToState);
     on<RemoveImages1>(_removeImageToState);
    
  }



   FutureOr<void> _addImage1ToState(
      AddImages1 event, Emitter<CaptureState1> emit) async {
    try {
      emit(  AddImagesInitial1( ));

      print("image 1 data  ${event.file} ");

      if (event.file!.path.isNotEmpty) {
        emit(AddImagesSuccessful1(
          image: event.file
        ));
      }
    } catch (e) {
      emit(AddImagesError1(error: ErrorHandler.handle(e).failure ));
    }
  }

   FutureOr<void> _removeImageToState(
      RemoveImages1 event, Emitter<CaptureState1> emit) async {
    try {
      emit(const AddImagesLoading1(message: ""));

      event.file!.delete();

      emit(AddImagesInitial1());
    } catch (e) {
      emit(AddImagesError1(error:  ErrorHandler.handle(e).failure  ));
    }
  }


}
