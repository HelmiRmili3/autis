import '../../../patient/domain/entities/patient_entity.dart';
import '../../entitys/video.dart';

abstract class PatientState {}

class PatientInitial extends PatientState {}

class PatientLoading extends PatientState {}

class PatientsLoaded extends PatientState {
  final List<PatientEntity> patients;
  PatientsLoaded(this.patients);
}

class PatientDeleted extends PatientState {}

class VediosLoaded extends PatientState {
  final List<Video> vedios;
  VediosLoaded(this.vedios);
}

class PatientFailure extends PatientState {
  final String error;
  PatientFailure(this.error);
}

class VedioFailure extends PatientState {
  final String error;
  VedioFailure(this.error);
}
