import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/error_handler.dart';
import '../event/capture_event2.dart';
// import '../state/capture_state.dart';
import '../state/capture_state2.dart';

class CaptureBloc2 extends Bloc<CaptureEvent2, CaptureState2> {
  CaptureBloc2()
      : super(
          AddImagesInitial2(),
        ) {
    on<CaptureEvent2>((event, emit) {});
    // on<AddImages>(_addImageToState);
    on<AddImages2>(_addImage1ToState);
    on<RemoveImages2>(_removeImageToState);
  }

  FutureOr<void> _addImage1ToState(
      AddImages2 event, Emitter<CaptureState2> emit) async {
    try {
      emit(AddImagesInitial2());

      print("image 1 data  ${event.file} ");

      if (event.file!.path.isNotEmpty) {
        emit(AddImagesSuccessful2(image: event.file));
      }
    } catch (e) {
      emit(AddImagesError2(error: ErrorHandler.handle(e).failure ));
    }
  }

  FutureOr<void> _removeImageToState(
      RemoveImages2 event, Emitter<CaptureState2> emit) async {
    try {
      emit(const AddImagesLoading2(message: ""));
            print("error");
      event.file!.delete();

      emit(AddImagesInitial2());
    } catch (e) {
      emit(AddImagesError2(error: ErrorHandler.handle(e).failure ));
    }
  }
}
