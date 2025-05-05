abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final String profilePictureUrl;

  ProfileLoaded({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.profilePictureUrl,
  });
}

class ProfileUpdateSuccess extends ProfileState {
  final String message;

  ProfileUpdateSuccess(this.message);
}

class ProfileFailure extends ProfileState {
  final String error;

  ProfileFailure(this.error);
}

class ProfilePictureUpdateSuccess extends ProfileState {
  final String message;

  ProfilePictureUpdateSuccess(this.message);
}

class ProfilePictureUpdateFailure extends ProfileState {
  final String error;

  ProfilePictureUpdateFailure(this.error);
}
