import 'package:autis/core/params/authentication/create_user_params.dart';
import 'package:autis/core/params/authentication/login_user_params.dart';
import 'package:autis/core/types/either.dart';
import 'package:autis/src/common/entitys/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> login(Loginuserprams user);
  Future<Either<Failure, UserEntity>> loginWithGoogle();
  Future<Either<Failure, UserCredential>> register(Loginuserprams user);
  Future<Either<Failure, UserEntity>> create(CreateUserParams user);
  Future<Either<Failure, UserEntity>> getUser();
  Future<Either<Failure, void>> logout();
}
