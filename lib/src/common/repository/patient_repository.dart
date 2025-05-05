import 'package:autis/core/params/patient/update_patient_params.dart';

import '../../../core/errors/failures.dart';
import '../../../core/types/either.dart';
import '../../patient/domain/entities/patient_entity.dart';
import '../entitys/video.dart';

abstract class PatientRepository {
  Future<Either<Failure, List<PatientEntity>>> getPatients();
  Future<Either<Failure, List<PatientEntity>>> getPatientsByDoctor(
      String doctorId);
  Future<Either<Failure, void>> update(UpdatePatientParams patient);
  Future<Either<Failure, List<PatientEntity>>> delete(String patientId);
  Future<Either<Failure, List<Video>>> getVediosByPatient(String id);
  Future<Either<Failure, List<Video>>> addVediosByPatient(Video vedio);
  Future<Either<Failure, List<Video>>> deleteVediosByPatient(String id);
}
