import '../../repository/appointement_repository.dart';

class GetPatientAppointementsUsecase {
  final AppointmentRepository _appointmentRepository;

  GetPatientAppointementsUsecase(this._appointmentRepository);

  Future<void> call() async {
    await _appointmentRepository.fetchAppointementByPatientId();
  }
}
