import 'package:autis/src/doctor/domain/entities/doctor_entity.dart';
import 'package:autis/src/patient/domain/entities/patient_entity.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/enums/invite_enum.dart';
import '../entitys/invite_entity.dart';

class InviteFactory {
  // Create new invite with auto-generated fields
  static InviteEntity createNew({
    required String patientId,
    required String doctorId,
    required PatientEntity patient,
    required DoctorEntity doctor,
    InviteStatus status = InviteStatus.pending,
  }) {
    final now = DateTime.now();
    return InviteEntity(
      inviteId: const Uuid().v4(),
      patientId: patientId,
      doctorId: doctorId,
      patient: patient,
      doctor: doctor,
      status: status,
      createdAt: now,
      updatedAt: now,
    );
  }

  // Convert from JSON
  static InviteEntity fromJson(Map<String, dynamic> json) {
    return InviteEntity(
      inviteId: const Uuid().v4(),
      patientId: json['patientId'] as String,
      doctorId: json['doctorId'] as String,
      patient: PatientEntity.fromJson(json['patient'] as Map<String, dynamic>),
      doctor: DoctorEntity.fromJson(json['doctor'] as Map<String, dynamic>),
      status: InviteStatus.fromJson(json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // Convert to JSON
  static Map<String, dynamic> toJson(InviteEntity invite) {
    return {
      'inviteId': invite.inviteId,
      'patientId': invite.patientId,
      'doctorId': invite.doctorId,
      'patient': invite.patient.toJson(),
      'doctor': invite.doctor.toJson(),
      'status': invite.status.toString(),
      'createdAt': invite.createdAt.toIso8601String(),
      'updatedAt': invite.updatedAt.toIso8601String(),
    };
  }

  // Update existing invite
  static InviteEntity update({
    required InviteEntity existing,
    InviteStatus? status,
    PatientEntity? patient,
    DoctorEntity? doctor,
  }) {
    return InviteEntity(
      inviteId: existing.inviteId,
      patientId: existing.patientId,
      doctorId: existing.doctorId,
      patient: patient ?? existing.patient,
      doctor: doctor ?? existing.doctor,
      status: status ?? existing.status,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
