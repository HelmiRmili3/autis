import 'package:autis/src/common/entitys/invite_entity.dart';

abstract class InviteState {}

class InviteInitial extends InviteState {}

class InviteLoading extends InviteState {}

class InviteLoaded extends InviteState {
  final List<InviteEntity> invites;
  InviteLoaded(this.invites);
}

// patient invite
class InviteAccepted extends InviteState {
  final InviteEntity invite;
  InviteAccepted(this.invite);
}

class InviteRejected extends InviteState {
  final InviteEntity invite;
  InviteRejected(this.invite);
}

class InvitePending extends InviteState {
  final InviteEntity invite;
  InvitePending(this.invite);
}

class InviteFailure extends InviteState {
  final String error;
  InviteFailure(this.error);
}
