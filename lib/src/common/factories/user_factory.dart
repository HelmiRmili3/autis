// factories/user_factory.dart
import 'package:autis/src/admin/domain/entities/admin_entity.dart';
import 'package:uuid/uuid.dart';
import '../../../core/utils/enums/gender_enum.dart';
import '../../doctor/domain/entities/doctor_entity.dart';
import '../../patient/domain/entities/patient_entity.dart';

class UserFactory {
  static const _uuid = Uuid();
  // Create users functions
  static PatientEntity createPatient({
    required String email,
    required String firstname,
    required String lastname,
    required String avatarUrl,
    required Gender gender,
    required String malady,
    DateTime? dateOfBirth,
    String? phone,
  }) {
    final now = DateTime.now();
    return PatientEntity(
      uid: _uuid.v4(),
      email: email,
      firstname: firstname,
      lastname: lastname,
      avatarUrl: avatarUrl,
      gender: gender,
      phone: phone,
      dateOfBirth: dateOfBirth,
      createdAt: now,
      updatedAt: now,
    );
  }

  static DoctorEntity createDoctor({
    required String email,
    required String firstname,
    required String lastname,
    required String avatarUrl,
    required Gender gender,
    required String phone,
    required String licenseNumber,
    required String specialization,
  }) {
    final now = DateTime.now();
    return DoctorEntity(
      uid: _uuid.v4(),
      email: email,
      firstname: firstname,
      lastname: lastname,
      avatarUrl: avatarUrl,
      gender: gender,
      phone: phone,
      licenseNumber: licenseNumber,
      specialization: specialization,
      createdAt: now,
      updatedAt: now,
    );
  }

  static AdminEntity createAdmin({
    required String email,
    required String firstname,
    required String lastname,
    required String avatarUrl,
    required Gender gender,
    required List<String> systemPermissions,
    String? adminLevel,
  }) {
    final now = DateTime.now();
    return AdminEntity(
      uid: _uuid.v4(),
      email: email,
      firstname: firstname,
      lastname: lastname,
      avatarUrl: avatarUrl,
      gender: gender,
      createdAt: now,
      updatedAt: now,
    );
  }

  // Upate user information
  // These functions are used to update existing user entities with new information.
  static PatientEntity updatePatient({
    required PatientEntity original,
    String? email,
    String? firstname,
    String? lastname,
    String? phone,
    String? malady,
    String? avatarUrl,
    Gender? gender,
    DateTime? dateOfBirth,
  }) {
    return PatientEntity(
      uid: original.uid, // Keep the same ID
      email: email ?? original.email,
      firstname: firstname ?? original.firstname,
      lastname: lastname ?? original.lastname,
      avatarUrl: avatarUrl ?? original.avatarUrl,
      gender: gender ?? original.gender,
      phone: phone ?? original.phone,
      createdAt: original.createdAt, // Original creation time
      updatedAt: DateTime.now(), // Update the modification time
      dateOfBirth: dateOfBirth ?? original.dateOfBirth,
    );
  }

  static DoctorEntity updateDoctor({
    required DoctorEntity original,
    String? email,
    String? firstname,
    String? lastname,
    String? avatarUrl,
    Gender? gender,
    String? phone,
    String? licenseNumber,
    String? specialization,
  }) {
    return DoctorEntity(
      uid: original.uid,
      email: email ?? original.email,
      firstname: firstname ?? original.firstname,
      lastname: lastname ?? original.lastname,
      avatarUrl: avatarUrl ?? original.avatarUrl,
      gender: gender ?? original.gender,
      phone: phone ?? original.phone,
      createdAt: original.createdAt,
      updatedAt: DateTime.now(),
      licenseNumber: licenseNumber ?? original.licenseNumber,
      specialization: specialization ?? original.specialization,
    );
  }

  static AdminEntity updateAdmin({
    required AdminEntity original,
    String? email,
    String? firstname,
    String? lastname,
    String? avatarUrl,
    Gender? gender,
    List<String>? systemPermissions,
    String? adminLevel,
  }) {
    return AdminEntity(
      uid: original.uid,
      email: email ?? original.email,
      firstname: firstname ?? original.firstname,
      lastname: lastname ?? original.lastname,
      avatarUrl: avatarUrl ?? original.avatarUrl,
      gender: gender ?? original.gender,
      createdAt: original.createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
