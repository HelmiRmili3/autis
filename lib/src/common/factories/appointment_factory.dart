import 'package:autis/src/doctor/domain/entities/doctor_entity.dart';
import 'package:autis/src/patient/domain/entities/patient_entity.dart';
import 'package:uuid/uuid.dart';
import '../entitys/appointement_entity.dart';

class AppointmentFactory {
  final String appointmentId;
  final String doctorId;
  final String patientId;
  final DoctorEntity doctor;
  final PatientEntity patient;
  final DateTime appointmentDate;
  final String? location;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Private constructor for internal use
  AppointmentFactory._({
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

  // Factory for creating new appointments (auto-generates ID and timestamps)
  factory AppointmentFactory.createNew({
    required String doctorId,
    required String patientId,
    required DoctorEntity doctor,
    required PatientEntity patient,
    required DateTime appointmentDate,
    String? location,
  }) {
    final now = DateTime.now();
    return AppointmentFactory._(
      appointmentId: const Uuid().v4(), // Auto-generate ID
      doctorId: doctorId,
      patientId: patientId,
      doctor: doctor,
      patient: patient,
      appointmentDate: appointmentDate,
      location: location,
      createdAt: now, // Set creation time
      updatedAt: now, // Set initial update time
    );
  }

  // Factory from JSON (for existing appointments)
  factory AppointmentFactory.fromJson(Map<String, dynamic> json) {
    return AppointmentFactory._(
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

  // Factory from Entity (for existing appointments)
  factory AppointmentFactory.fromEntity(AppointmentEntity entity) {
    return AppointmentFactory._(
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

  // Update timestamp when modifying
  AppointmentFactory copyWith({
    String? appointmentId,
    String? doctorId,
    String? patientId,
    DoctorEntity? doctor,
    PatientEntity? patient,
    DateTime? appointmentDate,
    String? location,
  }) {
    return AppointmentFactory._(
      appointmentId: appointmentId ?? this.appointmentId,
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      doctor: doctor ?? this.doctor,
      patient: patient ?? this.patient,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      location: location ?? this.location,
      createdAt: createdAt, // Preserve original creation time
      updatedAt: DateTime.now(), // Update timestamp on modification
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
}
