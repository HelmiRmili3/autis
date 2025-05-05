import 'package:autis/src/doctor/domain/entities/doctor_entity.dart';
import 'package:autis/src/patient/domain/entities/patient_entity.dart';
import 'package:equatable/equatable.dart';

import '../entitys/appointement_entity.dart';

class AppointmentModel extends Equatable {
  final String appointmentId;
  final String doctorId;
  final String patientId;
  final DoctorEntity doctor;
  final PatientEntity patient;
  final DateTime appointmentDate;
  final String? location;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AppointmentModel({
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    required this.doctor,
    required this.patient,
    required this.appointmentDate,
    this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      appointmentId: json['appointmentId'] as String,
      doctorId: json['doctorId'] as String,
      patientId: json['patientId'] as String,
      doctor: DoctorEntity.fromJson(json['doctor'] as Map<String, dynamic>),
      patient: PatientEntity.fromJson(json['patient'] as Map<String, dynamic>),
      appointmentDate: DateTime.parse(json['appointmentDate'] as String),
      location: json['location'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  factory AppointmentModel.fromEntity(AppointmentEntity entity) {
    return AppointmentModel(
      appointmentId: entity.appointmentId,
      doctorId: entity.doctorId,
      patientId: entity.patientId,
      doctor: entity.doctor,
      patient: entity.patient,
      appointmentDate: entity.appointmentDate,
      location: entity.location,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'doctorId': doctorId,
      'patientId': patientId,
      'doctor': doctor.toJson(),
      'patient': patient.toJson(),
      'appointmentDate': appointmentDate.toIso8601String(),
      'location': location,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  AppointmentEntity toEntity() {
    return AppointmentEntity(
      appointmentId: appointmentId,
      doctorId: doctorId,
      patientId: patientId,
      doctor: doctor,
      patient: patient,
      appointmentDate: appointmentDate,
      location: location,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  AppointmentModel copyWith({
    String? appointmentId,
    String? doctorId,
    String? patientId,
    DoctorEntity? doctor,
    PatientEntity? patient,
    DateTime? appointmentDate,
    String? location,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppointmentModel(
      appointmentId: appointmentId ?? this.appointmentId,
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      doctor: doctor ?? this.doctor,
      patient: patient ?? this.patient,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        appointmentId,
        doctorId,
        patientId,
        doctor,
        patient,
        appointmentDate,
        location,
        createdAt,
        updatedAt,
      ];
}
