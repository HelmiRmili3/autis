import 'package:autis/core/errors/failures.dart';
import 'package:autis/core/types/either.dart';
import 'package:autis/src/common/repository/doctor_repository.dart';

import '../../doctor/domain/entities/doctor_entity.dart';
import '../data/doctor_remote_data_sources.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorRemoteDataSource remoteDataSource;
  DoctorRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, void>> deleteDoctor(String doctorId) {
    return remoteDataSource.deleteDoctor(doctorId);
  }

  @override
  Future<Either<Failure, List<DoctorEntity>>> fetchAllDoctors() {
    return remoteDataSource.fetchAllDoctors();
  }

  @override
  Future<Either<Failure, DoctorEntity>> fetchDoctorById(String doctorId) {
    return remoteDataSource.fetchDoctorById(doctorId);
  }

  @override
  Future<Either<Failure, void>> verifyDoctor(String id, bool isVerified) {
    return remoteDataSource.verifyDoctor(id, isVerified);
  }

  @override
  Future<Either<Failure, void>> updateDoctor(DoctorEntity doctor) {
    return remoteDataSource.updateDoctor(doctor);
  }

  @override
  Future<Either<Failure, bool>> checkDoctorVerified(String doctorId) {
    return remoteDataSource.checkDoctorVerified(doctorId);
  }

  @override
  Future<Either<Failure, List<DoctorEntity>>> fetchVerifiedDoctors() {
    return remoteDataSource.fetchVerifiedDoctors();
  }

  @override
  Future<Either<Failure, List<DoctorEntity>>> fetchUnVerifiedDoctors() {
    return remoteDataSource.fetchUnVerifiedDoctors();
  }
}
