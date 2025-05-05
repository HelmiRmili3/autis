import 'package:autis/src/doctor/domain/entities/doctor_entity.dart';

abstract class DoctorEvent {}

// this event for patient
class FetchVerifiedDoctors extends DoctorEvent {}

// this event for admin
class FetchUnverifiedDoctors extends DoctorEvent {}

class FetchDoctor extends DoctorEvent {
  final String doctorId;
  FetchDoctor({required this.doctorId});
}

class UpdateDoctor extends DoctorEvent {
  final DoctorEntity doctorEntity;
  UpdateDoctor({required this.doctorEntity});
}

class VerifyDoctor extends DoctorEvent {
  final String id;
  final bool isVerified;
  VerifyDoctor({required this.id, required this.isVerified});
}

class DeleteDoctor extends DoctorEvent {
  final String doctorId;
  DeleteDoctor({required this.doctorId});
}
