import '../../../../core/errors/failures.dart';
import '../../../../core/types/either.dart';
import '../../repository/doctor_repository.dart';

class CheckVerifiedUsecase {
  final DoctorRepository _doctorRepository;

  CheckVerifiedUsecase(this._doctorRepository);

  Future<Either<Failure, bool>> call(String doctorId) async {
    return await _doctorRepository.checkDoctorVerified(doctorId);
  }
}
