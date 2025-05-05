import 'package:autis/src/doctor/domain/entities/doctor_entity.dart';

abstract class DoctorState {}

class DoctorInitial extends DoctorState {}

class DoctorLoading extends DoctorState {}

class DoctorsLoaded extends DoctorState {
  final List<DoctorEntity> doctors;
  DoctorsLoaded(this.doctors);
}

class DoctorLoaded extends DoctorState {
  final DoctorEntity doctor;
  DoctorLoaded(this.doctor);
}

class DoctorDeleted extends DoctorState {
  final String message;
  DoctorDeleted(this.message);
}

class DoctorUpdated extends DoctorState {
  final String message;
  DoctorUpdated(this.message);
}

class DoctorVerified extends DoctorState {
  final String message;
  DoctorVerified(this.message);
}

class DoctorError extends DoctorState {
  final String error;
  DoctorError(this.error);
}
