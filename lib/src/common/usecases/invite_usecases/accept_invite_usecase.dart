import 'package:autis/src/common/repository/invite_repository.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/types/either.dart';

class AcceptInviteUsecase {
  final InviteRepository _inviteRepository;
  AcceptInviteUsecase(this._inviteRepository);
  Future<Either<Failure, void>> call(String params) async {
    return await _inviteRepository.acceptInvite(params);
  }
}
