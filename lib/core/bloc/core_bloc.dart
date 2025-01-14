import 'dart:async';

import 'package:Woloo_Smart_hygiene/core/local/global_storage.dart';
import 'package:Woloo_Smart_hygiene/core/service/core_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'core_event.dart';
part 'core_state.dart';

class CoreBloc extends Bloc<CoreEvent, CoreState> {
  final CoreService coreService = CoreService();
  final globalStorage = GetIt.instance<GlobalStorage>();

CoreBloc() : super(CoreInitial()) {
    on<CoreEvent>((event, emit) {});
    on<CheckUserIsLoggedInOrNot>(_mapCheckUserState);
    on<UpdateToken>(_mapUpdateTokenToState);
  }

  FutureOr<void> _mapCheckUserState(CheckUserIsLoggedInOrNot event, Emitter<CoreState> emit) async {
    try {
      emit(CoreLoading());
    //  await Future.delayed(const Duration(seconds: 2));
      var token = globalStorage.getToken();
      if (token.isNotEmpty) {
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
           print("prooooooooo${response.first.profileImage}");
        globalStorage.saveProfile(profileName: response.first.name!);

        globalStorage.saveProfileImg(profileimg: response.first.profileImage!);
        globalStorage.saveShift(shift: response.first.startTime!);


      emit(UpdateTokenSuccess());
    } catch (e) {
      emit(UpdateTokenError(error: e.toString()));
    }
  }
}
