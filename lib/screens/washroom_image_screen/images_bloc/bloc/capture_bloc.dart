import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/error_handler.dart';
import '../event/capture_event.dart';
import '../state/capture_state.dart';

class CaptureBloc extends Bloc<CaptureEvent, CaptureState> {
  CaptureBloc()
      : super(
          AddImagesInitial(),
        ) {
    on<CaptureEvent>((event, emit) {});
    on<AddImages>(_addImageToState);
    on<RemoveImages>(_removeImageToState);
  }

  FutureOr<void> _addImageToState(
      AddImages event, Emitter<CaptureState> emit) async {
    try {
      emit(AddImagesInitial());

      print("file capture imagdsfsfs  ${event.file} ");

      if (event.file!.path.isNotEmpty) {
        emit(AddImagesSuccessful(image: event.file));
      }
    } catch (e) {
      emit(AddImagesError(error: ErrorHandler.handle(e).failure ));
    }
  }

  FutureOr<void> _removeImageToState(
      RemoveImages event, Emitter<CaptureState> emit) async {
    try {
      emit(const AddImagesLoading(message: ""));

      event.file!.delete();

      emit(AddImagesInitial());
    } catch (e) {
      emit(AddImagesError(error: ErrorHandler.handle(e).failure ));
    }
  }
}
