import 'dart:async';

import 'package:Woloo_Smart_hygiene/screens/task_list/data/network/task_list_service.dart';
import 'package:Woloo_Smart_hygiene/screens/washroom_image_screen/bloc/images_event.dart';
import 'package:Woloo_Smart_hygiene/screens/washroom_image_screen/bloc/images_state.dart';
import 'package:Woloo_Smart_hygiene/screens/washroom_image_screen/data/network/submit_images_service.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/network/error_handler.dart';

class ImagesBloc extends Bloc<ImagesEvent, ImagesState> {
  final SubmitImagesService submitImagesService =
      SubmitImagesService(dio: GetIt.instance());
  final TaskListService taskListService =
      TaskListService(dio: GetIt.instance());

  // String requestId = '';
  // List<DashboardModelClass> data = [];

  ImagesBloc() : super(UploadImagesInitial()) {
    on<ImagesEvent>((event, emit) {});
    on<UploadImages>(_mapUploadImagesToState);
  }

  FutureOr<void> _mapUploadImagesToState(
      UploadImages event, Emitter<ImagesState> emit) async {
    try {

      emit(const UploadImagesLoading(message: ""));

      var response = await submitImagesService.uploadImages(
        type: event.type,
        images: event.image!,
        id: event.id,
        remarks: event.remarks,
      );

      await submitImagesService.updateStatus(
          id: event.allocationId, status: "6");
          

      print("responseeee  ------  $response");
      emit(UploadImagesSuccessful());
    } catch (e) {

      emit(UploadImagesError(error: ErrorHandler.handle(e).failure  ));
    }
  }
}
