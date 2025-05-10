import 'package:autis/core/utils/enums/gender_enum.dart';
import 'package:autis/core/utils/enums/role_enum.dart';

class CreateUserParams {
  String? uid;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final Gender gender;
  final Role role;
  final String password;
  final DateTime? dateOfBirth;
  final String? specialization;

  CreateUserParams({
    this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.gender,
    required this.role,
    this.dateOfBirth,
    this.specialization,
  });

  // CopyWith method
  CreateUserParams copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? password,
    Gender? gender,
    Role? role,
    DateTime? dateOfBirth,
    String? specialization,
  }) {
    return CreateUserParams(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      gender: gender ?? this.gender,
      role: role ?? this.role,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      specialization: specialization ?? this.specialization,
    );
  }

  // ToJson method
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'gender': gender.toString().split('.').last, // Converts enum to string
      'role': role.toString().split('.').last, // Converts enum to string
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'specialization': specialization,
      // Note: You might not want to include password in JSON for security
    };
  }

  // Optional: fromJson factory constructor
  factory CreateUserParams.fromJson(Map<String, dynamic> json) {
    return CreateUserParams(
      uid: json['uid'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String,
      gender: Gender.values.firstWhere(
        (e) => e.toString() == 'Gender.${json['gender']}',
        orElse: () => Gender.preferNotToSay,
      ),
      role: Role.values.firstWhere(
        (e) => e.toString() == 'Role.${json['role']}',
        orElse: () => Role.patient,
      ),
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      specialization: json['specialization'] as String?,
    );
  }

  // Optional: Override toString for better debugging
  @override
  String toString() {
    return 'CreateUserParams(uid: $uid, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, gender: $gender, role: $role, dateOfBirth: $dateOfBirth, specialization: $specialization)';
  }
}
