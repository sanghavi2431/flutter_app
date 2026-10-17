import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class UpdateProfile extends ProfileEvent {
  final int id;

  /// When false, reuse [ProfileBloc] cache if available (no network).
  final bool forceRefresh;

  const UpdateProfile({required this.id, this.forceRefresh = false});

  @override
  List<Object?> get props => [id, forceRefresh];
}

class UserCoinsEvent extends ProfileEvent {
  final String userId;
  const UserCoinsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ClearProfileCache extends ProfileEvent {
  const ClearProfileCache();

  @override
  List<Object?> get props => [];
}
