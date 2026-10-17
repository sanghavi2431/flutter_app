import 'dart:async';

import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/screens/my_account/data/model/profile_model.dart';
import 'package:woloo_smart_hygiene/screens/my_account/data/network/profile_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService profileService = ProfileService(dio: GetIt.instance());
  final globalStorage = GetIt.instance<GlobalStorage>();

  ProfileModel? _cachedProfile;
  int? _cachedProfileId;

  ProfileModel? get cachedProfile => _cachedProfile;

  ProfileBloc() : super(Proflenitial()) {
    on<ProfileEvent>((event, emit) {});
    on<UpdateProfile>(_mapUpdateProfileToState);
    on<UserCoinsEvent>(_mapgetUserCoinsToState);
    on<ClearProfileCache>(_mapClearProfileCache);
  }

  FutureOr<void> _mapClearProfileCache(
      ClearProfileCache event, Emitter<ProfileState> emit) {
    _cachedProfile = null;
    _cachedProfileId = null;
    emit(Proflenitial());
  }

  FutureOr<void> _mapUpdateProfileToState(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    try {
      if (!event.forceRefresh &&
          _cachedProfile != null &&
          _cachedProfileId == event.id) {
        emit(ProfleSuccess(data: _cachedProfile!));
        return;
      }

      emit(ProfleLoading());

      var response = await profileService.getProfile(supervisorId: event.id);

      _cachedProfile = response;
      _cachedProfileId = event.id;
      _persistProfile(response);

      emit(ProfleSuccess(data: response));
    } catch (e) {
      emit(ProfleError(error: e.toString()));
    }
  }

  void _persistProfile(ProfileModel response) {
    final results = response.results;
    if (results == null) return;

    final name = [
      results.firstName ?? '',
      results.lastName ?? '',
    ].where((s) => s.trim().isNotEmpty).join(' ').trim();
    if (name.isNotEmpty) {
      globalStorage.saveProfile(profileName: name);
    }
    if ((results.mobile ?? '').isNotEmpty) {
      globalStorage.saveMobileNumber(accessMobileNumber: results.mobile!);
    }
    if ((results.profileImage ?? '').isNotEmpty) {
      globalStorage.saveProfileImg(profileimg: results.profileImage!);
    }
    if (results.startTime != null) {
      final shift =
          '${results.startTime!.hour.toString().padLeft(2, '0')}:${results.startTime!.minute.toString().padLeft(2, '0')}';
      globalStorage.saveShift(shift: shift);
    }
  }

  FutureOr<void> _mapgetUserCoinsToState(
      UserCoinsEvent event, Emitter<ProfileState> emit) async {
    try {
      var response = await profileService.getTask(event.userId);
      emit(GetUserCoins(coinsModel: response));
    } catch (e) {
      emit(ProfleError(error: e.toString()));
    }
  }
}
