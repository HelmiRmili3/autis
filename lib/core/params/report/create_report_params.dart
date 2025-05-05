import '../../../src/doctor/domain/entities/doctor_entity.dart';
import '../../../src/patient/domain/entities/patient_entity.dart';

class CreateReportParams {
  final String patientId;
  final String doctorId;
  final PatientEntity patient;
  final DoctorEntity doctor;
  final String reportDetails;
  final String? attachmentUrl;
  CreateReportParams(
    this.patientId,
    this.doctorId,
    this.patient,
    this.doctor,
    this.reportDetails,
    this.attachmentUrl,
  );
}
