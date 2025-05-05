import 'package:autis/core/errors/failures.dart';
import 'package:autis/core/params/invite/create_invite_params.dart';
import 'package:autis/core/types/either.dart';
import 'package:autis/src/common/data/invite_remote_data_sources.dart';
import 'package:autis/src/common/entitys/invite_entity.dart';
import 'package:autis/src/common/repository/invite_repository.dart';

class InviteRepositoryImpl implements InviteRepository {
  final InviteRemoteDataSources inviteRemoteDataSources;
  InviteRepositoryImpl(
    this.inviteRemoteDataSources,
  );
  @override
  Future<Either<Failure, void>> acceptInvite(String code) {
    return inviteRemoteDataSources.acceptInvite(code);
  }

  @override
  Future<Either<Failure, void>> deleteInvite(String inviteId) {
    return inviteRemoteDataSources.deleteInvite(inviteId);
  }

  @override
  Future<Either<Failure, void>> rejectInvite(String inviteId) {
    return inviteRemoteDataSources.rejectInvite(inviteId);
  }

  @override
  Future<Either<Failure, List<InviteEntity>>> fetchInvites(String doctorId) {
    return inviteRemoteDataSources.fetchInvites(doctorId);
  }

  @override
  Future<Either<Failure, void>> sendInvite(CreateInviteParams invite) {
    return inviteRemoteDataSources.sendInvite(invite);
  }

  @override
  Future<Either<Failure, InviteEntity>> checkInviteStatus(String patientId) {
    return inviteRemoteDataSources.checkInviteStatus(patientId);
  }
}
