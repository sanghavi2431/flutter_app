import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/error_handler.dart';
// import '../state/capture_state.dart';
import '../event/capture_event3.dart';
import '../state/capture_state3.dart';

class CaptureBloc3 extends Bloc<CaptureEvent3, CaptureState3> {
  CaptureBloc3()
      : super(
          AddImagesInitial3(),
        ) {
    on<CaptureEvent3>((event, emit) {});
    // on<AddImages>(_addImageToState);
    on<AddImages3>(_addImage1ToState);
    on<RemoveImages3>(_removeImageToState);
  }

  FutureOr<void> _addImage1ToState(
      AddImages3 event, Emitter<CaptureState3> emit) async {
    try {
      emit(AddImagesInitial3());

      print("image 1 data  ${event.file} ");

      if (event.file!.path.isNotEmpty) {
        emit(AddImagesSuccessful3(image: event.file));
      }
    } catch (e) {
      emit(AddImagesError3(error: ErrorHandler.handle(e).failure  ));
    }
  }

  FutureOr<void> _removeImageToState(
      RemoveImages3 event, Emitter<CaptureState3> emit) async {
    try {
      emit(const AddImagesLoading3(message: ""));
            print("error");
      event.file!.delete();

      emit(AddImagesInitial3());
    } catch (e) {
      emit(AddImagesError3(error: ErrorHandler.handle(e).failure ));
    }
  }
}
