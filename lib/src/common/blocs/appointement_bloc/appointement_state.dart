import 'package:autis/src/common/entitys/appointement_entity.dart';

abstract class AppointmentState {}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentLoaded extends AppointmentState {
  final List<AppointmentEntity> appointments;
  AppointmentLoaded(this.appointments);
}

class AppointmentFailure extends AppointmentState {
  final String error;
  AppointmentFailure(this.error);
}
