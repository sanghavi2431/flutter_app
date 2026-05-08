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

class UserCoinsEvent extends ProfileEvent {
  // final CoinsModel  coinsModel;
  final String userId;
  // final String email;
  // final String password;
  const UserCoinsEvent({required this.userId});

  @override
  List<Object?> get props => [
        // coinsModel
        userId
      ];
}
