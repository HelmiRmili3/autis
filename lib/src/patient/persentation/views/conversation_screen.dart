import 'package:autis/core/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/notification_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/utils/enums/notification_enum.dart';
import '../../../../injection_container.dart';

import '../../../common/blocs/invite_bloc/invite_bloc.dart';
import '../../../common/blocs/invite_bloc/invite_event.dart';
import '../../../common/blocs/invite_bloc/invite_state.dart';
import '../../../common/view/container_screen.dart';
import '../../domain/entities/patient_entity.dart';
import '../widgets/conversation_card.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  late PatientEntity? currentUser;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await sl<UserProfileStorage>().getUserProfile();

    setState(() {
      currentUser = user != null
          ? PatientEntity(
              uid: user.uid,
              email: user.email,
              firstname: user.firstname,
              lastname: user.lastname,
              avatarUrl: user.avatarUrl,
              gender: user.gender,
              createdAt: user.createdAt,
              updatedAt: user.updatedAt,
              phone: user.phone,
            )
          : null;
      _isInitialized = true;
    });

    if (currentUser != null) {
      sl<InviteBloc>().add(CheckInviteStatus(patientId: currentUser!.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return BlocListener<InviteBloc, InviteState>(
      listener: (context, state) {
        if (state is InviteFailure) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            sl<NotificationService>().showCustomManualDismissNotification(
              context: context,
              message: "You need to select doctor to send Invitation",
              type: NotificationType.warning,
            );
          });
        }
        if (state is InvitePending) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            sl<NotificationService>().showCustomManualDismissNotification(
              context: context,
              message: "Your invitation is pending approval",
              type: NotificationType.warning,
            );
          });
        }
        if (state is InviteRejected) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            sl<NotificationService>().showCustomManualDismissNotification(
              context: context,
              message: "Your invitation was rejected",
              type: NotificationType.error,
            );
          });
        }
      },
      child: ContainerScreen(
        title: Strings.chats,
        imagePath: 'assets/images/homebg.png',
        leadingicon: Icons.arrow_back_ios_new_rounded,
        onLeadingPress: () {
          Navigator.pop(context);
        },
        children: [
          BlocBuilder<InviteBloc, InviteState>(
            builder: (context, state) {
              if (state is InviteAccepted) {
                return ConversationCard(
                  currentUser: currentUser!,
                  doctor: state.invite.doctor,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
