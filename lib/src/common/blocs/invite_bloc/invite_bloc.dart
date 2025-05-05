import 'package:autis/core/services/secure_storage_service.dart';
import 'package:autis/core/utils/enums/invite_enum.dart';
import 'package:autis/src/common/blocs/invite_bloc/invite_event.dart';
import 'package:autis/src/common/blocs/invite_bloc/invite_state.dart';
import 'package:bloc/bloc.dart';

import '../../repository/invite_repository.dart';

class InviteBloc extends Bloc<InviteEvent, InviteState> {
  final InviteRepository inviteRepository;
  final UserProfileStorage user;

  InviteBloc(
    this.inviteRepository,
    this.user,
  ) : super(InviteInitial()) {
    on<SendInvite>(_onSendInvite);
    on<AcceptInvite>(_onAcceptInvite);
    on<RejectInvite>(_onRejectInvite);
    on<GetInvites>(_onGetInvites);
    on<CheckInviteStatus>(_onCheckInviteStatus);
  }

  Future<void> _onSendInvite(
      SendInvite event, Emitter<InviteState> emit) async {
    emit(InviteLoading());
    try {
      final response = await inviteRepository.sendInvite(event.invite);
      response.fold(
        (failure) {
          emit(InviteFailure(failure.message));
        },
        (_) {
          emit(InviteLoaded([])); // Update with actual data if needed
        },
      );
    } catch (e) {
      emit(InviteFailure("Error sending invite: $e"));
    }
  }

  Future<void> _onAcceptInvite(
      AcceptInvite event, Emitter<InviteState> emit) async {
    emit(InviteLoading());
    try {
      final response = await inviteRepository.acceptInvite(event.inviteId);
      response.fold(
        (failure) {
          emit(InviteFailure(failure.message));
        },
        (_) {
          emit(InviteLoaded([])); // Update with actual data if needed
        },
      );
    } catch (e) {
      emit(InviteFailure("Error accepting invite: $e"));
    }
  }

  Future<void> _onRejectInvite(
      RejectInvite event, Emitter<InviteState> emit) async {
    emit(InviteLoading());
    try {
      final response = await inviteRepository.rejectInvite(event.inviteId);
      response.fold(
        (failure) {
          emit(InviteFailure(failure.message));
        },
        (_) {
          emit(InviteLoaded([])); // Update with actual data if needed
        },
      );
    } catch (e) {
      emit(InviteFailure("Error rejecting invite: $e"));
    }
  }

  Future<void> _onGetInvites(
      GetInvites event, Emitter<InviteState> emit) async {
    emit(InviteLoading());
    try {
      final userData = await user.getUserProfile();
      final response = await inviteRepository.fetchInvites(userData!.uid);
      response.fold(
        (failure) {
          emit(InviteFailure(failure.message));
        },
        (invites) {
          emit(InviteLoaded(invites));
        },
      );
    } catch (e) {
      emit(InviteFailure("Error fetching invites : $e"));
    }
  }

  Future<void> _onCheckInviteStatus(
      CheckInviteStatus event, Emitter<InviteState> emit) async {
    emit(InviteLoading());
    try {
      final userData = await user.getUserProfile();
      final response = await inviteRepository.checkInviteStatus(userData!.uid);
      response.fold(
        (failure) {
          emit(InviteFailure(failure.message));
        },
        (invite) {
          if (invite.status == InviteStatus.accepted) {
            emit(InviteAccepted(invite));
          } else if (invite.status == InviteStatus.rejected) {
            emit(InviteRejected(invite));
          } else {
            emit(InvitePending(invite));
          }
        },
      );
    } catch (e) {
      emit(InviteFailure("Error fetching invite : $e"));
    }
  }
}
