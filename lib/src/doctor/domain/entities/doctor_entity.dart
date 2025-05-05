import 'package:autis/core/utils/enums/gender_enum.dart';

import '../../../../core/utils/enums/role_enum.dart';
import '../../../common/entitys/user_entity.dart';

class DoctorEntity extends UserEntity {
  final String licenseNumber;
  final bool isVerified;
  final String? specialization;

  const DoctorEntity({
    required super.uid,
    required super.email,
    required super.firstname,
    required super.lastname,
    required super.avatarUrl,
    required super.gender,
    required super.phone,
    required super.createdAt,
    required super.updatedAt,
    required this.licenseNumber,
    this.specialization,
    this.isVerified = false,
  }) : super(role: Role.doctor);

  factory DoctorEntity.fromJson(Map<String, dynamic> json) {
    return DoctorEntity(
      uid: json['uid'] as String,
      email: json['email'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      avatarUrl: json['avatarUrl'] as String,
      gender: GenderExtension.fromDisplayName(json['gender']),
      phone: json['phone'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      licenseNumber: json['licenseNumber'] as String,
      isVerified: json['isVerified'] as bool? ?? false,
      specialization: json['specialization'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'avatarUrl': avatarUrl,
      'gender': gender.name,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'role': role.name, // Just returns "doctor" without enum prefix
      'licenseNumber': licenseNumber,
      'isVerified': isVerified,
      'specialization': specialization,
    };
  }
}
