import '../../../../core/params/appointment/create_appointment_params.dart';
import '../../repository/appointement_repository.dart';

class CreateAppointementUsecase {
  final AppointmentRepository _appointmentRepository;

  CreateAppointementUsecase(this._appointmentRepository);

  Future<void> call(CreateAppointmentParams appointment) async {
    await _appointmentRepository.createAppointement(appointment);
  }
}
