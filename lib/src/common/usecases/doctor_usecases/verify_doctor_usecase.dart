import '../../../../core/errors/failures.dart';
import '../../../../core/types/either.dart';
import '../../repository/doctor_repository.dart';

class VerifyDoctorUsecase {
  final DoctorRepository _doctorRepository;

  VerifyDoctorUsecase(this._doctorRepository);

  Future<Either<Failure, void>> call(
    String doctorId,
    bool isVerified,
  ) async {
    return await _doctorRepository.verifyDoctor(
      doctorId,
      isVerified,
    );
  }
}
