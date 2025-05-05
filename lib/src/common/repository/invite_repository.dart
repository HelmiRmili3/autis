import 'package:autis/core/params/invite/create_invite_params.dart';

import '../../../core/errors/failures.dart';
import '../../../core/types/either.dart';
import '../entitys/invite_entity.dart';

abstract class InviteRepository {
  Future<Either<Failure, void>> sendInvite(CreateInviteParams invite);
  Future<Either<Failure, void>> acceptInvite(String inviteId);
  Future<Either<Failure, void>> rejectInvite(String inviteId);
  Future<Either<Failure, List<InviteEntity>>> fetchInvites(String doctorId);
  Future<Either<Failure, void>> deleteInvite(String code);
  Future<Either<Failure, InviteEntity>> checkInviteStatus(String patientId);
}
