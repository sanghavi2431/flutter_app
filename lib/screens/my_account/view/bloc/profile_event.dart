


import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class UpdateProfile extends ProfileEvent {
  final int id;
  const UpdateProfile({required this.id});

  @override
  List<Object?> get props => [];
}
