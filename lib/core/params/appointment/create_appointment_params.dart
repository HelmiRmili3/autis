import '../../../src/doctor/domain/entities/doctor_entity.dart';
import '../../../src/patient/domain/entities/patient_entity.dart';

class CreateAppointmentParams {
  final String doctorId;
  final String patientId;
  final DoctorEntity doctor;
  final PatientEntity patient;
  final DateTime appointmentDate;
  final String? location;

  CreateAppointmentParams({
    required this.doctorId,
    required this.patientId,
    required this.doctor,
    required this.patient,
    required this.appointmentDate,
    this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'patientId': patientId,
      'doctor': doctor.toJson(),
      'patient': patient.toJson(),
      'appointmentDate': appointmentDate.toIso8601String(),
      if (location != null) 'location': location,
    };
  }

  @override
  String toString() {
    return 'CreateAppointmentParams('
        'doctorId: $doctorId, '
        'patientId: $patientId, '
        'doctor: ${doctor.toString()}, '
        'patient: ${patient.toString()}, '
        'appointmentDate: $appointmentDate, '
        'location: $location)';
  }
}
