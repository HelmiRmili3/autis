import 'package:autis/core/params/invite/create_invite_params.dart';

abstract class InviteEvent {}

// patient use only
class SendInvite extends InviteEvent {
  final CreateInviteParams invite;
  SendInvite(this.invite);
}

class CheckInviteStatus extends InviteEvent {
  final String patientId;
  CheckInviteStatus({required this.patientId});
}

// doctor use only
class AcceptInvite extends InviteEvent {
  final String inviteId;
  AcceptInvite({required this.inviteId});
}

class RejectInvite extends InviteEvent {
  final String inviteId;
  RejectInvite({required this.inviteId});
}

class GetInvites extends InviteEvent {}
