import '../../repository/appointement_repository.dart';

class GetDoctorAppointementsUsecase {
  final AppointmentRepository _appointmentRepository;

  GetDoctorAppointementsUsecase(this._appointmentRepository);

  Future<void> call() async {
    await _appointmentRepository.fetchAppointementsForDoctor();
  }
}
