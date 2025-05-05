import 'package:autis/src/doctor/domain/entities/doctor_entity.dart';
import 'package:autis/src/patient/domain/entities/patient_entity.dart';

import '../../../core/utils/enums/invite_enum.dart';

class InviteEntity {
  final String inviteId;
  final String patientId;
  final String doctorId;
  final PatientEntity patient;
  final DoctorEntity doctor;
  final InviteStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const InviteEntity({
    required this.inviteId,
    required this.patientId,
    required this.doctorId,
    required this.patient,
    required this.doctor,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to JSON for Firestore/API
  Map<String, dynamic> toJson() {
    return {
      'inviteId': inviteId,
      'patientId': patientId,
      'doctorId': doctorId,
      'patient': patient.toJson(),
      'doctor': doctor.toJson(),
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from JSON (Firestore/API response)
  factory InviteEntity.fromJson(Map<String, dynamic> json) {
    return InviteEntity(
      inviteId: json['inviteId'] as String,
      patientId: json['patientId'] as String,
      doctorId: json['doctorId'] as String,
      patient: PatientEntity.fromJson(json['patient'] as Map<String, dynamic>),
      doctor: DoctorEntity.fromJson(json['doctor'] as Map<String, dynamic>),
      status: InviteStatus.values.firstWhere(
        (e) => e.toString() == 'InviteStatus.${json['status']}',
        orElse: () => InviteStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // Create a copy with updated fields
  InviteEntity copyWith({
    String? inviteId,
    String? patientId,
    String? doctorId,
    PatientEntity? patient,
    DoctorEntity? doctor,
    InviteStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InviteEntity(
      inviteId: inviteId ?? this.inviteId,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      patient: patient ?? this.patient,
      doctor: doctor ?? this.doctor,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'InviteEntity('
        'inviteId: $inviteId, '
        'patientId: $patientId, '
        'doctorId: $doctorId, '
        'status: $status, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt)';
  }
}
