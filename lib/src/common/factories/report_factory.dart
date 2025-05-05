import 'package:autis/src/doctor/domain/entities/doctor_entity.dart';
import 'package:autis/src/patient/domain/entities/patient_entity.dart';
import 'package:uuid/uuid.dart';
import '../entitys/report_entity.dart';

class ReportFactory {
  final String reportId;
  final String patientId;
  final String doctorId;
  final PatientEntity patient;
  final DoctorEntity doctor;
  final String reportDetails;
  final String? attachmentUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Private constructor for internal use
  ReportFactory._({
    required this.reportId,
    required this.patientId,
    required this.doctorId,
    required this.patient,
    required this.doctor,
    required this.reportDetails,
    this.attachmentUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory for creating new reports (auto-generates ID and timestamps)
  factory ReportFactory.createNew({
    required String patientId,
    required String doctorId,
    required PatientEntity patient,
    required DoctorEntity doctor,
    required String reportDetails,
    String? attachmentUrl,
  }) {
    final now = DateTime.now();
    return ReportFactory._(
      reportId: const Uuid().v4(), // Auto-generate ID
      patientId: patientId,
      doctorId: doctorId,
      patient: patient,
      doctor: doctor,
      reportDetails: reportDetails,
      attachmentUrl: attachmentUrl,
      createdAt: now, // Set creation time
      updatedAt: now, // Set initial update time
    );
  }

  // Factory from JSON (for existing reports)
  factory ReportFactory.fromJson(Map<String, dynamic> json) {
    return ReportFactory._(
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

  // Factory from Entity (for existing reports)
  factory ReportFactory.fromEntity(ReportEntity entity) {
    return ReportFactory._(
      reportId: entity.reportId,
      patientId: entity.patientId,
      doctorId: entity.doctorId,
      patient: entity.patient,
      doctor: entity.doctor,
      reportDetails: entity.reportDetails,
      attachmentUrl: entity.attachmentUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Update timestamp when modifying
  ReportFactory copyWith({
    String? reportId,
    String? patientId,
    String? doctorId,
    PatientEntity? patient,
    DoctorEntity? doctor,
    String? reportDetails,
    String? attachmentUrl,
  }) {
    return ReportFactory._(
      reportId: reportId ?? this.reportId,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      patient: patient ?? this.patient,
      doctor: doctor ?? this.doctor,
      reportDetails: reportDetails ?? this.reportDetails,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      createdAt: createdAt, // Preserve original creation time
      updatedAt: DateTime.now(), // Update timestamp on modification
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

  ReportEntity toEntity() {
    return ReportEntity(
      reportId: reportId,
      patientId: patientId,
      doctorId: doctorId,
      patient: patient,
      doctor: doctor,
      reportDetails: reportDetails,
      attachmentUrl: attachmentUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
