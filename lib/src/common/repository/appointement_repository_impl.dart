import 'package:autis/core/errors/failures.dart';
import 'package:autis/core/params/appointment/create_appointment_params.dart';
import 'package:autis/core/types/either.dart';
import 'package:autis/src/common/repository/appointement_repository.dart';

import '../../../core/params/appointment/update_appointment_params.dart';
import '../data/appointement_remote_data_sources.dart';
import '../entitys/appointement_entity.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDataSource remoteDataSource;
  AppointmentRepositoryImpl(
    this.remoteDataSource,
  );
  @override
  Future<Either<Failure, void>> createAppointement(
      CreateAppointmentParams appointment) {
    return remoteDataSource.createAppointment(appointment);
  }

  @override
  Future<Either<Failure, void>> deleteAppointement(String appointementId) {
    return remoteDataSource.delete(appointementId);
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>>
      fetchAppointementByPatientId() {
    return remoteDataSource.getAppointmentsByPatient();
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>>
      fetchAppointementsForDoctor() {
    return remoteDataSource.getAppointmentsByDoctor();
  }

  @override
  Future<Either<Failure, void>> updateAppointement(
      UpdateAppointmentParams appointement) {
    return remoteDataSource.update(appointement);
  }
}
