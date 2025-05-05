import 'package:autis/src/patient/domain/entities/patient_entity.dart';

abstract class DoctorRepository {
  DoctorRepository();

  // patient related methods

  List<PatientEntity> getAllPatient();
  PatientEntity getPatientById(String id);
  void acceptPatient(PatientEntity patient);
  void rejectPatient(PatientEntity patient);

// Report related methods

  List<PatientEntity> getAllReports();
  PatientEntity getReportById(String id);
  void createReport(PatientEntity report);
  void editReport(PatientEntity report);

// sessions related methods

  List<PatientEntity> getAllSessions();
  PatientEntity getSessionById(String id);
  List<PatientEntity> getSessionsByPatientId(String patientId);
  void createSession(PatientEntity session);
  void editSession(PatientEntity session);
}
