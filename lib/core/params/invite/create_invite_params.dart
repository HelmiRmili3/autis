import '../../../src/doctor/domain/entities/doctor_entity.dart';
import '../../../src/patient/domain/entities/patient_entity.dart';

class CreateInviteParams {
  final String patientId;
  final String doctorId;
  final PatientEntity patient;
  final DoctorEntity doctor;
  const CreateInviteParams({
    required this.patientId,
    required this.doctorId,
    required this.patient,
    required this.doctor,
  });
  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'patient': patient.toJson(),
      'doctor': doctor.toJson(),
    };
  }
}
