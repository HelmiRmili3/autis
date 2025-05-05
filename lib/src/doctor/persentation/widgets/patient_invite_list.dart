import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/blocs/invite_bloc/invite_bloc.dart';
import '../../../common/blocs/invite_bloc/invite_event.dart';
import '../../../common/blocs/invite_bloc/invite_state.dart';
import 'patient_invite_card.dart';

class InviteList extends StatefulWidget {
  const InviteList({super.key});

  @override
  State<InviteList> createState() => _InviteListState();
}

class _InviteListState extends State<InviteList> {
  @override
  void initState() {
    super.initState();
    context.read<InviteBloc>().add(GetInvites());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InviteBloc, InviteState>(
      builder: (context, state) {
        if (state is InviteLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is InviteFailure) {
          return Center(
            child: Text(
              state.error,
              style: TextStyle(fontSize: 16.sp, color: Colors.red),
            ),
          );
        }

        if (state is InviteLoaded) {
          final invites = state.invites;
          if (invites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mail_outline,
                    size: 64.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'You have no invites right now!',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Check back later or refresh to see if any new invites arrive.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 100.h),
            itemCount: invites.length,
            itemBuilder: (context, index) {
              final invite = invites[index];
              return InviteCard(
                invite: invite,
                onAccept: () => _handleAccept(context, invite.inviteId),
                onReject: () => _handleReject(context, invite.inviteId),
              );
            },
          );
        }

        return const SizedBox.shrink(); // Default fallback
      },
    );
  }

  void _handleAccept(BuildContext context, String inviteId) {
    context.read<InviteBloc>().add(AcceptInvite(inviteId: inviteId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invite accepted')),
    );
  }

  void _handleReject(BuildContext context, String inviteId) {
    context.read<InviteBloc>().add(RejectInvite(inviteId: inviteId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invite rejected')),
    );
  }
}
