import 'package:autis/core/params/invite/create_invite_params.dart';
import 'package:autis/src/common/repository/invite_repository.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/types/either.dart';

class SendInviteUsecase {
  final InviteRepository _inviteRepository;
  SendInviteUsecase(this._inviteRepository);
  Future<Either<Failure, void>> call(CreateInviteParams params) async {
    return await _inviteRepository.sendInvite(params);
  }
}
