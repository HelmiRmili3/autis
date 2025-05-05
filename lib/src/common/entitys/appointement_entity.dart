import 'package:autis/src/patient/domain/entities/patient_entity.dart';
import '../../doctor/domain/entities/doctor_entity.dart';

class AppointmentEntity {
  final String appointmentId;
  final String doctorId;
  final String patientId;
  final DoctorEntity doctor;
  final PatientEntity patient;
  final DateTime appointmentDate;
  final String? location;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppointmentEntity({
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

  factory AppointmentEntity.fromJson(Map<String, dynamic> json) {
    return AppointmentEntity(
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
}
