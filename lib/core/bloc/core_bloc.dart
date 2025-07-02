import 'dart:async';

import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/client_model.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/core/network/error_handler.dart';
import 'package:woloo_smart_hygiene/core/service/core_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../network/failure.dart';

part 'core_event.dart';
part 'core_state.dart';

class CoreBloc extends Bloc<CoreEvent, CoreState> {
  final CoreService coreService = CoreService();
  final globalStorage = GetIt.instance<GlobalStorage>();

CoreBloc() : super(CoreInitial()) {
    on<CoreEvent>((event, emit) {});
    on<CheckUserIsLoggedInOrNot>(_mapCheckUserState);
    on<UpdateToken>(_mapUpdateTokenToState);
    on<ClientEvent>(_mapGetClientState);
  }

  FutureOr<void> _mapCheckUserState(CheckUserIsLoggedInOrNot event, Emitter<CoreState> emit) async {
    try {
      emit(CoreLoading());
    //  await Future.delayed(const Duration(seconds: 2));
      var token = globalStorage.getToken();
      var cilentToken = globalStorage.getClientToken();
      if (token.isNotEmpty || cilentToken.isNotEmpty  ) {
        emit(const CoreSuccess(isLoggedIn: true));
      } else {
        emit(const CoreSuccess(isLoggedIn: false));
      }
    } catch (e) {
      emit(const CoreSuccess(isLoggedIn: false));
    }
  }

  FutureOr<void> _mapUpdateTokenToState(UpdateToken event, Emitter<CoreState> emit) async {
    try {

      emit(UpdateTokenLoading());
  //    var token = globalStorage.getToken();
       //  print( " from strage $token");
   //   if (token.isNotEmpty) {
       var response =  await coreService.updateFCMToken(token: event.token.toString());
   //   }
           debugPrint("prooooooooo${response.first.profileImage}");
        globalStorage.saveProfile(profileName: response.first.name!);

        globalStorage.saveProfileImg(profileimg: response.first.profileImage!);
        globalStorage.saveShift(shift: response.first.startTime!);


      emit(UpdateTokenSuccess());
    } catch (e) {
      emit(UpdateTokenError(error: ErrorHandler.handle(e).failure  ));
    }
  }


      FutureOr<void> _mapGetClientState(
      ClientEvent event, Emitter<CoreState> emit) async {
    try {
      emit( UpdateTokenLoading());

      var response =
      await coreService.getClient(
         id: event.id
      );


          GlobalStorage globalStorage  = GetIt.instance();
      globalStorage.saveClientId( accessClientId: response.results!.client!.value.toString() );
          
   

      debugPrint("requestId $response");
      //  = response;


      emit(ClientSuccess(
        model: response
        // subscriptionModel:  response,
      ));

    } catch (e) {

      emit(UpdateTokenError(error:  ErrorHandler.handle(e).failure ));
    }
  }




}
