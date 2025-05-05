import '../../../core/utils/enums/gender_enum.dart';
import '../../../core/utils/enums/role_enum.dart';

class UserEntity {
  final String uid;
  final String email;
  final String firstname;
  final String lastname;
  final String? phone;
  final String? location;
  final String avatarUrl;
  final Gender gender;
  final Role role;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.firstname,
    required this.lastname,
    this.phone,
    this.location,
    required this.avatarUrl,
    required this.gender,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      'location': location,
      'avatarUrl': avatarUrl,
      'gender': gender.toString().split('.').last,
      'role': role.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      phone: map['phone'],
      location: map['location'],
      avatarUrl: map['avatarUrl'] ?? '',
      gender: GenderExtension.fromDisplayName(map['gender']),
      role: Role.fromJson(map['role']),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  bool get isAdmin => role == Role.admin;
  bool get isDoctor => role == Role.doctor;
  bool get isPatient => role == Role.patient;
}
