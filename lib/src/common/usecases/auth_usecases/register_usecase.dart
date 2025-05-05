import 'package:autis/core/params/authentication/create_user_params.dart';
import 'package:autis/src/common/entitys/user_entity.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/types/either.dart';
import '../../repository/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository _authRepository;
  RegisterUsecase(this._authRepository);
  Future<Either<Failure, UserEntity>> call(CreateUserParams params) async {
    return await _authRepository.create(params);
  }
}
