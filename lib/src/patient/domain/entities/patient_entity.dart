import '../../../../core/utils/enums/gender_enum.dart';
import '../../../../core/utils/enums/role_enum.dart';
import '../../../common/entitys/user_entity.dart';

class PatientEntity extends UserEntity {
  const PatientEntity({
    required super.uid,
    required super.email,
    required super.firstname,
    required super.lastname,
    required super.avatarUrl,
    required super.dateOfBirth,
    required super.gender,
    required super.phone,
    required super.createdAt,
    required super.updatedAt,
  }) : super(role: Role.patient);

  factory PatientEntity.fromJson(Map<String, dynamic> json) {
    return PatientEntity(
      uid: json['uid'] as String,
      email: json['email'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      avatarUrl: json['avatarUrl'] as String,
      gender: GenderExtension.fromDisplayName(json['gender']),
      phone: json['phone'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : DateTime.now(),
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
      'role': role.name, // Returns "patient"
    };
  }

  int? get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }
}
