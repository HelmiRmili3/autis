import '../../../../core/params/appointment/update_appointment_params.dart';
import '../../repository/appointement_repository.dart';

class UpdateAppointementUsecase {
  final AppointmentRepository _appointmentRepository;

  UpdateAppointementUsecase(this._appointmentRepository);

  Future<void> call(UpdateAppointmentParams appointment) async {
    await _appointmentRepository.updateAppointement(appointment);
  }
}
