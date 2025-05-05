import '../../repository/appointement_repository.dart';

class DeleteAppointementUsecase {
  final AppointmentRepository _appointmentRepository;

  DeleteAppointementUsecase(this._appointmentRepository);

  Future<void> call(String appointmentId) async {
    await _appointmentRepository.deleteAppointement(appointmentId);
  }
}
