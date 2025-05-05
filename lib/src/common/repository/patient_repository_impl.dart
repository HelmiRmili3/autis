import 'package:autis/core/errors/failures.dart';
import 'package:autis/core/params/patient/update_patient_params.dart';
import 'package:autis/core/types/either.dart';
import 'package:autis/src/common/data/patient_remote_data_sources.dart';
import 'package:autis/src/patient/domain/entities/patient_entity.dart';
import 'package:autis/src/common/repository/patient_repository.dart';

import '../entitys/video.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource remoteDataSource;
  PatientRepositoryImpl(
    this.remoteDataSource,
  );
  @override
  Future<Either<Failure, List<PatientEntity>>> getPatients() {
    return remoteDataSource.getPatients();
  }

  @override
  Future<Either<Failure, List<PatientEntity>>> getPatientsByDoctor(
      String doctorId) async {
    return remoteDataSource.getPatientsByDoctor(doctorId);
  }

  @override
  Future<Either<Failure, void>> update(UpdatePatientParams patient) async {
    return remoteDataSource.update(patient);
  }

  @override
  Future<Either<Failure, List<PatientEntity>>> delete(String patientId) async {
    return remoteDataSource.delete(patientId);
  }

  @override
  Future<Either<Failure, List<Video>>> addVediosByPatient(Video vedio) async {
    return remoteDataSource.addVediosByPatient(vedio);
  }

  @override
  Future<Either<Failure, List<Video>>> deleteVediosByPatient(String id) async {
    return remoteDataSource.deleteVediosByPatient(id);
  }

  @override
  Future<Either<Failure, List<Video>>> getVediosByPatient(String id) async {
    return remoteDataSource.getVediosByPatient(id);
  }
}
