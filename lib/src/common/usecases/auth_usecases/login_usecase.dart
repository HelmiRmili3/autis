import 'package:autis/core/params/authentication/login_user_params.dart';
import 'package:autis/core/types/either.dart';
import 'package:autis/src/common/repository/auth_repository.dart';

import '../../../../core/errors/failures.dart';

class LoginUsecase {
  final AuthRepository _authRepository;
  LoginUsecase(this._authRepository);
  Future<Either<Failure, void>> call(Loginuserprams params) async {
    return await _authRepository.login(params);
  }
}
