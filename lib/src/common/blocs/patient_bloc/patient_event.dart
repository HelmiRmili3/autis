import 'package:autis/core/params/patient/update_patient_params.dart';

abstract class PatientEvent {}

class GetPatients extends PatientEvent {
  GetPatients();
}

class GetPatientsByDoctor extends PatientEvent {}

class DeletePatient extends PatientEvent {
  final String patientId;
  DeletePatient({required this.patientId});
}

class UpdatePatient extends PatientEvent {
  final UpdatePatientParams patient;
  UpdatePatient({required this.patient});
}

class UploadVedio extends PatientEvent {
  final String patientId;
  final String title;
  final String thumbnail;
  final String videoUrl;
  final String duration;

  UploadVedio(
    this.patientId,
    this.title,
    this.thumbnail,
    this.videoUrl,
    this.duration,
  );
}

class DeleteVedio extends PatientEvent {
  final String id;
  DeleteVedio(
    this.id,
  );
}

class GetAllVedios extends PatientEvent {
  final String patientId;

  GetAllVedios(this.patientId);
}

class GetPatient extends PatientEvent {}
