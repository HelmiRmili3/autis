import 'package:autis/src/doctor/domain/entities/doctor_entity.dart';
import 'package:autis/src/patient/domain/entities/patient_entity.dart';

class ReportEntity {
  final String reportId;
  final String patientId;
  final String doctorId;
  final PatientEntity patient;
  final DoctorEntity doctor;
  final String reportDetails;
  final String? attachmentUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReportEntity({
    required this.reportId,
    required this.patientId,
    required this.doctorId,
    required this.patient,
    required this.doctor,
    required this.reportDetails,
    required this.createdAt,
    required this.updatedAt,
    this.attachmentUrl,
  });

  factory ReportEntity.fromJson(Map<String, dynamic> json) {
    return ReportEntity(
      reportId: json['reportId'] as String,
      patientId: json['patientId'] as String,
      doctorId: json['doctorId'] as String,
      patient: PatientEntity.fromJson(json['patient'] as Map<String, dynamic>),
      doctor: DoctorEntity.fromJson(json['doctor'] as Map<String, dynamic>),
      reportDetails: json['reportDetails'] as String,
      attachmentUrl: json['attachmentUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reportId': reportId,
      'patientId': patientId,
      'doctorId': doctorId,
      'patient': patient.toJson(),
      'doctor': doctor.toJson(),
      'reportDetails': reportDetails,
      'attachmentUrl': attachmentUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
