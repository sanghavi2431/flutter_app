import 'package:equatable/equatable.dart';

import '../../data/model/profile_model.dart';




abstract class ProfileState extends Equatable {
  const ProfileState();
}

class Proflenitial extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfleLoading extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfleSuccess extends ProfileState {
  final ProfileModel data;
  const ProfleSuccess({
    required this.data,
  });

  @override
  List<Object?> get props => [data];
}

class ProfleError extends ProfileState {
  final String error;
  const ProfleError({required this.error});

  @override
  List<Object?> get props => [error];
}