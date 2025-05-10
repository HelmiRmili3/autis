import 'package:autis/core/params/appointment/create_appointment_params.dart';

import '../../../../core/params/appointment/update_appointment_params.dart';

abstract class AppointmentEvent {}

class CreatedAppointement extends AppointmentEvent {
  final CreateAppointmentParams appointement;
  CreatedAppointement(this.appointement);
}

class UpdatedAppointement extends AppointmentEvent {
  final UpdateAppointmentParams appointement;
  UpdatedAppointement(this.appointement);
}

class DeletedAppointement extends AppointmentEvent {
  final String appointementId;
  DeletedAppointement(this.appointementId);
}

class GetDoctorAppointements extends AppointmentEvent {
  final String patientId;

  GetDoctorAppointements(this.patientId);
}

class GetPatientAppointements extends AppointmentEvent {}
