import '../../../core/errors/failures.dart';
import '../../../core/params/appointment/create_appointment_params.dart';
import '../../../core/params/appointment/update_appointment_params.dart';
import '../../../core/types/either.dart';
import '../entitys/appointement_entity.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, List<AppointmentEntity>>>
      fetchAppointementsForDoctor();
  Future<Either<Failure, List<AppointmentEntity>>>
      fetchAppointementByPatientId();

  Future<Either<Failure, void>> deleteAppointement(String appointementId);
  Future<Either<Failure, void>> createAppointement(
      CreateAppointmentParams appointement);
  Future<Either<Failure, void>> updateAppointement(
      UpdateAppointmentParams appointement);
}
