import 'package:autis/src/common/repository/invite_repository.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/types/either.dart';

class RejectInviteUsecase {
  final InviteRepository _inviteRepository;
  RejectInviteUsecase(this._inviteRepository);
  Future<Either<Failure, void>> call(String params) async {
    return await _inviteRepository.acceptInvite(params);
  }
}
