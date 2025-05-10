import 'package:autis/core/errors/failures.dart';
import 'package:autis/src/doctor/domain/entities/doctor_entity.dart';

import '../../../core/types/either.dart';
import '../../doctor/domain/entities/update_doctor_params.dart';

abstract class DoctorRepository {
  Future<Either<Failure, List<DoctorEntity>>> fetchAllDoctors();
  Future<Either<Failure, List<DoctorEntity>>> fetchVerifiedDoctors();
  Future<Either<Failure, List<DoctorEntity>>> fetchUnVerifiedDoctors();
  Future<Either<Failure, DoctorEntity>> fetchDoctorById(String doctorId);
  Future<Either<Failure, void>> verifyDoctor(String id, bool isVerified);
  Future<Either<Failure, void>> deleteDoctor(String doctorId);
  Future<Either<Failure, DoctorEntity>> updateDoctor(UpdateDoctorParams doctor);
  Future<Either<Failure, bool>> checkDoctorVerified(String doctor);
}
