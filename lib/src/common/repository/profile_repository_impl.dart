import 'package:autis/core/errors/failures.dart';
import 'package:autis/core/params/profile/update_user_params.dart';
import 'package:autis/core/types/either.dart';
import 'package:autis/src/common/data/profile_remote_data_sources.dart';
import 'package:autis/src/common/entitys/user_entity.dart';
import 'package:autis/src/common/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  ProfileRepositoryImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, UserEntity>> getUserProfile(String uid) {
    return _remoteDataSource.getProfile(uid);
  }

  @override
  Future<Either<Failure, void>> updateUserProfile(UpdateUserProfile user) {
    return _remoteDataSource.update(user);
  }

  @override
  Future<Either<Failure, void>> createUserProfile(UserEntity user) {
    // TODO: implement createUserProfile
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteUserProfile(String uid) {
    return _remoteDataSource.delete(uid);
  }
}
