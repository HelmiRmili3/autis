import '../../../core/utils/enums/gender_enum.dart';
import '../../../core/utils/enums/role_enum.dart';

class UserProfileEntity {
  String uid;
  String email;
  String firstName;
  String lastName;
  String? phone;
  Gender gender;
  String? avatarUrl;
  String? location;
  Role role;

  UserProfileEntity({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    required this.gender,
    required this.role,
    this.avatarUrl,
    this.location,
  });
}
