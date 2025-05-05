import 'package:autis/core/errors/failures.dart';
import 'package:autis/core/types/either.dart';
import 'package:autis/src/admin/domain/repositories/admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  @override
  Future<Either<Failure, void>> createAdmin(String id, bool isVerified) {
    // TODO: implement createAdmin
    throw UnimplementedError();
  }
}
