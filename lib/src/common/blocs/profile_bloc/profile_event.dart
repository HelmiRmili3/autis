import 'package:autis/src/common/entitys/user_entity.dart';

abstract class ProfileEvent {}

class GetProfile extends ProfileEvent {
  final String userId;
  GetProfile({required this.userId});
}

class UpdateProfile extends ProfileEvent {
  final List<UserEntity> profileData;
  UpdateProfile({required this.profileData});
}
