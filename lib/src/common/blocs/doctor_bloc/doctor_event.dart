import '../../../doctor/domain/entities/update_doctor_params.dart';

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
  final UpdateDoctorParams doctor;
  UpdateDoctor({required this.doctor});
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
