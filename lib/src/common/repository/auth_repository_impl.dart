import 'package:autis/core/errors/failures.dart';
import 'package:autis/core/params/authentication/create_user_params.dart';
import 'package:autis/core/params/authentication/login_user_params.dart';
import 'package:autis/core/types/either.dart';
import 'package:autis/src/common/entitys/user_entity.dart';
import 'package:autis/src/common/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/auth_remote_data_sources.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  AuthRepositoryImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, UserEntity>> getUser() {
    return _remoteDataSource.getUserProfile();
  }

  @override
  Future<Either<Failure, void>> login(Loginuserprams userEntity) {
    return _remoteDataSource.login(userEntity);
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithGoogle() {
    // TODO: implement loginWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> create(CreateUserParams user) {
    return _remoteDataSource.create(user);
  }

  @override
  Future<Either<Failure, UserCredential>> register(Loginuserprams userEntity) {
    return _remoteDataSource.register(userEntity);
  }

  @override
  Future<Either<Failure, void>> logout() {
    return _remoteDataSource.logout();
  }
}
