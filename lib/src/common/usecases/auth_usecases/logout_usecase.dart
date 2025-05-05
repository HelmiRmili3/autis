import '../../../../core/errors/failures.dart';
import '../../../../core/types/either.dart';
import '../../repository/auth_repository.dart';

class LogoutUsecase {
  // This class is responsible for handling the logout functionality.
  // It will interact with the authentication repository to perform the logout operation.
  final AuthRepository _authRepository;
  LogoutUsecase(this._authRepository);
  Future<Either<Failure, void>> call() async {
    return await _authRepository.logout();
  }
}
