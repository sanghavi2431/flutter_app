
import 'dart:async';

import 'package:Woloo_Smart_hygiene/core/local/global_storage.dart';
import 'package:Woloo_Smart_hygiene/core/service/core_service.dart';
import 'package:Woloo_Smart_hygiene/screens/my_account/data/network/profile_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'profile_event.dart';
import 'profile_state.dart';



class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService profileService = ProfileService( dio: GetIt.instance());
  final globalStorage = GetIt.instance<GlobalStorage>();

ProfileBloc() : super(Proflenitial()) {
    on<ProfileEvent>((event, emit) {});
    // on<CheckUserIsLoggedInOrNot>(_mapCheckUserState);
    on<UpdateProfile>(_mapUpdateTokenToState);
  }

  // FutureOr<void> _mapCheckUserState(CheckUserIsLoggedInOrNot event, Emitter<CoreState> emit) async {
  //   try {
  //     emit(CoreLoading());
  //     await Future.delayed(const Duration(seconds: 2));
  //     var token = globalStorage.getToken();
  //     if (token.isNotEmpty) {
  //       emit(const CoreSuccess(isLoggedIn: true));
  //     } else {
  //       emit(const CoreSuccess(isLoggedIn: false));
  //     }
  //   } catch (e) {
  //     emit(const CoreSuccess(isLoggedIn: false));
  //   }
  // }

  FutureOr<void> _mapUpdateTokenToState(UpdateProfile event, Emitter<ProfileState> emit) async {
    try {

      emit(ProfleLoading());
  //    var token = globalStorage.getToken();
       //  print( " from strage $token");
   //   if (token.isNotEmpty) {
   
       var response =  await profileService.getProfile(supervisorId: event.id );
   //   }
        //   print("prooooooooo${response.first.profileImage}");
        // globalStorage.saveProfile(profileName: response.first.name!);

        // globalStorage.saveProfileImg(profileimg: response.first.profileImage!);
        // globalStorage.saveShift(profileimg: response.first.startTime!);


      emit(ProfleSuccess(
        data: response
      ));
    } catch (e) {
      emit(ProfleError(error: e.toString()));
    }
  }
}
