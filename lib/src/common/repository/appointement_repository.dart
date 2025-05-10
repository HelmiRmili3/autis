import '../../../core/errors/failures.dart';
import '../../../core/params/appointment/create_appointment_params.dart';
import '../../../core/params/appointment/update_appointment_params.dart';
import '../../../core/types/either.dart';
import '../entitys/appointement_entity.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, List<AppointmentEntity>>> fetchAppointementsForDoctor(
      String patientId);
  Future<Either<Failure, List<AppointmentEntity>>>
      fetchAppointementByPatientId();

  Future<Either<Failure, List<AppointmentEntity>>> deleteAppointement(
      String appointementId);
  Future<Either<Failure, List<AppointmentEntity>>> createAppointement(
      CreateAppointmentParams appointement);
  Future<Either<Failure, List<AppointmentEntity>>> updateAppointement(
      UpdateAppointmentParams appointement);
}
