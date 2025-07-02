import 'dart:async';

import 'package:woloo_smart_hygiene/screens/selfie_screen/bloc/selfie_event.dart';
import 'package:woloo_smart_hygiene/screens/selfie_screen/bloc/selfie_state.dart';
import 'package:woloo_smart_hygiene/screens/selfie_screen/data/network/selfie_service.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/network/error_handler.dart';

class SelfieBloc extends Bloc<SelfieEvent, SelfieState> {
  final SelfieService selfieService = SelfieService(dio: GetIt.instance());
  // String requestId = '';
  // List<DashboardModelClass> data = [];

  SelfieBloc() : super(UploadSelfieInitial()) {
    on<SelfieEvent>((event, emit) {});
    on<UploadSelfie>(_mapUploadSelfieToState);
  }

  FutureOr<void> _mapUploadSelfieToState(
      UploadSelfie event, Emitter<SelfieState> emit) async {
    try {
      emit(const UploadSelfieLoading(message: ""));
      debugPrint("type   ${event.type}");
      debugPrint("type   ${event.id}");
      var response = await selfieService.uploadSelfie(
        type: event.type,
        image: event.image,
        id:  event.id,
        remarks: event.remarks,
      );
      
        Future.delayed( const Duration( seconds: 2 ) );

      debugPrint("responseeee image  upload  ------  $response");
      emit(UploadSelfieSuccessful());
    } catch (e) {
      emit(UploadSelfieError(error: ErrorHandler.handle(e).failure  ));
    }
  }
  
}

