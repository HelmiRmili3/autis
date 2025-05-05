import '../../../../core/errors/failures.dart';
import '../../../../core/types/either.dart';

abstract class AdminRepository {
  Future<Either<Failure, void>> createAdmin(String id, bool isVerified);
}
