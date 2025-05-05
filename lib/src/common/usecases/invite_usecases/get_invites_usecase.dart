import '../../../../core/errors/failures.dart';
import '../../../../core/types/either.dart';
import '../../repository/invite_repository.dart';

class GetInvitesUsecase {
  final InviteRepository _inviteRepository;
  GetInvitesUsecase(this._inviteRepository);
  Future<Either<Failure, void>> call(String doctorId) async {
    return await _inviteRepository.fetchInvites(doctorId);
  }
}
