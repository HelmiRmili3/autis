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
  final DateTime dateOfBirth;
  final Role role;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.avatarUrl,
    required this.gender,
    required this.dateOfBirth,
    required this.role,
    this.phone,
    this.location,
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
      'dateOfBirth': dateOfBirth.toIso8601String(),
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
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
      role: Role.fromJson(map['role']),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  bool get isAdmin => role == Role.admin;
  bool get isDoctor => role == Role.doctor;
  bool get isPatient => role == Role.patient;
}
