import 'package:autis/src/doctor/domain/repositories/doctor_repository.dart';
import 'package:autis/src/patient/domain/entities/patient_entity.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  @override
  void acceptPatient(PatientEntity patient) {
    // TODO: implement acceptPatient
  }

  @override
  void createReport(PatientEntity report) {
    // TODO: implement createReport
  }

  @override
  void createSession(PatientEntity session) {
    // TODO: implement createSession
  }

  @override
  void editReport(PatientEntity report) {
    // TODO: implement editReport
  }

  @override
  void editSession(PatientEntity session) {
    // TODO: implement editSession
  }

  @override
  List<PatientEntity> getAllPatient() {
    // TODO: implement getAllPatient
    throw UnimplementedError();
  }

  @override
  List<PatientEntity> getAllReports() {
    // TODO: implement getAllReports
    throw UnimplementedError();
  }

  @override
  List<PatientEntity> getAllSessions() {
    // TODO: implement getAllSessions
    throw UnimplementedError();
  }

  @override
  PatientEntity getPatientById(String id) {
    // TODO: implement getPatientById
    throw UnimplementedError();
  }

  @override
  PatientEntity getReportById(String id) {
    // TODO: implement getReportById
    throw UnimplementedError();
  }

  @override
  PatientEntity getSessionById(String id) {
    // TODO: implement getSessionById
    throw UnimplementedError();
  }

  @override
  List<PatientEntity> getSessionsByPatientId(String patientId) {
    // TODO: implement getSessionsByPatientId
    throw UnimplementedError();
  }

  @override
  void rejectPatient(PatientEntity patient) {
    // TODO: implement rejectPatient
  }
}
