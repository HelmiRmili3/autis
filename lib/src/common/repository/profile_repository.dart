import 'package:autis/core/errors/failures.dart';

import '../../../core/params/profile/update_user_params.dart';
import '../../../core/types/either.dart';
import '../entitys/user_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserEntity>> getUserProfile(String uid);
  Future<Either<Failure, void>> createUserProfile(UserEntity user);
  Future<Either<Failure, void>> updateUserProfile(UpdateUserProfile user);
  Future<Either<Failure, void>> deleteUserProfile(String uid);
}
